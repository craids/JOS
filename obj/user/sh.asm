
obj/user/sh.debug:     file format elf32-i386


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
  80002c:	e8 d5 09 00 00       	call   800a06 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	83 ec 1c             	sub    $0x1c,%esp
  800049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004c:	8b 75 0c             	mov    0xc(%ebp),%esi
	int t;

	if (s == 0) {
  80004f:	85 db                	test   %ebx,%ebx
  800051:	75 28                	jne    80007b <_gettoken+0x3b>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
  800053:	b8 00 00 00 00       	mov    $0x0,%eax
_gettoken(char *s, char **p1, char **p2)
{
	int t;

	if (s == 0) {
		if (debug > 1)
  800058:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  80005f:	0f 8e 33 01 00 00    	jle    800198 <_gettoken+0x158>
			cprintf("GETTOKEN NULL\n");
  800065:	c7 04 24 00 41 80 00 	movl   $0x804100,(%esp)
  80006c:	e8 ef 0a 00 00       	call   800b60 <cprintf>
		return 0;
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	e9 1d 01 00 00       	jmp    800198 <_gettoken+0x158>
	}

	if (debug > 1)
  80007b:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800082:	7e 10                	jle    800094 <_gettoken+0x54>
		cprintf("GETTOKEN: %s\n", s);
  800084:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800088:	c7 04 24 0f 41 80 00 	movl   $0x80410f,(%esp)
  80008f:	e8 cc 0a 00 00       	call   800b60 <cprintf>

	*p1 = 0;
  800094:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	*p2 = 0;
  80009a:	8b 45 10             	mov    0x10(%ebp),%eax
  80009d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  8000a3:	eb 07                	jmp    8000ac <_gettoken+0x6c>
		*s++ = 0;
  8000a5:	83 c3 01             	add    $0x1,%ebx
  8000a8:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8000ac:	0f be 03             	movsbl (%ebx),%eax
  8000af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b3:	c7 04 24 1d 41 80 00 	movl   $0x80411d,(%esp)
  8000ba:	e8 cb 12 00 00       	call   80138a <strchr>
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	75 e2                	jne    8000a5 <_gettoken+0x65>
  8000c3:	89 df                	mov    %ebx,%edi
		*s++ = 0;
	if (*s == 0) {
  8000c5:	0f b6 03             	movzbl (%ebx),%eax
  8000c8:	84 c0                	test   %al,%al
  8000ca:	75 28                	jne    8000f4 <_gettoken+0xb4>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000cc:	b8 00 00 00 00       	mov    $0x0,%eax
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
		*s++ = 0;
	if (*s == 0) {
		if (debug > 1)
  8000d1:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  8000d8:	0f 8e ba 00 00 00    	jle    800198 <_gettoken+0x158>
			cprintf("EOL\n");
  8000de:	c7 04 24 22 41 80 00 	movl   $0x804122,(%esp)
  8000e5:	e8 76 0a 00 00       	call   800b60 <cprintf>
		return 0;
  8000ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ef:	e9 a4 00 00 00       	jmp    800198 <_gettoken+0x158>
	}
	if (strchr(SYMBOLS, *s)) {
  8000f4:	0f be c0             	movsbl %al,%eax
  8000f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000fb:	c7 04 24 33 41 80 00 	movl   $0x804133,(%esp)
  800102:	e8 83 12 00 00       	call   80138a <strchr>
  800107:	85 c0                	test   %eax,%eax
  800109:	74 2f                	je     80013a <_gettoken+0xfa>
		t = *s;
  80010b:	0f be 1b             	movsbl (%ebx),%ebx
		*p1 = s;
  80010e:	89 3e                	mov    %edi,(%esi)
		*s++ = 0;
  800110:	c6 07 00             	movb   $0x0,(%edi)
  800113:	83 c7 01             	add    $0x1,%edi
  800116:	8b 45 10             	mov    0x10(%ebp),%eax
  800119:	89 38                	mov    %edi,(%eax)
		*p2 = s;
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
  80011b:	89 d8                	mov    %ebx,%eax
	if (strchr(SYMBOLS, *s)) {
		t = *s;
		*p1 = s;
		*s++ = 0;
		*p2 = s;
		if (debug > 1)
  80011d:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800124:	7e 72                	jle    800198 <_gettoken+0x158>
			cprintf("TOK %c\n", t);
  800126:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80012a:	c7 04 24 27 41 80 00 	movl   $0x804127,(%esp)
  800131:	e8 2a 0a 00 00       	call   800b60 <cprintf>
		return t;
  800136:	89 d8                	mov    %ebx,%eax
  800138:	eb 5e                	jmp    800198 <_gettoken+0x158>
	}
	*p1 = s;
  80013a:	89 1e                	mov    %ebx,(%esi)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80013c:	eb 03                	jmp    800141 <_gettoken+0x101>
		s++;
  80013e:	83 c3 01             	add    $0x1,%ebx
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800141:	0f b6 03             	movzbl (%ebx),%eax
  800144:	84 c0                	test   %al,%al
  800146:	74 17                	je     80015f <_gettoken+0x11f>
  800148:	0f be c0             	movsbl %al,%eax
  80014b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80014f:	c7 04 24 2f 41 80 00 	movl   $0x80412f,(%esp)
  800156:	e8 2f 12 00 00       	call   80138a <strchr>
  80015b:	85 c0                	test   %eax,%eax
  80015d:	74 df                	je     80013e <_gettoken+0xfe>
		s++;
	*p2 = s;
  80015f:	8b 45 10             	mov    0x10(%ebp),%eax
  800162:	89 18                	mov    %ebx,(%eax)
		t = **p2;
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
  800164:	b8 77 00 00 00       	mov    $0x77,%eax
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
		s++;
	*p2 = s;
	if (debug > 1) {
  800169:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800170:	7e 26                	jle    800198 <_gettoken+0x158>
		t = **p2;
  800172:	0f b6 3b             	movzbl (%ebx),%edi
		**p2 = 0;
  800175:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  800178:	8b 06                	mov    (%esi),%eax
  80017a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017e:	c7 04 24 3b 41 80 00 	movl   $0x80413b,(%esp)
  800185:	e8 d6 09 00 00       	call   800b60 <cprintf>
		**p2 = t;
  80018a:	8b 45 10             	mov    0x10(%ebp),%eax
  80018d:	8b 00                	mov    (%eax),%eax
  80018f:	89 fa                	mov    %edi,%edx
  800191:	88 10                	mov    %dl,(%eax)
	}
	return 'w';
  800193:	b8 77 00 00 00       	mov    $0x77,%eax
}
  800198:	83 c4 1c             	add    $0x1c,%esp
  80019b:	5b                   	pop    %ebx
  80019c:	5e                   	pop    %esi
  80019d:	5f                   	pop    %edi
  80019e:	5d                   	pop    %ebp
  80019f:	c3                   	ret    

008001a0 <gettoken>:

int
gettoken(char *s, char **p1)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 18             	sub    $0x18,%esp
  8001a6:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  8001a9:	85 c0                	test   %eax,%eax
  8001ab:	74 24                	je     8001d1 <gettoken+0x31>
		nc = _gettoken(s, &np1, &np2);
  8001ad:	c7 44 24 08 0c 60 80 	movl   $0x80600c,0x8(%esp)
  8001b4:	00 
  8001b5:	c7 44 24 04 10 60 80 	movl   $0x806010,0x4(%esp)
  8001bc:	00 
  8001bd:	89 04 24             	mov    %eax,(%esp)
  8001c0:	e8 7b fe ff ff       	call   800040 <_gettoken>
  8001c5:	a3 08 60 80 00       	mov    %eax,0x806008
		return 0;
  8001ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cf:	eb 3c                	jmp    80020d <gettoken+0x6d>
	}
	c = nc;
  8001d1:	a1 08 60 80 00       	mov    0x806008,%eax
  8001d6:	a3 04 60 80 00       	mov    %eax,0x806004
	*p1 = np1;
  8001db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001de:	8b 15 10 60 80 00    	mov    0x806010,%edx
  8001e4:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001e6:	c7 44 24 08 0c 60 80 	movl   $0x80600c,0x8(%esp)
  8001ed:	00 
  8001ee:	c7 44 24 04 10 60 80 	movl   $0x806010,0x4(%esp)
  8001f5:	00 
  8001f6:	a1 0c 60 80 00       	mov    0x80600c,%eax
  8001fb:	89 04 24             	mov    %eax,(%esp)
  8001fe:	e8 3d fe ff ff       	call   800040 <_gettoken>
  800203:	a3 08 60 80 00       	mov    %eax,0x806008
	return c;
  800208:	a1 04 60 80 00       	mov    0x806004,%eax
}
  80020d:	c9                   	leave  
  80020e:	c3                   	ret    

0080020f <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	57                   	push   %edi
  800213:	56                   	push   %esi
  800214:	53                   	push   %ebx
  800215:	81 ec 6c 04 00 00    	sub    $0x46c,%esp
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
	gettoken(s, 0);
  80021b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800222:	00 
  800223:	8b 45 08             	mov    0x8(%ebp),%eax
  800226:	89 04 24             	mov    %eax,(%esp)
  800229:	e8 72 ff ff ff       	call   8001a0 <gettoken>

again:
	argc = 0;
  80022e:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		switch ((c = gettoken(0, &t))) {
  800233:	8d 5d a4             	lea    -0x5c(%ebp),%ebx
  800236:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80023a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800241:	e8 5a ff ff ff       	call   8001a0 <gettoken>
  800246:	83 f8 3e             	cmp    $0x3e,%eax
  800249:	0f 84 d1 00 00 00    	je     800320 <runcmd+0x111>
  80024f:	83 f8 3e             	cmp    $0x3e,%eax
  800252:	7f 13                	jg     800267 <runcmd+0x58>
  800254:	85 c0                	test   %eax,%eax
  800256:	0f 84 52 02 00 00    	je     8004ae <runcmd+0x29f>
  80025c:	83 f8 3c             	cmp    $0x3c,%eax
  80025f:	90                   	nop
  800260:	74 3d                	je     80029f <runcmd+0x90>
  800262:	e9 27 02 00 00       	jmp    80048e <runcmd+0x27f>
  800267:	83 f8 77             	cmp    $0x77,%eax
  80026a:	74 0f                	je     80027b <runcmd+0x6c>
  80026c:	83 f8 7c             	cmp    $0x7c,%eax
  80026f:	90                   	nop
  800270:	0f 84 2b 01 00 00    	je     8003a1 <runcmd+0x192>
  800276:	e9 13 02 00 00       	jmp    80048e <runcmd+0x27f>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  80027b:	83 fe 10             	cmp    $0x10,%esi
  80027e:	66 90                	xchg   %ax,%ax
  800280:	75 11                	jne    800293 <runcmd+0x84>
				cprintf("too many arguments\n");
  800282:	c7 04 24 45 41 80 00 	movl   $0x804145,(%esp)
  800289:	e8 d2 08 00 00       	call   800b60 <cprintf>
				exit();
  80028e:	e8 bb 07 00 00       	call   800a4e <exit>
			}
			argv[argc++] = t;
  800293:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800296:	89 44 b5 a8          	mov    %eax,-0x58(%ebp,%esi,4)
  80029a:	8d 76 01             	lea    0x1(%esi),%esi
			break;
  80029d:	eb 97                	jmp    800236 <runcmd+0x27>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  80029f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002aa:	e8 f1 fe ff ff       	call   8001a0 <gettoken>
  8002af:	83 f8 77             	cmp    $0x77,%eax
  8002b2:	74 11                	je     8002c5 <runcmd+0xb6>
				cprintf("syntax error: < not followed by word\n");
  8002b4:	c7 04 24 9c 42 80 00 	movl   $0x80429c,(%esp)
  8002bb:	e8 a0 08 00 00       	call   800b60 <cprintf>
				exit();
  8002c0:	e8 89 07 00 00       	call   800a4e <exit>
			// then check whether 'fd' is 0.
			// If not, dup 'fd' onto file descriptor 0,
			// then close the original 'fd'.

			// LAB 5: Your code here.
			if ((fd = open(t, O_RDONLY)) < 0) {
  8002c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002cc:	00 
  8002cd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002d0:	89 04 24             	mov    %eax,(%esp)
  8002d3:	e8 a7 24 00 00       	call   80277f <open>
  8002d8:	89 c7                	mov    %eax,%edi
  8002da:	85 c0                	test   %eax,%eax
  8002dc:	79 1c                	jns    8002fa <runcmd+0xeb>
				cprintf("open %s for reading: %e", t, fd);
  8002de:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002e2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e9:	c7 04 24 59 41 80 00 	movl   $0x804159,(%esp)
  8002f0:	e8 6b 08 00 00       	call   800b60 <cprintf>
				exit();
  8002f5:	e8 54 07 00 00       	call   800a4e <exit>
			}
			if (fd != 1) {
  8002fa:	83 ff 01             	cmp    $0x1,%edi
  8002fd:	0f 84 33 ff ff ff    	je     800236 <runcmd+0x27>
				dup(fd, 0);
  800303:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80030a:	00 
  80030b:	89 3c 24             	mov    %edi,(%esp)
  80030e:	e8 29 1e 00 00       	call   80213c <dup>
				close(fd);
  800313:	89 3c 24             	mov    %edi,(%esp)
  800316:	e8 cc 1d 00 00       	call   8020e7 <close>
  80031b:	e9 16 ff ff ff       	jmp    800236 <runcmd+0x27>
			}
			break;

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  800320:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800324:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80032b:	e8 70 fe ff ff       	call   8001a0 <gettoken>
  800330:	83 f8 77             	cmp    $0x77,%eax
  800333:	74 11                	je     800346 <runcmd+0x137>
				cprintf("syntax error: > not followed by word\n");
  800335:	c7 04 24 c4 42 80 00 	movl   $0x8042c4,(%esp)
  80033c:	e8 1f 08 00 00       	call   800b60 <cprintf>
				exit();
  800341:	e8 08 07 00 00       	call   800a4e <exit>
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800346:	c7 44 24 04 01 03 00 	movl   $0x301,0x4(%esp)
  80034d:	00 
  80034e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800351:	89 04 24             	mov    %eax,(%esp)
  800354:	e8 26 24 00 00       	call   80277f <open>
  800359:	89 c7                	mov    %eax,%edi
  80035b:	85 c0                	test   %eax,%eax
  80035d:	79 1c                	jns    80037b <runcmd+0x16c>
				cprintf("open %s for write: %e", t, fd);
  80035f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800363:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800366:	89 44 24 04          	mov    %eax,0x4(%esp)
  80036a:	c7 04 24 71 41 80 00 	movl   $0x804171,(%esp)
  800371:	e8 ea 07 00 00       	call   800b60 <cprintf>
				exit();
  800376:	e8 d3 06 00 00       	call   800a4e <exit>
			}
			if (fd != 1) {
  80037b:	83 ff 01             	cmp    $0x1,%edi
  80037e:	0f 84 b2 fe ff ff    	je     800236 <runcmd+0x27>
				dup(fd, 1);
  800384:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80038b:	00 
  80038c:	89 3c 24             	mov    %edi,(%esp)
  80038f:	e8 a8 1d 00 00       	call   80213c <dup>
				close(fd);
  800394:	89 3c 24             	mov    %edi,(%esp)
  800397:	e8 4b 1d 00 00       	call   8020e7 <close>
  80039c:	e9 95 fe ff ff       	jmp    800236 <runcmd+0x27>
			}
			break;

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8003a1:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  8003a7:	89 04 24             	mov    %eax,(%esp)
  8003aa:	e8 95 36 00 00       	call   803a44 <pipe>
  8003af:	85 c0                	test   %eax,%eax
  8003b1:	79 15                	jns    8003c8 <runcmd+0x1b9>
				cprintf("pipe: %e", r);
  8003b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b7:	c7 04 24 87 41 80 00 	movl   $0x804187,(%esp)
  8003be:	e8 9d 07 00 00       	call   800b60 <cprintf>
				exit();
  8003c3:	e8 86 06 00 00       	call   800a4e <exit>
			}
			if (debug)
  8003c8:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8003cf:	74 20                	je     8003f1 <runcmd+0x1e2>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  8003d1:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  8003d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003db:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8003e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e5:	c7 04 24 90 41 80 00 	movl   $0x804190,(%esp)
  8003ec:	e8 6f 07 00 00       	call   800b60 <cprintf>
			if ((r = fork()) < 0) {
  8003f1:	e8 ea 16 00 00       	call   801ae0 <fork>
  8003f6:	89 c7                	mov    %eax,%edi
  8003f8:	85 c0                	test   %eax,%eax
  8003fa:	79 15                	jns    800411 <runcmd+0x202>
				cprintf("fork: %e", r);
  8003fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800400:	c7 04 24 9d 41 80 00 	movl   $0x80419d,(%esp)
  800407:	e8 54 07 00 00       	call   800b60 <cprintf>
				exit();
  80040c:	e8 3d 06 00 00       	call   800a4e <exit>
			}
			if (r == 0) {
  800411:	85 ff                	test   %edi,%edi
  800413:	75 40                	jne    800455 <runcmd+0x246>
				if (p[0] != 0) {
  800415:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  80041b:	85 c0                	test   %eax,%eax
  80041d:	74 1e                	je     80043d <runcmd+0x22e>
					dup(p[0], 0);
  80041f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800426:	00 
  800427:	89 04 24             	mov    %eax,(%esp)
  80042a:	e8 0d 1d 00 00       	call   80213c <dup>
					close(p[0]);
  80042f:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800435:	89 04 24             	mov    %eax,(%esp)
  800438:	e8 aa 1c 00 00       	call   8020e7 <close>
				}
				close(p[1]);
  80043d:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800443:	89 04 24             	mov    %eax,(%esp)
  800446:	e8 9c 1c 00 00       	call   8020e7 <close>

	pipe_child = 0;
	gettoken(s, 0);

again:
	argc = 0;
  80044b:	be 00 00 00 00       	mov    $0x0,%esi
				if (p[0] != 0) {
					dup(p[0], 0);
					close(p[0]);
				}
				close(p[1]);
				goto again;
  800450:	e9 e1 fd ff ff       	jmp    800236 <runcmd+0x27>
			} else {
				pipe_child = r;
				if (p[1] != 1) {
  800455:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80045b:	83 f8 01             	cmp    $0x1,%eax
  80045e:	74 1e                	je     80047e <runcmd+0x26f>
					dup(p[1], 1);
  800460:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800467:	00 
  800468:	89 04 24             	mov    %eax,(%esp)
  80046b:	e8 cc 1c 00 00       	call   80213c <dup>
					close(p[1]);
  800470:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800476:	89 04 24             	mov    %eax,(%esp)
  800479:	e8 69 1c 00 00       	call   8020e7 <close>
				}
				close(p[0]);
  80047e:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800484:	89 04 24             	mov    %eax,(%esp)
  800487:	e8 5b 1c 00 00       	call   8020e7 <close>
				goto runit;
  80048c:	eb 25                	jmp    8004b3 <runcmd+0x2a4>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  80048e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800492:	c7 44 24 08 a6 41 80 	movl   $0x8041a6,0x8(%esp)
  800499:	00 
  80049a:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
  8004a1:	00 
  8004a2:	c7 04 24 c2 41 80 00 	movl   $0x8041c2,(%esp)
  8004a9:	e8 b9 05 00 00       	call   800a67 <_panic>
runcmd(char* s)
{
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
  8004ae:	bf 00 00 00 00       	mov    $0x0,%edi
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  8004b3:	85 f6                	test   %esi,%esi
  8004b5:	75 1e                	jne    8004d5 <runcmd+0x2c6>
		if (debug)
  8004b7:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004be:	0f 84 85 01 00 00    	je     800649 <runcmd+0x43a>
			cprintf("EMPTY COMMAND\n");
  8004c4:	c7 04 24 cc 41 80 00 	movl   $0x8041cc,(%esp)
  8004cb:	e8 90 06 00 00       	call   800b60 <cprintf>
  8004d0:	e9 74 01 00 00       	jmp    800649 <runcmd+0x43a>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  8004d5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004d8:	80 38 2f             	cmpb   $0x2f,(%eax)
  8004db:	74 22                	je     8004ff <runcmd+0x2f0>
		argv0buf[0] = '/';
  8004dd:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  8004e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004e8:	8d 9d a4 fb ff ff    	lea    -0x45c(%ebp),%ebx
  8004ee:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  8004f4:	89 04 24             	mov    %eax,(%esp)
  8004f7:	e8 7b 0d 00 00       	call   801277 <strcpy>
		argv[0] = argv0buf;
  8004fc:	89 5d a8             	mov    %ebx,-0x58(%ebp)
	}
	argv[argc] = 0;
  8004ff:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
  800506:	00 

	// Print the command.
	if (debug) {
  800507:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80050e:	74 43                	je     800553 <runcmd+0x344>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  800510:	a1 28 64 80 00       	mov    0x806428,%eax
  800515:	8b 40 48             	mov    0x48(%eax),%eax
  800518:	89 44 24 04          	mov    %eax,0x4(%esp)
  80051c:	c7 04 24 db 41 80 00 	movl   $0x8041db,(%esp)
  800523:	e8 38 06 00 00       	call   800b60 <cprintf>
  800528:	8d 5d a8             	lea    -0x58(%ebp),%ebx
		for (i = 0; argv[i]; i++)
  80052b:	eb 10                	jmp    80053d <runcmd+0x32e>
			cprintf(" %s", argv[i]);
  80052d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800531:	c7 04 24 66 42 80 00 	movl   $0x804266,(%esp)
  800538:	e8 23 06 00 00       	call   800b60 <cprintf>
  80053d:	83 c3 04             	add    $0x4,%ebx
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
  800540:	8b 43 fc             	mov    -0x4(%ebx),%eax
  800543:	85 c0                	test   %eax,%eax
  800545:	75 e6                	jne    80052d <runcmd+0x31e>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  800547:	c7 04 24 20 41 80 00 	movl   $0x804120,(%esp)
  80054e:	e8 0d 06 00 00       	call   800b60 <cprintf>
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800553:	8d 45 a8             	lea    -0x58(%ebp),%eax
  800556:	89 44 24 04          	mov    %eax,0x4(%esp)
  80055a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80055d:	89 04 24             	mov    %eax,(%esp)
  800560:	e8 41 25 00 00       	call   802aa6 <spawn>
  800565:	89 c3                	mov    %eax,%ebx
  800567:	85 c0                	test   %eax,%eax
  800569:	0f 89 c3 00 00 00    	jns    800632 <runcmd+0x423>
		cprintf("spawn %s: %e\n", argv[0], r);
  80056f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800573:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800576:	89 44 24 04          	mov    %eax,0x4(%esp)
  80057a:	c7 04 24 e9 41 80 00 	movl   $0x8041e9,(%esp)
  800581:	e8 da 05 00 00       	call   800b60 <cprintf>

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  800586:	e8 8f 1b 00 00       	call   80211a <close_all>
  80058b:	eb 4c                	jmp    8005d9 <runcmd+0x3ca>
	if (r >= 0) {
		if (debug)
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  80058d:	a1 28 64 80 00       	mov    0x806428,%eax
  800592:	8b 40 48             	mov    0x48(%eax),%eax
  800595:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800599:	8b 55 a8             	mov    -0x58(%ebp),%edx
  80059c:	89 54 24 08          	mov    %edx,0x8(%esp)
  8005a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005a4:	c7 04 24 f7 41 80 00 	movl   $0x8041f7,(%esp)
  8005ab:	e8 b0 05 00 00       	call   800b60 <cprintf>
		wait(r);
  8005b0:	89 1c 24             	mov    %ebx,(%esp)
  8005b3:	e8 32 36 00 00       	call   803bea <wait>
		if (debug)
  8005b8:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8005bf:	74 18                	je     8005d9 <runcmd+0x3ca>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8005c1:	a1 28 64 80 00       	mov    0x806428,%eax
  8005c6:	8b 40 48             	mov    0x48(%eax),%eax
  8005c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005cd:	c7 04 24 0c 42 80 00 	movl   $0x80420c,(%esp)
  8005d4:	e8 87 05 00 00       	call   800b60 <cprintf>
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  8005d9:	85 ff                	test   %edi,%edi
  8005db:	74 4e                	je     80062b <runcmd+0x41c>
		if (debug)
  8005dd:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8005e4:	74 1c                	je     800602 <runcmd+0x3f3>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  8005e6:	a1 28 64 80 00       	mov    0x806428,%eax
  8005eb:	8b 40 48             	mov    0x48(%eax),%eax
  8005ee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8005f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005f6:	c7 04 24 22 42 80 00 	movl   $0x804222,(%esp)
  8005fd:	e8 5e 05 00 00       	call   800b60 <cprintf>
		wait(pipe_child);
  800602:	89 3c 24             	mov    %edi,(%esp)
  800605:	e8 e0 35 00 00       	call   803bea <wait>
		if (debug)
  80060a:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800611:	74 18                	je     80062b <runcmd+0x41c>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  800613:	a1 28 64 80 00       	mov    0x806428,%eax
  800618:	8b 40 48             	mov    0x48(%eax),%eax
  80061b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80061f:	c7 04 24 0c 42 80 00 	movl   $0x80420c,(%esp)
  800626:	e8 35 05 00 00       	call   800b60 <cprintf>
	}

	// Done!
	exit();
  80062b:	e8 1e 04 00 00       	call   800a4e <exit>
  800630:	eb 17                	jmp    800649 <runcmd+0x43a>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
		cprintf("spawn %s: %e\n", argv[0], r);

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  800632:	e8 e3 1a 00 00       	call   80211a <close_all>
	if (r >= 0) {
		if (debug)
  800637:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80063e:	0f 84 6c ff ff ff    	je     8005b0 <runcmd+0x3a1>
  800644:	e9 44 ff ff ff       	jmp    80058d <runcmd+0x37e>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
	}

	// Done!
	exit();
}
  800649:	81 c4 6c 04 00 00    	add    $0x46c,%esp
  80064f:	5b                   	pop    %ebx
  800650:	5e                   	pop    %esi
  800651:	5f                   	pop    %edi
  800652:	5d                   	pop    %ebp
  800653:	c3                   	ret    

00800654 <usage>:
}


void
usage(void)
{
  800654:	55                   	push   %ebp
  800655:	89 e5                	mov    %esp,%ebp
  800657:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  80065a:	c7 04 24 ec 42 80 00 	movl   $0x8042ec,(%esp)
  800661:	e8 fa 04 00 00       	call   800b60 <cprintf>
	exit();
  800666:	e8 e3 03 00 00       	call   800a4e <exit>
}
  80066b:	c9                   	leave  
  80066c:	c3                   	ret    

0080066d <umain>:

