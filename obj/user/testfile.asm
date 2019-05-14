
obj/user/testfile.debug:     file format elf32-i386


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
  80002c:	e8 52 07 00 00       	call   800783 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
  80003a:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800040:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  800047:	e8 bb 0e 00 00       	call   800f07 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80004c:	89 1d 00 64 80 00    	mov    %ebx,0x806400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800052:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800059:	e8 07 17 00 00       	call   801765 <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80005e:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800065:	00 
  800066:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80006d:	00 
  80006e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800075:	00 
  800076:	89 04 24             	mov    %eax,(%esp)
  800079:	e8 5a 16 00 00       	call   8016d8 <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  80007e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800085:	00 
  800086:	c7 44 24 04 00 c0 cc 	movl   $0xccccc000,0x4(%esp)
  80008d:	cc 
  80008e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800095:	e8 d6 15 00 00       	call   801670 <ipc_recv>
}
  80009a:	83 c4 14             	add    $0x14,%esp
  80009d:	5b                   	pop    %ebx
  80009e:	5d                   	pop    %ebp
  80009f:	c3                   	ret    

008000a0 <umain>:

void
umain(int argc, char **argv)
{
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	57                   	push   %edi
  8000a4:	56                   	push   %esi
  8000a5:	53                   	push   %ebx
  8000a6:	81 ec cc 02 00 00    	sub    $0x2cc,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b1:	b8 a0 2d 80 00       	mov    $0x802da0,%eax
  8000b6:	e8 78 ff ff ff       	call   800033 <xopen>
  8000bb:	85 c0                	test   %eax,%eax
  8000bd:	79 25                	jns    8000e4 <umain+0x44>
  8000bf:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8000c2:	74 3c                	je     800100 <umain+0x60>
		panic("serve_open /not-found: %e", r);
  8000c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000c8:	c7 44 24 08 ab 2d 80 	movl   $0x802dab,0x8(%esp)
  8000cf:	00 
  8000d0:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  8000d7:	00 
  8000d8:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  8000df:	e8 00 07 00 00       	call   8007e4 <_panic>
	else if (r >= 0)
		panic("serve_open /not-found succeeded!");
  8000e4:	c7 44 24 08 60 2f 80 	movl   $0x802f60,0x8(%esp)
  8000eb:	00 
  8000ec:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8000f3:	00 
  8000f4:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  8000fb:	e8 e4 06 00 00       	call   8007e4 <_panic>

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800100:	ba 00 00 00 00       	mov    $0x0,%edx
  800105:	b8 d5 2d 80 00       	mov    $0x802dd5,%eax
  80010a:	e8 24 ff ff ff       	call   800033 <xopen>
  80010f:	85 c0                	test   %eax,%eax
  800111:	79 20                	jns    800133 <umain+0x93>
		panic("serve_open /newmotd: %e", r);
  800113:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800117:	c7 44 24 08 de 2d 80 	movl   $0x802dde,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800126:	00 
  800127:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  80012e:	e8 b1 06 00 00       	call   8007e4 <_panic>
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  800133:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  80013a:	75 12                	jne    80014e <umain+0xae>
  80013c:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  800143:	75 09                	jne    80014e <umain+0xae>
  800145:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  80014c:	74 1c                	je     80016a <umain+0xca>
		panic("serve_open did not fill struct Fd correctly\n");
  80014e:	c7 44 24 08 84 2f 80 	movl   $0x802f84,0x8(%esp)
  800155:	00 
  800156:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  80015d:	00 
  80015e:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  800165:	e8 7a 06 00 00       	call   8007e4 <_panic>
	cprintf("serve_open is good\n");
  80016a:	c7 04 24 f6 2d 80 00 	movl   $0x802df6,(%esp)
  800171:	e8 67 07 00 00       	call   8008dd <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800176:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80017c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800180:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800187:	ff 15 1c 40 80 00    	call   *0x80401c
  80018d:	85 c0                	test   %eax,%eax
  80018f:	79 20                	jns    8001b1 <umain+0x111>
		panic("file_stat: %e", r);
  800191:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800195:	c7 44 24 08 0a 2e 80 	movl   $0x802e0a,0x8(%esp)
  80019c:	00 
  80019d:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  8001a4:	00 
  8001a5:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  8001ac:	e8 33 06 00 00       	call   8007e4 <_panic>
	if (strlen(msg) != st.st_size)
  8001b1:	a1 00 40 80 00       	mov    0x804000,%eax
  8001b6:	89 04 24             	mov    %eax,(%esp)
  8001b9:	e8 12 0d 00 00       	call   800ed0 <strlen>
  8001be:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8001c1:	74 34                	je     8001f7 <umain+0x157>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8001c3:	a1 00 40 80 00       	mov    0x804000,%eax
  8001c8:	89 04 24             	mov    %eax,(%esp)
  8001cb:	e8 00 0d 00 00       	call   800ed0 <strlen>
  8001d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001db:	c7 44 24 08 b4 2f 80 	movl   $0x802fb4,0x8(%esp)
  8001e2:	00 
  8001e3:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  8001ea:	00 
  8001eb:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  8001f2:	e8 ed 05 00 00       	call   8007e4 <_panic>
	cprintf("file_stat is good\n");
  8001f7:	c7 04 24 18 2e 80 00 	movl   $0x802e18,(%esp)
  8001fe:	e8 da 06 00 00       	call   8008dd <cprintf>

	memset(buf, 0, sizeof buf);
  800203:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80020a:	00 
  80020b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800212:	00 
  800213:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800219:	89 1c 24             	mov    %ebx,(%esp)
  80021c:	e8 36 0e 00 00       	call   801057 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800221:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800228:	00 
  800229:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80022d:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800234:	ff 15 10 40 80 00    	call   *0x804010
  80023a:	85 c0                	test   %eax,%eax
  80023c:	79 20                	jns    80025e <umain+0x1be>
		panic("file_read: %e", r);
  80023e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800242:	c7 44 24 08 2b 2e 80 	movl   $0x802e2b,0x8(%esp)
  800249:	00 
  80024a:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  800251:	00 
  800252:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  800259:	e8 86 05 00 00       	call   8007e4 <_panic>
	if (strcmp(buf, msg) != 0)
  80025e:	a1 00 40 80 00       	mov    0x804000,%eax
  800263:	89 44 24 04          	mov    %eax,0x4(%esp)
  800267:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  80026d:	89 04 24             	mov    %eax,(%esp)
  800270:	e8 47 0d 00 00       	call   800fbc <strcmp>
  800275:	85 c0                	test   %eax,%eax
  800277:	74 1c                	je     800295 <umain+0x1f5>
		panic("file_read returned wrong data");
  800279:	c7 44 24 08 39 2e 80 	movl   $0x802e39,0x8(%esp)
  800280:	00 
  800281:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  800288:	00 
  800289:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  800290:	e8 4f 05 00 00       	call   8007e4 <_panic>
	cprintf("file_read is good\n");
  800295:	c7 04 24 57 2e 80 00 	movl   $0x802e57,(%esp)
  80029c:	e8 3c 06 00 00       	call   8008dd <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8002a1:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8002a8:	ff 15 18 40 80 00    	call   *0x804018
  8002ae:	85 c0                	test   %eax,%eax
  8002b0:	79 20                	jns    8002d2 <umain+0x232>
		panic("file_close: %e", r);
  8002b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002b6:	c7 44 24 08 6a 2e 80 	movl   $0x802e6a,0x8(%esp)
  8002bd:	00 
  8002be:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8002c5:	00 
  8002c6:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  8002cd:	e8 12 05 00 00       	call   8007e4 <_panic>
	cprintf("file_close is good\n");
  8002d2:	c7 04 24 79 2e 80 00 	movl   $0x802e79,(%esp)
  8002d9:	e8 ff 05 00 00       	call   8008dd <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  8002de:	a1 00 c0 cc cc       	mov    0xccccc000,%eax
  8002e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002e6:	a1 04 c0 cc cc       	mov    0xccccc004,%eax
  8002eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002ee:	a1 08 c0 cc cc       	mov    0xccccc008,%eax
  8002f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f6:	a1 0c c0 cc cc       	mov    0xccccc00c,%eax
  8002fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_page_unmap(0, FVA);
  8002fe:	c7 44 24 04 00 c0 cc 	movl   $0xccccc000,0x4(%esp)
  800305:	cc 
  800306:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80030d:	e8 b8 10 00 00       	call   8013ca <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  800312:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800319:	00 
  80031a:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800320:	89 44 24 04          	mov    %eax,0x4(%esp)
  800324:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800327:	89 04 24             	mov    %eax,(%esp)
  80032a:	ff 15 10 40 80 00    	call   *0x804010
  800330:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800333:	74 20                	je     800355 <umain+0x2b5>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  800335:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800339:	c7 44 24 08 dc 2f 80 	movl   $0x802fdc,0x8(%esp)
  800340:	00 
  800341:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  800348:	00 
  800349:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  800350:	e8 8f 04 00 00       	call   8007e4 <_panic>
	cprintf("stale fileid is good\n");
  800355:	c7 04 24 8d 2e 80 00 	movl   $0x802e8d,(%esp)
  80035c:	e8 7c 05 00 00       	call   8008dd <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800361:	ba 02 01 00 00       	mov    $0x102,%edx
  800366:	b8 a3 2e 80 00       	mov    $0x802ea3,%eax
  80036b:	e8 c3 fc ff ff       	call   800033 <xopen>
  800370:	85 c0                	test   %eax,%eax
  800372:	79 20                	jns    800394 <umain+0x2f4>
		panic("serve_open /new-file: %e", r);
  800374:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800378:	c7 44 24 08 ad 2e 80 	movl   $0x802ead,0x8(%esp)
  80037f:	00 
  800380:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  800387:	00 
  800388:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  80038f:	e8 50 04 00 00       	call   8007e4 <_panic>

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800394:	8b 1d 14 40 80 00    	mov    0x804014,%ebx
  80039a:	a1 00 40 80 00       	mov    0x804000,%eax
  80039f:	89 04 24             	mov    %eax,(%esp)
  8003a2:	e8 29 0b 00 00       	call   800ed0 <strlen>
  8003a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ab:	a1 00 40 80 00       	mov    0x804000,%eax
  8003b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b4:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8003bb:	ff d3                	call   *%ebx
  8003bd:	89 c3                	mov    %eax,%ebx
  8003bf:	a1 00 40 80 00       	mov    0x804000,%eax
  8003c4:	89 04 24             	mov    %eax,(%esp)
  8003c7:	e8 04 0b 00 00       	call   800ed0 <strlen>
  8003cc:	39 c3                	cmp    %eax,%ebx
  8003ce:	74 20                	je     8003f0 <umain+0x350>
		panic("file_write: %e", r);
  8003d0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003d4:	c7 44 24 08 c6 2e 80 	movl   $0x802ec6,0x8(%esp)
  8003db:	00 
  8003dc:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
  8003e3:	00 
  8003e4:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  8003eb:	e8 f4 03 00 00       	call   8007e4 <_panic>
	cprintf("file_write is good\n");
  8003f0:	c7 04 24 d5 2e 80 00 	movl   $0x802ed5,(%esp)
  8003f7:	e8 e1 04 00 00       	call   8008dd <cprintf>

	FVA->fd_offset = 0;
  8003fc:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  800403:	00 00 00 
	memset(buf, 0, sizeof buf);
  800406:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80040d:	00 
  80040e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800415:	00 
  800416:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  80041c:	89 1c 24             	mov    %ebx,(%esp)
  80041f:	e8 33 0c 00 00       	call   801057 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800424:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80042b:	00 
  80042c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800430:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800437:	ff 15 10 40 80 00    	call   *0x804010
  80043d:	89 c3                	mov    %eax,%ebx
  80043f:	85 c0                	test   %eax,%eax
  800441:	79 20                	jns    800463 <umain+0x3c3>
		panic("file_read after file_write: %e", r);
  800443:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800447:	c7 44 24 08 14 30 80 	movl   $0x803014,0x8(%esp)
  80044e:	00 
  80044f:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
  800456:	00 
  800457:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  80045e:	e8 81 03 00 00       	call   8007e4 <_panic>
	if (r != strlen(msg))
  800463:	a1 00 40 80 00       	mov    0x804000,%eax
  800468:	89 04 24             	mov    %eax,(%esp)
  80046b:	e8 60 0a 00 00       	call   800ed0 <strlen>
  800470:	39 d8                	cmp    %ebx,%eax
  800472:	74 20                	je     800494 <umain+0x3f4>
		panic("file_read after file_write returned wrong length: %d", r);
  800474:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800478:	c7 44 24 08 34 30 80 	movl   $0x803034,0x8(%esp)
  80047f:	00 
  800480:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  800487:	00 
  800488:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  80048f:	e8 50 03 00 00       	call   8007e4 <_panic>
	if (strcmp(buf, msg) != 0)
  800494:	a1 00 40 80 00       	mov    0x804000,%eax
  800499:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049d:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8004a3:	89 04 24             	mov    %eax,(%esp)
  8004a6:	e8 11 0b 00 00       	call   800fbc <strcmp>
  8004ab:	85 c0                	test   %eax,%eax
  8004ad:	74 1c                	je     8004cb <umain+0x42b>
		panic("file_read after file_write returned wrong data");
  8004af:	c7 44 24 08 6c 30 80 	movl   $0x80306c,0x8(%esp)
  8004b6:	00 
  8004b7:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  8004be:	00 
  8004bf:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  8004c6:	e8 19 03 00 00       	call   8007e4 <_panic>
	cprintf("file_read after file_write is good\n");
  8004cb:	c7 04 24 9c 30 80 00 	movl   $0x80309c,(%esp)
  8004d2:	e8 06 04 00 00       	call   8008dd <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8004d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004de:	00 
  8004df:	c7 04 24 a0 2d 80 00 	movl   $0x802da0,(%esp)
  8004e6:	e8 f4 1a 00 00       	call   801fdf <open>
  8004eb:	85 c0                	test   %eax,%eax
  8004ed:	79 25                	jns    800514 <umain+0x474>
  8004ef:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8004f2:	74 3c                	je     800530 <umain+0x490>
		panic("open /not-found: %e", r);
  8004f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004f8:	c7 44 24 08 b1 2d 80 	movl   $0x802db1,0x8(%esp)
  8004ff:	00 
  800500:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  800507:	00 
  800508:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  80050f:	e8 d0 02 00 00       	call   8007e4 <_panic>
	else if (r >= 0)
		panic("open /not-found succeeded!");
  800514:	c7 44 24 08 e9 2e 80 	movl   $0x802ee9,0x8(%esp)
  80051b:	00 
  80051c:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  800523:	00 
  800524:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  80052b:	e8 b4 02 00 00       	call   8007e4 <_panic>

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  800530:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800537:	00 
  800538:	c7 04 24 d5 2d 80 00 	movl   $0x802dd5,(%esp)
  80053f:	e8 9b 1a 00 00       	call   801fdf <open>
  800544:	85 c0                	test   %eax,%eax
  800546:	79 20                	jns    800568 <umain+0x4c8>
		panic("open /newmotd: %e", r);
  800548:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80054c:	c7 44 24 08 e4 2d 80 	movl   $0x802de4,0x8(%esp)
  800553:	00 
  800554:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  80055b:	00 
  80055c:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  800563:	e8 7c 02 00 00       	call   8007e4 <_panic>
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800568:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  80056b:	83 b8 00 00 00 d0 66 	cmpl   $0x66,-0x30000000(%eax)
  800572:	75 12                	jne    800586 <umain+0x4e6>
  800574:	83 b8 04 00 00 d0 00 	cmpl   $0x0,-0x2ffffffc(%eax)
  80057b:	75 09                	jne    800586 <umain+0x4e6>
  80057d:	83 b8 08 00 00 d0 00 	cmpl   $0x0,-0x2ffffff8(%eax)
  800584:	74 1c                	je     8005a2 <umain+0x502>
		panic("open did not fill struct Fd correctly\n");
  800586:	c7 44 24 08 c0 30 80 	movl   $0x8030c0,0x8(%esp)
  80058d:	00 
  80058e:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  800595:	00 
  800596:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  80059d:	e8 42 02 00 00       	call   8007e4 <_panic>
	cprintf("open is good\n");
  8005a2:	c7 04 24 fc 2d 80 00 	movl   $0x802dfc,(%esp)
  8005a9:	e8 2f 03 00 00       	call   8008dd <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  8005ae:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  8005b5:	00 
  8005b6:	c7 04 24 04 2f 80 00 	movl   $0x802f04,(%esp)
  8005bd:	e8 1d 1a 00 00       	call   801fdf <open>
  8005c2:	89 c6                	mov    %eax,%esi
  8005c4:	85 c0                	test   %eax,%eax
  8005c6:	79 20                	jns    8005e8 <umain+0x548>
		panic("creat /big: %e", f);
  8005c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005cc:	c7 44 24 08 09 2f 80 	movl   $0x802f09,0x8(%esp)
  8005d3:	00 
  8005d4:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
  8005db:	00 
  8005dc:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  8005e3:	e8 fc 01 00 00       	call   8007e4 <_panic>
	memset(buf, 0, sizeof(buf));
  8005e8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8005ef:	00 
  8005f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8005f7:	00 
  8005f8:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8005fe:	89 04 24             	mov    %eax,(%esp)
  800601:	e8 51 0a 00 00       	call   801057 <memset>
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800606:	bb 00 00 00 00       	mov    $0x0,%ebx
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
  80060b:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
  800611:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  800617:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80061e:	00 
  80061f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800623:	89 34 24             	mov    %esi,(%esp)
  800626:	e8 5c 15 00 00       	call   801b87 <write>
  80062b:	85 c0                	test   %eax,%eax
  80062d:	79 24                	jns    800653 <umain+0x5b3>
			panic("write /big@%d: %e", i, r);
  80062f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800633:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800637:	c7 44 24 08 18 2f 80 	movl   $0x802f18,0x8(%esp)
  80063e:	00 
  80063f:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  800646:	00 
  800647:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  80064e:	e8 91 01 00 00       	call   8007e4 <_panic>
  800653:	8d 83 00 02 00 00    	lea    0x200(%ebx),%eax
  800659:	89 c3                	mov    %eax,%ebx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  80065b:	3d 00 e0 01 00       	cmp    $0x1e000,%eax
  800660:	75 af                	jne    800611 <umain+0x571>
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800662:	89 34 24             	mov    %esi,(%esp)
  800665:	e8 dd 12 00 00       	call   801947 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  80066a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800671:	00 
  800672:	c7 04 24 04 2f 80 00 	movl   $0x802f04,(%esp)
  800679:	e8 61 19 00 00       	call   801fdf <open>
  80067e:	89 c6                	mov    %eax,%esi
  800680:	85 c0                	test   %eax,%eax
  800682:	79 20                	jns    8006a4 <umain+0x604>
		panic("open /big: %e", f);
  800684:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800688:	c7 44 24 08 2a 2f 80 	movl   $0x802f2a,0x8(%esp)
  80068f:	00 
  800690:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  800697:	00 
  800698:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  80069f:	e8 40 01 00 00       	call   8007e4 <_panic>
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
  8006a4:	bb 00 00 00 00       	mov    $0x0,%ebx
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  8006a9:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
  8006af:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  8006b5:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8006bc:	00 
  8006bd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c1:	89 34 24             	mov    %esi,(%esp)
  8006c4:	e8 73 14 00 00       	call   801b3c <readn>
  8006c9:	85 c0                	test   %eax,%eax
  8006cb:	79 24                	jns    8006f1 <umain+0x651>
			panic("read /big@%d: %e", i, r);
  8006cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8006d5:	c7 44 24 08 38 2f 80 	movl   $0x802f38,0x8(%esp)
  8006dc:	00 
  8006dd:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  8006e4:	00 
  8006e5:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  8006ec:	e8 f3 00 00 00       	call   8007e4 <_panic>
		if (r != sizeof(buf))
  8006f1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8006f6:	74 2c                	je     800724 <umain+0x684>
			panic("read /big from %d returned %d < %d bytes",
  8006f8:	c7 44 24 14 00 02 00 	movl   $0x200,0x14(%esp)
  8006ff:	00 
  800700:	89 44 24 10          	mov    %eax,0x10(%esp)
  800704:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800708:	c7 44 24 08 e8 30 80 	movl   $0x8030e8,0x8(%esp)
  80070f:	00 
  800710:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
  800717:	00 
  800718:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  80071f:	e8 c0 00 00 00       	call   8007e4 <_panic>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800724:	8b 85 4c fd ff ff    	mov    -0x2b4(%ebp),%eax
  80072a:	39 d8                	cmp    %ebx,%eax
  80072c:	74 24                	je     800752 <umain+0x6b2>
			panic("read /big from %d returned bad data %d",
  80072e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800732:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800736:	c7 44 24 08 14 31 80 	movl   $0x803114,0x8(%esp)
  80073d:	00 
  80073e:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  800745:	00 
  800746:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  80074d:	e8 92 00 00 00       	call   8007e4 <_panic>
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800752:	8d 98 00 02 00 00    	lea    0x200(%eax),%ebx
  800758:	81 fb ff df 01 00    	cmp    $0x1dfff,%ebx
  80075e:	0f 8e 4b ff ff ff    	jle    8006af <umain+0x60f>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800764:	89 34 24             	mov    %esi,(%esp)
  800767:	e8 db 11 00 00       	call   801947 <close>
	cprintf("large file is good\n");
  80076c:	c7 04 24 49 2f 80 00 	movl   $0x802f49,(%esp)
  800773:	e8 65 01 00 00       	call   8008dd <cprintf>
}
  800778:	81 c4 cc 02 00 00    	add    $0x2cc,%esp
  80077e:	5b                   	pop    %ebx
  80077f:	5e                   	pop    %esi
  800780:	5f                   	pop    %edi
  800781:	5d                   	pop    %ebp
  800782:	c3                   	ret    

00800783 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	56                   	push   %esi
  800787:	53                   	push   %ebx
  800788:	83 ec 10             	sub    $0x10,%esp
  80078b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80078e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800791:	e8 4f 0b 00 00       	call   8012e5 <sys_getenvid>
  800796:	25 ff 03 00 00       	and    $0x3ff,%eax
  80079b:	c1 e0 07             	shl    $0x7,%eax
  80079e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007a3:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007a8:	85 db                	test   %ebx,%ebx
  8007aa:	7e 07                	jle    8007b3 <libmain+0x30>
		binaryname = argv[0];
  8007ac:	8b 06                	mov    (%esi),%eax
  8007ae:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  8007b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007b7:	89 1c 24             	mov    %ebx,(%esp)
  8007ba:	e8 e1 f8 ff ff       	call   8000a0 <umain>

	// exit gracefully
	exit();
  8007bf:	e8 07 00 00 00       	call   8007cb <exit>
}
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	5b                   	pop    %ebx
  8007c8:	5e                   	pop    %esi
  8007c9:	5d                   	pop    %ebp
  8007ca:	c3                   	ret    

008007cb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8007d1:	e8 a4 11 00 00       	call   80197a <close_all>
	sys_env_destroy(0);
  8007d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007dd:	e8 b1 0a 00 00       	call   801293 <sys_env_destroy>
}
  8007e2:	c9                   	leave  
  8007e3:	c3                   	ret    

