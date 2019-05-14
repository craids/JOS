
obj/user/ls.debug:     file format elf32-i386


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
  80002c:	e8 fa 02 00 00       	call   80032b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 10             	sub    $0x10,%esp
  800048:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004b:	8b 75 0c             	mov    0xc(%ebp),%esi
	const char *sep;

	if(flag['l'])
  80004e:	83 3d d0 51 80 00 00 	cmpl   $0x0,0x8051d0
  800055:	74 23                	je     80007a <ls1+0x3a>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800057:	89 f0                	mov    %esi,%eax
  800059:	3c 01                	cmp    $0x1,%al
  80005b:	19 c0                	sbb    %eax,%eax
  80005d:	83 e0 c9             	and    $0xffffffc9,%eax
  800060:	83 c0 64             	add    $0x64,%eax
  800063:	89 44 24 08          	mov    %eax,0x8(%esp)
  800067:	8b 45 10             	mov    0x10(%ebp),%eax
  80006a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006e:	c7 04 24 c2 2b 80 00 	movl   $0x802bc2,(%esp)
  800075:	e8 d5 1c 00 00       	call   801d4f <printf>
	if(prefix) {
  80007a:	85 db                	test   %ebx,%ebx
  80007c:	74 38                	je     8000b6 <ls1+0x76>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
			sep = "/";
		else
			sep = "";
  80007e:	b8 28 2c 80 00       	mov    $0x802c28,%eax
	const char *sep;

	if(flag['l'])
		printf("%11d %c ", size, isdir ? 'd' : '-');
	if(prefix) {
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800083:	80 3b 00             	cmpb   $0x0,(%ebx)
  800086:	74 1a                	je     8000a2 <ls1+0x62>
  800088:	89 1c 24             	mov    %ebx,(%esp)
  80008b:	e8 e0 09 00 00       	call   800a70 <strlen>
  800090:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
			sep = "/";
  800095:	b8 c0 2b 80 00       	mov    $0x802bc0,%eax
  80009a:	ba 28 2c 80 00       	mov    $0x802c28,%edx
  80009f:	0f 44 c2             	cmove  %edx,%eax
		else
			sep = "";
		printf("%s%s", prefix, sep);
  8000a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000aa:	c7 04 24 cb 2b 80 00 	movl   $0x802bcb,(%esp)
  8000b1:	e8 99 1c 00 00       	call   801d4f <printf>
	}
	printf("%s", name);
  8000b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8000b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bd:	c7 04 24 61 30 80 00 	movl   $0x803061,(%esp)
  8000c4:	e8 86 1c 00 00       	call   801d4f <printf>
	if(flag['F'] && isdir)
  8000c9:	83 3d 38 51 80 00 00 	cmpl   $0x0,0x805138
  8000d0:	74 12                	je     8000e4 <ls1+0xa4>
  8000d2:	89 f0                	mov    %esi,%eax
  8000d4:	84 c0                	test   %al,%al
  8000d6:	74 0c                	je     8000e4 <ls1+0xa4>
		printf("/");
  8000d8:	c7 04 24 c0 2b 80 00 	movl   $0x802bc0,(%esp)
  8000df:	e8 6b 1c 00 00       	call   801d4f <printf>
	printf("\n");
  8000e4:	c7 04 24 27 2c 80 00 	movl   $0x802c27,(%esp)
  8000eb:	e8 5f 1c 00 00       	call   801d4f <printf>
}
  8000f0:	83 c4 10             	add    $0x10,%esp
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5d                   	pop    %ebp
  8000f6:	c3                   	ret    

008000f7 <lsdir>:
		ls1(0, st.st_isdir, st.st_size, path);
}

void
lsdir(const char *path, const char *prefix)
{
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	57                   	push   %edi
  8000fb:	56                   	push   %esi
  8000fc:	53                   	push   %ebx
  8000fd:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  800103:	8b 7d 08             	mov    0x8(%ebp),%edi
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800106:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80010d:	00 
  80010e:	89 3c 24             	mov    %edi,(%esp)
  800111:	e8 89 1a 00 00       	call   801b9f <open>
  800116:	89 c3                	mov    %eax,%ebx
  800118:	85 c0                	test   %eax,%eax
  80011a:	78 08                	js     800124 <lsdir+0x2d>
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80011c:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800122:	eb 57                	jmp    80017b <lsdir+0x84>
{
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
  800124:	89 44 24 10          	mov    %eax,0x10(%esp)
  800128:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80012c:	c7 44 24 08 d0 2b 80 	movl   $0x802bd0,0x8(%esp)
  800133:	00 
  800134:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  80013b:	00 
  80013c:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  800143:	e8 44 02 00 00       	call   80038c <_panic>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0])
  800148:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  80014f:	74 2a                	je     80017b <lsdir+0x84>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  800151:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800155:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80015b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80015f:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800166:	0f 94 c0             	sete   %al
  800169:	0f b6 c0             	movzbl %al,%eax
  80016c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800170:	8b 45 0c             	mov    0xc(%ebp),%eax
  800173:	89 04 24             	mov    %eax,(%esp)
  800176:	e8 c5 fe ff ff       	call   800040 <ls1>
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80017b:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  800182:	00 
  800183:	89 74 24 04          	mov    %esi,0x4(%esp)
  800187:	89 1c 24             	mov    %ebx,(%esp)
  80018a:	e8 6d 15 00 00       	call   8016fc <readn>
  80018f:	3d 00 01 00 00       	cmp    $0x100,%eax
  800194:	74 b2                	je     800148 <lsdir+0x51>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  800196:	85 c0                	test   %eax,%eax
  800198:	7e 20                	jle    8001ba <lsdir+0xc3>
		panic("short read in directory %s", path);
  80019a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80019e:	c7 44 24 08 e6 2b 80 	movl   $0x802be6,0x8(%esp)
  8001a5:	00 
  8001a6:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8001ad:	00 
  8001ae:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  8001b5:	e8 d2 01 00 00       	call   80038c <_panic>
	if (n < 0)
  8001ba:	85 c0                	test   %eax,%eax
  8001bc:	79 24                	jns    8001e2 <lsdir+0xeb>
		panic("error reading directory %s: %e", path, n);
  8001be:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001c2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8001c6:	c7 44 24 08 2c 2c 80 	movl   $0x802c2c,0x8(%esp)
  8001cd:	00 
  8001ce:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  8001d5:	00 
  8001d6:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  8001dd:	e8 aa 01 00 00       	call   80038c <_panic>
}
  8001e2:	81 c4 2c 01 00 00    	add    $0x12c,%esp
  8001e8:	5b                   	pop    %ebx
  8001e9:	5e                   	pop    %esi
  8001ea:	5f                   	pop    %edi
  8001eb:	5d                   	pop    %ebp
  8001ec:	c3                   	ret    

008001ed <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	53                   	push   %ebx
  8001f1:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  8001f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  8001fa:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  800200:	89 44 24 04          	mov    %eax,0x4(%esp)
  800204:	89 1c 24             	mov    %ebx,(%esp)
  800207:	e8 f4 16 00 00       	call   801900 <stat>
  80020c:	85 c0                	test   %eax,%eax
  80020e:	79 24                	jns    800234 <ls+0x47>
		panic("stat %s: %e", path, r);
  800210:	89 44 24 10          	mov    %eax,0x10(%esp)
  800214:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800218:	c7 44 24 08 01 2c 80 	movl   $0x802c01,0x8(%esp)
  80021f:	00 
  800220:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800227:	00 
  800228:	c7 04 24 dc 2b 80 00 	movl   $0x802bdc,(%esp)
  80022f:	e8 58 01 00 00       	call   80038c <_panic>
	if (st.st_isdir && !flag['d'])
  800234:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800237:	85 c0                	test   %eax,%eax
  800239:	74 1a                	je     800255 <ls+0x68>
  80023b:	83 3d b0 51 80 00 00 	cmpl   $0x0,0x8051b0
  800242:	75 11                	jne    800255 <ls+0x68>
		lsdir(path, prefix);
  800244:	8b 45 0c             	mov    0xc(%ebp),%eax
  800247:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024b:	89 1c 24             	mov    %ebx,(%esp)
  80024e:	e8 a4 fe ff ff       	call   8000f7 <lsdir>
  800253:	eb 23                	jmp    800278 <ls+0x8b>
	else
		ls1(0, st.st_isdir, st.st_size, path);
  800255:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800259:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80025c:	89 54 24 08          	mov    %edx,0x8(%esp)
  800260:	85 c0                	test   %eax,%eax
  800262:	0f 95 c0             	setne  %al
  800265:	0f b6 c0             	movzbl %al,%eax
  800268:	89 44 24 04          	mov    %eax,0x4(%esp)
  80026c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800273:	e8 c8 fd ff ff       	call   800040 <ls1>
}
  800278:	81 c4 b4 00 00 00    	add    $0xb4,%esp
  80027e:	5b                   	pop    %ebx
  80027f:	5d                   	pop    %ebp
  800280:	c3                   	ret    

00800281 <usage>:
	printf("\n");
}

void
usage(void)
{
  800281:	55                   	push   %ebp
  800282:	89 e5                	mov    %esp,%ebp
  800284:	83 ec 18             	sub    $0x18,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800287:	c7 04 24 0d 2c 80 00 	movl   $0x802c0d,(%esp)
  80028e:	e8 bc 1a 00 00       	call   801d4f <printf>
	exit();
  800293:	e8 db 00 00 00       	call   800373 <exit>
}
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <umain>:

void
umain(int argc, char **argv)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	56                   	push   %esi
  80029e:	53                   	push   %ebx
  80029f:	83 ec 20             	sub    $0x20,%esp
  8002a2:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
  8002a5:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8002a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002b0:	8d 45 08             	lea    0x8(%ebp),%eax
  8002b3:	89 04 24             	mov    %eax,(%esp)
  8002b6:	e8 46 0f 00 00       	call   801201 <argstart>
	while ((i = argnext(&args)) >= 0)
  8002bb:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  8002be:	eb 1e                	jmp    8002de <umain+0x44>
		switch (i) {
  8002c0:	83 f8 64             	cmp    $0x64,%eax
  8002c3:	74 0a                	je     8002cf <umain+0x35>
  8002c5:	83 f8 6c             	cmp    $0x6c,%eax
  8002c8:	74 05                	je     8002cf <umain+0x35>
  8002ca:	83 f8 46             	cmp    $0x46,%eax
  8002cd:	75 0a                	jne    8002d9 <umain+0x3f>
		case 'd':
		case 'F':
		case 'l':
			flag[i]++;
  8002cf:	83 04 85 20 50 80 00 	addl   $0x1,0x805020(,%eax,4)
  8002d6:	01 
			break;
  8002d7:	eb 05                	jmp    8002de <umain+0x44>
		default:
			usage();
  8002d9:	e8 a3 ff ff ff       	call   800281 <usage>
{
	int i;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  8002de:	89 1c 24             	mov    %ebx,(%esp)
  8002e1:	e8 53 0f 00 00       	call   801239 <argnext>
  8002e6:	85 c0                	test   %eax,%eax
  8002e8:	79 d6                	jns    8002c0 <umain+0x26>
			break;
		default:
			usage();
		}

	if (argc == 1)
  8002ea:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8002ee:	74 07                	je     8002f7 <umain+0x5d>
  8002f0:	bb 01 00 00 00       	mov    $0x1,%ebx
  8002f5:	eb 28                	jmp    80031f <umain+0x85>
		ls("/", "");
  8002f7:	c7 44 24 04 28 2c 80 	movl   $0x802c28,0x4(%esp)
  8002fe:	00 
  8002ff:	c7 04 24 c0 2b 80 00 	movl   $0x802bc0,(%esp)
  800306:	e8 e2 fe ff ff       	call   8001ed <ls>
  80030b:	eb 17                	jmp    800324 <umain+0x8a>
	else {
		for (i = 1; i < argc; i++)
			ls(argv[i], argv[i]);
  80030d:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  800310:	89 44 24 04          	mov    %eax,0x4(%esp)
  800314:	89 04 24             	mov    %eax,(%esp)
  800317:	e8 d1 fe ff ff       	call   8001ed <ls>
		}

	if (argc == 1)
		ls("/", "");
	else {
		for (i = 1; i < argc; i++)
  80031c:	83 c3 01             	add    $0x1,%ebx
  80031f:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  800322:	7c e9                	jl     80030d <umain+0x73>
			ls(argv[i], argv[i]);
	}
}
  800324:	83 c4 20             	add    $0x20,%esp
  800327:	5b                   	pop    %ebx
  800328:	5e                   	pop    %esi
  800329:	5d                   	pop    %ebp
  80032a:	c3                   	ret    

0080032b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	56                   	push   %esi
  80032f:	53                   	push   %ebx
  800330:	83 ec 10             	sub    $0x10,%esp
  800333:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800336:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800339:	e8 47 0b 00 00       	call   800e85 <sys_getenvid>
  80033e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800343:	c1 e0 07             	shl    $0x7,%eax
  800346:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80034b:	a3 20 54 80 00       	mov    %eax,0x805420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800350:	85 db                	test   %ebx,%ebx
  800352:	7e 07                	jle    80035b <libmain+0x30>
		binaryname = argv[0];
  800354:	8b 06                	mov    (%esi),%eax
  800356:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80035b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80035f:	89 1c 24             	mov    %ebx,(%esp)
  800362:	e8 33 ff ff ff       	call   80029a <umain>

	// exit gracefully
	exit();
  800367:	e8 07 00 00 00       	call   800373 <exit>
}
  80036c:	83 c4 10             	add    $0x10,%esp
  80036f:	5b                   	pop    %ebx
  800370:	5e                   	pop    %esi
  800371:	5d                   	pop    %ebp
  800372:	c3                   	ret    

00800373 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800379:	e8 bc 11 00 00       	call   80153a <close_all>
	sys_env_destroy(0);
  80037e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800385:	e8 a9 0a 00 00       	call   800e33 <sys_env_destroy>
}
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    

0080038c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	56                   	push   %esi
  800390:	53                   	push   %ebx
  800391:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800394:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800397:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80039d:	e8 e3 0a 00 00       	call   800e85 <sys_getenvid>
  8003a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a5:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ac:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003b0:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b8:	c7 04 24 58 2c 80 00 	movl   $0x802c58,(%esp)
  8003bf:	e8 c1 00 00 00       	call   800485 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003c4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003cb:	89 04 24             	mov    %eax,(%esp)
  8003ce:	e8 51 00 00 00       	call   800424 <vcprintf>
	cprintf("\n");
  8003d3:	c7 04 24 27 2c 80 00 	movl   $0x802c27,(%esp)
  8003da:	e8 a6 00 00 00       	call   800485 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003df:	cc                   	int3   
  8003e0:	eb fd                	jmp    8003df <_panic+0x53>

008003e2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	53                   	push   %ebx
  8003e6:	83 ec 14             	sub    $0x14,%esp
  8003e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003ec:	8b 13                	mov    (%ebx),%edx
  8003ee:	8d 42 01             	lea    0x1(%edx),%eax
  8003f1:	89 03                	mov    %eax,(%ebx)
  8003f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003f6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003fa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003ff:	75 19                	jne    80041a <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800401:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800408:	00 
  800409:	8d 43 08             	lea    0x8(%ebx),%eax
  80040c:	89 04 24             	mov    %eax,(%esp)
  80040f:	e8 e2 09 00 00       	call   800df6 <sys_cputs>
		b->idx = 0;
  800414:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80041a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80041e:	83 c4 14             	add    $0x14,%esp
  800421:	5b                   	pop    %ebx
  800422:	5d                   	pop    %ebp
  800423:	c3                   	ret    

00800424 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80042d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800434:	00 00 00 
	b.cnt = 0;
  800437:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80043e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800441:	8b 45 0c             	mov    0xc(%ebp),%eax
  800444:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80044f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800455:	89 44 24 04          	mov    %eax,0x4(%esp)
  800459:	c7 04 24 e2 03 80 00 	movl   $0x8003e2,(%esp)
  800460:	e8 a9 01 00 00       	call   80060e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800465:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80046b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80046f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800475:	89 04 24             	mov    %eax,(%esp)
  800478:	e8 79 09 00 00       	call   800df6 <sys_cputs>

	return b.cnt;
}
  80047d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800483:	c9                   	leave  
  800484:	c3                   	ret    

00800485 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800485:	55                   	push   %ebp
  800486:	89 e5                	mov    %esp,%ebp
  800488:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80048b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80048e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	89 04 24             	mov    %eax,(%esp)
  800498:	e8 87 ff ff ff       	call   800424 <vcprintf>
	va_end(ap);

	return cnt;
}
  80049d:	c9                   	leave  
  80049e:	c3                   	ret    
  80049f:	90                   	nop