void
umain(int argc, char **argv)
{
  80066d:	55                   	push   %ebp
  80066e:	89 e5                	mov    %esp,%ebp
  800670:	57                   	push   %edi
  800671:	56                   	push   %esi
  800672:	53                   	push   %ebx
  800673:	83 ec 3c             	sub    $0x3c,%esp
  800676:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  800679:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80067c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800680:	89 74 24 04          	mov    %esi,0x4(%esp)
  800684:	8d 45 08             	lea    0x8(%ebp),%eax
  800687:	89 04 24             	mov    %eax,(%esp)
  80068a:	e8 45 17 00 00       	call   801dd4 <argstart>
{
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
  80068f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
umain(int argc, char **argv)
{
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
  800696:	bf 3f 00 00 00       	mov    $0x3f,%edi
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  80069b:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  80069e:	eb 30                	jmp    8006d0 <umain+0x63>
		switch (r) {
  8006a0:	83 f8 69             	cmp    $0x69,%eax
  8006a3:	74 0d                	je     8006b2 <umain+0x45>
  8006a5:	83 f8 78             	cmp    $0x78,%eax
  8006a8:	74 1f                	je     8006c9 <umain+0x5c>
  8006aa:	83 f8 64             	cmp    $0x64,%eax
  8006ad:	75 13                	jne    8006c2 <umain+0x55>
  8006af:	90                   	nop
  8006b0:	eb 07                	jmp    8006b9 <umain+0x4c>
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  8006b2:	bf 01 00 00 00       	mov    $0x1,%edi
  8006b7:	eb 17                	jmp    8006d0 <umain+0x63>
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
		switch (r) {
		case 'd':
			debug++;
  8006b9:	83 05 00 60 80 00 01 	addl   $0x1,0x806000
			break;
  8006c0:	eb 0e                	jmp    8006d0 <umain+0x63>
			break;
		case 'x':
			echocmds = 1;
			break;
		default:
			usage();
  8006c2:	e8 8d ff ff ff       	call   800654 <usage>
  8006c7:	eb 07                	jmp    8006d0 <umain+0x63>
			break;
		case 'i':
			interactive = 1;
			break;
		case 'x':
			echocmds = 1;
  8006c9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  8006d0:	89 1c 24             	mov    %ebx,(%esp)
  8006d3:	e8 34 17 00 00       	call   801e0c <argnext>
  8006d8:	85 c0                	test   %eax,%eax
  8006da:	79 c4                	jns    8006a0 <umain+0x33>
  8006dc:	89 fb                	mov    %edi,%ebx
			break;
		default:
			usage();
		}

	if (argc > 2)
  8006de:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006e2:	7e 05                	jle    8006e9 <umain+0x7c>
		usage();
  8006e4:	e8 6b ff ff ff       	call   800654 <usage>
	if (argc == 2) {
  8006e9:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006ed:	75 72                	jne    800761 <umain+0xf4>
		close(0);
  8006ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8006f6:	e8 ec 19 00 00       	call   8020e7 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  8006fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800702:	00 
  800703:	8b 46 04             	mov    0x4(%esi),%eax
  800706:	89 04 24             	mov    %eax,(%esp)
  800709:	e8 71 20 00 00       	call   80277f <open>
  80070e:	85 c0                	test   %eax,%eax
  800710:	79 27                	jns    800739 <umain+0xcc>
			panic("open %s: %e", argv[1], r);
  800712:	89 44 24 10          	mov    %eax,0x10(%esp)
  800716:	8b 46 04             	mov    0x4(%esi),%eax
  800719:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80071d:	c7 44 24 08 42 42 80 	movl   $0x804242,0x8(%esp)
  800724:	00 
  800725:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  80072c:	00 
  80072d:	c7 04 24 c2 41 80 00 	movl   $0x8041c2,(%esp)
  800734:	e8 2e 03 00 00       	call   800a67 <_panic>
		assert(r == 0);
  800739:	85 c0                	test   %eax,%eax
  80073b:	74 24                	je     800761 <umain+0xf4>
  80073d:	c7 44 24 0c 4e 42 80 	movl   $0x80424e,0xc(%esp)
  800744:	00 
  800745:	c7 44 24 08 55 42 80 	movl   $0x804255,0x8(%esp)
  80074c:	00 
  80074d:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  800754:	00 
  800755:	c7 04 24 c2 41 80 00 	movl   $0x8041c2,(%esp)
  80075c:	e8 06 03 00 00       	call   800a67 <_panic>
	}
	if (interactive == '?')
  800761:	83 fb 3f             	cmp    $0x3f,%ebx
  800764:	75 0e                	jne    800774 <umain+0x107>
		interactive = iscons(0);
  800766:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80076d:	e8 0a 02 00 00       	call   80097c <iscons>
  800772:	89 c7                	mov    %eax,%edi

	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
  800774:	85 ff                	test   %edi,%edi
  800776:	b8 00 00 00 00       	mov    $0x0,%eax
  80077b:	ba 3f 42 80 00       	mov    $0x80423f,%edx
  800780:	0f 45 c2             	cmovne %edx,%eax
  800783:	89 04 24             	mov    %eax,(%esp)
  800786:	e8 c5 09 00 00       	call   801150 <readline>
  80078b:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  80078d:	85 c0                	test   %eax,%eax
  80078f:	75 1a                	jne    8007ab <umain+0x13e>
			if (debug)
  800791:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800798:	74 0c                	je     8007a6 <umain+0x139>
				cprintf("EXITING\n");
  80079a:	c7 04 24 6a 42 80 00 	movl   $0x80426a,(%esp)
  8007a1:	e8 ba 03 00 00       	call   800b60 <cprintf>
			exit();	// end of file
  8007a6:	e8 a3 02 00 00       	call   800a4e <exit>
		}
		if (debug)
  8007ab:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007b2:	74 10                	je     8007c4 <umain+0x157>
			cprintf("LINE: %s\n", buf);
  8007b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007b8:	c7 04 24 73 42 80 00 	movl   $0x804273,(%esp)
  8007bf:	e8 9c 03 00 00       	call   800b60 <cprintf>
		if (buf[0] == '#')
  8007c4:	80 3b 23             	cmpb   $0x23,(%ebx)
  8007c7:	74 ab                	je     800774 <umain+0x107>
			continue;
		if (echocmds)
  8007c9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007cd:	74 10                	je     8007df <umain+0x172>
			printf("# %s\n", buf);
  8007cf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007d3:	c7 04 24 7d 42 80 00 	movl   $0x80427d,(%esp)
  8007da:	e8 50 21 00 00       	call   80292f <printf>
		if (debug)
  8007df:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007e6:	74 0c                	je     8007f4 <umain+0x187>
			cprintf("BEFORE FORK\n");
  8007e8:	c7 04 24 83 42 80 00 	movl   $0x804283,(%esp)
  8007ef:	e8 6c 03 00 00       	call   800b60 <cprintf>
		if ((r = fork()) < 0)
  8007f4:	e8 e7 12 00 00       	call   801ae0 <fork>
  8007f9:	89 c6                	mov    %eax,%esi
  8007fb:	85 c0                	test   %eax,%eax
  8007fd:	79 20                	jns    80081f <umain+0x1b2>
			panic("fork: %e", r);
  8007ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800803:	c7 44 24 08 9d 41 80 	movl   $0x80419d,0x8(%esp)
  80080a:	00 
  80080b:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
  800812:	00 
  800813:	c7 04 24 c2 41 80 00 	movl   $0x8041c2,(%esp)
  80081a:	e8 48 02 00 00       	call   800a67 <_panic>
		if (debug)
  80081f:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800826:	74 10                	je     800838 <umain+0x1cb>
			cprintf("FORK: %d\n", r);
  800828:	89 44 24 04          	mov    %eax,0x4(%esp)
  80082c:	c7 04 24 90 42 80 00 	movl   $0x804290,(%esp)
  800833:	e8 28 03 00 00       	call   800b60 <cprintf>
		if (r == 0) {
  800838:	85 f6                	test   %esi,%esi
  80083a:	75 12                	jne    80084e <umain+0x1e1>
			runcmd(buf);
  80083c:	89 1c 24             	mov    %ebx,(%esp)
  80083f:	e8 cb f9 ff ff       	call   80020f <runcmd>
			exit();
  800844:	e8 05 02 00 00       	call   800a4e <exit>
  800849:	e9 26 ff ff ff       	jmp    800774 <umain+0x107>
		} else
			wait(r);
  80084e:	89 34 24             	mov    %esi,(%esp)
  800851:	e8 94 33 00 00       	call   803bea <wait>
  800856:	e9 19 ff ff ff       	jmp    800774 <umain+0x107>
  80085b:	66 90                	xchg   %ax,%ax
  80085d:	66 90                	xchg   %ax,%ax
  80085f:	90                   	nop

00800860 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800863:	b8 00 00 00 00       	mov    $0x0,%eax
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800870:	c7 44 24 04 0d 43 80 	movl   $0x80430d,0x4(%esp)
  800877:	00 
  800878:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087b:	89 04 24             	mov    %eax,(%esp)
  80087e:	e8 f4 09 00 00       	call   801277 <strcpy>
	return 0;
}
  800883:	b8 00 00 00 00       	mov    $0x0,%eax
  800888:	c9                   	leave  
  800889:	c3                   	ret    

0080088a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	57                   	push   %edi
  80088e:	56                   	push   %esi
  80088f:	53                   	push   %ebx
  800890:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800896:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80089b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8008a1:	eb 31                	jmp    8008d4 <devcons_write+0x4a>
		m = n - tot;
  8008a3:	8b 75 10             	mov    0x10(%ebp),%esi
  8008a6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8008a8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8008ab:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8008b0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8008b3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8008b7:	03 45 0c             	add    0xc(%ebp),%eax
  8008ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008be:	89 3c 24             	mov    %edi,(%esp)
  8008c1:	e8 4e 0b 00 00       	call   801414 <memmove>
		sys_cputs(buf, m);
  8008c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008ca:	89 3c 24             	mov    %edi,(%esp)
  8008cd:	e8 f4 0c 00 00       	call   8015c6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8008d2:	01 f3                	add    %esi,%ebx
  8008d4:	89 d8                	mov    %ebx,%eax
  8008d6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8008d9:	72 c8                	jb     8008a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8008db:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8008e1:	5b                   	pop    %ebx
  8008e2:	5e                   	pop    %esi
  8008e3:	5f                   	pop    %edi
  8008e4:	5d                   	pop    %ebp
  8008e5:	c3                   	ret    

008008e6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8008ec:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8008f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8008f5:	75 07                	jne    8008fe <devcons_read+0x18>
  8008f7:	eb 2a                	jmp    800923 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8008f9:	e8 76 0d 00 00       	call   801674 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8008fe:	66 90                	xchg   %ax,%ax
  800900:	e8 df 0c 00 00       	call   8015e4 <sys_cgetc>
  800905:	85 c0                	test   %eax,%eax
  800907:	74 f0                	je     8008f9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800909:	85 c0                	test   %eax,%eax
  80090b:	78 16                	js     800923 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80090d:	83 f8 04             	cmp    $0x4,%eax
  800910:	74 0c                	je     80091e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  800912:	8b 55 0c             	mov    0xc(%ebp),%edx
  800915:	88 02                	mov    %al,(%edx)
	return 1;
  800917:	b8 01 00 00 00       	mov    $0x1,%eax
  80091c:	eb 05                	jmp    800923 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80091e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800923:	c9                   	leave  
  800924:	c3                   	ret    

00800925 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800925:	55                   	push   %ebp
  800926:	89 e5                	mov    %esp,%ebp
  800928:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800931:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800938:	00 
  800939:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80093c:	89 04 24             	mov    %eax,(%esp)
  80093f:	e8 82 0c 00 00       	call   8015c6 <sys_cputs>
}
  800944:	c9                   	leave  
  800945:	c3                   	ret    

00800946 <getchar>:

int
getchar(void)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80094c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800953:	00 
  800954:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800957:	89 44 24 04          	mov    %eax,0x4(%esp)
  80095b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800962:	e8 e3 18 00 00       	call   80224a <read>
	if (r < 0)
  800967:	85 c0                	test   %eax,%eax
  800969:	78 0f                	js     80097a <getchar+0x34>
		return r;
	if (r < 1)
  80096b:	85 c0                	test   %eax,%eax
  80096d:	7e 06                	jle    800975 <getchar+0x2f>
		return -E_EOF;
	return c;
  80096f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800973:	eb 05                	jmp    80097a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800975:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80097a:	c9                   	leave  
  80097b:	c3                   	ret    

0080097c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800982:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800985:	89 44 24 04          	mov    %eax,0x4(%esp)
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	89 04 24             	mov    %eax,(%esp)
  80098f:	e8 22 16 00 00       	call   801fb6 <fd_lookup>
  800994:	85 c0                	test   %eax,%eax
  800996:	78 11                	js     8009a9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80099b:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8009a1:	39 10                	cmp    %edx,(%eax)
  8009a3:	0f 94 c0             	sete   %al
  8009a6:	0f b6 c0             	movzbl %al,%eax
}
  8009a9:	c9                   	leave  
  8009aa:	c3                   	ret    

008009ab <opencons>:

int
opencons(void)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8009b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009b4:	89 04 24             	mov    %eax,(%esp)
  8009b7:	e8 ab 15 00 00       	call   801f67 <fd_alloc>
		return r;
  8009bc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8009be:	85 c0                	test   %eax,%eax
  8009c0:	78 40                	js     800a02 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8009c9:	00 
  8009ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8009d8:	e8 b6 0c 00 00       	call   801693 <sys_page_alloc>
		return r;
  8009dd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009df:	85 c0                	test   %eax,%eax
  8009e1:	78 1f                	js     800a02 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8009e3:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8009e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8009ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8009f8:	89 04 24             	mov    %eax,(%esp)
  8009fb:	e8 40 15 00 00       	call   801f40 <fd2num>
  800a00:	89 c2                	mov    %eax,%edx
}
  800a02:	89 d0                	mov    %edx,%eax
  800a04:	c9                   	leave  
  800a05:	c3                   	ret    

00800a06 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	56                   	push   %esi
  800a0a:	53                   	push   %ebx
  800a0b:	83 ec 10             	sub    $0x10,%esp
  800a0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a11:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800a14:	e8 3c 0c 00 00       	call   801655 <sys_getenvid>
  800a19:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a1e:	c1 e0 07             	shl    $0x7,%eax
  800a21:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800a26:	a3 28 64 80 00       	mov    %eax,0x806428

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a2b:	85 db                	test   %ebx,%ebx
  800a2d:	7e 07                	jle    800a36 <libmain+0x30>
		binaryname = argv[0];
  800a2f:	8b 06                	mov    (%esi),%eax
  800a31:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// call user main routine
	umain(argc, argv);
  800a36:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a3a:	89 1c 24             	mov    %ebx,(%esp)
  800a3d:	e8 2b fc ff ff       	call   80066d <umain>

	// exit gracefully
	exit();
  800a42:	e8 07 00 00 00       	call   800a4e <exit>
}
  800a47:	83 c4 10             	add    $0x10,%esp
  800a4a:	5b                   	pop    %ebx
  800a4b:	5e                   	pop    %esi
  800a4c:	5d                   	pop    %ebp
  800a4d:	c3                   	ret    

00800a4e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800a54:	e8 c1 16 00 00       	call   80211a <close_all>
	sys_env_destroy(0);
  800a59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a60:	e8 9e 0b 00 00       	call   801603 <sys_env_destroy>
}
  800a65:	c9                   	leave  
  800a66:	c3                   	ret    

00800a67 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	56                   	push   %esi
  800a6b:	53                   	push   %ebx
  800a6c:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800a6f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800a72:	8b 35 1c 50 80 00    	mov    0x80501c,%esi
  800a78:	e8 d8 0b 00 00       	call   801655 <sys_getenvid>
  800a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a80:	89 54 24 10          	mov    %edx,0x10(%esp)
  800a84:	8b 55 08             	mov    0x8(%ebp),%edx
  800a87:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a8b:	89 74 24 08          	mov    %esi,0x8(%esp)
  800a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a93:	c7 04 24 24 43 80 00 	movl   $0x804324,(%esp)
  800a9a:	e8 c1 00 00 00       	call   800b60 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800a9f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800aa3:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa6:	89 04 24             	mov    %eax,(%esp)
  800aa9:	e8 51 00 00 00       	call   800aff <vcprintf>
	cprintf("\n");
  800aae:	c7 04 24 20 41 80 00 	movl   $0x804120,(%esp)
  800ab5:	e8 a6 00 00 00       	call   800b60 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800aba:	cc                   	int3   
  800abb:	eb fd                	jmp    800aba <_panic+0x53>

00800abd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	53                   	push   %ebx
  800ac1:	83 ec 14             	sub    $0x14,%esp
  800ac4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800ac7:	8b 13                	mov    (%ebx),%edx
  800ac9:	8d 42 01             	lea    0x1(%edx),%eax
  800acc:	89 03                	mov    %eax,(%ebx)
  800ace:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ad1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800ad5:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ada:	75 19                	jne    800af5 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800adc:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800ae3:	00 
  800ae4:	8d 43 08             	lea    0x8(%ebx),%eax
  800ae7:	89 04 24             	mov    %eax,(%esp)
  800aea:	e8 d7 0a 00 00       	call   8015c6 <sys_cputs>
		b->idx = 0;
  800aef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800af5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800af9:	83 c4 14             	add    $0x14,%esp
  800afc:	5b                   	pop    %ebx
  800afd:	5d                   	pop    %ebp
  800afe:	c3                   	ret    

00800aff <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800b08:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b0f:	00 00 00 
	b.cnt = 0;
  800b12:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b19:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b23:	8b 45 08             	mov    0x8(%ebp),%eax
  800b26:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b2a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b30:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b34:	c7 04 24 bd 0a 80 00 	movl   $0x800abd,(%esp)
  800b3b:	e8 ae 01 00 00       	call   800cee <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b40:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800b46:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b4a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b50:	89 04 24             	mov    %eax,(%esp)
  800b53:	e8 6e 0a 00 00       	call   8015c6 <sys_cputs>

	return b.cnt;
}
  800b58:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b5e:	c9                   	leave  
  800b5f:	c3                   	ret    

00800b60 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b66:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800b69:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	89 04 24             	mov    %eax,(%esp)
  800b73:	e8 87 ff ff ff       	call   800aff <vcprintf>
	va_end(ap);

	return cnt;
}
  800b78:	c9                   	leave  
  800b79:	c3                   	ret    
  800b7a:	66 90                	xchg   %ax,%ax
  800b7c:	66 90                	xchg   %ax,%ax
  800b7e:	66 90                	xchg   %ax,%ax

00800b80 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	57                   	push   %edi
  800b84:	56                   	push   %esi
  800b85:	53                   	push   %ebx
  800b86:	83 ec 3c             	sub    $0x3c,%esp
  800b89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b8c:	89 d7                	mov    %edx,%edi
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b97:	89 c3                	mov    %eax,%ebx
  800b99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800b9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ba2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ba7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800baa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800bad:	39 d9                	cmp    %ebx,%ecx
  800baf:	72 05                	jb     800bb6 <printnum+0x36>
  800bb1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800bb4:	77 69                	ja     800c1f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bb6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bb9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800bbd:	83 ee 01             	sub    $0x1,%esi
  800bc0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800bc4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bc8:	8b 44 24 08          	mov    0x8(%esp),%eax
  800bcc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800bd0:	89 c3                	mov    %eax,%ebx
  800bd2:	89 d6                	mov    %edx,%esi
  800bd4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800bd7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800bda:	89 54 24 08          	mov    %edx,0x8(%esp)
  800bde:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800be2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800be5:	89 04 24             	mov    %eax,(%esp)
  800be8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800beb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bef:	e8 6c 32 00 00       	call   803e60 <__udivdi3>
  800bf4:	89 d9                	mov    %ebx,%ecx
  800bf6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800bfa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800bfe:	89 04 24             	mov    %eax,(%esp)
  800c01:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c05:	89 fa                	mov    %edi,%edx
  800c07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c0a:	e8 71 ff ff ff       	call   800b80 <printnum>
  800c0f:	eb 1b                	jmp    800c2c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c11:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c15:	8b 45 18             	mov    0x18(%ebp),%eax
  800c18:	89 04 24             	mov    %eax,(%esp)
  800c1b:	ff d3                	call   *%ebx
  800c1d:	eb 03                	jmp    800c22 <printnum+0xa2>
  800c1f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c22:	83 ee 01             	sub    $0x1,%esi
  800c25:	85 f6                	test   %esi,%esi
  800c27:	7f e8                	jg     800c11 <printnum+0x91>
  800c29:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c2c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c30:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800c34:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c37:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c3e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c45:	89 04 24             	mov    %eax,(%esp)
  800c48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c4f:	e8 3c 33 00 00       	call   803f90 <__umoddi3>
  800c54:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c58:	0f be 80 47 43 80 00 	movsbl 0x804347(%eax),%eax
  800c5f:	89 04 24             	mov    %eax,(%esp)
  800c62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c65:	ff d0                	call   *%eax
}
  800c67:	83 c4 3c             	add    $0x3c,%esp
  800c6a:	5b                   	pop    %ebx
  800c6b:	5e                   	pop    %esi
  800c6c:	5f                   	pop    %edi
  800c6d:	5d                   	pop    %ebp
  800c6e:	c3                   	ret    

00800c6f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c72:	83 fa 01             	cmp    $0x1,%edx
  800c75:	7e 0e                	jle    800c85 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800c77:	8b 10                	mov    (%eax),%edx
  800c79:	8d 4a 08             	lea    0x8(%edx),%ecx
  800c7c:	89 08                	mov    %ecx,(%eax)
  800c7e:	8b 02                	mov    (%edx),%eax
  800c80:	8b 52 04             	mov    0x4(%edx),%edx
  800c83:	eb 22                	jmp    800ca7 <getuint+0x38>
	else if (lflag)
  800c85:	85 d2                	test   %edx,%edx
  800c87:	74 10                	je     800c99 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800c89:	8b 10                	mov    (%eax),%edx
  800c8b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800c8e:	89 08                	mov    %ecx,(%eax)
  800c90:	8b 02                	mov    (%edx),%eax
  800c92:	ba 00 00 00 00       	mov    $0x0,%edx
  800c97:	eb 0e                	jmp    800ca7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800c99:	8b 10                	mov    (%eax),%edx
  800c9b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800c9e:	89 08                	mov    %ecx,(%eax)
  800ca0:	8b 02                	mov    (%edx),%eax
  800ca2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800caf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800cb3:	8b 10                	mov    (%eax),%edx
  800cb5:	3b 50 04             	cmp    0x4(%eax),%edx
  800cb8:	73 0a                	jae    800cc4 <sprintputch+0x1b>
		*b->buf++ = ch;
  800cba:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cbd:	89 08                	mov    %ecx,(%eax)
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	88 02                	mov    %al,(%edx)
}
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ccc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800ccf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cd3:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd6:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	89 04 24             	mov    %eax,(%esp)
  800ce7:	e8 02 00 00 00       	call   800cee <vprintfmt>
	va_end(ap);
}
  800cec:	c9                   	leave  
  800ced:	c3                   	ret    

00800cee <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	57                   	push   %edi
  800cf2:	56                   	push   %esi
  800cf3:	53                   	push   %ebx
  800cf4:	83 ec 3c             	sub    $0x3c,%esp
  800cf7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800cfa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cfd:	eb 14                	jmp    800d13 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800cff:	85 c0                	test   %eax,%eax
  800d01:	0f 84 b3 03 00 00    	je     8010ba <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800d07:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d0b:	89 04 24             	mov    %eax,(%esp)
  800d0e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d11:	89 f3                	mov    %esi,%ebx
  800d13:	8d 73 01             	lea    0x1(%ebx),%esi
  800d16:	0f b6 03             	movzbl (%ebx),%eax
  800d19:	83 f8 25             	cmp    $0x25,%eax
  800d1c:	75 e1                	jne    800cff <vprintfmt+0x11>
  800d1e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800d22:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800d29:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800d30:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800d37:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3c:	eb 1d                	jmp    800d5b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d3e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800d40:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800d44:	eb 15                	jmp    800d5b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d46:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d48:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800d4c:	eb 0d                	jmp    800d5b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800d4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d51:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d54:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d5b:	8d 5e 01             	lea    0x1(%esi),%ebx
  800d5e:	0f b6 0e             	movzbl (%esi),%ecx
  800d61:	0f b6 c1             	movzbl %cl,%eax
  800d64:	83 e9 23             	sub    $0x23,%ecx
  800d67:	80 f9 55             	cmp    $0x55,%cl
  800d6a:	0f 87 2a 03 00 00    	ja     80109a <vprintfmt+0x3ac>
  800d70:	0f b6 c9             	movzbl %cl,%ecx
  800d73:	ff 24 8d 80 44 80 00 	jmp    *0x804480(,%ecx,4)
  800d7a:	89 de                	mov    %ebx,%esi
  800d7c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800d81:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800d84:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800d88:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800d8b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800d8e:	83 fb 09             	cmp    $0x9,%ebx
  800d91:	77 36                	ja     800dc9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d93:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d96:	eb e9                	jmp    800d81 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d98:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9b:	8d 48 04             	lea    0x4(%eax),%ecx
  800d9e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800da1:	8b 00                	mov    (%eax),%eax
  800da3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800da6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800da8:	eb 22                	jmp    800dcc <vprintfmt+0xde>
  800daa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800dad:	85 c9                	test   %ecx,%ecx
  800daf:	b8 00 00 00 00       	mov    $0x0,%eax
  800db4:	0f 49 c1             	cmovns %ecx,%eax
  800db7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dba:	89 de                	mov    %ebx,%esi
  800dbc:	eb 9d                	jmp    800d5b <vprintfmt+0x6d>
  800dbe:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800dc0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800dc7:	eb 92                	jmp    800d5b <vprintfmt+0x6d>
  800dc9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  800dcc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dd0:	79 89                	jns    800d5b <vprintfmt+0x6d>
  800dd2:	e9 77 ff ff ff       	jmp    800d4e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dd7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dda:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800ddc:	e9 7a ff ff ff       	jmp    800d5b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800de1:	8b 45 14             	mov    0x14(%ebp),%eax
  800de4:	8d 50 04             	lea    0x4(%eax),%edx
  800de7:	89 55 14             	mov    %edx,0x14(%ebp)
  800dea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800dee:	8b 00                	mov    (%eax),%eax
  800df0:	89 04 24             	mov    %eax,(%esp)
  800df3:	ff 55 08             	call   *0x8(%ebp)
			break;
  800df6:	e9 18 ff ff ff       	jmp    800d13 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800dfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dfe:	8d 50 04             	lea    0x4(%eax),%edx
  800e01:	89 55 14             	mov    %edx,0x14(%ebp)
  800e04:	8b 00                	mov    (%eax),%eax
  800e06:	99                   	cltd   
  800e07:	31 d0                	xor    %edx,%eax
  800e09:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e0b:	83 f8 11             	cmp    $0x11,%eax
  800e0e:	7f 0b                	jg     800e1b <vprintfmt+0x12d>
  800e10:	8b 14 85 e0 45 80 00 	mov    0x8045e0(,%eax,4),%edx
  800e17:	85 d2                	test   %edx,%edx
  800e19:	75 20                	jne    800e3b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  800e1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e1f:	c7 44 24 08 5f 43 80 	movl   $0x80435f,0x8(%esp)
  800e26:	00 
  800e27:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	89 04 24             	mov    %eax,(%esp)
  800e31:	e8 90 fe ff ff       	call   800cc6 <printfmt>
  800e36:	e9 d8 fe ff ff       	jmp    800d13 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800e3b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800e3f:	c7 44 24 08 67 42 80 	movl   $0x804267,0x8(%esp)
  800e46:	00 
  800e47:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	89 04 24             	mov    %eax,(%esp)
  800e51:	e8 70 fe ff ff       	call   800cc6 <printfmt>
  800e56:	e9 b8 fe ff ff       	jmp    800d13 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e5b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800e5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e61:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e64:	8b 45 14             	mov    0x14(%ebp),%eax
  800e67:	8d 50 04             	lea    0x4(%eax),%edx
  800e6a:	89 55 14             	mov    %edx,0x14(%ebp)
  800e6d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800e6f:	85 f6                	test   %esi,%esi
  800e71:	b8 58 43 80 00       	mov    $0x804358,%eax
  800e76:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800e79:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800e7d:	0f 84 97 00 00 00    	je     800f1a <vprintfmt+0x22c>
  800e83:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800e87:	0f 8e 9b 00 00 00    	jle    800f28 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e8d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800e91:	89 34 24             	mov    %esi,(%esp)
  800e94:	e8 bf 03 00 00       	call   801258 <strnlen>
  800e99:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800e9c:	29 c2                	sub    %eax,%edx
  800e9e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800ea1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800ea5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800ea8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800eab:	8b 75 08             	mov    0x8(%ebp),%esi
  800eae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800eb1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800eb3:	eb 0f                	jmp    800ec4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800eb5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800eb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ebc:	89 04 24             	mov    %eax,(%esp)
  800ebf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ec1:	83 eb 01             	sub    $0x1,%ebx
  800ec4:	85 db                	test   %ebx,%ebx
  800ec6:	7f ed                	jg     800eb5 <vprintfmt+0x1c7>
  800ec8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800ecb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800ece:	85 d2                	test   %edx,%edx
  800ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed5:	0f 49 c2             	cmovns %edx,%eax
  800ed8:	29 c2                	sub    %eax,%edx
  800eda:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800edd:	89 d7                	mov    %edx,%edi
  800edf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ee2:	eb 50                	jmp    800f34 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800ee4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ee8:	74 1e                	je     800f08 <vprintfmt+0x21a>
  800eea:	0f be d2             	movsbl %dl,%edx
  800eed:	83 ea 20             	sub    $0x20,%edx
  800ef0:	83 fa 5e             	cmp    $0x5e,%edx
  800ef3:	76 13                	jbe    800f08 <vprintfmt+0x21a>
					putch('?', putdat);
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800efc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800f03:	ff 55 08             	call   *0x8(%ebp)
  800f06:	eb 0d                	jmp    800f15 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800f08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f0b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f0f:	89 04 24             	mov    %eax,(%esp)
  800f12:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f15:	83 ef 01             	sub    $0x1,%edi
  800f18:	eb 1a                	jmp    800f34 <vprintfmt+0x246>
  800f1a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800f1d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800f20:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f23:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800f26:	eb 0c                	jmp    800f34 <vprintfmt+0x246>
  800f28:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800f2b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800f2e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f31:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800f34:	83 c6 01             	add    $0x1,%esi
  800f37:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800f3b:	0f be c2             	movsbl %dl,%eax
  800f3e:	85 c0                	test   %eax,%eax
  800f40:	74 27                	je     800f69 <vprintfmt+0x27b>
  800f42:	85 db                	test   %ebx,%ebx
  800f44:	78 9e                	js     800ee4 <vprintfmt+0x1f6>
  800f46:	83 eb 01             	sub    $0x1,%ebx
  800f49:	79 99                	jns    800ee4 <vprintfmt+0x1f6>
  800f4b:	89 f8                	mov    %edi,%eax
  800f4d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f50:	8b 75 08             	mov    0x8(%ebp),%esi
  800f53:	89 c3                	mov    %eax,%ebx
  800f55:	eb 1a                	jmp    800f71 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800f57:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f5b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800f62:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f64:	83 eb 01             	sub    $0x1,%ebx
  800f67:	eb 08                	jmp    800f71 <vprintfmt+0x283>
  800f69:	89 fb                	mov    %edi,%ebx
  800f6b:	8b 75 08             	mov    0x8(%ebp),%esi
  800f6e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f71:	85 db                	test   %ebx,%ebx
  800f73:	7f e2                	jg     800f57 <vprintfmt+0x269>
  800f75:	89 75 08             	mov    %esi,0x8(%ebp)
  800f78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7b:	e9 93 fd ff ff       	jmp    800d13 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800f80:	83 fa 01             	cmp    $0x1,%edx
  800f83:	7e 16                	jle    800f9b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800f85:	8b 45 14             	mov    0x14(%ebp),%eax
  800f88:	8d 50 08             	lea    0x8(%eax),%edx
  800f8b:	89 55 14             	mov    %edx,0x14(%ebp)
  800f8e:	8b 50 04             	mov    0x4(%eax),%edx
  800f91:	8b 00                	mov    (%eax),%eax
  800f93:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f96:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800f99:	eb 32                	jmp    800fcd <vprintfmt+0x2df>
	else if (lflag)
  800f9b:	85 d2                	test   %edx,%edx
  800f9d:	74 18                	je     800fb7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800f9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa2:	8d 50 04             	lea    0x4(%eax),%edx
  800fa5:	89 55 14             	mov    %edx,0x14(%ebp)
  800fa8:	8b 30                	mov    (%eax),%esi
  800faa:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800fad:	89 f0                	mov    %esi,%eax
  800faf:	c1 f8 1f             	sar    $0x1f,%eax
  800fb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800fb5:	eb 16                	jmp    800fcd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800fb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800fba:	8d 50 04             	lea    0x4(%eax),%edx
  800fbd:	89 55 14             	mov    %edx,0x14(%ebp)
  800fc0:	8b 30                	mov    (%eax),%esi
  800fc2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800fc5:	89 f0                	mov    %esi,%eax
  800fc7:	c1 f8 1f             	sar    $0x1f,%eax
  800fca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800fd3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800fd8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fdc:	0f 89 80 00 00 00    	jns    801062 <vprintfmt+0x374>
				putch('-', putdat);
  800fe2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800fe6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800fed:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800ff0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ff3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ff6:	f7 d8                	neg    %eax
  800ff8:	83 d2 00             	adc    $0x0,%edx
  800ffb:	f7 da                	neg    %edx
			}
			base = 10;
  800ffd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801002:	eb 5e                	jmp    801062 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801004:	8d 45 14             	lea    0x14(%ebp),%eax
  801007:	e8 63 fc ff ff       	call   800c6f <getuint>
			base = 10;
  80100c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801011:	eb 4f                	jmp    801062 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  801013:	8d 45 14             	lea    0x14(%ebp),%eax
  801016:	e8 54 fc ff ff       	call   800c6f <getuint>
			base = 8;
  80101b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801020:	eb 40                	jmp    801062 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  801022:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801026:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80102d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801030:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801034:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80103b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80103e:	8b 45 14             	mov    0x14(%ebp),%eax
  801041:	8d 50 04             	lea    0x4(%eax),%edx
  801044:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801047:	8b 00                	mov    (%eax),%eax
  801049:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80104e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801053:	eb 0d                	jmp    801062 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801055:	8d 45 14             	lea    0x14(%ebp),%eax
  801058:	e8 12 fc ff ff       	call   800c6f <getuint>
			base = 16;
  80105d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801062:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  801066:	89 74 24 10          	mov    %esi,0x10(%esp)
  80106a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80106d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801071:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801075:	89 04 24             	mov    %eax,(%esp)
  801078:	89 54 24 04          	mov    %edx,0x4(%esp)
  80107c:	89 fa                	mov    %edi,%edx
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	e8 fa fa ff ff       	call   800b80 <printnum>
			break;
  801086:	e9 88 fc ff ff       	jmp    800d13 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80108b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80108f:	89 04 24             	mov    %eax,(%esp)
  801092:	ff 55 08             	call   *0x8(%ebp)
			break;
  801095:	e9 79 fc ff ff       	jmp    800d13 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80109a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80109e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8010a5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010a8:	89 f3                	mov    %esi,%ebx
  8010aa:	eb 03                	jmp    8010af <vprintfmt+0x3c1>
  8010ac:	83 eb 01             	sub    $0x1,%ebx
  8010af:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8010b3:	75 f7                	jne    8010ac <vprintfmt+0x3be>
  8010b5:	e9 59 fc ff ff       	jmp    800d13 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8010ba:	83 c4 3c             	add    $0x3c,%esp
  8010bd:	5b                   	pop    %ebx
  8010be:	5e                   	pop    %esi
  8010bf:	5f                   	pop    %edi
  8010c0:	5d                   	pop    %ebp
  8010c1:	c3                   	ret    