008007e4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8007e4:	55                   	push   %ebp
  8007e5:	89 e5                	mov    %esp,%ebp
  8007e7:	56                   	push   %esi
  8007e8:	53                   	push   %ebx
  8007e9:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8007ec:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8007ef:	8b 35 04 40 80 00    	mov    0x804004,%esi
  8007f5:	e8 eb 0a 00 00       	call   8012e5 <sys_getenvid>
  8007fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007fd:	89 54 24 10          	mov    %edx,0x10(%esp)
  800801:	8b 55 08             	mov    0x8(%ebp),%edx
  800804:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800808:	89 74 24 08          	mov    %esi,0x8(%esp)
  80080c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800810:	c7 04 24 6c 31 80 00 	movl   $0x80316c,(%esp)
  800817:	e8 c1 00 00 00       	call   8008dd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80081c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800820:	8b 45 10             	mov    0x10(%ebp),%eax
  800823:	89 04 24             	mov    %eax,(%esp)
  800826:	e8 51 00 00 00       	call   80087c <vcprintf>
	cprintf("\n");
  80082b:	c7 04 24 04 36 80 00 	movl   $0x803604,(%esp)
  800832:	e8 a6 00 00 00       	call   8008dd <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800837:	cc                   	int3   
  800838:	eb fd                	jmp    800837 <_panic+0x53>

0080083a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	53                   	push   %ebx
  80083e:	83 ec 14             	sub    $0x14,%esp
  800841:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800844:	8b 13                	mov    (%ebx),%edx
  800846:	8d 42 01             	lea    0x1(%edx),%eax
  800849:	89 03                	mov    %eax,(%ebx)
  80084b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800852:	3d ff 00 00 00       	cmp    $0xff,%eax
  800857:	75 19                	jne    800872 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800859:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800860:	00 
  800861:	8d 43 08             	lea    0x8(%ebx),%eax
  800864:	89 04 24             	mov    %eax,(%esp)
  800867:	e8 ea 09 00 00       	call   801256 <sys_cputs>
		b->idx = 0;
  80086c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800872:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800876:	83 c4 14             	add    $0x14,%esp
  800879:	5b                   	pop    %ebx
  80087a:	5d                   	pop    %ebp
  80087b:	c3                   	ret    

0080087c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800885:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80088c:	00 00 00 
	b.cnt = 0;
  80088f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800896:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b1:	c7 04 24 3a 08 80 00 	movl   $0x80083a,(%esp)
  8008b8:	e8 b1 01 00 00       	call   800a6e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8008bd:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8008c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008c7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8008cd:	89 04 24             	mov    %eax,(%esp)
  8008d0:	e8 81 09 00 00       	call   801256 <sys_cputs>

	return b.cnt;
}
  8008d5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    

008008dd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8008e3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8008e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	89 04 24             	mov    %eax,(%esp)
  8008f0:	e8 87 ff ff ff       	call   80087c <vcprintf>
	va_end(ap);

	return cnt;
}
  8008f5:	c9                   	leave  
  8008f6:	c3                   	ret    
  8008f7:	66 90                	xchg   %ax,%ax
  8008f9:	66 90                	xchg   %ax,%ax
  8008fb:	66 90                	xchg   %ax,%ax
  8008fd:	66 90                	xchg   %ax,%ax
  8008ff:	90                   	nop

00800900 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	57                   	push   %edi
  800904:	56                   	push   %esi
  800905:	53                   	push   %ebx
  800906:	83 ec 3c             	sub    $0x3c,%esp
  800909:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80090c:	89 d7                	mov    %edx,%edi
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800914:	8b 45 0c             	mov    0xc(%ebp),%eax
  800917:	89 c3                	mov    %eax,%ebx
  800919:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80091c:	8b 45 10             	mov    0x10(%ebp),%eax
  80091f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800922:	b9 00 00 00 00       	mov    $0x0,%ecx
  800927:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80092a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80092d:	39 d9                	cmp    %ebx,%ecx
  80092f:	72 05                	jb     800936 <printnum+0x36>
  800931:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800934:	77 69                	ja     80099f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800936:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800939:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80093d:	83 ee 01             	sub    $0x1,%esi
  800940:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800944:	89 44 24 08          	mov    %eax,0x8(%esp)
  800948:	8b 44 24 08          	mov    0x8(%esp),%eax
  80094c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800950:	89 c3                	mov    %eax,%ebx
  800952:	89 d6                	mov    %edx,%esi
  800954:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800957:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80095a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80095e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800962:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800965:	89 04 24             	mov    %eax,(%esp)
  800968:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80096b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80096f:	e8 8c 21 00 00       	call   802b00 <__udivdi3>
  800974:	89 d9                	mov    %ebx,%ecx
  800976:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80097a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80097e:	89 04 24             	mov    %eax,(%esp)
  800981:	89 54 24 04          	mov    %edx,0x4(%esp)
  800985:	89 fa                	mov    %edi,%edx
  800987:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80098a:	e8 71 ff ff ff       	call   800900 <printnum>
  80098f:	eb 1b                	jmp    8009ac <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800991:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800995:	8b 45 18             	mov    0x18(%ebp),%eax
  800998:	89 04 24             	mov    %eax,(%esp)
  80099b:	ff d3                	call   *%ebx
  80099d:	eb 03                	jmp    8009a2 <printnum+0xa2>
  80099f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009a2:	83 ee 01             	sub    $0x1,%esi
  8009a5:	85 f6                	test   %esi,%esi
  8009a7:	7f e8                	jg     800991 <printnum+0x91>
  8009a9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009ac:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009b0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8009b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8009ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009be:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c5:	89 04 24             	mov    %eax,(%esp)
  8009c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009cf:	e8 5c 22 00 00       	call   802c30 <__umoddi3>
  8009d4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009d8:	0f be 80 8f 31 80 00 	movsbl 0x80318f(%eax),%eax
  8009df:	89 04 24             	mov    %eax,(%esp)
  8009e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009e5:	ff d0                	call   *%eax
}
  8009e7:	83 c4 3c             	add    $0x3c,%esp
  8009ea:	5b                   	pop    %ebx
  8009eb:	5e                   	pop    %esi
  8009ec:	5f                   	pop    %edi
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009f2:	83 fa 01             	cmp    $0x1,%edx
  8009f5:	7e 0e                	jle    800a05 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8009f7:	8b 10                	mov    (%eax),%edx
  8009f9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8009fc:	89 08                	mov    %ecx,(%eax)
  8009fe:	8b 02                	mov    (%edx),%eax
  800a00:	8b 52 04             	mov    0x4(%edx),%edx
  800a03:	eb 22                	jmp    800a27 <getuint+0x38>
	else if (lflag)
  800a05:	85 d2                	test   %edx,%edx
  800a07:	74 10                	je     800a19 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800a09:	8b 10                	mov    (%eax),%edx
  800a0b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800a0e:	89 08                	mov    %ecx,(%eax)
  800a10:	8b 02                	mov    (%edx),%eax
  800a12:	ba 00 00 00 00       	mov    $0x0,%edx
  800a17:	eb 0e                	jmp    800a27 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800a19:	8b 10                	mov    (%eax),%edx
  800a1b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800a1e:	89 08                	mov    %ecx,(%eax)
  800a20:	8b 02                	mov    (%edx),%eax
  800a22:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a27:	5d                   	pop    %ebp
  800a28:	c3                   	ret    

00800a29 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800a2f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800a33:	8b 10                	mov    (%eax),%edx
  800a35:	3b 50 04             	cmp    0x4(%eax),%edx
  800a38:	73 0a                	jae    800a44 <sprintputch+0x1b>
		*b->buf++ = ch;
  800a3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a3d:	89 08                	mov    %ecx,(%eax)
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	88 02                	mov    %al,(%edx)
}
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a4c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800a4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a53:	8b 45 10             	mov    0x10(%ebp),%eax
  800a56:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	89 04 24             	mov    %eax,(%esp)
  800a67:	e8 02 00 00 00       	call   800a6e <vprintfmt>
	va_end(ap);
}
  800a6c:	c9                   	leave  
  800a6d:	c3                   	ret    

00800a6e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	57                   	push   %edi
  800a72:	56                   	push   %esi
  800a73:	53                   	push   %ebx
  800a74:	83 ec 3c             	sub    $0x3c,%esp
  800a77:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800a7d:	eb 14                	jmp    800a93 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800a7f:	85 c0                	test   %eax,%eax
  800a81:	0f 84 b3 03 00 00    	je     800e3a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800a87:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a8b:	89 04 24             	mov    %eax,(%esp)
  800a8e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a91:	89 f3                	mov    %esi,%ebx
  800a93:	8d 73 01             	lea    0x1(%ebx),%esi
  800a96:	0f b6 03             	movzbl (%ebx),%eax
  800a99:	83 f8 25             	cmp    $0x25,%eax
  800a9c:	75 e1                	jne    800a7f <vprintfmt+0x11>
  800a9e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800aa2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800aa9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800ab0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800ab7:	ba 00 00 00 00       	mov    $0x0,%edx
  800abc:	eb 1d                	jmp    800adb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800abe:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800ac0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800ac4:	eb 15                	jmp    800adb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ac6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ac8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800acc:	eb 0d                	jmp    800adb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800ace:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ad1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800ad4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800adb:	8d 5e 01             	lea    0x1(%esi),%ebx
  800ade:	0f b6 0e             	movzbl (%esi),%ecx
  800ae1:	0f b6 c1             	movzbl %cl,%eax
  800ae4:	83 e9 23             	sub    $0x23,%ecx
  800ae7:	80 f9 55             	cmp    $0x55,%cl
  800aea:	0f 87 2a 03 00 00    	ja     800e1a <vprintfmt+0x3ac>
  800af0:	0f b6 c9             	movzbl %cl,%ecx
  800af3:	ff 24 8d e0 32 80 00 	jmp    *0x8032e0(,%ecx,4)
  800afa:	89 de                	mov    %ebx,%esi
  800afc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800b01:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800b04:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800b08:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800b0b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800b0e:	83 fb 09             	cmp    $0x9,%ebx
  800b11:	77 36                	ja     800b49 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b13:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800b16:	eb e9                	jmp    800b01 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b18:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1b:	8d 48 04             	lea    0x4(%eax),%ecx
  800b1e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b26:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800b28:	eb 22                	jmp    800b4c <vprintfmt+0xde>
  800b2a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800b2d:	85 c9                	test   %ecx,%ecx
  800b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b34:	0f 49 c1             	cmovns %ecx,%eax
  800b37:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b3a:	89 de                	mov    %ebx,%esi
  800b3c:	eb 9d                	jmp    800adb <vprintfmt+0x6d>
  800b3e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800b40:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800b47:	eb 92                	jmp    800adb <vprintfmt+0x6d>
  800b49:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  800b4c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b50:	79 89                	jns    800adb <vprintfmt+0x6d>
  800b52:	e9 77 ff ff ff       	jmp    800ace <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b57:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b5a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800b5c:	e9 7a ff ff ff       	jmp    800adb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b61:	8b 45 14             	mov    0x14(%ebp),%eax
  800b64:	8d 50 04             	lea    0x4(%eax),%edx
  800b67:	89 55 14             	mov    %edx,0x14(%ebp)
  800b6a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	89 04 24             	mov    %eax,(%esp)
  800b73:	ff 55 08             	call   *0x8(%ebp)
			break;
  800b76:	e9 18 ff ff ff       	jmp    800a93 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7e:	8d 50 04             	lea    0x4(%eax),%edx
  800b81:	89 55 14             	mov    %edx,0x14(%ebp)
  800b84:	8b 00                	mov    (%eax),%eax
  800b86:	99                   	cltd   
  800b87:	31 d0                	xor    %edx,%eax
  800b89:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800b8b:	83 f8 11             	cmp    $0x11,%eax
  800b8e:	7f 0b                	jg     800b9b <vprintfmt+0x12d>
  800b90:	8b 14 85 40 34 80 00 	mov    0x803440(,%eax,4),%edx
  800b97:	85 d2                	test   %edx,%edx
  800b99:	75 20                	jne    800bbb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  800b9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b9f:	c7 44 24 08 a7 31 80 	movl   $0x8031a7,0x8(%esp)
  800ba6:	00 
  800ba7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
  800bae:	89 04 24             	mov    %eax,(%esp)
  800bb1:	e8 90 fe ff ff       	call   800a46 <printfmt>
  800bb6:	e9 d8 fe ff ff       	jmp    800a93 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800bbb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800bbf:	c7 44 24 08 99 35 80 	movl   $0x803599,0x8(%esp)
  800bc6:	00 
  800bc7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	89 04 24             	mov    %eax,(%esp)
  800bd1:	e8 70 fe ff ff       	call   800a46 <printfmt>
  800bd6:	e9 b8 fe ff ff       	jmp    800a93 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bdb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800bde:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800be1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800be4:	8b 45 14             	mov    0x14(%ebp),%eax
  800be7:	8d 50 04             	lea    0x4(%eax),%edx
  800bea:	89 55 14             	mov    %edx,0x14(%ebp)
  800bed:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800bef:	85 f6                	test   %esi,%esi
  800bf1:	b8 a0 31 80 00       	mov    $0x8031a0,%eax
  800bf6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800bf9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800bfd:	0f 84 97 00 00 00    	je     800c9a <vprintfmt+0x22c>
  800c03:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800c07:	0f 8e 9b 00 00 00    	jle    800ca8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  800c0d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800c11:	89 34 24             	mov    %esi,(%esp)
  800c14:	e8 cf 02 00 00       	call   800ee8 <strnlen>
  800c19:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800c1c:	29 c2                	sub    %eax,%edx
  800c1e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800c21:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800c25:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800c28:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800c2b:	8b 75 08             	mov    0x8(%ebp),%esi
  800c2e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c31:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c33:	eb 0f                	jmp    800c44 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800c35:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800c3c:	89 04 24             	mov    %eax,(%esp)
  800c3f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c41:	83 eb 01             	sub    $0x1,%ebx
  800c44:	85 db                	test   %ebx,%ebx
  800c46:	7f ed                	jg     800c35 <vprintfmt+0x1c7>
  800c48:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800c4b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800c4e:	85 d2                	test   %edx,%edx
  800c50:	b8 00 00 00 00       	mov    $0x0,%eax
  800c55:	0f 49 c2             	cmovns %edx,%eax
  800c58:	29 c2                	sub    %eax,%edx
  800c5a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800c5d:	89 d7                	mov    %edx,%edi
  800c5f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800c62:	eb 50                	jmp    800cb4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800c64:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c68:	74 1e                	je     800c88 <vprintfmt+0x21a>
  800c6a:	0f be d2             	movsbl %dl,%edx
  800c6d:	83 ea 20             	sub    $0x20,%edx
  800c70:	83 fa 5e             	cmp    $0x5e,%edx
  800c73:	76 13                	jbe    800c88 <vprintfmt+0x21a>
					putch('?', putdat);
  800c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c78:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c7c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800c83:	ff 55 08             	call   *0x8(%ebp)
  800c86:	eb 0d                	jmp    800c95 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800c88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c8f:	89 04 24             	mov    %eax,(%esp)
  800c92:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c95:	83 ef 01             	sub    $0x1,%edi
  800c98:	eb 1a                	jmp    800cb4 <vprintfmt+0x246>
  800c9a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800c9d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800ca0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ca3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ca6:	eb 0c                	jmp    800cb4 <vprintfmt+0x246>
  800ca8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800cab:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800cae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800cb1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800cb4:	83 c6 01             	add    $0x1,%esi
  800cb7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800cbb:	0f be c2             	movsbl %dl,%eax
  800cbe:	85 c0                	test   %eax,%eax
  800cc0:	74 27                	je     800ce9 <vprintfmt+0x27b>
  800cc2:	85 db                	test   %ebx,%ebx
  800cc4:	78 9e                	js     800c64 <vprintfmt+0x1f6>
  800cc6:	83 eb 01             	sub    $0x1,%ebx
  800cc9:	79 99                	jns    800c64 <vprintfmt+0x1f6>
  800ccb:	89 f8                	mov    %edi,%eax
  800ccd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800cd0:	8b 75 08             	mov    0x8(%ebp),%esi
  800cd3:	89 c3                	mov    %eax,%ebx
  800cd5:	eb 1a                	jmp    800cf1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800cd7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800cdb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800ce2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ce4:	83 eb 01             	sub    $0x1,%ebx
  800ce7:	eb 08                	jmp    800cf1 <vprintfmt+0x283>
  800ce9:	89 fb                	mov    %edi,%ebx
  800ceb:	8b 75 08             	mov    0x8(%ebp),%esi
  800cee:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800cf1:	85 db                	test   %ebx,%ebx
  800cf3:	7f e2                	jg     800cd7 <vprintfmt+0x269>
  800cf5:	89 75 08             	mov    %esi,0x8(%ebp)
  800cf8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cfb:	e9 93 fd ff ff       	jmp    800a93 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800d00:	83 fa 01             	cmp    $0x1,%edx
  800d03:	7e 16                	jle    800d1b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800d05:	8b 45 14             	mov    0x14(%ebp),%eax
  800d08:	8d 50 08             	lea    0x8(%eax),%edx
  800d0b:	89 55 14             	mov    %edx,0x14(%ebp)
  800d0e:	8b 50 04             	mov    0x4(%eax),%edx
  800d11:	8b 00                	mov    (%eax),%eax
  800d13:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d16:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800d19:	eb 32                	jmp    800d4d <vprintfmt+0x2df>
	else if (lflag)
  800d1b:	85 d2                	test   %edx,%edx
  800d1d:	74 18                	je     800d37 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800d1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d22:	8d 50 04             	lea    0x4(%eax),%edx
  800d25:	89 55 14             	mov    %edx,0x14(%ebp)
  800d28:	8b 30                	mov    (%eax),%esi
  800d2a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800d2d:	89 f0                	mov    %esi,%eax
  800d2f:	c1 f8 1f             	sar    $0x1f,%eax
  800d32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d35:	eb 16                	jmp    800d4d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800d37:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3a:	8d 50 04             	lea    0x4(%eax),%edx
  800d3d:	89 55 14             	mov    %edx,0x14(%ebp)
  800d40:	8b 30                	mov    (%eax),%esi
  800d42:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800d45:	89 f0                	mov    %esi,%eax
  800d47:	c1 f8 1f             	sar    $0x1f,%eax
  800d4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800d53:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800d58:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d5c:	0f 89 80 00 00 00    	jns    800de2 <vprintfmt+0x374>
				putch('-', putdat);
  800d62:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d66:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800d6d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800d70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d76:	f7 d8                	neg    %eax
  800d78:	83 d2 00             	adc    $0x0,%edx
  800d7b:	f7 da                	neg    %edx
			}
			base = 10;
  800d7d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800d82:	eb 5e                	jmp    800de2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800d84:	8d 45 14             	lea    0x14(%ebp),%eax
  800d87:	e8 63 fc ff ff       	call   8009ef <getuint>
			base = 10;
  800d8c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800d91:	eb 4f                	jmp    800de2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800d93:	8d 45 14             	lea    0x14(%ebp),%eax
  800d96:	e8 54 fc ff ff       	call   8009ef <getuint>
			base = 8;
  800d9b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800da0:	eb 40                	jmp    800de2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800da2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800da6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800dad:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800db0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800db4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800dbb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc1:	8d 50 04             	lea    0x4(%eax),%edx
  800dc4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800dc7:	8b 00                	mov    (%eax),%eax
  800dc9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800dce:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800dd3:	eb 0d                	jmp    800de2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800dd5:	8d 45 14             	lea    0x14(%ebp),%eax
  800dd8:	e8 12 fc ff ff       	call   8009ef <getuint>
			base = 16;
  800ddd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800de2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800de6:	89 74 24 10          	mov    %esi,0x10(%esp)
  800dea:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800ded:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800df1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800df5:	89 04 24             	mov    %eax,(%esp)
  800df8:	89 54 24 04          	mov    %edx,0x4(%esp)
  800dfc:	89 fa                	mov    %edi,%edx
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	e8 fa fa ff ff       	call   800900 <printnum>
			break;
  800e06:	e9 88 fc ff ff       	jmp    800a93 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e0b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e0f:	89 04 24             	mov    %eax,(%esp)
  800e12:	ff 55 08             	call   *0x8(%ebp)
			break;
  800e15:	e9 79 fc ff ff       	jmp    800a93 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e1a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e1e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800e25:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e28:	89 f3                	mov    %esi,%ebx
  800e2a:	eb 03                	jmp    800e2f <vprintfmt+0x3c1>
  800e2c:	83 eb 01             	sub    $0x1,%ebx
  800e2f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800e33:	75 f7                	jne    800e2c <vprintfmt+0x3be>
  800e35:	e9 59 fc ff ff       	jmp    800a93 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800e3a:	83 c4 3c             	add    $0x3c,%esp
  800e3d:	5b                   	pop    %ebx
  800e3e:	5e                   	pop    %esi
  800e3f:	5f                   	pop    %edi
  800e40:	5d                   	pop    %ebp
  800e41:	c3                   	ret    