008004a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	57                   	push   %edi
  8004a4:	56                   	push   %esi
  8004a5:	53                   	push   %ebx
  8004a6:	83 ec 3c             	sub    $0x3c,%esp
  8004a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ac:	89 d7                	mov    %edx,%edi
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	89 c3                	mov    %eax,%ebx
  8004b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ca:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004cd:	39 d9                	cmp    %ebx,%ecx
  8004cf:	72 05                	jb     8004d6 <printnum+0x36>
  8004d1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004d4:	77 69                	ja     80053f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004d9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8004dd:	83 ee 01             	sub    $0x1,%esi
  8004e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8004ec:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8004f0:	89 c3                	mov    %eax,%ebx
  8004f2:	89 d6                	mov    %edx,%esi
  8004f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004f7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004fa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8004fe:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800505:	89 04 24             	mov    %eax,(%esp)
  800508:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80050b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80050f:	e8 1c 24 00 00       	call   802930 <__udivdi3>
  800514:	89 d9                	mov    %ebx,%ecx
  800516:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80051a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80051e:	89 04 24             	mov    %eax,(%esp)
  800521:	89 54 24 04          	mov    %edx,0x4(%esp)
  800525:	89 fa                	mov    %edi,%edx
  800527:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80052a:	e8 71 ff ff ff       	call   8004a0 <printnum>
  80052f:	eb 1b                	jmp    80054c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800531:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800535:	8b 45 18             	mov    0x18(%ebp),%eax
  800538:	89 04 24             	mov    %eax,(%esp)
  80053b:	ff d3                	call   *%ebx
  80053d:	eb 03                	jmp    800542 <printnum+0xa2>
  80053f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800542:	83 ee 01             	sub    $0x1,%esi
  800545:	85 f6                	test   %esi,%esi
  800547:	7f e8                	jg     800531 <printnum+0x91>
  800549:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80054c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800550:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800554:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800557:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80055a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80055e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800562:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800565:	89 04 24             	mov    %eax,(%esp)
  800568:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80056b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80056f:	e8 ec 24 00 00       	call   802a60 <__umoddi3>
  800574:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800578:	0f be 80 7b 2c 80 00 	movsbl 0x802c7b(%eax),%eax
  80057f:	89 04 24             	mov    %eax,(%esp)
  800582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800585:	ff d0                	call   *%eax
}
  800587:	83 c4 3c             	add    $0x3c,%esp
  80058a:	5b                   	pop    %ebx
  80058b:	5e                   	pop    %esi
  80058c:	5f                   	pop    %edi
  80058d:	5d                   	pop    %ebp
  80058e:	c3                   	ret    

0080058f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80058f:	55                   	push   %ebp
  800590:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800592:	83 fa 01             	cmp    $0x1,%edx
  800595:	7e 0e                	jle    8005a5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800597:	8b 10                	mov    (%eax),%edx
  800599:	8d 4a 08             	lea    0x8(%edx),%ecx
  80059c:	89 08                	mov    %ecx,(%eax)
  80059e:	8b 02                	mov    (%edx),%eax
  8005a0:	8b 52 04             	mov    0x4(%edx),%edx
  8005a3:	eb 22                	jmp    8005c7 <getuint+0x38>
	else if (lflag)
  8005a5:	85 d2                	test   %edx,%edx
  8005a7:	74 10                	je     8005b9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8005a9:	8b 10                	mov    (%eax),%edx
  8005ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005ae:	89 08                	mov    %ecx,(%eax)
  8005b0:	8b 02                	mov    (%edx),%eax
  8005b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b7:	eb 0e                	jmp    8005c7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005b9:	8b 10                	mov    (%eax),%edx
  8005bb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005be:	89 08                	mov    %ecx,(%eax)
  8005c0:	8b 02                	mov    (%edx),%eax
  8005c2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005c7:	5d                   	pop    %ebp
  8005c8:	c3                   	ret    

008005c9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005c9:	55                   	push   %ebp
  8005ca:	89 e5                	mov    %esp,%ebp
  8005cc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005cf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005d3:	8b 10                	mov    (%eax),%edx
  8005d5:	3b 50 04             	cmp    0x4(%eax),%edx
  8005d8:	73 0a                	jae    8005e4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005da:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005dd:	89 08                	mov    %ecx,(%eax)
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	88 02                	mov    %al,(%edx)
}
  8005e4:	5d                   	pop    %ebp
  8005e5:	c3                   	ret    

008005e6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8005ec:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800601:	8b 45 08             	mov    0x8(%ebp),%eax
  800604:	89 04 24             	mov    %eax,(%esp)
  800607:	e8 02 00 00 00       	call   80060e <vprintfmt>
	va_end(ap);
}
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    

0080060e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	57                   	push   %edi
  800612:	56                   	push   %esi
  800613:	53                   	push   %ebx
  800614:	83 ec 3c             	sub    $0x3c,%esp
  800617:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80061a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80061d:	eb 14                	jmp    800633 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80061f:	85 c0                	test   %eax,%eax
  800621:	0f 84 b3 03 00 00    	je     8009da <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800627:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80062b:	89 04 24             	mov    %eax,(%esp)
  80062e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800631:	89 f3                	mov    %esi,%ebx
  800633:	8d 73 01             	lea    0x1(%ebx),%esi
  800636:	0f b6 03             	movzbl (%ebx),%eax
  800639:	83 f8 25             	cmp    $0x25,%eax
  80063c:	75 e1                	jne    80061f <vprintfmt+0x11>
  80063e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800642:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800649:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800650:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800657:	ba 00 00 00 00       	mov    $0x0,%edx
  80065c:	eb 1d                	jmp    80067b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80065e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800660:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800664:	eb 15                	jmp    80067b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800666:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800668:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80066c:	eb 0d                	jmp    80067b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80066e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800671:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800674:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80067e:	0f b6 0e             	movzbl (%esi),%ecx
  800681:	0f b6 c1             	movzbl %cl,%eax
  800684:	83 e9 23             	sub    $0x23,%ecx
  800687:	80 f9 55             	cmp    $0x55,%cl
  80068a:	0f 87 2a 03 00 00    	ja     8009ba <vprintfmt+0x3ac>
  800690:	0f b6 c9             	movzbl %cl,%ecx
  800693:	ff 24 8d c0 2d 80 00 	jmp    *0x802dc0(,%ecx,4)
  80069a:	89 de                	mov    %ebx,%esi
  80069c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8006a1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8006a4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8006a8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8006ab:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8006ae:	83 fb 09             	cmp    $0x9,%ebx
  8006b1:	77 36                	ja     8006e9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006b6:	eb e9                	jmp    8006a1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8d 48 04             	lea    0x4(%eax),%ecx
  8006be:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006c6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8006c8:	eb 22                	jmp    8006ec <vprintfmt+0xde>
  8006ca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006cd:	85 c9                	test   %ecx,%ecx
  8006cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d4:	0f 49 c1             	cmovns %ecx,%eax
  8006d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006da:	89 de                	mov    %ebx,%esi
  8006dc:	eb 9d                	jmp    80067b <vprintfmt+0x6d>
  8006de:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8006e0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8006e7:	eb 92                	jmp    80067b <vprintfmt+0x6d>
  8006e9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8006ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006f0:	79 89                	jns    80067b <vprintfmt+0x6d>
  8006f2:	e9 77 ff ff ff       	jmp    80066e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006f7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006fa:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8006fc:	e9 7a ff ff ff       	jmp    80067b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800701:	8b 45 14             	mov    0x14(%ebp),%eax
  800704:	8d 50 04             	lea    0x4(%eax),%edx
  800707:	89 55 14             	mov    %edx,0x14(%ebp)
  80070a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	89 04 24             	mov    %eax,(%esp)
  800713:	ff 55 08             	call   *0x8(%ebp)
			break;
  800716:	e9 18 ff ff ff       	jmp    800633 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	8d 50 04             	lea    0x4(%eax),%edx
  800721:	89 55 14             	mov    %edx,0x14(%ebp)
  800724:	8b 00                	mov    (%eax),%eax
  800726:	99                   	cltd   
  800727:	31 d0                	xor    %edx,%eax
  800729:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80072b:	83 f8 11             	cmp    $0x11,%eax
  80072e:	7f 0b                	jg     80073b <vprintfmt+0x12d>
  800730:	8b 14 85 20 2f 80 00 	mov    0x802f20(,%eax,4),%edx
  800737:	85 d2                	test   %edx,%edx
  800739:	75 20                	jne    80075b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80073b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80073f:	c7 44 24 08 93 2c 80 	movl   $0x802c93,0x8(%esp)
  800746:	00 
  800747:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	89 04 24             	mov    %eax,(%esp)
  800751:	e8 90 fe ff ff       	call   8005e6 <printfmt>
  800756:	e9 d8 fe ff ff       	jmp    800633 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80075b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80075f:	c7 44 24 08 61 30 80 	movl   $0x803061,0x8(%esp)
  800766:	00 
  800767:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	89 04 24             	mov    %eax,(%esp)
  800771:	e8 70 fe ff ff       	call   8005e6 <printfmt>
  800776:	e9 b8 fe ff ff       	jmp    800633 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80077b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80077e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800781:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8d 50 04             	lea    0x4(%eax),%edx
  80078a:	89 55 14             	mov    %edx,0x14(%ebp)
  80078d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80078f:	85 f6                	test   %esi,%esi
  800791:	b8 8c 2c 80 00       	mov    $0x802c8c,%eax
  800796:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800799:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80079d:	0f 84 97 00 00 00    	je     80083a <vprintfmt+0x22c>
  8007a3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007a7:	0f 8e 9b 00 00 00    	jle    800848 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ad:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007b1:	89 34 24             	mov    %esi,(%esp)
  8007b4:	e8 cf 02 00 00       	call   800a88 <strnlen>
  8007b9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007bc:	29 c2                	sub    %eax,%edx
  8007be:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8007c1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8007c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007c8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8007cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007d1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d3:	eb 0f                	jmp    8007e4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8007d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007dc:	89 04 24             	mov    %eax,(%esp)
  8007df:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e1:	83 eb 01             	sub    $0x1,%ebx
  8007e4:	85 db                	test   %ebx,%ebx
  8007e6:	7f ed                	jg     8007d5 <vprintfmt+0x1c7>
  8007e8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8007eb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007ee:	85 d2                	test   %edx,%edx
  8007f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f5:	0f 49 c2             	cmovns %edx,%eax
  8007f8:	29 c2                	sub    %eax,%edx
  8007fa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8007fd:	89 d7                	mov    %edx,%edi
  8007ff:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800802:	eb 50                	jmp    800854 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800804:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800808:	74 1e                	je     800828 <vprintfmt+0x21a>
  80080a:	0f be d2             	movsbl %dl,%edx
  80080d:	83 ea 20             	sub    $0x20,%edx
  800810:	83 fa 5e             	cmp    $0x5e,%edx
  800813:	76 13                	jbe    800828 <vprintfmt+0x21a>
					putch('?', putdat);
  800815:	8b 45 0c             	mov    0xc(%ebp),%eax
  800818:	89 44 24 04          	mov    %eax,0x4(%esp)
  80081c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800823:	ff 55 08             	call   *0x8(%ebp)
  800826:	eb 0d                	jmp    800835 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800828:	8b 55 0c             	mov    0xc(%ebp),%edx
  80082b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80082f:	89 04 24             	mov    %eax,(%esp)
  800832:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800835:	83 ef 01             	sub    $0x1,%edi
  800838:	eb 1a                	jmp    800854 <vprintfmt+0x246>
  80083a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80083d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800840:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800843:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800846:	eb 0c                	jmp    800854 <vprintfmt+0x246>
  800848:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80084b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80084e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800851:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800854:	83 c6 01             	add    $0x1,%esi
  800857:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80085b:	0f be c2             	movsbl %dl,%eax
  80085e:	85 c0                	test   %eax,%eax
  800860:	74 27                	je     800889 <vprintfmt+0x27b>
  800862:	85 db                	test   %ebx,%ebx
  800864:	78 9e                	js     800804 <vprintfmt+0x1f6>
  800866:	83 eb 01             	sub    $0x1,%ebx
  800869:	79 99                	jns    800804 <vprintfmt+0x1f6>
  80086b:	89 f8                	mov    %edi,%eax
  80086d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800870:	8b 75 08             	mov    0x8(%ebp),%esi
  800873:	89 c3                	mov    %eax,%ebx
  800875:	eb 1a                	jmp    800891 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800877:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80087b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800882:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800884:	83 eb 01             	sub    $0x1,%ebx
  800887:	eb 08                	jmp    800891 <vprintfmt+0x283>
  800889:	89 fb                	mov    %edi,%ebx
  80088b:	8b 75 08             	mov    0x8(%ebp),%esi
  80088e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800891:	85 db                	test   %ebx,%ebx
  800893:	7f e2                	jg     800877 <vprintfmt+0x269>
  800895:	89 75 08             	mov    %esi,0x8(%ebp)
  800898:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80089b:	e9 93 fd ff ff       	jmp    800633 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008a0:	83 fa 01             	cmp    $0x1,%edx
  8008a3:	7e 16                	jle    8008bb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	8d 50 08             	lea    0x8(%eax),%edx
  8008ab:	89 55 14             	mov    %edx,0x14(%ebp)
  8008ae:	8b 50 04             	mov    0x4(%eax),%edx
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008b9:	eb 32                	jmp    8008ed <vprintfmt+0x2df>
	else if (lflag)
  8008bb:	85 d2                	test   %edx,%edx
  8008bd:	74 18                	je     8008d7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	8d 50 04             	lea    0x4(%eax),%edx
  8008c5:	89 55 14             	mov    %edx,0x14(%ebp)
  8008c8:	8b 30                	mov    (%eax),%esi
  8008ca:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8008cd:	89 f0                	mov    %esi,%eax
  8008cf:	c1 f8 1f             	sar    $0x1f,%eax
  8008d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d5:	eb 16                	jmp    8008ed <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	8d 50 04             	lea    0x4(%eax),%edx
  8008dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8008e0:	8b 30                	mov    (%eax),%esi
  8008e2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8008e5:	89 f0                	mov    %esi,%eax
  8008e7:	c1 f8 1f             	sar    $0x1f,%eax
  8008ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8008f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8008f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fc:	0f 89 80 00 00 00    	jns    800982 <vprintfmt+0x374>
				putch('-', putdat);
  800902:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800906:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80090d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800910:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800913:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800916:	f7 d8                	neg    %eax
  800918:	83 d2 00             	adc    $0x0,%edx
  80091b:	f7 da                	neg    %edx
			}
			base = 10;
  80091d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800922:	eb 5e                	jmp    800982 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800924:	8d 45 14             	lea    0x14(%ebp),%eax
  800927:	e8 63 fc ff ff       	call   80058f <getuint>
			base = 10;
  80092c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800931:	eb 4f                	jmp    800982 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800933:	8d 45 14             	lea    0x14(%ebp),%eax
  800936:	e8 54 fc ff ff       	call   80058f <getuint>
			base = 8;
  80093b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800940:	eb 40                	jmp    800982 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800942:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800946:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80094d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800950:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800954:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80095b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	8d 50 04             	lea    0x4(%eax),%edx
  800964:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800967:	8b 00                	mov    (%eax),%eax
  800969:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80096e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800973:	eb 0d                	jmp    800982 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800975:	8d 45 14             	lea    0x14(%ebp),%eax
  800978:	e8 12 fc ff ff       	call   80058f <getuint>
			base = 16;
  80097d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800982:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800986:	89 74 24 10          	mov    %esi,0x10(%esp)
  80098a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80098d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800991:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800995:	89 04 24             	mov    %eax,(%esp)
  800998:	89 54 24 04          	mov    %edx,0x4(%esp)
  80099c:	89 fa                	mov    %edi,%edx
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	e8 fa fa ff ff       	call   8004a0 <printnum>
			break;
  8009a6:	e9 88 fc ff ff       	jmp    800633 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009ab:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009af:	89 04 24             	mov    %eax,(%esp)
  8009b2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009b5:	e9 79 fc ff ff       	jmp    800633 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009be:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009c5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009c8:	89 f3                	mov    %esi,%ebx
  8009ca:	eb 03                	jmp    8009cf <vprintfmt+0x3c1>
  8009cc:	83 eb 01             	sub    $0x1,%ebx
  8009cf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8009d3:	75 f7                	jne    8009cc <vprintfmt+0x3be>
  8009d5:	e9 59 fc ff ff       	jmp    800633 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8009da:	83 c4 3c             	add    $0x3c,%esp
  8009dd:	5b                   	pop    %ebx
  8009de:	5e                   	pop    %esi
  8009df:	5f                   	pop    %edi
  8009e0:	5d                   	pop    %ebp
  8009e1:	c3                   	ret    

008009e2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	83 ec 28             	sub    $0x28,%esp
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009f1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009f5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ff:	85 c0                	test   %eax,%eax
  800a01:	74 30                	je     800a33 <vsnprintf+0x51>
  800a03:	85 d2                	test   %edx,%edx
  800a05:	7e 2c                	jle    800a33 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a07:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a11:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a15:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a18:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a1c:	c7 04 24 c9 05 80 00 	movl   $0x8005c9,(%esp)
  800a23:	e8 e6 fb ff ff       	call   80060e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a2b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a31:	eb 05                	jmp    800a38 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a38:	c9                   	leave  
  800a39:	c3                   	ret    