008010c2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010c2:	55                   	push   %ebp
  8010c3:	89 e5                	mov    %esp,%ebp
  8010c5:	83 ec 28             	sub    $0x28,%esp
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010d1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8010d5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8010d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010df:	85 c0                	test   %eax,%eax
  8010e1:	74 30                	je     801113 <vsnprintf+0x51>
  8010e3:	85 d2                	test   %edx,%edx
  8010e5:	7e 2c                	jle    801113 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8010e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8010f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010fc:	c7 04 24 a9 0c 80 00 	movl   $0x800ca9,(%esp)
  801103:	e8 e6 fb ff ff       	call   800cee <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801108:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80110b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80110e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801111:	eb 05                	jmp    801118 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801113:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801118:	c9                   	leave  
  801119:	c3                   	ret    

0080111a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801120:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801123:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801127:	8b 45 10             	mov    0x10(%ebp),%eax
  80112a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80112e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801131:	89 44 24 04          	mov    %eax,0x4(%esp)
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	89 04 24             	mov    %eax,(%esp)
  80113b:	e8 82 ff ff ff       	call   8010c2 <vsnprintf>
	va_end(ap);

	return rc;
}
  801140:	c9                   	leave  
  801141:	c3                   	ret    
  801142:	66 90                	xchg   %ax,%ax
  801144:	66 90                	xchg   %ax,%ax
  801146:	66 90                	xchg   %ax,%ax
  801148:	66 90                	xchg   %ax,%ax
  80114a:	66 90                	xchg   %ax,%ax
  80114c:	66 90                	xchg   %ax,%ax
  80114e:	66 90                	xchg   %ax,%ax

00801150 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	57                   	push   %edi
  801154:	56                   	push   %esi
  801155:	53                   	push   %ebx
  801156:	83 ec 1c             	sub    $0x1c,%esp
  801159:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80115c:	85 c0                	test   %eax,%eax
  80115e:	74 18                	je     801178 <readline+0x28>
		fprintf(1, "%s", prompt);
  801160:	89 44 24 08          	mov    %eax,0x8(%esp)
  801164:	c7 44 24 04 67 42 80 	movl   $0x804267,0x4(%esp)
  80116b:	00 
  80116c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801173:	e8 96 17 00 00       	call   80290e <fprintf>
#endif

	i = 0;
	echoing = iscons(0);
  801178:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80117f:	e8 f8 f7 ff ff       	call   80097c <iscons>
  801184:	89 c7                	mov    %eax,%edi
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
  801186:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
  80118b:	e8 b6 f7 ff ff       	call   800946 <getchar>
  801190:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  801192:	85 c0                	test   %eax,%eax
  801194:	79 25                	jns    8011bb <readline+0x6b>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  801196:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
  80119b:	83 fb f8             	cmp    $0xfffffff8,%ebx
  80119e:	0f 84 88 00 00 00    	je     80122c <readline+0xdc>
				cprintf("read error: %e\n", c);
  8011a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011a8:	c7 04 24 47 46 80 00 	movl   $0x804647,(%esp)
  8011af:	e8 ac f9 ff ff       	call   800b60 <cprintf>
			return NULL;
  8011b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b9:	eb 71                	jmp    80122c <readline+0xdc>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8011bb:	83 f8 7f             	cmp    $0x7f,%eax
  8011be:	74 05                	je     8011c5 <readline+0x75>
  8011c0:	83 f8 08             	cmp    $0x8,%eax
  8011c3:	75 19                	jne    8011de <readline+0x8e>
  8011c5:	85 f6                	test   %esi,%esi
  8011c7:	7e 15                	jle    8011de <readline+0x8e>
			if (echoing)
  8011c9:	85 ff                	test   %edi,%edi
  8011cb:	74 0c                	je     8011d9 <readline+0x89>
				cputchar('\b');
  8011cd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  8011d4:	e8 4c f7 ff ff       	call   800925 <cputchar>
			i--;
  8011d9:	83 ee 01             	sub    $0x1,%esi
  8011dc:	eb ad                	jmp    80118b <readline+0x3b>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011de:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8011e4:	7f 1c                	jg     801202 <readline+0xb2>
  8011e6:	83 fb 1f             	cmp    $0x1f,%ebx
  8011e9:	7e 17                	jle    801202 <readline+0xb2>
			if (echoing)
  8011eb:	85 ff                	test   %edi,%edi
  8011ed:	74 08                	je     8011f7 <readline+0xa7>
				cputchar(c);
  8011ef:	89 1c 24             	mov    %ebx,(%esp)
  8011f2:	e8 2e f7 ff ff       	call   800925 <cputchar>
			buf[i++] = c;
  8011f7:	88 9e 20 60 80 00    	mov    %bl,0x806020(%esi)
  8011fd:	8d 76 01             	lea    0x1(%esi),%esi
  801200:	eb 89                	jmp    80118b <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  801202:	83 fb 0d             	cmp    $0xd,%ebx
  801205:	74 09                	je     801210 <readline+0xc0>
  801207:	83 fb 0a             	cmp    $0xa,%ebx
  80120a:	0f 85 7b ff ff ff    	jne    80118b <readline+0x3b>
			if (echoing)
  801210:	85 ff                	test   %edi,%edi
  801212:	74 0c                	je     801220 <readline+0xd0>
				cputchar('\n');
  801214:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80121b:	e8 05 f7 ff ff       	call   800925 <cputchar>
			buf[i] = 0;
  801220:	c6 86 20 60 80 00 00 	movb   $0x0,0x806020(%esi)
			return buf;
  801227:	b8 20 60 80 00       	mov    $0x806020,%eax
		}
	}
}
  80122c:	83 c4 1c             	add    $0x1c,%esp
  80122f:	5b                   	pop    %ebx
  801230:	5e                   	pop    %esi
  801231:	5f                   	pop    %edi
  801232:	5d                   	pop    %ebp
  801233:	c3                   	ret    
  801234:	66 90                	xchg   %ax,%ax
  801236:	66 90                	xchg   %ax,%ax
  801238:	66 90                	xchg   %ax,%ax
  80123a:	66 90                	xchg   %ax,%ax
  80123c:	66 90                	xchg   %ax,%ax
  80123e:	66 90                	xchg   %ax,%ax

00801240 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	eb 03                	jmp    801250 <strlen+0x10>
		n++;
  80124d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801250:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801254:	75 f7                	jne    80124d <strlen+0xd>
		n++;
	return n;
}
  801256:	5d                   	pop    %ebp
  801257:	c3                   	ret    

00801258 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801258:	55                   	push   %ebp
  801259:	89 e5                	mov    %esp,%ebp
  80125b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80125e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801261:	b8 00 00 00 00       	mov    $0x0,%eax
  801266:	eb 03                	jmp    80126b <strnlen+0x13>
		n++;
  801268:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80126b:	39 d0                	cmp    %edx,%eax
  80126d:	74 06                	je     801275 <strnlen+0x1d>
  80126f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801273:	75 f3                	jne    801268 <strnlen+0x10>
		n++;
	return n;
}
  801275:	5d                   	pop    %ebp
  801276:	c3                   	ret    

00801277 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	53                   	push   %ebx
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801281:	89 c2                	mov    %eax,%edx
  801283:	83 c2 01             	add    $0x1,%edx
  801286:	83 c1 01             	add    $0x1,%ecx
  801289:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80128d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801290:	84 db                	test   %bl,%bl
  801292:	75 ef                	jne    801283 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801294:	5b                   	pop    %ebx
  801295:	5d                   	pop    %ebp
  801296:	c3                   	ret    

00801297 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	53                   	push   %ebx
  80129b:	83 ec 08             	sub    $0x8,%esp
  80129e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8012a1:	89 1c 24             	mov    %ebx,(%esp)
  8012a4:	e8 97 ff ff ff       	call   801240 <strlen>
	strcpy(dst + len, src);
  8012a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  8012b0:	01 d8                	add    %ebx,%eax
  8012b2:	89 04 24             	mov    %eax,(%esp)
  8012b5:	e8 bd ff ff ff       	call   801277 <strcpy>
	return dst;
}
  8012ba:	89 d8                	mov    %ebx,%eax
  8012bc:	83 c4 08             	add    $0x8,%esp
  8012bf:	5b                   	pop    %ebx
  8012c0:	5d                   	pop    %ebp
  8012c1:	c3                   	ret    

008012c2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
  8012c5:	56                   	push   %esi
  8012c6:	53                   	push   %ebx
  8012c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8012ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012cd:	89 f3                	mov    %esi,%ebx
  8012cf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012d2:	89 f2                	mov    %esi,%edx
  8012d4:	eb 0f                	jmp    8012e5 <strncpy+0x23>
		*dst++ = *src;
  8012d6:	83 c2 01             	add    $0x1,%edx
  8012d9:	0f b6 01             	movzbl (%ecx),%eax
  8012dc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8012df:	80 39 01             	cmpb   $0x1,(%ecx)
  8012e2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012e5:	39 da                	cmp    %ebx,%edx
  8012e7:	75 ed                	jne    8012d6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8012e9:	89 f0                	mov    %esi,%eax
  8012eb:	5b                   	pop    %ebx
  8012ec:	5e                   	pop    %esi
  8012ed:	5d                   	pop    %ebp
  8012ee:	c3                   	ret    

008012ef <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	56                   	push   %esi
  8012f3:	53                   	push   %ebx
  8012f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8012f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012fd:	89 f0                	mov    %esi,%eax
  8012ff:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801303:	85 c9                	test   %ecx,%ecx
  801305:	75 0b                	jne    801312 <strlcpy+0x23>
  801307:	eb 1d                	jmp    801326 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801309:	83 c0 01             	add    $0x1,%eax
  80130c:	83 c2 01             	add    $0x1,%edx
  80130f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801312:	39 d8                	cmp    %ebx,%eax
  801314:	74 0b                	je     801321 <strlcpy+0x32>
  801316:	0f b6 0a             	movzbl (%edx),%ecx
  801319:	84 c9                	test   %cl,%cl
  80131b:	75 ec                	jne    801309 <strlcpy+0x1a>
  80131d:	89 c2                	mov    %eax,%edx
  80131f:	eb 02                	jmp    801323 <strlcpy+0x34>
  801321:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  801323:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  801326:	29 f0                	sub    %esi,%eax
}
  801328:	5b                   	pop    %ebx
  801329:	5e                   	pop    %esi
  80132a:	5d                   	pop    %ebp
  80132b:	c3                   	ret    

0080132c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801332:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801335:	eb 06                	jmp    80133d <strcmp+0x11>
		p++, q++;
  801337:	83 c1 01             	add    $0x1,%ecx
  80133a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80133d:	0f b6 01             	movzbl (%ecx),%eax
  801340:	84 c0                	test   %al,%al
  801342:	74 04                	je     801348 <strcmp+0x1c>
  801344:	3a 02                	cmp    (%edx),%al
  801346:	74 ef                	je     801337 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801348:	0f b6 c0             	movzbl %al,%eax
  80134b:	0f b6 12             	movzbl (%edx),%edx
  80134e:	29 d0                	sub    %edx,%eax
}
  801350:	5d                   	pop    %ebp
  801351:	c3                   	ret    

00801352 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
  801355:	53                   	push   %ebx
  801356:	8b 45 08             	mov    0x8(%ebp),%eax
  801359:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135c:	89 c3                	mov    %eax,%ebx
  80135e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801361:	eb 06                	jmp    801369 <strncmp+0x17>
		n--, p++, q++;
  801363:	83 c0 01             	add    $0x1,%eax
  801366:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801369:	39 d8                	cmp    %ebx,%eax
  80136b:	74 15                	je     801382 <strncmp+0x30>
  80136d:	0f b6 08             	movzbl (%eax),%ecx
  801370:	84 c9                	test   %cl,%cl
  801372:	74 04                	je     801378 <strncmp+0x26>
  801374:	3a 0a                	cmp    (%edx),%cl
  801376:	74 eb                	je     801363 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801378:	0f b6 00             	movzbl (%eax),%eax
  80137b:	0f b6 12             	movzbl (%edx),%edx
  80137e:	29 d0                	sub    %edx,%eax
  801380:	eb 05                	jmp    801387 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801382:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801387:	5b                   	pop    %ebx
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    

0080138a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801394:	eb 07                	jmp    80139d <strchr+0x13>
		if (*s == c)
  801396:	38 ca                	cmp    %cl,%dl
  801398:	74 0f                	je     8013a9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80139a:	83 c0 01             	add    $0x1,%eax
  80139d:	0f b6 10             	movzbl (%eax),%edx
  8013a0:	84 d2                	test   %dl,%dl
  8013a2:	75 f2                	jne    801396 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8013a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a9:	5d                   	pop    %ebp
  8013aa:	c3                   	ret    

008013ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8013b5:	eb 07                	jmp    8013be <strfind+0x13>
		if (*s == c)
  8013b7:	38 ca                	cmp    %cl,%dl
  8013b9:	74 0a                	je     8013c5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8013bb:	83 c0 01             	add    $0x1,%eax
  8013be:	0f b6 10             	movzbl (%eax),%edx
  8013c1:	84 d2                	test   %dl,%dl
  8013c3:	75 f2                	jne    8013b7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8013c5:	5d                   	pop    %ebp
  8013c6:	c3                   	ret    

008013c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	57                   	push   %edi
  8013cb:	56                   	push   %esi
  8013cc:	53                   	push   %ebx
  8013cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8013d3:	85 c9                	test   %ecx,%ecx
  8013d5:	74 36                	je     80140d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8013d7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8013dd:	75 28                	jne    801407 <memset+0x40>
  8013df:	f6 c1 03             	test   $0x3,%cl
  8013e2:	75 23                	jne    801407 <memset+0x40>
		c &= 0xFF;
  8013e4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013e8:	89 d3                	mov    %edx,%ebx
  8013ea:	c1 e3 08             	shl    $0x8,%ebx
  8013ed:	89 d6                	mov    %edx,%esi
  8013ef:	c1 e6 18             	shl    $0x18,%esi
  8013f2:	89 d0                	mov    %edx,%eax
  8013f4:	c1 e0 10             	shl    $0x10,%eax
  8013f7:	09 f0                	or     %esi,%eax
  8013f9:	09 c2                	or     %eax,%edx
  8013fb:	89 d0                	mov    %edx,%eax
  8013fd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8013ff:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801402:	fc                   	cld    
  801403:	f3 ab                	rep stos %eax,%es:(%edi)
  801405:	eb 06                	jmp    80140d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801407:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140a:	fc                   	cld    
  80140b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80140d:	89 f8                	mov    %edi,%eax
  80140f:	5b                   	pop    %ebx
  801410:	5e                   	pop    %esi
  801411:	5f                   	pop    %edi
  801412:	5d                   	pop    %ebp
  801413:	c3                   	ret    

00801414 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	57                   	push   %edi
  801418:	56                   	push   %esi
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
  80141c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80141f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801422:	39 c6                	cmp    %eax,%esi
  801424:	73 35                	jae    80145b <memmove+0x47>
  801426:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801429:	39 d0                	cmp    %edx,%eax
  80142b:	73 2e                	jae    80145b <memmove+0x47>
		s += n;
		d += n;
  80142d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  801430:	89 d6                	mov    %edx,%esi
  801432:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801434:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80143a:	75 13                	jne    80144f <memmove+0x3b>
  80143c:	f6 c1 03             	test   $0x3,%cl
  80143f:	75 0e                	jne    80144f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801441:	83 ef 04             	sub    $0x4,%edi
  801444:	8d 72 fc             	lea    -0x4(%edx),%esi
  801447:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80144a:	fd                   	std    
  80144b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80144d:	eb 09                	jmp    801458 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80144f:	83 ef 01             	sub    $0x1,%edi
  801452:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801455:	fd                   	std    
  801456:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801458:	fc                   	cld    
  801459:	eb 1d                	jmp    801478 <memmove+0x64>
  80145b:	89 f2                	mov    %esi,%edx
  80145d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80145f:	f6 c2 03             	test   $0x3,%dl
  801462:	75 0f                	jne    801473 <memmove+0x5f>
  801464:	f6 c1 03             	test   $0x3,%cl
  801467:	75 0a                	jne    801473 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801469:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80146c:	89 c7                	mov    %eax,%edi
  80146e:	fc                   	cld    
  80146f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801471:	eb 05                	jmp    801478 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801473:	89 c7                	mov    %eax,%edi
  801475:	fc                   	cld    
  801476:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801478:	5e                   	pop    %esi
  801479:	5f                   	pop    %edi
  80147a:	5d                   	pop    %ebp
  80147b:	c3                   	ret    

0080147c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801482:	8b 45 10             	mov    0x10(%ebp),%eax
  801485:	89 44 24 08          	mov    %eax,0x8(%esp)
  801489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	89 04 24             	mov    %eax,(%esp)
  801496:	e8 79 ff ff ff       	call   801414 <memmove>
}
  80149b:	c9                   	leave  
  80149c:	c3                   	ret    

0080149d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
  8014a0:	56                   	push   %esi
  8014a1:	53                   	push   %ebx
  8014a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014a8:	89 d6                	mov    %edx,%esi
  8014aa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014ad:	eb 1a                	jmp    8014c9 <memcmp+0x2c>
		if (*s1 != *s2)
  8014af:	0f b6 02             	movzbl (%edx),%eax
  8014b2:	0f b6 19             	movzbl (%ecx),%ebx
  8014b5:	38 d8                	cmp    %bl,%al
  8014b7:	74 0a                	je     8014c3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8014b9:	0f b6 c0             	movzbl %al,%eax
  8014bc:	0f b6 db             	movzbl %bl,%ebx
  8014bf:	29 d8                	sub    %ebx,%eax
  8014c1:	eb 0f                	jmp    8014d2 <memcmp+0x35>
		s1++, s2++;
  8014c3:	83 c2 01             	add    $0x1,%edx
  8014c6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8014c9:	39 f2                	cmp    %esi,%edx
  8014cb:	75 e2                	jne    8014af <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8014cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d2:	5b                   	pop    %ebx
  8014d3:	5e                   	pop    %esi
  8014d4:	5d                   	pop    %ebp
  8014d5:	c3                   	ret    

008014d6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8014df:	89 c2                	mov    %eax,%edx
  8014e1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8014e4:	eb 07                	jmp    8014ed <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014e6:	38 08                	cmp    %cl,(%eax)
  8014e8:	74 07                	je     8014f1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014ea:	83 c0 01             	add    $0x1,%eax
  8014ed:	39 d0                	cmp    %edx,%eax
  8014ef:	72 f5                	jb     8014e6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8014f1:	5d                   	pop    %ebp
  8014f2:	c3                   	ret    

008014f3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
  8014f6:	57                   	push   %edi
  8014f7:	56                   	push   %esi
  8014f8:	53                   	push   %ebx
  8014f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014fc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014ff:	eb 03                	jmp    801504 <strtol+0x11>
		s++;
  801501:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801504:	0f b6 0a             	movzbl (%edx),%ecx
  801507:	80 f9 09             	cmp    $0x9,%cl
  80150a:	74 f5                	je     801501 <strtol+0xe>
  80150c:	80 f9 20             	cmp    $0x20,%cl
  80150f:	74 f0                	je     801501 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  801511:	80 f9 2b             	cmp    $0x2b,%cl
  801514:	75 0a                	jne    801520 <strtol+0x2d>
		s++;
  801516:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801519:	bf 00 00 00 00       	mov    $0x0,%edi
  80151e:	eb 11                	jmp    801531 <strtol+0x3e>
  801520:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801525:	80 f9 2d             	cmp    $0x2d,%cl
  801528:	75 07                	jne    801531 <strtol+0x3e>
		s++, neg = 1;
  80152a:	8d 52 01             	lea    0x1(%edx),%edx
  80152d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801531:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  801536:	75 15                	jne    80154d <strtol+0x5a>
  801538:	80 3a 30             	cmpb   $0x30,(%edx)
  80153b:	75 10                	jne    80154d <strtol+0x5a>
  80153d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801541:	75 0a                	jne    80154d <strtol+0x5a>
		s += 2, base = 16;
  801543:	83 c2 02             	add    $0x2,%edx
  801546:	b8 10 00 00 00       	mov    $0x10,%eax
  80154b:	eb 10                	jmp    80155d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80154d:	85 c0                	test   %eax,%eax
  80154f:	75 0c                	jne    80155d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801551:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801553:	80 3a 30             	cmpb   $0x30,(%edx)
  801556:	75 05                	jne    80155d <strtol+0x6a>
		s++, base = 8;
  801558:	83 c2 01             	add    $0x1,%edx
  80155b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80155d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801562:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801565:	0f b6 0a             	movzbl (%edx),%ecx
  801568:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80156b:	89 f0                	mov    %esi,%eax
  80156d:	3c 09                	cmp    $0x9,%al
  80156f:	77 08                	ja     801579 <strtol+0x86>
			dig = *s - '0';
  801571:	0f be c9             	movsbl %cl,%ecx
  801574:	83 e9 30             	sub    $0x30,%ecx
  801577:	eb 20                	jmp    801599 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  801579:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80157c:	89 f0                	mov    %esi,%eax
  80157e:	3c 19                	cmp    $0x19,%al
  801580:	77 08                	ja     80158a <strtol+0x97>
			dig = *s - 'a' + 10;
  801582:	0f be c9             	movsbl %cl,%ecx
  801585:	83 e9 57             	sub    $0x57,%ecx
  801588:	eb 0f                	jmp    801599 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80158a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80158d:	89 f0                	mov    %esi,%eax
  80158f:	3c 19                	cmp    $0x19,%al
  801591:	77 16                	ja     8015a9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801593:	0f be c9             	movsbl %cl,%ecx
  801596:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801599:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80159c:	7d 0f                	jge    8015ad <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80159e:	83 c2 01             	add    $0x1,%edx
  8015a1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8015a5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8015a7:	eb bc                	jmp    801565 <strtol+0x72>
  8015a9:	89 d8                	mov    %ebx,%eax
  8015ab:	eb 02                	jmp    8015af <strtol+0xbc>
  8015ad:	89 d8                	mov    %ebx,%eax

	if (endptr)
  8015af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b3:	74 05                	je     8015ba <strtol+0xc7>
		*endptr = (char *) s;
  8015b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015b8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  8015ba:	f7 d8                	neg    %eax
  8015bc:	85 ff                	test   %edi,%edi
  8015be:	0f 44 c3             	cmove  %ebx,%eax
}
  8015c1:	5b                   	pop    %ebx
  8015c2:	5e                   	pop    %esi
  8015c3:	5f                   	pop    %edi
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    

008015c6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	57                   	push   %edi
  8015ca:	56                   	push   %esi
  8015cb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d7:	89 c3                	mov    %eax,%ebx
  8015d9:	89 c7                	mov    %eax,%edi
  8015db:	89 c6                	mov    %eax,%esi
  8015dd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8015df:	5b                   	pop    %ebx
  8015e0:	5e                   	pop    %esi
  8015e1:	5f                   	pop    %edi
  8015e2:	5d                   	pop    %ebp
  8015e3:	c3                   	ret    

008015e4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	57                   	push   %edi
  8015e8:	56                   	push   %esi
  8015e9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8015f4:	89 d1                	mov    %edx,%ecx
  8015f6:	89 d3                	mov    %edx,%ebx
  8015f8:	89 d7                	mov    %edx,%edi
  8015fa:	89 d6                	mov    %edx,%esi
  8015fc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8015fe:	5b                   	pop    %ebx
  8015ff:	5e                   	pop    %esi
  801600:	5f                   	pop    %edi
  801601:	5d                   	pop    %ebp
  801602:	c3                   	ret    

00801603 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	57                   	push   %edi
  801607:	56                   	push   %esi
  801608:	53                   	push   %ebx
  801609:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80160c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801611:	b8 03 00 00 00       	mov    $0x3,%eax
  801616:	8b 55 08             	mov    0x8(%ebp),%edx
  801619:	89 cb                	mov    %ecx,%ebx
  80161b:	89 cf                	mov    %ecx,%edi
  80161d:	89 ce                	mov    %ecx,%esi
  80161f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801621:	85 c0                	test   %eax,%eax
  801623:	7e 28                	jle    80164d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801625:	89 44 24 10          	mov    %eax,0x10(%esp)
  801629:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801630:	00 
  801631:	c7 44 24 08 57 46 80 	movl   $0x804657,0x8(%esp)
  801638:	00 
  801639:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801640:	00 
  801641:	c7 04 24 74 46 80 00 	movl   $0x804674,(%esp)
  801648:	e8 1a f4 ff ff       	call   800a67 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80164d:	83 c4 2c             	add    $0x2c,%esp
  801650:	5b                   	pop    %ebx
  801651:	5e                   	pop    %esi
  801652:	5f                   	pop    %edi
  801653:	5d                   	pop    %ebp
  801654:	c3                   	ret    

00801655 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	57                   	push   %edi
  801659:	56                   	push   %esi
  80165a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80165b:	ba 00 00 00 00       	mov    $0x0,%edx
  801660:	b8 02 00 00 00       	mov    $0x2,%eax
  801665:	89 d1                	mov    %edx,%ecx
  801667:	89 d3                	mov    %edx,%ebx
  801669:	89 d7                	mov    %edx,%edi
  80166b:	89 d6                	mov    %edx,%esi
  80166d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80166f:	5b                   	pop    %ebx
  801670:	5e                   	pop    %esi
  801671:	5f                   	pop    %edi
  801672:	5d                   	pop    %ebp
  801673:	c3                   	ret    

00801674 <sys_yield>:

void
sys_yield(void)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	57                   	push   %edi
  801678:	56                   	push   %esi
  801679:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80167a:	ba 00 00 00 00       	mov    $0x0,%edx
  80167f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801684:	89 d1                	mov    %edx,%ecx
  801686:	89 d3                	mov    %edx,%ebx
  801688:	89 d7                	mov    %edx,%edi
  80168a:	89 d6                	mov    %edx,%esi
  80168c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80168e:	5b                   	pop    %ebx
  80168f:	5e                   	pop    %esi
  801690:	5f                   	pop    %edi
  801691:	5d                   	pop    %ebp
  801692:	c3                   	ret    

00801693 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	57                   	push   %edi
  801697:	56                   	push   %esi
  801698:	53                   	push   %ebx
  801699:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80169c:	be 00 00 00 00       	mov    $0x0,%esi
  8016a1:	b8 04 00 00 00       	mov    $0x4,%eax
  8016a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016af:	89 f7                	mov    %esi,%edi
  8016b1:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8016b3:	85 c0                	test   %eax,%eax
  8016b5:	7e 28                	jle    8016df <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016b7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016bb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8016c2:	00 
  8016c3:	c7 44 24 08 57 46 80 	movl   $0x804657,0x8(%esp)
  8016ca:	00 
  8016cb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8016d2:	00 
  8016d3:	c7 04 24 74 46 80 00 	movl   $0x804674,(%esp)
  8016da:	e8 88 f3 ff ff       	call   800a67 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8016df:	83 c4 2c             	add    $0x2c,%esp
  8016e2:	5b                   	pop    %ebx
  8016e3:	5e                   	pop    %esi
  8016e4:	5f                   	pop    %edi
  8016e5:	5d                   	pop    %ebp
  8016e6:	c3                   	ret    

008016e7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	57                   	push   %edi
  8016eb:	56                   	push   %esi
  8016ec:	53                   	push   %ebx
  8016ed:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016f0:	b8 05 00 00 00       	mov    $0x5,%eax
  8016f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016fe:	8b 7d 14             	mov    0x14(%ebp),%edi
  801701:	8b 75 18             	mov    0x18(%ebp),%esi
  801704:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801706:	85 c0                	test   %eax,%eax
  801708:	7e 28                	jle    801732 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80170a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80170e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801715:	00 
  801716:	c7 44 24 08 57 46 80 	movl   $0x804657,0x8(%esp)
  80171d:	00 
  80171e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801725:	00 
  801726:	c7 04 24 74 46 80 00 	movl   $0x804674,(%esp)
  80172d:	e8 35 f3 ff ff       	call   800a67 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801732:	83 c4 2c             	add    $0x2c,%esp
  801735:	5b                   	pop    %ebx
  801736:	5e                   	pop    %esi
  801737:	5f                   	pop    %edi
  801738:	5d                   	pop    %ebp
  801739:	c3                   	ret    

0080173a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	57                   	push   %edi
  80173e:	56                   	push   %esi
  80173f:	53                   	push   %ebx
  801740:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801743:	bb 00 00 00 00       	mov    $0x0,%ebx
  801748:	b8 06 00 00 00       	mov    $0x6,%eax
  80174d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801750:	8b 55 08             	mov    0x8(%ebp),%edx
  801753:	89 df                	mov    %ebx,%edi
  801755:	89 de                	mov    %ebx,%esi
  801757:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801759:	85 c0                	test   %eax,%eax
  80175b:	7e 28                	jle    801785 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80175d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801761:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801768:	00 
  801769:	c7 44 24 08 57 46 80 	movl   $0x804657,0x8(%esp)
  801770:	00 
  801771:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801778:	00 
  801779:	c7 04 24 74 46 80 00 	movl   $0x804674,(%esp)
  801780:	e8 e2 f2 ff ff       	call   800a67 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801785:	83 c4 2c             	add    $0x2c,%esp
  801788:	5b                   	pop    %ebx
  801789:	5e                   	pop    %esi
  80178a:	5f                   	pop    %edi
  80178b:	5d                   	pop    %ebp
  80178c:	c3                   	ret    

0080178d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	57                   	push   %edi
  801791:	56                   	push   %esi
  801792:	53                   	push   %ebx
  801793:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801796:	bb 00 00 00 00       	mov    $0x0,%ebx
  80179b:	b8 08 00 00 00       	mov    $0x8,%eax
  8017a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a6:	89 df                	mov    %ebx,%edi
  8017a8:	89 de                	mov    %ebx,%esi
  8017aa:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	7e 28                	jle    8017d8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017b0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017b4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8017bb:	00 
  8017bc:	c7 44 24 08 57 46 80 	movl   $0x804657,0x8(%esp)
  8017c3:	00 
  8017c4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8017cb:	00 
  8017cc:	c7 04 24 74 46 80 00 	movl   $0x804674,(%esp)
  8017d3:	e8 8f f2 ff ff       	call   800a67 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8017d8:	83 c4 2c             	add    $0x2c,%esp
  8017db:	5b                   	pop    %ebx
  8017dc:	5e                   	pop    %esi
  8017dd:	5f                   	pop    %edi
  8017de:	5d                   	pop    %ebp
  8017df:	c3                   	ret    

008017e0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	57                   	push   %edi
  8017e4:	56                   	push   %esi
  8017e5:	53                   	push   %ebx
  8017e6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017ee:	b8 09 00 00 00       	mov    $0x9,%eax
  8017f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f9:	89 df                	mov    %ebx,%edi
  8017fb:	89 de                	mov    %ebx,%esi
  8017fd:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8017ff:	85 c0                	test   %eax,%eax
  801801:	7e 28                	jle    80182b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801803:	89 44 24 10          	mov    %eax,0x10(%esp)
  801807:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80180e:	00 
  80180f:	c7 44 24 08 57 46 80 	movl   $0x804657,0x8(%esp)
  801816:	00 
  801817:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80181e:	00 
  80181f:	c7 04 24 74 46 80 00 	movl   $0x804674,(%esp)
  801826:	e8 3c f2 ff ff       	call   800a67 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80182b:	83 c4 2c             	add    $0x2c,%esp
  80182e:	5b                   	pop    %ebx
  80182f:	5e                   	pop    %esi
  801830:	5f                   	pop    %edi
  801831:	5d                   	pop    %ebp
  801832:	c3                   	ret    