00800e42 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 28             	sub    $0x28,%esp
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e51:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800e55:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800e58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	74 30                	je     800e93 <vsnprintf+0x51>
  800e63:	85 d2                	test   %edx,%edx
  800e65:	7e 2c                	jle    800e93 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e67:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e71:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e75:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e78:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e7c:	c7 04 24 29 0a 80 00 	movl   $0x800a29,(%esp)
  800e83:	e8 e6 fb ff ff       	call   800a6e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800e88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e8b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e91:	eb 05                	jmp    800e98 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800e93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800e98:	c9                   	leave  
  800e99:	c3                   	ret    

00800e9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ea0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ea3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ea7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eaa:	89 44 24 08          	mov    %eax,0x8(%esp)
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	89 04 24             	mov    %eax,(%esp)
  800ebb:	e8 82 ff ff ff       	call   800e42 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    
  800ec2:	66 90                	xchg   %ax,%ax
  800ec4:	66 90                	xchg   %ax,%ax
  800ec6:	66 90                	xchg   %ax,%ax
  800ec8:	66 90                	xchg   %ax,%ax
  800eca:	66 90                	xchg   %ax,%ax
  800ecc:	66 90                	xchg   %ax,%ax
  800ece:	66 90                	xchg   %ax,%ax

00800ed0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  800edb:	eb 03                	jmp    800ee0 <strlen+0x10>
		n++;
  800edd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ee0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ee4:	75 f7                	jne    800edd <strlen+0xd>
		n++;
	return n;
}
  800ee6:	5d                   	pop    %ebp
  800ee7:	c3                   	ret    

00800ee8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eee:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ef1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef6:	eb 03                	jmp    800efb <strnlen+0x13>
		n++;
  800ef8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800efb:	39 d0                	cmp    %edx,%eax
  800efd:	74 06                	je     800f05 <strnlen+0x1d>
  800eff:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800f03:	75 f3                	jne    800ef8 <strnlen+0x10>
		n++;
	return n;
}
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    

00800f07 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	53                   	push   %ebx
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800f11:	89 c2                	mov    %eax,%edx
  800f13:	83 c2 01             	add    $0x1,%edx
  800f16:	83 c1 01             	add    $0x1,%ecx
  800f19:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800f1d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800f20:	84 db                	test   %bl,%bl
  800f22:	75 ef                	jne    800f13 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800f24:	5b                   	pop    %ebx
  800f25:	5d                   	pop    %ebp
  800f26:	c3                   	ret    

00800f27 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	53                   	push   %ebx
  800f2b:	83 ec 08             	sub    $0x8,%esp
  800f2e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800f31:	89 1c 24             	mov    %ebx,(%esp)
  800f34:	e8 97 ff ff ff       	call   800ed0 <strlen>
	strcpy(dst + len, src);
  800f39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f3c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f40:	01 d8                	add    %ebx,%eax
  800f42:	89 04 24             	mov    %eax,(%esp)
  800f45:	e8 bd ff ff ff       	call   800f07 <strcpy>
	return dst;
}
  800f4a:	89 d8                	mov    %ebx,%eax
  800f4c:	83 c4 08             	add    $0x8,%esp
  800f4f:	5b                   	pop    %ebx
  800f50:	5d                   	pop    %ebp
  800f51:	c3                   	ret    

00800f52 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	56                   	push   %esi
  800f56:	53                   	push   %ebx
  800f57:	8b 75 08             	mov    0x8(%ebp),%esi
  800f5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5d:	89 f3                	mov    %esi,%ebx
  800f5f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f62:	89 f2                	mov    %esi,%edx
  800f64:	eb 0f                	jmp    800f75 <strncpy+0x23>
		*dst++ = *src;
  800f66:	83 c2 01             	add    $0x1,%edx
  800f69:	0f b6 01             	movzbl (%ecx),%eax
  800f6c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800f6f:	80 39 01             	cmpb   $0x1,(%ecx)
  800f72:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f75:	39 da                	cmp    %ebx,%edx
  800f77:	75 ed                	jne    800f66 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800f79:	89 f0                	mov    %esi,%eax
  800f7b:	5b                   	pop    %ebx
  800f7c:	5e                   	pop    %esi
  800f7d:	5d                   	pop    %ebp
  800f7e:	c3                   	ret    

00800f7f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	56                   	push   %esi
  800f83:	53                   	push   %ebx
  800f84:	8b 75 08             	mov    0x8(%ebp),%esi
  800f87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800f8d:	89 f0                	mov    %esi,%eax
  800f8f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800f93:	85 c9                	test   %ecx,%ecx
  800f95:	75 0b                	jne    800fa2 <strlcpy+0x23>
  800f97:	eb 1d                	jmp    800fb6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800f99:	83 c0 01             	add    $0x1,%eax
  800f9c:	83 c2 01             	add    $0x1,%edx
  800f9f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fa2:	39 d8                	cmp    %ebx,%eax
  800fa4:	74 0b                	je     800fb1 <strlcpy+0x32>
  800fa6:	0f b6 0a             	movzbl (%edx),%ecx
  800fa9:	84 c9                	test   %cl,%cl
  800fab:	75 ec                	jne    800f99 <strlcpy+0x1a>
  800fad:	89 c2                	mov    %eax,%edx
  800faf:	eb 02                	jmp    800fb3 <strlcpy+0x34>
  800fb1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800fb3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800fb6:	29 f0                	sub    %esi,%eax
}
  800fb8:	5b                   	pop    %ebx
  800fb9:	5e                   	pop    %esi
  800fba:	5d                   	pop    %ebp
  800fbb:	c3                   	ret    

00800fbc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fc2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800fc5:	eb 06                	jmp    800fcd <strcmp+0x11>
		p++, q++;
  800fc7:	83 c1 01             	add    $0x1,%ecx
  800fca:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800fcd:	0f b6 01             	movzbl (%ecx),%eax
  800fd0:	84 c0                	test   %al,%al
  800fd2:	74 04                	je     800fd8 <strcmp+0x1c>
  800fd4:	3a 02                	cmp    (%edx),%al
  800fd6:	74 ef                	je     800fc7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fd8:	0f b6 c0             	movzbl %al,%eax
  800fdb:	0f b6 12             	movzbl (%edx),%edx
  800fde:	29 d0                	sub    %edx,%eax
}
  800fe0:	5d                   	pop    %ebp
  800fe1:	c3                   	ret    

00800fe2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800fe2:	55                   	push   %ebp
  800fe3:	89 e5                	mov    %esp,%ebp
  800fe5:	53                   	push   %ebx
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fec:	89 c3                	mov    %eax,%ebx
  800fee:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ff1:	eb 06                	jmp    800ff9 <strncmp+0x17>
		n--, p++, q++;
  800ff3:	83 c0 01             	add    $0x1,%eax
  800ff6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ff9:	39 d8                	cmp    %ebx,%eax
  800ffb:	74 15                	je     801012 <strncmp+0x30>
  800ffd:	0f b6 08             	movzbl (%eax),%ecx
  801000:	84 c9                	test   %cl,%cl
  801002:	74 04                	je     801008 <strncmp+0x26>
  801004:	3a 0a                	cmp    (%edx),%cl
  801006:	74 eb                	je     800ff3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801008:	0f b6 00             	movzbl (%eax),%eax
  80100b:	0f b6 12             	movzbl (%edx),%edx
  80100e:	29 d0                	sub    %edx,%eax
  801010:	eb 05                	jmp    801017 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801012:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801017:	5b                   	pop    %ebx
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    

0080101a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801024:	eb 07                	jmp    80102d <strchr+0x13>
		if (*s == c)
  801026:	38 ca                	cmp    %cl,%dl
  801028:	74 0f                	je     801039 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80102a:	83 c0 01             	add    $0x1,%eax
  80102d:	0f b6 10             	movzbl (%eax),%edx
  801030:	84 d2                	test   %dl,%dl
  801032:	75 f2                	jne    801026 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801034:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801039:	5d                   	pop    %ebp
  80103a:	c3                   	ret    

0080103b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801045:	eb 07                	jmp    80104e <strfind+0x13>
		if (*s == c)
  801047:	38 ca                	cmp    %cl,%dl
  801049:	74 0a                	je     801055 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80104b:	83 c0 01             	add    $0x1,%eax
  80104e:	0f b6 10             	movzbl (%eax),%edx
  801051:	84 d2                	test   %dl,%dl
  801053:	75 f2                	jne    801047 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  801055:	5d                   	pop    %ebp
  801056:	c3                   	ret    

00801057 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	57                   	push   %edi
  80105b:	56                   	push   %esi
  80105c:	53                   	push   %ebx
  80105d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801060:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801063:	85 c9                	test   %ecx,%ecx
  801065:	74 36                	je     80109d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801067:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80106d:	75 28                	jne    801097 <memset+0x40>
  80106f:	f6 c1 03             	test   $0x3,%cl
  801072:	75 23                	jne    801097 <memset+0x40>
		c &= 0xFF;
  801074:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801078:	89 d3                	mov    %edx,%ebx
  80107a:	c1 e3 08             	shl    $0x8,%ebx
  80107d:	89 d6                	mov    %edx,%esi
  80107f:	c1 e6 18             	shl    $0x18,%esi
  801082:	89 d0                	mov    %edx,%eax
  801084:	c1 e0 10             	shl    $0x10,%eax
  801087:	09 f0                	or     %esi,%eax
  801089:	09 c2                	or     %eax,%edx
  80108b:	89 d0                	mov    %edx,%eax
  80108d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80108f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801092:	fc                   	cld    
  801093:	f3 ab                	rep stos %eax,%es:(%edi)
  801095:	eb 06                	jmp    80109d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109a:	fc                   	cld    
  80109b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80109d:	89 f8                	mov    %edi,%eax
  80109f:	5b                   	pop    %ebx
  8010a0:	5e                   	pop    %esi
  8010a1:	5f                   	pop    %edi
  8010a2:	5d                   	pop    %ebp
  8010a3:	c3                   	ret    

008010a4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
  8010a7:	57                   	push   %edi
  8010a8:	56                   	push   %esi
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010af:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010b2:	39 c6                	cmp    %eax,%esi
  8010b4:	73 35                	jae    8010eb <memmove+0x47>
  8010b6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8010b9:	39 d0                	cmp    %edx,%eax
  8010bb:	73 2e                	jae    8010eb <memmove+0x47>
		s += n;
		d += n;
  8010bd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8010c0:	89 d6                	mov    %edx,%esi
  8010c2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010c4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8010ca:	75 13                	jne    8010df <memmove+0x3b>
  8010cc:	f6 c1 03             	test   $0x3,%cl
  8010cf:	75 0e                	jne    8010df <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8010d1:	83 ef 04             	sub    $0x4,%edi
  8010d4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8010d7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8010da:	fd                   	std    
  8010db:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8010dd:	eb 09                	jmp    8010e8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8010df:	83 ef 01             	sub    $0x1,%edi
  8010e2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8010e5:	fd                   	std    
  8010e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8010e8:	fc                   	cld    
  8010e9:	eb 1d                	jmp    801108 <memmove+0x64>
  8010eb:	89 f2                	mov    %esi,%edx
  8010ed:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8010ef:	f6 c2 03             	test   $0x3,%dl
  8010f2:	75 0f                	jne    801103 <memmove+0x5f>
  8010f4:	f6 c1 03             	test   $0x3,%cl
  8010f7:	75 0a                	jne    801103 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8010f9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8010fc:	89 c7                	mov    %eax,%edi
  8010fe:	fc                   	cld    
  8010ff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801101:	eb 05                	jmp    801108 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801103:	89 c7                	mov    %eax,%edi
  801105:	fc                   	cld    
  801106:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801108:	5e                   	pop    %esi
  801109:	5f                   	pop    %edi
  80110a:	5d                   	pop    %ebp
  80110b:	c3                   	ret    

0080110c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801112:	8b 45 10             	mov    0x10(%ebp),%eax
  801115:	89 44 24 08          	mov    %eax,0x8(%esp)
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	89 04 24             	mov    %eax,(%esp)
  801126:	e8 79 ff ff ff       	call   8010a4 <memmove>
}
  80112b:	c9                   	leave  
  80112c:	c3                   	ret    

0080112d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
  801130:	56                   	push   %esi
  801131:	53                   	push   %ebx
  801132:	8b 55 08             	mov    0x8(%ebp),%edx
  801135:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801138:	89 d6                	mov    %edx,%esi
  80113a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80113d:	eb 1a                	jmp    801159 <memcmp+0x2c>
		if (*s1 != *s2)
  80113f:	0f b6 02             	movzbl (%edx),%eax
  801142:	0f b6 19             	movzbl (%ecx),%ebx
  801145:	38 d8                	cmp    %bl,%al
  801147:	74 0a                	je     801153 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  801149:	0f b6 c0             	movzbl %al,%eax
  80114c:	0f b6 db             	movzbl %bl,%ebx
  80114f:	29 d8                	sub    %ebx,%eax
  801151:	eb 0f                	jmp    801162 <memcmp+0x35>
		s1++, s2++;
  801153:	83 c2 01             	add    $0x1,%edx
  801156:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801159:	39 f2                	cmp    %esi,%edx
  80115b:	75 e2                	jne    80113f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80115d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801162:	5b                   	pop    %ebx
  801163:	5e                   	pop    %esi
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    

00801166 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80116f:	89 c2                	mov    %eax,%edx
  801171:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801174:	eb 07                	jmp    80117d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  801176:	38 08                	cmp    %cl,(%eax)
  801178:	74 07                	je     801181 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80117a:	83 c0 01             	add    $0x1,%eax
  80117d:	39 d0                	cmp    %edx,%eax
  80117f:	72 f5                	jb     801176 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801181:	5d                   	pop    %ebp
  801182:	c3                   	ret    

00801183 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
  801186:	57                   	push   %edi
  801187:	56                   	push   %esi
  801188:	53                   	push   %ebx
  801189:	8b 55 08             	mov    0x8(%ebp),%edx
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80118f:	eb 03                	jmp    801194 <strtol+0x11>
		s++;
  801191:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801194:	0f b6 0a             	movzbl (%edx),%ecx
  801197:	80 f9 09             	cmp    $0x9,%cl
  80119a:	74 f5                	je     801191 <strtol+0xe>
  80119c:	80 f9 20             	cmp    $0x20,%cl
  80119f:	74 f0                	je     801191 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011a1:	80 f9 2b             	cmp    $0x2b,%cl
  8011a4:	75 0a                	jne    8011b0 <strtol+0x2d>
		s++;
  8011a6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8011a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8011ae:	eb 11                	jmp    8011c1 <strtol+0x3e>
  8011b0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8011b5:	80 f9 2d             	cmp    $0x2d,%cl
  8011b8:	75 07                	jne    8011c1 <strtol+0x3e>
		s++, neg = 1;
  8011ba:	8d 52 01             	lea    0x1(%edx),%edx
  8011bd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011c1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  8011c6:	75 15                	jne    8011dd <strtol+0x5a>
  8011c8:	80 3a 30             	cmpb   $0x30,(%edx)
  8011cb:	75 10                	jne    8011dd <strtol+0x5a>
  8011cd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8011d1:	75 0a                	jne    8011dd <strtol+0x5a>
		s += 2, base = 16;
  8011d3:	83 c2 02             	add    $0x2,%edx
  8011d6:	b8 10 00 00 00       	mov    $0x10,%eax
  8011db:	eb 10                	jmp    8011ed <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  8011dd:	85 c0                	test   %eax,%eax
  8011df:	75 0c                	jne    8011ed <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8011e1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8011e3:	80 3a 30             	cmpb   $0x30,(%edx)
  8011e6:	75 05                	jne    8011ed <strtol+0x6a>
		s++, base = 8;
  8011e8:	83 c2 01             	add    $0x1,%edx
  8011eb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8011ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011f5:	0f b6 0a             	movzbl (%edx),%ecx
  8011f8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8011fb:	89 f0                	mov    %esi,%eax
  8011fd:	3c 09                	cmp    $0x9,%al
  8011ff:	77 08                	ja     801209 <strtol+0x86>
			dig = *s - '0';
  801201:	0f be c9             	movsbl %cl,%ecx
  801204:	83 e9 30             	sub    $0x30,%ecx
  801207:	eb 20                	jmp    801229 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  801209:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80120c:	89 f0                	mov    %esi,%eax
  80120e:	3c 19                	cmp    $0x19,%al
  801210:	77 08                	ja     80121a <strtol+0x97>
			dig = *s - 'a' + 10;
  801212:	0f be c9             	movsbl %cl,%ecx
  801215:	83 e9 57             	sub    $0x57,%ecx
  801218:	eb 0f                	jmp    801229 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80121a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80121d:	89 f0                	mov    %esi,%eax
  80121f:	3c 19                	cmp    $0x19,%al
  801221:	77 16                	ja     801239 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801223:	0f be c9             	movsbl %cl,%ecx
  801226:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801229:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80122c:	7d 0f                	jge    80123d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80122e:	83 c2 01             	add    $0x1,%edx
  801231:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801235:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801237:	eb bc                	jmp    8011f5 <strtol+0x72>
  801239:	89 d8                	mov    %ebx,%eax
  80123b:	eb 02                	jmp    80123f <strtol+0xbc>
  80123d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80123f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801243:	74 05                	je     80124a <strtol+0xc7>
		*endptr = (char *) s;
  801245:	8b 75 0c             	mov    0xc(%ebp),%esi
  801248:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80124a:	f7 d8                	neg    %eax
  80124c:	85 ff                	test   %edi,%edi
  80124e:	0f 44 c3             	cmove  %ebx,%eax
}
  801251:	5b                   	pop    %ebx
  801252:	5e                   	pop    %esi
  801253:	5f                   	pop    %edi
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    