00800a3a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a40:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a47:	8b 45 10             	mov    0x10(%ebp),%eax
  800a4a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a51:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	89 04 24             	mov    %eax,(%esp)
  800a5b:	e8 82 ff ff ff       	call   8009e2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a60:	c9                   	leave  
  800a61:	c3                   	ret    
  800a62:	66 90                	xchg   %ax,%ax
  800a64:	66 90                	xchg   %ax,%ax
  800a66:	66 90                	xchg   %ax,%ax
  800a68:	66 90                	xchg   %ax,%ax
  800a6a:	66 90                	xchg   %ax,%ax
  800a6c:	66 90                	xchg   %ax,%ax
  800a6e:	66 90                	xchg   %ax,%ax

00800a70 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a76:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7b:	eb 03                	jmp    800a80 <strlen+0x10>
		n++;
  800a7d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a80:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a84:	75 f7                	jne    800a7d <strlen+0xd>
		n++;
	return n;
}
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a91:	b8 00 00 00 00       	mov    $0x0,%eax
  800a96:	eb 03                	jmp    800a9b <strnlen+0x13>
		n++;
  800a98:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a9b:	39 d0                	cmp    %edx,%eax
  800a9d:	74 06                	je     800aa5 <strnlen+0x1d>
  800a9f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800aa3:	75 f3                	jne    800a98 <strnlen+0x10>
		n++;
	return n;
}
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    

00800aa7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	53                   	push   %ebx
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ab1:	89 c2                	mov    %eax,%edx
  800ab3:	83 c2 01             	add    $0x1,%edx
  800ab6:	83 c1 01             	add    $0x1,%ecx
  800ab9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800abd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ac0:	84 db                	test   %bl,%bl
  800ac2:	75 ef                	jne    800ab3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ac4:	5b                   	pop    %ebx
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	53                   	push   %ebx
  800acb:	83 ec 08             	sub    $0x8,%esp
  800ace:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ad1:	89 1c 24             	mov    %ebx,(%esp)
  800ad4:	e8 97 ff ff ff       	call   800a70 <strlen>
	strcpy(dst + len, src);
  800ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ae0:	01 d8                	add    %ebx,%eax
  800ae2:	89 04 24             	mov    %eax,(%esp)
  800ae5:	e8 bd ff ff ff       	call   800aa7 <strcpy>
	return dst;
}
  800aea:	89 d8                	mov    %ebx,%eax
  800aec:	83 c4 08             	add    $0x8,%esp
  800aef:	5b                   	pop    %ebx
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	56                   	push   %esi
  800af6:	53                   	push   %ebx
  800af7:	8b 75 08             	mov    0x8(%ebp),%esi
  800afa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800afd:	89 f3                	mov    %esi,%ebx
  800aff:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b02:	89 f2                	mov    %esi,%edx
  800b04:	eb 0f                	jmp    800b15 <strncpy+0x23>
		*dst++ = *src;
  800b06:	83 c2 01             	add    $0x1,%edx
  800b09:	0f b6 01             	movzbl (%ecx),%eax
  800b0c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b0f:	80 39 01             	cmpb   $0x1,(%ecx)
  800b12:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b15:	39 da                	cmp    %ebx,%edx
  800b17:	75 ed                	jne    800b06 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b19:	89 f0                	mov    %esi,%eax
  800b1b:	5b                   	pop    %ebx
  800b1c:	5e                   	pop    %esi
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    

00800b1f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	56                   	push   %esi
  800b23:	53                   	push   %ebx
  800b24:	8b 75 08             	mov    0x8(%ebp),%esi
  800b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b2d:	89 f0                	mov    %esi,%eax
  800b2f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b33:	85 c9                	test   %ecx,%ecx
  800b35:	75 0b                	jne    800b42 <strlcpy+0x23>
  800b37:	eb 1d                	jmp    800b56 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b39:	83 c0 01             	add    $0x1,%eax
  800b3c:	83 c2 01             	add    $0x1,%edx
  800b3f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b42:	39 d8                	cmp    %ebx,%eax
  800b44:	74 0b                	je     800b51 <strlcpy+0x32>
  800b46:	0f b6 0a             	movzbl (%edx),%ecx
  800b49:	84 c9                	test   %cl,%cl
  800b4b:	75 ec                	jne    800b39 <strlcpy+0x1a>
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	eb 02                	jmp    800b53 <strlcpy+0x34>
  800b51:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800b53:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800b56:	29 f0                	sub    %esi,%eax
}
  800b58:	5b                   	pop    %ebx
  800b59:	5e                   	pop    %esi
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b62:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b65:	eb 06                	jmp    800b6d <strcmp+0x11>
		p++, q++;
  800b67:	83 c1 01             	add    $0x1,%ecx
  800b6a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b6d:	0f b6 01             	movzbl (%ecx),%eax
  800b70:	84 c0                	test   %al,%al
  800b72:	74 04                	je     800b78 <strcmp+0x1c>
  800b74:	3a 02                	cmp    (%edx),%al
  800b76:	74 ef                	je     800b67 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b78:	0f b6 c0             	movzbl %al,%eax
  800b7b:	0f b6 12             	movzbl (%edx),%edx
  800b7e:	29 d0                	sub    %edx,%eax
}
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	53                   	push   %ebx
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8c:	89 c3                	mov    %eax,%ebx
  800b8e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b91:	eb 06                	jmp    800b99 <strncmp+0x17>
		n--, p++, q++;
  800b93:	83 c0 01             	add    $0x1,%eax
  800b96:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b99:	39 d8                	cmp    %ebx,%eax
  800b9b:	74 15                	je     800bb2 <strncmp+0x30>
  800b9d:	0f b6 08             	movzbl (%eax),%ecx
  800ba0:	84 c9                	test   %cl,%cl
  800ba2:	74 04                	je     800ba8 <strncmp+0x26>
  800ba4:	3a 0a                	cmp    (%edx),%cl
  800ba6:	74 eb                	je     800b93 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba8:	0f b6 00             	movzbl (%eax),%eax
  800bab:	0f b6 12             	movzbl (%edx),%edx
  800bae:	29 d0                	sub    %edx,%eax
  800bb0:	eb 05                	jmp    800bb7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800bb2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800bb7:	5b                   	pop    %ebx
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bc4:	eb 07                	jmp    800bcd <strchr+0x13>
		if (*s == c)
  800bc6:	38 ca                	cmp    %cl,%dl
  800bc8:	74 0f                	je     800bd9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bca:	83 c0 01             	add    $0x1,%eax
  800bcd:	0f b6 10             	movzbl (%eax),%edx
  800bd0:	84 d2                	test   %dl,%dl
  800bd2:	75 f2                	jne    800bc6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800bd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    

00800bdb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800be5:	eb 07                	jmp    800bee <strfind+0x13>
		if (*s == c)
  800be7:	38 ca                	cmp    %cl,%dl
  800be9:	74 0a                	je     800bf5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800beb:	83 c0 01             	add    $0x1,%eax
  800bee:	0f b6 10             	movzbl (%eax),%edx
  800bf1:	84 d2                	test   %dl,%dl
  800bf3:	75 f2                	jne    800be7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	57                   	push   %edi
  800bfb:	56                   	push   %esi
  800bfc:	53                   	push   %ebx
  800bfd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c00:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c03:	85 c9                	test   %ecx,%ecx
  800c05:	74 36                	je     800c3d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c07:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c0d:	75 28                	jne    800c37 <memset+0x40>
  800c0f:	f6 c1 03             	test   $0x3,%cl
  800c12:	75 23                	jne    800c37 <memset+0x40>
		c &= 0xFF;
  800c14:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c18:	89 d3                	mov    %edx,%ebx
  800c1a:	c1 e3 08             	shl    $0x8,%ebx
  800c1d:	89 d6                	mov    %edx,%esi
  800c1f:	c1 e6 18             	shl    $0x18,%esi
  800c22:	89 d0                	mov    %edx,%eax
  800c24:	c1 e0 10             	shl    $0x10,%eax
  800c27:	09 f0                	or     %esi,%eax
  800c29:	09 c2                	or     %eax,%edx
  800c2b:	89 d0                	mov    %edx,%eax
  800c2d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c2f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800c32:	fc                   	cld    
  800c33:	f3 ab                	rep stos %eax,%es:(%edi)
  800c35:	eb 06                	jmp    800c3d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3a:	fc                   	cld    
  800c3b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c3d:	89 f8                	mov    %edi,%eax
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c52:	39 c6                	cmp    %eax,%esi
  800c54:	73 35                	jae    800c8b <memmove+0x47>
  800c56:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c59:	39 d0                	cmp    %edx,%eax
  800c5b:	73 2e                	jae    800c8b <memmove+0x47>
		s += n;
		d += n;
  800c5d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800c60:	89 d6                	mov    %edx,%esi
  800c62:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c64:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c6a:	75 13                	jne    800c7f <memmove+0x3b>
  800c6c:	f6 c1 03             	test   $0x3,%cl
  800c6f:	75 0e                	jne    800c7f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c71:	83 ef 04             	sub    $0x4,%edi
  800c74:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c77:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800c7a:	fd                   	std    
  800c7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c7d:	eb 09                	jmp    800c88 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c7f:	83 ef 01             	sub    $0x1,%edi
  800c82:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c85:	fd                   	std    
  800c86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c88:	fc                   	cld    
  800c89:	eb 1d                	jmp    800ca8 <memmove+0x64>
  800c8b:	89 f2                	mov    %esi,%edx
  800c8d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c8f:	f6 c2 03             	test   $0x3,%dl
  800c92:	75 0f                	jne    800ca3 <memmove+0x5f>
  800c94:	f6 c1 03             	test   $0x3,%cl
  800c97:	75 0a                	jne    800ca3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c99:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800c9c:	89 c7                	mov    %eax,%edi
  800c9e:	fc                   	cld    
  800c9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ca1:	eb 05                	jmp    800ca8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ca3:	89 c7                	mov    %eax,%edi
  800ca5:	fc                   	cld    
  800ca6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ca8:	5e                   	pop    %esi
  800ca9:	5f                   	pop    %edi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 04 24             	mov    %eax,(%esp)
  800cc6:	e8 79 ff ff ff       	call   800c44 <memmove>
}
  800ccb:	c9                   	leave  
  800ccc:	c3                   	ret    

00800ccd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	56                   	push   %esi
  800cd1:	53                   	push   %ebx
  800cd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd8:	89 d6                	mov    %edx,%esi
  800cda:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cdd:	eb 1a                	jmp    800cf9 <memcmp+0x2c>
		if (*s1 != *s2)
  800cdf:	0f b6 02             	movzbl (%edx),%eax
  800ce2:	0f b6 19             	movzbl (%ecx),%ebx
  800ce5:	38 d8                	cmp    %bl,%al
  800ce7:	74 0a                	je     800cf3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ce9:	0f b6 c0             	movzbl %al,%eax
  800cec:	0f b6 db             	movzbl %bl,%ebx
  800cef:	29 d8                	sub    %ebx,%eax
  800cf1:	eb 0f                	jmp    800d02 <memcmp+0x35>
		s1++, s2++;
  800cf3:	83 c2 01             	add    $0x1,%edx
  800cf6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cf9:	39 f2                	cmp    %esi,%edx
  800cfb:	75 e2                	jne    800cdf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d0f:	89 c2                	mov    %eax,%edx
  800d11:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d14:	eb 07                	jmp    800d1d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d16:	38 08                	cmp    %cl,(%eax)
  800d18:	74 07                	je     800d21 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d1a:	83 c0 01             	add    $0x1,%eax
  800d1d:	39 d0                	cmp    %edx,%eax
  800d1f:	72 f5                	jb     800d16 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	57                   	push   %edi
  800d27:	56                   	push   %esi
  800d28:	53                   	push   %ebx
  800d29:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d2f:	eb 03                	jmp    800d34 <strtol+0x11>
		s++;
  800d31:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d34:	0f b6 0a             	movzbl (%edx),%ecx
  800d37:	80 f9 09             	cmp    $0x9,%cl
  800d3a:	74 f5                	je     800d31 <strtol+0xe>
  800d3c:	80 f9 20             	cmp    $0x20,%cl
  800d3f:	74 f0                	je     800d31 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d41:	80 f9 2b             	cmp    $0x2b,%cl
  800d44:	75 0a                	jne    800d50 <strtol+0x2d>
		s++;
  800d46:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d49:	bf 00 00 00 00       	mov    $0x0,%edi
  800d4e:	eb 11                	jmp    800d61 <strtol+0x3e>
  800d50:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800d55:	80 f9 2d             	cmp    $0x2d,%cl
  800d58:	75 07                	jne    800d61 <strtol+0x3e>
		s++, neg = 1;
  800d5a:	8d 52 01             	lea    0x1(%edx),%edx
  800d5d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d61:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800d66:	75 15                	jne    800d7d <strtol+0x5a>
  800d68:	80 3a 30             	cmpb   $0x30,(%edx)
  800d6b:	75 10                	jne    800d7d <strtol+0x5a>
  800d6d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d71:	75 0a                	jne    800d7d <strtol+0x5a>
		s += 2, base = 16;
  800d73:	83 c2 02             	add    $0x2,%edx
  800d76:	b8 10 00 00 00       	mov    $0x10,%eax
  800d7b:	eb 10                	jmp    800d8d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800d7d:	85 c0                	test   %eax,%eax
  800d7f:	75 0c                	jne    800d8d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d81:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d83:	80 3a 30             	cmpb   $0x30,(%edx)
  800d86:	75 05                	jne    800d8d <strtol+0x6a>
		s++, base = 8;
  800d88:	83 c2 01             	add    $0x1,%edx
  800d8b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800d8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d92:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d95:	0f b6 0a             	movzbl (%edx),%ecx
  800d98:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800d9b:	89 f0                	mov    %esi,%eax
  800d9d:	3c 09                	cmp    $0x9,%al
  800d9f:	77 08                	ja     800da9 <strtol+0x86>
			dig = *s - '0';
  800da1:	0f be c9             	movsbl %cl,%ecx
  800da4:	83 e9 30             	sub    $0x30,%ecx
  800da7:	eb 20                	jmp    800dc9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800da9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800dac:	89 f0                	mov    %esi,%eax
  800dae:	3c 19                	cmp    $0x19,%al
  800db0:	77 08                	ja     800dba <strtol+0x97>
			dig = *s - 'a' + 10;
  800db2:	0f be c9             	movsbl %cl,%ecx
  800db5:	83 e9 57             	sub    $0x57,%ecx
  800db8:	eb 0f                	jmp    800dc9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800dba:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800dbd:	89 f0                	mov    %esi,%eax
  800dbf:	3c 19                	cmp    $0x19,%al
  800dc1:	77 16                	ja     800dd9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800dc3:	0f be c9             	movsbl %cl,%ecx
  800dc6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800dc9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800dcc:	7d 0f                	jge    800ddd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800dce:	83 c2 01             	add    $0x1,%edx
  800dd1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800dd5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800dd7:	eb bc                	jmp    800d95 <strtol+0x72>
  800dd9:	89 d8                	mov    %ebx,%eax
  800ddb:	eb 02                	jmp    800ddf <strtol+0xbc>
  800ddd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800ddf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de3:	74 05                	je     800dea <strtol+0xc7>
		*endptr = (char *) s;
  800de5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800de8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800dea:	f7 d8                	neg    %eax
  800dec:	85 ff                	test   %edi,%edi
  800dee:	0f 44 c3             	cmove  %ebx,%eax
}
  800df1:	5b                   	pop    %ebx
  800df2:	5e                   	pop    %esi
  800df3:	5f                   	pop    %edi
  800df4:	5d                   	pop    %ebp
  800df5:	c3                   	ret    

00800df6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	57                   	push   %edi
  800dfa:	56                   	push   %esi
  800dfb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dfc:	b8 00 00 00 00       	mov    $0x0,%eax
  800e01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e04:	8b 55 08             	mov    0x8(%ebp),%edx
  800e07:	89 c3                	mov    %eax,%ebx
  800e09:	89 c7                	mov    %eax,%edi
  800e0b:	89 c6                	mov    %eax,%esi
  800e0d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e0f:	5b                   	pop    %ebx
  800e10:	5e                   	pop    %esi
  800e11:	5f                   	pop    %edi
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    

00800e14 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	57                   	push   %edi
  800e18:	56                   	push   %esi
  800e19:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e1f:	b8 01 00 00 00       	mov    $0x1,%eax
  800e24:	89 d1                	mov    %edx,%ecx
  800e26:	89 d3                	mov    %edx,%ebx
  800e28:	89 d7                	mov    %edx,%edi
  800e2a:	89 d6                	mov    %edx,%esi
  800e2c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e2e:	5b                   	pop    %ebx
  800e2f:	5e                   	pop    %esi
  800e30:	5f                   	pop    %edi
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    