00801833 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	57                   	push   %edi
  801837:	56                   	push   %esi
  801838:	53                   	push   %ebx
  801839:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80183c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801841:	b8 0a 00 00 00       	mov    $0xa,%eax
  801846:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801849:	8b 55 08             	mov    0x8(%ebp),%edx
  80184c:	89 df                	mov    %ebx,%edi
  80184e:	89 de                	mov    %ebx,%esi
  801850:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801852:	85 c0                	test   %eax,%eax
  801854:	7e 28                	jle    80187e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801856:	89 44 24 10          	mov    %eax,0x10(%esp)
  80185a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801861:	00 
  801862:	c7 44 24 08 57 46 80 	movl   $0x804657,0x8(%esp)
  801869:	00 
  80186a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801871:	00 
  801872:	c7 04 24 74 46 80 00 	movl   $0x804674,(%esp)
  801879:	e8 e9 f1 ff ff       	call   800a67 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80187e:	83 c4 2c             	add    $0x2c,%esp
  801881:	5b                   	pop    %ebx
  801882:	5e                   	pop    %esi
  801883:	5f                   	pop    %edi
  801884:	5d                   	pop    %ebp
  801885:	c3                   	ret    

00801886 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	57                   	push   %edi
  80188a:	56                   	push   %esi
  80188b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80188c:	be 00 00 00 00       	mov    $0x0,%esi
  801891:	b8 0c 00 00 00       	mov    $0xc,%eax
  801896:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801899:	8b 55 08             	mov    0x8(%ebp),%edx
  80189c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80189f:	8b 7d 14             	mov    0x14(%ebp),%edi
  8018a2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8018a4:	5b                   	pop    %ebx
  8018a5:	5e                   	pop    %esi
  8018a6:	5f                   	pop    %edi
  8018a7:	5d                   	pop    %ebp
  8018a8:	c3                   	ret    

008018a9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	57                   	push   %edi
  8018ad:	56                   	push   %esi
  8018ae:	53                   	push   %ebx
  8018af:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018b7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8018bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8018bf:	89 cb                	mov    %ecx,%ebx
  8018c1:	89 cf                	mov    %ecx,%edi
  8018c3:	89 ce                	mov    %ecx,%esi
  8018c5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8018c7:	85 c0                	test   %eax,%eax
  8018c9:	7e 28                	jle    8018f3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018cb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018cf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8018d6:	00 
  8018d7:	c7 44 24 08 57 46 80 	movl   $0x804657,0x8(%esp)
  8018de:	00 
  8018df:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8018e6:	00 
  8018e7:	c7 04 24 74 46 80 00 	movl   $0x804674,(%esp)
  8018ee:	e8 74 f1 ff ff       	call   800a67 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8018f3:	83 c4 2c             	add    $0x2c,%esp
  8018f6:	5b                   	pop    %ebx
  8018f7:	5e                   	pop    %esi
  8018f8:	5f                   	pop    %edi
  8018f9:	5d                   	pop    %ebp
  8018fa:	c3                   	ret    

008018fb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	57                   	push   %edi
  8018ff:	56                   	push   %esi
  801900:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801901:	ba 00 00 00 00       	mov    $0x0,%edx
  801906:	b8 0e 00 00 00       	mov    $0xe,%eax
  80190b:	89 d1                	mov    %edx,%ecx
  80190d:	89 d3                	mov    %edx,%ebx
  80190f:	89 d7                	mov    %edx,%edi
  801911:	89 d6                	mov    %edx,%esi
  801913:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801915:	5b                   	pop    %ebx
  801916:	5e                   	pop    %esi
  801917:	5f                   	pop    %edi
  801918:	5d                   	pop    %ebp
  801919:	c3                   	ret    

0080191a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	57                   	push   %edi
  80191e:	56                   	push   %esi
  80191f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801920:	bb 00 00 00 00       	mov    $0x0,%ebx
  801925:	b8 0f 00 00 00       	mov    $0xf,%eax
  80192a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80192d:	8b 55 08             	mov    0x8(%ebp),%edx
  801930:	89 df                	mov    %ebx,%edi
  801932:	89 de                	mov    %ebx,%esi
  801934:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  801936:	5b                   	pop    %ebx
  801937:	5e                   	pop    %esi
  801938:	5f                   	pop    %edi
  801939:	5d                   	pop    %ebp
  80193a:	c3                   	ret    

0080193b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	57                   	push   %edi
  80193f:	56                   	push   %esi
  801940:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801941:	bb 00 00 00 00       	mov    $0x0,%ebx
  801946:	b8 10 00 00 00       	mov    $0x10,%eax
  80194b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80194e:	8b 55 08             	mov    0x8(%ebp),%edx
  801951:	89 df                	mov    %ebx,%edi
  801953:	89 de                	mov    %ebx,%esi
  801955:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  801957:	5b                   	pop    %ebx
  801958:	5e                   	pop    %esi
  801959:	5f                   	pop    %edi
  80195a:	5d                   	pop    %ebp
  80195b:	c3                   	ret    

0080195c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	57                   	push   %edi
  801960:	56                   	push   %esi
  801961:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801962:	b9 00 00 00 00       	mov    $0x0,%ecx
  801967:	b8 11 00 00 00       	mov    $0x11,%eax
  80196c:	8b 55 08             	mov    0x8(%ebp),%edx
  80196f:	89 cb                	mov    %ecx,%ebx
  801971:	89 cf                	mov    %ecx,%edi
  801973:	89 ce                	mov    %ecx,%esi
  801975:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  801977:	5b                   	pop    %ebx
  801978:	5e                   	pop    %esi
  801979:	5f                   	pop    %edi
  80197a:	5d                   	pop    %ebp
  80197b:	c3                   	ret    

0080197c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	57                   	push   %edi
  801980:	56                   	push   %esi
  801981:	53                   	push   %ebx
  801982:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801985:	be 00 00 00 00       	mov    $0x0,%esi
  80198a:	b8 12 00 00 00       	mov    $0x12,%eax
  80198f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801992:	8b 55 08             	mov    0x8(%ebp),%edx
  801995:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801998:	8b 7d 14             	mov    0x14(%ebp),%edi
  80199b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80199d:	85 c0                	test   %eax,%eax
  80199f:	7e 28                	jle    8019c9 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019a1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019a5:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  8019ac:	00 
  8019ad:	c7 44 24 08 57 46 80 	movl   $0x804657,0x8(%esp)
  8019b4:	00 
  8019b5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8019bc:	00 
  8019bd:	c7 04 24 74 46 80 00 	movl   $0x804674,(%esp)
  8019c4:	e8 9e f0 ff ff       	call   800a67 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  8019c9:	83 c4 2c             	add    $0x2c,%esp
  8019cc:	5b                   	pop    %ebx
  8019cd:	5e                   	pop    %esi
  8019ce:	5f                   	pop    %edi
  8019cf:	5d                   	pop    %ebp
  8019d0:	c3                   	ret    

008019d1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	53                   	push   %ebx
  8019d5:	83 ec 24             	sub    $0x24,%esp
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8019db:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0)
  8019dd:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8019e1:	75 20                	jne    801a03 <pgfault+0x32>
		panic("pgfault: faulting address [%08x] not a write\n", addr);
  8019e3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8019e7:	c7 44 24 08 84 46 80 	movl   $0x804684,0x8(%esp)
  8019ee:	00 
  8019ef:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  8019f6:	00 
  8019f7:	c7 04 24 04 47 80 00 	movl   $0x804704,(%esp)
  8019fe:	e8 64 f0 ff ff       	call   800a67 <_panic>

	void *page_aligned_addr = (void *) ROUNDDOWN(addr, PGSIZE);
  801a03:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t page_num = (uint32_t) page_aligned_addr / PGSIZE;
  801a09:	89 d8                	mov    %ebx,%eax
  801a0b:	c1 e8 0c             	shr    $0xc,%eax
	if (!(uvpt[page_num] & PTE_COW))
  801a0e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a15:	f6 c4 08             	test   $0x8,%ah
  801a18:	75 1c                	jne    801a36 <pgfault+0x65>
		panic("pgfault: fault was not on a copy-on-write page\n");
  801a1a:	c7 44 24 08 b4 46 80 	movl   $0x8046b4,0x8(%esp)
  801a21:	00 
  801a22:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801a29:	00 
  801a2a:	c7 04 24 04 47 80 00 	movl   $0x804704,(%esp)
  801a31:	e8 31 f0 ff ff       	call   800a67 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	// Allocate
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801a36:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801a3d:	00 
  801a3e:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801a45:	00 
  801a46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a4d:	e8 41 fc ff ff       	call   801693 <sys_page_alloc>
  801a52:	85 c0                	test   %eax,%eax
  801a54:	79 20                	jns    801a76 <pgfault+0xa5>
		panic("sys_page_alloc: %e\n", r);
  801a56:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a5a:	c7 44 24 08 0f 47 80 	movl   $0x80470f,0x8(%esp)
  801a61:	00 
  801a62:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  801a69:	00 
  801a6a:	c7 04 24 04 47 80 00 	movl   $0x804704,(%esp)
  801a71:	e8 f1 ef ff ff       	call   800a67 <_panic>

	// Copy over
	void *src_addr = (void *) ROUNDDOWN(addr, PGSIZE);
	memmove(PFTEMP, src_addr, PGSIZE);
  801a76:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801a7d:	00 
  801a7e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a82:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801a89:	e8 86 f9 ff ff       	call   801414 <memmove>

	// Remap
	if ((r = sys_page_map(0, PFTEMP, 0, src_addr, PTE_P | PTE_U | PTE_W)) < 0)
  801a8e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801a95:	00 
  801a96:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801a9a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801aa1:	00 
  801aa2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801aa9:	00 
  801aaa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ab1:	e8 31 fc ff ff       	call   8016e7 <sys_page_map>
  801ab6:	85 c0                	test   %eax,%eax
  801ab8:	79 20                	jns    801ada <pgfault+0x109>
		panic("sys_page_map: %e\n", r);
  801aba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801abe:	c7 44 24 08 23 47 80 	movl   $0x804723,0x8(%esp)
  801ac5:	00 
  801ac6:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  801acd:	00 
  801ace:	c7 04 24 04 47 80 00 	movl   $0x804704,(%esp)
  801ad5:	e8 8d ef ff ff       	call   800a67 <_panic>

	//panic("pgfault not implemented");
}
  801ada:	83 c4 24             	add    $0x24,%esp
  801add:	5b                   	pop    %ebx
  801ade:	5d                   	pop    %ebp
  801adf:	c3                   	ret    

00801ae0 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	57                   	push   %edi
  801ae4:	56                   	push   %esi
  801ae5:	53                   	push   %ebx
  801ae6:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.
	int r;
	envid_t child_envid;

	set_pgfault_handler(pgfault);
  801ae9:	c7 04 24 d1 19 80 00 	movl   $0x8019d1,(%esp)
  801af0:	e8 55 21 00 00       	call   803c4a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801af5:	b8 07 00 00 00       	mov    $0x7,%eax
  801afa:	cd 30                	int    $0x30
  801afc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801aff:	89 45 e0             	mov    %eax,-0x20(%ebp)

	child_envid = sys_exofork();
	if (child_envid < 0)
  801b02:	85 c0                	test   %eax,%eax
  801b04:	79 20                	jns    801b26 <fork+0x46>
		panic("sys_exofork: %e\n", child_envid);
  801b06:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b0a:	c7 44 24 08 35 47 80 	movl   $0x804735,0x8(%esp)
  801b11:	00 
  801b12:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  801b19:	00 
  801b1a:	c7 04 24 04 47 80 00 	movl   $0x804704,(%esp)
  801b21:	e8 41 ef ff ff       	call   800a67 <_panic>
	if (child_envid == 0) { // child
  801b26:	bf 00 00 00 00       	mov    $0x0,%edi
  801b2b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b30:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801b34:	75 21                	jne    801b57 <fork+0x77>
		// Fix thisenv like dumbfork does and return 0
		thisenv = &envs[ENVX(sys_getenvid())];
  801b36:	e8 1a fb ff ff       	call   801655 <sys_getenvid>
  801b3b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b40:	c1 e0 07             	shl    $0x7,%eax
  801b43:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b48:	a3 28 64 80 00       	mov    %eax,0x806428
		return 0;
  801b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b52:	e9 53 02 00 00       	jmp    801daa <fork+0x2ca>
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
  801b57:	89 d8                	mov    %ebx,%eax
  801b59:	c1 e8 0a             	shr    $0xa,%eax
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  801b5c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b63:	a8 01                	test   $0x1,%al
  801b65:	0f 84 7a 01 00 00    	je     801ce5 <fork+0x205>
			((uvpt[page_num] & PTE_P) == PTE_P)) {
  801b6b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  801b72:	a8 01                	test   $0x1,%al
  801b74:	0f 84 6b 01 00 00    	je     801ce5 <fork+0x205>
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
	envid_t this_envid = thisenv->env_id;
  801b7a:	a1 28 64 80 00       	mov    0x806428,%eax
  801b7f:	8b 40 48             	mov    0x48(%eax),%eax
  801b82:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// LAB 4: Your code here.
	if (uvpt[pn] & PTE_SHARE) {
  801b85:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801b8c:	f6 c4 04             	test   $0x4,%ah
  801b8f:	74 52                	je     801be3 <fork+0x103>
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801b91:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801b98:	25 07 0e 00 00       	and    $0xe07,%eax
  801b9d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801ba1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ba5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ba8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bac:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801bb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bb3:	89 04 24             	mov    %eax,(%esp)
  801bb6:	e8 2c fb ff ff       	call   8016e7 <sys_page_map>
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	0f 89 22 01 00 00    	jns    801ce5 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801bc3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bc7:	c7 44 24 08 23 47 80 	movl   $0x804723,0x8(%esp)
  801bce:	00 
  801bcf:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  801bd6:	00 
  801bd7:	c7 04 24 04 47 80 00 	movl   $0x804704,(%esp)
  801bde:	e8 84 ee ff ff       	call   800a67 <_panic>
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
  801be3:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801bea:	f6 c4 08             	test   $0x8,%ah
  801bed:	75 0f                	jne    801bfe <fork+0x11e>
  801bef:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801bf6:	a8 02                	test   $0x2,%al
  801bf8:	0f 84 99 00 00 00    	je     801c97 <fork+0x1b7>
		if (uvpt[pn] & PTE_U)
  801bfe:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801c05:	83 e0 04             	and    $0x4,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
  801c08:	83 f8 01             	cmp    $0x1,%eax
  801c0b:	19 f6                	sbb    %esi,%esi
  801c0d:	83 e6 fc             	and    $0xfffffffc,%esi
  801c10:	81 c6 05 08 00 00    	add    $0x805,%esi
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
		if (uvpt[pn] & PTE_U)
			perm |= PTE_U;

		// Map page COW, U and P in child
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), perm)) < 0)
  801c16:	89 74 24 10          	mov    %esi,0x10(%esp)
  801c1a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c21:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c25:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c2c:	89 04 24             	mov    %eax,(%esp)
  801c2f:	e8 b3 fa ff ff       	call   8016e7 <sys_page_map>
  801c34:	85 c0                	test   %eax,%eax
  801c36:	79 20                	jns    801c58 <fork+0x178>
			panic("sys_page_map: %e\n", r);
  801c38:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c3c:	c7 44 24 08 23 47 80 	movl   $0x804723,0x8(%esp)
  801c43:	00 
  801c44:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  801c4b:	00 
  801c4c:	c7 04 24 04 47 80 00 	movl   $0x804704,(%esp)
  801c53:	e8 0f ee ff ff       	call   800a67 <_panic>

		// Map page COW, U and P in parent
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), this_envid, (void *) (pn*PGSIZE), perm)) < 0)
  801c58:	89 74 24 10          	mov    %esi,0x10(%esp)
  801c5c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c63:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c67:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c6b:	89 04 24             	mov    %eax,(%esp)
  801c6e:	e8 74 fa ff ff       	call   8016e7 <sys_page_map>
  801c73:	85 c0                	test   %eax,%eax
  801c75:	79 6e                	jns    801ce5 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801c77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c7b:	c7 44 24 08 23 47 80 	movl   $0x804723,0x8(%esp)
  801c82:	00 
  801c83:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  801c8a:	00 
  801c8b:	c7 04 24 04 47 80 00 	movl   $0x804704,(%esp)
  801c92:	e8 d0 ed ff ff       	call   800a67 <_panic>

	} else { // map pages that are present but not writable or COW with their original permissions
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801c97:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801c9e:	25 07 0e 00 00       	and    $0xe07,%eax
  801ca3:	89 44 24 10          	mov    %eax,0x10(%esp)
  801ca7:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cae:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cb2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801cb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cb9:	89 04 24             	mov    %eax,(%esp)
  801cbc:	e8 26 fa ff ff       	call   8016e7 <sys_page_map>
  801cc1:	85 c0                	test   %eax,%eax
  801cc3:	79 20                	jns    801ce5 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801cc5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cc9:	c7 44 24 08 23 47 80 	movl   $0x804723,0x8(%esp)
  801cd0:	00 
  801cd1:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
  801cd8:	00 
  801cd9:	c7 04 24 04 47 80 00 	movl   $0x804704,(%esp)
  801ce0:	e8 82 ed ff ff       	call   800a67 <_panic>
	// and let duppage worry about the permissions.
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
  801ce5:	83 c3 01             	add    $0x1,%ebx
  801ce8:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801cee:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  801cf4:	0f 85 5d fe ff ff    	jne    801b57 <fork+0x77>
	}

	// Allocate exception stack space for child. The child can't do this themselves
	// because the mechanism by which it would is to run the pgfault handler, which
	// needs to run on the exception stack (catch 22).
	if ((r = sys_page_alloc(child_envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801cfa:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801d01:	00 
  801d02:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801d09:	ee 
  801d0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d0d:	89 04 24             	mov    %eax,(%esp)
  801d10:	e8 7e f9 ff ff       	call   801693 <sys_page_alloc>
  801d15:	85 c0                	test   %eax,%eax
  801d17:	79 20                	jns    801d39 <fork+0x259>
		panic("sys_page_alloc: %e\n", r);
  801d19:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d1d:	c7 44 24 08 0f 47 80 	movl   $0x80470f,0x8(%esp)
  801d24:	00 
  801d25:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  801d2c:	00 
  801d2d:	c7 04 24 04 47 80 00 	movl   $0x804704,(%esp)
  801d34:	e8 2e ed ff ff       	call   800a67 <_panic>

	// Set page fault handler for the child
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801d39:	c7 44 24 04 cb 3c 80 	movl   $0x803ccb,0x4(%esp)
  801d40:	00 
  801d41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d44:	89 04 24             	mov    %eax,(%esp)
  801d47:	e8 e7 fa ff ff       	call   801833 <sys_env_set_pgfault_upcall>
  801d4c:	85 c0                	test   %eax,%eax
  801d4e:	79 20                	jns    801d70 <fork+0x290>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801d50:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d54:	c7 44 24 08 e4 46 80 	movl   $0x8046e4,0x8(%esp)
  801d5b:	00 
  801d5c:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801d63:	00 
  801d64:	c7 04 24 04 47 80 00 	movl   $0x804704,(%esp)
  801d6b:	e8 f7 ec ff ff       	call   800a67 <_panic>

	// Mark child environment as runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  801d70:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801d77:	00 
  801d78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d7b:	89 04 24             	mov    %eax,(%esp)
  801d7e:	e8 0a fa ff ff       	call   80178d <sys_env_set_status>
  801d83:	85 c0                	test   %eax,%eax
  801d85:	79 20                	jns    801da7 <fork+0x2c7>
		panic("sys_env_set_status: %e\n", r);
  801d87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d8b:	c7 44 24 08 46 47 80 	movl   $0x804746,0x8(%esp)
  801d92:	00 
  801d93:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  801d9a:	00 
  801d9b:	c7 04 24 04 47 80 00 	movl   $0x804704,(%esp)
  801da2:	e8 c0 ec ff ff       	call   800a67 <_panic>

	return child_envid;
  801da7:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801daa:	83 c4 2c             	add    $0x2c,%esp
  801dad:	5b                   	pop    %ebx
  801dae:	5e                   	pop    %esi
  801daf:	5f                   	pop    %edi
  801db0:	5d                   	pop    %ebp
  801db1:	c3                   	ret    

00801db2 <sfork>:

// Challenge!
int
sfork(void)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
  801db5:	83 ec 18             	sub    $0x18,%esp
//	return __fork(1);
	panic("sfork not implemented");
  801db8:	c7 44 24 08 5e 47 80 	movl   $0x80475e,0x8(%esp)
  801dbf:	00 
  801dc0:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  801dc7:	00 
  801dc8:	c7 04 24 04 47 80 00 	movl   $0x804704,(%esp)
  801dcf:	e8 93 ec ff ff       	call   800a67 <_panic>

00801dd4 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
  801dd7:	53                   	push   %ebx
  801dd8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ddb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dde:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801de1:	89 08                	mov    %ecx,(%eax)
	args->argv = (const char **) argv;
  801de3:	89 50 04             	mov    %edx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801de6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801deb:	83 39 01             	cmpl   $0x1,(%ecx)
  801dee:	7e 0f                	jle    801dff <argstart+0x2b>
  801df0:	85 d2                	test   %edx,%edx
  801df2:	ba 00 00 00 00       	mov    $0x0,%edx
  801df7:	bb 21 41 80 00       	mov    $0x804121,%ebx
  801dfc:	0f 44 da             	cmove  %edx,%ebx
  801dff:	89 58 08             	mov    %ebx,0x8(%eax)
	args->argvalue = 0;
  801e02:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801e09:	5b                   	pop    %ebx
  801e0a:	5d                   	pop    %ebp
  801e0b:	c3                   	ret    

00801e0c <argnext>:

int
argnext(struct Argstate *args)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	53                   	push   %ebx
  801e10:	83 ec 14             	sub    $0x14,%esp
  801e13:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801e16:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801e1d:	8b 43 08             	mov    0x8(%ebx),%eax
  801e20:	85 c0                	test   %eax,%eax
  801e22:	74 71                	je     801e95 <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  801e24:	80 38 00             	cmpb   $0x0,(%eax)
  801e27:	75 50                	jne    801e79 <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801e29:	8b 0b                	mov    (%ebx),%ecx
  801e2b:	83 39 01             	cmpl   $0x1,(%ecx)
  801e2e:	74 57                	je     801e87 <argnext+0x7b>
		    || args->argv[1][0] != '-'
  801e30:	8b 53 04             	mov    0x4(%ebx),%edx
  801e33:	8b 42 04             	mov    0x4(%edx),%eax
  801e36:	80 38 2d             	cmpb   $0x2d,(%eax)
  801e39:	75 4c                	jne    801e87 <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  801e3b:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801e3f:	74 46                	je     801e87 <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801e41:	83 c0 01             	add    $0x1,%eax
  801e44:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801e47:	8b 01                	mov    (%ecx),%eax
  801e49:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801e50:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e54:	8d 42 08             	lea    0x8(%edx),%eax
  801e57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e5b:	83 c2 04             	add    $0x4,%edx
  801e5e:	89 14 24             	mov    %edx,(%esp)
  801e61:	e8 ae f5 ff ff       	call   801414 <memmove>
		(*args->argc)--;
  801e66:	8b 03                	mov    (%ebx),%eax
  801e68:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801e6b:	8b 43 08             	mov    0x8(%ebx),%eax
  801e6e:	80 38 2d             	cmpb   $0x2d,(%eax)
  801e71:	75 06                	jne    801e79 <argnext+0x6d>
  801e73:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801e77:	74 0e                	je     801e87 <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801e79:	8b 53 08             	mov    0x8(%ebx),%edx
  801e7c:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801e7f:	83 c2 01             	add    $0x1,%edx
  801e82:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  801e85:	eb 13                	jmp    801e9a <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  801e87:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801e8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801e93:	eb 05                	jmp    801e9a <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  801e95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801e9a:	83 c4 14             	add    $0x14,%esp
  801e9d:	5b                   	pop    %ebx
  801e9e:	5d                   	pop    %ebp
  801e9f:	c3                   	ret    

00801ea0 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	53                   	push   %ebx
  801ea4:	83 ec 14             	sub    $0x14,%esp
  801ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801eaa:	8b 43 08             	mov    0x8(%ebx),%eax
  801ead:	85 c0                	test   %eax,%eax
  801eaf:	74 5a                	je     801f0b <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  801eb1:	80 38 00             	cmpb   $0x0,(%eax)
  801eb4:	74 0c                	je     801ec2 <argnextvalue+0x22>
		args->argvalue = args->curarg;
  801eb6:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801eb9:	c7 43 08 21 41 80 00 	movl   $0x804121,0x8(%ebx)
  801ec0:	eb 44                	jmp    801f06 <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  801ec2:	8b 03                	mov    (%ebx),%eax
  801ec4:	83 38 01             	cmpl   $0x1,(%eax)
  801ec7:	7e 2f                	jle    801ef8 <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  801ec9:	8b 53 04             	mov    0x4(%ebx),%edx
  801ecc:	8b 4a 04             	mov    0x4(%edx),%ecx
  801ecf:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801ed2:	8b 00                	mov    (%eax),%eax
  801ed4:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801edb:	89 44 24 08          	mov    %eax,0x8(%esp)
  801edf:	8d 42 08             	lea    0x8(%edx),%eax
  801ee2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee6:	83 c2 04             	add    $0x4,%edx
  801ee9:	89 14 24             	mov    %edx,(%esp)
  801eec:	e8 23 f5 ff ff       	call   801414 <memmove>
		(*args->argc)--;
  801ef1:	8b 03                	mov    (%ebx),%eax
  801ef3:	83 28 01             	subl   $0x1,(%eax)
  801ef6:	eb 0e                	jmp    801f06 <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  801ef8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801eff:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  801f06:	8b 43 0c             	mov    0xc(%ebx),%eax
  801f09:	eb 05                	jmp    801f10 <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  801f0b:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  801f10:	83 c4 14             	add    $0x14,%esp
  801f13:	5b                   	pop    %ebx
  801f14:	5d                   	pop    %ebp
  801f15:	c3                   	ret    

00801f16 <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	83 ec 18             	sub    $0x18,%esp
  801f1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801f1f:	8b 51 0c             	mov    0xc(%ecx),%edx
  801f22:	89 d0                	mov    %edx,%eax
  801f24:	85 d2                	test   %edx,%edx
  801f26:	75 08                	jne    801f30 <argvalue+0x1a>
  801f28:	89 0c 24             	mov    %ecx,(%esp)
  801f2b:	e8 70 ff ff ff       	call   801ea0 <argnextvalue>
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    
  801f32:	66 90                	xchg   %ax,%ax
  801f34:	66 90                	xchg   %ax,%ax
  801f36:	66 90                	xchg   %ax,%ax
  801f38:	66 90                	xchg   %ax,%ax
  801f3a:	66 90                	xchg   %ax,%ax
  801f3c:	66 90                	xchg   %ax,%ax
  801f3e:	66 90                	xchg   %ax,%ax

00801f40 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	05 00 00 00 30       	add    $0x30000000,%eax
  801f4b:	c1 e8 0c             	shr    $0xc,%eax
}
  801f4e:	5d                   	pop    %ebp
  801f4f:	c3                   	ret    

00801f50 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  801f5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f60:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801f65:	5d                   	pop    %ebp
  801f66:	c3                   	ret    

00801f67 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f6d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f72:	89 c2                	mov    %eax,%edx
  801f74:	c1 ea 16             	shr    $0x16,%edx
  801f77:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801f7e:	f6 c2 01             	test   $0x1,%dl
  801f81:	74 11                	je     801f94 <fd_alloc+0x2d>
  801f83:	89 c2                	mov    %eax,%edx
  801f85:	c1 ea 0c             	shr    $0xc,%edx
  801f88:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801f8f:	f6 c2 01             	test   $0x1,%dl
  801f92:	75 09                	jne    801f9d <fd_alloc+0x36>
			*fd_store = fd;
  801f94:	89 01                	mov    %eax,(%ecx)
			return 0;
  801f96:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9b:	eb 17                	jmp    801fb4 <fd_alloc+0x4d>
  801f9d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801fa2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801fa7:	75 c9                	jne    801f72 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801fa9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801faf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801fb4:	5d                   	pop    %ebp
  801fb5:	c3                   	ret    

00801fb6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801fbc:	83 f8 1f             	cmp    $0x1f,%eax
  801fbf:	77 36                	ja     801ff7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801fc1:	c1 e0 0c             	shl    $0xc,%eax
  801fc4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801fc9:	89 c2                	mov    %eax,%edx
  801fcb:	c1 ea 16             	shr    $0x16,%edx
  801fce:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801fd5:	f6 c2 01             	test   $0x1,%dl
  801fd8:	74 24                	je     801ffe <fd_lookup+0x48>
  801fda:	89 c2                	mov    %eax,%edx
  801fdc:	c1 ea 0c             	shr    $0xc,%edx
  801fdf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801fe6:	f6 c2 01             	test   $0x1,%dl
  801fe9:	74 1a                	je     802005 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801feb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fee:	89 02                	mov    %eax,(%edx)
	return 0;
  801ff0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff5:	eb 13                	jmp    80200a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ff7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ffc:	eb 0c                	jmp    80200a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801ffe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802003:	eb 05                	jmp    80200a <fd_lookup+0x54>
  802005:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80200a:	5d                   	pop    %ebp
  80200b:	c3                   	ret    

0080200c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	83 ec 18             	sub    $0x18,%esp
  802012:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  802015:	ba 00 00 00 00       	mov    $0x0,%edx
  80201a:	eb 13                	jmp    80202f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80201c:	39 08                	cmp    %ecx,(%eax)
  80201e:	75 0c                	jne    80202c <dev_lookup+0x20>
			*dev = devtab[i];
  802020:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802023:	89 01                	mov    %eax,(%ecx)
			return 0;
  802025:	b8 00 00 00 00       	mov    $0x0,%eax
  80202a:	eb 38                	jmp    802064 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80202c:	83 c2 01             	add    $0x1,%edx
  80202f:	8b 04 95 f0 47 80 00 	mov    0x8047f0(,%edx,4),%eax
  802036:	85 c0                	test   %eax,%eax
  802038:	75 e2                	jne    80201c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80203a:	a1 28 64 80 00       	mov    0x806428,%eax
  80203f:	8b 40 48             	mov    0x48(%eax),%eax
  802042:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802046:	89 44 24 04          	mov    %eax,0x4(%esp)
  80204a:	c7 04 24 74 47 80 00 	movl   $0x804774,(%esp)
  802051:	e8 0a eb ff ff       	call   800b60 <cprintf>
	*dev = 0;
  802056:	8b 45 0c             	mov    0xc(%ebp),%eax
  802059:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80205f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	56                   	push   %esi
  80206a:	53                   	push   %ebx
  80206b:	83 ec 20             	sub    $0x20,%esp
  80206e:	8b 75 08             	mov    0x8(%ebp),%esi
  802071:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802074:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802077:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80207b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802081:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802084:	89 04 24             	mov    %eax,(%esp)
  802087:	e8 2a ff ff ff       	call   801fb6 <fd_lookup>
  80208c:	85 c0                	test   %eax,%eax
  80208e:	78 05                	js     802095 <fd_close+0x2f>
	    || fd != fd2)
  802090:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  802093:	74 0c                	je     8020a1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  802095:	84 db                	test   %bl,%bl
  802097:	ba 00 00 00 00       	mov    $0x0,%edx
  80209c:	0f 44 c2             	cmove  %edx,%eax
  80209f:	eb 3f                	jmp    8020e0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8020a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a8:	8b 06                	mov    (%esi),%eax
  8020aa:	89 04 24             	mov    %eax,(%esp)
  8020ad:	e8 5a ff ff ff       	call   80200c <dev_lookup>
  8020b2:	89 c3                	mov    %eax,%ebx
  8020b4:	85 c0                	test   %eax,%eax
  8020b6:	78 16                	js     8020ce <fd_close+0x68>
		if (dev->dev_close)
  8020b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8020be:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	74 07                	je     8020ce <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8020c7:	89 34 24             	mov    %esi,(%esp)
  8020ca:	ff d0                	call   *%eax
  8020cc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8020ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d9:	e8 5c f6 ff ff       	call   80173a <sys_page_unmap>
	return r;
  8020de:	89 d8                	mov    %ebx,%eax
}
  8020e0:	83 c4 20             	add    $0x20,%esp
  8020e3:	5b                   	pop    %ebx
  8020e4:	5e                   	pop    %esi
  8020e5:	5d                   	pop    %ebp
  8020e6:	c3                   	ret    