00801256 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	57                   	push   %edi
  80125a:	56                   	push   %esi
  80125b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80125c:	b8 00 00 00 00       	mov    $0x0,%eax
  801261:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801264:	8b 55 08             	mov    0x8(%ebp),%edx
  801267:	89 c3                	mov    %eax,%ebx
  801269:	89 c7                	mov    %eax,%edi
  80126b:	89 c6                	mov    %eax,%esi
  80126d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80126f:	5b                   	pop    %ebx
  801270:	5e                   	pop    %esi
  801271:	5f                   	pop    %edi
  801272:	5d                   	pop    %ebp
  801273:	c3                   	ret    

00801274 <sys_cgetc>:

int
sys_cgetc(void)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
  801277:	57                   	push   %edi
  801278:	56                   	push   %esi
  801279:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80127a:	ba 00 00 00 00       	mov    $0x0,%edx
  80127f:	b8 01 00 00 00       	mov    $0x1,%eax
  801284:	89 d1                	mov    %edx,%ecx
  801286:	89 d3                	mov    %edx,%ebx
  801288:	89 d7                	mov    %edx,%edi
  80128a:	89 d6                	mov    %edx,%esi
  80128c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80128e:	5b                   	pop    %ebx
  80128f:	5e                   	pop    %esi
  801290:	5f                   	pop    %edi
  801291:	5d                   	pop    %ebp
  801292:	c3                   	ret    

00801293 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	57                   	push   %edi
  801297:	56                   	push   %esi
  801298:	53                   	push   %ebx
  801299:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80129c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012a1:	b8 03 00 00 00       	mov    $0x3,%eax
  8012a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a9:	89 cb                	mov    %ecx,%ebx
  8012ab:	89 cf                	mov    %ecx,%edi
  8012ad:	89 ce                	mov    %ecx,%esi
  8012af:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8012b1:	85 c0                	test   %eax,%eax
  8012b3:	7e 28                	jle    8012dd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012b5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012b9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8012c0:	00 
  8012c1:	c7 44 24 08 a7 34 80 	movl   $0x8034a7,0x8(%esp)
  8012c8:	00 
  8012c9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012d0:	00 
  8012d1:	c7 04 24 c4 34 80 00 	movl   $0x8034c4,(%esp)
  8012d8:	e8 07 f5 ff ff       	call   8007e4 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8012dd:	83 c4 2c             	add    $0x2c,%esp
  8012e0:	5b                   	pop    %ebx
  8012e1:	5e                   	pop    %esi
  8012e2:	5f                   	pop    %edi
  8012e3:	5d                   	pop    %ebp
  8012e4:	c3                   	ret    

008012e5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	57                   	push   %edi
  8012e9:	56                   	push   %esi
  8012ea:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8012f0:	b8 02 00 00 00       	mov    $0x2,%eax
  8012f5:	89 d1                	mov    %edx,%ecx
  8012f7:	89 d3                	mov    %edx,%ebx
  8012f9:	89 d7                	mov    %edx,%edi
  8012fb:	89 d6                	mov    %edx,%esi
  8012fd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8012ff:	5b                   	pop    %ebx
  801300:	5e                   	pop    %esi
  801301:	5f                   	pop    %edi
  801302:	5d                   	pop    %ebp
  801303:	c3                   	ret    

00801304 <sys_yield>:

void
sys_yield(void)
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
  801307:	57                   	push   %edi
  801308:	56                   	push   %esi
  801309:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80130a:	ba 00 00 00 00       	mov    $0x0,%edx
  80130f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801314:	89 d1                	mov    %edx,%ecx
  801316:	89 d3                	mov    %edx,%ebx
  801318:	89 d7                	mov    %edx,%edi
  80131a:	89 d6                	mov    %edx,%esi
  80131c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80131e:	5b                   	pop    %ebx
  80131f:	5e                   	pop    %esi
  801320:	5f                   	pop    %edi
  801321:	5d                   	pop    %ebp
  801322:	c3                   	ret    

00801323 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
  801326:	57                   	push   %edi
  801327:	56                   	push   %esi
  801328:	53                   	push   %ebx
  801329:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80132c:	be 00 00 00 00       	mov    $0x0,%esi
  801331:	b8 04 00 00 00       	mov    $0x4,%eax
  801336:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801339:	8b 55 08             	mov    0x8(%ebp),%edx
  80133c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80133f:	89 f7                	mov    %esi,%edi
  801341:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801343:	85 c0                	test   %eax,%eax
  801345:	7e 28                	jle    80136f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801347:	89 44 24 10          	mov    %eax,0x10(%esp)
  80134b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801352:	00 
  801353:	c7 44 24 08 a7 34 80 	movl   $0x8034a7,0x8(%esp)
  80135a:	00 
  80135b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801362:	00 
  801363:	c7 04 24 c4 34 80 00 	movl   $0x8034c4,(%esp)
  80136a:	e8 75 f4 ff ff       	call   8007e4 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80136f:	83 c4 2c             	add    $0x2c,%esp
  801372:	5b                   	pop    %ebx
  801373:	5e                   	pop    %esi
  801374:	5f                   	pop    %edi
  801375:	5d                   	pop    %ebp
  801376:	c3                   	ret    

00801377 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	57                   	push   %edi
  80137b:	56                   	push   %esi
  80137c:	53                   	push   %ebx
  80137d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801380:	b8 05 00 00 00       	mov    $0x5,%eax
  801385:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801388:	8b 55 08             	mov    0x8(%ebp),%edx
  80138b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80138e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801391:	8b 75 18             	mov    0x18(%ebp),%esi
  801394:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801396:	85 c0                	test   %eax,%eax
  801398:	7e 28                	jle    8013c2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80139a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80139e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8013a5:	00 
  8013a6:	c7 44 24 08 a7 34 80 	movl   $0x8034a7,0x8(%esp)
  8013ad:	00 
  8013ae:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013b5:	00 
  8013b6:	c7 04 24 c4 34 80 00 	movl   $0x8034c4,(%esp)
  8013bd:	e8 22 f4 ff ff       	call   8007e4 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8013c2:	83 c4 2c             	add    $0x2c,%esp
  8013c5:	5b                   	pop    %ebx
  8013c6:	5e                   	pop    %esi
  8013c7:	5f                   	pop    %edi
  8013c8:	5d                   	pop    %ebp
  8013c9:	c3                   	ret    

008013ca <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	57                   	push   %edi
  8013ce:	56                   	push   %esi
  8013cf:	53                   	push   %ebx
  8013d0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d8:	b8 06 00 00 00       	mov    $0x6,%eax
  8013dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e3:	89 df                	mov    %ebx,%edi
  8013e5:	89 de                	mov    %ebx,%esi
  8013e7:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8013e9:	85 c0                	test   %eax,%eax
  8013eb:	7e 28                	jle    801415 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013ed:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013f1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8013f8:	00 
  8013f9:	c7 44 24 08 a7 34 80 	movl   $0x8034a7,0x8(%esp)
  801400:	00 
  801401:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801408:	00 
  801409:	c7 04 24 c4 34 80 00 	movl   $0x8034c4,(%esp)
  801410:	e8 cf f3 ff ff       	call   8007e4 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801415:	83 c4 2c             	add    $0x2c,%esp
  801418:	5b                   	pop    %ebx
  801419:	5e                   	pop    %esi
  80141a:	5f                   	pop    %edi
  80141b:	5d                   	pop    %ebp
  80141c:	c3                   	ret    

0080141d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	57                   	push   %edi
  801421:	56                   	push   %esi
  801422:	53                   	push   %ebx
  801423:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801426:	bb 00 00 00 00       	mov    $0x0,%ebx
  80142b:	b8 08 00 00 00       	mov    $0x8,%eax
  801430:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801433:	8b 55 08             	mov    0x8(%ebp),%edx
  801436:	89 df                	mov    %ebx,%edi
  801438:	89 de                	mov    %ebx,%esi
  80143a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80143c:	85 c0                	test   %eax,%eax
  80143e:	7e 28                	jle    801468 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801440:	89 44 24 10          	mov    %eax,0x10(%esp)
  801444:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80144b:	00 
  80144c:	c7 44 24 08 a7 34 80 	movl   $0x8034a7,0x8(%esp)
  801453:	00 
  801454:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80145b:	00 
  80145c:	c7 04 24 c4 34 80 00 	movl   $0x8034c4,(%esp)
  801463:	e8 7c f3 ff ff       	call   8007e4 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801468:	83 c4 2c             	add    $0x2c,%esp
  80146b:	5b                   	pop    %ebx
  80146c:	5e                   	pop    %esi
  80146d:	5f                   	pop    %edi
  80146e:	5d                   	pop    %ebp
  80146f:	c3                   	ret    

00801470 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	57                   	push   %edi
  801474:	56                   	push   %esi
  801475:	53                   	push   %ebx
  801476:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801479:	bb 00 00 00 00       	mov    $0x0,%ebx
  80147e:	b8 09 00 00 00       	mov    $0x9,%eax
  801483:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801486:	8b 55 08             	mov    0x8(%ebp),%edx
  801489:	89 df                	mov    %ebx,%edi
  80148b:	89 de                	mov    %ebx,%esi
  80148d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80148f:	85 c0                	test   %eax,%eax
  801491:	7e 28                	jle    8014bb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801493:	89 44 24 10          	mov    %eax,0x10(%esp)
  801497:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80149e:	00 
  80149f:	c7 44 24 08 a7 34 80 	movl   $0x8034a7,0x8(%esp)
  8014a6:	00 
  8014a7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014ae:	00 
  8014af:	c7 04 24 c4 34 80 00 	movl   $0x8034c4,(%esp)
  8014b6:	e8 29 f3 ff ff       	call   8007e4 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8014bb:	83 c4 2c             	add    $0x2c,%esp
  8014be:	5b                   	pop    %ebx
  8014bf:	5e                   	pop    %esi
  8014c0:	5f                   	pop    %edi
  8014c1:	5d                   	pop    %ebp
  8014c2:	c3                   	ret    

008014c3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	57                   	push   %edi
  8014c7:	56                   	push   %esi
  8014c8:	53                   	push   %ebx
  8014c9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014d1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8014d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014dc:	89 df                	mov    %ebx,%edi
  8014de:	89 de                	mov    %ebx,%esi
  8014e0:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	7e 28                	jle    80150e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014e6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014ea:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8014f1:	00 
  8014f2:	c7 44 24 08 a7 34 80 	movl   $0x8034a7,0x8(%esp)
  8014f9:	00 
  8014fa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801501:	00 
  801502:	c7 04 24 c4 34 80 00 	movl   $0x8034c4,(%esp)
  801509:	e8 d6 f2 ff ff       	call   8007e4 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80150e:	83 c4 2c             	add    $0x2c,%esp
  801511:	5b                   	pop    %ebx
  801512:	5e                   	pop    %esi
  801513:	5f                   	pop    %edi
  801514:	5d                   	pop    %ebp
  801515:	c3                   	ret    

00801516 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	57                   	push   %edi
  80151a:	56                   	push   %esi
  80151b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80151c:	be 00 00 00 00       	mov    $0x0,%esi
  801521:	b8 0c 00 00 00       	mov    $0xc,%eax
  801526:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801529:	8b 55 08             	mov    0x8(%ebp),%edx
  80152c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80152f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801532:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801534:	5b                   	pop    %ebx
  801535:	5e                   	pop    %esi
  801536:	5f                   	pop    %edi
  801537:	5d                   	pop    %ebp
  801538:	c3                   	ret    

00801539 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	57                   	push   %edi
  80153d:	56                   	push   %esi
  80153e:	53                   	push   %ebx
  80153f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801542:	b9 00 00 00 00       	mov    $0x0,%ecx
  801547:	b8 0d 00 00 00       	mov    $0xd,%eax
  80154c:	8b 55 08             	mov    0x8(%ebp),%edx
  80154f:	89 cb                	mov    %ecx,%ebx
  801551:	89 cf                	mov    %ecx,%edi
  801553:	89 ce                	mov    %ecx,%esi
  801555:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801557:	85 c0                	test   %eax,%eax
  801559:	7e 28                	jle    801583 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80155b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80155f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801566:	00 
  801567:	c7 44 24 08 a7 34 80 	movl   $0x8034a7,0x8(%esp)
  80156e:	00 
  80156f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801576:	00 
  801577:	c7 04 24 c4 34 80 00 	movl   $0x8034c4,(%esp)
  80157e:	e8 61 f2 ff ff       	call   8007e4 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801583:	83 c4 2c             	add    $0x2c,%esp
  801586:	5b                   	pop    %ebx
  801587:	5e                   	pop    %esi
  801588:	5f                   	pop    %edi
  801589:	5d                   	pop    %ebp
  80158a:	c3                   	ret    

0080158b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	57                   	push   %edi
  80158f:	56                   	push   %esi
  801590:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801591:	ba 00 00 00 00       	mov    $0x0,%edx
  801596:	b8 0e 00 00 00       	mov    $0xe,%eax
  80159b:	89 d1                	mov    %edx,%ecx
  80159d:	89 d3                	mov    %edx,%ebx
  80159f:	89 d7                	mov    %edx,%edi
  8015a1:	89 d6                	mov    %edx,%esi
  8015a3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8015a5:	5b                   	pop    %ebx
  8015a6:	5e                   	pop    %esi
  8015a7:	5f                   	pop    %edi
  8015a8:	5d                   	pop    %ebp
  8015a9:	c3                   	ret    

008015aa <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	57                   	push   %edi
  8015ae:	56                   	push   %esi
  8015af:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b5:	b8 0f 00 00 00       	mov    $0xf,%eax
  8015ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c0:	89 df                	mov    %ebx,%edi
  8015c2:	89 de                	mov    %ebx,%esi
  8015c4:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  8015c6:	5b                   	pop    %ebx
  8015c7:	5e                   	pop    %esi
  8015c8:	5f                   	pop    %edi
  8015c9:	5d                   	pop    %ebp
  8015ca:	c3                   	ret    

008015cb <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
  8015ce:	57                   	push   %edi
  8015cf:	56                   	push   %esi
  8015d0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d6:	b8 10 00 00 00       	mov    $0x10,%eax
  8015db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015de:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e1:	89 df                	mov    %ebx,%edi
  8015e3:	89 de                	mov    %ebx,%esi
  8015e5:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  8015e7:	5b                   	pop    %ebx
  8015e8:	5e                   	pop    %esi
  8015e9:	5f                   	pop    %edi
  8015ea:	5d                   	pop    %ebp
  8015eb:	c3                   	ret    

008015ec <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	57                   	push   %edi
  8015f0:	56                   	push   %esi
  8015f1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015f7:	b8 11 00 00 00       	mov    $0x11,%eax
  8015fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ff:	89 cb                	mov    %ecx,%ebx
  801601:	89 cf                	mov    %ecx,%edi
  801603:	89 ce                	mov    %ecx,%esi
  801605:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  801607:	5b                   	pop    %ebx
  801608:	5e                   	pop    %esi
  801609:	5f                   	pop    %edi
  80160a:	5d                   	pop    %ebp
  80160b:	c3                   	ret    

0080160c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	57                   	push   %edi
  801610:	56                   	push   %esi
  801611:	53                   	push   %ebx
  801612:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801615:	be 00 00 00 00       	mov    $0x0,%esi
  80161a:	b8 12 00 00 00       	mov    $0x12,%eax
  80161f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801622:	8b 55 08             	mov    0x8(%ebp),%edx
  801625:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801628:	8b 7d 14             	mov    0x14(%ebp),%edi
  80162b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80162d:	85 c0                	test   %eax,%eax
  80162f:	7e 28                	jle    801659 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  801631:	89 44 24 10          	mov    %eax,0x10(%esp)
  801635:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  80163c:	00 
  80163d:	c7 44 24 08 a7 34 80 	movl   $0x8034a7,0x8(%esp)
  801644:	00 
  801645:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80164c:	00 
  80164d:	c7 04 24 c4 34 80 00 	movl   $0x8034c4,(%esp)
  801654:	e8 8b f1 ff ff       	call   8007e4 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  801659:	83 c4 2c             	add    $0x2c,%esp
  80165c:	5b                   	pop    %ebx
  80165d:	5e                   	pop    %esi
  80165e:	5f                   	pop    %edi
  80165f:	5d                   	pop    %ebp
  801660:	c3                   	ret    
  801661:	66 90                	xchg   %ax,%ax
  801663:	66 90                	xchg   %ax,%ax
  801665:	66 90                	xchg   %ax,%ax
  801667:	66 90                	xchg   %ax,%ax
  801669:	66 90                	xchg   %ax,%ax
  80166b:	66 90                	xchg   %ax,%ax
  80166d:	66 90                	xchg   %ax,%ax
  80166f:	90                   	nop

00801670 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	56                   	push   %esi
  801674:	53                   	push   %ebx
  801675:	83 ec 10             	sub    $0x10,%esp
  801678:	8b 75 08             	mov    0x8(%ebp),%esi
  80167b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  801681:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  801683:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  801688:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80168b:	89 04 24             	mov    %eax,(%esp)
  80168e:	e8 a6 fe ff ff       	call   801539 <sys_ipc_recv>
  801693:	85 c0                	test   %eax,%eax
  801695:	74 16                	je     8016ad <ipc_recv+0x3d>
		if (from_env_store != NULL)
  801697:	85 f6                	test   %esi,%esi
  801699:	74 06                	je     8016a1 <ipc_recv+0x31>
			*from_env_store = 0;
  80169b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  8016a1:	85 db                	test   %ebx,%ebx
  8016a3:	74 2c                	je     8016d1 <ipc_recv+0x61>
			*perm_store = 0;
  8016a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016ab:	eb 24                	jmp    8016d1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  8016ad:	85 f6                	test   %esi,%esi
  8016af:	74 0a                	je     8016bb <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  8016b1:	a1 08 50 80 00       	mov    0x805008,%eax
  8016b6:	8b 40 74             	mov    0x74(%eax),%eax
  8016b9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  8016bb:	85 db                	test   %ebx,%ebx
  8016bd:	74 0a                	je     8016c9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  8016bf:	a1 08 50 80 00       	mov    0x805008,%eax
  8016c4:	8b 40 78             	mov    0x78(%eax),%eax
  8016c7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8016c9:	a1 08 50 80 00       	mov    0x805008,%eax
  8016ce:	8b 40 70             	mov    0x70(%eax),%eax
}
  8016d1:	83 c4 10             	add    $0x10,%esp
  8016d4:	5b                   	pop    %ebx
  8016d5:	5e                   	pop    %esi
  8016d6:	5d                   	pop    %ebp
  8016d7:	c3                   	ret    