00800e33 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800e3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e41:	b8 03 00 00 00       	mov    $0x3,%eax
  800e46:	8b 55 08             	mov    0x8(%ebp),%edx
  800e49:	89 cb                	mov    %ecx,%ebx
  800e4b:	89 cf                	mov    %ecx,%edi
  800e4d:	89 ce                	mov    %ecx,%esi
  800e4f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e51:	85 c0                	test   %eax,%eax
  800e53:	7e 28                	jle    800e7d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e55:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e59:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800e60:	00 
  800e61:	c7 44 24 08 87 2f 80 	movl   $0x802f87,0x8(%esp)
  800e68:	00 
  800e69:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e70:	00 
  800e71:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  800e78:	e8 0f f5 ff ff       	call   80038c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e7d:	83 c4 2c             	add    $0x2c,%esp
  800e80:	5b                   	pop    %ebx
  800e81:	5e                   	pop    %esi
  800e82:	5f                   	pop    %edi
  800e83:	5d                   	pop    %ebp
  800e84:	c3                   	ret    

00800e85 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	57                   	push   %edi
  800e89:	56                   	push   %esi
  800e8a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e90:	b8 02 00 00 00       	mov    $0x2,%eax
  800e95:	89 d1                	mov    %edx,%ecx
  800e97:	89 d3                	mov    %edx,%ebx
  800e99:	89 d7                	mov    %edx,%edi
  800e9b:	89 d6                	mov    %edx,%esi
  800e9d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e9f:	5b                   	pop    %ebx
  800ea0:	5e                   	pop    %esi
  800ea1:	5f                   	pop    %edi
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    

00800ea4 <sys_yield>:

void
sys_yield(void)
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
  800eaf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800eb4:	89 d1                	mov    %edx,%ecx
  800eb6:	89 d3                	mov    %edx,%ebx
  800eb8:	89 d7                	mov    %edx,%edi
  800eba:	89 d6                	mov    %edx,%esi
  800ebc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800ecc:	be 00 00 00 00       	mov    $0x0,%esi
  800ed1:	b8 04 00 00 00       	mov    $0x4,%eax
  800ed6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  800edc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800edf:	89 f7                	mov    %esi,%edi
  800ee1:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ee3:	85 c0                	test   %eax,%eax
  800ee5:	7e 28                	jle    800f0f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eeb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ef2:	00 
  800ef3:	c7 44 24 08 87 2f 80 	movl   $0x802f87,0x8(%esp)
  800efa:	00 
  800efb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f02:	00 
  800f03:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  800f0a:	e8 7d f4 ff ff       	call   80038c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f0f:	83 c4 2c             	add    $0x2c,%esp
  800f12:	5b                   	pop    %ebx
  800f13:	5e                   	pop    %esi
  800f14:	5f                   	pop    %edi
  800f15:	5d                   	pop    %ebp
  800f16:	c3                   	ret    

00800f17 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
  800f1a:	57                   	push   %edi
  800f1b:	56                   	push   %esi
  800f1c:	53                   	push   %ebx
  800f1d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f20:	b8 05 00 00 00       	mov    $0x5,%eax
  800f25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f31:	8b 75 18             	mov    0x18(%ebp),%esi
  800f34:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f36:	85 c0                	test   %eax,%eax
  800f38:	7e 28                	jle    800f62 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f3e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f45:	00 
  800f46:	c7 44 24 08 87 2f 80 	movl   $0x802f87,0x8(%esp)
  800f4d:	00 
  800f4e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f55:	00 
  800f56:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  800f5d:	e8 2a f4 ff ff       	call   80038c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f62:	83 c4 2c             	add    $0x2c,%esp
  800f65:	5b                   	pop    %ebx
  800f66:	5e                   	pop    %esi
  800f67:	5f                   	pop    %edi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    

00800f6a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	57                   	push   %edi
  800f6e:	56                   	push   %esi
  800f6f:	53                   	push   %ebx
  800f70:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f78:	b8 06 00 00 00       	mov    $0x6,%eax
  800f7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f80:	8b 55 08             	mov    0x8(%ebp),%edx
  800f83:	89 df                	mov    %ebx,%edi
  800f85:	89 de                	mov    %ebx,%esi
  800f87:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f89:	85 c0                	test   %eax,%eax
  800f8b:	7e 28                	jle    800fb5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f91:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f98:	00 
  800f99:	c7 44 24 08 87 2f 80 	movl   $0x802f87,0x8(%esp)
  800fa0:	00 
  800fa1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa8:	00 
  800fa9:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  800fb0:	e8 d7 f3 ff ff       	call   80038c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fb5:	83 c4 2c             	add    $0x2c,%esp
  800fb8:	5b                   	pop    %ebx
  800fb9:	5e                   	pop    %esi
  800fba:	5f                   	pop    %edi
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    

00800fbd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	57                   	push   %edi
  800fc1:	56                   	push   %esi
  800fc2:	53                   	push   %ebx
  800fc3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcb:	b8 08 00 00 00       	mov    $0x8,%eax
  800fd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd6:	89 df                	mov    %ebx,%edi
  800fd8:	89 de                	mov    %ebx,%esi
  800fda:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	7e 28                	jle    801008 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800feb:	00 
  800fec:	c7 44 24 08 87 2f 80 	movl   $0x802f87,0x8(%esp)
  800ff3:	00 
  800ff4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ffb:	00 
  800ffc:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  801003:	e8 84 f3 ff ff       	call   80038c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801008:	83 c4 2c             	add    $0x2c,%esp
  80100b:	5b                   	pop    %ebx
  80100c:	5e                   	pop    %esi
  80100d:	5f                   	pop    %edi
  80100e:	5d                   	pop    %ebp
  80100f:	c3                   	ret    

00801010 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	57                   	push   %edi
  801014:	56                   	push   %esi
  801015:	53                   	push   %ebx
  801016:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801019:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101e:	b8 09 00 00 00       	mov    $0x9,%eax
  801023:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801026:	8b 55 08             	mov    0x8(%ebp),%edx
  801029:	89 df                	mov    %ebx,%edi
  80102b:	89 de                	mov    %ebx,%esi
  80102d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80102f:	85 c0                	test   %eax,%eax
  801031:	7e 28                	jle    80105b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801033:	89 44 24 10          	mov    %eax,0x10(%esp)
  801037:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80103e:	00 
  80103f:	c7 44 24 08 87 2f 80 	movl   $0x802f87,0x8(%esp)
  801046:	00 
  801047:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80104e:	00 
  80104f:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  801056:	e8 31 f3 ff ff       	call   80038c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80105b:	83 c4 2c             	add    $0x2c,%esp
  80105e:	5b                   	pop    %ebx
  80105f:	5e                   	pop    %esi
  801060:	5f                   	pop    %edi
  801061:	5d                   	pop    %ebp
  801062:	c3                   	ret    

00801063 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	57                   	push   %edi
  801067:	56                   	push   %esi
  801068:	53                   	push   %ebx
  801069:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801071:	b8 0a 00 00 00       	mov    $0xa,%eax
  801076:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801079:	8b 55 08             	mov    0x8(%ebp),%edx
  80107c:	89 df                	mov    %ebx,%edi
  80107e:	89 de                	mov    %ebx,%esi
  801080:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801082:	85 c0                	test   %eax,%eax
  801084:	7e 28                	jle    8010ae <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801086:	89 44 24 10          	mov    %eax,0x10(%esp)
  80108a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801091:	00 
  801092:	c7 44 24 08 87 2f 80 	movl   $0x802f87,0x8(%esp)
  801099:	00 
  80109a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010a1:	00 
  8010a2:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  8010a9:	e8 de f2 ff ff       	call   80038c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010ae:	83 c4 2c             	add    $0x2c,%esp
  8010b1:	5b                   	pop    %ebx
  8010b2:	5e                   	pop    %esi
  8010b3:	5f                   	pop    %edi
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    

008010b6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	57                   	push   %edi
  8010ba:	56                   	push   %esi
  8010bb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010bc:	be 00 00 00 00       	mov    $0x0,%esi
  8010c1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010cf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010d2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010d4:	5b                   	pop    %ebx
  8010d5:	5e                   	pop    %esi
  8010d6:	5f                   	pop    %edi
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	57                   	push   %edi
  8010dd:	56                   	push   %esi
  8010de:	53                   	push   %ebx
  8010df:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ef:	89 cb                	mov    %ecx,%ebx
  8010f1:	89 cf                	mov    %ecx,%edi
  8010f3:	89 ce                	mov    %ecx,%esi
  8010f5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	7e 28                	jle    801123 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010fb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ff:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801106:	00 
  801107:	c7 44 24 08 87 2f 80 	movl   $0x802f87,0x8(%esp)
  80110e:	00 
  80110f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801116:	00 
  801117:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  80111e:	e8 69 f2 ff ff       	call   80038c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801123:	83 c4 2c             	add    $0x2c,%esp
  801126:	5b                   	pop    %ebx
  801127:	5e                   	pop    %esi
  801128:	5f                   	pop    %edi
  801129:	5d                   	pop    %ebp
  80112a:	c3                   	ret    

0080112b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	57                   	push   %edi
  80112f:	56                   	push   %esi
  801130:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801131:	ba 00 00 00 00       	mov    $0x0,%edx
  801136:	b8 0e 00 00 00       	mov    $0xe,%eax
  80113b:	89 d1                	mov    %edx,%ecx
  80113d:	89 d3                	mov    %edx,%ebx
  80113f:	89 d7                	mov    %edx,%edi
  801141:	89 d6                	mov    %edx,%esi
  801143:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801145:	5b                   	pop    %ebx
  801146:	5e                   	pop    %esi
  801147:	5f                   	pop    %edi
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    

0080114a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	57                   	push   %edi
  80114e:	56                   	push   %esi
  80114f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801150:	bb 00 00 00 00       	mov    $0x0,%ebx
  801155:	b8 0f 00 00 00       	mov    $0xf,%eax
  80115a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80115d:	8b 55 08             	mov    0x8(%ebp),%edx
  801160:	89 df                	mov    %ebx,%edi
  801162:	89 de                	mov    %ebx,%esi
  801164:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  801166:	5b                   	pop    %ebx
  801167:	5e                   	pop    %esi
  801168:	5f                   	pop    %edi
  801169:	5d                   	pop    %ebp
  80116a:	c3                   	ret    

0080116b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
  80116e:	57                   	push   %edi
  80116f:	56                   	push   %esi
  801170:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801171:	bb 00 00 00 00       	mov    $0x0,%ebx
  801176:	b8 10 00 00 00       	mov    $0x10,%eax
  80117b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117e:	8b 55 08             	mov    0x8(%ebp),%edx
  801181:	89 df                	mov    %ebx,%edi
  801183:	89 de                	mov    %ebx,%esi
  801185:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  801187:	5b                   	pop    %ebx
  801188:	5e                   	pop    %esi
  801189:	5f                   	pop    %edi
  80118a:	5d                   	pop    %ebp
  80118b:	c3                   	ret    

0080118c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
  80118f:	57                   	push   %edi
  801190:	56                   	push   %esi
  801191:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801192:	b9 00 00 00 00       	mov    $0x0,%ecx
  801197:	b8 11 00 00 00       	mov    $0x11,%eax
  80119c:	8b 55 08             	mov    0x8(%ebp),%edx
  80119f:	89 cb                	mov    %ecx,%ebx
  8011a1:	89 cf                	mov    %ecx,%edi
  8011a3:	89 ce                	mov    %ecx,%esi
  8011a5:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  8011a7:	5b                   	pop    %ebx
  8011a8:	5e                   	pop    %esi
  8011a9:	5f                   	pop    %edi
  8011aa:	5d                   	pop    %ebp
  8011ab:	c3                   	ret    

008011ac <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	57                   	push   %edi
  8011b0:	56                   	push   %esi
  8011b1:	53                   	push   %ebx
  8011b2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011b5:	be 00 00 00 00       	mov    $0x0,%esi
  8011ba:	b8 12 00 00 00       	mov    $0x12,%eax
  8011bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011c8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011cb:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8011cd:	85 c0                	test   %eax,%eax
  8011cf:	7e 28                	jle    8011f9 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011d5:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  8011dc:	00 
  8011dd:	c7 44 24 08 87 2f 80 	movl   $0x802f87,0x8(%esp)
  8011e4:	00 
  8011e5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011ec:	00 
  8011ed:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  8011f4:	e8 93 f1 ff ff       	call   80038c <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  8011f9:	83 c4 2c             	add    $0x2c,%esp
  8011fc:	5b                   	pop    %ebx
  8011fd:	5e                   	pop    %esi
  8011fe:	5f                   	pop    %edi
  8011ff:	5d                   	pop    %ebp
  801200:	c3                   	ret    

00801201 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801201:	55                   	push   %ebp
  801202:	89 e5                	mov    %esp,%ebp
  801204:	53                   	push   %ebx
  801205:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801208:	8b 55 0c             	mov    0xc(%ebp),%edx
  80120b:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  80120e:	89 08                	mov    %ecx,(%eax)
	args->argv = (const char **) argv;
  801210:	89 50 04             	mov    %edx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801213:	bb 00 00 00 00       	mov    $0x0,%ebx
  801218:	83 39 01             	cmpl   $0x1,(%ecx)
  80121b:	7e 0f                	jle    80122c <argstart+0x2b>
  80121d:	85 d2                	test   %edx,%edx
  80121f:	ba 00 00 00 00       	mov    $0x0,%edx
  801224:	bb 28 2c 80 00       	mov    $0x802c28,%ebx
  801229:	0f 44 da             	cmove  %edx,%ebx
  80122c:	89 58 08             	mov    %ebx,0x8(%eax)
	args->argvalue = 0;
  80122f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801236:	5b                   	pop    %ebx
  801237:	5d                   	pop    %ebp
  801238:	c3                   	ret    

00801239 <argnext>:

int
argnext(struct Argstate *args)
{
  801239:	55                   	push   %ebp
  80123a:	89 e5                	mov    %esp,%ebp
  80123c:	53                   	push   %ebx
  80123d:	83 ec 14             	sub    $0x14,%esp
  801240:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801243:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  80124a:	8b 43 08             	mov    0x8(%ebx),%eax
  80124d:	85 c0                	test   %eax,%eax
  80124f:	74 71                	je     8012c2 <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  801251:	80 38 00             	cmpb   $0x0,(%eax)
  801254:	75 50                	jne    8012a6 <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801256:	8b 0b                	mov    (%ebx),%ecx
  801258:	83 39 01             	cmpl   $0x1,(%ecx)
  80125b:	74 57                	je     8012b4 <argnext+0x7b>
		    || args->argv[1][0] != '-'
  80125d:	8b 53 04             	mov    0x4(%ebx),%edx
  801260:	8b 42 04             	mov    0x4(%edx),%eax
  801263:	80 38 2d             	cmpb   $0x2d,(%eax)
  801266:	75 4c                	jne    8012b4 <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  801268:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80126c:	74 46                	je     8012b4 <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80126e:	83 c0 01             	add    $0x1,%eax
  801271:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801274:	8b 01                	mov    (%ecx),%eax
  801276:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  80127d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801281:	8d 42 08             	lea    0x8(%edx),%eax
  801284:	89 44 24 04          	mov    %eax,0x4(%esp)
  801288:	83 c2 04             	add    $0x4,%edx
  80128b:	89 14 24             	mov    %edx,(%esp)
  80128e:	e8 b1 f9 ff ff       	call   800c44 <memmove>
		(*args->argc)--;
  801293:	8b 03                	mov    (%ebx),%eax
  801295:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801298:	8b 43 08             	mov    0x8(%ebx),%eax
  80129b:	80 38 2d             	cmpb   $0x2d,(%eax)
  80129e:	75 06                	jne    8012a6 <argnext+0x6d>
  8012a0:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8012a4:	74 0e                	je     8012b4 <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  8012a6:	8b 53 08             	mov    0x8(%ebx),%edx
  8012a9:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  8012ac:	83 c2 01             	add    $0x1,%edx
  8012af:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  8012b2:	eb 13                	jmp    8012c7 <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  8012b4:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  8012bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8012c0:	eb 05                	jmp    8012c7 <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  8012c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  8012c7:	83 c4 14             	add    $0x14,%esp
  8012ca:	5b                   	pop    %ebx
  8012cb:	5d                   	pop    %ebp
  8012cc:	c3                   	ret    

008012cd <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	53                   	push   %ebx
  8012d1:	83 ec 14             	sub    $0x14,%esp
  8012d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  8012d7:	8b 43 08             	mov    0x8(%ebx),%eax
  8012da:	85 c0                	test   %eax,%eax
  8012dc:	74 5a                	je     801338 <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  8012de:	80 38 00             	cmpb   $0x0,(%eax)
  8012e1:	74 0c                	je     8012ef <argnextvalue+0x22>
		args->argvalue = args->curarg;
  8012e3:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  8012e6:	c7 43 08 28 2c 80 00 	movl   $0x802c28,0x8(%ebx)
  8012ed:	eb 44                	jmp    801333 <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  8012ef:	8b 03                	mov    (%ebx),%eax
  8012f1:	83 38 01             	cmpl   $0x1,(%eax)
  8012f4:	7e 2f                	jle    801325 <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  8012f6:	8b 53 04             	mov    0x4(%ebx),%edx
  8012f9:	8b 4a 04             	mov    0x4(%edx),%ecx
  8012fc:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8012ff:	8b 00                	mov    (%eax),%eax
  801301:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801308:	89 44 24 08          	mov    %eax,0x8(%esp)
  80130c:	8d 42 08             	lea    0x8(%edx),%eax
  80130f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801313:	83 c2 04             	add    $0x4,%edx
  801316:	89 14 24             	mov    %edx,(%esp)
  801319:	e8 26 f9 ff ff       	call   800c44 <memmove>
		(*args->argc)--;
  80131e:	8b 03                	mov    (%ebx),%eax
  801320:	83 28 01             	subl   $0x1,(%eax)
  801323:	eb 0e                	jmp    801333 <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  801325:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  80132c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  801333:	8b 43 0c             	mov    0xc(%ebx),%eax
  801336:	eb 05                	jmp    80133d <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  80133d:	83 c4 14             	add    $0x14,%esp
  801340:	5b                   	pop    %ebx
  801341:	5d                   	pop    %ebp
  801342:	c3                   	ret    

00801343 <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
  801346:	83 ec 18             	sub    $0x18,%esp
  801349:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  80134c:	8b 51 0c             	mov    0xc(%ecx),%edx
  80134f:	89 d0                	mov    %edx,%eax
  801351:	85 d2                	test   %edx,%edx
  801353:	75 08                	jne    80135d <argvalue+0x1a>
  801355:	89 0c 24             	mov    %ecx,(%esp)
  801358:	e8 70 ff ff ff       	call   8012cd <argnextvalue>
}
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    
  80135f:	90                   	nop