008020e7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	89 04 24             	mov    %eax,(%esp)
  8020fa:	e8 b7 fe ff ff       	call   801fb6 <fd_lookup>
  8020ff:	89 c2                	mov    %eax,%edx
  802101:	85 d2                	test   %edx,%edx
  802103:	78 13                	js     802118 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  802105:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80210c:	00 
  80210d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802110:	89 04 24             	mov    %eax,(%esp)
  802113:	e8 4e ff ff ff       	call   802066 <fd_close>
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <close_all>:

void
close_all(void)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	53                   	push   %ebx
  80211e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802121:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802126:	89 1c 24             	mov    %ebx,(%esp)
  802129:	e8 b9 ff ff ff       	call   8020e7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80212e:	83 c3 01             	add    $0x1,%ebx
  802131:	83 fb 20             	cmp    $0x20,%ebx
  802134:	75 f0                	jne    802126 <close_all+0xc>
		close(i);
}
  802136:	83 c4 14             	add    $0x14,%esp
  802139:	5b                   	pop    %ebx
  80213a:	5d                   	pop    %ebp
  80213b:	c3                   	ret    

0080213c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	57                   	push   %edi
  802140:	56                   	push   %esi
  802141:	53                   	push   %ebx
  802142:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802145:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802148:	89 44 24 04          	mov    %eax,0x4(%esp)
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	89 04 24             	mov    %eax,(%esp)
  802152:	e8 5f fe ff ff       	call   801fb6 <fd_lookup>
  802157:	89 c2                	mov    %eax,%edx
  802159:	85 d2                	test   %edx,%edx
  80215b:	0f 88 e1 00 00 00    	js     802242 <dup+0x106>
		return r;
	close(newfdnum);
  802161:	8b 45 0c             	mov    0xc(%ebp),%eax
  802164:	89 04 24             	mov    %eax,(%esp)
  802167:	e8 7b ff ff ff       	call   8020e7 <close>

	newfd = INDEX2FD(newfdnum);
  80216c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80216f:	c1 e3 0c             	shl    $0xc,%ebx
  802172:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  802178:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80217b:	89 04 24             	mov    %eax,(%esp)
  80217e:	e8 cd fd ff ff       	call   801f50 <fd2data>
  802183:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  802185:	89 1c 24             	mov    %ebx,(%esp)
  802188:	e8 c3 fd ff ff       	call   801f50 <fd2data>
  80218d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80218f:	89 f0                	mov    %esi,%eax
  802191:	c1 e8 16             	shr    $0x16,%eax
  802194:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80219b:	a8 01                	test   $0x1,%al
  80219d:	74 43                	je     8021e2 <dup+0xa6>
  80219f:	89 f0                	mov    %esi,%eax
  8021a1:	c1 e8 0c             	shr    $0xc,%eax
  8021a4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8021ab:	f6 c2 01             	test   $0x1,%dl
  8021ae:	74 32                	je     8021e2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8021b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8021b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8021bc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8021c0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021cb:	00 
  8021cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d7:	e8 0b f5 ff ff       	call   8016e7 <sys_page_map>
  8021dc:	89 c6                	mov    %eax,%esi
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	78 3e                	js     802220 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021e5:	89 c2                	mov    %eax,%edx
  8021e7:	c1 ea 0c             	shr    $0xc,%edx
  8021ea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8021f1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8021f7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8021fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802206:	00 
  802207:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802212:	e8 d0 f4 ff ff       	call   8016e7 <sys_page_map>
  802217:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  802219:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80221c:	85 f6                	test   %esi,%esi
  80221e:	79 22                	jns    802242 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802220:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802224:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80222b:	e8 0a f5 ff ff       	call   80173a <sys_page_unmap>
	sys_page_unmap(0, nva);
  802230:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802234:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80223b:	e8 fa f4 ff ff       	call   80173a <sys_page_unmap>
	return r;
  802240:	89 f0                	mov    %esi,%eax
}
  802242:	83 c4 3c             	add    $0x3c,%esp
  802245:	5b                   	pop    %ebx
  802246:	5e                   	pop    %esi
  802247:	5f                   	pop    %edi
  802248:	5d                   	pop    %ebp
  802249:	c3                   	ret    

0080224a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	53                   	push   %ebx
  80224e:	83 ec 24             	sub    $0x24,%esp
  802251:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802254:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802257:	89 44 24 04          	mov    %eax,0x4(%esp)
  80225b:	89 1c 24             	mov    %ebx,(%esp)
  80225e:	e8 53 fd ff ff       	call   801fb6 <fd_lookup>
  802263:	89 c2                	mov    %eax,%edx
  802265:	85 d2                	test   %edx,%edx
  802267:	78 6d                	js     8022d6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802269:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80226c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802273:	8b 00                	mov    (%eax),%eax
  802275:	89 04 24             	mov    %eax,(%esp)
  802278:	e8 8f fd ff ff       	call   80200c <dev_lookup>
  80227d:	85 c0                	test   %eax,%eax
  80227f:	78 55                	js     8022d6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802284:	8b 50 08             	mov    0x8(%eax),%edx
  802287:	83 e2 03             	and    $0x3,%edx
  80228a:	83 fa 01             	cmp    $0x1,%edx
  80228d:	75 23                	jne    8022b2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80228f:	a1 28 64 80 00       	mov    0x806428,%eax
  802294:	8b 40 48             	mov    0x48(%eax),%eax
  802297:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80229b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80229f:	c7 04 24 b5 47 80 00 	movl   $0x8047b5,(%esp)
  8022a6:	e8 b5 e8 ff ff       	call   800b60 <cprintf>
		return -E_INVAL;
  8022ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022b0:	eb 24                	jmp    8022d6 <read+0x8c>
	}
	if (!dev->dev_read)
  8022b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b5:	8b 52 08             	mov    0x8(%edx),%edx
  8022b8:	85 d2                	test   %edx,%edx
  8022ba:	74 15                	je     8022d1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8022bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022ca:	89 04 24             	mov    %eax,(%esp)
  8022cd:	ff d2                	call   *%edx
  8022cf:	eb 05                	jmp    8022d6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8022d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8022d6:	83 c4 24             	add    $0x24,%esp
  8022d9:	5b                   	pop    %ebx
  8022da:	5d                   	pop    %ebp
  8022db:	c3                   	ret    

008022dc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
  8022df:	57                   	push   %edi
  8022e0:	56                   	push   %esi
  8022e1:	53                   	push   %ebx
  8022e2:	83 ec 1c             	sub    $0x1c,%esp
  8022e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022e8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022f0:	eb 23                	jmp    802315 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022f2:	89 f0                	mov    %esi,%eax
  8022f4:	29 d8                	sub    %ebx,%eax
  8022f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022fa:	89 d8                	mov    %ebx,%eax
  8022fc:	03 45 0c             	add    0xc(%ebp),%eax
  8022ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  802303:	89 3c 24             	mov    %edi,(%esp)
  802306:	e8 3f ff ff ff       	call   80224a <read>
		if (m < 0)
  80230b:	85 c0                	test   %eax,%eax
  80230d:	78 10                	js     80231f <readn+0x43>
			return m;
		if (m == 0)
  80230f:	85 c0                	test   %eax,%eax
  802311:	74 0a                	je     80231d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802313:	01 c3                	add    %eax,%ebx
  802315:	39 f3                	cmp    %esi,%ebx
  802317:	72 d9                	jb     8022f2 <readn+0x16>
  802319:	89 d8                	mov    %ebx,%eax
  80231b:	eb 02                	jmp    80231f <readn+0x43>
  80231d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80231f:	83 c4 1c             	add    $0x1c,%esp
  802322:	5b                   	pop    %ebx
  802323:	5e                   	pop    %esi
  802324:	5f                   	pop    %edi
  802325:	5d                   	pop    %ebp
  802326:	c3                   	ret    

00802327 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
  80232a:	53                   	push   %ebx
  80232b:	83 ec 24             	sub    $0x24,%esp
  80232e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802331:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802334:	89 44 24 04          	mov    %eax,0x4(%esp)
  802338:	89 1c 24             	mov    %ebx,(%esp)
  80233b:	e8 76 fc ff ff       	call   801fb6 <fd_lookup>
  802340:	89 c2                	mov    %eax,%edx
  802342:	85 d2                	test   %edx,%edx
  802344:	78 68                	js     8023ae <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802346:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802349:	89 44 24 04          	mov    %eax,0x4(%esp)
  80234d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802350:	8b 00                	mov    (%eax),%eax
  802352:	89 04 24             	mov    %eax,(%esp)
  802355:	e8 b2 fc ff ff       	call   80200c <dev_lookup>
  80235a:	85 c0                	test   %eax,%eax
  80235c:	78 50                	js     8023ae <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80235e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802361:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802365:	75 23                	jne    80238a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802367:	a1 28 64 80 00       	mov    0x806428,%eax
  80236c:	8b 40 48             	mov    0x48(%eax),%eax
  80236f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802373:	89 44 24 04          	mov    %eax,0x4(%esp)
  802377:	c7 04 24 d1 47 80 00 	movl   $0x8047d1,(%esp)
  80237e:	e8 dd e7 ff ff       	call   800b60 <cprintf>
		return -E_INVAL;
  802383:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802388:	eb 24                	jmp    8023ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80238a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238d:	8b 52 0c             	mov    0xc(%edx),%edx
  802390:	85 d2                	test   %edx,%edx
  802392:	74 15                	je     8023a9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802394:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802397:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80239b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80239e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023a2:	89 04 24             	mov    %eax,(%esp)
  8023a5:	ff d2                	call   *%edx
  8023a7:	eb 05                	jmp    8023ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8023a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8023ae:	83 c4 24             	add    $0x24,%esp
  8023b1:	5b                   	pop    %ebx
  8023b2:	5d                   	pop    %ebp
  8023b3:	c3                   	ret    

008023b4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023ba:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8023bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c4:	89 04 24             	mov    %eax,(%esp)
  8023c7:	e8 ea fb ff ff       	call   801fb6 <fd_lookup>
  8023cc:	85 c0                	test   %eax,%eax
  8023ce:	78 0e                	js     8023de <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8023d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8023d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
  8023e3:	53                   	push   %ebx
  8023e4:	83 ec 24             	sub    $0x24,%esp
  8023e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f1:	89 1c 24             	mov    %ebx,(%esp)
  8023f4:	e8 bd fb ff ff       	call   801fb6 <fd_lookup>
  8023f9:	89 c2                	mov    %eax,%edx
  8023fb:	85 d2                	test   %edx,%edx
  8023fd:	78 61                	js     802460 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802402:	89 44 24 04          	mov    %eax,0x4(%esp)
  802406:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802409:	8b 00                	mov    (%eax),%eax
  80240b:	89 04 24             	mov    %eax,(%esp)
  80240e:	e8 f9 fb ff ff       	call   80200c <dev_lookup>
  802413:	85 c0                	test   %eax,%eax
  802415:	78 49                	js     802460 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80241e:	75 23                	jne    802443 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802420:	a1 28 64 80 00       	mov    0x806428,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802425:	8b 40 48             	mov    0x48(%eax),%eax
  802428:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80242c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802430:	c7 04 24 94 47 80 00 	movl   $0x804794,(%esp)
  802437:	e8 24 e7 ff ff       	call   800b60 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80243c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802441:	eb 1d                	jmp    802460 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  802443:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802446:	8b 52 18             	mov    0x18(%edx),%edx
  802449:	85 d2                	test   %edx,%edx
  80244b:	74 0e                	je     80245b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80244d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802450:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802454:	89 04 24             	mov    %eax,(%esp)
  802457:	ff d2                	call   *%edx
  802459:	eb 05                	jmp    802460 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80245b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  802460:	83 c4 24             	add    $0x24,%esp
  802463:	5b                   	pop    %ebx
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    

00802466 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
  802469:	53                   	push   %ebx
  80246a:	83 ec 24             	sub    $0x24,%esp
  80246d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802470:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802473:	89 44 24 04          	mov    %eax,0x4(%esp)
  802477:	8b 45 08             	mov    0x8(%ebp),%eax
  80247a:	89 04 24             	mov    %eax,(%esp)
  80247d:	e8 34 fb ff ff       	call   801fb6 <fd_lookup>
  802482:	89 c2                	mov    %eax,%edx
  802484:	85 d2                	test   %edx,%edx
  802486:	78 52                	js     8024da <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802488:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80248b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80248f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802492:	8b 00                	mov    (%eax),%eax
  802494:	89 04 24             	mov    %eax,(%esp)
  802497:	e8 70 fb ff ff       	call   80200c <dev_lookup>
  80249c:	85 c0                	test   %eax,%eax
  80249e:	78 3a                	js     8024da <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8024a7:	74 2c                	je     8024d5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8024a9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8024ac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8024b3:	00 00 00 
	stat->st_isdir = 0;
  8024b6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024bd:	00 00 00 
	stat->st_dev = dev;
  8024c0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8024c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024cd:	89 14 24             	mov    %edx,(%esp)
  8024d0:	ff 50 14             	call   *0x14(%eax)
  8024d3:	eb 05                	jmp    8024da <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8024d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8024da:	83 c4 24             	add    $0x24,%esp
  8024dd:	5b                   	pop    %ebx
  8024de:	5d                   	pop    %ebp
  8024df:	c3                   	ret    

008024e0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
  8024e3:	56                   	push   %esi
  8024e4:	53                   	push   %ebx
  8024e5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8024e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8024ef:	00 
  8024f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f3:	89 04 24             	mov    %eax,(%esp)
  8024f6:	e8 84 02 00 00       	call   80277f <open>
  8024fb:	89 c3                	mov    %eax,%ebx
  8024fd:	85 db                	test   %ebx,%ebx
  8024ff:	78 1b                	js     80251c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  802501:	8b 45 0c             	mov    0xc(%ebp),%eax
  802504:	89 44 24 04          	mov    %eax,0x4(%esp)
  802508:	89 1c 24             	mov    %ebx,(%esp)
  80250b:	e8 56 ff ff ff       	call   802466 <fstat>
  802510:	89 c6                	mov    %eax,%esi
	close(fd);
  802512:	89 1c 24             	mov    %ebx,(%esp)
  802515:	e8 cd fb ff ff       	call   8020e7 <close>
	return r;
  80251a:	89 f0                	mov    %esi,%eax
}
  80251c:	83 c4 10             	add    $0x10,%esp
  80251f:	5b                   	pop    %ebx
  802520:	5e                   	pop    %esi
  802521:	5d                   	pop    %ebp
  802522:	c3                   	ret    

00802523 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802523:	55                   	push   %ebp
  802524:	89 e5                	mov    %esp,%ebp
  802526:	56                   	push   %esi
  802527:	53                   	push   %ebx
  802528:	83 ec 10             	sub    $0x10,%esp
  80252b:	89 c6                	mov    %eax,%esi
  80252d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80252f:	83 3d 20 64 80 00 00 	cmpl   $0x0,0x806420
  802536:	75 11                	jne    802549 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802538:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80253f:	e8 a1 18 00 00       	call   803de5 <ipc_find_env>
  802544:	a3 20 64 80 00       	mov    %eax,0x806420
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802549:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802550:	00 
  802551:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802558:	00 
  802559:	89 74 24 04          	mov    %esi,0x4(%esp)
  80255d:	a1 20 64 80 00       	mov    0x806420,%eax
  802562:	89 04 24             	mov    %eax,(%esp)
  802565:	e8 ee 17 00 00       	call   803d58 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80256a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802571:	00 
  802572:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802576:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80257d:	e8 6e 17 00 00       	call   803cf0 <ipc_recv>
}
  802582:	83 c4 10             	add    $0x10,%esp
  802585:	5b                   	pop    %ebx
  802586:	5e                   	pop    %esi
  802587:	5d                   	pop    %ebp
  802588:	c3                   	ret    

00802589 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802589:	55                   	push   %ebp
  80258a:	89 e5                	mov    %esp,%ebp
  80258c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80258f:	8b 45 08             	mov    0x8(%ebp),%eax
  802592:	8b 40 0c             	mov    0xc(%eax),%eax
  802595:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  80259a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80259d:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8025a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8025a7:	b8 02 00 00 00       	mov    $0x2,%eax
  8025ac:	e8 72 ff ff ff       	call   802523 <fsipc>
}
  8025b1:	c9                   	leave  
  8025b2:	c3                   	ret    

008025b3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8025b3:	55                   	push   %ebp
  8025b4:	89 e5                	mov    %esp,%ebp
  8025b6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8025b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bf:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8025c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8025c9:	b8 06 00 00 00       	mov    $0x6,%eax
  8025ce:	e8 50 ff ff ff       	call   802523 <fsipc>
}
  8025d3:	c9                   	leave  
  8025d4:	c3                   	ret    

008025d5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8025d5:	55                   	push   %ebp
  8025d6:	89 e5                	mov    %esp,%ebp
  8025d8:	53                   	push   %ebx
  8025d9:	83 ec 14             	sub    $0x14,%esp
  8025dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8025df:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e5:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8025ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8025ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8025f4:	e8 2a ff ff ff       	call   802523 <fsipc>
  8025f9:	89 c2                	mov    %eax,%edx
  8025fb:	85 d2                	test   %edx,%edx
  8025fd:	78 2b                	js     80262a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8025ff:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802606:	00 
  802607:	89 1c 24             	mov    %ebx,(%esp)
  80260a:	e8 68 ec ff ff       	call   801277 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80260f:	a1 80 70 80 00       	mov    0x807080,%eax
  802614:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80261a:	a1 84 70 80 00       	mov    0x807084,%eax
  80261f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802625:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80262a:	83 c4 14             	add    $0x14,%esp
  80262d:	5b                   	pop    %ebx
  80262e:	5d                   	pop    %ebp
  80262f:	c3                   	ret    

00802630 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802630:	55                   	push   %ebp
  802631:	89 e5                	mov    %esp,%ebp
  802633:	53                   	push   %ebx
  802634:	83 ec 14             	sub    $0x14,%esp
  802637:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80263a:	8b 45 08             	mov    0x8(%ebp),%eax
  80263d:	8b 40 0c             	mov    0xc(%eax),%eax
  802640:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  802645:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80264b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  802650:	0f 46 c3             	cmovbe %ebx,%eax
  802653:	a3 04 70 80 00       	mov    %eax,0x807004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  802658:	89 44 24 08          	mov    %eax,0x8(%esp)
  80265c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80265f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802663:	c7 04 24 08 70 80 00 	movl   $0x807008,(%esp)
  80266a:	e8 a5 ed ff ff       	call   801414 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80266f:	ba 00 00 00 00       	mov    $0x0,%edx
  802674:	b8 04 00 00 00       	mov    $0x4,%eax
  802679:	e8 a5 fe ff ff       	call   802523 <fsipc>
  80267e:	85 c0                	test   %eax,%eax
  802680:	78 53                	js     8026d5 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  802682:	39 c3                	cmp    %eax,%ebx
  802684:	73 24                	jae    8026aa <devfile_write+0x7a>
  802686:	c7 44 24 0c 04 48 80 	movl   $0x804804,0xc(%esp)
  80268d:	00 
  80268e:	c7 44 24 08 55 42 80 	movl   $0x804255,0x8(%esp)
  802695:	00 
  802696:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  80269d:	00 
  80269e:	c7 04 24 0b 48 80 00 	movl   $0x80480b,(%esp)
  8026a5:	e8 bd e3 ff ff       	call   800a67 <_panic>
	assert(r <= PGSIZE);
  8026aa:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8026af:	7e 24                	jle    8026d5 <devfile_write+0xa5>
  8026b1:	c7 44 24 0c 16 48 80 	movl   $0x804816,0xc(%esp)
  8026b8:	00 
  8026b9:	c7 44 24 08 55 42 80 	movl   $0x804255,0x8(%esp)
  8026c0:	00 
  8026c1:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  8026c8:	00 
  8026c9:	c7 04 24 0b 48 80 00 	movl   $0x80480b,(%esp)
  8026d0:	e8 92 e3 ff ff       	call   800a67 <_panic>
	return r;
}
  8026d5:	83 c4 14             	add    $0x14,%esp
  8026d8:	5b                   	pop    %ebx
  8026d9:	5d                   	pop    %ebp
  8026da:	c3                   	ret    

008026db <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8026db:	55                   	push   %ebp
  8026dc:	89 e5                	mov    %esp,%ebp
  8026de:	56                   	push   %esi
  8026df:	53                   	push   %ebx
  8026e0:	83 ec 10             	sub    $0x10,%esp
  8026e3:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8026e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ec:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  8026f1:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8026f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026fc:	b8 03 00 00 00       	mov    $0x3,%eax
  802701:	e8 1d fe ff ff       	call   802523 <fsipc>
  802706:	89 c3                	mov    %eax,%ebx
  802708:	85 c0                	test   %eax,%eax
  80270a:	78 6a                	js     802776 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  80270c:	39 c6                	cmp    %eax,%esi
  80270e:	73 24                	jae    802734 <devfile_read+0x59>
  802710:	c7 44 24 0c 04 48 80 	movl   $0x804804,0xc(%esp)
  802717:	00 
  802718:	c7 44 24 08 55 42 80 	movl   $0x804255,0x8(%esp)
  80271f:	00 
  802720:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  802727:	00 
  802728:	c7 04 24 0b 48 80 00 	movl   $0x80480b,(%esp)
  80272f:	e8 33 e3 ff ff       	call   800a67 <_panic>
	assert(r <= PGSIZE);
  802734:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802739:	7e 24                	jle    80275f <devfile_read+0x84>
  80273b:	c7 44 24 0c 16 48 80 	movl   $0x804816,0xc(%esp)
  802742:	00 
  802743:	c7 44 24 08 55 42 80 	movl   $0x804255,0x8(%esp)
  80274a:	00 
  80274b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  802752:	00 
  802753:	c7 04 24 0b 48 80 00 	movl   $0x80480b,(%esp)
  80275a:	e8 08 e3 ff ff       	call   800a67 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80275f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802763:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  80276a:	00 
  80276b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80276e:	89 04 24             	mov    %eax,(%esp)
  802771:	e8 9e ec ff ff       	call   801414 <memmove>
	return r;
}
  802776:	89 d8                	mov    %ebx,%eax
  802778:	83 c4 10             	add    $0x10,%esp
  80277b:	5b                   	pop    %ebx
  80277c:	5e                   	pop    %esi
  80277d:	5d                   	pop    %ebp
  80277e:	c3                   	ret    

0080277f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80277f:	55                   	push   %ebp
  802780:	89 e5                	mov    %esp,%ebp
  802782:	53                   	push   %ebx
  802783:	83 ec 24             	sub    $0x24,%esp
  802786:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802789:	89 1c 24             	mov    %ebx,(%esp)
  80278c:	e8 af ea ff ff       	call   801240 <strlen>
  802791:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802796:	7f 60                	jg     8027f8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  802798:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80279b:	89 04 24             	mov    %eax,(%esp)
  80279e:	e8 c4 f7 ff ff       	call   801f67 <fd_alloc>
  8027a3:	89 c2                	mov    %eax,%edx
  8027a5:	85 d2                	test   %edx,%edx
  8027a7:	78 54                	js     8027fd <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8027a9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027ad:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  8027b4:	e8 be ea ff ff       	call   801277 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8027b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027bc:	a3 00 74 80 00       	mov    %eax,0x807400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8027c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8027c9:	e8 55 fd ff ff       	call   802523 <fsipc>
  8027ce:	89 c3                	mov    %eax,%ebx
  8027d0:	85 c0                	test   %eax,%eax
  8027d2:	79 17                	jns    8027eb <open+0x6c>
		fd_close(fd, 0);
  8027d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8027db:	00 
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	89 04 24             	mov    %eax,(%esp)
  8027e2:	e8 7f f8 ff ff       	call   802066 <fd_close>
		return r;
  8027e7:	89 d8                	mov    %ebx,%eax
  8027e9:	eb 12                	jmp    8027fd <open+0x7e>
	}

	return fd2num(fd);
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	89 04 24             	mov    %eax,(%esp)
  8027f1:	e8 4a f7 ff ff       	call   801f40 <fd2num>
  8027f6:	eb 05                	jmp    8027fd <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8027f8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8027fd:	83 c4 24             	add    $0x24,%esp
  802800:	5b                   	pop    %ebx
  802801:	5d                   	pop    %ebp
  802802:	c3                   	ret    

00802803 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802803:	55                   	push   %ebp
  802804:	89 e5                	mov    %esp,%ebp
  802806:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802809:	ba 00 00 00 00       	mov    $0x0,%edx
  80280e:	b8 08 00 00 00       	mov    $0x8,%eax
  802813:	e8 0b fd ff ff       	call   802523 <fsipc>
}
  802818:	c9                   	leave  
  802819:	c3                   	ret    

0080281a <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80281a:	55                   	push   %ebp
  80281b:	89 e5                	mov    %esp,%ebp
  80281d:	53                   	push   %ebx
  80281e:	83 ec 14             	sub    $0x14,%esp
  802821:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  802823:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  802827:	7e 31                	jle    80285a <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802829:	8b 40 04             	mov    0x4(%eax),%eax
  80282c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802830:	8d 43 10             	lea    0x10(%ebx),%eax
  802833:	89 44 24 04          	mov    %eax,0x4(%esp)
  802837:	8b 03                	mov    (%ebx),%eax
  802839:	89 04 24             	mov    %eax,(%esp)
  80283c:	e8 e6 fa ff ff       	call   802327 <write>
		if (result > 0)
  802841:	85 c0                	test   %eax,%eax
  802843:	7e 03                	jle    802848 <writebuf+0x2e>
			b->result += result;
  802845:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  802848:	39 43 04             	cmp    %eax,0x4(%ebx)
  80284b:	74 0d                	je     80285a <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  80284d:	85 c0                	test   %eax,%eax
  80284f:	ba 00 00 00 00       	mov    $0x0,%edx
  802854:	0f 4f c2             	cmovg  %edx,%eax
  802857:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80285a:	83 c4 14             	add    $0x14,%esp
  80285d:	5b                   	pop    %ebx
  80285e:	5d                   	pop    %ebp
  80285f:	c3                   	ret    

00802860 <putch>:

static void
putch(int ch, void *thunk)
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
  802863:	53                   	push   %ebx
  802864:	83 ec 04             	sub    $0x4,%esp
  802867:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80286a:	8b 53 04             	mov    0x4(%ebx),%edx
  80286d:	8d 42 01             	lea    0x1(%edx),%eax
  802870:	89 43 04             	mov    %eax,0x4(%ebx)
  802873:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802876:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80287a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80287f:	75 0e                	jne    80288f <putch+0x2f>
		writebuf(b);
  802881:	89 d8                	mov    %ebx,%eax
  802883:	e8 92 ff ff ff       	call   80281a <writebuf>
		b->idx = 0;
  802888:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  80288f:	83 c4 04             	add    $0x4,%esp
  802892:	5b                   	pop    %ebx
  802893:	5d                   	pop    %ebp
  802894:	c3                   	ret    

00802895 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802895:	55                   	push   %ebp
  802896:	89 e5                	mov    %esp,%ebp
  802898:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  80289e:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a1:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8028a7:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8028ae:	00 00 00 
	b.result = 0;
  8028b1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8028b8:	00 00 00 
	b.error = 1;
  8028bb:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8028c2:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8028c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8028c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028d3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8028d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028dd:	c7 04 24 60 28 80 00 	movl   $0x802860,(%esp)
  8028e4:	e8 05 e4 ff ff       	call   800cee <vprintfmt>
	if (b.idx > 0)
  8028e9:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8028f0:	7e 0b                	jle    8028fd <vfprintf+0x68>
		writebuf(&b);
  8028f2:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8028f8:	e8 1d ff ff ff       	call   80281a <writebuf>

	return (b.result ? b.result : b.error);
  8028fd:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802903:	85 c0                	test   %eax,%eax
  802905:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80290c:	c9                   	leave  
  80290d:	c3                   	ret    

0080290e <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80290e:	55                   	push   %ebp
  80290f:	89 e5                	mov    %esp,%ebp
  802911:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802914:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  802917:	89 44 24 08          	mov    %eax,0x8(%esp)
  80291b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80291e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802922:	8b 45 08             	mov    0x8(%ebp),%eax
  802925:	89 04 24             	mov    %eax,(%esp)
  802928:	e8 68 ff ff ff       	call   802895 <vfprintf>
	va_end(ap);

	return cnt;
}
  80292d:	c9                   	leave  
  80292e:	c3                   	ret    

0080292f <printf>:

int
printf(const char *fmt, ...)
{
  80292f:	55                   	push   %ebp
  802930:	89 e5                	mov    %esp,%ebp
  802932:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802935:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  802938:	89 44 24 08          	mov    %eax,0x8(%esp)
  80293c:	8b 45 08             	mov    0x8(%ebp),%eax
  80293f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802943:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80294a:	e8 46 ff ff ff       	call   802895 <vfprintf>
	va_end(ap);

	return cnt;
}
  80294f:	c9                   	leave  
  802950:	c3                   	ret    
  802951:	66 90                	xchg   %ax,%ax
  802953:	66 90                	xchg   %ax,%ax
  802955:	66 90                	xchg   %ax,%ax
  802957:	66 90                	xchg   %ax,%ax
  802959:	66 90                	xchg   %ax,%ax
  80295b:	66 90                	xchg   %ax,%ax
  80295d:	66 90                	xchg   %ax,%ax
  80295f:	90                   	nop