008016d8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
  8016db:	57                   	push   %edi
  8016dc:	56                   	push   %esi
  8016dd:	53                   	push   %ebx
  8016de:	83 ec 1c             	sub    $0x1c,%esp
  8016e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016e7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  8016ea:	85 db                	test   %ebx,%ebx
  8016ec:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8016f1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  8016f4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	89 04 24             	mov    %eax,(%esp)
  801706:	e8 0b fe ff ff       	call   801516 <sys_ipc_try_send>
	if (r == 0) return;
  80170b:	85 c0                	test   %eax,%eax
  80170d:	75 22                	jne    801731 <ipc_send+0x59>
  80170f:	eb 4c                	jmp    80175d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  801711:	84 d2                	test   %dl,%dl
  801713:	75 48                	jne    80175d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  801715:	e8 ea fb ff ff       	call   801304 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80171a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80171e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801722:	89 74 24 04          	mov    %esi,0x4(%esp)
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	89 04 24             	mov    %eax,(%esp)
  80172c:	e8 e5 fd ff ff       	call   801516 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  801731:	85 c0                	test   %eax,%eax
  801733:	0f 94 c2             	sete   %dl
  801736:	74 d9                	je     801711 <ipc_send+0x39>
  801738:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80173b:	74 d4                	je     801711 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80173d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801741:	c7 44 24 08 d2 34 80 	movl   $0x8034d2,0x8(%esp)
  801748:	00 
  801749:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  801750:	00 
  801751:	c7 04 24 e0 34 80 00 	movl   $0x8034e0,(%esp)
  801758:	e8 87 f0 ff ff       	call   8007e4 <_panic>
}
  80175d:	83 c4 1c             	add    $0x1c,%esp
  801760:	5b                   	pop    %ebx
  801761:	5e                   	pop    %esi
  801762:	5f                   	pop    %edi
  801763:	5d                   	pop    %ebp
  801764:	c3                   	ret    

00801765 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80176b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801770:	89 c2                	mov    %eax,%edx
  801772:	c1 e2 07             	shl    $0x7,%edx
  801775:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80177b:	8b 52 50             	mov    0x50(%edx),%edx
  80177e:	39 ca                	cmp    %ecx,%edx
  801780:	75 0d                	jne    80178f <ipc_find_env+0x2a>
			return envs[i].env_id;
  801782:	c1 e0 07             	shl    $0x7,%eax
  801785:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80178a:	8b 40 40             	mov    0x40(%eax),%eax
  80178d:	eb 0e                	jmp    80179d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80178f:	83 c0 01             	add    $0x1,%eax
  801792:	3d 00 04 00 00       	cmp    $0x400,%eax
  801797:	75 d7                	jne    801770 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801799:	66 b8 00 00          	mov    $0x0,%ax
}
  80179d:	5d                   	pop    %ebp
  80179e:	c3                   	ret    
  80179f:	90                   	nop

008017a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8017ab:	c1 e8 0c             	shr    $0xc,%eax
}
  8017ae:	5d                   	pop    %ebp
  8017af:	c3                   	ret    

008017b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8017bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017c0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017c5:	5d                   	pop    %ebp
  8017c6:	c3                   	ret    

008017c7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017cd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017d2:	89 c2                	mov    %eax,%edx
  8017d4:	c1 ea 16             	shr    $0x16,%edx
  8017d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017de:	f6 c2 01             	test   $0x1,%dl
  8017e1:	74 11                	je     8017f4 <fd_alloc+0x2d>
  8017e3:	89 c2                	mov    %eax,%edx
  8017e5:	c1 ea 0c             	shr    $0xc,%edx
  8017e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017ef:	f6 c2 01             	test   $0x1,%dl
  8017f2:	75 09                	jne    8017fd <fd_alloc+0x36>
			*fd_store = fd;
  8017f4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fb:	eb 17                	jmp    801814 <fd_alloc+0x4d>
  8017fd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801802:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801807:	75 c9                	jne    8017d2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801809:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80180f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801814:	5d                   	pop    %ebp
  801815:	c3                   	ret    

00801816 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80181c:	83 f8 1f             	cmp    $0x1f,%eax
  80181f:	77 36                	ja     801857 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801821:	c1 e0 0c             	shl    $0xc,%eax
  801824:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801829:	89 c2                	mov    %eax,%edx
  80182b:	c1 ea 16             	shr    $0x16,%edx
  80182e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801835:	f6 c2 01             	test   $0x1,%dl
  801838:	74 24                	je     80185e <fd_lookup+0x48>
  80183a:	89 c2                	mov    %eax,%edx
  80183c:	c1 ea 0c             	shr    $0xc,%edx
  80183f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801846:	f6 c2 01             	test   $0x1,%dl
  801849:	74 1a                	je     801865 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80184b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184e:	89 02                	mov    %eax,(%edx)
	return 0;
  801850:	b8 00 00 00 00       	mov    $0x0,%eax
  801855:	eb 13                	jmp    80186a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801857:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80185c:	eb 0c                	jmp    80186a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80185e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801863:	eb 05                	jmp    80186a <fd_lookup+0x54>
  801865:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80186a:	5d                   	pop    %ebp
  80186b:	c3                   	ret    

0080186c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	83 ec 18             	sub    $0x18,%esp
  801872:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801875:	ba 00 00 00 00       	mov    $0x0,%edx
  80187a:	eb 13                	jmp    80188f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80187c:	39 08                	cmp    %ecx,(%eax)
  80187e:	75 0c                	jne    80188c <dev_lookup+0x20>
			*dev = devtab[i];
  801880:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801883:	89 01                	mov    %eax,(%ecx)
			return 0;
  801885:	b8 00 00 00 00       	mov    $0x0,%eax
  80188a:	eb 38                	jmp    8018c4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80188c:	83 c2 01             	add    $0x1,%edx
  80188f:	8b 04 95 6c 35 80 00 	mov    0x80356c(,%edx,4),%eax
  801896:	85 c0                	test   %eax,%eax
  801898:	75 e2                	jne    80187c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80189a:	a1 08 50 80 00       	mov    0x805008,%eax
  80189f:	8b 40 48             	mov    0x48(%eax),%eax
  8018a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018aa:	c7 04 24 ec 34 80 00 	movl   $0x8034ec,(%esp)
  8018b1:	e8 27 f0 ff ff       	call   8008dd <cprintf>
	*dev = 0;
  8018b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8018bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	56                   	push   %esi
  8018ca:	53                   	push   %ebx
  8018cb:	83 ec 20             	sub    $0x20,%esp
  8018ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8018d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018e1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018e4:	89 04 24             	mov    %eax,(%esp)
  8018e7:	e8 2a ff ff ff       	call   801816 <fd_lookup>
  8018ec:	85 c0                	test   %eax,%eax
  8018ee:	78 05                	js     8018f5 <fd_close+0x2f>
	    || fd != fd2)
  8018f0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8018f3:	74 0c                	je     801901 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8018f5:	84 db                	test   %bl,%bl
  8018f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fc:	0f 44 c2             	cmove  %edx,%eax
  8018ff:	eb 3f                	jmp    801940 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801901:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801904:	89 44 24 04          	mov    %eax,0x4(%esp)
  801908:	8b 06                	mov    (%esi),%eax
  80190a:	89 04 24             	mov    %eax,(%esp)
  80190d:	e8 5a ff ff ff       	call   80186c <dev_lookup>
  801912:	89 c3                	mov    %eax,%ebx
  801914:	85 c0                	test   %eax,%eax
  801916:	78 16                	js     80192e <fd_close+0x68>
		if (dev->dev_close)
  801918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80191e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801923:	85 c0                	test   %eax,%eax
  801925:	74 07                	je     80192e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801927:	89 34 24             	mov    %esi,(%esp)
  80192a:	ff d0                	call   *%eax
  80192c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80192e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801932:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801939:	e8 8c fa ff ff       	call   8013ca <sys_page_unmap>
	return r;
  80193e:	89 d8                	mov    %ebx,%eax
}
  801940:	83 c4 20             	add    $0x20,%esp
  801943:	5b                   	pop    %ebx
  801944:	5e                   	pop    %esi
  801945:	5d                   	pop    %ebp
  801946:	c3                   	ret    

00801947 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80194d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801950:	89 44 24 04          	mov    %eax,0x4(%esp)
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	89 04 24             	mov    %eax,(%esp)
  80195a:	e8 b7 fe ff ff       	call   801816 <fd_lookup>
  80195f:	89 c2                	mov    %eax,%edx
  801961:	85 d2                	test   %edx,%edx
  801963:	78 13                	js     801978 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801965:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80196c:	00 
  80196d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801970:	89 04 24             	mov    %eax,(%esp)
  801973:	e8 4e ff ff ff       	call   8018c6 <fd_close>
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <close_all>:

void
close_all(void)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
  80197d:	53                   	push   %ebx
  80197e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801981:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801986:	89 1c 24             	mov    %ebx,(%esp)
  801989:	e8 b9 ff ff ff       	call   801947 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80198e:	83 c3 01             	add    $0x1,%ebx
  801991:	83 fb 20             	cmp    $0x20,%ebx
  801994:	75 f0                	jne    801986 <close_all+0xc>
		close(i);
}
  801996:	83 c4 14             	add    $0x14,%esp
  801999:	5b                   	pop    %ebx
  80199a:	5d                   	pop    %ebp
  80199b:	c3                   	ret    

0080199c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	57                   	push   %edi
  8019a0:	56                   	push   %esi
  8019a1:	53                   	push   %ebx
  8019a2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	89 04 24             	mov    %eax,(%esp)
  8019b2:	e8 5f fe ff ff       	call   801816 <fd_lookup>
  8019b7:	89 c2                	mov    %eax,%edx
  8019b9:	85 d2                	test   %edx,%edx
  8019bb:	0f 88 e1 00 00 00    	js     801aa2 <dup+0x106>
		return r;
	close(newfdnum);
  8019c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c4:	89 04 24             	mov    %eax,(%esp)
  8019c7:	e8 7b ff ff ff       	call   801947 <close>

	newfd = INDEX2FD(newfdnum);
  8019cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8019cf:	c1 e3 0c             	shl    $0xc,%ebx
  8019d2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8019d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019db:	89 04 24             	mov    %eax,(%esp)
  8019de:	e8 cd fd ff ff       	call   8017b0 <fd2data>
  8019e3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8019e5:	89 1c 24             	mov    %ebx,(%esp)
  8019e8:	e8 c3 fd ff ff       	call   8017b0 <fd2data>
  8019ed:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019ef:	89 f0                	mov    %esi,%eax
  8019f1:	c1 e8 16             	shr    $0x16,%eax
  8019f4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019fb:	a8 01                	test   $0x1,%al
  8019fd:	74 43                	je     801a42 <dup+0xa6>
  8019ff:	89 f0                	mov    %esi,%eax
  801a01:	c1 e8 0c             	shr    $0xc,%eax
  801a04:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a0b:	f6 c2 01             	test   $0x1,%dl
  801a0e:	74 32                	je     801a42 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a10:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a17:	25 07 0e 00 00       	and    $0xe07,%eax
  801a1c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a20:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a24:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a2b:	00 
  801a2c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a37:	e8 3b f9 ff ff       	call   801377 <sys_page_map>
  801a3c:	89 c6                	mov    %eax,%esi
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	78 3e                	js     801a80 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a45:	89 c2                	mov    %eax,%edx
  801a47:	c1 ea 0c             	shr    $0xc,%edx
  801a4a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a51:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a57:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801a5f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a66:	00 
  801a67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a72:	e8 00 f9 ff ff       	call   801377 <sys_page_map>
  801a77:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801a79:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a7c:	85 f6                	test   %esi,%esi
  801a7e:	79 22                	jns    801aa2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801a80:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a8b:	e8 3a f9 ff ff       	call   8013ca <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a90:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a9b:	e8 2a f9 ff ff       	call   8013ca <sys_page_unmap>
	return r;
  801aa0:	89 f0                	mov    %esi,%eax
}
  801aa2:	83 c4 3c             	add    $0x3c,%esp
  801aa5:	5b                   	pop    %ebx
  801aa6:	5e                   	pop    %esi
  801aa7:	5f                   	pop    %edi
  801aa8:	5d                   	pop    %ebp
  801aa9:	c3                   	ret    

00801aaa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	53                   	push   %ebx
  801aae:	83 ec 24             	sub    $0x24,%esp
  801ab1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ab4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801abb:	89 1c 24             	mov    %ebx,(%esp)
  801abe:	e8 53 fd ff ff       	call   801816 <fd_lookup>
  801ac3:	89 c2                	mov    %eax,%edx
  801ac5:	85 d2                	test   %edx,%edx
  801ac7:	78 6d                	js     801b36 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ac9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801acc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad3:	8b 00                	mov    (%eax),%eax
  801ad5:	89 04 24             	mov    %eax,(%esp)
  801ad8:	e8 8f fd ff ff       	call   80186c <dev_lookup>
  801add:	85 c0                	test   %eax,%eax
  801adf:	78 55                	js     801b36 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae4:	8b 50 08             	mov    0x8(%eax),%edx
  801ae7:	83 e2 03             	and    $0x3,%edx
  801aea:	83 fa 01             	cmp    $0x1,%edx
  801aed:	75 23                	jne    801b12 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801aef:	a1 08 50 80 00       	mov    0x805008,%eax
  801af4:	8b 40 48             	mov    0x48(%eax),%eax
  801af7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801afb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aff:	c7 04 24 30 35 80 00 	movl   $0x803530,(%esp)
  801b06:	e8 d2 ed ff ff       	call   8008dd <cprintf>
		return -E_INVAL;
  801b0b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b10:	eb 24                	jmp    801b36 <read+0x8c>
	}
	if (!dev->dev_read)
  801b12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b15:	8b 52 08             	mov    0x8(%edx),%edx
  801b18:	85 d2                	test   %edx,%edx
  801b1a:	74 15                	je     801b31 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b1f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b26:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b2a:	89 04 24             	mov    %eax,(%esp)
  801b2d:	ff d2                	call   *%edx
  801b2f:	eb 05                	jmp    801b36 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801b31:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801b36:	83 c4 24             	add    $0x24,%esp
  801b39:	5b                   	pop    %ebx
  801b3a:	5d                   	pop    %ebp
  801b3b:	c3                   	ret    

00801b3c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	57                   	push   %edi
  801b40:	56                   	push   %esi
  801b41:	53                   	push   %ebx
  801b42:	83 ec 1c             	sub    $0x1c,%esp
  801b45:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b48:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b50:	eb 23                	jmp    801b75 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b52:	89 f0                	mov    %esi,%eax
  801b54:	29 d8                	sub    %ebx,%eax
  801b56:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b5a:	89 d8                	mov    %ebx,%eax
  801b5c:	03 45 0c             	add    0xc(%ebp),%eax
  801b5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b63:	89 3c 24             	mov    %edi,(%esp)
  801b66:	e8 3f ff ff ff       	call   801aaa <read>
		if (m < 0)
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	78 10                	js     801b7f <readn+0x43>
			return m;
		if (m == 0)
  801b6f:	85 c0                	test   %eax,%eax
  801b71:	74 0a                	je     801b7d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b73:	01 c3                	add    %eax,%ebx
  801b75:	39 f3                	cmp    %esi,%ebx
  801b77:	72 d9                	jb     801b52 <readn+0x16>
  801b79:	89 d8                	mov    %ebx,%eax
  801b7b:	eb 02                	jmp    801b7f <readn+0x43>
  801b7d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801b7f:	83 c4 1c             	add    $0x1c,%esp
  801b82:	5b                   	pop    %ebx
  801b83:	5e                   	pop    %esi
  801b84:	5f                   	pop    %edi
  801b85:	5d                   	pop    %ebp
  801b86:	c3                   	ret    

00801b87 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
  801b8a:	53                   	push   %ebx
  801b8b:	83 ec 24             	sub    $0x24,%esp
  801b8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b91:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b98:	89 1c 24             	mov    %ebx,(%esp)
  801b9b:	e8 76 fc ff ff       	call   801816 <fd_lookup>
  801ba0:	89 c2                	mov    %eax,%edx
  801ba2:	85 d2                	test   %edx,%edx
  801ba4:	78 68                	js     801c0e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ba6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb0:	8b 00                	mov    (%eax),%eax
  801bb2:	89 04 24             	mov    %eax,(%esp)
  801bb5:	e8 b2 fc ff ff       	call   80186c <dev_lookup>
  801bba:	85 c0                	test   %eax,%eax
  801bbc:	78 50                	js     801c0e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bc5:	75 23                	jne    801bea <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801bc7:	a1 08 50 80 00       	mov    0x805008,%eax
  801bcc:	8b 40 48             	mov    0x48(%eax),%eax
  801bcf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd7:	c7 04 24 4c 35 80 00 	movl   $0x80354c,(%esp)
  801bde:	e8 fa ec ff ff       	call   8008dd <cprintf>
		return -E_INVAL;
  801be3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801be8:	eb 24                	jmp    801c0e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801bea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bed:	8b 52 0c             	mov    0xc(%edx),%edx
  801bf0:	85 d2                	test   %edx,%edx
  801bf2:	74 15                	je     801c09 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801bf4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bf7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bfe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c02:	89 04 24             	mov    %eax,(%esp)
  801c05:	ff d2                	call   *%edx
  801c07:	eb 05                	jmp    801c0e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801c09:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801c0e:	83 c4 24             	add    $0x24,%esp
  801c11:	5b                   	pop    %ebx
  801c12:	5d                   	pop    %ebp
  801c13:	c3                   	ret    

00801c14 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c1a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801c1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	89 04 24             	mov    %eax,(%esp)
  801c27:	e8 ea fb ff ff       	call   801816 <fd_lookup>
  801c2c:	85 c0                	test   %eax,%eax
  801c2e:	78 0e                	js     801c3e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c36:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	53                   	push   %ebx
  801c44:	83 ec 24             	sub    $0x24,%esp
  801c47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c4a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c51:	89 1c 24             	mov    %ebx,(%esp)
  801c54:	e8 bd fb ff ff       	call   801816 <fd_lookup>
  801c59:	89 c2                	mov    %eax,%edx
  801c5b:	85 d2                	test   %edx,%edx
  801c5d:	78 61                	js     801cc0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c62:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c69:	8b 00                	mov    (%eax),%eax
  801c6b:	89 04 24             	mov    %eax,(%esp)
  801c6e:	e8 f9 fb ff ff       	call   80186c <dev_lookup>
  801c73:	85 c0                	test   %eax,%eax
  801c75:	78 49                	js     801cc0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c7a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c7e:	75 23                	jne    801ca3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801c80:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c85:	8b 40 48             	mov    0x48(%eax),%eax
  801c88:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c90:	c7 04 24 0c 35 80 00 	movl   $0x80350c,(%esp)
  801c97:	e8 41 ec ff ff       	call   8008dd <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801c9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ca1:	eb 1d                	jmp    801cc0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801ca3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ca6:	8b 52 18             	mov    0x18(%edx),%edx
  801ca9:	85 d2                	test   %edx,%edx
  801cab:	74 0e                	je     801cbb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801cad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801cb0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cb4:	89 04 24             	mov    %eax,(%esp)
  801cb7:	ff d2                	call   *%edx
  801cb9:	eb 05                	jmp    801cc0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801cbb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801cc0:	83 c4 24             	add    $0x24,%esp
  801cc3:	5b                   	pop    %ebx
  801cc4:	5d                   	pop    %ebp
  801cc5:	c3                   	ret    

00801cc6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	53                   	push   %ebx
  801cca:	83 ec 24             	sub    $0x24,%esp
  801ccd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cd0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	89 04 24             	mov    %eax,(%esp)
  801cdd:	e8 34 fb ff ff       	call   801816 <fd_lookup>
  801ce2:	89 c2                	mov    %eax,%edx
  801ce4:	85 d2                	test   %edx,%edx
  801ce6:	78 52                	js     801d3a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ce8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ceb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf2:	8b 00                	mov    (%eax),%eax
  801cf4:	89 04 24             	mov    %eax,(%esp)
  801cf7:	e8 70 fb ff ff       	call   80186c <dev_lookup>
  801cfc:	85 c0                	test   %eax,%eax
  801cfe:	78 3a                	js     801d3a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d03:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d07:	74 2c                	je     801d35 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d09:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d0c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d13:	00 00 00 
	stat->st_isdir = 0;
  801d16:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d1d:	00 00 00 
	stat->st_dev = dev;
  801d20:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d26:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d2d:	89 14 24             	mov    %edx,(%esp)
  801d30:	ff 50 14             	call   *0x14(%eax)
  801d33:	eb 05                	jmp    801d3a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801d35:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801d3a:	83 c4 24             	add    $0x24,%esp
  801d3d:	5b                   	pop    %ebx
  801d3e:	5d                   	pop    %ebp
  801d3f:	c3                   	ret    