00801360 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	05 00 00 00 30       	add    $0x30000000,%eax
  80136b:	c1 e8 0c             	shr    $0xc,%eax
}
  80136e:	5d                   	pop    %ebp
  80136f:	c3                   	ret    

00801370 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80137b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801380:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801385:	5d                   	pop    %ebp
  801386:	c3                   	ret    

00801387 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
  80138a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80138d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801392:	89 c2                	mov    %eax,%edx
  801394:	c1 ea 16             	shr    $0x16,%edx
  801397:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80139e:	f6 c2 01             	test   $0x1,%dl
  8013a1:	74 11                	je     8013b4 <fd_alloc+0x2d>
  8013a3:	89 c2                	mov    %eax,%edx
  8013a5:	c1 ea 0c             	shr    $0xc,%edx
  8013a8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013af:	f6 c2 01             	test   $0x1,%dl
  8013b2:	75 09                	jne    8013bd <fd_alloc+0x36>
			*fd_store = fd;
  8013b4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bb:	eb 17                	jmp    8013d4 <fd_alloc+0x4d>
  8013bd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8013c2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013c7:	75 c9                	jne    801392 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013c9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8013cf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8013d4:	5d                   	pop    %ebp
  8013d5:	c3                   	ret    

008013d6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013dc:	83 f8 1f             	cmp    $0x1f,%eax
  8013df:	77 36                	ja     801417 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013e1:	c1 e0 0c             	shl    $0xc,%eax
  8013e4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013e9:	89 c2                	mov    %eax,%edx
  8013eb:	c1 ea 16             	shr    $0x16,%edx
  8013ee:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013f5:	f6 c2 01             	test   $0x1,%dl
  8013f8:	74 24                	je     80141e <fd_lookup+0x48>
  8013fa:	89 c2                	mov    %eax,%edx
  8013fc:	c1 ea 0c             	shr    $0xc,%edx
  8013ff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801406:	f6 c2 01             	test   $0x1,%dl
  801409:	74 1a                	je     801425 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80140b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140e:	89 02                	mov    %eax,(%edx)
	return 0;
  801410:	b8 00 00 00 00       	mov    $0x0,%eax
  801415:	eb 13                	jmp    80142a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801417:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80141c:	eb 0c                	jmp    80142a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80141e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801423:	eb 05                	jmp    80142a <fd_lookup+0x54>
  801425:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80142a:	5d                   	pop    %ebp
  80142b:	c3                   	ret    

0080142c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	83 ec 18             	sub    $0x18,%esp
  801432:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801435:	ba 00 00 00 00       	mov    $0x0,%edx
  80143a:	eb 13                	jmp    80144f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80143c:	39 08                	cmp    %ecx,(%eax)
  80143e:	75 0c                	jne    80144c <dev_lookup+0x20>
			*dev = devtab[i];
  801440:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801443:	89 01                	mov    %eax,(%ecx)
			return 0;
  801445:	b8 00 00 00 00       	mov    $0x0,%eax
  80144a:	eb 38                	jmp    801484 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80144c:	83 c2 01             	add    $0x1,%edx
  80144f:	8b 04 95 34 30 80 00 	mov    0x803034(,%edx,4),%eax
  801456:	85 c0                	test   %eax,%eax
  801458:	75 e2                	jne    80143c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80145a:	a1 20 54 80 00       	mov    0x805420,%eax
  80145f:	8b 40 48             	mov    0x48(%eax),%eax
  801462:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801466:	89 44 24 04          	mov    %eax,0x4(%esp)
  80146a:	c7 04 24 b4 2f 80 00 	movl   $0x802fb4,(%esp)
  801471:	e8 0f f0 ff ff       	call   800485 <cprintf>
	*dev = 0;
  801476:	8b 45 0c             	mov    0xc(%ebp),%eax
  801479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80147f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801484:	c9                   	leave  
  801485:	c3                   	ret    

00801486 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
  801489:	56                   	push   %esi
  80148a:	53                   	push   %ebx
  80148b:	83 ec 20             	sub    $0x20,%esp
  80148e:	8b 75 08             	mov    0x8(%ebp),%esi
  801491:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801494:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801497:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80149b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014a1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014a4:	89 04 24             	mov    %eax,(%esp)
  8014a7:	e8 2a ff ff ff       	call   8013d6 <fd_lookup>
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	78 05                	js     8014b5 <fd_close+0x2f>
	    || fd != fd2)
  8014b0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8014b3:	74 0c                	je     8014c1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8014b5:	84 db                	test   %bl,%bl
  8014b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014bc:	0f 44 c2             	cmove  %edx,%eax
  8014bf:	eb 3f                	jmp    801500 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c8:	8b 06                	mov    (%esi),%eax
  8014ca:	89 04 24             	mov    %eax,(%esp)
  8014cd:	e8 5a ff ff ff       	call   80142c <dev_lookup>
  8014d2:	89 c3                	mov    %eax,%ebx
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	78 16                	js     8014ee <fd_close+0x68>
		if (dev->dev_close)
  8014d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014db:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8014de:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	74 07                	je     8014ee <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8014e7:	89 34 24             	mov    %esi,(%esp)
  8014ea:	ff d0                	call   *%eax
  8014ec:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8014ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014f9:	e8 6c fa ff ff       	call   800f6a <sys_page_unmap>
	return r;
  8014fe:	89 d8                	mov    %ebx,%eax
}
  801500:	83 c4 20             	add    $0x20,%esp
  801503:	5b                   	pop    %ebx
  801504:	5e                   	pop    %esi
  801505:	5d                   	pop    %ebp
  801506:	c3                   	ret    

00801507 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80150d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801510:	89 44 24 04          	mov    %eax,0x4(%esp)
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	89 04 24             	mov    %eax,(%esp)
  80151a:	e8 b7 fe ff ff       	call   8013d6 <fd_lookup>
  80151f:	89 c2                	mov    %eax,%edx
  801521:	85 d2                	test   %edx,%edx
  801523:	78 13                	js     801538 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801525:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80152c:	00 
  80152d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801530:	89 04 24             	mov    %eax,(%esp)
  801533:	e8 4e ff ff ff       	call   801486 <fd_close>
}
  801538:	c9                   	leave  
  801539:	c3                   	ret    

0080153a <close_all>:

void
close_all(void)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	53                   	push   %ebx
  80153e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801541:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801546:	89 1c 24             	mov    %ebx,(%esp)
  801549:	e8 b9 ff ff ff       	call   801507 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80154e:	83 c3 01             	add    $0x1,%ebx
  801551:	83 fb 20             	cmp    $0x20,%ebx
  801554:	75 f0                	jne    801546 <close_all+0xc>
		close(i);
}
  801556:	83 c4 14             	add    $0x14,%esp
  801559:	5b                   	pop    %ebx
  80155a:	5d                   	pop    %ebp
  80155b:	c3                   	ret    

0080155c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	57                   	push   %edi
  801560:	56                   	push   %esi
  801561:	53                   	push   %ebx
  801562:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801565:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801568:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156c:	8b 45 08             	mov    0x8(%ebp),%eax
  80156f:	89 04 24             	mov    %eax,(%esp)
  801572:	e8 5f fe ff ff       	call   8013d6 <fd_lookup>
  801577:	89 c2                	mov    %eax,%edx
  801579:	85 d2                	test   %edx,%edx
  80157b:	0f 88 e1 00 00 00    	js     801662 <dup+0x106>
		return r;
	close(newfdnum);
  801581:	8b 45 0c             	mov    0xc(%ebp),%eax
  801584:	89 04 24             	mov    %eax,(%esp)
  801587:	e8 7b ff ff ff       	call   801507 <close>

	newfd = INDEX2FD(newfdnum);
  80158c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80158f:	c1 e3 0c             	shl    $0xc,%ebx
  801592:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80159b:	89 04 24             	mov    %eax,(%esp)
  80159e:	e8 cd fd ff ff       	call   801370 <fd2data>
  8015a3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8015a5:	89 1c 24             	mov    %ebx,(%esp)
  8015a8:	e8 c3 fd ff ff       	call   801370 <fd2data>
  8015ad:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015af:	89 f0                	mov    %esi,%eax
  8015b1:	c1 e8 16             	shr    $0x16,%eax
  8015b4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015bb:	a8 01                	test   $0x1,%al
  8015bd:	74 43                	je     801602 <dup+0xa6>
  8015bf:	89 f0                	mov    %esi,%eax
  8015c1:	c1 e8 0c             	shr    $0xc,%eax
  8015c4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015cb:	f6 c2 01             	test   $0x1,%dl
  8015ce:	74 32                	je     801602 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015d7:	25 07 0e 00 00       	and    $0xe07,%eax
  8015dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015e0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8015e4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015eb:	00 
  8015ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015f7:	e8 1b f9 ff ff       	call   800f17 <sys_page_map>
  8015fc:	89 c6                	mov    %eax,%esi
  8015fe:	85 c0                	test   %eax,%eax
  801600:	78 3e                	js     801640 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801605:	89 c2                	mov    %eax,%edx
  801607:	c1 ea 0c             	shr    $0xc,%edx
  80160a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801611:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801617:	89 54 24 10          	mov    %edx,0x10(%esp)
  80161b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80161f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801626:	00 
  801627:	89 44 24 04          	mov    %eax,0x4(%esp)
  80162b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801632:	e8 e0 f8 ff ff       	call   800f17 <sys_page_map>
  801637:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801639:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80163c:	85 f6                	test   %esi,%esi
  80163e:	79 22                	jns    801662 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801640:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801644:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80164b:	e8 1a f9 ff ff       	call   800f6a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801650:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801654:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80165b:	e8 0a f9 ff ff       	call   800f6a <sys_page_unmap>
	return r;
  801660:	89 f0                	mov    %esi,%eax
}
  801662:	83 c4 3c             	add    $0x3c,%esp
  801665:	5b                   	pop    %ebx
  801666:	5e                   	pop    %esi
  801667:	5f                   	pop    %edi
  801668:	5d                   	pop    %ebp
  801669:	c3                   	ret    

0080166a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	53                   	push   %ebx
  80166e:	83 ec 24             	sub    $0x24,%esp
  801671:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801674:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801677:	89 44 24 04          	mov    %eax,0x4(%esp)
  80167b:	89 1c 24             	mov    %ebx,(%esp)
  80167e:	e8 53 fd ff ff       	call   8013d6 <fd_lookup>
  801683:	89 c2                	mov    %eax,%edx
  801685:	85 d2                	test   %edx,%edx
  801687:	78 6d                	js     8016f6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801689:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80168c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801690:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801693:	8b 00                	mov    (%eax),%eax
  801695:	89 04 24             	mov    %eax,(%esp)
  801698:	e8 8f fd ff ff       	call   80142c <dev_lookup>
  80169d:	85 c0                	test   %eax,%eax
  80169f:	78 55                	js     8016f6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a4:	8b 50 08             	mov    0x8(%eax),%edx
  8016a7:	83 e2 03             	and    $0x3,%edx
  8016aa:	83 fa 01             	cmp    $0x1,%edx
  8016ad:	75 23                	jne    8016d2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016af:	a1 20 54 80 00       	mov    0x805420,%eax
  8016b4:	8b 40 48             	mov    0x48(%eax),%eax
  8016b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016bf:	c7 04 24 f8 2f 80 00 	movl   $0x802ff8,(%esp)
  8016c6:	e8 ba ed ff ff       	call   800485 <cprintf>
		return -E_INVAL;
  8016cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d0:	eb 24                	jmp    8016f6 <read+0x8c>
	}
	if (!dev->dev_read)
  8016d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d5:	8b 52 08             	mov    0x8(%edx),%edx
  8016d8:	85 d2                	test   %edx,%edx
  8016da:	74 15                	je     8016f1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016ea:	89 04 24             	mov    %eax,(%esp)
  8016ed:	ff d2                	call   *%edx
  8016ef:	eb 05                	jmp    8016f6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8016f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8016f6:	83 c4 24             	add    $0x24,%esp
  8016f9:	5b                   	pop    %ebx
  8016fa:	5d                   	pop    %ebp
  8016fb:	c3                   	ret    

008016fc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	57                   	push   %edi
  801700:	56                   	push   %esi
  801701:	53                   	push   %ebx
  801702:	83 ec 1c             	sub    $0x1c,%esp
  801705:	8b 7d 08             	mov    0x8(%ebp),%edi
  801708:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80170b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801710:	eb 23                	jmp    801735 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801712:	89 f0                	mov    %esi,%eax
  801714:	29 d8                	sub    %ebx,%eax
  801716:	89 44 24 08          	mov    %eax,0x8(%esp)
  80171a:	89 d8                	mov    %ebx,%eax
  80171c:	03 45 0c             	add    0xc(%ebp),%eax
  80171f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801723:	89 3c 24             	mov    %edi,(%esp)
  801726:	e8 3f ff ff ff       	call   80166a <read>
		if (m < 0)
  80172b:	85 c0                	test   %eax,%eax
  80172d:	78 10                	js     80173f <readn+0x43>
			return m;
		if (m == 0)
  80172f:	85 c0                	test   %eax,%eax
  801731:	74 0a                	je     80173d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801733:	01 c3                	add    %eax,%ebx
  801735:	39 f3                	cmp    %esi,%ebx
  801737:	72 d9                	jb     801712 <readn+0x16>
  801739:	89 d8                	mov    %ebx,%eax
  80173b:	eb 02                	jmp    80173f <readn+0x43>
  80173d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80173f:	83 c4 1c             	add    $0x1c,%esp
  801742:	5b                   	pop    %ebx
  801743:	5e                   	pop    %esi
  801744:	5f                   	pop    %edi
  801745:	5d                   	pop    %ebp
  801746:	c3                   	ret    

00801747 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	53                   	push   %ebx
  80174b:	83 ec 24             	sub    $0x24,%esp
  80174e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801751:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801754:	89 44 24 04          	mov    %eax,0x4(%esp)
  801758:	89 1c 24             	mov    %ebx,(%esp)
  80175b:	e8 76 fc ff ff       	call   8013d6 <fd_lookup>
  801760:	89 c2                	mov    %eax,%edx
  801762:	85 d2                	test   %edx,%edx
  801764:	78 68                	js     8017ce <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801766:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801769:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801770:	8b 00                	mov    (%eax),%eax
  801772:	89 04 24             	mov    %eax,(%esp)
  801775:	e8 b2 fc ff ff       	call   80142c <dev_lookup>
  80177a:	85 c0                	test   %eax,%eax
  80177c:	78 50                	js     8017ce <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80177e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801781:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801785:	75 23                	jne    8017aa <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801787:	a1 20 54 80 00       	mov    0x805420,%eax
  80178c:	8b 40 48             	mov    0x48(%eax),%eax
  80178f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801793:	89 44 24 04          	mov    %eax,0x4(%esp)
  801797:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  80179e:	e8 e2 ec ff ff       	call   800485 <cprintf>
		return -E_INVAL;
  8017a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a8:	eb 24                	jmp    8017ce <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ad:	8b 52 0c             	mov    0xc(%edx),%edx
  8017b0:	85 d2                	test   %edx,%edx
  8017b2:	74 15                	je     8017c9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017c2:	89 04 24             	mov    %eax,(%esp)
  8017c5:	ff d2                	call   *%edx
  8017c7:	eb 05                	jmp    8017ce <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8017c9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8017ce:	83 c4 24             	add    $0x24,%esp
  8017d1:	5b                   	pop    %ebx
  8017d2:	5d                   	pop    %ebp
  8017d3:	c3                   	ret    