00802960 <map_segment>:
}

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  802960:	55                   	push   %ebp
  802961:	89 e5                	mov    %esp,%ebp
  802963:	57                   	push   %edi
  802964:	56                   	push   %esi
  802965:	53                   	push   %ebx
  802966:	83 ec 2c             	sub    $0x2c,%esp
  802969:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80296c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80296f:	89 d0                	mov    %edx,%eax
  802971:	25 ff 0f 00 00       	and    $0xfff,%eax
  802976:	74 0b                	je     802983 <map_segment+0x23>
		va -= i;
  802978:	29 c2                	sub    %eax,%edx
		memsz += i;
  80297a:	01 45 e4             	add    %eax,-0x1c(%ebp)
		filesz += i;
  80297d:	01 45 0c             	add    %eax,0xc(%ebp)
		fileoffset -= i;
  802980:	29 45 10             	sub    %eax,0x10(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802983:	89 d6                	mov    %edx,%esi
  802985:	bb 00 00 00 00       	mov    $0x0,%ebx
  80298a:	e9 ff 00 00 00       	jmp    802a8e <map_segment+0x12e>
		if (i >= filesz) {
  80298f:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
  802992:	77 23                	ja     8029b7 <map_segment+0x57>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802994:	8b 45 14             	mov    0x14(%ebp),%eax
  802997:	89 44 24 08          	mov    %eax,0x8(%esp)
  80299b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80299f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029a2:	89 04 24             	mov    %eax,(%esp)
  8029a5:	e8 e9 ec ff ff       	call   801693 <sys_page_alloc>
  8029aa:	85 c0                	test   %eax,%eax
  8029ac:	0f 89 d0 00 00 00    	jns    802a82 <map_segment+0x122>
  8029b2:	e9 e7 00 00 00       	jmp    802a9e <map_segment+0x13e>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8029b7:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8029be:	00 
  8029bf:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8029c6:	00 
  8029c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029ce:	e8 c0 ec ff ff       	call   801693 <sys_page_alloc>
  8029d3:	85 c0                	test   %eax,%eax
  8029d5:	0f 88 c3 00 00 00    	js     802a9e <map_segment+0x13e>
  8029db:	89 f8                	mov    %edi,%eax
  8029dd:	03 45 10             	add    0x10(%ebp),%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8029e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e7:	89 04 24             	mov    %eax,(%esp)
  8029ea:	e8 c5 f9 ff ff       	call   8023b4 <seek>
  8029ef:	85 c0                	test   %eax,%eax
  8029f1:	0f 88 a7 00 00 00    	js     802a9e <map_segment+0x13e>
  8029f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029fa:	29 f8                	sub    %edi,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8029fc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802a01:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802a06:	0f 47 c1             	cmova  %ecx,%eax
  802a09:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a0d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802a14:	00 
  802a15:	8b 45 08             	mov    0x8(%ebp),%eax
  802a18:	89 04 24             	mov    %eax,(%esp)
  802a1b:	e8 bc f8 ff ff       	call   8022dc <readn>
  802a20:	85 c0                	test   %eax,%eax
  802a22:	78 7a                	js     802a9e <map_segment+0x13e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802a24:	8b 45 14             	mov    0x14(%ebp),%eax
  802a27:	89 44 24 10          	mov    %eax,0x10(%esp)
  802a2b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802a2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a32:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a36:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802a3d:	00 
  802a3e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a45:	e8 9d ec ff ff       	call   8016e7 <sys_page_map>
  802a4a:	85 c0                	test   %eax,%eax
  802a4c:	79 20                	jns    802a6e <map_segment+0x10e>
				panic("spawn: sys_page_map data: %e", r);
  802a4e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a52:	c7 44 24 08 22 48 80 	movl   $0x804822,0x8(%esp)
  802a59:	00 
  802a5a:	c7 44 24 04 ac 01 00 	movl   $0x1ac,0x4(%esp)
  802a61:	00 
  802a62:	c7 04 24 3f 48 80 00 	movl   $0x80483f,(%esp)
  802a69:	e8 f9 df ff ff       	call   800a67 <_panic>
			sys_page_unmap(0, UTEMP);
  802a6e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802a75:	00 
  802a76:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a7d:	e8 b8 ec ff ff       	call   80173a <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802a82:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802a88:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802a8e:	89 df                	mov    %ebx,%edi
  802a90:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  802a93:	0f 87 f6 fe ff ff    	ja     80298f <map_segment+0x2f>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  802a99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a9e:	83 c4 2c             	add    $0x2c,%esp
  802aa1:	5b                   	pop    %ebx
  802aa2:	5e                   	pop    %esi
  802aa3:	5f                   	pop    %edi
  802aa4:	5d                   	pop    %ebp
  802aa5:	c3                   	ret    

00802aa6 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802aa6:	55                   	push   %ebp
  802aa7:	89 e5                	mov    %esp,%ebp
  802aa9:	57                   	push   %edi
  802aaa:	56                   	push   %esi
  802aab:	53                   	push   %ebx
  802aac:	81 ec 8c 02 00 00    	sub    $0x28c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802ab2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802ab9:	00 
  802aba:	8b 45 08             	mov    0x8(%ebp),%eax
  802abd:	89 04 24             	mov    %eax,(%esp)
  802ac0:	e8 ba fc ff ff       	call   80277f <open>
  802ac5:	89 c1                	mov    %eax,%ecx
  802ac7:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  802acd:	85 c0                	test   %eax,%eax
  802acf:	0f 88 9f 03 00 00    	js     802e74 <spawn+0x3ce>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802ad5:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  802adc:	00 
  802add:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ae7:	89 0c 24             	mov    %ecx,(%esp)
  802aea:	e8 ed f7 ff ff       	call   8022dc <readn>
  802aef:	3d 00 02 00 00       	cmp    $0x200,%eax
  802af4:	75 0c                	jne    802b02 <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  802af6:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802afd:	45 4c 46 
  802b00:	74 36                	je     802b38 <spawn+0x92>
		close(fd);
  802b02:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802b08:	89 04 24             	mov    %eax,(%esp)
  802b0b:	e8 d7 f5 ff ff       	call   8020e7 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802b10:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  802b17:	46 
  802b18:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  802b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b22:	c7 04 24 4b 48 80 00 	movl   $0x80484b,(%esp)
  802b29:	e8 32 e0 ff ff       	call   800b60 <cprintf>
		return -E_NOT_EXEC;
  802b2e:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  802b33:	e9 c0 03 00 00       	jmp    802ef8 <spawn+0x452>
  802b38:	b8 07 00 00 00       	mov    $0x7,%eax
  802b3d:	cd 30                	int    $0x30
  802b3f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  802b45:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	0f 88 29 03 00 00    	js     802e7c <spawn+0x3d6>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802b53:	89 c6                	mov    %eax,%esi
  802b55:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  802b5b:	c1 e6 07             	shl    $0x7,%esi
  802b5e:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802b64:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802b6a:	b9 11 00 00 00       	mov    $0x11,%ecx
  802b6f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802b71:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802b77:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802b7d:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  802b82:	be 00 00 00 00       	mov    $0x0,%esi
  802b87:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802b8a:	eb 0f                	jmp    802b9b <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  802b8c:	89 04 24             	mov    %eax,(%esp)
  802b8f:	e8 ac e6 ff ff       	call   801240 <strlen>
  802b94:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802b98:	83 c3 01             	add    $0x1,%ebx
  802b9b:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  802ba2:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802ba5:	85 c0                	test   %eax,%eax
  802ba7:	75 e3                	jne    802b8c <spawn+0xe6>
  802ba9:	89 9d 80 fd ff ff    	mov    %ebx,-0x280(%ebp)
  802baf:	89 8d 7c fd ff ff    	mov    %ecx,-0x284(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802bb5:	bf 00 10 40 00       	mov    $0x401000,%edi
  802bba:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802bbc:	89 fa                	mov    %edi,%edx
  802bbe:	83 e2 fc             	and    $0xfffffffc,%edx
  802bc1:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802bc8:	29 c2                	sub    %eax,%edx
  802bca:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802bd0:	8d 42 f8             	lea    -0x8(%edx),%eax
  802bd3:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802bd8:	0f 86 ae 02 00 00    	jbe    802e8c <spawn+0x3e6>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802bde:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802be5:	00 
  802be6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802bed:	00 
  802bee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bf5:	e8 99 ea ff ff       	call   801693 <sys_page_alloc>
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	0f 88 f6 02 00 00    	js     802ef8 <spawn+0x452>
  802c02:	be 00 00 00 00       	mov    $0x0,%esi
  802c07:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  802c0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802c10:	eb 30                	jmp    802c42 <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  802c12:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802c18:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802c1e:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802c21:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  802c24:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c28:	89 3c 24             	mov    %edi,(%esp)
  802c2b:	e8 47 e6 ff ff       	call   801277 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802c30:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  802c33:	89 04 24             	mov    %eax,(%esp)
  802c36:	e8 05 e6 ff ff       	call   801240 <strlen>
  802c3b:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802c3f:	83 c6 01             	add    $0x1,%esi
  802c42:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
  802c48:	7c c8                	jl     802c12 <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802c4a:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802c50:	8b 8d 7c fd ff ff    	mov    -0x284(%ebp),%ecx
  802c56:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802c5d:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802c63:	74 24                	je     802c89 <spawn+0x1e3>
  802c65:	c7 44 24 0c c4 48 80 	movl   $0x8048c4,0xc(%esp)
  802c6c:	00 
  802c6d:	c7 44 24 08 55 42 80 	movl   $0x804255,0x8(%esp)
  802c74:	00 
  802c75:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
  802c7c:	00 
  802c7d:	c7 04 24 3f 48 80 00 	movl   $0x80483f,(%esp)
  802c84:	e8 de dd ff ff       	call   800a67 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802c89:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802c8f:	89 c8                	mov    %ecx,%eax
  802c91:	2d 00 30 80 11       	sub    $0x11803000,%eax
  802c96:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  802c99:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802c9f:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802ca2:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  802ca8:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802cae:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  802cb5:	00 
  802cb6:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  802cbd:	ee 
  802cbe:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802cc4:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cc8:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802ccf:	00 
  802cd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802cd7:	e8 0b ea ff ff       	call   8016e7 <sys_page_map>
  802cdc:	89 c7                	mov    %eax,%edi
  802cde:	85 c0                	test   %eax,%eax
  802ce0:	0f 88 fc 01 00 00    	js     802ee2 <spawn+0x43c>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802ce6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802ced:	00 
  802cee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802cf5:	e8 40 ea ff ff       	call   80173a <sys_page_unmap>
  802cfa:	89 c7                	mov    %eax,%edi
  802cfc:	85 c0                	test   %eax,%eax
  802cfe:	0f 88 de 01 00 00    	js     802ee2 <spawn+0x43c>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802d04:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802d0a:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802d11:	be 00 00 00 00       	mov    $0x0,%esi
  802d16:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
  802d1c:	eb 4a                	jmp    802d68 <spawn+0x2c2>
		if (ph->p_type != ELF_PROG_LOAD)
  802d1e:	83 3b 01             	cmpl   $0x1,(%ebx)
  802d21:	75 3f                	jne    802d62 <spawn+0x2bc>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802d23:	8b 43 18             	mov    0x18(%ebx),%eax
  802d26:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  802d29:	83 f8 01             	cmp    $0x1,%eax
  802d2c:	19 c0                	sbb    %eax,%eax
  802d2e:	83 e0 fe             	and    $0xfffffffe,%eax
  802d31:	83 c0 07             	add    $0x7,%eax
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802d34:	8b 4b 14             	mov    0x14(%ebx),%ecx
  802d37:	8b 53 08             	mov    0x8(%ebx),%edx
  802d3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d3e:	8b 43 04             	mov    0x4(%ebx),%eax
  802d41:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d45:	8b 43 10             	mov    0x10(%ebx),%eax
  802d48:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d4c:	89 3c 24             	mov    %edi,(%esp)
  802d4f:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802d55:	e8 06 fc ff ff       	call   802960 <map_segment>
  802d5a:	85 c0                	test   %eax,%eax
  802d5c:	0f 88 ed 00 00 00    	js     802e4f <spawn+0x3a9>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802d62:	83 c6 01             	add    $0x1,%esi
  802d65:	83 c3 20             	add    $0x20,%ebx
  802d68:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802d6f:	39 c6                	cmp    %eax,%esi
  802d71:	7c ab                	jl     802d1e <spawn+0x278>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802d73:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802d79:	89 04 24             	mov    %eax,(%esp)
  802d7c:	e8 66 f3 ff ff       	call   8020e7 <close>
	uint8_t *addr, *end_addr;
    int perm;
    int r;

	end_addr = (uint8_t *) (UXSTACKTOP - PGSIZE);
	for (addr = 0; addr < end_addr; addr += PGSIZE) {	
  802d81:	bb 00 00 00 00       	mov    $0x0,%ebx
  802d86:	8b b5 8c fd ff ff    	mov    -0x274(%ebp),%esi
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)) {
  802d8c:	89 d8                	mov    %ebx,%eax
  802d8e:	c1 e8 16             	shr    $0x16,%eax
  802d91:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802d98:	a8 01                	test   $0x1,%al
  802d9a:	74 46                	je     802de2 <spawn+0x33c>
  802d9c:	89 d8                	mov    %ebx,%eax
  802d9e:	c1 e8 0c             	shr    $0xc,%eax
  802da1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802da8:	f6 c2 01             	test   $0x1,%dl
  802dab:	74 35                	je     802de2 <spawn+0x33c>
			perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  802dad:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
            if (perm & PTE_SHARE) {
  802db4:	f6 c4 04             	test   $0x4,%ah
  802db7:	74 29                	je     802de2 <spawn+0x33c>
    int r;

	end_addr = (uint8_t *) (UXSTACKTOP - PGSIZE);
	for (addr = 0; addr < end_addr; addr += PGSIZE) {	
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)) {
			perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  802db9:	25 07 0e 00 00       	and    $0xe07,%eax
            if (perm & PTE_SHARE) {
                if ((r = sys_page_map(0, addr, child, addr, perm)) < 0) 
  802dbe:	89 44 24 10          	mov    %eax,0x10(%esp)
  802dc2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802dc6:	89 74 24 08          	mov    %esi,0x8(%esp)
  802dca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802dce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802dd5:	e8 0d e9 ff ff       	call   8016e7 <sys_page_map>
  802dda:	85 c0                	test   %eax,%eax
  802ddc:	0f 88 b1 00 00 00    	js     802e93 <spawn+0x3ed>
	uint8_t *addr, *end_addr;
    int perm;
    int r;

	end_addr = (uint8_t *) (UXSTACKTOP - PGSIZE);
	for (addr = 0; addr < end_addr; addr += PGSIZE) {	
  802de2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802de8:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  802dee:	75 9c                	jne    802d8c <spawn+0x2e6>
  802df0:	e9 be 00 00 00       	jmp    802eb3 <spawn+0x40d>
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);
  802df5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802df9:	c7 44 24 08 65 48 80 	movl   $0x804865,0x8(%esp)
  802e00:	00 
  802e01:	c7 44 24 04 8b 00 00 	movl   $0x8b,0x4(%esp)
  802e08:	00 
  802e09:	c7 04 24 3f 48 80 00 	movl   $0x80483f,(%esp)
  802e10:	e8 52 dc ff ff       	call   800a67 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802e15:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  802e1c:	00 
  802e1d:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802e23:	89 04 24             	mov    %eax,(%esp)
  802e26:	e8 62 e9 ff ff       	call   80178d <sys_env_set_status>
  802e2b:	85 c0                	test   %eax,%eax
  802e2d:	79 55                	jns    802e84 <spawn+0x3de>
		panic("sys_env_set_status: %e", r);
  802e2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e33:	c7 44 24 08 7f 48 80 	movl   $0x80487f,0x8(%esp)
  802e3a:	00 
  802e3b:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
  802e42:	00 
  802e43:	c7 04 24 3f 48 80 00 	movl   $0x80483f,(%esp)
  802e4a:	e8 18 dc ff ff       	call   800a67 <_panic>
  802e4f:	89 c7                	mov    %eax,%edi

	return child;

error:
	sys_env_destroy(child);
  802e51:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802e57:	89 04 24             	mov    %eax,(%esp)
  802e5a:	e8 a4 e7 ff ff       	call   801603 <sys_env_destroy>
	close(fd);
  802e5f:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802e65:	89 04 24             	mov    %eax,(%esp)
  802e68:	e8 7a f2 ff ff       	call   8020e7 <close>
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802e6d:	89 f8                	mov    %edi,%eax
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  802e6f:	e9 84 00 00 00       	jmp    802ef8 <spawn+0x452>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  802e74:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802e7a:	eb 7c                	jmp    802ef8 <spawn+0x452>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  802e7c:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802e82:	eb 74                	jmp    802ef8 <spawn+0x452>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  802e84:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802e8a:	eb 6c                	jmp    802ef8 <spawn+0x452>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  802e8c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  802e91:	eb 65                	jmp    802ef8 <spawn+0x452>
	close(fd);
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
  802e93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e97:	c7 44 24 08 96 48 80 	movl   $0x804896,0x8(%esp)
  802e9e:	00 
  802e9f:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  802ea6:	00 
  802ea7:	c7 04 24 3f 48 80 00 	movl   $0x80483f,(%esp)
  802eae:	e8 b4 db ff ff       	call   800a67 <_panic>

	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  802eb3:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  802eba:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802ebd:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802ec3:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ec7:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802ecd:	89 04 24             	mov    %eax,(%esp)
  802ed0:	e8 0b e9 ff ff       	call   8017e0 <sys_env_set_trapframe>
  802ed5:	85 c0                	test   %eax,%eax
  802ed7:	0f 89 38 ff ff ff    	jns    802e15 <spawn+0x36f>
  802edd:	e9 13 ff ff ff       	jmp    802df5 <spawn+0x34f>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802ee2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802ee9:	00 
  802eea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ef1:	e8 44 e8 ff ff       	call   80173a <sys_page_unmap>
  802ef6:	89 f8                	mov    %edi,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802ef8:	81 c4 8c 02 00 00    	add    $0x28c,%esp
  802efe:	5b                   	pop    %ebx
  802eff:	5e                   	pop    %esi
  802f00:	5f                   	pop    %edi
  802f01:	5d                   	pop    %ebp
  802f02:	c3                   	ret    

00802f03 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802f03:	55                   	push   %ebp
  802f04:	89 e5                	mov    %esp,%ebp
  802f06:	56                   	push   %esi
  802f07:	53                   	push   %ebx
  802f08:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802f0b:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802f0e:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802f13:	eb 03                	jmp    802f18 <spawnl+0x15>
		argc++;
  802f15:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802f18:	83 c0 04             	add    $0x4,%eax
  802f1b:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  802f1f:	75 f4                	jne    802f15 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802f21:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  802f28:	83 e0 f0             	and    $0xfffffff0,%eax
  802f2b:	29 c4                	sub    %eax,%esp
  802f2d:	8d 44 24 0b          	lea    0xb(%esp),%eax
  802f31:	c1 e8 02             	shr    $0x2,%eax
  802f34:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  802f3b:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802f3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802f40:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  802f47:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  802f4e:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f54:	eb 0a                	jmp    802f60 <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  802f56:	83 c0 01             	add    $0x1,%eax
  802f59:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  802f5d:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802f60:	39 d0                	cmp    %edx,%eax
  802f62:	75 f2                	jne    802f56 <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802f64:	89 74 24 04          	mov    %esi,0x4(%esp)
  802f68:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6b:	89 04 24             	mov    %eax,(%esp)
  802f6e:	e8 33 fb ff ff       	call   802aa6 <spawn>
}
  802f73:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f76:	5b                   	pop    %ebx
  802f77:	5e                   	pop    %esi
  802f78:	5d                   	pop    %ebp
  802f79:	c3                   	ret    

00802f7a <exec>:

int
exec(const char *prog, const char **argv)
{
  802f7a:	55                   	push   %ebp
  802f7b:	89 e5                	mov    %esp,%ebp
  802f7d:	57                   	push   %edi
  802f7e:	56                   	push   %esi
  802f7f:	53                   	push   %ebx
  802f80:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
	int fd, i, r;
	struct Elf *elf;
	struct Proghdr *ph;
	int perm;	

	if ((r = open(prog, O_RDONLY)) < 0)
  802f86:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802f8d:	00 
  802f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f91:	89 04 24             	mov    %eax,(%esp)
  802f94:	e8 e6 f7 ff ff       	call   80277f <open>
  802f99:	89 c7                	mov    %eax,%edi
  802f9b:	85 c0                	test   %eax,%eax
  802f9d:	0f 88 14 03 00 00    	js     8032b7 <exec+0x33d>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802fa3:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  802faa:	00 
  802fab:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802fb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fb5:	89 3c 24             	mov    %edi,(%esp)
  802fb8:	e8 1f f3 ff ff       	call   8022dc <readn>
  802fbd:	3d 00 02 00 00       	cmp    $0x200,%eax
  802fc2:	75 0c                	jne    802fd0 <exec+0x56>
	    || elf->e_magic != ELF_MAGIC) {
  802fc4:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802fcb:	45 4c 46 
  802fce:	74 30                	je     803000 <exec+0x86>
		close(fd);
  802fd0:	89 3c 24             	mov    %edi,(%esp)
  802fd3:	e8 0f f1 ff ff       	call   8020e7 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802fd8:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  802fdf:	46 
  802fe0:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  802fe6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fea:	c7 04 24 4b 48 80 00 	movl   $0x80484b,(%esp)
  802ff1:	e8 6a db ff ff       	call   800b60 <cprintf>
		return -E_NOT_EXEC;
  802ff6:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  802ffb:	e9 d8 02 00 00       	jmp    8032d8 <exec+0x35e>
	}

	// Set up program segments as defined in ELF header.
	uint32_t tmp = ETEMPREGION;
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  803000:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  803006:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Set up program segments as defined in ELF header.
	uint32_t tmp = ETEMPREGION;
  80300d:	b8 00 00 00 e0       	mov    $0xe0000000,%eax
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  803012:	be 00 00 00 00       	mov    $0x0,%esi
  803017:	89 bd e4 fd ff ff    	mov    %edi,-0x21c(%ebp)
  80301d:	89 c7                	mov    %eax,%edi
  80301f:	eb 71                	jmp    803092 <exec+0x118>
		if (ph->p_type != ELF_PROG_LOAD)
  803021:	83 3b 01             	cmpl   $0x1,(%ebx)
  803024:	75 66                	jne    80308c <exec+0x112>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  803026:	8b 43 18             	mov    0x18(%ebx),%eax
  803029:	83 e0 02             	and    $0x2,%eax
	uint32_t tmp = ETEMPREGION;
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  80302c:	83 f8 01             	cmp    $0x1,%eax
  80302f:	19 c0                	sbb    %eax,%eax
  803031:	83 e0 fe             	and    $0xfffffffe,%eax
  803034:	83 c0 07             	add    $0x7,%eax
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(0, PGOFF(ph->p_va) + tmp, ph->p_memsz,
  803037:	8b 4b 14             	mov    0x14(%ebx),%ecx
  80303a:	8b 53 08             	mov    0x8(%ebx),%edx
  80303d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  803043:	01 fa                	add    %edi,%edx
  803045:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803049:	8b 43 04             	mov    0x4(%ebx),%eax
  80304c:	89 44 24 08          	mov    %eax,0x8(%esp)
  803050:	8b 43 10             	mov    0x10(%ebx),%eax
  803053:	89 44 24 04          	mov    %eax,0x4(%esp)
  803057:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
  80305d:	89 04 24             	mov    %eax,(%esp)
  803060:	b8 00 00 00 00       	mov    $0x0,%eax
  803065:	e8 f6 f8 ff ff       	call   802960 <map_segment>
  80306a:	85 c0                	test   %eax,%eax
  80306c:	0f 88 25 02 00 00    	js     803297 <exec+0x31d>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
		tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
  803072:	8b 53 14             	mov    0x14(%ebx),%edx
  803075:	8b 43 08             	mov    0x8(%ebx),%eax
  803078:	25 ff 0f 00 00       	and    $0xfff,%eax
  80307d:	8d 84 02 ff 0f 00 00 	lea    0xfff(%edx,%eax,1),%eax
  803084:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803089:	8d 3c 38             	lea    (%eax,%edi,1),%edi
	}

	// Set up program segments as defined in ELF header.
	uint32_t tmp = ETEMPREGION;
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80308c:	83 c6 01             	add    $0x1,%esi
  80308f:	83 c3 20             	add    $0x20,%ebx
  803092:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  803099:	39 c6                	cmp    %eax,%esi
  80309b:	7c 84                	jl     803021 <exec+0xa7>
  80309d:	89 bd dc fd ff ff    	mov    %edi,-0x224(%ebp)
  8030a3:	8b bd e4 fd ff ff    	mov    -0x21c(%ebp),%edi
		if ((r = map_segment(0, PGOFF(ph->p_va) + tmp, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
		tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
	}
	close(fd);
  8030a9:	89 3c 24             	mov    %edi,(%esp)
  8030ac:	e8 36 f0 ff ff       	call   8020e7 <close>
	fd = -1;
	cprintf("tf_esp: %x\n", tf_esp);
  8030b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8030b8:	00 
  8030b9:	c7 04 24 ac 48 80 00 	movl   $0x8048ac,(%esp)
  8030c0:	e8 9b da ff ff       	call   800b60 <cprintf>
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8030c5:	bb 00 00 00 00       	mov    $0x0,%ebx
	size_t string_size;
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	string_size = 0;
  8030ca:	be 00 00 00 00       	mov    $0x0,%esi
  8030cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8030d2:	eb 0f                	jmp    8030e3 <exec+0x169>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  8030d4:	89 04 24             	mov    %eax,(%esp)
  8030d7:	e8 64 e1 ff ff       	call   801240 <strlen>
  8030dc:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8030e0:	83 c3 01             	add    $0x1,%ebx
  8030e3:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8030ea:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8030ed:	85 c0                	test   %eax,%eax
  8030ef:	75 e3                	jne    8030d4 <exec+0x15a>
  8030f1:	89 9d d8 fd ff ff    	mov    %ebx,-0x228(%ebp)
  8030f7:	89 8d d4 fd ff ff    	mov    %ecx,-0x22c(%ebp)
		string_size += strlen(argv[argc]) + 1;

	string_store = (char*) UTEMP + PGSIZE - string_size;
  8030fd:	bf 00 10 40 00       	mov    $0x401000,%edi
  803102:	29 f7                	sub    %esi,%edi
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  803104:	89 fa                	mov    %edi,%edx
  803106:	83 e2 fc             	and    $0xfffffffc,%edx
  803109:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  803110:	29 c2                	sub    %eax,%edx
  803112:	89 95 e4 fd ff ff    	mov    %edx,-0x21c(%ebp)
	
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  803118:	8d 42 f8             	lea    -0x8(%edx),%eax
  80311b:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  803120:	0f 86 93 01 00 00    	jbe    8032b9 <exec+0x33f>
		return -E_NO_MEM;

	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  803126:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80312d:	00 
  80312e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  803135:	00 
  803136:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80313d:	e8 51 e5 ff ff       	call   801693 <sys_page_alloc>
  803142:	85 c0                	test   %eax,%eax
  803144:	0f 88 8e 01 00 00    	js     8032d8 <exec+0x35e>
  80314a:	be 00 00 00 00       	mov    $0x0,%esi
  80314f:	89 9d e0 fd ff ff    	mov    %ebx,-0x220(%ebp)
  803155:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  803158:	eb 30                	jmp    80318a <exec+0x210>
		return r;

	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  80315a:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  803160:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
  803166:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  803169:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  80316c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803170:	89 3c 24             	mov    %edi,(%esp)
  803173:	e8 ff e0 ff ff       	call   801277 <strcpy>
		string_store += strlen(argv[i]) + 1;
  803178:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  80317b:	89 04 24             	mov    %eax,(%esp)
  80317e:	e8 bd e0 ff ff       	call   801240 <strlen>
  803183:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
		return -E_NO_MEM;

	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		return r;

	for (i = 0; i < argc; i++) {
  803187:	83 c6 01             	add    $0x1,%esi
  80318a:	39 b5 e0 fd ff ff    	cmp    %esi,-0x220(%ebp)
  803190:	7f c8                	jg     80315a <exec+0x1e0>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  803192:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
  803198:	8b 8d d4 fd ff ff    	mov    -0x22c(%ebp),%ecx
  80319e:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8031a5:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8031ab:	74 24                	je     8031d1 <exec+0x257>
  8031ad:	c7 44 24 0c c4 48 80 	movl   $0x8048c4,0xc(%esp)
  8031b4:	00 
  8031b5:	c7 44 24 08 55 42 80 	movl   $0x804255,0x8(%esp)
  8031bc:	00 
  8031bd:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
  8031c4:	00 
  8031c5:	c7 04 24 3f 48 80 00 	movl   $0x80483f,(%esp)
  8031cc:	e8 96 d8 ff ff       	call   800a67 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8031d1:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
  8031d7:	89 c8                	mov    %ecx,%eax
  8031d9:	2d 00 30 80 11       	sub    $0x11803000,%eax
  8031de:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8031e1:	8b 85 d8 fd ff ff    	mov    -0x228(%ebp),%eax
  8031e7:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8031ea:	8d 99 f8 cf 7f ee    	lea    -0x11803008(%ecx),%ebx

	cprintf("stack: %x\n", stack);
  8031f0:	8b bd dc fd ff ff    	mov    -0x224(%ebp),%edi
  8031f6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8031fa:	c7 04 24 b8 48 80 00 	movl   $0x8048b8,(%esp)
  803201:	e8 5a d9 ff ff       	call   800b60 <cprintf>
	if ((r = sys_page_map(0, UTEMP, child, (void*) stack, PTE_P | PTE_U | PTE_W)) < 0)
  803206:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80320d:	00 
  80320e:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803212:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803219:	00 
  80321a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  803221:	00 
  803222:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803229:	e8 b9 e4 ff ff       	call   8016e7 <sys_page_map>
  80322e:	89 c7                	mov    %eax,%edi
  803230:	85 c0                	test   %eax,%eax
  803232:	0f 88 8a 00 00 00    	js     8032c2 <exec+0x348>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  803238:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80323f:	00 
  803240:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803247:	e8 ee e4 ff ff       	call   80173a <sys_page_unmap>
  80324c:	89 c7                	mov    %eax,%edi
  80324e:	85 c0                	test   %eax,%eax
  803250:	78 70                	js     8032c2 <exec+0x348>
	// cprintf("tf_eip: %x\n", tf_eip);
	if ((r = init_stack_with_addr(0, argv, &tf_esp, tmp)) < 0)
		return r;

	// Syscall to exec
	if (sys_exec(elf->e_entry, tf_esp, (void *)(elf_buf + elf->e_phoff), elf->e_phnum) < 0)
  803252:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  803259:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80325d:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  803263:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  80326a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80326e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803272:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  803278:	89 04 24             	mov    %eax,(%esp)
  80327b:	e8 fc e6 ff ff       	call   80197c <sys_exec>
  803280:	89 c2                	mov    %eax,%edx
		goto error;
	return 0;
  803282:	b8 00 00 00 00       	mov    $0x0,%eax
  803287:	be 00 00 00 00       	mov    $0x0,%esi
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
		tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
	}
	close(fd);
	fd = -1;
  80328c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
	// cprintf("tf_eip: %x\n", tf_eip);
	if ((r = init_stack_with_addr(0, argv, &tf_esp, tmp)) < 0)
		return r;

	// Syscall to exec
	if (sys_exec(elf->e_entry, tf_esp, (void *)(elf_buf + elf->e_phoff), elf->e_phnum) < 0)
  803291:	85 d2                	test   %edx,%edx
  803293:	78 0a                	js     80329f <exec+0x325>
  803295:	eb 41                	jmp    8032d8 <exec+0x35e>
  803297:	8b bd e4 fd ff ff    	mov    -0x21c(%ebp),%edi
  80329d:	89 c6                	mov    %eax,%esi
		goto error;
	return 0;

error:
	sys_env_destroy(0);
  80329f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032a6:	e8 58 e3 ff ff       	call   801603 <sys_env_destroy>
	close(fd);
  8032ab:	89 3c 24             	mov    %edi,(%esp)
  8032ae:	e8 34 ee ff ff       	call   8020e7 <close>
	return r;
  8032b3:	89 f0                	mov    %esi,%eax
  8032b5:	eb 21                	jmp    8032d8 <exec+0x35e>
  8032b7:	eb 1f                	jmp    8032d8 <exec+0x35e>

	string_store = (char*) UTEMP + PGSIZE - string_size;
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
	
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  8032b9:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8032be:	66 90                	xchg   %ax,%ax
  8032c0:	eb 16                	jmp    8032d8 <exec+0x35e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8032c2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8032c9:	00 
  8032ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032d1:	e8 64 e4 ff ff       	call   80173a <sys_page_unmap>
  8032d6:	89 f8                	mov    %edi,%eax

error:
	sys_env_destroy(0);
	close(fd);
	return r;
}
  8032d8:	81 c4 3c 02 00 00    	add    $0x23c,%esp
  8032de:	5b                   	pop    %ebx
  8032df:	5e                   	pop    %esi
  8032e0:	5f                   	pop    %edi
  8032e1:	5d                   	pop    %ebp
  8032e2:	c3                   	ret    

008032e3 <execl>:

int
execl(const char *prog, const char *arg0, ...)
{
  8032e3:	55                   	push   %ebp
  8032e4:	89 e5                	mov    %esp,%ebp
  8032e6:	56                   	push   %esi
  8032e7:	53                   	push   %ebx
  8032e8:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8032eb:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8032ee:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8032f3:	eb 03                	jmp    8032f8 <execl+0x15>
		argc++;
  8032f5:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8032f8:	83 c0 04             	add    $0x4,%eax
  8032fb:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  8032ff:	75 f4                	jne    8032f5 <execl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  803301:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  803308:	83 e0 f0             	and    $0xfffffff0,%eax
  80330b:	29 c4                	sub    %eax,%esp
  80330d:	8d 44 24 0b          	lea    0xb(%esp),%eax
  803311:	c1 e8 02             	shr    $0x2,%eax
  803314:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  80331b:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80331d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803320:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  803327:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  80332e:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80332f:	b8 00 00 00 00       	mov    $0x0,%eax
  803334:	eb 0a                	jmp    803340 <execl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  803336:	83 c0 01             	add    $0x1,%eax
  803339:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  80333d:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  803340:	39 d0                	cmp    %edx,%eax
  803342:	75 f2                	jne    803336 <execl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return exec(prog, argv);
  803344:	89 74 24 04          	mov    %esi,0x4(%esp)
  803348:	8b 45 08             	mov    0x8(%ebp),%eax
  80334b:	89 04 24             	mov    %eax,(%esp)
  80334e:	e8 27 fc ff ff       	call   802f7a <exec>
}
  803353:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803356:	5b                   	pop    %ebx
  803357:	5e                   	pop    %esi
  803358:	5d                   	pop    %ebp
  803359:	c3                   	ret    
  80335a:	66 90                	xchg   %ax,%ax
  80335c:	66 90                	xchg   %ax,%ax
  80335e:	66 90                	xchg   %ax,%ax

00803360 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803360:	55                   	push   %ebp
  803361:	89 e5                	mov    %esp,%ebp
  803363:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803366:	c7 44 24 04 ea 48 80 	movl   $0x8048ea,0x4(%esp)
  80336d:	00 
  80336e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803371:	89 04 24             	mov    %eax,(%esp)
  803374:	e8 fe de ff ff       	call   801277 <strcpy>
	return 0;
}
  803379:	b8 00 00 00 00       	mov    $0x0,%eax
  80337e:	c9                   	leave  
  80337f:	c3                   	ret    

00803380 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803380:	55                   	push   %ebp
  803381:	89 e5                	mov    %esp,%ebp
  803383:	53                   	push   %ebx
  803384:	83 ec 14             	sub    $0x14,%esp
  803387:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80338a:	89 1c 24             	mov    %ebx,(%esp)
  80338d:	e8 8d 0a 00 00       	call   803e1f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803392:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803397:	83 f8 01             	cmp    $0x1,%eax
  80339a:	75 0d                	jne    8033a9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80339c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80339f:	89 04 24             	mov    %eax,(%esp)
  8033a2:	e8 29 03 00 00       	call   8036d0 <nsipc_close>
  8033a7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8033a9:	89 d0                	mov    %edx,%eax
  8033ab:	83 c4 14             	add    $0x14,%esp
  8033ae:	5b                   	pop    %ebx
  8033af:	5d                   	pop    %ebp
  8033b0:	c3                   	ret    

008033b1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8033b1:	55                   	push   %ebp
  8033b2:	89 e5                	mov    %esp,%ebp
  8033b4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8033b7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8033be:	00 
  8033bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8033c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8033c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d3:	89 04 24             	mov    %eax,(%esp)
  8033d6:	e8 f0 03 00 00       	call   8037cb <nsipc_send>
}
  8033db:	c9                   	leave  
  8033dc:	c3                   	ret    

008033dd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8033dd:	55                   	push   %ebp
  8033de:	89 e5                	mov    %esp,%ebp
  8033e0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8033e3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8033ea:	00 
  8033eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8033ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8033f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8033ff:	89 04 24             	mov    %eax,(%esp)
  803402:	e8 44 03 00 00       	call   80374b <nsipc_recv>
}
  803407:	c9                   	leave  
  803408:	c3                   	ret    

00803409 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803409:	55                   	push   %ebp
  80340a:	89 e5                	mov    %esp,%ebp
  80340c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80340f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803412:	89 54 24 04          	mov    %edx,0x4(%esp)
  803416:	89 04 24             	mov    %eax,(%esp)
  803419:	e8 98 eb ff ff       	call   801fb6 <fd_lookup>
  80341e:	85 c0                	test   %eax,%eax
  803420:	78 17                	js     803439 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803425:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  80342b:	39 08                	cmp    %ecx,(%eax)
  80342d:	75 05                	jne    803434 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80342f:	8b 40 0c             	mov    0xc(%eax),%eax
  803432:	eb 05                	jmp    803439 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  803434:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  803439:	c9                   	leave  
  80343a:	c3                   	ret    

0080343b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80343b:	55                   	push   %ebp
  80343c:	89 e5                	mov    %esp,%ebp
  80343e:	56                   	push   %esi
  80343f:	53                   	push   %ebx
  803440:	83 ec 20             	sub    $0x20,%esp
  803443:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803445:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803448:	89 04 24             	mov    %eax,(%esp)
  80344b:	e8 17 eb ff ff       	call   801f67 <fd_alloc>
  803450:	89 c3                	mov    %eax,%ebx
  803452:	85 c0                	test   %eax,%eax
  803454:	78 21                	js     803477 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803456:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80345d:	00 
  80345e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803461:	89 44 24 04          	mov    %eax,0x4(%esp)
  803465:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80346c:	e8 22 e2 ff ff       	call   801693 <sys_page_alloc>
  803471:	89 c3                	mov    %eax,%ebx
  803473:	85 c0                	test   %eax,%eax
  803475:	79 0c                	jns    803483 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  803477:	89 34 24             	mov    %esi,(%esp)
  80347a:	e8 51 02 00 00       	call   8036d0 <nsipc_close>
		return r;
  80347f:	89 d8                	mov    %ebx,%eax
  803481:	eb 20                	jmp    8034a3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803483:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  803489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80348e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803491:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  803498:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80349b:	89 14 24             	mov    %edx,(%esp)
  80349e:	e8 9d ea ff ff       	call   801f40 <fd2num>
}
  8034a3:	83 c4 20             	add    $0x20,%esp
  8034a6:	5b                   	pop    %ebx
  8034a7:	5e                   	pop    %esi
  8034a8:	5d                   	pop    %ebp
  8034a9:	c3                   	ret    

008034aa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8034aa:	55                   	push   %ebp
  8034ab:	89 e5                	mov    %esp,%ebp
  8034ad:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b3:	e8 51 ff ff ff       	call   803409 <fd2sockid>
		return r;
  8034b8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034ba:	85 c0                	test   %eax,%eax
  8034bc:	78 23                	js     8034e1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8034be:	8b 55 10             	mov    0x10(%ebp),%edx
  8034c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8034c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034c8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8034cc:	89 04 24             	mov    %eax,(%esp)
  8034cf:	e8 45 01 00 00       	call   803619 <nsipc_accept>
		return r;
  8034d4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8034d6:	85 c0                	test   %eax,%eax
  8034d8:	78 07                	js     8034e1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8034da:	e8 5c ff ff ff       	call   80343b <alloc_sockfd>
  8034df:	89 c1                	mov    %eax,%ecx
}
  8034e1:	89 c8                	mov    %ecx,%eax
  8034e3:	c9                   	leave  
  8034e4:	c3                   	ret    