00801d40 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	56                   	push   %esi
  801d44:	53                   	push   %ebx
  801d45:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d48:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d4f:	00 
  801d50:	8b 45 08             	mov    0x8(%ebp),%eax
  801d53:	89 04 24             	mov    %eax,(%esp)
  801d56:	e8 84 02 00 00       	call   801fdf <open>
  801d5b:	89 c3                	mov    %eax,%ebx
  801d5d:	85 db                	test   %ebx,%ebx
  801d5f:	78 1b                	js     801d7c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801d61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d68:	89 1c 24             	mov    %ebx,(%esp)
  801d6b:	e8 56 ff ff ff       	call   801cc6 <fstat>
  801d70:	89 c6                	mov    %eax,%esi
	close(fd);
  801d72:	89 1c 24             	mov    %ebx,(%esp)
  801d75:	e8 cd fb ff ff       	call   801947 <close>
	return r;
  801d7a:	89 f0                	mov    %esi,%eax
}
  801d7c:	83 c4 10             	add    $0x10,%esp
  801d7f:	5b                   	pop    %ebx
  801d80:	5e                   	pop    %esi
  801d81:	5d                   	pop    %ebp
  801d82:	c3                   	ret    

00801d83 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	56                   	push   %esi
  801d87:	53                   	push   %ebx
  801d88:	83 ec 10             	sub    $0x10,%esp
  801d8b:	89 c6                	mov    %eax,%esi
  801d8d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d8f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d96:	75 11                	jne    801da9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801d9f:	e8 c1 f9 ff ff       	call   801765 <ipc_find_env>
  801da4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801da9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801db0:	00 
  801db1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801db8:	00 
  801db9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dbd:	a1 00 50 80 00       	mov    0x805000,%eax
  801dc2:	89 04 24             	mov    %eax,(%esp)
  801dc5:	e8 0e f9 ff ff       	call   8016d8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801dca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dd1:	00 
  801dd2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dd6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ddd:	e8 8e f8 ff ff       	call   801670 <ipc_recv>
}
  801de2:	83 c4 10             	add    $0x10,%esp
  801de5:	5b                   	pop    %ebx
  801de6:	5e                   	pop    %esi
  801de7:	5d                   	pop    %ebp
  801de8:	c3                   	ret    

00801de9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801def:	8b 45 08             	mov    0x8(%ebp),%eax
  801df2:	8b 40 0c             	mov    0xc(%eax),%eax
  801df5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e02:	ba 00 00 00 00       	mov    $0x0,%edx
  801e07:	b8 02 00 00 00       	mov    $0x2,%eax
  801e0c:	e8 72 ff ff ff       	call   801d83 <fsipc>
}
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e19:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e1f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e24:	ba 00 00 00 00       	mov    $0x0,%edx
  801e29:	b8 06 00 00 00       	mov    $0x6,%eax
  801e2e:	e8 50 ff ff ff       	call   801d83 <fsipc>
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	53                   	push   %ebx
  801e39:	83 ec 14             	sub    $0x14,%esp
  801e3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	8b 40 0c             	mov    0xc(%eax),%eax
  801e45:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e4f:	b8 05 00 00 00       	mov    $0x5,%eax
  801e54:	e8 2a ff ff ff       	call   801d83 <fsipc>
  801e59:	89 c2                	mov    %eax,%edx
  801e5b:	85 d2                	test   %edx,%edx
  801e5d:	78 2b                	js     801e8a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e5f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e66:	00 
  801e67:	89 1c 24             	mov    %ebx,(%esp)
  801e6a:	e8 98 f0 ff ff       	call   800f07 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e6f:	a1 80 60 80 00       	mov    0x806080,%eax
  801e74:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e7a:	a1 84 60 80 00       	mov    0x806084,%eax
  801e7f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8a:	83 c4 14             	add    $0x14,%esp
  801e8d:	5b                   	pop    %ebx
  801e8e:	5d                   	pop    %ebp
  801e8f:	c3                   	ret    

00801e90 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	53                   	push   %ebx
  801e94:	83 ec 14             	sub    $0x14,%esp
  801e97:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9d:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801ea5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801eab:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801eb0:	0f 46 c3             	cmovbe %ebx,%eax
  801eb3:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801eb8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ebf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec3:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801eca:	e8 d5 f1 ff ff       	call   8010a4 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ecf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed4:	b8 04 00 00 00       	mov    $0x4,%eax
  801ed9:	e8 a5 fe ff ff       	call   801d83 <fsipc>
  801ede:	85 c0                	test   %eax,%eax
  801ee0:	78 53                	js     801f35 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801ee2:	39 c3                	cmp    %eax,%ebx
  801ee4:	73 24                	jae    801f0a <devfile_write+0x7a>
  801ee6:	c7 44 24 0c 80 35 80 	movl   $0x803580,0xc(%esp)
  801eed:	00 
  801eee:	c7 44 24 08 87 35 80 	movl   $0x803587,0x8(%esp)
  801ef5:	00 
  801ef6:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801efd:	00 
  801efe:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  801f05:	e8 da e8 ff ff       	call   8007e4 <_panic>
	assert(r <= PGSIZE);
  801f0a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f0f:	7e 24                	jle    801f35 <devfile_write+0xa5>
  801f11:	c7 44 24 0c a7 35 80 	movl   $0x8035a7,0xc(%esp)
  801f18:	00 
  801f19:	c7 44 24 08 87 35 80 	movl   $0x803587,0x8(%esp)
  801f20:	00 
  801f21:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801f28:	00 
  801f29:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  801f30:	e8 af e8 ff ff       	call   8007e4 <_panic>
	return r;
}
  801f35:	83 c4 14             	add    $0x14,%esp
  801f38:	5b                   	pop    %ebx
  801f39:	5d                   	pop    %ebp
  801f3a:	c3                   	ret    

00801f3b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	56                   	push   %esi
  801f3f:	53                   	push   %ebx
  801f40:	83 ec 10             	sub    $0x10,%esp
  801f43:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f46:	8b 45 08             	mov    0x8(%ebp),%eax
  801f49:	8b 40 0c             	mov    0xc(%eax),%eax
  801f4c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f51:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f57:	ba 00 00 00 00       	mov    $0x0,%edx
  801f5c:	b8 03 00 00 00       	mov    $0x3,%eax
  801f61:	e8 1d fe ff ff       	call   801d83 <fsipc>
  801f66:	89 c3                	mov    %eax,%ebx
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	78 6a                	js     801fd6 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801f6c:	39 c6                	cmp    %eax,%esi
  801f6e:	73 24                	jae    801f94 <devfile_read+0x59>
  801f70:	c7 44 24 0c 80 35 80 	movl   $0x803580,0xc(%esp)
  801f77:	00 
  801f78:	c7 44 24 08 87 35 80 	movl   $0x803587,0x8(%esp)
  801f7f:	00 
  801f80:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801f87:	00 
  801f88:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  801f8f:	e8 50 e8 ff ff       	call   8007e4 <_panic>
	assert(r <= PGSIZE);
  801f94:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f99:	7e 24                	jle    801fbf <devfile_read+0x84>
  801f9b:	c7 44 24 0c a7 35 80 	movl   $0x8035a7,0xc(%esp)
  801fa2:	00 
  801fa3:	c7 44 24 08 87 35 80 	movl   $0x803587,0x8(%esp)
  801faa:	00 
  801fab:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801fb2:	00 
  801fb3:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  801fba:	e8 25 e8 ff ff       	call   8007e4 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801fbf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fc3:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801fca:	00 
  801fcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fce:	89 04 24             	mov    %eax,(%esp)
  801fd1:	e8 ce f0 ff ff       	call   8010a4 <memmove>
	return r;
}
  801fd6:	89 d8                	mov    %ebx,%eax
  801fd8:	83 c4 10             	add    $0x10,%esp
  801fdb:	5b                   	pop    %ebx
  801fdc:	5e                   	pop    %esi
  801fdd:	5d                   	pop    %ebp
  801fde:	c3                   	ret    

00801fdf <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	53                   	push   %ebx
  801fe3:	83 ec 24             	sub    $0x24,%esp
  801fe6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801fe9:	89 1c 24             	mov    %ebx,(%esp)
  801fec:	e8 df ee ff ff       	call   800ed0 <strlen>
  801ff1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ff6:	7f 60                	jg     802058 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801ff8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ffb:	89 04 24             	mov    %eax,(%esp)
  801ffe:	e8 c4 f7 ff ff       	call   8017c7 <fd_alloc>
  802003:	89 c2                	mov    %eax,%edx
  802005:	85 d2                	test   %edx,%edx
  802007:	78 54                	js     80205d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  802009:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80200d:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  802014:	e8 ee ee ff ff       	call   800f07 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201c:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802021:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802024:	b8 01 00 00 00       	mov    $0x1,%eax
  802029:	e8 55 fd ff ff       	call   801d83 <fsipc>
  80202e:	89 c3                	mov    %eax,%ebx
  802030:	85 c0                	test   %eax,%eax
  802032:	79 17                	jns    80204b <open+0x6c>
		fd_close(fd, 0);
  802034:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80203b:	00 
  80203c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203f:	89 04 24             	mov    %eax,(%esp)
  802042:	e8 7f f8 ff ff       	call   8018c6 <fd_close>
		return r;
  802047:	89 d8                	mov    %ebx,%eax
  802049:	eb 12                	jmp    80205d <open+0x7e>
	}

	return fd2num(fd);
  80204b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204e:	89 04 24             	mov    %eax,(%esp)
  802051:	e8 4a f7 ff ff       	call   8017a0 <fd2num>
  802056:	eb 05                	jmp    80205d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  802058:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80205d:	83 c4 24             	add    $0x24,%esp
  802060:	5b                   	pop    %ebx
  802061:	5d                   	pop    %ebp
  802062:	c3                   	ret    

00802063 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802069:	ba 00 00 00 00       	mov    $0x0,%edx
  80206e:	b8 08 00 00 00       	mov    $0x8,%eax
  802073:	e8 0b fd ff ff       	call   801d83 <fsipc>
}
  802078:	c9                   	leave  
  802079:	c3                   	ret    
  80207a:	66 90                	xchg   %ax,%ax
  80207c:	66 90                	xchg   %ax,%ax
  80207e:	66 90                	xchg   %ax,%ax

00802080 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802086:	c7 44 24 04 b3 35 80 	movl   $0x8035b3,0x4(%esp)
  80208d:	00 
  80208e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802091:	89 04 24             	mov    %eax,(%esp)
  802094:	e8 6e ee ff ff       	call   800f07 <strcpy>
	return 0;
}
  802099:	b8 00 00 00 00       	mov    $0x0,%eax
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	53                   	push   %ebx
  8020a4:	83 ec 14             	sub    $0x14,%esp
  8020a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8020aa:	89 1c 24             	mov    %ebx,(%esp)
  8020ad:	e8 04 0a 00 00       	call   802ab6 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8020b2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8020b7:	83 f8 01             	cmp    $0x1,%eax
  8020ba:	75 0d                	jne    8020c9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8020bc:	8b 43 0c             	mov    0xc(%ebx),%eax
  8020bf:	89 04 24             	mov    %eax,(%esp)
  8020c2:	e8 29 03 00 00       	call   8023f0 <nsipc_close>
  8020c7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8020c9:	89 d0                	mov    %edx,%eax
  8020cb:	83 c4 14             	add    $0x14,%esp
  8020ce:	5b                   	pop    %ebx
  8020cf:	5d                   	pop    %ebp
  8020d0:	c3                   	ret    

008020d1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020d7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020de:	00 
  8020df:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8020f3:	89 04 24             	mov    %eax,(%esp)
  8020f6:	e8 f0 03 00 00       	call   8024eb <nsipc_send>
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802103:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80210a:	00 
  80210b:	8b 45 10             	mov    0x10(%ebp),%eax
  80210e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802112:	8b 45 0c             	mov    0xc(%ebp),%eax
  802115:	89 44 24 04          	mov    %eax,0x4(%esp)
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	8b 40 0c             	mov    0xc(%eax),%eax
  80211f:	89 04 24             	mov    %eax,(%esp)
  802122:	e8 44 03 00 00       	call   80246b <nsipc_recv>
}
  802127:	c9                   	leave  
  802128:	c3                   	ret    

00802129 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
  80212c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80212f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802132:	89 54 24 04          	mov    %edx,0x4(%esp)
  802136:	89 04 24             	mov    %eax,(%esp)
  802139:	e8 d8 f6 ff ff       	call   801816 <fd_lookup>
  80213e:	85 c0                	test   %eax,%eax
  802140:	78 17                	js     802159 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802145:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  80214b:	39 08                	cmp    %ecx,(%eax)
  80214d:	75 05                	jne    802154 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80214f:	8b 40 0c             	mov    0xc(%eax),%eax
  802152:	eb 05                	jmp    802159 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802154:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802159:	c9                   	leave  
  80215a:	c3                   	ret    

0080215b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
  80215e:	56                   	push   %esi
  80215f:	53                   	push   %ebx
  802160:	83 ec 20             	sub    $0x20,%esp
  802163:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802165:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802168:	89 04 24             	mov    %eax,(%esp)
  80216b:	e8 57 f6 ff ff       	call   8017c7 <fd_alloc>
  802170:	89 c3                	mov    %eax,%ebx
  802172:	85 c0                	test   %eax,%eax
  802174:	78 21                	js     802197 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802176:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80217d:	00 
  80217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802181:	89 44 24 04          	mov    %eax,0x4(%esp)
  802185:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80218c:	e8 92 f1 ff ff       	call   801323 <sys_page_alloc>
  802191:	89 c3                	mov    %eax,%ebx
  802193:	85 c0                	test   %eax,%eax
  802195:	79 0c                	jns    8021a3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802197:	89 34 24             	mov    %esi,(%esp)
  80219a:	e8 51 02 00 00       	call   8023f0 <nsipc_close>
		return r;
  80219f:	89 d8                	mov    %ebx,%eax
  8021a1:	eb 20                	jmp    8021c3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8021a3:	8b 15 24 40 80 00    	mov    0x804024,%edx
  8021a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ac:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8021ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8021b8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8021bb:	89 14 24             	mov    %edx,(%esp)
  8021be:	e8 dd f5 ff ff       	call   8017a0 <fd2num>
}
  8021c3:	83 c4 20             	add    $0x20,%esp
  8021c6:	5b                   	pop    %ebx
  8021c7:	5e                   	pop    %esi
  8021c8:	5d                   	pop    %ebp
  8021c9:	c3                   	ret    

008021ca <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	e8 51 ff ff ff       	call   802129 <fd2sockid>
		return r;
  8021d8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021da:	85 c0                	test   %eax,%eax
  8021dc:	78 23                	js     802201 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021de:	8b 55 10             	mov    0x10(%ebp),%edx
  8021e1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021ec:	89 04 24             	mov    %eax,(%esp)
  8021ef:	e8 45 01 00 00       	call   802339 <nsipc_accept>
		return r;
  8021f4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	78 07                	js     802201 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8021fa:	e8 5c ff ff ff       	call   80215b <alloc_sockfd>
  8021ff:	89 c1                	mov    %eax,%ecx
}
  802201:	89 c8                	mov    %ecx,%eax
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	e8 16 ff ff ff       	call   802129 <fd2sockid>
  802213:	89 c2                	mov    %eax,%edx
  802215:	85 d2                	test   %edx,%edx
  802217:	78 16                	js     80222f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802219:	8b 45 10             	mov    0x10(%ebp),%eax
  80221c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802220:	8b 45 0c             	mov    0xc(%ebp),%eax
  802223:	89 44 24 04          	mov    %eax,0x4(%esp)
  802227:	89 14 24             	mov    %edx,(%esp)
  80222a:	e8 60 01 00 00       	call   80238f <nsipc_bind>
}
  80222f:	c9                   	leave  
  802230:	c3                   	ret    

00802231 <shutdown>:

int
shutdown(int s, int how)
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
  802234:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	e8 ea fe ff ff       	call   802129 <fd2sockid>
  80223f:	89 c2                	mov    %eax,%edx
  802241:	85 d2                	test   %edx,%edx
  802243:	78 0f                	js     802254 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802245:	8b 45 0c             	mov    0xc(%ebp),%eax
  802248:	89 44 24 04          	mov    %eax,0x4(%esp)
  80224c:	89 14 24             	mov    %edx,(%esp)
  80224f:	e8 7a 01 00 00       	call   8023ce <nsipc_shutdown>
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	e8 c5 fe ff ff       	call   802129 <fd2sockid>
  802264:	89 c2                	mov    %eax,%edx
  802266:	85 d2                	test   %edx,%edx
  802268:	78 16                	js     802280 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80226a:	8b 45 10             	mov    0x10(%ebp),%eax
  80226d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802271:	8b 45 0c             	mov    0xc(%ebp),%eax
  802274:	89 44 24 04          	mov    %eax,0x4(%esp)
  802278:	89 14 24             	mov    %edx,(%esp)
  80227b:	e8 8a 01 00 00       	call   80240a <nsipc_connect>
}
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <listen>:

int
listen(int s, int backlog)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	e8 99 fe ff ff       	call   802129 <fd2sockid>
  802290:	89 c2                	mov    %eax,%edx
  802292:	85 d2                	test   %edx,%edx
  802294:	78 0f                	js     8022a5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802296:	8b 45 0c             	mov    0xc(%ebp),%eax
  802299:	89 44 24 04          	mov    %eax,0x4(%esp)
  80229d:	89 14 24             	mov    %edx,(%esp)
  8022a0:	e8 a4 01 00 00       	call   802449 <nsipc_listen>
}
  8022a5:	c9                   	leave  
  8022a6:	c3                   	ret    

008022a7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
  8022aa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8022ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	89 04 24             	mov    %eax,(%esp)
  8022c1:	e8 98 02 00 00       	call   80255e <nsipc_socket>
  8022c6:	89 c2                	mov    %eax,%edx
  8022c8:	85 d2                	test   %edx,%edx
  8022ca:	78 05                	js     8022d1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8022cc:	e8 8a fe ff ff       	call   80215b <alloc_sockfd>
}
  8022d1:	c9                   	leave  
  8022d2:	c3                   	ret    

008022d3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
  8022d6:	53                   	push   %ebx
  8022d7:	83 ec 14             	sub    $0x14,%esp
  8022da:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8022dc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8022e3:	75 11                	jne    8022f6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022e5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8022ec:	e8 74 f4 ff ff       	call   801765 <ipc_find_env>
  8022f1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022f6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8022fd:	00 
  8022fe:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802305:	00 
  802306:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80230a:	a1 04 50 80 00       	mov    0x805004,%eax
  80230f:	89 04 24             	mov    %eax,(%esp)
  802312:	e8 c1 f3 ff ff       	call   8016d8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802317:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80231e:	00 
  80231f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802326:	00 
  802327:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80232e:	e8 3d f3 ff ff       	call   801670 <ipc_recv>
}
  802333:	83 c4 14             	add    $0x14,%esp
  802336:	5b                   	pop    %ebx
  802337:	5d                   	pop    %ebp
  802338:	c3                   	ret    

00802339 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
  80233c:	56                   	push   %esi
  80233d:	53                   	push   %ebx
  80233e:	83 ec 10             	sub    $0x10,%esp
  802341:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80234c:	8b 06                	mov    (%esi),%eax
  80234e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802353:	b8 01 00 00 00       	mov    $0x1,%eax
  802358:	e8 76 ff ff ff       	call   8022d3 <nsipc>
  80235d:	89 c3                	mov    %eax,%ebx
  80235f:	85 c0                	test   %eax,%eax
  802361:	78 23                	js     802386 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802363:	a1 10 70 80 00       	mov    0x807010,%eax
  802368:	89 44 24 08          	mov    %eax,0x8(%esp)
  80236c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802373:	00 
  802374:	8b 45 0c             	mov    0xc(%ebp),%eax
  802377:	89 04 24             	mov    %eax,(%esp)
  80237a:	e8 25 ed ff ff       	call   8010a4 <memmove>
		*addrlen = ret->ret_addrlen;
  80237f:	a1 10 70 80 00       	mov    0x807010,%eax
  802384:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802386:	89 d8                	mov    %ebx,%eax
  802388:	83 c4 10             	add    $0x10,%esp
  80238b:	5b                   	pop    %ebx
  80238c:	5e                   	pop    %esi
  80238d:	5d                   	pop    %ebp
  80238e:	c3                   	ret    