008017d4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017da:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8017dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	89 04 24             	mov    %eax,(%esp)
  8017e7:	e8 ea fb ff ff       	call   8013d6 <fd_lookup>
  8017ec:	85 c0                	test   %eax,%eax
  8017ee:	78 0e                	js     8017fe <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8017f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	53                   	push   %ebx
  801804:	83 ec 24             	sub    $0x24,%esp
  801807:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80180a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80180d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801811:	89 1c 24             	mov    %ebx,(%esp)
  801814:	e8 bd fb ff ff       	call   8013d6 <fd_lookup>
  801819:	89 c2                	mov    %eax,%edx
  80181b:	85 d2                	test   %edx,%edx
  80181d:	78 61                	js     801880 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80181f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801822:	89 44 24 04          	mov    %eax,0x4(%esp)
  801826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801829:	8b 00                	mov    (%eax),%eax
  80182b:	89 04 24             	mov    %eax,(%esp)
  80182e:	e8 f9 fb ff ff       	call   80142c <dev_lookup>
  801833:	85 c0                	test   %eax,%eax
  801835:	78 49                	js     801880 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80183e:	75 23                	jne    801863 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801840:	a1 20 54 80 00       	mov    0x805420,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801845:	8b 40 48             	mov    0x48(%eax),%eax
  801848:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80184c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801850:	c7 04 24 d4 2f 80 00 	movl   $0x802fd4,(%esp)
  801857:	e8 29 ec ff ff       	call   800485 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80185c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801861:	eb 1d                	jmp    801880 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801863:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801866:	8b 52 18             	mov    0x18(%edx),%edx
  801869:	85 d2                	test   %edx,%edx
  80186b:	74 0e                	je     80187b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80186d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801870:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801874:	89 04 24             	mov    %eax,(%esp)
  801877:	ff d2                	call   *%edx
  801879:	eb 05                	jmp    801880 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80187b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801880:	83 c4 24             	add    $0x24,%esp
  801883:	5b                   	pop    %ebx
  801884:	5d                   	pop    %ebp
  801885:	c3                   	ret    

00801886 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	53                   	push   %ebx
  80188a:	83 ec 24             	sub    $0x24,%esp
  80188d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801890:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801893:	89 44 24 04          	mov    %eax,0x4(%esp)
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	89 04 24             	mov    %eax,(%esp)
  80189d:	e8 34 fb ff ff       	call   8013d6 <fd_lookup>
  8018a2:	89 c2                	mov    %eax,%edx
  8018a4:	85 d2                	test   %edx,%edx
  8018a6:	78 52                	js     8018fa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b2:	8b 00                	mov    (%eax),%eax
  8018b4:	89 04 24             	mov    %eax,(%esp)
  8018b7:	e8 70 fb ff ff       	call   80142c <dev_lookup>
  8018bc:	85 c0                	test   %eax,%eax
  8018be:	78 3a                	js     8018fa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8018c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018c7:	74 2c                	je     8018f5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018c9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018cc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018d3:	00 00 00 
	stat->st_isdir = 0;
  8018d6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018dd:	00 00 00 
	stat->st_dev = dev;
  8018e0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018ed:	89 14 24             	mov    %edx,(%esp)
  8018f0:	ff 50 14             	call   *0x14(%eax)
  8018f3:	eb 05                	jmp    8018fa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8018f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8018fa:	83 c4 24             	add    $0x24,%esp
  8018fd:	5b                   	pop    %ebx
  8018fe:	5d                   	pop    %ebp
  8018ff:	c3                   	ret    

00801900 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	56                   	push   %esi
  801904:	53                   	push   %ebx
  801905:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801908:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80190f:	00 
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	89 04 24             	mov    %eax,(%esp)
  801916:	e8 84 02 00 00       	call   801b9f <open>
  80191b:	89 c3                	mov    %eax,%ebx
  80191d:	85 db                	test   %ebx,%ebx
  80191f:	78 1b                	js     80193c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801921:	8b 45 0c             	mov    0xc(%ebp),%eax
  801924:	89 44 24 04          	mov    %eax,0x4(%esp)
  801928:	89 1c 24             	mov    %ebx,(%esp)
  80192b:	e8 56 ff ff ff       	call   801886 <fstat>
  801930:	89 c6                	mov    %eax,%esi
	close(fd);
  801932:	89 1c 24             	mov    %ebx,(%esp)
  801935:	e8 cd fb ff ff       	call   801507 <close>
	return r;
  80193a:	89 f0                	mov    %esi,%eax
}
  80193c:	83 c4 10             	add    $0x10,%esp
  80193f:	5b                   	pop    %ebx
  801940:	5e                   	pop    %esi
  801941:	5d                   	pop    %ebp
  801942:	c3                   	ret    

00801943 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	56                   	push   %esi
  801947:	53                   	push   %ebx
  801948:	83 ec 10             	sub    $0x10,%esp
  80194b:	89 c6                	mov    %eax,%esi
  80194d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80194f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801956:	75 11                	jne    801969 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801958:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80195f:	e8 51 0f 00 00       	call   8028b5 <ipc_find_env>
  801964:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801969:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801970:	00 
  801971:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801978:	00 
  801979:	89 74 24 04          	mov    %esi,0x4(%esp)
  80197d:	a1 00 50 80 00       	mov    0x805000,%eax
  801982:	89 04 24             	mov    %eax,(%esp)
  801985:	e8 9e 0e 00 00       	call   802828 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80198a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801991:	00 
  801992:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801996:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80199d:	e8 1e 0e 00 00       	call   8027c0 <ipc_recv>
}
  8019a2:	83 c4 10             	add    $0x10,%esp
  8019a5:	5b                   	pop    %ebx
  8019a6:	5e                   	pop    %esi
  8019a7:	5d                   	pop    %ebp
  8019a8:	c3                   	ret    

008019a9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8019ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c7:	b8 02 00 00 00       	mov    $0x2,%eax
  8019cc:	e8 72 ff ff ff       	call   801943 <fsipc>
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8019df:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8019e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e9:	b8 06 00 00 00       	mov    $0x6,%eax
  8019ee:	e8 50 ff ff ff       	call   801943 <fsipc>
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	53                   	push   %ebx
  8019f9:	83 ec 14             	sub    $0x14,%esp
  8019fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	8b 40 0c             	mov    0xc(%eax),%eax
  801a05:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a0f:	b8 05 00 00 00       	mov    $0x5,%eax
  801a14:	e8 2a ff ff ff       	call   801943 <fsipc>
  801a19:	89 c2                	mov    %eax,%edx
  801a1b:	85 d2                	test   %edx,%edx
  801a1d:	78 2b                	js     801a4a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a1f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801a26:	00 
  801a27:	89 1c 24             	mov    %ebx,(%esp)
  801a2a:	e8 78 f0 ff ff       	call   800aa7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a2f:	a1 80 60 80 00       	mov    0x806080,%eax
  801a34:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a3a:	a1 84 60 80 00       	mov    0x806084,%eax
  801a3f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4a:	83 c4 14             	add    $0x14,%esp
  801a4d:	5b                   	pop    %ebx
  801a4e:	5d                   	pop    %ebp
  801a4f:	c3                   	ret    

00801a50 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	53                   	push   %ebx
  801a54:	83 ec 14             	sub    $0x14,%esp
  801a57:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	8b 40 0c             	mov    0xc(%eax),%eax
  801a60:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801a65:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801a6b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801a70:	0f 46 c3             	cmovbe %ebx,%eax
  801a73:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801a78:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a83:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801a8a:	e8 b5 f1 ff ff       	call   800c44 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a94:	b8 04 00 00 00       	mov    $0x4,%eax
  801a99:	e8 a5 fe ff ff       	call   801943 <fsipc>
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	78 53                	js     801af5 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801aa2:	39 c3                	cmp    %eax,%ebx
  801aa4:	73 24                	jae    801aca <devfile_write+0x7a>
  801aa6:	c7 44 24 0c 48 30 80 	movl   $0x803048,0xc(%esp)
  801aad:	00 
  801aae:	c7 44 24 08 4f 30 80 	movl   $0x80304f,0x8(%esp)
  801ab5:	00 
  801ab6:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801abd:	00 
  801abe:	c7 04 24 64 30 80 00 	movl   $0x803064,(%esp)
  801ac5:	e8 c2 e8 ff ff       	call   80038c <_panic>
	assert(r <= PGSIZE);
  801aca:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801acf:	7e 24                	jle    801af5 <devfile_write+0xa5>
  801ad1:	c7 44 24 0c 6f 30 80 	movl   $0x80306f,0xc(%esp)
  801ad8:	00 
  801ad9:	c7 44 24 08 4f 30 80 	movl   $0x80304f,0x8(%esp)
  801ae0:	00 
  801ae1:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801ae8:	00 
  801ae9:	c7 04 24 64 30 80 00 	movl   $0x803064,(%esp)
  801af0:	e8 97 e8 ff ff       	call   80038c <_panic>
	return r;
}
  801af5:	83 c4 14             	add    $0x14,%esp
  801af8:	5b                   	pop    %ebx
  801af9:	5d                   	pop    %ebp
  801afa:	c3                   	ret    

00801afb <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	56                   	push   %esi
  801aff:	53                   	push   %ebx
  801b00:	83 ec 10             	sub    $0x10,%esp
  801b03:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	8b 40 0c             	mov    0xc(%eax),%eax
  801b0c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b11:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b17:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1c:	b8 03 00 00 00       	mov    $0x3,%eax
  801b21:	e8 1d fe ff ff       	call   801943 <fsipc>
  801b26:	89 c3                	mov    %eax,%ebx
  801b28:	85 c0                	test   %eax,%eax
  801b2a:	78 6a                	js     801b96 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801b2c:	39 c6                	cmp    %eax,%esi
  801b2e:	73 24                	jae    801b54 <devfile_read+0x59>
  801b30:	c7 44 24 0c 48 30 80 	movl   $0x803048,0xc(%esp)
  801b37:	00 
  801b38:	c7 44 24 08 4f 30 80 	movl   $0x80304f,0x8(%esp)
  801b3f:	00 
  801b40:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801b47:	00 
  801b48:	c7 04 24 64 30 80 00 	movl   $0x803064,(%esp)
  801b4f:	e8 38 e8 ff ff       	call   80038c <_panic>
	assert(r <= PGSIZE);
  801b54:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b59:	7e 24                	jle    801b7f <devfile_read+0x84>
  801b5b:	c7 44 24 0c 6f 30 80 	movl   $0x80306f,0xc(%esp)
  801b62:	00 
  801b63:	c7 44 24 08 4f 30 80 	movl   $0x80304f,0x8(%esp)
  801b6a:	00 
  801b6b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801b72:	00 
  801b73:	c7 04 24 64 30 80 00 	movl   $0x803064,(%esp)
  801b7a:	e8 0d e8 ff ff       	call   80038c <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b7f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b83:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b8a:	00 
  801b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8e:	89 04 24             	mov    %eax,(%esp)
  801b91:	e8 ae f0 ff ff       	call   800c44 <memmove>
	return r;
}
  801b96:	89 d8                	mov    %ebx,%eax
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	5b                   	pop    %ebx
  801b9c:	5e                   	pop    %esi
  801b9d:	5d                   	pop    %ebp
  801b9e:	c3                   	ret    

00801b9f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	53                   	push   %ebx
  801ba3:	83 ec 24             	sub    $0x24,%esp
  801ba6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801ba9:	89 1c 24             	mov    %ebx,(%esp)
  801bac:	e8 bf ee ff ff       	call   800a70 <strlen>
  801bb1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bb6:	7f 60                	jg     801c18 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801bb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bbb:	89 04 24             	mov    %eax,(%esp)
  801bbe:	e8 c4 f7 ff ff       	call   801387 <fd_alloc>
  801bc3:	89 c2                	mov    %eax,%edx
  801bc5:	85 d2                	test   %edx,%edx
  801bc7:	78 54                	js     801c1d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801bc9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bcd:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801bd4:	e8 ce ee ff ff       	call   800aa7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bdc:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801be1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801be4:	b8 01 00 00 00       	mov    $0x1,%eax
  801be9:	e8 55 fd ff ff       	call   801943 <fsipc>
  801bee:	89 c3                	mov    %eax,%ebx
  801bf0:	85 c0                	test   %eax,%eax
  801bf2:	79 17                	jns    801c0b <open+0x6c>
		fd_close(fd, 0);
  801bf4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bfb:	00 
  801bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bff:	89 04 24             	mov    %eax,(%esp)
  801c02:	e8 7f f8 ff ff       	call   801486 <fd_close>
		return r;
  801c07:	89 d8                	mov    %ebx,%eax
  801c09:	eb 12                	jmp    801c1d <open+0x7e>
	}

	return fd2num(fd);
  801c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0e:	89 04 24             	mov    %eax,(%esp)
  801c11:	e8 4a f7 ff ff       	call   801360 <fd2num>
  801c16:	eb 05                	jmp    801c1d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c18:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801c1d:	83 c4 24             	add    $0x24,%esp
  801c20:	5b                   	pop    %ebx
  801c21:	5d                   	pop    %ebp
  801c22:	c3                   	ret    

00801c23 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c29:	ba 00 00 00 00       	mov    $0x0,%edx
  801c2e:	b8 08 00 00 00       	mov    $0x8,%eax
  801c33:	e8 0b fd ff ff       	call   801943 <fsipc>
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	53                   	push   %ebx
  801c3e:	83 ec 14             	sub    $0x14,%esp
  801c41:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801c43:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801c47:	7e 31                	jle    801c7a <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801c49:	8b 40 04             	mov    0x4(%eax),%eax
  801c4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c50:	8d 43 10             	lea    0x10(%ebx),%eax
  801c53:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c57:	8b 03                	mov    (%ebx),%eax
  801c59:	89 04 24             	mov    %eax,(%esp)
  801c5c:	e8 e6 fa ff ff       	call   801747 <write>
		if (result > 0)
  801c61:	85 c0                	test   %eax,%eax
  801c63:	7e 03                	jle    801c68 <writebuf+0x2e>
			b->result += result;
  801c65:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801c68:	39 43 04             	cmp    %eax,0x4(%ebx)
  801c6b:	74 0d                	je     801c7a <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801c6d:	85 c0                	test   %eax,%eax
  801c6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c74:	0f 4f c2             	cmovg  %edx,%eax
  801c77:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801c7a:	83 c4 14             	add    $0x14,%esp
  801c7d:	5b                   	pop    %ebx
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    

00801c80 <putch>:

static void
putch(int ch, void *thunk)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	53                   	push   %ebx
  801c84:	83 ec 04             	sub    $0x4,%esp
  801c87:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801c8a:	8b 53 04             	mov    0x4(%ebx),%edx
  801c8d:	8d 42 01             	lea    0x1(%edx),%eax
  801c90:	89 43 04             	mov    %eax,0x4(%ebx)
  801c93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c96:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801c9a:	3d 00 01 00 00       	cmp    $0x100,%eax
  801c9f:	75 0e                	jne    801caf <putch+0x2f>
		writebuf(b);
  801ca1:	89 d8                	mov    %ebx,%eax
  801ca3:	e8 92 ff ff ff       	call   801c3a <writebuf>
		b->idx = 0;
  801ca8:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801caf:	83 c4 04             	add    $0x4,%esp
  801cb2:	5b                   	pop    %ebx
  801cb3:	5d                   	pop    %ebp
  801cb4:	c3                   	ret    

00801cb5 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc1:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801cc7:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801cce:	00 00 00 
	b.result = 0;
  801cd1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801cd8:	00 00 00 
	b.error = 1;
  801cdb:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801ce2:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801ce5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cef:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cf3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cfd:	c7 04 24 80 1c 80 00 	movl   $0x801c80,(%esp)
  801d04:	e8 05 e9 ff ff       	call   80060e <vprintfmt>
	if (b.idx > 0)
  801d09:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801d10:	7e 0b                	jle    801d1d <vfprintf+0x68>
		writebuf(&b);
  801d12:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801d18:	e8 1d ff ff ff       	call   801c3a <writebuf>

	return (b.result ? b.result : b.error);
  801d1d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801d23:	85 c0                	test   %eax,%eax
  801d25:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d34:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801d37:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	89 04 24             	mov    %eax,(%esp)
  801d48:	e8 68 ff ff ff       	call   801cb5 <vfprintf>
	va_end(ap);

	return cnt;
}
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <printf>:

int
printf(const char *fmt, ...)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d55:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801d58:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801d6a:	e8 46 ff ff ff       	call   801cb5 <vfprintf>
	va_end(ap);

	return cnt;
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    
  801d71:	66 90                	xchg   %ax,%ax
  801d73:	66 90                	xchg   %ax,%ax
  801d75:	66 90                	xchg   %ax,%ax
  801d77:	66 90                	xchg   %ax,%ax
  801d79:	66 90                	xchg   %ax,%ax
  801d7b:	66 90                	xchg   %ax,%ax
  801d7d:	66 90                	xchg   %ax,%ax
  801d7f:	90                   	nop