008034e5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8034e5:	55                   	push   %ebp
  8034e6:	89 e5                	mov    %esp,%ebp
  8034e8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8034eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ee:	e8 16 ff ff ff       	call   803409 <fd2sockid>
  8034f3:	89 c2                	mov    %eax,%edx
  8034f5:	85 d2                	test   %edx,%edx
  8034f7:	78 16                	js     80350f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8034f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8034fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  803500:	8b 45 0c             	mov    0xc(%ebp),%eax
  803503:	89 44 24 04          	mov    %eax,0x4(%esp)
  803507:	89 14 24             	mov    %edx,(%esp)
  80350a:	e8 60 01 00 00       	call   80366f <nsipc_bind>
}
  80350f:	c9                   	leave  
  803510:	c3                   	ret    

00803511 <shutdown>:

int
shutdown(int s, int how)
{
  803511:	55                   	push   %ebp
  803512:	89 e5                	mov    %esp,%ebp
  803514:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803517:	8b 45 08             	mov    0x8(%ebp),%eax
  80351a:	e8 ea fe ff ff       	call   803409 <fd2sockid>
  80351f:	89 c2                	mov    %eax,%edx
  803521:	85 d2                	test   %edx,%edx
  803523:	78 0f                	js     803534 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  803525:	8b 45 0c             	mov    0xc(%ebp),%eax
  803528:	89 44 24 04          	mov    %eax,0x4(%esp)
  80352c:	89 14 24             	mov    %edx,(%esp)
  80352f:	e8 7a 01 00 00       	call   8036ae <nsipc_shutdown>
}
  803534:	c9                   	leave  
  803535:	c3                   	ret    

00803536 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803536:	55                   	push   %ebp
  803537:	89 e5                	mov    %esp,%ebp
  803539:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80353c:	8b 45 08             	mov    0x8(%ebp),%eax
  80353f:	e8 c5 fe ff ff       	call   803409 <fd2sockid>
  803544:	89 c2                	mov    %eax,%edx
  803546:	85 d2                	test   %edx,%edx
  803548:	78 16                	js     803560 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80354a:	8b 45 10             	mov    0x10(%ebp),%eax
  80354d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803551:	8b 45 0c             	mov    0xc(%ebp),%eax
  803554:	89 44 24 04          	mov    %eax,0x4(%esp)
  803558:	89 14 24             	mov    %edx,(%esp)
  80355b:	e8 8a 01 00 00       	call   8036ea <nsipc_connect>
}
  803560:	c9                   	leave  
  803561:	c3                   	ret    

00803562 <listen>:

int
listen(int s, int backlog)
{
  803562:	55                   	push   %ebp
  803563:	89 e5                	mov    %esp,%ebp
  803565:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803568:	8b 45 08             	mov    0x8(%ebp),%eax
  80356b:	e8 99 fe ff ff       	call   803409 <fd2sockid>
  803570:	89 c2                	mov    %eax,%edx
  803572:	85 d2                	test   %edx,%edx
  803574:	78 0f                	js     803585 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  803576:	8b 45 0c             	mov    0xc(%ebp),%eax
  803579:	89 44 24 04          	mov    %eax,0x4(%esp)
  80357d:	89 14 24             	mov    %edx,(%esp)
  803580:	e8 a4 01 00 00       	call   803729 <nsipc_listen>
}
  803585:	c9                   	leave  
  803586:	c3                   	ret    

00803587 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803587:	55                   	push   %ebp
  803588:	89 e5                	mov    %esp,%ebp
  80358a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80358d:	8b 45 10             	mov    0x10(%ebp),%eax
  803590:	89 44 24 08          	mov    %eax,0x8(%esp)
  803594:	8b 45 0c             	mov    0xc(%ebp),%eax
  803597:	89 44 24 04          	mov    %eax,0x4(%esp)
  80359b:	8b 45 08             	mov    0x8(%ebp),%eax
  80359e:	89 04 24             	mov    %eax,(%esp)
  8035a1:	e8 98 02 00 00       	call   80383e <nsipc_socket>
  8035a6:	89 c2                	mov    %eax,%edx
  8035a8:	85 d2                	test   %edx,%edx
  8035aa:	78 05                	js     8035b1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8035ac:	e8 8a fe ff ff       	call   80343b <alloc_sockfd>
}
  8035b1:	c9                   	leave  
  8035b2:	c3                   	ret    

008035b3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8035b3:	55                   	push   %ebp
  8035b4:	89 e5                	mov    %esp,%ebp
  8035b6:	53                   	push   %ebx
  8035b7:	83 ec 14             	sub    $0x14,%esp
  8035ba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8035bc:	83 3d 24 64 80 00 00 	cmpl   $0x0,0x806424
  8035c3:	75 11                	jne    8035d6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8035c5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8035cc:	e8 14 08 00 00       	call   803de5 <ipc_find_env>
  8035d1:	a3 24 64 80 00       	mov    %eax,0x806424
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8035d6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8035dd:	00 
  8035de:	c7 44 24 08 00 90 80 	movl   $0x809000,0x8(%esp)
  8035e5:	00 
  8035e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8035ea:	a1 24 64 80 00       	mov    0x806424,%eax
  8035ef:	89 04 24             	mov    %eax,(%esp)
  8035f2:	e8 61 07 00 00       	call   803d58 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8035f7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8035fe:	00 
  8035ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803606:	00 
  803607:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80360e:	e8 dd 06 00 00       	call   803cf0 <ipc_recv>
}
  803613:	83 c4 14             	add    $0x14,%esp
  803616:	5b                   	pop    %ebx
  803617:	5d                   	pop    %ebp
  803618:	c3                   	ret    

00803619 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803619:	55                   	push   %ebp
  80361a:	89 e5                	mov    %esp,%ebp
  80361c:	56                   	push   %esi
  80361d:	53                   	push   %ebx
  80361e:	83 ec 10             	sub    $0x10,%esp
  803621:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  803624:	8b 45 08             	mov    0x8(%ebp),%eax
  803627:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80362c:	8b 06                	mov    (%esi),%eax
  80362e:	a3 04 90 80 00       	mov    %eax,0x809004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803633:	b8 01 00 00 00       	mov    $0x1,%eax
  803638:	e8 76 ff ff ff       	call   8035b3 <nsipc>
  80363d:	89 c3                	mov    %eax,%ebx
  80363f:	85 c0                	test   %eax,%eax
  803641:	78 23                	js     803666 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803643:	a1 10 90 80 00       	mov    0x809010,%eax
  803648:	89 44 24 08          	mov    %eax,0x8(%esp)
  80364c:	c7 44 24 04 00 90 80 	movl   $0x809000,0x4(%esp)
  803653:	00 
  803654:	8b 45 0c             	mov    0xc(%ebp),%eax
  803657:	89 04 24             	mov    %eax,(%esp)
  80365a:	e8 b5 dd ff ff       	call   801414 <memmove>
		*addrlen = ret->ret_addrlen;
  80365f:	a1 10 90 80 00       	mov    0x809010,%eax
  803664:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  803666:	89 d8                	mov    %ebx,%eax
  803668:	83 c4 10             	add    $0x10,%esp
  80366b:	5b                   	pop    %ebx
  80366c:	5e                   	pop    %esi
  80366d:	5d                   	pop    %ebp
  80366e:	c3                   	ret    

0080366f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80366f:	55                   	push   %ebp
  803670:	89 e5                	mov    %esp,%ebp
  803672:	53                   	push   %ebx
  803673:	83 ec 14             	sub    $0x14,%esp
  803676:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803679:	8b 45 08             	mov    0x8(%ebp),%eax
  80367c:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803681:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803685:	8b 45 0c             	mov    0xc(%ebp),%eax
  803688:	89 44 24 04          	mov    %eax,0x4(%esp)
  80368c:	c7 04 24 04 90 80 00 	movl   $0x809004,(%esp)
  803693:	e8 7c dd ff ff       	call   801414 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803698:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_BIND);
  80369e:	b8 02 00 00 00       	mov    $0x2,%eax
  8036a3:	e8 0b ff ff ff       	call   8035b3 <nsipc>
}
  8036a8:	83 c4 14             	add    $0x14,%esp
  8036ab:	5b                   	pop    %ebx
  8036ac:	5d                   	pop    %ebp
  8036ad:	c3                   	ret    

008036ae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8036ae:	55                   	push   %ebp
  8036af:	89 e5                	mov    %esp,%ebp
  8036b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8036b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b7:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.shutdown.req_how = how;
  8036bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036bf:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_SHUTDOWN);
  8036c4:	b8 03 00 00 00       	mov    $0x3,%eax
  8036c9:	e8 e5 fe ff ff       	call   8035b3 <nsipc>
}
  8036ce:	c9                   	leave  
  8036cf:	c3                   	ret    

008036d0 <nsipc_close>:

int
nsipc_close(int s)
{
  8036d0:	55                   	push   %ebp
  8036d1:	89 e5                	mov    %esp,%ebp
  8036d3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8036d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d9:	a3 00 90 80 00       	mov    %eax,0x809000
	return nsipc(NSREQ_CLOSE);
  8036de:	b8 04 00 00 00       	mov    $0x4,%eax
  8036e3:	e8 cb fe ff ff       	call   8035b3 <nsipc>
}
  8036e8:	c9                   	leave  
  8036e9:	c3                   	ret    

008036ea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8036ea:	55                   	push   %ebp
  8036eb:	89 e5                	mov    %esp,%ebp
  8036ed:	53                   	push   %ebx
  8036ee:	83 ec 14             	sub    $0x14,%esp
  8036f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8036f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f7:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8036fc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803700:	8b 45 0c             	mov    0xc(%ebp),%eax
  803703:	89 44 24 04          	mov    %eax,0x4(%esp)
  803707:	c7 04 24 04 90 80 00 	movl   $0x809004,(%esp)
  80370e:	e8 01 dd ff ff       	call   801414 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803713:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_CONNECT);
  803719:	b8 05 00 00 00       	mov    $0x5,%eax
  80371e:	e8 90 fe ff ff       	call   8035b3 <nsipc>
}
  803723:	83 c4 14             	add    $0x14,%esp
  803726:	5b                   	pop    %ebx
  803727:	5d                   	pop    %ebp
  803728:	c3                   	ret    

00803729 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803729:	55                   	push   %ebp
  80372a:	89 e5                	mov    %esp,%ebp
  80372c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80372f:	8b 45 08             	mov    0x8(%ebp),%eax
  803732:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.listen.req_backlog = backlog;
  803737:	8b 45 0c             	mov    0xc(%ebp),%eax
  80373a:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_LISTEN);
  80373f:	b8 06 00 00 00       	mov    $0x6,%eax
  803744:	e8 6a fe ff ff       	call   8035b3 <nsipc>
}
  803749:	c9                   	leave  
  80374a:	c3                   	ret    

0080374b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80374b:	55                   	push   %ebp
  80374c:	89 e5                	mov    %esp,%ebp
  80374e:	56                   	push   %esi
  80374f:	53                   	push   %ebx
  803750:	83 ec 10             	sub    $0x10,%esp
  803753:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803756:	8b 45 08             	mov    0x8(%ebp),%eax
  803759:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.recv.req_len = len;
  80375e:	89 35 04 90 80 00    	mov    %esi,0x809004
	nsipcbuf.recv.req_flags = flags;
  803764:	8b 45 14             	mov    0x14(%ebp),%eax
  803767:	a3 08 90 80 00       	mov    %eax,0x809008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80376c:	b8 07 00 00 00       	mov    $0x7,%eax
  803771:	e8 3d fe ff ff       	call   8035b3 <nsipc>
  803776:	89 c3                	mov    %eax,%ebx
  803778:	85 c0                	test   %eax,%eax
  80377a:	78 46                	js     8037c2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80377c:	39 f0                	cmp    %esi,%eax
  80377e:	7f 07                	jg     803787 <nsipc_recv+0x3c>
  803780:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803785:	7e 24                	jle    8037ab <nsipc_recv+0x60>
  803787:	c7 44 24 0c f6 48 80 	movl   $0x8048f6,0xc(%esp)
  80378e:	00 
  80378f:	c7 44 24 08 55 42 80 	movl   $0x804255,0x8(%esp)
  803796:	00 
  803797:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80379e:	00 
  80379f:	c7 04 24 0b 49 80 00 	movl   $0x80490b,(%esp)
  8037a6:	e8 bc d2 ff ff       	call   800a67 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8037ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  8037af:	c7 44 24 04 00 90 80 	movl   $0x809000,0x4(%esp)
  8037b6:	00 
  8037b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037ba:	89 04 24             	mov    %eax,(%esp)
  8037bd:	e8 52 dc ff ff       	call   801414 <memmove>
	}

	return r;
}
  8037c2:	89 d8                	mov    %ebx,%eax
  8037c4:	83 c4 10             	add    $0x10,%esp
  8037c7:	5b                   	pop    %ebx
  8037c8:	5e                   	pop    %esi
  8037c9:	5d                   	pop    %ebp
  8037ca:	c3                   	ret    

008037cb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8037cb:	55                   	push   %ebp
  8037cc:	89 e5                	mov    %esp,%ebp
  8037ce:	53                   	push   %ebx
  8037cf:	83 ec 14             	sub    $0x14,%esp
  8037d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8037d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d8:	a3 00 90 80 00       	mov    %eax,0x809000
	assert(size < 1600);
  8037dd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8037e3:	7e 24                	jle    803809 <nsipc_send+0x3e>
  8037e5:	c7 44 24 0c 17 49 80 	movl   $0x804917,0xc(%esp)
  8037ec:	00 
  8037ed:	c7 44 24 08 55 42 80 	movl   $0x804255,0x8(%esp)
  8037f4:	00 
  8037f5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8037fc:	00 
  8037fd:	c7 04 24 0b 49 80 00 	movl   $0x80490b,(%esp)
  803804:	e8 5e d2 ff ff       	call   800a67 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803809:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80380d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803810:	89 44 24 04          	mov    %eax,0x4(%esp)
  803814:	c7 04 24 0c 90 80 00 	movl   $0x80900c,(%esp)
  80381b:	e8 f4 db ff ff       	call   801414 <memmove>
	nsipcbuf.send.req_size = size;
  803820:	89 1d 04 90 80 00    	mov    %ebx,0x809004
	nsipcbuf.send.req_flags = flags;
  803826:	8b 45 14             	mov    0x14(%ebp),%eax
  803829:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SEND);
  80382e:	b8 08 00 00 00       	mov    $0x8,%eax
  803833:	e8 7b fd ff ff       	call   8035b3 <nsipc>
}
  803838:	83 c4 14             	add    $0x14,%esp
  80383b:	5b                   	pop    %ebx
  80383c:	5d                   	pop    %ebp
  80383d:	c3                   	ret    

0080383e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80383e:	55                   	push   %ebp
  80383f:	89 e5                	mov    %esp,%ebp
  803841:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803844:	8b 45 08             	mov    0x8(%ebp),%eax
  803847:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.socket.req_type = type;
  80384c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80384f:	a3 04 90 80 00       	mov    %eax,0x809004
	nsipcbuf.socket.req_protocol = protocol;
  803854:	8b 45 10             	mov    0x10(%ebp),%eax
  803857:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SOCKET);
  80385c:	b8 09 00 00 00       	mov    $0x9,%eax
  803861:	e8 4d fd ff ff       	call   8035b3 <nsipc>
}
  803866:	c9                   	leave  
  803867:	c3                   	ret    

00803868 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803868:	55                   	push   %ebp
  803869:	89 e5                	mov    %esp,%ebp
  80386b:	56                   	push   %esi
  80386c:	53                   	push   %ebx
  80386d:	83 ec 10             	sub    $0x10,%esp
  803870:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803873:	8b 45 08             	mov    0x8(%ebp),%eax
  803876:	89 04 24             	mov    %eax,(%esp)
  803879:	e8 d2 e6 ff ff       	call   801f50 <fd2data>
  80387e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803880:	c7 44 24 04 23 49 80 	movl   $0x804923,0x4(%esp)
  803887:	00 
  803888:	89 1c 24             	mov    %ebx,(%esp)
  80388b:	e8 e7 d9 ff ff       	call   801277 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803890:	8b 46 04             	mov    0x4(%esi),%eax
  803893:	2b 06                	sub    (%esi),%eax
  803895:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80389b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8038a2:	00 00 00 
	stat->st_dev = &devpipe;
  8038a5:	c7 83 88 00 00 00 58 	movl   $0x805058,0x88(%ebx)
  8038ac:	50 80 00 
	return 0;
}
  8038af:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b4:	83 c4 10             	add    $0x10,%esp
  8038b7:	5b                   	pop    %ebx
  8038b8:	5e                   	pop    %esi
  8038b9:	5d                   	pop    %ebp
  8038ba:	c3                   	ret    

008038bb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8038bb:	55                   	push   %ebp
  8038bc:	89 e5                	mov    %esp,%ebp
  8038be:	53                   	push   %ebx
  8038bf:	83 ec 14             	sub    $0x14,%esp
  8038c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8038c5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8038c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038d0:	e8 65 de ff ff       	call   80173a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8038d5:	89 1c 24             	mov    %ebx,(%esp)
  8038d8:	e8 73 e6 ff ff       	call   801f50 <fd2data>
  8038dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038e8:	e8 4d de ff ff       	call   80173a <sys_page_unmap>
}
  8038ed:	83 c4 14             	add    $0x14,%esp
  8038f0:	5b                   	pop    %ebx
  8038f1:	5d                   	pop    %ebp
  8038f2:	c3                   	ret    

008038f3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8038f3:	55                   	push   %ebp
  8038f4:	89 e5                	mov    %esp,%ebp
  8038f6:	57                   	push   %edi
  8038f7:	56                   	push   %esi
  8038f8:	53                   	push   %ebx
  8038f9:	83 ec 2c             	sub    $0x2c,%esp
  8038fc:	89 c6                	mov    %eax,%esi
  8038fe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803901:	a1 28 64 80 00       	mov    0x806428,%eax
  803906:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803909:	89 34 24             	mov    %esi,(%esp)
  80390c:	e8 0e 05 00 00       	call   803e1f <pageref>
  803911:	89 c7                	mov    %eax,%edi
  803913:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803916:	89 04 24             	mov    %eax,(%esp)
  803919:	e8 01 05 00 00       	call   803e1f <pageref>
  80391e:	39 c7                	cmp    %eax,%edi
  803920:	0f 94 c2             	sete   %dl
  803923:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  803926:	8b 0d 28 64 80 00    	mov    0x806428,%ecx
  80392c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80392f:	39 fb                	cmp    %edi,%ebx
  803931:	74 21                	je     803954 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  803933:	84 d2                	test   %dl,%dl
  803935:	74 ca                	je     803901 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803937:	8b 51 58             	mov    0x58(%ecx),%edx
  80393a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80393e:	89 54 24 08          	mov    %edx,0x8(%esp)
  803942:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803946:	c7 04 24 2a 49 80 00 	movl   $0x80492a,(%esp)
  80394d:	e8 0e d2 ff ff       	call   800b60 <cprintf>
  803952:	eb ad                	jmp    803901 <_pipeisclosed+0xe>
	}
}
  803954:	83 c4 2c             	add    $0x2c,%esp
  803957:	5b                   	pop    %ebx
  803958:	5e                   	pop    %esi
  803959:	5f                   	pop    %edi
  80395a:	5d                   	pop    %ebp
  80395b:	c3                   	ret    

0080395c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80395c:	55                   	push   %ebp
  80395d:	89 e5                	mov    %esp,%ebp
  80395f:	57                   	push   %edi
  803960:	56                   	push   %esi
  803961:	53                   	push   %ebx
  803962:	83 ec 1c             	sub    $0x1c,%esp
  803965:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803968:	89 34 24             	mov    %esi,(%esp)
  80396b:	e8 e0 e5 ff ff       	call   801f50 <fd2data>
  803970:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803972:	bf 00 00 00 00       	mov    $0x0,%edi
  803977:	eb 45                	jmp    8039be <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803979:	89 da                	mov    %ebx,%edx
  80397b:	89 f0                	mov    %esi,%eax
  80397d:	e8 71 ff ff ff       	call   8038f3 <_pipeisclosed>
  803982:	85 c0                	test   %eax,%eax
  803984:	75 41                	jne    8039c7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803986:	e8 e9 dc ff ff       	call   801674 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80398b:	8b 43 04             	mov    0x4(%ebx),%eax
  80398e:	8b 0b                	mov    (%ebx),%ecx
  803990:	8d 51 20             	lea    0x20(%ecx),%edx
  803993:	39 d0                	cmp    %edx,%eax
  803995:	73 e2                	jae    803979 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803997:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80399a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80399e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8039a1:	99                   	cltd   
  8039a2:	c1 ea 1b             	shr    $0x1b,%edx
  8039a5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8039a8:	83 e1 1f             	and    $0x1f,%ecx
  8039ab:	29 d1                	sub    %edx,%ecx
  8039ad:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8039b1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8039b5:	83 c0 01             	add    $0x1,%eax
  8039b8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039bb:	83 c7 01             	add    $0x1,%edi
  8039be:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8039c1:	75 c8                	jne    80398b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8039c3:	89 f8                	mov    %edi,%eax
  8039c5:	eb 05                	jmp    8039cc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8039c7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8039cc:	83 c4 1c             	add    $0x1c,%esp
  8039cf:	5b                   	pop    %ebx
  8039d0:	5e                   	pop    %esi
  8039d1:	5f                   	pop    %edi
  8039d2:	5d                   	pop    %ebp
  8039d3:	c3                   	ret    