0080238f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
  802392:	53                   	push   %ebx
  802393:	83 ec 14             	sub    $0x14,%esp
  802396:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8023a1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ac:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8023b3:	e8 ec ec ff ff       	call   8010a4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8023b8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8023be:	b8 02 00 00 00       	mov    $0x2,%eax
  8023c3:	e8 0b ff ff ff       	call   8022d3 <nsipc>
}
  8023c8:	83 c4 14             	add    $0x14,%esp
  8023cb:	5b                   	pop    %ebx
  8023cc:	5d                   	pop    %ebp
  8023cd:	c3                   	ret    

008023ce <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
  8023d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8023d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8023dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023df:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8023e4:	b8 03 00 00 00       	mov    $0x3,%eax
  8023e9:	e8 e5 fe ff ff       	call   8022d3 <nsipc>
}
  8023ee:	c9                   	leave  
  8023ef:	c3                   	ret    

008023f0 <nsipc_close>:

int
nsipc_close(int s)
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
  8023f3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8023fe:	b8 04 00 00 00       	mov    $0x4,%eax
  802403:	e8 cb fe ff ff       	call   8022d3 <nsipc>
}
  802408:	c9                   	leave  
  802409:	c3                   	ret    

0080240a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80240a:	55                   	push   %ebp
  80240b:	89 e5                	mov    %esp,%ebp
  80240d:	53                   	push   %ebx
  80240e:	83 ec 14             	sub    $0x14,%esp
  802411:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80241c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802420:	8b 45 0c             	mov    0xc(%ebp),%eax
  802423:	89 44 24 04          	mov    %eax,0x4(%esp)
  802427:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80242e:	e8 71 ec ff ff       	call   8010a4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802433:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802439:	b8 05 00 00 00       	mov    $0x5,%eax
  80243e:	e8 90 fe ff ff       	call   8022d3 <nsipc>
}
  802443:	83 c4 14             	add    $0x14,%esp
  802446:	5b                   	pop    %ebx
  802447:	5d                   	pop    %ebp
  802448:	c3                   	ret    

00802449 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
  80244c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80244f:	8b 45 08             	mov    0x8(%ebp),%eax
  802452:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80245f:	b8 06 00 00 00       	mov    $0x6,%eax
  802464:	e8 6a fe ff ff       	call   8022d3 <nsipc>
}
  802469:	c9                   	leave  
  80246a:	c3                   	ret    

0080246b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80246b:	55                   	push   %ebp
  80246c:	89 e5                	mov    %esp,%ebp
  80246e:	56                   	push   %esi
  80246f:	53                   	push   %ebx
  802470:	83 ec 10             	sub    $0x10,%esp
  802473:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80247e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802484:	8b 45 14             	mov    0x14(%ebp),%eax
  802487:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80248c:	b8 07 00 00 00       	mov    $0x7,%eax
  802491:	e8 3d fe ff ff       	call   8022d3 <nsipc>
  802496:	89 c3                	mov    %eax,%ebx
  802498:	85 c0                	test   %eax,%eax
  80249a:	78 46                	js     8024e2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80249c:	39 f0                	cmp    %esi,%eax
  80249e:	7f 07                	jg     8024a7 <nsipc_recv+0x3c>
  8024a0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8024a5:	7e 24                	jle    8024cb <nsipc_recv+0x60>
  8024a7:	c7 44 24 0c bf 35 80 	movl   $0x8035bf,0xc(%esp)
  8024ae:	00 
  8024af:	c7 44 24 08 87 35 80 	movl   $0x803587,0x8(%esp)
  8024b6:	00 
  8024b7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8024be:	00 
  8024bf:	c7 04 24 d4 35 80 00 	movl   $0x8035d4,(%esp)
  8024c6:	e8 19 e3 ff ff       	call   8007e4 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8024cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024cf:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8024d6:	00 
  8024d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024da:	89 04 24             	mov    %eax,(%esp)
  8024dd:	e8 c2 eb ff ff       	call   8010a4 <memmove>
	}

	return r;
}
  8024e2:	89 d8                	mov    %ebx,%eax
  8024e4:	83 c4 10             	add    $0x10,%esp
  8024e7:	5b                   	pop    %ebx
  8024e8:	5e                   	pop    %esi
  8024e9:	5d                   	pop    %ebp
  8024ea:	c3                   	ret    

008024eb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
  8024ee:	53                   	push   %ebx
  8024ef:	83 ec 14             	sub    $0x14,%esp
  8024f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8024f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8024fd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802503:	7e 24                	jle    802529 <nsipc_send+0x3e>
  802505:	c7 44 24 0c e0 35 80 	movl   $0x8035e0,0xc(%esp)
  80250c:	00 
  80250d:	c7 44 24 08 87 35 80 	movl   $0x803587,0x8(%esp)
  802514:	00 
  802515:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80251c:	00 
  80251d:	c7 04 24 d4 35 80 00 	movl   $0x8035d4,(%esp)
  802524:	e8 bb e2 ff ff       	call   8007e4 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802529:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80252d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802530:	89 44 24 04          	mov    %eax,0x4(%esp)
  802534:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80253b:	e8 64 eb ff ff       	call   8010a4 <memmove>
	nsipcbuf.send.req_size = size;
  802540:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802546:	8b 45 14             	mov    0x14(%ebp),%eax
  802549:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80254e:	b8 08 00 00 00       	mov    $0x8,%eax
  802553:	e8 7b fd ff ff       	call   8022d3 <nsipc>
}
  802558:	83 c4 14             	add    $0x14,%esp
  80255b:	5b                   	pop    %ebx
  80255c:	5d                   	pop    %ebp
  80255d:	c3                   	ret    

0080255e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80255e:	55                   	push   %ebp
  80255f:	89 e5                	mov    %esp,%ebp
  802561:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802564:	8b 45 08             	mov    0x8(%ebp),%eax
  802567:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80256c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80256f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802574:	8b 45 10             	mov    0x10(%ebp),%eax
  802577:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80257c:	b8 09 00 00 00       	mov    $0x9,%eax
  802581:	e8 4d fd ff ff       	call   8022d3 <nsipc>
}
  802586:	c9                   	leave  
  802587:	c3                   	ret    

00802588 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802588:	55                   	push   %ebp
  802589:	89 e5                	mov    %esp,%ebp
  80258b:	56                   	push   %esi
  80258c:	53                   	push   %ebx
  80258d:	83 ec 10             	sub    $0x10,%esp
  802590:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802593:	8b 45 08             	mov    0x8(%ebp),%eax
  802596:	89 04 24             	mov    %eax,(%esp)
  802599:	e8 12 f2 ff ff       	call   8017b0 <fd2data>
  80259e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8025a0:	c7 44 24 04 ec 35 80 	movl   $0x8035ec,0x4(%esp)
  8025a7:	00 
  8025a8:	89 1c 24             	mov    %ebx,(%esp)
  8025ab:	e8 57 e9 ff ff       	call   800f07 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8025b0:	8b 46 04             	mov    0x4(%esi),%eax
  8025b3:	2b 06                	sub    (%esi),%eax
  8025b5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8025bb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8025c2:	00 00 00 
	stat->st_dev = &devpipe;
  8025c5:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  8025cc:	40 80 00 
	return 0;
}
  8025cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d4:	83 c4 10             	add    $0x10,%esp
  8025d7:	5b                   	pop    %ebx
  8025d8:	5e                   	pop    %esi
  8025d9:	5d                   	pop    %ebp
  8025da:	c3                   	ret    

008025db <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8025db:	55                   	push   %ebp
  8025dc:	89 e5                	mov    %esp,%ebp
  8025de:	53                   	push   %ebx
  8025df:	83 ec 14             	sub    $0x14,%esp
  8025e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8025e5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025f0:	e8 d5 ed ff ff       	call   8013ca <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8025f5:	89 1c 24             	mov    %ebx,(%esp)
  8025f8:	e8 b3 f1 ff ff       	call   8017b0 <fd2data>
  8025fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802601:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802608:	e8 bd ed ff ff       	call   8013ca <sys_page_unmap>
}
  80260d:	83 c4 14             	add    $0x14,%esp
  802610:	5b                   	pop    %ebx
  802611:	5d                   	pop    %ebp
  802612:	c3                   	ret    

00802613 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
  802616:	57                   	push   %edi
  802617:	56                   	push   %esi
  802618:	53                   	push   %ebx
  802619:	83 ec 2c             	sub    $0x2c,%esp
  80261c:	89 c6                	mov    %eax,%esi
  80261e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802621:	a1 08 50 80 00       	mov    0x805008,%eax
  802626:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802629:	89 34 24             	mov    %esi,(%esp)
  80262c:	e8 85 04 00 00       	call   802ab6 <pageref>
  802631:	89 c7                	mov    %eax,%edi
  802633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802636:	89 04 24             	mov    %eax,(%esp)
  802639:	e8 78 04 00 00       	call   802ab6 <pageref>
  80263e:	39 c7                	cmp    %eax,%edi
  802640:	0f 94 c2             	sete   %dl
  802643:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802646:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80264c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80264f:	39 fb                	cmp    %edi,%ebx
  802651:	74 21                	je     802674 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802653:	84 d2                	test   %dl,%dl
  802655:	74 ca                	je     802621 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802657:	8b 51 58             	mov    0x58(%ecx),%edx
  80265a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80265e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802662:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802666:	c7 04 24 f3 35 80 00 	movl   $0x8035f3,(%esp)
  80266d:	e8 6b e2 ff ff       	call   8008dd <cprintf>
  802672:	eb ad                	jmp    802621 <_pipeisclosed+0xe>
	}
}
  802674:	83 c4 2c             	add    $0x2c,%esp
  802677:	5b                   	pop    %ebx
  802678:	5e                   	pop    %esi
  802679:	5f                   	pop    %edi
  80267a:	5d                   	pop    %ebp
  80267b:	c3                   	ret    

0080267c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
  80267f:	57                   	push   %edi
  802680:	56                   	push   %esi
  802681:	53                   	push   %ebx
  802682:	83 ec 1c             	sub    $0x1c,%esp
  802685:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802688:	89 34 24             	mov    %esi,(%esp)
  80268b:	e8 20 f1 ff ff       	call   8017b0 <fd2data>
  802690:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802692:	bf 00 00 00 00       	mov    $0x0,%edi
  802697:	eb 45                	jmp    8026de <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802699:	89 da                	mov    %ebx,%edx
  80269b:	89 f0                	mov    %esi,%eax
  80269d:	e8 71 ff ff ff       	call   802613 <_pipeisclosed>
  8026a2:	85 c0                	test   %eax,%eax
  8026a4:	75 41                	jne    8026e7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8026a6:	e8 59 ec ff ff       	call   801304 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8026ab:	8b 43 04             	mov    0x4(%ebx),%eax
  8026ae:	8b 0b                	mov    (%ebx),%ecx
  8026b0:	8d 51 20             	lea    0x20(%ecx),%edx
  8026b3:	39 d0                	cmp    %edx,%eax
  8026b5:	73 e2                	jae    802699 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8026b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026ba:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8026be:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8026c1:	99                   	cltd   
  8026c2:	c1 ea 1b             	shr    $0x1b,%edx
  8026c5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8026c8:	83 e1 1f             	and    $0x1f,%ecx
  8026cb:	29 d1                	sub    %edx,%ecx
  8026cd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8026d1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8026d5:	83 c0 01             	add    $0x1,%eax
  8026d8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026db:	83 c7 01             	add    $0x1,%edi
  8026de:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8026e1:	75 c8                	jne    8026ab <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8026e3:	89 f8                	mov    %edi,%eax
  8026e5:	eb 05                	jmp    8026ec <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8026e7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8026ec:	83 c4 1c             	add    $0x1c,%esp
  8026ef:	5b                   	pop    %ebx
  8026f0:	5e                   	pop    %esi
  8026f1:	5f                   	pop    %edi
  8026f2:	5d                   	pop    %ebp
  8026f3:	c3                   	ret    

008026f4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8026f4:	55                   	push   %ebp
  8026f5:	89 e5                	mov    %esp,%ebp
  8026f7:	57                   	push   %edi
  8026f8:	56                   	push   %esi
  8026f9:	53                   	push   %ebx
  8026fa:	83 ec 1c             	sub    $0x1c,%esp
  8026fd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802700:	89 3c 24             	mov    %edi,(%esp)
  802703:	e8 a8 f0 ff ff       	call   8017b0 <fd2data>
  802708:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80270a:	be 00 00 00 00       	mov    $0x0,%esi
  80270f:	eb 3d                	jmp    80274e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802711:	85 f6                	test   %esi,%esi
  802713:	74 04                	je     802719 <devpipe_read+0x25>
				return i;
  802715:	89 f0                	mov    %esi,%eax
  802717:	eb 43                	jmp    80275c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802719:	89 da                	mov    %ebx,%edx
  80271b:	89 f8                	mov    %edi,%eax
  80271d:	e8 f1 fe ff ff       	call   802613 <_pipeisclosed>
  802722:	85 c0                	test   %eax,%eax
  802724:	75 31                	jne    802757 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802726:	e8 d9 eb ff ff       	call   801304 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80272b:	8b 03                	mov    (%ebx),%eax
  80272d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802730:	74 df                	je     802711 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802732:	99                   	cltd   
  802733:	c1 ea 1b             	shr    $0x1b,%edx
  802736:	01 d0                	add    %edx,%eax
  802738:	83 e0 1f             	and    $0x1f,%eax
  80273b:	29 d0                	sub    %edx,%eax
  80273d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802742:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802745:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802748:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80274b:	83 c6 01             	add    $0x1,%esi
  80274e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802751:	75 d8                	jne    80272b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802753:	89 f0                	mov    %esi,%eax
  802755:	eb 05                	jmp    80275c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802757:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80275c:	83 c4 1c             	add    $0x1c,%esp
  80275f:	5b                   	pop    %ebx
  802760:	5e                   	pop    %esi
  802761:	5f                   	pop    %edi
  802762:	5d                   	pop    %ebp
  802763:	c3                   	ret    

00802764 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802764:	55                   	push   %ebp
  802765:	89 e5                	mov    %esp,%ebp
  802767:	56                   	push   %esi
  802768:	53                   	push   %ebx
  802769:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80276c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80276f:	89 04 24             	mov    %eax,(%esp)
  802772:	e8 50 f0 ff ff       	call   8017c7 <fd_alloc>
  802777:	89 c2                	mov    %eax,%edx
  802779:	85 d2                	test   %edx,%edx
  80277b:	0f 88 4d 01 00 00    	js     8028ce <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802781:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802788:	00 
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802790:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802797:	e8 87 eb ff ff       	call   801323 <sys_page_alloc>
  80279c:	89 c2                	mov    %eax,%edx
  80279e:	85 d2                	test   %edx,%edx
  8027a0:	0f 88 28 01 00 00    	js     8028ce <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8027a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8027a9:	89 04 24             	mov    %eax,(%esp)
  8027ac:	e8 16 f0 ff ff       	call   8017c7 <fd_alloc>
  8027b1:	89 c3                	mov    %eax,%ebx
  8027b3:	85 c0                	test   %eax,%eax
  8027b5:	0f 88 fe 00 00 00    	js     8028b9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027bb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027c2:	00 
  8027c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027d1:	e8 4d eb ff ff       	call   801323 <sys_page_alloc>
  8027d6:	89 c3                	mov    %eax,%ebx
  8027d8:	85 c0                	test   %eax,%eax
  8027da:	0f 88 d9 00 00 00    	js     8028b9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e3:	89 04 24             	mov    %eax,(%esp)
  8027e6:	e8 c5 ef ff ff       	call   8017b0 <fd2data>
  8027eb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027ed:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027f4:	00 
  8027f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802800:	e8 1e eb ff ff       	call   801323 <sys_page_alloc>
  802805:	89 c3                	mov    %eax,%ebx
  802807:	85 c0                	test   %eax,%eax
  802809:	0f 88 97 00 00 00    	js     8028a6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80280f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802812:	89 04 24             	mov    %eax,(%esp)
  802815:	e8 96 ef ff ff       	call   8017b0 <fd2data>
  80281a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802821:	00 
  802822:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802826:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80282d:	00 
  80282e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802832:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802839:	e8 39 eb ff ff       	call   801377 <sys_page_map>
  80283e:	89 c3                	mov    %eax,%ebx
  802840:	85 c0                	test   %eax,%eax
  802842:	78 52                	js     802896 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802844:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802859:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80285f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802862:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802867:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	89 04 24             	mov    %eax,(%esp)
  802874:	e8 27 ef ff ff       	call   8017a0 <fd2num>
  802879:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80287c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80287e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802881:	89 04 24             	mov    %eax,(%esp)
  802884:	e8 17 ef ff ff       	call   8017a0 <fd2num>
  802889:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80288c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80288f:	b8 00 00 00 00       	mov    $0x0,%eax
  802894:	eb 38                	jmp    8028ce <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802896:	89 74 24 04          	mov    %esi,0x4(%esp)
  80289a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028a1:	e8 24 eb ff ff       	call   8013ca <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8028a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028b4:	e8 11 eb ff ff       	call   8013ca <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028c7:	e8 fe ea ff ff       	call   8013ca <sys_page_unmap>
  8028cc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8028ce:	83 c4 30             	add    $0x30,%esp
  8028d1:	5b                   	pop    %ebx
  8028d2:	5e                   	pop    %esi
  8028d3:	5d                   	pop    %ebp
  8028d4:	c3                   	ret    

008028d5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8028d5:	55                   	push   %ebp
  8028d6:	89 e5                	mov    %esp,%ebp
  8028d8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e5:	89 04 24             	mov    %eax,(%esp)
  8028e8:	e8 29 ef ff ff       	call   801816 <fd_lookup>
  8028ed:	89 c2                	mov    %eax,%edx
  8028ef:	85 d2                	test   %edx,%edx
  8028f1:	78 15                	js     802908 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	89 04 24             	mov    %eax,(%esp)
  8028f9:	e8 b2 ee ff ff       	call   8017b0 <fd2data>
	return _pipeisclosed(fd, p);
  8028fe:	89 c2                	mov    %eax,%edx
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	e8 0b fd ff ff       	call   802613 <_pipeisclosed>
}
  802908:	c9                   	leave  
  802909:	c3                   	ret    
  80290a:	66 90                	xchg   %ax,%ax
  80290c:	66 90                	xchg   %ax,%ax
  80290e:	66 90                	xchg   %ax,%ax

00802910 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802910:	55                   	push   %ebp
  802911:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802913:	b8 00 00 00 00       	mov    $0x0,%eax
  802918:	5d                   	pop    %ebp
  802919:	c3                   	ret    

0080291a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80291a:	55                   	push   %ebp
  80291b:	89 e5                	mov    %esp,%ebp
  80291d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802920:	c7 44 24 04 0b 36 80 	movl   $0x80360b,0x4(%esp)
  802927:	00 
  802928:	8b 45 0c             	mov    0xc(%ebp),%eax
  80292b:	89 04 24             	mov    %eax,(%esp)
  80292e:	e8 d4 e5 ff ff       	call   800f07 <strcpy>
	return 0;
}
  802933:	b8 00 00 00 00       	mov    $0x0,%eax
  802938:	c9                   	leave  
  802939:	c3                   	ret    