00801d80 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801d86:	c7 44 24 04 7b 30 80 	movl   $0x80307b,0x4(%esp)
  801d8d:	00 
  801d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d91:	89 04 24             	mov    %eax,(%esp)
  801d94:	e8 0e ed ff ff       	call   800aa7 <strcpy>
	return 0;
}
  801d99:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	53                   	push   %ebx
  801da4:	83 ec 14             	sub    $0x14,%esp
  801da7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801daa:	89 1c 24             	mov    %ebx,(%esp)
  801dad:	e8 3d 0b 00 00       	call   8028ef <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801db2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801db7:	83 f8 01             	cmp    $0x1,%eax
  801dba:	75 0d                	jne    801dc9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801dbc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801dbf:	89 04 24             	mov    %eax,(%esp)
  801dc2:	e8 29 03 00 00       	call   8020f0 <nsipc_close>
  801dc7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801dc9:	89 d0                	mov    %edx,%eax
  801dcb:	83 c4 14             	add    $0x14,%esp
  801dce:	5b                   	pop    %ebx
  801dcf:	5d                   	pop    %ebp
  801dd0:	c3                   	ret    

00801dd1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801dd7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801dde:	00 
  801ddf:	8b 45 10             	mov    0x10(%ebp),%eax
  801de2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801de6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	8b 40 0c             	mov    0xc(%eax),%eax
  801df3:	89 04 24             	mov    %eax,(%esp)
  801df6:	e8 f0 03 00 00       	call   8021eb <nsipc_send>
}
  801dfb:	c9                   	leave  
  801dfc:	c3                   	ret    

00801dfd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801dfd:	55                   	push   %ebp
  801dfe:	89 e5                	mov    %esp,%ebp
  801e00:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e03:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e0a:	00 
  801e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e15:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e19:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e1f:	89 04 24             	mov    %eax,(%esp)
  801e22:	e8 44 03 00 00       	call   80216b <nsipc_recv>
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e2f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e32:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e36:	89 04 24             	mov    %eax,(%esp)
  801e39:	e8 98 f5 ff ff       	call   8013d6 <fd_lookup>
  801e3e:	85 c0                	test   %eax,%eax
  801e40:	78 17                	js     801e59 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e45:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e4b:	39 08                	cmp    %ecx,(%eax)
  801e4d:	75 05                	jne    801e54 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801e4f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e52:	eb 05                	jmp    801e59 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801e54:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	56                   	push   %esi
  801e5f:	53                   	push   %ebx
  801e60:	83 ec 20             	sub    $0x20,%esp
  801e63:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801e65:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e68:	89 04 24             	mov    %eax,(%esp)
  801e6b:	e8 17 f5 ff ff       	call   801387 <fd_alloc>
  801e70:	89 c3                	mov    %eax,%ebx
  801e72:	85 c0                	test   %eax,%eax
  801e74:	78 21                	js     801e97 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e76:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e7d:	00 
  801e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e81:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e85:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e8c:	e8 32 f0 ff ff       	call   800ec3 <sys_page_alloc>
  801e91:	89 c3                	mov    %eax,%ebx
  801e93:	85 c0                	test   %eax,%eax
  801e95:	79 0c                	jns    801ea3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801e97:	89 34 24             	mov    %esi,(%esp)
  801e9a:	e8 51 02 00 00       	call   8020f0 <nsipc_close>
		return r;
  801e9f:	89 d8                	mov    %ebx,%eax
  801ea1:	eb 20                	jmp    801ec3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801ea3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eac:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801eae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801eb8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801ebb:	89 14 24             	mov    %edx,(%esp)
  801ebe:	e8 9d f4 ff ff       	call   801360 <fd2num>
}
  801ec3:	83 c4 20             	add    $0x20,%esp
  801ec6:	5b                   	pop    %ebx
  801ec7:	5e                   	pop    %esi
  801ec8:	5d                   	pop    %ebp
  801ec9:	c3                   	ret    

00801eca <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed3:	e8 51 ff ff ff       	call   801e29 <fd2sockid>
		return r;
  801ed8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801eda:	85 c0                	test   %eax,%eax
  801edc:	78 23                	js     801f01 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ede:	8b 55 10             	mov    0x10(%ebp),%edx
  801ee1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801eec:	89 04 24             	mov    %eax,(%esp)
  801eef:	e8 45 01 00 00       	call   802039 <nsipc_accept>
		return r;
  801ef4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ef6:	85 c0                	test   %eax,%eax
  801ef8:	78 07                	js     801f01 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801efa:	e8 5c ff ff ff       	call   801e5b <alloc_sockfd>
  801eff:	89 c1                	mov    %eax,%ecx
}
  801f01:	89 c8                	mov    %ecx,%eax
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	e8 16 ff ff ff       	call   801e29 <fd2sockid>
  801f13:	89 c2                	mov    %eax,%edx
  801f15:	85 d2                	test   %edx,%edx
  801f17:	78 16                	js     801f2f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801f19:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f23:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f27:	89 14 24             	mov    %edx,(%esp)
  801f2a:	e8 60 01 00 00       	call   80208f <nsipc_bind>
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <shutdown>:

int
shutdown(int s, int how)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f37:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3a:	e8 ea fe ff ff       	call   801e29 <fd2sockid>
  801f3f:	89 c2                	mov    %eax,%edx
  801f41:	85 d2                	test   %edx,%edx
  801f43:	78 0f                	js     801f54 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f48:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f4c:	89 14 24             	mov    %edx,(%esp)
  801f4f:	e8 7a 01 00 00       	call   8020ce <nsipc_shutdown>
}
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5f:	e8 c5 fe ff ff       	call   801e29 <fd2sockid>
  801f64:	89 c2                	mov    %eax,%edx
  801f66:	85 d2                	test   %edx,%edx
  801f68:	78 16                	js     801f80 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801f6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f6d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f78:	89 14 24             	mov    %edx,(%esp)
  801f7b:	e8 8a 01 00 00       	call   80210a <nsipc_connect>
}
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <listen>:

int
listen(int s, int backlog)
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
  801f85:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	e8 99 fe ff ff       	call   801e29 <fd2sockid>
  801f90:	89 c2                	mov    %eax,%edx
  801f92:	85 d2                	test   %edx,%edx
  801f94:	78 0f                	js     801fa5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f9d:	89 14 24             	mov    %edx,(%esp)
  801fa0:	e8 a4 01 00 00       	call   802149 <nsipc_listen>
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fad:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbe:	89 04 24             	mov    %eax,(%esp)
  801fc1:	e8 98 02 00 00       	call   80225e <nsipc_socket>
  801fc6:	89 c2                	mov    %eax,%edx
  801fc8:	85 d2                	test   %edx,%edx
  801fca:	78 05                	js     801fd1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801fcc:	e8 8a fe ff ff       	call   801e5b <alloc_sockfd>
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	53                   	push   %ebx
  801fd7:	83 ec 14             	sub    $0x14,%esp
  801fda:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fdc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801fe3:	75 11                	jne    801ff6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801fe5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801fec:	e8 c4 08 00 00       	call   8028b5 <ipc_find_env>
  801ff1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ff6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ffd:	00 
  801ffe:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802005:	00 
  802006:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80200a:	a1 04 50 80 00       	mov    0x805004,%eax
  80200f:	89 04 24             	mov    %eax,(%esp)
  802012:	e8 11 08 00 00       	call   802828 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802017:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80201e:	00 
  80201f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802026:	00 
  802027:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80202e:	e8 8d 07 00 00       	call   8027c0 <ipc_recv>
}
  802033:	83 c4 14             	add    $0x14,%esp
  802036:	5b                   	pop    %ebx
  802037:	5d                   	pop    %ebp
  802038:	c3                   	ret    

00802039 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	56                   	push   %esi
  80203d:	53                   	push   %ebx
  80203e:	83 ec 10             	sub    $0x10,%esp
  802041:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80204c:	8b 06                	mov    (%esi),%eax
  80204e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802053:	b8 01 00 00 00       	mov    $0x1,%eax
  802058:	e8 76 ff ff ff       	call   801fd3 <nsipc>
  80205d:	89 c3                	mov    %eax,%ebx
  80205f:	85 c0                	test   %eax,%eax
  802061:	78 23                	js     802086 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802063:	a1 10 70 80 00       	mov    0x807010,%eax
  802068:	89 44 24 08          	mov    %eax,0x8(%esp)
  80206c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802073:	00 
  802074:	8b 45 0c             	mov    0xc(%ebp),%eax
  802077:	89 04 24             	mov    %eax,(%esp)
  80207a:	e8 c5 eb ff ff       	call   800c44 <memmove>
		*addrlen = ret->ret_addrlen;
  80207f:	a1 10 70 80 00       	mov    0x807010,%eax
  802084:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802086:	89 d8                	mov    %ebx,%eax
  802088:	83 c4 10             	add    $0x10,%esp
  80208b:	5b                   	pop    %ebx
  80208c:	5e                   	pop    %esi
  80208d:	5d                   	pop    %ebp
  80208e:	c3                   	ret    

0080208f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
  802092:	53                   	push   %ebx
  802093:	83 ec 14             	sub    $0x14,%esp
  802096:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802099:	8b 45 08             	mov    0x8(%ebp),%eax
  80209c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020a1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ac:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8020b3:	e8 8c eb ff ff       	call   800c44 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020b8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8020be:	b8 02 00 00 00       	mov    $0x2,%eax
  8020c3:	e8 0b ff ff ff       	call   801fd3 <nsipc>
}
  8020c8:	83 c4 14             	add    $0x14,%esp
  8020cb:	5b                   	pop    %ebx
  8020cc:	5d                   	pop    %ebp
  8020cd:	c3                   	ret    

008020ce <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8020dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020df:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8020e4:	b8 03 00 00 00       	mov    $0x3,%eax
  8020e9:	e8 e5 fe ff ff       	call   801fd3 <nsipc>
}
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <nsipc_close>:

int
nsipc_close(int s)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020fe:	b8 04 00 00 00       	mov    $0x4,%eax
  802103:	e8 cb fe ff ff       	call   801fd3 <nsipc>
}
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	53                   	push   %ebx
  80210e:	83 ec 14             	sub    $0x14,%esp
  802111:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80211c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802120:	8b 45 0c             	mov    0xc(%ebp),%eax
  802123:	89 44 24 04          	mov    %eax,0x4(%esp)
  802127:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80212e:	e8 11 eb ff ff       	call   800c44 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802133:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802139:	b8 05 00 00 00       	mov    $0x5,%eax
  80213e:	e8 90 fe ff ff       	call   801fd3 <nsipc>
}
  802143:	83 c4 14             	add    $0x14,%esp
  802146:	5b                   	pop    %ebx
  802147:	5d                   	pop    %ebp
  802148:	c3                   	ret    

00802149 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80214f:	8b 45 08             	mov    0x8(%ebp),%eax
  802152:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80215f:	b8 06 00 00 00       	mov    $0x6,%eax
  802164:	e8 6a fe ff ff       	call   801fd3 <nsipc>
}
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
  80216e:	56                   	push   %esi
  80216f:	53                   	push   %ebx
  802170:	83 ec 10             	sub    $0x10,%esp
  802173:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80217e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802184:	8b 45 14             	mov    0x14(%ebp),%eax
  802187:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80218c:	b8 07 00 00 00       	mov    $0x7,%eax
  802191:	e8 3d fe ff ff       	call   801fd3 <nsipc>
  802196:	89 c3                	mov    %eax,%ebx
  802198:	85 c0                	test   %eax,%eax
  80219a:	78 46                	js     8021e2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80219c:	39 f0                	cmp    %esi,%eax
  80219e:	7f 07                	jg     8021a7 <nsipc_recv+0x3c>
  8021a0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021a5:	7e 24                	jle    8021cb <nsipc_recv+0x60>
  8021a7:	c7 44 24 0c 87 30 80 	movl   $0x803087,0xc(%esp)
  8021ae:	00 
  8021af:	c7 44 24 08 4f 30 80 	movl   $0x80304f,0x8(%esp)
  8021b6:	00 
  8021b7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8021be:	00 
  8021bf:	c7 04 24 9c 30 80 00 	movl   $0x80309c,(%esp)
  8021c6:	e8 c1 e1 ff ff       	call   80038c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021cf:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8021d6:	00 
  8021d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021da:	89 04 24             	mov    %eax,(%esp)
  8021dd:	e8 62 ea ff ff       	call   800c44 <memmove>
	}

	return r;
}
  8021e2:	89 d8                	mov    %ebx,%eax
  8021e4:	83 c4 10             	add    $0x10,%esp
  8021e7:	5b                   	pop    %ebx
  8021e8:	5e                   	pop    %esi
  8021e9:	5d                   	pop    %ebp
  8021ea:	c3                   	ret    

008021eb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	53                   	push   %ebx
  8021ef:	83 ec 14             	sub    $0x14,%esp
  8021f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8021fd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802203:	7e 24                	jle    802229 <nsipc_send+0x3e>
  802205:	c7 44 24 0c a8 30 80 	movl   $0x8030a8,0xc(%esp)
  80220c:	00 
  80220d:	c7 44 24 08 4f 30 80 	movl   $0x80304f,0x8(%esp)
  802214:	00 
  802215:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80221c:	00 
  80221d:	c7 04 24 9c 30 80 00 	movl   $0x80309c,(%esp)
  802224:	e8 63 e1 ff ff       	call   80038c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802229:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80222d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802230:	89 44 24 04          	mov    %eax,0x4(%esp)
  802234:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80223b:	e8 04 ea ff ff       	call   800c44 <memmove>
	nsipcbuf.send.req_size = size;
  802240:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802246:	8b 45 14             	mov    0x14(%ebp),%eax
  802249:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80224e:	b8 08 00 00 00       	mov    $0x8,%eax
  802253:	e8 7b fd ff ff       	call   801fd3 <nsipc>
}
  802258:	83 c4 14             	add    $0x14,%esp
  80225b:	5b                   	pop    %ebx
  80225c:	5d                   	pop    %ebp
  80225d:	c3                   	ret    

0080225e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
  802261:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80226c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802274:	8b 45 10             	mov    0x10(%ebp),%eax
  802277:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80227c:	b8 09 00 00 00       	mov    $0x9,%eax
  802281:	e8 4d fd ff ff       	call   801fd3 <nsipc>
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	56                   	push   %esi
  80228c:	53                   	push   %ebx
  80228d:	83 ec 10             	sub    $0x10,%esp
  802290:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	89 04 24             	mov    %eax,(%esp)
  802299:	e8 d2 f0 ff ff       	call   801370 <fd2data>
  80229e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8022a0:	c7 44 24 04 b4 30 80 	movl   $0x8030b4,0x4(%esp)
  8022a7:	00 
  8022a8:	89 1c 24             	mov    %ebx,(%esp)
  8022ab:	e8 f7 e7 ff ff       	call   800aa7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8022b0:	8b 46 04             	mov    0x4(%esi),%eax
  8022b3:	2b 06                	sub    (%esi),%eax
  8022b5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8022bb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022c2:	00 00 00 
	stat->st_dev = &devpipe;
  8022c5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8022cc:	40 80 00 
	return 0;
}
  8022cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d4:	83 c4 10             	add    $0x10,%esp
  8022d7:	5b                   	pop    %ebx
  8022d8:	5e                   	pop    %esi
  8022d9:	5d                   	pop    %ebp
  8022da:	c3                   	ret    

008022db <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
  8022de:	53                   	push   %ebx
  8022df:	83 ec 14             	sub    $0x14,%esp
  8022e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022e5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022f0:	e8 75 ec ff ff       	call   800f6a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022f5:	89 1c 24             	mov    %ebx,(%esp)
  8022f8:	e8 73 f0 ff ff       	call   801370 <fd2data>
  8022fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802301:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802308:	e8 5d ec ff ff       	call   800f6a <sys_page_unmap>
}
  80230d:	83 c4 14             	add    $0x14,%esp
  802310:	5b                   	pop    %ebx
  802311:	5d                   	pop    %ebp
  802312:	c3                   	ret    