008039d4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8039d4:	55                   	push   %ebp
  8039d5:	89 e5                	mov    %esp,%ebp
  8039d7:	57                   	push   %edi
  8039d8:	56                   	push   %esi
  8039d9:	53                   	push   %ebx
  8039da:	83 ec 1c             	sub    $0x1c,%esp
  8039dd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8039e0:	89 3c 24             	mov    %edi,(%esp)
  8039e3:	e8 68 e5 ff ff       	call   801f50 <fd2data>
  8039e8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8039ea:	be 00 00 00 00       	mov    $0x0,%esi
  8039ef:	eb 3d                	jmp    803a2e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8039f1:	85 f6                	test   %esi,%esi
  8039f3:	74 04                	je     8039f9 <devpipe_read+0x25>
				return i;
  8039f5:	89 f0                	mov    %esi,%eax
  8039f7:	eb 43                	jmp    803a3c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8039f9:	89 da                	mov    %ebx,%edx
  8039fb:	89 f8                	mov    %edi,%eax
  8039fd:	e8 f1 fe ff ff       	call   8038f3 <_pipeisclosed>
  803a02:	85 c0                	test   %eax,%eax
  803a04:	75 31                	jne    803a37 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803a06:	e8 69 dc ff ff       	call   801674 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803a0b:	8b 03                	mov    (%ebx),%eax
  803a0d:	3b 43 04             	cmp    0x4(%ebx),%eax
  803a10:	74 df                	je     8039f1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803a12:	99                   	cltd   
  803a13:	c1 ea 1b             	shr    $0x1b,%edx
  803a16:	01 d0                	add    %edx,%eax
  803a18:	83 e0 1f             	and    $0x1f,%eax
  803a1b:	29 d0                	sub    %edx,%eax
  803a1d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803a22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803a25:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803a28:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803a2b:	83 c6 01             	add    $0x1,%esi
  803a2e:	3b 75 10             	cmp    0x10(%ebp),%esi
  803a31:	75 d8                	jne    803a0b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803a33:	89 f0                	mov    %esi,%eax
  803a35:	eb 05                	jmp    803a3c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  803a37:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  803a3c:	83 c4 1c             	add    $0x1c,%esp
  803a3f:	5b                   	pop    %ebx
  803a40:	5e                   	pop    %esi
  803a41:	5f                   	pop    %edi
  803a42:	5d                   	pop    %ebp
  803a43:	c3                   	ret    

00803a44 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803a44:	55                   	push   %ebp
  803a45:	89 e5                	mov    %esp,%ebp
  803a47:	56                   	push   %esi
  803a48:	53                   	push   %ebx
  803a49:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803a4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803a4f:	89 04 24             	mov    %eax,(%esp)
  803a52:	e8 10 e5 ff ff       	call   801f67 <fd_alloc>
  803a57:	89 c2                	mov    %eax,%edx
  803a59:	85 d2                	test   %edx,%edx
  803a5b:	0f 88 4d 01 00 00    	js     803bae <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a61:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803a68:	00 
  803a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a77:	e8 17 dc ff ff       	call   801693 <sys_page_alloc>
  803a7c:	89 c2                	mov    %eax,%edx
  803a7e:	85 d2                	test   %edx,%edx
  803a80:	0f 88 28 01 00 00    	js     803bae <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803a86:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803a89:	89 04 24             	mov    %eax,(%esp)
  803a8c:	e8 d6 e4 ff ff       	call   801f67 <fd_alloc>
  803a91:	89 c3                	mov    %eax,%ebx
  803a93:	85 c0                	test   %eax,%eax
  803a95:	0f 88 fe 00 00 00    	js     803b99 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803a9b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803aa2:	00 
  803aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  803aaa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ab1:	e8 dd db ff ff       	call   801693 <sys_page_alloc>
  803ab6:	89 c3                	mov    %eax,%ebx
  803ab8:	85 c0                	test   %eax,%eax
  803aba:	0f 88 d9 00 00 00    	js     803b99 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac3:	89 04 24             	mov    %eax,(%esp)
  803ac6:	e8 85 e4 ff ff       	call   801f50 <fd2data>
  803acb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803acd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803ad4:	00 
  803ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ad9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ae0:	e8 ae db ff ff       	call   801693 <sys_page_alloc>
  803ae5:	89 c3                	mov    %eax,%ebx
  803ae7:	85 c0                	test   %eax,%eax
  803ae9:	0f 88 97 00 00 00    	js     803b86 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803af2:	89 04 24             	mov    %eax,(%esp)
  803af5:	e8 56 e4 ff ff       	call   801f50 <fd2data>
  803afa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803b01:	00 
  803b02:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b06:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803b0d:	00 
  803b0e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803b12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803b19:	e8 c9 db ff ff       	call   8016e7 <sys_page_map>
  803b1e:	89 c3                	mov    %eax,%ebx
  803b20:	85 c0                	test   %eax,%eax
  803b22:	78 52                	js     803b76 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803b24:	8b 15 58 50 80 00    	mov    0x805058,%edx
  803b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b2d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  803b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803b39:	8b 15 58 50 80 00    	mov    0x805058,%edx
  803b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b42:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b47:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b51:	89 04 24             	mov    %eax,(%esp)
  803b54:	e8 e7 e3 ff ff       	call   801f40 <fd2num>
  803b59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803b5c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b61:	89 04 24             	mov    %eax,(%esp)
  803b64:	e8 d7 e3 ff ff       	call   801f40 <fd2num>
  803b69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803b6c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803b6f:	b8 00 00 00 00       	mov    $0x0,%eax
  803b74:	eb 38                	jmp    803bae <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  803b76:	89 74 24 04          	mov    %esi,0x4(%esp)
  803b7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803b81:	e8 b4 db ff ff       	call   80173a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  803b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b89:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b8d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803b94:	e8 a1 db ff ff       	call   80173a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  803b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ba0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ba7:	e8 8e db ff ff       	call   80173a <sys_page_unmap>
  803bac:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  803bae:	83 c4 30             	add    $0x30,%esp
  803bb1:	5b                   	pop    %ebx
  803bb2:	5e                   	pop    %esi
  803bb3:	5d                   	pop    %ebp
  803bb4:	c3                   	ret    

00803bb5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  803bb5:	55                   	push   %ebp
  803bb6:	89 e5                	mov    %esp,%ebp
  803bb8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803bbb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc5:	89 04 24             	mov    %eax,(%esp)
  803bc8:	e8 e9 e3 ff ff       	call   801fb6 <fd_lookup>
  803bcd:	89 c2                	mov    %eax,%edx
  803bcf:	85 d2                	test   %edx,%edx
  803bd1:	78 15                	js     803be8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd6:	89 04 24             	mov    %eax,(%esp)
  803bd9:	e8 72 e3 ff ff       	call   801f50 <fd2data>
	return _pipeisclosed(fd, p);
  803bde:	89 c2                	mov    %eax,%edx
  803be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be3:	e8 0b fd ff ff       	call   8038f3 <_pipeisclosed>
}
  803be8:	c9                   	leave  
  803be9:	c3                   	ret    

00803bea <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803bea:	55                   	push   %ebp
  803beb:	89 e5                	mov    %esp,%ebp
  803bed:	56                   	push   %esi
  803bee:	53                   	push   %ebx
  803bef:	83 ec 10             	sub    $0x10,%esp
  803bf2:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  803bf5:	85 f6                	test   %esi,%esi
  803bf7:	75 24                	jne    803c1d <wait+0x33>
  803bf9:	c7 44 24 0c 42 49 80 	movl   $0x804942,0xc(%esp)
  803c00:	00 
  803c01:	c7 44 24 08 55 42 80 	movl   $0x804255,0x8(%esp)
  803c08:	00 
  803c09:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  803c10:	00 
  803c11:	c7 04 24 4d 49 80 00 	movl   $0x80494d,(%esp)
  803c18:	e8 4a ce ff ff       	call   800a67 <_panic>
	e = &envs[ENVX(envid)];
  803c1d:	89 f3                	mov    %esi,%ebx
  803c1f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  803c25:	c1 e3 07             	shl    $0x7,%ebx
  803c28:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803c2e:	eb 05                	jmp    803c35 <wait+0x4b>
		sys_yield();
  803c30:	e8 3f da ff ff       	call   801674 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803c35:	8b 43 48             	mov    0x48(%ebx),%eax
  803c38:	39 f0                	cmp    %esi,%eax
  803c3a:	75 07                	jne    803c43 <wait+0x59>
  803c3c:	8b 43 54             	mov    0x54(%ebx),%eax
  803c3f:	85 c0                	test   %eax,%eax
  803c41:	75 ed                	jne    803c30 <wait+0x46>
		sys_yield();
}
  803c43:	83 c4 10             	add    $0x10,%esp
  803c46:	5b                   	pop    %ebx
  803c47:	5e                   	pop    %esi
  803c48:	5d                   	pop    %ebp
  803c49:	c3                   	ret    

00803c4a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803c4a:	55                   	push   %ebp
  803c4b:	89 e5                	mov    %esp,%ebp
  803c4d:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  803c50:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  803c57:	75 68                	jne    803cc1 <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  803c59:	a1 28 64 80 00       	mov    0x806428,%eax
  803c5e:	8b 40 48             	mov    0x48(%eax),%eax
  803c61:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803c68:	00 
  803c69:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  803c70:	ee 
  803c71:	89 04 24             	mov    %eax,(%esp)
  803c74:	e8 1a da ff ff       	call   801693 <sys_page_alloc>
  803c79:	85 c0                	test   %eax,%eax
  803c7b:	74 2c                	je     803ca9 <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  803c7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c81:	c7 04 24 58 49 80 00 	movl   $0x804958,(%esp)
  803c88:	e8 d3 ce ff ff       	call   800b60 <cprintf>
			panic("set_pg_fault_handler");
  803c8d:	c7 44 24 08 8c 49 80 	movl   $0x80498c,0x8(%esp)
  803c94:	00 
  803c95:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  803c9c:	00 
  803c9d:	c7 04 24 a1 49 80 00 	movl   $0x8049a1,(%esp)
  803ca4:	e8 be cd ff ff       	call   800a67 <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  803ca9:	a1 28 64 80 00       	mov    0x806428,%eax
  803cae:	8b 40 48             	mov    0x48(%eax),%eax
  803cb1:	c7 44 24 04 cb 3c 80 	movl   $0x803ccb,0x4(%esp)
  803cb8:	00 
  803cb9:	89 04 24             	mov    %eax,(%esp)
  803cbc:	e8 72 db ff ff       	call   801833 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  803cc4:	a3 00 a0 80 00       	mov    %eax,0x80a000
}
  803cc9:	c9                   	leave  
  803cca:	c3                   	ret    

00803ccb <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803ccb:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803ccc:	a1 00 a0 80 00       	mov    0x80a000,%eax
	call *%eax
  803cd1:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803cd3:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  803cd6:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  803cda:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  803cdc:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  803ce0:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  803ce1:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  803ce4:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  803ce6:	58                   	pop    %eax
	popl %eax
  803ce7:	58                   	pop    %eax
	popal
  803ce8:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  803ce9:	83 c4 04             	add    $0x4,%esp
	popfl
  803cec:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803ced:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  803cee:	c3                   	ret    
  803cef:	90                   	nop

00803cf0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803cf0:	55                   	push   %ebp
  803cf1:	89 e5                	mov    %esp,%ebp
  803cf3:	56                   	push   %esi
  803cf4:	53                   	push   %ebx
  803cf5:	83 ec 10             	sub    $0x10,%esp
  803cf8:	8b 75 08             	mov    0x8(%ebp),%esi
  803cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cfe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  803d01:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  803d03:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  803d08:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  803d0b:	89 04 24             	mov    %eax,(%esp)
  803d0e:	e8 96 db ff ff       	call   8018a9 <sys_ipc_recv>
  803d13:	85 c0                	test   %eax,%eax
  803d15:	74 16                	je     803d2d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  803d17:	85 f6                	test   %esi,%esi
  803d19:	74 06                	je     803d21 <ipc_recv+0x31>
			*from_env_store = 0;
  803d1b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  803d21:	85 db                	test   %ebx,%ebx
  803d23:	74 2c                	je     803d51 <ipc_recv+0x61>
			*perm_store = 0;
  803d25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  803d2b:	eb 24                	jmp    803d51 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  803d2d:	85 f6                	test   %esi,%esi
  803d2f:	74 0a                	je     803d3b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  803d31:	a1 28 64 80 00       	mov    0x806428,%eax
  803d36:	8b 40 74             	mov    0x74(%eax),%eax
  803d39:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  803d3b:	85 db                	test   %ebx,%ebx
  803d3d:	74 0a                	je     803d49 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  803d3f:	a1 28 64 80 00       	mov    0x806428,%eax
  803d44:	8b 40 78             	mov    0x78(%eax),%eax
  803d47:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  803d49:	a1 28 64 80 00       	mov    0x806428,%eax
  803d4e:	8b 40 70             	mov    0x70(%eax),%eax
}
  803d51:	83 c4 10             	add    $0x10,%esp
  803d54:	5b                   	pop    %ebx
  803d55:	5e                   	pop    %esi
  803d56:	5d                   	pop    %ebp
  803d57:	c3                   	ret    

00803d58 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803d58:	55                   	push   %ebp
  803d59:	89 e5                	mov    %esp,%ebp
  803d5b:	57                   	push   %edi
  803d5c:	56                   	push   %esi
  803d5d:	53                   	push   %ebx
  803d5e:	83 ec 1c             	sub    $0x1c,%esp
  803d61:	8b 75 0c             	mov    0xc(%ebp),%esi
  803d64:	8b 5d 10             	mov    0x10(%ebp),%ebx
  803d67:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  803d6a:	85 db                	test   %ebx,%ebx
  803d6c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  803d71:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  803d74:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d78:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803d7c:	89 74 24 04          	mov    %esi,0x4(%esp)
  803d80:	8b 45 08             	mov    0x8(%ebp),%eax
  803d83:	89 04 24             	mov    %eax,(%esp)
  803d86:	e8 fb da ff ff       	call   801886 <sys_ipc_try_send>
	if (r == 0) return;
  803d8b:	85 c0                	test   %eax,%eax
  803d8d:	75 22                	jne    803db1 <ipc_send+0x59>
  803d8f:	eb 4c                	jmp    803ddd <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  803d91:	84 d2                	test   %dl,%dl
  803d93:	75 48                	jne    803ddd <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  803d95:	e8 da d8 ff ff       	call   801674 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  803d9a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803d9e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803da2:	89 74 24 04          	mov    %esi,0x4(%esp)
  803da6:	8b 45 08             	mov    0x8(%ebp),%eax
  803da9:	89 04 24             	mov    %eax,(%esp)
  803dac:	e8 d5 da ff ff       	call   801886 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  803db1:	85 c0                	test   %eax,%eax
  803db3:	0f 94 c2             	sete   %dl
  803db6:	74 d9                	je     803d91 <ipc_send+0x39>
  803db8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803dbb:	74 d4                	je     803d91 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  803dbd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803dc1:	c7 44 24 08 af 49 80 	movl   $0x8049af,0x8(%esp)
  803dc8:	00 
  803dc9:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  803dd0:	00 
  803dd1:	c7 04 24 bd 49 80 00 	movl   $0x8049bd,(%esp)
  803dd8:	e8 8a cc ff ff       	call   800a67 <_panic>
}
  803ddd:	83 c4 1c             	add    $0x1c,%esp
  803de0:	5b                   	pop    %ebx
  803de1:	5e                   	pop    %esi
  803de2:	5f                   	pop    %edi
  803de3:	5d                   	pop    %ebp
  803de4:	c3                   	ret    

00803de5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803de5:	55                   	push   %ebp
  803de6:	89 e5                	mov    %esp,%ebp
  803de8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  803deb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  803df0:	89 c2                	mov    %eax,%edx
  803df2:	c1 e2 07             	shl    $0x7,%edx
  803df5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  803dfb:	8b 52 50             	mov    0x50(%edx),%edx
  803dfe:	39 ca                	cmp    %ecx,%edx
  803e00:	75 0d                	jne    803e0f <ipc_find_env+0x2a>
			return envs[i].env_id;
  803e02:	c1 e0 07             	shl    $0x7,%eax
  803e05:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  803e0a:	8b 40 40             	mov    0x40(%eax),%eax
  803e0d:	eb 0e                	jmp    803e1d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803e0f:	83 c0 01             	add    $0x1,%eax
  803e12:	3d 00 04 00 00       	cmp    $0x400,%eax
  803e17:	75 d7                	jne    803df0 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803e19:	66 b8 00 00          	mov    $0x0,%ax
}
  803e1d:	5d                   	pop    %ebp
  803e1e:	c3                   	ret    

00803e1f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803e1f:	55                   	push   %ebp
  803e20:	89 e5                	mov    %esp,%ebp
  803e22:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803e25:	89 d0                	mov    %edx,%eax
  803e27:	c1 e8 16             	shr    $0x16,%eax
  803e2a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803e31:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803e36:	f6 c1 01             	test   $0x1,%cl
  803e39:	74 1d                	je     803e58 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  803e3b:	c1 ea 0c             	shr    $0xc,%edx
  803e3e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803e45:	f6 c2 01             	test   $0x1,%dl
  803e48:	74 0e                	je     803e58 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803e4a:	c1 ea 0c             	shr    $0xc,%edx
  803e4d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803e54:	ef 
  803e55:	0f b7 c0             	movzwl %ax,%eax
}
  803e58:	5d                   	pop    %ebp
  803e59:	c3                   	ret    
  803e5a:	66 90                	xchg   %ax,%ax
  803e5c:	66 90                	xchg   %ax,%ax
  803e5e:	66 90                	xchg   %ax,%ax

00803e60 <__udivdi3>:
  803e60:	55                   	push   %ebp
  803e61:	57                   	push   %edi
  803e62:	56                   	push   %esi
  803e63:	83 ec 0c             	sub    $0xc,%esp
  803e66:	8b 44 24 28          	mov    0x28(%esp),%eax
  803e6a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  803e6e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  803e72:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  803e76:	85 c0                	test   %eax,%eax
  803e78:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803e7c:	89 ea                	mov    %ebp,%edx
  803e7e:	89 0c 24             	mov    %ecx,(%esp)
  803e81:	75 2d                	jne    803eb0 <__udivdi3+0x50>
  803e83:	39 e9                	cmp    %ebp,%ecx
  803e85:	77 61                	ja     803ee8 <__udivdi3+0x88>
  803e87:	85 c9                	test   %ecx,%ecx
  803e89:	89 ce                	mov    %ecx,%esi
  803e8b:	75 0b                	jne    803e98 <__udivdi3+0x38>
  803e8d:	b8 01 00 00 00       	mov    $0x1,%eax
  803e92:	31 d2                	xor    %edx,%edx
  803e94:	f7 f1                	div    %ecx
  803e96:	89 c6                	mov    %eax,%esi
  803e98:	31 d2                	xor    %edx,%edx
  803e9a:	89 e8                	mov    %ebp,%eax
  803e9c:	f7 f6                	div    %esi
  803e9e:	89 c5                	mov    %eax,%ebp
  803ea0:	89 f8                	mov    %edi,%eax
  803ea2:	f7 f6                	div    %esi
  803ea4:	89 ea                	mov    %ebp,%edx
  803ea6:	83 c4 0c             	add    $0xc,%esp
  803ea9:	5e                   	pop    %esi
  803eaa:	5f                   	pop    %edi
  803eab:	5d                   	pop    %ebp
  803eac:	c3                   	ret    
  803ead:	8d 76 00             	lea    0x0(%esi),%esi
  803eb0:	39 e8                	cmp    %ebp,%eax
  803eb2:	77 24                	ja     803ed8 <__udivdi3+0x78>
  803eb4:	0f bd e8             	bsr    %eax,%ebp
  803eb7:	83 f5 1f             	xor    $0x1f,%ebp
  803eba:	75 3c                	jne    803ef8 <__udivdi3+0x98>
  803ebc:	8b 74 24 04          	mov    0x4(%esp),%esi
  803ec0:	39 34 24             	cmp    %esi,(%esp)
  803ec3:	0f 86 9f 00 00 00    	jbe    803f68 <__udivdi3+0x108>
  803ec9:	39 d0                	cmp    %edx,%eax
  803ecb:	0f 82 97 00 00 00    	jb     803f68 <__udivdi3+0x108>
  803ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803ed8:	31 d2                	xor    %edx,%edx
  803eda:	31 c0                	xor    %eax,%eax
  803edc:	83 c4 0c             	add    $0xc,%esp
  803edf:	5e                   	pop    %esi
  803ee0:	5f                   	pop    %edi
  803ee1:	5d                   	pop    %ebp
  803ee2:	c3                   	ret    
  803ee3:	90                   	nop
  803ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803ee8:	89 f8                	mov    %edi,%eax
  803eea:	f7 f1                	div    %ecx
  803eec:	31 d2                	xor    %edx,%edx
  803eee:	83 c4 0c             	add    $0xc,%esp
  803ef1:	5e                   	pop    %esi
  803ef2:	5f                   	pop    %edi
  803ef3:	5d                   	pop    %ebp
  803ef4:	c3                   	ret    
  803ef5:	8d 76 00             	lea    0x0(%esi),%esi
  803ef8:	89 e9                	mov    %ebp,%ecx
  803efa:	8b 3c 24             	mov    (%esp),%edi
  803efd:	d3 e0                	shl    %cl,%eax
  803eff:	89 c6                	mov    %eax,%esi
  803f01:	b8 20 00 00 00       	mov    $0x20,%eax
  803f06:	29 e8                	sub    %ebp,%eax
  803f08:	89 c1                	mov    %eax,%ecx
  803f0a:	d3 ef                	shr    %cl,%edi
  803f0c:	89 e9                	mov    %ebp,%ecx
  803f0e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803f12:	8b 3c 24             	mov    (%esp),%edi
  803f15:	09 74 24 08          	or     %esi,0x8(%esp)
  803f19:	89 d6                	mov    %edx,%esi
  803f1b:	d3 e7                	shl    %cl,%edi
  803f1d:	89 c1                	mov    %eax,%ecx
  803f1f:	89 3c 24             	mov    %edi,(%esp)
  803f22:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803f26:	d3 ee                	shr    %cl,%esi
  803f28:	89 e9                	mov    %ebp,%ecx
  803f2a:	d3 e2                	shl    %cl,%edx
  803f2c:	89 c1                	mov    %eax,%ecx
  803f2e:	d3 ef                	shr    %cl,%edi
  803f30:	09 d7                	or     %edx,%edi
  803f32:	89 f2                	mov    %esi,%edx
  803f34:	89 f8                	mov    %edi,%eax
  803f36:	f7 74 24 08          	divl   0x8(%esp)
  803f3a:	89 d6                	mov    %edx,%esi
  803f3c:	89 c7                	mov    %eax,%edi
  803f3e:	f7 24 24             	mull   (%esp)
  803f41:	39 d6                	cmp    %edx,%esi
  803f43:	89 14 24             	mov    %edx,(%esp)
  803f46:	72 30                	jb     803f78 <__udivdi3+0x118>
  803f48:	8b 54 24 04          	mov    0x4(%esp),%edx
  803f4c:	89 e9                	mov    %ebp,%ecx
  803f4e:	d3 e2                	shl    %cl,%edx
  803f50:	39 c2                	cmp    %eax,%edx
  803f52:	73 05                	jae    803f59 <__udivdi3+0xf9>
  803f54:	3b 34 24             	cmp    (%esp),%esi
  803f57:	74 1f                	je     803f78 <__udivdi3+0x118>
  803f59:	89 f8                	mov    %edi,%eax
  803f5b:	31 d2                	xor    %edx,%edx
  803f5d:	e9 7a ff ff ff       	jmp    803edc <__udivdi3+0x7c>
  803f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803f68:	31 d2                	xor    %edx,%edx
  803f6a:	b8 01 00 00 00       	mov    $0x1,%eax
  803f6f:	e9 68 ff ff ff       	jmp    803edc <__udivdi3+0x7c>
  803f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803f78:	8d 47 ff             	lea    -0x1(%edi),%eax
  803f7b:	31 d2                	xor    %edx,%edx
  803f7d:	83 c4 0c             	add    $0xc,%esp
  803f80:	5e                   	pop    %esi
  803f81:	5f                   	pop    %edi
  803f82:	5d                   	pop    %ebp
  803f83:	c3                   	ret    
  803f84:	66 90                	xchg   %ax,%ax
  803f86:	66 90                	xchg   %ax,%ax
  803f88:	66 90                	xchg   %ax,%ax
  803f8a:	66 90                	xchg   %ax,%ax
  803f8c:	66 90                	xchg   %ax,%ax
  803f8e:	66 90                	xchg   %ax,%ax

00803f90 <__umoddi3>:
  803f90:	55                   	push   %ebp
  803f91:	57                   	push   %edi
  803f92:	56                   	push   %esi
  803f93:	83 ec 14             	sub    $0x14,%esp
  803f96:	8b 44 24 28          	mov    0x28(%esp),%eax
  803f9a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  803f9e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803fa2:	89 c7                	mov    %eax,%edi
  803fa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fa8:	8b 44 24 30          	mov    0x30(%esp),%eax
  803fac:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803fb0:	89 34 24             	mov    %esi,(%esp)
  803fb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803fb7:	85 c0                	test   %eax,%eax
  803fb9:	89 c2                	mov    %eax,%edx
  803fbb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803fbf:	75 17                	jne    803fd8 <__umoddi3+0x48>
  803fc1:	39 fe                	cmp    %edi,%esi
  803fc3:	76 4b                	jbe    804010 <__umoddi3+0x80>
  803fc5:	89 c8                	mov    %ecx,%eax
  803fc7:	89 fa                	mov    %edi,%edx
  803fc9:	f7 f6                	div    %esi
  803fcb:	89 d0                	mov    %edx,%eax
  803fcd:	31 d2                	xor    %edx,%edx
  803fcf:	83 c4 14             	add    $0x14,%esp
  803fd2:	5e                   	pop    %esi
  803fd3:	5f                   	pop    %edi
  803fd4:	5d                   	pop    %ebp
  803fd5:	c3                   	ret    
  803fd6:	66 90                	xchg   %ax,%ax
  803fd8:	39 f8                	cmp    %edi,%eax
  803fda:	77 54                	ja     804030 <__umoddi3+0xa0>
  803fdc:	0f bd e8             	bsr    %eax,%ebp
  803fdf:	83 f5 1f             	xor    $0x1f,%ebp
  803fe2:	75 5c                	jne    804040 <__umoddi3+0xb0>
  803fe4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803fe8:	39 3c 24             	cmp    %edi,(%esp)
  803feb:	0f 87 e7 00 00 00    	ja     8040d8 <__umoddi3+0x148>
  803ff1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803ff5:	29 f1                	sub    %esi,%ecx
  803ff7:	19 c7                	sbb    %eax,%edi
  803ff9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803ffd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804001:	8b 44 24 08          	mov    0x8(%esp),%eax
  804005:	8b 54 24 0c          	mov    0xc(%esp),%edx
  804009:	83 c4 14             	add    $0x14,%esp
  80400c:	5e                   	pop    %esi
  80400d:	5f                   	pop    %edi
  80400e:	5d                   	pop    %ebp
  80400f:	c3                   	ret    
  804010:	85 f6                	test   %esi,%esi
  804012:	89 f5                	mov    %esi,%ebp
  804014:	75 0b                	jne    804021 <__umoddi3+0x91>
  804016:	b8 01 00 00 00       	mov    $0x1,%eax
  80401b:	31 d2                	xor    %edx,%edx
  80401d:	f7 f6                	div    %esi
  80401f:	89 c5                	mov    %eax,%ebp
  804021:	8b 44 24 04          	mov    0x4(%esp),%eax
  804025:	31 d2                	xor    %edx,%edx
  804027:	f7 f5                	div    %ebp
  804029:	89 c8                	mov    %ecx,%eax
  80402b:	f7 f5                	div    %ebp
  80402d:	eb 9c                	jmp    803fcb <__umoddi3+0x3b>
  80402f:	90                   	nop
  804030:	89 c8                	mov    %ecx,%eax
  804032:	89 fa                	mov    %edi,%edx
  804034:	83 c4 14             	add    $0x14,%esp
  804037:	5e                   	pop    %esi
  804038:	5f                   	pop    %edi
  804039:	5d                   	pop    %ebp
  80403a:	c3                   	ret    
  80403b:	90                   	nop
  80403c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804040:	8b 04 24             	mov    (%esp),%eax
  804043:	be 20 00 00 00       	mov    $0x20,%esi
  804048:	89 e9                	mov    %ebp,%ecx
  80404a:	29 ee                	sub    %ebp,%esi
  80404c:	d3 e2                	shl    %cl,%edx
  80404e:	89 f1                	mov    %esi,%ecx
  804050:	d3 e8                	shr    %cl,%eax
  804052:	89 e9                	mov    %ebp,%ecx
  804054:	89 44 24 04          	mov    %eax,0x4(%esp)
  804058:	8b 04 24             	mov    (%esp),%eax
  80405b:	09 54 24 04          	or     %edx,0x4(%esp)
  80405f:	89 fa                	mov    %edi,%edx
  804061:	d3 e0                	shl    %cl,%eax
  804063:	89 f1                	mov    %esi,%ecx
  804065:	89 44 24 08          	mov    %eax,0x8(%esp)
  804069:	8b 44 24 10          	mov    0x10(%esp),%eax
  80406d:	d3 ea                	shr    %cl,%edx
  80406f:	89 e9                	mov    %ebp,%ecx
  804071:	d3 e7                	shl    %cl,%edi
  804073:	89 f1                	mov    %esi,%ecx
  804075:	d3 e8                	shr    %cl,%eax
  804077:	89 e9                	mov    %ebp,%ecx
  804079:	09 f8                	or     %edi,%eax
  80407b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80407f:	f7 74 24 04          	divl   0x4(%esp)
  804083:	d3 e7                	shl    %cl,%edi
  804085:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804089:	89 d7                	mov    %edx,%edi
  80408b:	f7 64 24 08          	mull   0x8(%esp)
  80408f:	39 d7                	cmp    %edx,%edi
  804091:	89 c1                	mov    %eax,%ecx
  804093:	89 14 24             	mov    %edx,(%esp)
  804096:	72 2c                	jb     8040c4 <__umoddi3+0x134>
  804098:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80409c:	72 22                	jb     8040c0 <__umoddi3+0x130>
  80409e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8040a2:	29 c8                	sub    %ecx,%eax
  8040a4:	19 d7                	sbb    %edx,%edi
  8040a6:	89 e9                	mov    %ebp,%ecx
  8040a8:	89 fa                	mov    %edi,%edx
  8040aa:	d3 e8                	shr    %cl,%eax
  8040ac:	89 f1                	mov    %esi,%ecx
  8040ae:	d3 e2                	shl    %cl,%edx
  8040b0:	89 e9                	mov    %ebp,%ecx
  8040b2:	d3 ef                	shr    %cl,%edi
  8040b4:	09 d0                	or     %edx,%eax
  8040b6:	89 fa                	mov    %edi,%edx
  8040b8:	83 c4 14             	add    $0x14,%esp
  8040bb:	5e                   	pop    %esi
  8040bc:	5f                   	pop    %edi
  8040bd:	5d                   	pop    %ebp
  8040be:	c3                   	ret    
  8040bf:	90                   	nop
  8040c0:	39 d7                	cmp    %edx,%edi
  8040c2:	75 da                	jne    80409e <__umoddi3+0x10e>
  8040c4:	8b 14 24             	mov    (%esp),%edx
  8040c7:	89 c1                	mov    %eax,%ecx
  8040c9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8040cd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8040d1:	eb cb                	jmp    80409e <__umoddi3+0x10e>
  8040d3:	90                   	nop
  8040d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8040d8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8040dc:	0f 82 0f ff ff ff    	jb     803ff1 <__umoddi3+0x61>
  8040e2:	e9 1a ff ff ff       	jmp    804001 <__umoddi3+0x71>