0080293a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80293a:	55                   	push   %ebp
  80293b:	89 e5                	mov    %esp,%ebp
  80293d:	57                   	push   %edi
  80293e:	56                   	push   %esi
  80293f:	53                   	push   %ebx
  802940:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802946:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80294b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802951:	eb 31                	jmp    802984 <devcons_write+0x4a>
		m = n - tot;
  802953:	8b 75 10             	mov    0x10(%ebp),%esi
  802956:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802958:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80295b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802960:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802963:	89 74 24 08          	mov    %esi,0x8(%esp)
  802967:	03 45 0c             	add    0xc(%ebp),%eax
  80296a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80296e:	89 3c 24             	mov    %edi,(%esp)
  802971:	e8 2e e7 ff ff       	call   8010a4 <memmove>
		sys_cputs(buf, m);
  802976:	89 74 24 04          	mov    %esi,0x4(%esp)
  80297a:	89 3c 24             	mov    %edi,(%esp)
  80297d:	e8 d4 e8 ff ff       	call   801256 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802982:	01 f3                	add    %esi,%ebx
  802984:	89 d8                	mov    %ebx,%eax
  802986:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802989:	72 c8                	jb     802953 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80298b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802991:	5b                   	pop    %ebx
  802992:	5e                   	pop    %esi
  802993:	5f                   	pop    %edi
  802994:	5d                   	pop    %ebp
  802995:	c3                   	ret    

00802996 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802996:	55                   	push   %ebp
  802997:	89 e5                	mov    %esp,%ebp
  802999:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80299c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8029a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8029a5:	75 07                	jne    8029ae <devcons_read+0x18>
  8029a7:	eb 2a                	jmp    8029d3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8029a9:	e8 56 e9 ff ff       	call   801304 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8029ae:	66 90                	xchg   %ax,%ax
  8029b0:	e8 bf e8 ff ff       	call   801274 <sys_cgetc>
  8029b5:	85 c0                	test   %eax,%eax
  8029b7:	74 f0                	je     8029a9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8029b9:	85 c0                	test   %eax,%eax
  8029bb:	78 16                	js     8029d3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8029bd:	83 f8 04             	cmp    $0x4,%eax
  8029c0:	74 0c                	je     8029ce <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8029c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029c5:	88 02                	mov    %al,(%edx)
	return 1;
  8029c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8029cc:	eb 05                	jmp    8029d3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8029ce:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8029d3:	c9                   	leave  
  8029d4:	c3                   	ret    

008029d5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8029d5:	55                   	push   %ebp
  8029d6:	89 e5                	mov    %esp,%ebp
  8029d8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8029db:	8b 45 08             	mov    0x8(%ebp),%eax
  8029de:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8029e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8029e8:	00 
  8029e9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029ec:	89 04 24             	mov    %eax,(%esp)
  8029ef:	e8 62 e8 ff ff       	call   801256 <sys_cputs>
}
  8029f4:	c9                   	leave  
  8029f5:	c3                   	ret    

008029f6 <getchar>:

int
getchar(void)
{
  8029f6:	55                   	push   %ebp
  8029f7:	89 e5                	mov    %esp,%ebp
  8029f9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8029fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802a03:	00 
  802a04:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a07:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a12:	e8 93 f0 ff ff       	call   801aaa <read>
	if (r < 0)
  802a17:	85 c0                	test   %eax,%eax
  802a19:	78 0f                	js     802a2a <getchar+0x34>
		return r;
	if (r < 1)
  802a1b:	85 c0                	test   %eax,%eax
  802a1d:	7e 06                	jle    802a25 <getchar+0x2f>
		return -E_EOF;
	return c;
  802a1f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802a23:	eb 05                	jmp    802a2a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802a25:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802a2a:	c9                   	leave  
  802a2b:	c3                   	ret    

00802a2c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802a2c:	55                   	push   %ebp
  802a2d:	89 e5                	mov    %esp,%ebp
  802a2f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a32:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a35:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	89 04 24             	mov    %eax,(%esp)
  802a3f:	e8 d2 ed ff ff       	call   801816 <fd_lookup>
  802a44:	85 c0                	test   %eax,%eax
  802a46:	78 11                	js     802a59 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802a51:	39 10                	cmp    %edx,(%eax)
  802a53:	0f 94 c0             	sete   %al
  802a56:	0f b6 c0             	movzbl %al,%eax
}
  802a59:	c9                   	leave  
  802a5a:	c3                   	ret    

00802a5b <opencons>:

int
opencons(void)
{
  802a5b:	55                   	push   %ebp
  802a5c:	89 e5                	mov    %esp,%ebp
  802a5e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a61:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a64:	89 04 24             	mov    %eax,(%esp)
  802a67:	e8 5b ed ff ff       	call   8017c7 <fd_alloc>
		return r;
  802a6c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a6e:	85 c0                	test   %eax,%eax
  802a70:	78 40                	js     802ab2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a72:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a79:	00 
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a88:	e8 96 e8 ff ff       	call   801323 <sys_page_alloc>
		return r;
  802a8d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a8f:	85 c0                	test   %eax,%eax
  802a91:	78 1f                	js     802ab2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802a93:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802aa8:	89 04 24             	mov    %eax,(%esp)
  802aab:	e8 f0 ec ff ff       	call   8017a0 <fd2num>
  802ab0:	89 c2                	mov    %eax,%edx
}
  802ab2:	89 d0                	mov    %edx,%eax
  802ab4:	c9                   	leave  
  802ab5:	c3                   	ret    

00802ab6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802ab6:	55                   	push   %ebp
  802ab7:	89 e5                	mov    %esp,%ebp
  802ab9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802abc:	89 d0                	mov    %edx,%eax
  802abe:	c1 e8 16             	shr    $0x16,%eax
  802ac1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802ac8:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802acd:	f6 c1 01             	test   $0x1,%cl
  802ad0:	74 1d                	je     802aef <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802ad2:	c1 ea 0c             	shr    $0xc,%edx
  802ad5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802adc:	f6 c2 01             	test   $0x1,%dl
  802adf:	74 0e                	je     802aef <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802ae1:	c1 ea 0c             	shr    $0xc,%edx
  802ae4:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802aeb:	ef 
  802aec:	0f b7 c0             	movzwl %ax,%eax
}
  802aef:	5d                   	pop    %ebp
  802af0:	c3                   	ret    
  802af1:	66 90                	xchg   %ax,%ax
  802af3:	66 90                	xchg   %ax,%ax
  802af5:	66 90                	xchg   %ax,%ax
  802af7:	66 90                	xchg   %ax,%ax
  802af9:	66 90                	xchg   %ax,%ax
  802afb:	66 90                	xchg   %ax,%ax
  802afd:	66 90                	xchg   %ax,%ax
  802aff:	90                   	nop

00802b00 <__udivdi3>:
  802b00:	55                   	push   %ebp
  802b01:	57                   	push   %edi
  802b02:	56                   	push   %esi
  802b03:	83 ec 0c             	sub    $0xc,%esp
  802b06:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b0a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802b0e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802b12:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b16:	85 c0                	test   %eax,%eax
  802b18:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802b1c:	89 ea                	mov    %ebp,%edx
  802b1e:	89 0c 24             	mov    %ecx,(%esp)
  802b21:	75 2d                	jne    802b50 <__udivdi3+0x50>
  802b23:	39 e9                	cmp    %ebp,%ecx
  802b25:	77 61                	ja     802b88 <__udivdi3+0x88>
  802b27:	85 c9                	test   %ecx,%ecx
  802b29:	89 ce                	mov    %ecx,%esi
  802b2b:	75 0b                	jne    802b38 <__udivdi3+0x38>
  802b2d:	b8 01 00 00 00       	mov    $0x1,%eax
  802b32:	31 d2                	xor    %edx,%edx
  802b34:	f7 f1                	div    %ecx
  802b36:	89 c6                	mov    %eax,%esi
  802b38:	31 d2                	xor    %edx,%edx
  802b3a:	89 e8                	mov    %ebp,%eax
  802b3c:	f7 f6                	div    %esi
  802b3e:	89 c5                	mov    %eax,%ebp
  802b40:	89 f8                	mov    %edi,%eax
  802b42:	f7 f6                	div    %esi
  802b44:	89 ea                	mov    %ebp,%edx
  802b46:	83 c4 0c             	add    $0xc,%esp
  802b49:	5e                   	pop    %esi
  802b4a:	5f                   	pop    %edi
  802b4b:	5d                   	pop    %ebp
  802b4c:	c3                   	ret    
  802b4d:	8d 76 00             	lea    0x0(%esi),%esi
  802b50:	39 e8                	cmp    %ebp,%eax
  802b52:	77 24                	ja     802b78 <__udivdi3+0x78>
  802b54:	0f bd e8             	bsr    %eax,%ebp
  802b57:	83 f5 1f             	xor    $0x1f,%ebp
  802b5a:	75 3c                	jne    802b98 <__udivdi3+0x98>
  802b5c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802b60:	39 34 24             	cmp    %esi,(%esp)
  802b63:	0f 86 9f 00 00 00    	jbe    802c08 <__udivdi3+0x108>
  802b69:	39 d0                	cmp    %edx,%eax
  802b6b:	0f 82 97 00 00 00    	jb     802c08 <__udivdi3+0x108>
  802b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b78:	31 d2                	xor    %edx,%edx
  802b7a:	31 c0                	xor    %eax,%eax
  802b7c:	83 c4 0c             	add    $0xc,%esp
  802b7f:	5e                   	pop    %esi
  802b80:	5f                   	pop    %edi
  802b81:	5d                   	pop    %ebp
  802b82:	c3                   	ret    
  802b83:	90                   	nop
  802b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b88:	89 f8                	mov    %edi,%eax
  802b8a:	f7 f1                	div    %ecx
  802b8c:	31 d2                	xor    %edx,%edx
  802b8e:	83 c4 0c             	add    $0xc,%esp
  802b91:	5e                   	pop    %esi
  802b92:	5f                   	pop    %edi
  802b93:	5d                   	pop    %ebp
  802b94:	c3                   	ret    
  802b95:	8d 76 00             	lea    0x0(%esi),%esi
  802b98:	89 e9                	mov    %ebp,%ecx
  802b9a:	8b 3c 24             	mov    (%esp),%edi
  802b9d:	d3 e0                	shl    %cl,%eax
  802b9f:	89 c6                	mov    %eax,%esi
  802ba1:	b8 20 00 00 00       	mov    $0x20,%eax
  802ba6:	29 e8                	sub    %ebp,%eax
  802ba8:	89 c1                	mov    %eax,%ecx
  802baa:	d3 ef                	shr    %cl,%edi
  802bac:	89 e9                	mov    %ebp,%ecx
  802bae:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802bb2:	8b 3c 24             	mov    (%esp),%edi
  802bb5:	09 74 24 08          	or     %esi,0x8(%esp)
  802bb9:	89 d6                	mov    %edx,%esi
  802bbb:	d3 e7                	shl    %cl,%edi
  802bbd:	89 c1                	mov    %eax,%ecx
  802bbf:	89 3c 24             	mov    %edi,(%esp)
  802bc2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802bc6:	d3 ee                	shr    %cl,%esi
  802bc8:	89 e9                	mov    %ebp,%ecx
  802bca:	d3 e2                	shl    %cl,%edx
  802bcc:	89 c1                	mov    %eax,%ecx
  802bce:	d3 ef                	shr    %cl,%edi
  802bd0:	09 d7                	or     %edx,%edi
  802bd2:	89 f2                	mov    %esi,%edx
  802bd4:	89 f8                	mov    %edi,%eax
  802bd6:	f7 74 24 08          	divl   0x8(%esp)
  802bda:	89 d6                	mov    %edx,%esi
  802bdc:	89 c7                	mov    %eax,%edi
  802bde:	f7 24 24             	mull   (%esp)
  802be1:	39 d6                	cmp    %edx,%esi
  802be3:	89 14 24             	mov    %edx,(%esp)
  802be6:	72 30                	jb     802c18 <__udivdi3+0x118>
  802be8:	8b 54 24 04          	mov    0x4(%esp),%edx
  802bec:	89 e9                	mov    %ebp,%ecx
  802bee:	d3 e2                	shl    %cl,%edx
  802bf0:	39 c2                	cmp    %eax,%edx
  802bf2:	73 05                	jae    802bf9 <__udivdi3+0xf9>
  802bf4:	3b 34 24             	cmp    (%esp),%esi
  802bf7:	74 1f                	je     802c18 <__udivdi3+0x118>
  802bf9:	89 f8                	mov    %edi,%eax
  802bfb:	31 d2                	xor    %edx,%edx
  802bfd:	e9 7a ff ff ff       	jmp    802b7c <__udivdi3+0x7c>
  802c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c08:	31 d2                	xor    %edx,%edx
  802c0a:	b8 01 00 00 00       	mov    $0x1,%eax
  802c0f:	e9 68 ff ff ff       	jmp    802b7c <__udivdi3+0x7c>
  802c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c18:	8d 47 ff             	lea    -0x1(%edi),%eax
  802c1b:	31 d2                	xor    %edx,%edx
  802c1d:	83 c4 0c             	add    $0xc,%esp
  802c20:	5e                   	pop    %esi
  802c21:	5f                   	pop    %edi
  802c22:	5d                   	pop    %ebp
  802c23:	c3                   	ret    
  802c24:	66 90                	xchg   %ax,%ax
  802c26:	66 90                	xchg   %ax,%ax
  802c28:	66 90                	xchg   %ax,%ax
  802c2a:	66 90                	xchg   %ax,%ax
  802c2c:	66 90                	xchg   %ax,%ax
  802c2e:	66 90                	xchg   %ax,%ax

00802c30 <__umoddi3>:
  802c30:	55                   	push   %ebp
  802c31:	57                   	push   %edi
  802c32:	56                   	push   %esi
  802c33:	83 ec 14             	sub    $0x14,%esp
  802c36:	8b 44 24 28          	mov    0x28(%esp),%eax
  802c3a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802c3e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802c42:	89 c7                	mov    %eax,%edi
  802c44:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c48:	8b 44 24 30          	mov    0x30(%esp),%eax
  802c4c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802c50:	89 34 24             	mov    %esi,(%esp)
  802c53:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c57:	85 c0                	test   %eax,%eax
  802c59:	89 c2                	mov    %eax,%edx
  802c5b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c5f:	75 17                	jne    802c78 <__umoddi3+0x48>
  802c61:	39 fe                	cmp    %edi,%esi
  802c63:	76 4b                	jbe    802cb0 <__umoddi3+0x80>
  802c65:	89 c8                	mov    %ecx,%eax
  802c67:	89 fa                	mov    %edi,%edx
  802c69:	f7 f6                	div    %esi
  802c6b:	89 d0                	mov    %edx,%eax
  802c6d:	31 d2                	xor    %edx,%edx
  802c6f:	83 c4 14             	add    $0x14,%esp
  802c72:	5e                   	pop    %esi
  802c73:	5f                   	pop    %edi
  802c74:	5d                   	pop    %ebp
  802c75:	c3                   	ret    
  802c76:	66 90                	xchg   %ax,%ax
  802c78:	39 f8                	cmp    %edi,%eax
  802c7a:	77 54                	ja     802cd0 <__umoddi3+0xa0>
  802c7c:	0f bd e8             	bsr    %eax,%ebp
  802c7f:	83 f5 1f             	xor    $0x1f,%ebp
  802c82:	75 5c                	jne    802ce0 <__umoddi3+0xb0>
  802c84:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802c88:	39 3c 24             	cmp    %edi,(%esp)
  802c8b:	0f 87 e7 00 00 00    	ja     802d78 <__umoddi3+0x148>
  802c91:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c95:	29 f1                	sub    %esi,%ecx
  802c97:	19 c7                	sbb    %eax,%edi
  802c99:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c9d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ca1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ca5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802ca9:	83 c4 14             	add    $0x14,%esp
  802cac:	5e                   	pop    %esi
  802cad:	5f                   	pop    %edi
  802cae:	5d                   	pop    %ebp
  802caf:	c3                   	ret    
  802cb0:	85 f6                	test   %esi,%esi
  802cb2:	89 f5                	mov    %esi,%ebp
  802cb4:	75 0b                	jne    802cc1 <__umoddi3+0x91>
  802cb6:	b8 01 00 00 00       	mov    $0x1,%eax
  802cbb:	31 d2                	xor    %edx,%edx
  802cbd:	f7 f6                	div    %esi
  802cbf:	89 c5                	mov    %eax,%ebp
  802cc1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802cc5:	31 d2                	xor    %edx,%edx
  802cc7:	f7 f5                	div    %ebp
  802cc9:	89 c8                	mov    %ecx,%eax
  802ccb:	f7 f5                	div    %ebp
  802ccd:	eb 9c                	jmp    802c6b <__umoddi3+0x3b>
  802ccf:	90                   	nop
  802cd0:	89 c8                	mov    %ecx,%eax
  802cd2:	89 fa                	mov    %edi,%edx
  802cd4:	83 c4 14             	add    $0x14,%esp
  802cd7:	5e                   	pop    %esi
  802cd8:	5f                   	pop    %edi
  802cd9:	5d                   	pop    %ebp
  802cda:	c3                   	ret    
  802cdb:	90                   	nop
  802cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ce0:	8b 04 24             	mov    (%esp),%eax
  802ce3:	be 20 00 00 00       	mov    $0x20,%esi
  802ce8:	89 e9                	mov    %ebp,%ecx
  802cea:	29 ee                	sub    %ebp,%esi
  802cec:	d3 e2                	shl    %cl,%edx
  802cee:	89 f1                	mov    %esi,%ecx
  802cf0:	d3 e8                	shr    %cl,%eax
  802cf2:	89 e9                	mov    %ebp,%ecx
  802cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cf8:	8b 04 24             	mov    (%esp),%eax
  802cfb:	09 54 24 04          	or     %edx,0x4(%esp)
  802cff:	89 fa                	mov    %edi,%edx
  802d01:	d3 e0                	shl    %cl,%eax
  802d03:	89 f1                	mov    %esi,%ecx
  802d05:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d09:	8b 44 24 10          	mov    0x10(%esp),%eax
  802d0d:	d3 ea                	shr    %cl,%edx
  802d0f:	89 e9                	mov    %ebp,%ecx
  802d11:	d3 e7                	shl    %cl,%edi
  802d13:	89 f1                	mov    %esi,%ecx
  802d15:	d3 e8                	shr    %cl,%eax
  802d17:	89 e9                	mov    %ebp,%ecx
  802d19:	09 f8                	or     %edi,%eax
  802d1b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802d1f:	f7 74 24 04          	divl   0x4(%esp)
  802d23:	d3 e7                	shl    %cl,%edi
  802d25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d29:	89 d7                	mov    %edx,%edi
  802d2b:	f7 64 24 08          	mull   0x8(%esp)
  802d2f:	39 d7                	cmp    %edx,%edi
  802d31:	89 c1                	mov    %eax,%ecx
  802d33:	89 14 24             	mov    %edx,(%esp)
  802d36:	72 2c                	jb     802d64 <__umoddi3+0x134>
  802d38:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802d3c:	72 22                	jb     802d60 <__umoddi3+0x130>
  802d3e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802d42:	29 c8                	sub    %ecx,%eax
  802d44:	19 d7                	sbb    %edx,%edi
  802d46:	89 e9                	mov    %ebp,%ecx
  802d48:	89 fa                	mov    %edi,%edx
  802d4a:	d3 e8                	shr    %cl,%eax
  802d4c:	89 f1                	mov    %esi,%ecx
  802d4e:	d3 e2                	shl    %cl,%edx
  802d50:	89 e9                	mov    %ebp,%ecx
  802d52:	d3 ef                	shr    %cl,%edi
  802d54:	09 d0                	or     %edx,%eax
  802d56:	89 fa                	mov    %edi,%edx
  802d58:	83 c4 14             	add    $0x14,%esp
  802d5b:	5e                   	pop    %esi
  802d5c:	5f                   	pop    %edi
  802d5d:	5d                   	pop    %ebp
  802d5e:	c3                   	ret    
  802d5f:	90                   	nop
  802d60:	39 d7                	cmp    %edx,%edi
  802d62:	75 da                	jne    802d3e <__umoddi3+0x10e>
  802d64:	8b 14 24             	mov    (%esp),%edx
  802d67:	89 c1                	mov    %eax,%ecx
  802d69:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802d6d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802d71:	eb cb                	jmp    802d3e <__umoddi3+0x10e>
  802d73:	90                   	nop
  802d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d78:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802d7c:	0f 82 0f ff ff ff    	jb     802c91 <__umoddi3+0x61>
  802d82:	e9 1a ff ff ff       	jmp    802ca1 <__umoddi3+0x71>