00802313 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
  802316:	57                   	push   %edi
  802317:	56                   	push   %esi
  802318:	53                   	push   %ebx
  802319:	83 ec 2c             	sub    $0x2c,%esp
  80231c:	89 c6                	mov    %eax,%esi
  80231e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802321:	a1 20 54 80 00       	mov    0x805420,%eax
  802326:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802329:	89 34 24             	mov    %esi,(%esp)
  80232c:	e8 be 05 00 00       	call   8028ef <pageref>
  802331:	89 c7                	mov    %eax,%edi
  802333:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802336:	89 04 24             	mov    %eax,(%esp)
  802339:	e8 b1 05 00 00       	call   8028ef <pageref>
  80233e:	39 c7                	cmp    %eax,%edi
  802340:	0f 94 c2             	sete   %dl
  802343:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802346:	8b 0d 20 54 80 00    	mov    0x805420,%ecx
  80234c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80234f:	39 fb                	cmp    %edi,%ebx
  802351:	74 21                	je     802374 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802353:	84 d2                	test   %dl,%dl
  802355:	74 ca                	je     802321 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802357:	8b 51 58             	mov    0x58(%ecx),%edx
  80235a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80235e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802362:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802366:	c7 04 24 bb 30 80 00 	movl   $0x8030bb,(%esp)
  80236d:	e8 13 e1 ff ff       	call   800485 <cprintf>
  802372:	eb ad                	jmp    802321 <_pipeisclosed+0xe>
	}
}
  802374:	83 c4 2c             	add    $0x2c,%esp
  802377:	5b                   	pop    %ebx
  802378:	5e                   	pop    %esi
  802379:	5f                   	pop    %edi
  80237a:	5d                   	pop    %ebp
  80237b:	c3                   	ret    

0080237c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
  80237f:	57                   	push   %edi
  802380:	56                   	push   %esi
  802381:	53                   	push   %ebx
  802382:	83 ec 1c             	sub    $0x1c,%esp
  802385:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802388:	89 34 24             	mov    %esi,(%esp)
  80238b:	e8 e0 ef ff ff       	call   801370 <fd2data>
  802390:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802392:	bf 00 00 00 00       	mov    $0x0,%edi
  802397:	eb 45                	jmp    8023de <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802399:	89 da                	mov    %ebx,%edx
  80239b:	89 f0                	mov    %esi,%eax
  80239d:	e8 71 ff ff ff       	call   802313 <_pipeisclosed>
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	75 41                	jne    8023e7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8023a6:	e8 f9 ea ff ff       	call   800ea4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8023ab:	8b 43 04             	mov    0x4(%ebx),%eax
  8023ae:	8b 0b                	mov    (%ebx),%ecx
  8023b0:	8d 51 20             	lea    0x20(%ecx),%edx
  8023b3:	39 d0                	cmp    %edx,%eax
  8023b5:	73 e2                	jae    802399 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023ba:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8023be:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8023c1:	99                   	cltd   
  8023c2:	c1 ea 1b             	shr    $0x1b,%edx
  8023c5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8023c8:	83 e1 1f             	and    $0x1f,%ecx
  8023cb:	29 d1                	sub    %edx,%ecx
  8023cd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8023d1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8023d5:	83 c0 01             	add    $0x1,%eax
  8023d8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023db:	83 c7 01             	add    $0x1,%edi
  8023de:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023e1:	75 c8                	jne    8023ab <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8023e3:	89 f8                	mov    %edi,%eax
  8023e5:	eb 05                	jmp    8023ec <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8023e7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8023ec:	83 c4 1c             	add    $0x1c,%esp
  8023ef:	5b                   	pop    %ebx
  8023f0:	5e                   	pop    %esi
  8023f1:	5f                   	pop    %edi
  8023f2:	5d                   	pop    %ebp
  8023f3:	c3                   	ret    

008023f4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
  8023f7:	57                   	push   %edi
  8023f8:	56                   	push   %esi
  8023f9:	53                   	push   %ebx
  8023fa:	83 ec 1c             	sub    $0x1c,%esp
  8023fd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802400:	89 3c 24             	mov    %edi,(%esp)
  802403:	e8 68 ef ff ff       	call   801370 <fd2data>
  802408:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80240a:	be 00 00 00 00       	mov    $0x0,%esi
  80240f:	eb 3d                	jmp    80244e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802411:	85 f6                	test   %esi,%esi
  802413:	74 04                	je     802419 <devpipe_read+0x25>
				return i;
  802415:	89 f0                	mov    %esi,%eax
  802417:	eb 43                	jmp    80245c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802419:	89 da                	mov    %ebx,%edx
  80241b:	89 f8                	mov    %edi,%eax
  80241d:	e8 f1 fe ff ff       	call   802313 <_pipeisclosed>
  802422:	85 c0                	test   %eax,%eax
  802424:	75 31                	jne    802457 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802426:	e8 79 ea ff ff       	call   800ea4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80242b:	8b 03                	mov    (%ebx),%eax
  80242d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802430:	74 df                	je     802411 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802432:	99                   	cltd   
  802433:	c1 ea 1b             	shr    $0x1b,%edx
  802436:	01 d0                	add    %edx,%eax
  802438:	83 e0 1f             	and    $0x1f,%eax
  80243b:	29 d0                	sub    %edx,%eax
  80243d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802442:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802445:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802448:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80244b:	83 c6 01             	add    $0x1,%esi
  80244e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802451:	75 d8                	jne    80242b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802453:	89 f0                	mov    %esi,%eax
  802455:	eb 05                	jmp    80245c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802457:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80245c:	83 c4 1c             	add    $0x1c,%esp
  80245f:	5b                   	pop    %ebx
  802460:	5e                   	pop    %esi
  802461:	5f                   	pop    %edi
  802462:	5d                   	pop    %ebp
  802463:	c3                   	ret    

00802464 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
  802467:	56                   	push   %esi
  802468:	53                   	push   %ebx
  802469:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80246c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80246f:	89 04 24             	mov    %eax,(%esp)
  802472:	e8 10 ef ff ff       	call   801387 <fd_alloc>
  802477:	89 c2                	mov    %eax,%edx
  802479:	85 d2                	test   %edx,%edx
  80247b:	0f 88 4d 01 00 00    	js     8025ce <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802481:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802488:	00 
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802490:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802497:	e8 27 ea ff ff       	call   800ec3 <sys_page_alloc>
  80249c:	89 c2                	mov    %eax,%edx
  80249e:	85 d2                	test   %edx,%edx
  8024a0:	0f 88 28 01 00 00    	js     8025ce <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8024a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024a9:	89 04 24             	mov    %eax,(%esp)
  8024ac:	e8 d6 ee ff ff       	call   801387 <fd_alloc>
  8024b1:	89 c3                	mov    %eax,%ebx
  8024b3:	85 c0                	test   %eax,%eax
  8024b5:	0f 88 fe 00 00 00    	js     8025b9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024bb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024c2:	00 
  8024c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d1:	e8 ed e9 ff ff       	call   800ec3 <sys_page_alloc>
  8024d6:	89 c3                	mov    %eax,%ebx
  8024d8:	85 c0                	test   %eax,%eax
  8024da:	0f 88 d9 00 00 00    	js     8025b9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	89 04 24             	mov    %eax,(%esp)
  8024e6:	e8 85 ee ff ff       	call   801370 <fd2data>
  8024eb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024ed:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024f4:	00 
  8024f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802500:	e8 be e9 ff ff       	call   800ec3 <sys_page_alloc>
  802505:	89 c3                	mov    %eax,%ebx
  802507:	85 c0                	test   %eax,%eax
  802509:	0f 88 97 00 00 00    	js     8025a6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80250f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802512:	89 04 24             	mov    %eax,(%esp)
  802515:	e8 56 ee ff ff       	call   801370 <fd2data>
  80251a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802521:	00 
  802522:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802526:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80252d:	00 
  80252e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802532:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802539:	e8 d9 e9 ff ff       	call   800f17 <sys_page_map>
  80253e:	89 c3                	mov    %eax,%ebx
  802540:	85 c0                	test   %eax,%eax
  802542:	78 52                	js     802596 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802544:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802559:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80255f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802562:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802567:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	89 04 24             	mov    %eax,(%esp)
  802574:	e8 e7 ed ff ff       	call   801360 <fd2num>
  802579:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80257c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80257e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802581:	89 04 24             	mov    %eax,(%esp)
  802584:	e8 d7 ed ff ff       	call   801360 <fd2num>
  802589:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80258c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80258f:	b8 00 00 00 00       	mov    $0x0,%eax
  802594:	eb 38                	jmp    8025ce <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802596:	89 74 24 04          	mov    %esi,0x4(%esp)
  80259a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025a1:	e8 c4 e9 ff ff       	call   800f6a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8025a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025b4:	e8 b1 e9 ff ff       	call   800f6a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025c7:	e8 9e e9 ff ff       	call   800f6a <sys_page_unmap>
  8025cc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8025ce:	83 c4 30             	add    $0x30,%esp
  8025d1:	5b                   	pop    %ebx
  8025d2:	5e                   	pop    %esi
  8025d3:	5d                   	pop    %ebp
  8025d4:	c3                   	ret    

008025d5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8025d5:	55                   	push   %ebp
  8025d6:	89 e5                	mov    %esp,%ebp
  8025d8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e5:	89 04 24             	mov    %eax,(%esp)
  8025e8:	e8 e9 ed ff ff       	call   8013d6 <fd_lookup>
  8025ed:	89 c2                	mov    %eax,%edx
  8025ef:	85 d2                	test   %edx,%edx
  8025f1:	78 15                	js     802608 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	89 04 24             	mov    %eax,(%esp)
  8025f9:	e8 72 ed ff ff       	call   801370 <fd2data>
	return _pipeisclosed(fd, p);
  8025fe:	89 c2                	mov    %eax,%edx
  802600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802603:	e8 0b fd ff ff       	call   802313 <_pipeisclosed>
}
  802608:	c9                   	leave  
  802609:	c3                   	ret    
  80260a:	66 90                	xchg   %ax,%ax
  80260c:	66 90                	xchg   %ax,%ax
  80260e:	66 90                	xchg   %ax,%ax

00802610 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802610:	55                   	push   %ebp
  802611:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802613:	b8 00 00 00 00       	mov    $0x0,%eax
  802618:	5d                   	pop    %ebp
  802619:	c3                   	ret    

0080261a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
  80261d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802620:	c7 44 24 04 d3 30 80 	movl   $0x8030d3,0x4(%esp)
  802627:	00 
  802628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80262b:	89 04 24             	mov    %eax,(%esp)
  80262e:	e8 74 e4 ff ff       	call   800aa7 <strcpy>
	return 0;
}
  802633:	b8 00 00 00 00       	mov    $0x0,%eax
  802638:	c9                   	leave  
  802639:	c3                   	ret    

0080263a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80263a:	55                   	push   %ebp
  80263b:	89 e5                	mov    %esp,%ebp
  80263d:	57                   	push   %edi
  80263e:	56                   	push   %esi
  80263f:	53                   	push   %ebx
  802640:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802646:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80264b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802651:	eb 31                	jmp    802684 <devcons_write+0x4a>
		m = n - tot;
  802653:	8b 75 10             	mov    0x10(%ebp),%esi
  802656:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802658:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80265b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802660:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802663:	89 74 24 08          	mov    %esi,0x8(%esp)
  802667:	03 45 0c             	add    0xc(%ebp),%eax
  80266a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80266e:	89 3c 24             	mov    %edi,(%esp)
  802671:	e8 ce e5 ff ff       	call   800c44 <memmove>
		sys_cputs(buf, m);
  802676:	89 74 24 04          	mov    %esi,0x4(%esp)
  80267a:	89 3c 24             	mov    %edi,(%esp)
  80267d:	e8 74 e7 ff ff       	call   800df6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802682:	01 f3                	add    %esi,%ebx
  802684:	89 d8                	mov    %ebx,%eax
  802686:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802689:	72 c8                	jb     802653 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80268b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802691:	5b                   	pop    %ebx
  802692:	5e                   	pop    %esi
  802693:	5f                   	pop    %edi
  802694:	5d                   	pop    %ebp
  802695:	c3                   	ret    

00802696 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802696:	55                   	push   %ebp
  802697:	89 e5                	mov    %esp,%ebp
  802699:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80269c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8026a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026a5:	75 07                	jne    8026ae <devcons_read+0x18>
  8026a7:	eb 2a                	jmp    8026d3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8026a9:	e8 f6 e7 ff ff       	call   800ea4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8026ae:	66 90                	xchg   %ax,%ax
  8026b0:	e8 5f e7 ff ff       	call   800e14 <sys_cgetc>
  8026b5:	85 c0                	test   %eax,%eax
  8026b7:	74 f0                	je     8026a9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8026b9:	85 c0                	test   %eax,%eax
  8026bb:	78 16                	js     8026d3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8026bd:	83 f8 04             	cmp    $0x4,%eax
  8026c0:	74 0c                	je     8026ce <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8026c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026c5:	88 02                	mov    %al,(%edx)
	return 1;
  8026c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8026cc:	eb 05                	jmp    8026d3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8026ce:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8026d3:	c9                   	leave  
  8026d4:	c3                   	ret    

008026d5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
  8026d8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
  8026de:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8026e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8026e8:	00 
  8026e9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026ec:	89 04 24             	mov    %eax,(%esp)
  8026ef:	e8 02 e7 ff ff       	call   800df6 <sys_cputs>
}
  8026f4:	c9                   	leave  
  8026f5:	c3                   	ret    

008026f6 <getchar>:

int
getchar(void)
{
  8026f6:	55                   	push   %ebp
  8026f7:	89 e5                	mov    %esp,%ebp
  8026f9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8026fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802703:	00 
  802704:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802707:	89 44 24 04          	mov    %eax,0x4(%esp)
  80270b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802712:	e8 53 ef ff ff       	call   80166a <read>
	if (r < 0)
  802717:	85 c0                	test   %eax,%eax
  802719:	78 0f                	js     80272a <getchar+0x34>
		return r;
	if (r < 1)
  80271b:	85 c0                	test   %eax,%eax
  80271d:	7e 06                	jle    802725 <getchar+0x2f>
		return -E_EOF;
	return c;
  80271f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802723:	eb 05                	jmp    80272a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802725:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80272a:	c9                   	leave  
  80272b:	c3                   	ret    

0080272c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80272c:	55                   	push   %ebp
  80272d:	89 e5                	mov    %esp,%ebp
  80272f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802732:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802735:	89 44 24 04          	mov    %eax,0x4(%esp)
  802739:	8b 45 08             	mov    0x8(%ebp),%eax
  80273c:	89 04 24             	mov    %eax,(%esp)
  80273f:	e8 92 ec ff ff       	call   8013d6 <fd_lookup>
  802744:	85 c0                	test   %eax,%eax
  802746:	78 11                	js     802759 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802751:	39 10                	cmp    %edx,(%eax)
  802753:	0f 94 c0             	sete   %al
  802756:	0f b6 c0             	movzbl %al,%eax
}
  802759:	c9                   	leave  
  80275a:	c3                   	ret    

0080275b <opencons>:

int
opencons(void)
{
  80275b:	55                   	push   %ebp
  80275c:	89 e5                	mov    %esp,%ebp
  80275e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802761:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802764:	89 04 24             	mov    %eax,(%esp)
  802767:	e8 1b ec ff ff       	call   801387 <fd_alloc>
		return r;
  80276c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80276e:	85 c0                	test   %eax,%eax
  802770:	78 40                	js     8027b2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802772:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802779:	00 
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802781:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802788:	e8 36 e7 ff ff       	call   800ec3 <sys_page_alloc>
		return r;
  80278d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80278f:	85 c0                	test   %eax,%eax
  802791:	78 1f                	js     8027b2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802793:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8027a8:	89 04 24             	mov    %eax,(%esp)
  8027ab:	e8 b0 eb ff ff       	call   801360 <fd2num>
  8027b0:	89 c2                	mov    %eax,%edx
}
  8027b2:	89 d0                	mov    %edx,%eax
  8027b4:	c9                   	leave  
  8027b5:	c3                   	ret    
  8027b6:	66 90                	xchg   %ax,%ax
  8027b8:	66 90                	xchg   %ax,%ax
  8027ba:	66 90                	xchg   %ax,%ax
  8027bc:	66 90                	xchg   %ax,%ax
  8027be:	66 90                	xchg   %ax,%ax

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
  8027de:	e8 f6 e8 ff ff       	call   8010d9 <sys_ipc_recv>
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
  802801:	a1 20 54 80 00       	mov    0x805420,%eax
  802806:	8b 40 74             	mov    0x74(%eax),%eax
  802809:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80280b:	85 db                	test   %ebx,%ebx
  80280d:	74 0a                	je     802819 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80280f:	a1 20 54 80 00       	mov    0x805420,%eax
  802814:	8b 40 78             	mov    0x78(%eax),%eax
  802817:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802819:	a1 20 54 80 00       	mov    0x805420,%eax
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
  802856:	e8 5b e8 ff ff       	call   8010b6 <sys_ipc_try_send>
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
  802865:	e8 3a e6 ff ff       	call   800ea4 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80286a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80286e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802872:	89 74 24 04          	mov    %esi,0x4(%esp)
  802876:	8b 45 08             	mov    0x8(%ebp),%eax
  802879:	89 04 24             	mov    %eax,(%esp)
  80287c:	e8 35 e8 ff ff       	call   8010b6 <sys_ipc_try_send>
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
  802891:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  802898:	00 
  802899:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  8028a0:	00 
  8028a1:	c7 04 24 ed 30 80 00 	movl   $0x8030ed,(%esp)
  8028a8:	e8 df da ff ff       	call   80038c <_panic>
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
