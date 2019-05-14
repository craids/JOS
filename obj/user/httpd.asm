
obj/user/httpd.debug:     file format elf32-i386


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
  80002c:	e8 6c 08 00 00       	call   80089d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <die>:
	{404, "Not Found"},
};

static void
die(char *m)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	cprintf("%s\n", m);
  800046:	89 44 24 04          	mov    %eax,0x4(%esp)
  80004a:	c7 04 24 60 31 80 00 	movl   $0x803160,(%esp)
  800051:	e8 a1 09 00 00       	call   8009f7 <cprintf>
	exit();
  800056:	e8 8a 08 00 00       	call   8008e5 <exit>
}
  80005b:	c9                   	leave  
  80005c:	c3                   	ret    

0080005d <send_error>:
	return 0;
}

static int
send_error(struct http_request *req, int code)
{
  80005d:	55                   	push   %ebp
  80005e:	89 e5                	mov    %esp,%ebp
  800060:	57                   	push   %edi
  800061:	56                   	push   %esi
  800062:	53                   	push   %ebx
  800063:	81 ec 2c 02 00 00    	sub    $0x22c,%esp
  800069:	89 c6                	mov    %eax,%esi
	char buf[512];
	int r;

	struct error_messages *e = errors;
  80006b:	b9 00 40 80 00       	mov    $0x804000,%ecx
	while (e->code != 0 && e->msg != 0) {
  800070:	eb 07                	jmp    800079 <send_error+0x1c>
		if (e->code == code)
  800072:	39 d3                	cmp    %edx,%ebx
  800074:	74 11                	je     800087 <send_error+0x2a>
			break;
		e++;
  800076:	83 c1 08             	add    $0x8,%ecx
{
	char buf[512];
	int r;

	struct error_messages *e = errors;
	while (e->code != 0 && e->msg != 0) {
  800079:	8b 19                	mov    (%ecx),%ebx
  80007b:	85 db                	test   %ebx,%ebx
  80007d:	74 5d                	je     8000dc <send_error+0x7f>
  80007f:	83 79 04 00          	cmpl   $0x0,0x4(%ecx)
  800083:	75 ed                	jne    800072 <send_error+0x15>
  800085:	eb 04                	jmp    80008b <send_error+0x2e>
		if (e->code == code)
			break;
		e++;
	}

	if (e->code == 0)
  800087:	85 db                	test   %ebx,%ebx
  800089:	74 58                	je     8000e3 <send_error+0x86>
		return -1;

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  80008b:	8b 41 04             	mov    0x4(%ecx),%eax
  80008e:	89 44 24 18          	mov    %eax,0x18(%esp)
  800092:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  800096:	89 44 24 10          	mov    %eax,0x10(%esp)
  80009a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80009e:	c7 44 24 08 00 32 80 	movl   $0x803200,0x8(%esp)
  8000a5:	00 
  8000a6:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  8000ad:	00 
  8000ae:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
  8000b4:	89 3c 24             	mov    %edi,(%esp)
  8000b7:	e8 fe 0e 00 00       	call   800fba <snprintf>
  8000bc:	89 c3                	mov    %eax,%ebx
			       "Content-type: text/html\r\n"
			       "\r\n"
			       "<html><body><p>%d - %s</p></body></html>\r\n",
			       e->code, e->msg, e->code, e->msg);

	if (write(req->sock, buf, r) != r)
  8000be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8000c6:	8b 06                	mov    (%esi),%eax
  8000c8:	89 04 24             	mov    %eax,(%esp)
  8000cb:	e8 a7 1a 00 00       	call   801b77 <write>
  8000d0:	39 c3                	cmp    %eax,%ebx
  8000d2:	0f 95 c0             	setne  %al
  8000d5:	0f b6 c0             	movzbl %al,%eax
  8000d8:	f7 d8                	neg    %eax
  8000da:	eb 0c                	jmp    8000e8 <send_error+0x8b>
			break;
		e++;
	}

	if (e->code == 0)
		return -1;
  8000dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8000e1:	eb 05                	jmp    8000e8 <send_error+0x8b>
  8000e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

	if (write(req->sock, buf, r) != r)
		return -1;

	return 0;
}
  8000e8:	81 c4 2c 02 00 00    	add    $0x22c,%esp
  8000ee:	5b                   	pop    %ebx
  8000ef:	5e                   	pop    %esi
  8000f0:	5f                   	pop    %edi
  8000f1:	5d                   	pop    %ebp
  8000f2:	c3                   	ret    

008000f3 <handle_client>:
	return r;
}

static void
handle_client(int sock)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	57                   	push   %edi
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	81 ec 4c 03 00 00    	sub    $0x34c,%esp
  8000ff:	89 c6                	mov    %eax,%esi
	struct http_request *req = &con_d;

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800101:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800108:	00 
  800109:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  80010f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800113:	89 34 24             	mov    %esi,(%esp)
  800116:	e8 7f 19 00 00       	call   801a9a <read>
  80011b:	85 c0                	test   %eax,%eax
  80011d:	79 1c                	jns    80013b <handle_client+0x48>
			panic("failed to read");
  80011f:	c7 44 24 08 64 31 80 	movl   $0x803164,0x8(%esp)
  800126:	00 
  800127:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
  80012e:	00 
  80012f:	c7 04 24 73 31 80 00 	movl   $0x803173,(%esp)
  800136:	e8 c3 07 00 00       	call   8008fe <_panic>

		memset(req, 0, sizeof(req));
  80013b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800142:	00 
  800143:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80014a:	00 
  80014b:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80014e:	89 04 24             	mov    %eax,(%esp)
  800151:	e8 21 10 00 00       	call   801177 <memset>

		req->sock = sock;
  800156:	89 75 dc             	mov    %esi,-0x24(%ebp)
	int url_len, version_len;

	if (!req)
		return -1;

	if (strncmp(request, "GET ", 4) != 0)
  800159:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800160:	00 
  800161:	c7 44 24 04 80 31 80 	movl   $0x803180,0x4(%esp)
  800168:	00 
  800169:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  80016f:	89 04 24             	mov    %eax,(%esp)
  800172:	e8 8b 0f 00 00       	call   801102 <strncmp>
  800177:	85 c0                	test   %eax,%eax
  800179:	0f 85 af 02 00 00    	jne    80042e <handle_client+0x33b>
		return -E_BAD_REQ;

	// skip GET
	request += 4;
  80017f:	8d 9d e0 fd ff ff    	lea    -0x220(%ebp),%ebx
  800185:	eb 03                	jmp    80018a <handle_client+0x97>

	// get the url
	url = request;
	while (*request && *request != ' ')
		request++;
  800187:	83 c3 01             	add    $0x1,%ebx
	// skip GET
	request += 4;

	// get the url
	url = request;
	while (*request && *request != ' ')
  80018a:	f6 03 df             	testb  $0xdf,(%ebx)
  80018d:	75 f8                	jne    800187 <handle_client+0x94>
		request++;
	url_len = request - url;
  80018f:	89 df                	mov    %ebx,%edi
  800191:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
  800197:	29 c7                	sub    %eax,%edi

	req->url = malloc(url_len + 1);
  800199:	8d 47 01             	lea    0x1(%edi),%eax
  80019c:	89 04 24             	mov    %eax,(%esp)
  80019f:	e8 ae 24 00 00       	call   802652 <malloc>
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	memmove(req->url, url, url_len);
  8001a7:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8001ab:	8d 8d e0 fd ff ff    	lea    -0x220(%ebp),%ecx
  8001b1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8001b5:	89 04 24             	mov    %eax,(%esp)
  8001b8:	e8 07 10 00 00       	call   8011c4 <memmove>
	req->url[url_len] = '\0';
  8001bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c0:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)

	// skip space
	request++;
  8001c4:	83 c3 01             	add    $0x1,%ebx
  8001c7:	89 d8                	mov    %ebx,%eax
  8001c9:	eb 03                	jmp    8001ce <handle_client+0xdb>

	version = request;
	while (*request && *request != '\n')
		request++;
  8001cb:	83 c0 01             	add    $0x1,%eax

	// skip space
	request++;

	version = request;
	while (*request && *request != '\n')
  8001ce:	0f b6 10             	movzbl (%eax),%edx
  8001d1:	80 fa 0a             	cmp    $0xa,%dl
  8001d4:	74 04                	je     8001da <handle_client+0xe7>
  8001d6:	84 d2                	test   %dl,%dl
  8001d8:	75 f1                	jne    8001cb <handle_client+0xd8>
		request++;
	version_len = request - version;
  8001da:	29 d8                	sub    %ebx,%eax
  8001dc:	89 c7                	mov    %eax,%edi

	req->version = malloc(version_len + 1);
  8001de:	8d 40 01             	lea    0x1(%eax),%eax
  8001e1:	89 04 24             	mov    %eax,(%esp)
  8001e4:	e8 69 24 00 00       	call   802652 <malloc>
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	memmove(req->version, version, version_len);
  8001ec:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8001f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001f4:	89 04 24             	mov    %eax,(%esp)
  8001f7:	e8 c8 0f 00 00       	call   8011c4 <memmove>
	req->version[version_len] = '\0';
  8001fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ff:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
	int fd;
	struct Stat statbuf;

	// open the requested url for reading
	// if the file does not exist, send a 404 error using send_error
	if ((fd = open(req->url, O_RDONLY)) < 0) {
  800203:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80020a:	00 
  80020b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80020e:	89 04 24             	mov    %eax,(%esp)
  800211:	e8 b9 1d 00 00       	call   801fcf <open>
  800216:	89 c3                	mov    %eax,%ebx
  800218:	85 c0                	test   %eax,%eax
  80021a:	79 12                	jns    80022e <handle_client+0x13b>
		send_error(req, 404);
  80021c:	ba 94 01 00 00       	mov    $0x194,%edx
  800221:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800224:	e8 34 fe ff ff       	call   80005d <send_error>
  800229:	e9 d8 01 00 00       	jmp    800406 <handle_client+0x313>
		r = fd;
		goto end;
	}

	// if the file is a directory, send a 404 error using send_error
	if ((r = stat(req->url, &statbuf)) < 0 || statbuf.st_isdir) {
  80022e:	8d 85 50 fd ff ff    	lea    -0x2b0(%ebp),%eax
  800234:	89 44 24 04          	mov    %eax,0x4(%esp)
  800238:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80023b:	89 04 24             	mov    %eax,(%esp)
  80023e:	e8 ed 1a 00 00       	call   801d30 <stat>
  800243:	85 c0                	test   %eax,%eax
  800245:	78 09                	js     800250 <handle_client+0x15d>
  800247:	83 bd d4 fd ff ff 00 	cmpl   $0x0,-0x22c(%ebp)
  80024e:	74 12                	je     800262 <handle_client+0x16f>
		send_error(req, 404);
  800250:	ba 94 01 00 00       	mov    $0x194,%edx
  800255:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800258:	e8 00 fe ff ff       	call   80005d <send_error>
  80025d:	e9 a4 01 00 00       	jmp    800406 <handle_client+0x313>
		goto end;
	}

	// set file_size to the size of the file
	file_size = statbuf.st_size;
  800262:	8b 85 d0 fd ff ff    	mov    -0x230(%ebp),%eax
  800268:	89 85 c4 fc ff ff    	mov    %eax,-0x33c(%ebp)
}

static int
send_header(struct http_request *req, int code)
{
	struct responce_header *h = headers;
  80026e:	bf 10 40 80 00       	mov    $0x804010,%edi
  800273:	eb 0a                	jmp    80027f <handle_client+0x18c>
	while (h->code != 0 && h->header!= 0) {
		if (h->code == code)
  800275:	3d c8 00 00 00       	cmp    $0xc8,%eax
  80027a:	74 13                	je     80028f <handle_client+0x19c>
			break;
		h++;
  80027c:	83 c7 08             	add    $0x8,%edi

static int
send_header(struct http_request *req, int code)
{
	struct responce_header *h = headers;
	while (h->code != 0 && h->header!= 0) {
  80027f:	8b 07                	mov    (%edi),%eax
  800281:	85 c0                	test   %eax,%eax
  800283:	0f 84 7d 01 00 00    	je     800406 <handle_client+0x313>
  800289:	83 7f 04 00          	cmpl   $0x0,0x4(%edi)
  80028d:	75 e6                	jne    800275 <handle_client+0x182>
	}

	if (h->code == 0)
		return -1;

	int len = strlen(h->header);
  80028f:	8b 47 04             	mov    0x4(%edi),%eax
  800292:	89 04 24             	mov    %eax,(%esp)
  800295:	e8 56 0d 00 00       	call   800ff0 <strlen>
	if (write(req->sock, h->header, len) != len) {
  80029a:	89 85 c0 fc ff ff    	mov    %eax,-0x340(%ebp)
  8002a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002a4:	8b 47 04             	mov    0x4(%edi),%eax
  8002a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ae:	89 04 24             	mov    %eax,(%esp)
  8002b1:	e8 c1 18 00 00       	call   801b77 <write>
  8002b6:	39 85 c0 fc ff ff    	cmp    %eax,-0x340(%ebp)
  8002bc:	0f 84 7b 01 00 00    	je     80043d <handle_client+0x34a>
		die("Failed to send bytes to client");
  8002c2:	b8 7c 32 80 00       	mov    $0x80327c,%eax
  8002c7:	e8 74 fd ff ff       	call   800040 <die>
  8002cc:	e9 6c 01 00 00       	jmp    80043d <handle_client+0x34a>
	char buf[64];
	int r;

	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
	if (r > 63)
		panic("buffer too small!");
  8002d1:	c7 44 24 08 85 31 80 	movl   $0x803185,0x8(%esp)
  8002d8:	00 
  8002d9:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8002e0:	00 
  8002e1:	c7 04 24 73 31 80 00 	movl   $0x803173,(%esp)
  8002e8:	e8 11 06 00 00       	call   8008fe <_panic>

	if (write(req->sock, buf, r) != r)
  8002ed:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8002f1:	8d 85 d0 fc ff ff    	lea    -0x330(%ebp),%eax
  8002f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002fe:	89 04 24             	mov    %eax,(%esp)
  800301:	e8 71 18 00 00       	call   801b77 <write>
	file_size = statbuf.st_size;

	if ((r = send_header(req, 200)) < 0)
		goto end;

	if ((r = send_size(req, file_size)) < 0)
  800306:	39 c7                	cmp    %eax,%edi
  800308:	0f 85 f8 00 00 00    	jne    800406 <handle_client+0x313>

	type = mime_type(req->url);
	if (!type)
		return -1;

	r = snprintf(buf, 128, "Content-Type: %s\r\n", type);
  80030e:	c7 44 24 0c 97 31 80 	movl   $0x803197,0xc(%esp)
  800315:	00 
  800316:	c7 44 24 08 a1 31 80 	movl   $0x8031a1,0x8(%esp)
  80031d:	00 
  80031e:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  800325:	00 
  800326:	8d 85 d0 fc ff ff    	lea    -0x330(%ebp),%eax
  80032c:	89 04 24             	mov    %eax,(%esp)
  80032f:	e8 86 0c 00 00       	call   800fba <snprintf>
  800334:	89 c7                	mov    %eax,%edi
	if (r > 127)
  800336:	83 f8 7f             	cmp    $0x7f,%eax
  800339:	7e 1c                	jle    800357 <handle_client+0x264>
		panic("buffer too small!");
  80033b:	c7 44 24 08 85 31 80 	movl   $0x803185,0x8(%esp)
  800342:	00 
  800343:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  80034a:	00 
  80034b:	c7 04 24 73 31 80 00 	movl   $0x803173,(%esp)
  800352:	e8 a7 05 00 00       	call   8008fe <_panic>

	if (write(req->sock, buf, r) != r)
  800357:	89 44 24 08          	mov    %eax,0x8(%esp)
  80035b:	8d 85 d0 fc ff ff    	lea    -0x330(%ebp),%eax
  800361:	89 44 24 04          	mov    %eax,0x4(%esp)
  800365:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800368:	89 04 24             	mov    %eax,(%esp)
  80036b:	e8 07 18 00 00       	call   801b77 <write>
		goto end;

	if ((r = send_size(req, file_size)) < 0)
		goto end;

	if ((r = send_content_type(req)) < 0)
  800370:	39 c7                	cmp    %eax,%edi
  800372:	0f 85 8e 00 00 00    	jne    800406 <handle_client+0x313>

static int
send_header_fin(struct http_request *req)
{
	const char *fin = "\r\n";
	int fin_len = strlen(fin);
  800378:	c7 04 24 c7 31 80 00 	movl   $0x8031c7,(%esp)
  80037f:	e8 6c 0c 00 00       	call   800ff0 <strlen>
  800384:	89 c7                	mov    %eax,%edi

	if (write(req->sock, fin, fin_len) != fin_len)
  800386:	89 44 24 08          	mov    %eax,0x8(%esp)
  80038a:	c7 44 24 04 c7 31 80 	movl   $0x8031c7,0x4(%esp)
  800391:	00 
  800392:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800395:	89 04 24             	mov    %eax,(%esp)
  800398:	e8 da 17 00 00       	call   801b77 <write>
		goto end;

	if ((r = send_content_type(req)) < 0)
		goto end;

	if ((r = send_header_fin(req)) < 0)
  80039d:	39 c7                	cmp    %eax,%edi
  80039f:	75 65                	jne    800406 <handle_client+0x313>
  8003a1:	89 a5 c0 fc ff ff    	mov    %esp,-0x340(%ebp)
	// LAB 6: Your code here.
	// Read 1024 bytes at a time from the file and then write them out
	// to the socket
	int length;
	int BYTE_INCREMENT = 1024;
	char tmp_buf[BYTE_INCREMENT];
  8003a7:	81 ec 00 04 00 00    	sub    $0x400,%esp
  8003ad:	8d 44 24 10          	lea    0x10(%esp),%eax
  8003b1:	89 85 c4 fc ff ff    	mov    %eax,-0x33c(%ebp)
  8003b7:	eb 27                	jmp    8003e0 <handle_client+0x2ed>

	while ((length = read(fd, tmp_buf, BYTE_INCREMENT)) > 0) {
		if (write(req->sock, tmp_buf, length) != length)
  8003b9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8003bd:	8b 85 c4 fc ff ff    	mov    -0x33c(%ebp),%eax
  8003c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ca:	89 04 24             	mov    %eax,(%esp)
  8003cd:	e8 a5 17 00 00       	call   801b77 <write>
  8003d2:	39 c7                	cmp    %eax,%edi
  8003d4:	74 0a                	je     8003e0 <handle_client+0x2ed>
			die("send_data: unable to write data to socket\n");
  8003d6:	b8 9c 32 80 00       	mov    $0x80329c,%eax
  8003db:	e8 60 fc ff ff       	call   800040 <die>
	// to the socket
	int length;
	int BYTE_INCREMENT = 1024;
	char tmp_buf[BYTE_INCREMENT];

	while ((length = read(fd, tmp_buf, BYTE_INCREMENT)) > 0) {
  8003e0:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  8003e7:	00 
  8003e8:	8b 85 c4 fc ff ff    	mov    -0x33c(%ebp),%eax
  8003ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f2:	89 1c 24             	mov    %ebx,(%esp)
  8003f5:	e8 a0 16 00 00       	call   801a9a <read>
  8003fa:	89 c7                	mov    %eax,%edi
  8003fc:	85 c0                	test   %eax,%eax
  8003fe:	7f b9                	jg     8003b9 <handle_client+0x2c6>
  800400:	8b a5 c0 fc ff ff    	mov    -0x340(%ebp),%esp
		goto end;

	r = send_data(req, fd);

end:
	close(fd);
  800406:	89 1c 24             	mov    %ebx,(%esp)
  800409:	e8 29 15 00 00       	call   801937 <close>
}

static void
req_free(struct http_request *req)
{
	free(req->url);
  80040e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800411:	89 04 24             	mov    %eax,(%esp)
  800414:	e8 67 21 00 00       	call   802580 <free>
	free(req->version);
  800419:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041c:	89 04 24             	mov    %eax,(%esp)
  80041f:	e8 5c 21 00 00       	call   802580 <free>

		// no keep alive
		break;
	}

	close(sock);
  800424:	89 34 24             	mov    %esi,(%esp)
  800427:	e8 0b 15 00 00       	call   801937 <close>
  80042c:	eb 47                	jmp    800475 <handle_client+0x382>

		req->sock = sock;

		r = http_request_parse(req, buffer);
		if (r == -E_BAD_REQ)
			send_error(req, 400);
  80042e:	ba 90 01 00 00       	mov    $0x190,%edx
  800433:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800436:	e8 22 fc ff ff       	call   80005d <send_error>
  80043b:	eb d1                	jmp    80040e <handle_client+0x31b>
send_size(struct http_request *req, off_t size)
{
	char buf[64];
	int r;

	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
  80043d:	8b 85 c4 fc ff ff    	mov    -0x33c(%ebp),%eax
  800443:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800447:	c7 44 24 08 b4 31 80 	movl   $0x8031b4,0x8(%esp)
  80044e:	00 
  80044f:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  800456:	00 
  800457:	8d 85 d0 fc ff ff    	lea    -0x330(%ebp),%eax
  80045d:	89 04 24             	mov    %eax,(%esp)
  800460:	e8 55 0b 00 00       	call   800fba <snprintf>
  800465:	89 c7                	mov    %eax,%edi
	if (r > 63)
  800467:	83 f8 3f             	cmp    $0x3f,%eax
  80046a:	0f 8e 7d fe ff ff    	jle    8002ed <handle_client+0x1fa>
  800470:	e9 5c fe ff ff       	jmp    8002d1 <handle_client+0x1de>
		// no keep alive
		break;
	}

	close(sock);
}
  800475:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800478:	5b                   	pop    %ebx
  800479:	5e                   	pop    %esi
  80047a:	5f                   	pop    %edi
  80047b:	5d                   	pop    %ebp
  80047c:	c3                   	ret    

0080047d <umain>:

void
umain(int argc, char **argv)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	57                   	push   %edi
  800481:	56                   	push   %esi
  800482:	53                   	push   %ebx
  800483:	83 ec 4c             	sub    $0x4c,%esp
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  800486:	c7 05 20 40 80 00 ca 	movl   $0x8031ca,0x804020
  80048d:	31 80 00 

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800490:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800497:	00 
  800498:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80049f:	00 
  8004a0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8004a7:	e8 eb 1d 00 00       	call   802297 <socket>
  8004ac:	89 c6                	mov    %eax,%esi
  8004ae:	85 c0                	test   %eax,%eax
  8004b0:	79 0a                	jns    8004bc <umain+0x3f>
		die("Failed to create socket");
  8004b2:	b8 d1 31 80 00       	mov    $0x8031d1,%eax
  8004b7:	e8 84 fb ff ff       	call   800040 <die>

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  8004bc:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  8004c3:	00 
  8004c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004cb:	00 
  8004cc:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8004cf:	89 1c 24             	mov    %ebx,(%esp)
  8004d2:	e8 a0 0c 00 00       	call   801177 <memset>
	server.sin_family = AF_INET;			// Internet/IP
  8004d7:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  8004db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004e2:	e8 69 01 00 00       	call   800650 <htonl>
  8004e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
	server.sin_port = htons(PORT);			// server port
  8004ea:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  8004f1:	e8 40 01 00 00       	call   800636 <htons>
  8004f6:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  8004fa:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800501:	00 
  800502:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800506:	89 34 24             	mov    %esi,(%esp)
  800509:	e8 e7 1c 00 00       	call   8021f5 <bind>
  80050e:	85 c0                	test   %eax,%eax
  800510:	79 0a                	jns    80051c <umain+0x9f>
		 sizeof(server)) < 0)
	{
		die("Failed to bind the server socket");
  800512:	b8 c8 32 80 00       	mov    $0x8032c8,%eax
  800517:	e8 24 fb ff ff       	call   800040 <die>
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  80051c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  800523:	00 
  800524:	89 34 24             	mov    %esi,(%esp)
  800527:	e8 46 1d 00 00       	call   802272 <listen>
  80052c:	85 c0                	test   %eax,%eax
  80052e:	79 0a                	jns    80053a <umain+0xbd>
		die("Failed to listen on server socket");
  800530:	b8 ec 32 80 00       	mov    $0x8032ec,%eax
  800535:	e8 06 fb ff ff       	call   800040 <die>

	cprintf("Waiting for http connections...\n");
  80053a:	c7 04 24 10 33 80 00 	movl   $0x803310,(%esp)
  800541:	e8 b1 04 00 00       	call   8009f7 <cprintf>

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  800546:	8d 7d c4             	lea    -0x3c(%ebp),%edi
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");

	while (1) {
		unsigned int clientlen = sizeof(client);
  800549:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		// Wait for client connection
		if ((clientsock = accept(serversock,
  800550:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800554:	8d 45 c8             	lea    -0x38(%ebp),%eax
  800557:	89 44 24 04          	mov    %eax,0x4(%esp)
  80055b:	89 34 24             	mov    %esi,(%esp)
  80055e:	e8 57 1c 00 00       	call   8021ba <accept>
  800563:	89 c3                	mov    %eax,%ebx
  800565:	85 c0                	test   %eax,%eax
  800567:	79 0a                	jns    800573 <umain+0xf6>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  800569:	b8 34 33 80 00       	mov    $0x803334,%eax
  80056e:	e8 cd fa ff ff       	call   800040 <die>
		}
		handle_client(clientsock);
  800573:	89 d8                	mov    %ebx,%eax
  800575:	e8 79 fb ff ff       	call   8000f3 <handle_client>
	}
  80057a:	eb cd                	jmp    800549 <umain+0xcc>
  80057c:	66 90                	xchg   %ax,%ax
  80057e:	66 90                	xchg   %ax,%ax

00800580 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800580:	55                   	push   %ebp
  800581:	89 e5                	mov    %esp,%ebp
  800583:	57                   	push   %edi
  800584:	56                   	push   %esi
  800585:	53                   	push   %ebx
  800586:	83 ec 19             	sub    $0x19,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80058f:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  800593:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  800596:	c7 45 dc 00 50 80 00 	movl   $0x805000,-0x24(%ebp)
 */
char *
inet_ntoa(struct in_addr addr)
{
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80059d:	be 00 00 00 00       	mov    $0x0,%esi
  8005a2:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  8005a5:	eb 02                	jmp    8005a9 <inet_ntoa+0x29>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  8005a7:	89 ce                	mov    %ecx,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  8005a9:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005ac:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  8005af:	0f b6 c2             	movzbl %dl,%eax
  8005b2:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  8005b5:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
  8005b8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8005bb:	66 c1 e8 0b          	shr    $0xb,%ax
  8005bf:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  8005c1:	8d 4e 01             	lea    0x1(%esi),%ecx
  8005c4:	89 f3                	mov    %esi,%ebx
  8005c6:	0f b6 f3             	movzbl %bl,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  8005c9:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  8005cc:	01 ff                	add    %edi,%edi
  8005ce:	89 fb                	mov    %edi,%ebx
  8005d0:	29 da                	sub    %ebx,%edx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
  8005d2:	83 c2 30             	add    $0x30,%edx
  8005d5:	88 54 35 ed          	mov    %dl,-0x13(%ebp,%esi,1)
    } while(*ap);
  8005d9:	84 c0                	test   %al,%al
  8005db:	75 ca                	jne    8005a7 <inet_ntoa+0x27>
  8005dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005e0:	89 c8                	mov    %ecx,%eax
  8005e2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005e5:	89 cf                	mov    %ecx,%edi
  8005e7:	eb 0d                	jmp    8005f6 <inet_ntoa+0x76>
    while(i--)
      *rp++ = inv[i];
  8005e9:	0f b6 f0             	movzbl %al,%esi
  8005ec:	0f b6 4c 35 ed       	movzbl -0x13(%ebp,%esi,1),%ecx
  8005f1:	88 0a                	mov    %cl,(%edx)
  8005f3:	83 c2 01             	add    $0x1,%edx
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8005f6:	83 e8 01             	sub    $0x1,%eax
  8005f9:	3c ff                	cmp    $0xff,%al
  8005fb:	75 ec                	jne    8005e9 <inet_ntoa+0x69>
  8005fd:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800600:	89 f9                	mov    %edi,%ecx
  800602:	0f b6 c9             	movzbl %cl,%ecx
  800605:	03 4d dc             	add    -0x24(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  800608:	8d 41 01             	lea    0x1(%ecx),%eax
  80060b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    ap++;
  80060e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  800612:	80 45 db 01          	addb   $0x1,-0x25(%ebp)
  800616:	80 7d db 03          	cmpb   $0x3,-0x25(%ebp)
  80061a:	77 0a                	ja     800626 <inet_ntoa+0xa6>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  80061c:	c6 01 2e             	movb   $0x2e,(%ecx)
  80061f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800624:	eb 81                	jmp    8005a7 <inet_ntoa+0x27>
    ap++;
  }
  *--rp = 0;
  800626:	c6 01 00             	movb   $0x0,(%ecx)
  return str;
}
  800629:	b8 00 50 80 00       	mov    $0x805000,%eax
  80062e:	83 c4 19             	add    $0x19,%esp
  800631:	5b                   	pop    %ebx
  800632:	5e                   	pop    %esi
  800633:	5f                   	pop    %edi
  800634:	5d                   	pop    %ebp
  800635:	c3                   	ret    

00800636 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  800636:	55                   	push   %ebp
  800637:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800639:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80063d:	66 c1 c0 08          	rol    $0x8,%ax
}
  800641:	5d                   	pop    %ebp
  800642:	c3                   	ret    

00800643 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800643:	55                   	push   %ebp
  800644:	89 e5                	mov    %esp,%ebp
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800646:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80064a:	66 c1 c0 08          	rol    $0x8,%ax
 */
u16_t
ntohs(u16_t n)
{
  return htons(n);
}
  80064e:	5d                   	pop    %ebp
  80064f:	c3                   	ret    

00800650 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  800650:	55                   	push   %ebp
  800651:	89 e5                	mov    %esp,%ebp
  800653:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  800656:	89 d1                	mov    %edx,%ecx
  800658:	c1 e9 18             	shr    $0x18,%ecx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80065b:	89 d0                	mov    %edx,%eax
  80065d:	c1 e0 18             	shl    $0x18,%eax
  800660:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  800662:	89 d1                	mov    %edx,%ecx
  800664:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  80066a:	c1 e1 08             	shl    $0x8,%ecx
  80066d:	09 c8                	or     %ecx,%eax
    ((n & 0xff0000UL) >> 8) |
  80066f:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  800675:	c1 ea 08             	shr    $0x8,%edx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  800678:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80067a:	5d                   	pop    %ebp
  80067b:	c3                   	ret    

0080067c <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80067c:	55                   	push   %ebp
  80067d:	89 e5                	mov    %esp,%ebp
  80067f:	57                   	push   %edi
  800680:	56                   	push   %esi
  800681:	53                   	push   %ebx
  800682:	83 ec 20             	sub    $0x20,%esp
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  800688:	0f be 10             	movsbl (%eax),%edx
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  80068b:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80068e:	89 75 d8             	mov    %esi,-0x28(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  800691:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800694:	80 f9 09             	cmp    $0x9,%cl
  800697:	0f 87 a6 01 00 00    	ja     800843 <inet_aton+0x1c7>
      return (0);
    val = 0;
    base = 10;
  80069d:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
    if (c == '0') {
  8006a4:	83 fa 30             	cmp    $0x30,%edx
  8006a7:	75 2b                	jne    8006d4 <inet_aton+0x58>
      c = *++cp;
  8006a9:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  8006ad:	89 d1                	mov    %edx,%ecx
  8006af:	83 e1 df             	and    $0xffffffdf,%ecx
  8006b2:	80 f9 58             	cmp    $0x58,%cl
  8006b5:	74 0f                	je     8006c6 <inet_aton+0x4a>
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
  8006b7:	83 c0 01             	add    $0x1,%eax
  8006ba:	0f be d2             	movsbl %dl,%edx
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
      } else
        base = 8;
  8006bd:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  8006c4:	eb 0e                	jmp    8006d4 <inet_aton+0x58>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  8006c6:	0f be 50 02          	movsbl 0x2(%eax),%edx
  8006ca:	8d 40 02             	lea    0x2(%eax),%eax
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  8006cd:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  8006d4:	83 c0 01             	add    $0x1,%eax
  8006d7:	bf 00 00 00 00       	mov    $0x0,%edi
  8006dc:	eb 03                	jmp    8006e1 <inet_aton+0x65>
  8006de:	83 c0 01             	add    $0x1,%eax
  8006e1:	8d 70 ff             	lea    -0x1(%eax),%esi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  8006e4:	89 d3                	mov    %edx,%ebx
  8006e6:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8006e9:	80 f9 09             	cmp    $0x9,%cl
  8006ec:	77 0d                	ja     8006fb <inet_aton+0x7f>
        val = (val * base) + (int)(c - '0');
  8006ee:	0f af 7d e0          	imul   -0x20(%ebp),%edi
  8006f2:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  8006f6:	0f be 10             	movsbl (%eax),%edx
  8006f9:	eb e3                	jmp    8006de <inet_aton+0x62>
      } else if (base == 16 && isxdigit(c)) {
  8006fb:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  8006ff:	75 30                	jne    800731 <inet_aton+0xb5>
  800701:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
  800704:	88 4d df             	mov    %cl,-0x21(%ebp)
  800707:	89 d1                	mov    %edx,%ecx
  800709:	83 e1 df             	and    $0xffffffdf,%ecx
  80070c:	83 e9 41             	sub    $0x41,%ecx
  80070f:	80 f9 05             	cmp    $0x5,%cl
  800712:	77 23                	ja     800737 <inet_aton+0xbb>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800714:	89 fb                	mov    %edi,%ebx
  800716:	c1 e3 04             	shl    $0x4,%ebx
  800719:	8d 7a 0a             	lea    0xa(%edx),%edi
  80071c:	80 7d df 1a          	cmpb   $0x1a,-0x21(%ebp)
  800720:	19 c9                	sbb    %ecx,%ecx
  800722:	83 e1 20             	and    $0x20,%ecx
  800725:	83 c1 41             	add    $0x41,%ecx
  800728:	29 cf                	sub    %ecx,%edi
  80072a:	09 df                	or     %ebx,%edi
        c = *++cp;
  80072c:	0f be 10             	movsbl (%eax),%edx
  80072f:	eb ad                	jmp    8006de <inet_aton+0x62>
  800731:	89 d0                	mov    %edx,%eax
  800733:	89 f9                	mov    %edi,%ecx
  800735:	eb 04                	jmp    80073b <inet_aton+0xbf>
  800737:	89 d0                	mov    %edx,%eax
  800739:	89 f9                	mov    %edi,%ecx
      } else
        break;
    }
    if (c == '.') {
  80073b:	83 f8 2e             	cmp    $0x2e,%eax
  80073e:	75 22                	jne    800762 <inet_aton+0xe6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  800740:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800743:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  800746:	0f 84 fe 00 00 00    	je     80084a <inet_aton+0x1ce>
        return (0);
      *pp++ = val;
  80074c:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  800750:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800753:	89 48 fc             	mov    %ecx,-0x4(%eax)
      c = *++cp;
  800756:	8d 46 01             	lea    0x1(%esi),%eax
  800759:	0f be 56 01          	movsbl 0x1(%esi),%edx
    } else
      break;
  }
  80075d:	e9 2f ff ff ff       	jmp    800691 <inet_aton+0x15>
  800762:	89 f9                	mov    %edi,%ecx
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800764:	85 d2                	test   %edx,%edx
  800766:	74 27                	je     80078f <inet_aton+0x113>
    return (0);
  800768:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80076d:	80 fb 1f             	cmp    $0x1f,%bl
  800770:	0f 86 e7 00 00 00    	jbe    80085d <inet_aton+0x1e1>
  800776:	84 d2                	test   %dl,%dl
  800778:	0f 88 d3 00 00 00    	js     800851 <inet_aton+0x1d5>
  80077e:	83 fa 20             	cmp    $0x20,%edx
  800781:	74 0c                	je     80078f <inet_aton+0x113>
  800783:	83 ea 09             	sub    $0x9,%edx
  800786:	83 fa 04             	cmp    $0x4,%edx
  800789:	0f 87 ce 00 00 00    	ja     80085d <inet_aton+0x1e1>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  80078f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800792:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800795:	29 c2                	sub    %eax,%edx
  800797:	c1 fa 02             	sar    $0x2,%edx
  80079a:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  80079d:	83 fa 02             	cmp    $0x2,%edx
  8007a0:	74 22                	je     8007c4 <inet_aton+0x148>
  8007a2:	83 fa 02             	cmp    $0x2,%edx
  8007a5:	7f 0f                	jg     8007b6 <inet_aton+0x13a>

  case 0:
    return (0);       /* initial nondigit */
  8007a7:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  8007ac:	85 d2                	test   %edx,%edx
  8007ae:	0f 84 a9 00 00 00    	je     80085d <inet_aton+0x1e1>
  8007b4:	eb 73                	jmp    800829 <inet_aton+0x1ad>
  8007b6:	83 fa 03             	cmp    $0x3,%edx
  8007b9:	74 26                	je     8007e1 <inet_aton+0x165>
  8007bb:	83 fa 04             	cmp    $0x4,%edx
  8007be:	66 90                	xchg   %ax,%ax
  8007c0:	74 40                	je     800802 <inet_aton+0x186>
  8007c2:	eb 65                	jmp    800829 <inet_aton+0x1ad>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  8007c4:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8007c9:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  8007cf:	0f 87 88 00 00 00    	ja     80085d <inet_aton+0x1e1>
      return (0);
    val |= parts[0] << 24;
  8007d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007d8:	c1 e0 18             	shl    $0x18,%eax
  8007db:	89 cf                	mov    %ecx,%edi
  8007dd:	09 c7                	or     %eax,%edi
    break;
  8007df:	eb 48                	jmp    800829 <inet_aton+0x1ad>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  8007e1:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8007e6:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  8007ec:	77 6f                	ja     80085d <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  8007ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007f1:	c1 e2 10             	shl    $0x10,%edx
  8007f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007f7:	c1 e0 18             	shl    $0x18,%eax
  8007fa:	09 d0                	or     %edx,%eax
  8007fc:	09 c8                	or     %ecx,%eax
  8007fe:	89 c7                	mov    %eax,%edi
    break;
  800800:	eb 27                	jmp    800829 <inet_aton+0x1ad>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  800802:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  800807:	81 f9 ff 00 00 00    	cmp    $0xff,%ecx
  80080d:	77 4e                	ja     80085d <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80080f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800812:	c1 e2 10             	shl    $0x10,%edx
  800815:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800818:	c1 e0 18             	shl    $0x18,%eax
  80081b:	09 c2                	or     %eax,%edx
  80081d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800820:	c1 e0 08             	shl    $0x8,%eax
  800823:	09 d0                	or     %edx,%eax
  800825:	09 c8                	or     %ecx,%eax
  800827:	89 c7                	mov    %eax,%edi
    break;
  }
  if (addr)
  800829:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80082d:	74 29                	je     800858 <inet_aton+0x1dc>
    addr->s_addr = htonl(val);
  80082f:	89 3c 24             	mov    %edi,(%esp)
  800832:	e8 19 fe ff ff       	call   800650 <htonl>
  800837:	8b 75 0c             	mov    0xc(%ebp),%esi
  80083a:	89 06                	mov    %eax,(%esi)
  return (1);
  80083c:	b8 01 00 00 00       	mov    $0x1,%eax
  800841:	eb 1a                	jmp    80085d <inet_aton+0x1e1>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  800843:	b8 00 00 00 00       	mov    $0x0,%eax
  800848:	eb 13                	jmp    80085d <inet_aton+0x1e1>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  80084a:	b8 00 00 00 00       	mov    $0x0,%eax
  80084f:	eb 0c                	jmp    80085d <inet_aton+0x1e1>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  800851:	b8 00 00 00 00       	mov    $0x0,%eax
  800856:	eb 05                	jmp    80085d <inet_aton+0x1e1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  800858:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80085d:	83 c4 20             	add    $0x20,%esp
  800860:	5b                   	pop    %ebx
  800861:	5e                   	pop    %esi
  800862:	5f                   	pop    %edi
  800863:	5d                   	pop    %ebp
  800864:	c3                   	ret    

00800865 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  800865:	55                   	push   %ebp
  800866:	89 e5                	mov    %esp,%ebp
  800868:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  80086b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80086e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	89 04 24             	mov    %eax,(%esp)
  800878:	e8 ff fd ff ff       	call   80067c <inet_aton>
  80087d:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  80087f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800884:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  800888:	c9                   	leave  
  800889:	c3                   	ret    

0080088a <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	89 04 24             	mov    %eax,(%esp)
  800896:	e8 b5 fd ff ff       	call   800650 <htonl>
}
  80089b:	c9                   	leave  
  80089c:	c3                   	ret    

0080089d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	56                   	push   %esi
  8008a1:	53                   	push   %ebx
  8008a2:	83 ec 10             	sub    $0x10,%esp
  8008a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008a8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8008ab:	e8 55 0b 00 00       	call   801405 <sys_getenvid>
  8008b0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8008b5:	c1 e0 07             	shl    $0x7,%eax
  8008b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8008bd:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008c2:	85 db                	test   %ebx,%ebx
  8008c4:	7e 07                	jle    8008cd <libmain+0x30>
		binaryname = argv[0];
  8008c6:	8b 06                	mov    (%esi),%eax
  8008c8:	a3 20 40 80 00       	mov    %eax,0x804020

	// call user main routine
	umain(argc, argv);
  8008cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008d1:	89 1c 24             	mov    %ebx,(%esp)
  8008d4:	e8 a4 fb ff ff       	call   80047d <umain>

	// exit gracefully
	exit();
  8008d9:	e8 07 00 00 00       	call   8008e5 <exit>
}
  8008de:	83 c4 10             	add    $0x10,%esp
  8008e1:	5b                   	pop    %ebx
  8008e2:	5e                   	pop    %esi
  8008e3:	5d                   	pop    %ebp
  8008e4:	c3                   	ret    

008008e5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8008eb:	e8 7a 10 00 00       	call   80196a <close_all>
	sys_env_destroy(0);
  8008f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8008f7:	e8 b7 0a 00 00       	call   8013b3 <sys_env_destroy>
}
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	56                   	push   %esi
  800902:	53                   	push   %ebx
  800903:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800906:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800909:	8b 35 20 40 80 00    	mov    0x804020,%esi
  80090f:	e8 f1 0a 00 00       	call   801405 <sys_getenvid>
  800914:	8b 55 0c             	mov    0xc(%ebp),%edx
  800917:	89 54 24 10          	mov    %edx,0x10(%esp)
  80091b:	8b 55 08             	mov    0x8(%ebp),%edx
  80091e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800922:	89 74 24 08          	mov    %esi,0x8(%esp)
  800926:	89 44 24 04          	mov    %eax,0x4(%esp)
  80092a:	c7 04 24 88 33 80 00 	movl   $0x803388,(%esp)
  800931:	e8 c1 00 00 00       	call   8009f7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800936:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80093a:	8b 45 10             	mov    0x10(%ebp),%eax
  80093d:	89 04 24             	mov    %eax,(%esp)
  800940:	e8 51 00 00 00       	call   800996 <vcprintf>
	cprintf("\n");
  800945:	c7 04 24 c8 31 80 00 	movl   $0x8031c8,(%esp)
  80094c:	e8 a6 00 00 00       	call   8009f7 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800951:	cc                   	int3   
  800952:	eb fd                	jmp    800951 <_panic+0x53>

00800954 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	53                   	push   %ebx
  800958:	83 ec 14             	sub    $0x14,%esp
  80095b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80095e:	8b 13                	mov    (%ebx),%edx
  800960:	8d 42 01             	lea    0x1(%edx),%eax
  800963:	89 03                	mov    %eax,(%ebx)
  800965:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800968:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80096c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800971:	75 19                	jne    80098c <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800973:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80097a:	00 
  80097b:	8d 43 08             	lea    0x8(%ebx),%eax
  80097e:	89 04 24             	mov    %eax,(%esp)
  800981:	e8 f0 09 00 00       	call   801376 <sys_cputs>
		b->idx = 0;
  800986:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80098c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800990:	83 c4 14             	add    $0x14,%esp
  800993:	5b                   	pop    %ebx
  800994:	5d                   	pop    %ebp
  800995:	c3                   	ret    

00800996 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80099f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009a6:	00 00 00 
	b.cnt = 0;
  8009a9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009b0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8009b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009c1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009cb:	c7 04 24 54 09 80 00 	movl   $0x800954,(%esp)
  8009d2:	e8 b7 01 00 00       	call   800b8e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8009d7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8009dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8009e7:	89 04 24             	mov    %eax,(%esp)
  8009ea:	e8 87 09 00 00       	call   801376 <sys_cputs>

	return b.cnt;
}
  8009ef:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    

008009f7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009fd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	89 04 24             	mov    %eax,(%esp)
  800a0a:	e8 87 ff ff ff       	call   800996 <vcprintf>
	va_end(ap);

	return cnt;
}
  800a0f:	c9                   	leave  
  800a10:	c3                   	ret    
  800a11:	66 90                	xchg   %ax,%ax
  800a13:	66 90                	xchg   %ax,%ax
  800a15:	66 90                	xchg   %ax,%ax
  800a17:	66 90                	xchg   %ax,%ax
  800a19:	66 90                	xchg   %ax,%ax
  800a1b:	66 90                	xchg   %ax,%ax
  800a1d:	66 90                	xchg   %ax,%ax
  800a1f:	90                   	nop

00800a20 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	57                   	push   %edi
  800a24:	56                   	push   %esi
  800a25:	53                   	push   %ebx
  800a26:	83 ec 3c             	sub    $0x3c,%esp
  800a29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a2c:	89 d7                	mov    %edx,%edi
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a37:	89 c3                	mov    %eax,%ebx
  800a39:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800a3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a42:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a47:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a4a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a4d:	39 d9                	cmp    %ebx,%ecx
  800a4f:	72 05                	jb     800a56 <printnum+0x36>
  800a51:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a54:	77 69                	ja     800abf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a56:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a59:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800a5d:	83 ee 01             	sub    $0x1,%esi
  800a60:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800a64:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a68:	8b 44 24 08          	mov    0x8(%esp),%eax
  800a6c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800a70:	89 c3                	mov    %eax,%ebx
  800a72:	89 d6                	mov    %edx,%esi
  800a74:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800a77:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800a7a:	89 54 24 08          	mov    %edx,0x8(%esp)
  800a7e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800a82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a85:	89 04 24             	mov    %eax,(%esp)
  800a88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a8f:	e8 2c 24 00 00       	call   802ec0 <__udivdi3>
  800a94:	89 d9                	mov    %ebx,%ecx
  800a96:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800a9a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800a9e:	89 04 24             	mov    %eax,(%esp)
  800aa1:	89 54 24 04          	mov    %edx,0x4(%esp)
  800aa5:	89 fa                	mov    %edi,%edx
  800aa7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800aaa:	e8 71 ff ff ff       	call   800a20 <printnum>
  800aaf:	eb 1b                	jmp    800acc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ab1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ab5:	8b 45 18             	mov    0x18(%ebp),%eax
  800ab8:	89 04 24             	mov    %eax,(%esp)
  800abb:	ff d3                	call   *%ebx
  800abd:	eb 03                	jmp    800ac2 <printnum+0xa2>
  800abf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ac2:	83 ee 01             	sub    $0x1,%esi
  800ac5:	85 f6                	test   %esi,%esi
  800ac7:	7f e8                	jg     800ab1 <printnum+0x91>
  800ac9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800acc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ad0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800ad4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ad7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800ada:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ade:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ae2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ae5:	89 04 24             	mov    %eax,(%esp)
  800ae8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aef:	e8 fc 24 00 00       	call   802ff0 <__umoddi3>
  800af4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800af8:	0f be 80 ab 33 80 00 	movsbl 0x8033ab(%eax),%eax
  800aff:	89 04 24             	mov    %eax,(%esp)
  800b02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b05:	ff d0                	call   *%eax
}
  800b07:	83 c4 3c             	add    $0x3c,%esp
  800b0a:	5b                   	pop    %ebx
  800b0b:	5e                   	pop    %esi
  800b0c:	5f                   	pop    %edi
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b12:	83 fa 01             	cmp    $0x1,%edx
  800b15:	7e 0e                	jle    800b25 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800b17:	8b 10                	mov    (%eax),%edx
  800b19:	8d 4a 08             	lea    0x8(%edx),%ecx
  800b1c:	89 08                	mov    %ecx,(%eax)
  800b1e:	8b 02                	mov    (%edx),%eax
  800b20:	8b 52 04             	mov    0x4(%edx),%edx
  800b23:	eb 22                	jmp    800b47 <getuint+0x38>
	else if (lflag)
  800b25:	85 d2                	test   %edx,%edx
  800b27:	74 10                	je     800b39 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800b29:	8b 10                	mov    (%eax),%edx
  800b2b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800b2e:	89 08                	mov    %ecx,(%eax)
  800b30:	8b 02                	mov    (%edx),%eax
  800b32:	ba 00 00 00 00       	mov    $0x0,%edx
  800b37:	eb 0e                	jmp    800b47 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800b39:	8b 10                	mov    (%eax),%edx
  800b3b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800b3e:	89 08                	mov    %ecx,(%eax)
  800b40:	8b 02                	mov    (%edx),%eax
  800b42:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b47:	5d                   	pop    %ebp
  800b48:	c3                   	ret    

00800b49 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800b4f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800b53:	8b 10                	mov    (%eax),%edx
  800b55:	3b 50 04             	cmp    0x4(%eax),%edx
  800b58:	73 0a                	jae    800b64 <sprintputch+0x1b>
		*b->buf++ = ch;
  800b5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b5d:	89 08                	mov    %ecx,(%eax)
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	88 02                	mov    %al,(%edx)
}
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b6c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800b6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b73:	8b 45 10             	mov    0x10(%ebp),%eax
  800b76:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	89 04 24             	mov    %eax,(%esp)
  800b87:	e8 02 00 00 00       	call   800b8e <vprintfmt>
	va_end(ap);
}
  800b8c:	c9                   	leave  
  800b8d:	c3                   	ret    

00800b8e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	57                   	push   %edi
  800b92:	56                   	push   %esi
  800b93:	53                   	push   %ebx
  800b94:	83 ec 3c             	sub    $0x3c,%esp
  800b97:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800b9a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b9d:	eb 14                	jmp    800bb3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800b9f:	85 c0                	test   %eax,%eax
  800ba1:	0f 84 b3 03 00 00    	je     800f5a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800ba7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bab:	89 04 24             	mov    %eax,(%esp)
  800bae:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb1:	89 f3                	mov    %esi,%ebx
  800bb3:	8d 73 01             	lea    0x1(%ebx),%esi
  800bb6:	0f b6 03             	movzbl (%ebx),%eax
  800bb9:	83 f8 25             	cmp    $0x25,%eax
  800bbc:	75 e1                	jne    800b9f <vprintfmt+0x11>
  800bbe:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800bc2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800bc9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800bd0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800bd7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdc:	eb 1d                	jmp    800bfb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bde:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800be0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800be4:	eb 15                	jmp    800bfb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800be6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800be8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800bec:	eb 0d                	jmp    800bfb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800bee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bf1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800bf4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bfb:	8d 5e 01             	lea    0x1(%esi),%ebx
  800bfe:	0f b6 0e             	movzbl (%esi),%ecx
  800c01:	0f b6 c1             	movzbl %cl,%eax
  800c04:	83 e9 23             	sub    $0x23,%ecx
  800c07:	80 f9 55             	cmp    $0x55,%cl
  800c0a:	0f 87 2a 03 00 00    	ja     800f3a <vprintfmt+0x3ac>
  800c10:	0f b6 c9             	movzbl %cl,%ecx
  800c13:	ff 24 8d e0 34 80 00 	jmp    *0x8034e0(,%ecx,4)
  800c1a:	89 de                	mov    %ebx,%esi
  800c1c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800c21:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800c24:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800c28:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800c2b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800c2e:	83 fb 09             	cmp    $0x9,%ebx
  800c31:	77 36                	ja     800c69 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c33:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c36:	eb e9                	jmp    800c21 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c38:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3b:	8d 48 04             	lea    0x4(%eax),%ecx
  800c3e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800c41:	8b 00                	mov    (%eax),%eax
  800c43:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c46:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800c48:	eb 22                	jmp    800c6c <vprintfmt+0xde>
  800c4a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800c4d:	85 c9                	test   %ecx,%ecx
  800c4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c54:	0f 49 c1             	cmovns %ecx,%eax
  800c57:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c5a:	89 de                	mov    %ebx,%esi
  800c5c:	eb 9d                	jmp    800bfb <vprintfmt+0x6d>
  800c5e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800c60:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800c67:	eb 92                	jmp    800bfb <vprintfmt+0x6d>
  800c69:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  800c6c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c70:	79 89                	jns    800bfb <vprintfmt+0x6d>
  800c72:	e9 77 ff ff ff       	jmp    800bee <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c77:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c7a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800c7c:	e9 7a ff ff ff       	jmp    800bfb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c81:	8b 45 14             	mov    0x14(%ebp),%eax
  800c84:	8d 50 04             	lea    0x4(%eax),%edx
  800c87:	89 55 14             	mov    %edx,0x14(%ebp)
  800c8a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c8e:	8b 00                	mov    (%eax),%eax
  800c90:	89 04 24             	mov    %eax,(%esp)
  800c93:	ff 55 08             	call   *0x8(%ebp)
			break;
  800c96:	e9 18 ff ff ff       	jmp    800bb3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9e:	8d 50 04             	lea    0x4(%eax),%edx
  800ca1:	89 55 14             	mov    %edx,0x14(%ebp)
  800ca4:	8b 00                	mov    (%eax),%eax
  800ca6:	99                   	cltd   
  800ca7:	31 d0                	xor    %edx,%eax
  800ca9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800cab:	83 f8 11             	cmp    $0x11,%eax
  800cae:	7f 0b                	jg     800cbb <vprintfmt+0x12d>
  800cb0:	8b 14 85 40 36 80 00 	mov    0x803640(,%eax,4),%edx
  800cb7:	85 d2                	test   %edx,%edx
  800cb9:	75 20                	jne    800cdb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  800cbb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cbf:	c7 44 24 08 c3 33 80 	movl   $0x8033c3,0x8(%esp)
  800cc6:	00 
  800cc7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	89 04 24             	mov    %eax,(%esp)
  800cd1:	e8 90 fe ff ff       	call   800b66 <printfmt>
  800cd6:	e9 d8 fe ff ff       	jmp    800bb3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800cdb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800cdf:	c7 44 24 08 7d 37 80 	movl   $0x80377d,0x8(%esp)
  800ce6:	00 
  800ce7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	89 04 24             	mov    %eax,(%esp)
  800cf1:	e8 70 fe ff ff       	call   800b66 <printfmt>
  800cf6:	e9 b8 fe ff ff       	jmp    800bb3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cfb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800cfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d01:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d04:	8b 45 14             	mov    0x14(%ebp),%eax
  800d07:	8d 50 04             	lea    0x4(%eax),%edx
  800d0a:	89 55 14             	mov    %edx,0x14(%ebp)
  800d0d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800d0f:	85 f6                	test   %esi,%esi
  800d11:	b8 bc 33 80 00       	mov    $0x8033bc,%eax
  800d16:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800d19:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800d1d:	0f 84 97 00 00 00    	je     800dba <vprintfmt+0x22c>
  800d23:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800d27:	0f 8e 9b 00 00 00    	jle    800dc8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d2d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800d31:	89 34 24             	mov    %esi,(%esp)
  800d34:	e8 cf 02 00 00       	call   801008 <strnlen>
  800d39:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800d3c:	29 c2                	sub    %eax,%edx
  800d3e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800d41:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800d45:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d48:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800d4b:	8b 75 08             	mov    0x8(%ebp),%esi
  800d4e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d51:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d53:	eb 0f                	jmp    800d64 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800d55:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d5c:	89 04 24             	mov    %eax,(%esp)
  800d5f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d61:	83 eb 01             	sub    $0x1,%ebx
  800d64:	85 db                	test   %ebx,%ebx
  800d66:	7f ed                	jg     800d55 <vprintfmt+0x1c7>
  800d68:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800d6b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800d6e:	85 d2                	test   %edx,%edx
  800d70:	b8 00 00 00 00       	mov    $0x0,%eax
  800d75:	0f 49 c2             	cmovns %edx,%eax
  800d78:	29 c2                	sub    %eax,%edx
  800d7a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800d7d:	89 d7                	mov    %edx,%edi
  800d7f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800d82:	eb 50                	jmp    800dd4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800d84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d88:	74 1e                	je     800da8 <vprintfmt+0x21a>
  800d8a:	0f be d2             	movsbl %dl,%edx
  800d8d:	83 ea 20             	sub    $0x20,%edx
  800d90:	83 fa 5e             	cmp    $0x5e,%edx
  800d93:	76 13                	jbe    800da8 <vprintfmt+0x21a>
					putch('?', putdat);
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d9c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800da3:	ff 55 08             	call   *0x8(%ebp)
  800da6:	eb 0d                	jmp    800db5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800da8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dab:	89 54 24 04          	mov    %edx,0x4(%esp)
  800daf:	89 04 24             	mov    %eax,(%esp)
  800db2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800db5:	83 ef 01             	sub    $0x1,%edi
  800db8:	eb 1a                	jmp    800dd4 <vprintfmt+0x246>
  800dba:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800dbd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800dc0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800dc3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800dc6:	eb 0c                	jmp    800dd4 <vprintfmt+0x246>
  800dc8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800dcb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800dce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800dd1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800dd4:	83 c6 01             	add    $0x1,%esi
  800dd7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800ddb:	0f be c2             	movsbl %dl,%eax
  800dde:	85 c0                	test   %eax,%eax
  800de0:	74 27                	je     800e09 <vprintfmt+0x27b>
  800de2:	85 db                	test   %ebx,%ebx
  800de4:	78 9e                	js     800d84 <vprintfmt+0x1f6>
  800de6:	83 eb 01             	sub    $0x1,%ebx
  800de9:	79 99                	jns    800d84 <vprintfmt+0x1f6>
  800deb:	89 f8                	mov    %edi,%eax
  800ded:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800df0:	8b 75 08             	mov    0x8(%ebp),%esi
  800df3:	89 c3                	mov    %eax,%ebx
  800df5:	eb 1a                	jmp    800e11 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800df7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800dfb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800e02:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e04:	83 eb 01             	sub    $0x1,%ebx
  800e07:	eb 08                	jmp    800e11 <vprintfmt+0x283>
  800e09:	89 fb                	mov    %edi,%ebx
  800e0b:	8b 75 08             	mov    0x8(%ebp),%esi
  800e0e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e11:	85 db                	test   %ebx,%ebx
  800e13:	7f e2                	jg     800df7 <vprintfmt+0x269>
  800e15:	89 75 08             	mov    %esi,0x8(%ebp)
  800e18:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e1b:	e9 93 fd ff ff       	jmp    800bb3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800e20:	83 fa 01             	cmp    $0x1,%edx
  800e23:	7e 16                	jle    800e3b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800e25:	8b 45 14             	mov    0x14(%ebp),%eax
  800e28:	8d 50 08             	lea    0x8(%eax),%edx
  800e2b:	89 55 14             	mov    %edx,0x14(%ebp)
  800e2e:	8b 50 04             	mov    0x4(%eax),%edx
  800e31:	8b 00                	mov    (%eax),%eax
  800e33:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e36:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800e39:	eb 32                	jmp    800e6d <vprintfmt+0x2df>
	else if (lflag)
  800e3b:	85 d2                	test   %edx,%edx
  800e3d:	74 18                	je     800e57 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800e3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e42:	8d 50 04             	lea    0x4(%eax),%edx
  800e45:	89 55 14             	mov    %edx,0x14(%ebp)
  800e48:	8b 30                	mov    (%eax),%esi
  800e4a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800e4d:	89 f0                	mov    %esi,%eax
  800e4f:	c1 f8 1f             	sar    $0x1f,%eax
  800e52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e55:	eb 16                	jmp    800e6d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800e57:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5a:	8d 50 04             	lea    0x4(%eax),%edx
  800e5d:	89 55 14             	mov    %edx,0x14(%ebp)
  800e60:	8b 30                	mov    (%eax),%esi
  800e62:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800e65:	89 f0                	mov    %esi,%eax
  800e67:	c1 f8 1f             	sar    $0x1f,%eax
  800e6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800e73:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800e78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7c:	0f 89 80 00 00 00    	jns    800f02 <vprintfmt+0x374>
				putch('-', putdat);
  800e82:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e86:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800e8d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800e90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e96:	f7 d8                	neg    %eax
  800e98:	83 d2 00             	adc    $0x0,%edx
  800e9b:	f7 da                	neg    %edx
			}
			base = 10;
  800e9d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ea2:	eb 5e                	jmp    800f02 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ea4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ea7:	e8 63 fc ff ff       	call   800b0f <getuint>
			base = 10;
  800eac:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800eb1:	eb 4f                	jmp    800f02 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800eb3:	8d 45 14             	lea    0x14(%ebp),%eax
  800eb6:	e8 54 fc ff ff       	call   800b0f <getuint>
			base = 8;
  800ebb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800ec0:	eb 40                	jmp    800f02 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800ec2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ec6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800ecd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800ed0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ed4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800edb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800ede:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee1:	8d 50 04             	lea    0x4(%eax),%edx
  800ee4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ee7:	8b 00                	mov    (%eax),%eax
  800ee9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800eee:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800ef3:	eb 0d                	jmp    800f02 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ef5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ef8:	e8 12 fc ff ff       	call   800b0f <getuint>
			base = 16;
  800efd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f02:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800f06:	89 74 24 10          	mov    %esi,0x10(%esp)
  800f0a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800f0d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800f11:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800f15:	89 04 24             	mov    %eax,(%esp)
  800f18:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f1c:	89 fa                	mov    %edi,%edx
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	e8 fa fa ff ff       	call   800a20 <printnum>
			break;
  800f26:	e9 88 fc ff ff       	jmp    800bb3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f2b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f2f:	89 04 24             	mov    %eax,(%esp)
  800f32:	ff 55 08             	call   *0x8(%ebp)
			break;
  800f35:	e9 79 fc ff ff       	jmp    800bb3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f3a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f3e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800f45:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f48:	89 f3                	mov    %esi,%ebx
  800f4a:	eb 03                	jmp    800f4f <vprintfmt+0x3c1>
  800f4c:	83 eb 01             	sub    $0x1,%ebx
  800f4f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800f53:	75 f7                	jne    800f4c <vprintfmt+0x3be>
  800f55:	e9 59 fc ff ff       	jmp    800bb3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800f5a:	83 c4 3c             	add    $0x3c,%esp
  800f5d:	5b                   	pop    %ebx
  800f5e:	5e                   	pop    %esi
  800f5f:	5f                   	pop    %edi
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    

00800f62 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 28             	sub    $0x28,%esp
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f71:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800f75:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800f78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f7f:	85 c0                	test   %eax,%eax
  800f81:	74 30                	je     800fb3 <vsnprintf+0x51>
  800f83:	85 d2                	test   %edx,%edx
  800f85:	7e 2c                	jle    800fb3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f87:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800f8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f91:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f95:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f98:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f9c:	c7 04 24 49 0b 80 00 	movl   $0x800b49,(%esp)
  800fa3:	e8 e6 fb ff ff       	call   800b8e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800fa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fab:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb1:	eb 05                	jmp    800fb8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800fb3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800fb8:	c9                   	leave  
  800fb9:	c3                   	ret    

00800fba <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fc0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800fc3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800fc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fca:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	89 04 24             	mov    %eax,(%esp)
  800fdb:	e8 82 ff ff ff       	call   800f62 <vsnprintf>
	va_end(ap);

	return rc;
}
  800fe0:	c9                   	leave  
  800fe1:	c3                   	ret    
  800fe2:	66 90                	xchg   %ax,%ax
  800fe4:	66 90                	xchg   %ax,%ax
  800fe6:	66 90                	xchg   %ax,%ax
  800fe8:	66 90                	xchg   %ax,%ax
  800fea:	66 90                	xchg   %ax,%ax
  800fec:	66 90                	xchg   %ax,%ax
  800fee:	66 90                	xchg   %ax,%ax

00800ff0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
  800ff3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ff6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffb:	eb 03                	jmp    801000 <strlen+0x10>
		n++;
  800ffd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801000:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801004:	75 f7                	jne    800ffd <strlen+0xd>
		n++;
	return n;
}
  801006:	5d                   	pop    %ebp
  801007:	c3                   	ret    

00801008 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80100e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801011:	b8 00 00 00 00       	mov    $0x0,%eax
  801016:	eb 03                	jmp    80101b <strnlen+0x13>
		n++;
  801018:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101b:	39 d0                	cmp    %edx,%eax
  80101d:	74 06                	je     801025 <strnlen+0x1d>
  80101f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801023:	75 f3                	jne    801018 <strnlen+0x10>
		n++;
	return n;
}
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    

00801027 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	53                   	push   %ebx
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801031:	89 c2                	mov    %eax,%edx
  801033:	83 c2 01             	add    $0x1,%edx
  801036:	83 c1 01             	add    $0x1,%ecx
  801039:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80103d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801040:	84 db                	test   %bl,%bl
  801042:	75 ef                	jne    801033 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801044:	5b                   	pop    %ebx
  801045:	5d                   	pop    %ebp
  801046:	c3                   	ret    

00801047 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	53                   	push   %ebx
  80104b:	83 ec 08             	sub    $0x8,%esp
  80104e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801051:	89 1c 24             	mov    %ebx,(%esp)
  801054:	e8 97 ff ff ff       	call   800ff0 <strlen>
	strcpy(dst + len, src);
  801059:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801060:	01 d8                	add    %ebx,%eax
  801062:	89 04 24             	mov    %eax,(%esp)
  801065:	e8 bd ff ff ff       	call   801027 <strcpy>
	return dst;
}
  80106a:	89 d8                	mov    %ebx,%eax
  80106c:	83 c4 08             	add    $0x8,%esp
  80106f:	5b                   	pop    %ebx
  801070:	5d                   	pop    %ebp
  801071:	c3                   	ret    

00801072 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	56                   	push   %esi
  801076:	53                   	push   %ebx
  801077:	8b 75 08             	mov    0x8(%ebp),%esi
  80107a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107d:	89 f3                	mov    %esi,%ebx
  80107f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801082:	89 f2                	mov    %esi,%edx
  801084:	eb 0f                	jmp    801095 <strncpy+0x23>
		*dst++ = *src;
  801086:	83 c2 01             	add    $0x1,%edx
  801089:	0f b6 01             	movzbl (%ecx),%eax
  80108c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80108f:	80 39 01             	cmpb   $0x1,(%ecx)
  801092:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801095:	39 da                	cmp    %ebx,%edx
  801097:	75 ed                	jne    801086 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801099:	89 f0                	mov    %esi,%eax
  80109b:	5b                   	pop    %ebx
  80109c:	5e                   	pop    %esi
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    

0080109f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	56                   	push   %esi
  8010a3:	53                   	push   %ebx
  8010a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8010a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010ad:	89 f0                	mov    %esi,%eax
  8010af:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8010b3:	85 c9                	test   %ecx,%ecx
  8010b5:	75 0b                	jne    8010c2 <strlcpy+0x23>
  8010b7:	eb 1d                	jmp    8010d6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8010b9:	83 c0 01             	add    $0x1,%eax
  8010bc:	83 c2 01             	add    $0x1,%edx
  8010bf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010c2:	39 d8                	cmp    %ebx,%eax
  8010c4:	74 0b                	je     8010d1 <strlcpy+0x32>
  8010c6:	0f b6 0a             	movzbl (%edx),%ecx
  8010c9:	84 c9                	test   %cl,%cl
  8010cb:	75 ec                	jne    8010b9 <strlcpy+0x1a>
  8010cd:	89 c2                	mov    %eax,%edx
  8010cf:	eb 02                	jmp    8010d3 <strlcpy+0x34>
  8010d1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8010d3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8010d6:	29 f0                	sub    %esi,%eax
}
  8010d8:	5b                   	pop    %ebx
  8010d9:	5e                   	pop    %esi
  8010da:	5d                   	pop    %ebp
  8010db:	c3                   	ret    

008010dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8010e5:	eb 06                	jmp    8010ed <strcmp+0x11>
		p++, q++;
  8010e7:	83 c1 01             	add    $0x1,%ecx
  8010ea:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010ed:	0f b6 01             	movzbl (%ecx),%eax
  8010f0:	84 c0                	test   %al,%al
  8010f2:	74 04                	je     8010f8 <strcmp+0x1c>
  8010f4:	3a 02                	cmp    (%edx),%al
  8010f6:	74 ef                	je     8010e7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010f8:	0f b6 c0             	movzbl %al,%eax
  8010fb:	0f b6 12             	movzbl (%edx),%edx
  8010fe:	29 d0                	sub    %edx,%eax
}
  801100:	5d                   	pop    %ebp
  801101:	c3                   	ret    

00801102 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
  801105:	53                   	push   %ebx
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	8b 55 0c             	mov    0xc(%ebp),%edx
  80110c:	89 c3                	mov    %eax,%ebx
  80110e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801111:	eb 06                	jmp    801119 <strncmp+0x17>
		n--, p++, q++;
  801113:	83 c0 01             	add    $0x1,%eax
  801116:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801119:	39 d8                	cmp    %ebx,%eax
  80111b:	74 15                	je     801132 <strncmp+0x30>
  80111d:	0f b6 08             	movzbl (%eax),%ecx
  801120:	84 c9                	test   %cl,%cl
  801122:	74 04                	je     801128 <strncmp+0x26>
  801124:	3a 0a                	cmp    (%edx),%cl
  801126:	74 eb                	je     801113 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801128:	0f b6 00             	movzbl (%eax),%eax
  80112b:	0f b6 12             	movzbl (%edx),%edx
  80112e:	29 d0                	sub    %edx,%eax
  801130:	eb 05                	jmp    801137 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801132:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801137:	5b                   	pop    %ebx
  801138:	5d                   	pop    %ebp
  801139:	c3                   	ret    

0080113a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	8b 45 08             	mov    0x8(%ebp),%eax
  801140:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801144:	eb 07                	jmp    80114d <strchr+0x13>
		if (*s == c)
  801146:	38 ca                	cmp    %cl,%dl
  801148:	74 0f                	je     801159 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80114a:	83 c0 01             	add    $0x1,%eax
  80114d:	0f b6 10             	movzbl (%eax),%edx
  801150:	84 d2                	test   %dl,%dl
  801152:	75 f2                	jne    801146 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801154:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    

0080115b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801165:	eb 07                	jmp    80116e <strfind+0x13>
		if (*s == c)
  801167:	38 ca                	cmp    %cl,%dl
  801169:	74 0a                	je     801175 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80116b:	83 c0 01             	add    $0x1,%eax
  80116e:	0f b6 10             	movzbl (%eax),%edx
  801171:	84 d2                	test   %dl,%dl
  801173:	75 f2                	jne    801167 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  801175:	5d                   	pop    %ebp
  801176:	c3                   	ret    

00801177 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
  80117a:	57                   	push   %edi
  80117b:	56                   	push   %esi
  80117c:	53                   	push   %ebx
  80117d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801180:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801183:	85 c9                	test   %ecx,%ecx
  801185:	74 36                	je     8011bd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801187:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80118d:	75 28                	jne    8011b7 <memset+0x40>
  80118f:	f6 c1 03             	test   $0x3,%cl
  801192:	75 23                	jne    8011b7 <memset+0x40>
		c &= 0xFF;
  801194:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801198:	89 d3                	mov    %edx,%ebx
  80119a:	c1 e3 08             	shl    $0x8,%ebx
  80119d:	89 d6                	mov    %edx,%esi
  80119f:	c1 e6 18             	shl    $0x18,%esi
  8011a2:	89 d0                	mov    %edx,%eax
  8011a4:	c1 e0 10             	shl    $0x10,%eax
  8011a7:	09 f0                	or     %esi,%eax
  8011a9:	09 c2                	or     %eax,%edx
  8011ab:	89 d0                	mov    %edx,%eax
  8011ad:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8011af:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8011b2:	fc                   	cld    
  8011b3:	f3 ab                	rep stos %eax,%es:(%edi)
  8011b5:	eb 06                	jmp    8011bd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	fc                   	cld    
  8011bb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8011bd:	89 f8                	mov    %edi,%eax
  8011bf:	5b                   	pop    %ebx
  8011c0:	5e                   	pop    %esi
  8011c1:	5f                   	pop    %edi
  8011c2:	5d                   	pop    %ebp
  8011c3:	c3                   	ret    

008011c4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
  8011c7:	57                   	push   %edi
  8011c8:	56                   	push   %esi
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011d2:	39 c6                	cmp    %eax,%esi
  8011d4:	73 35                	jae    80120b <memmove+0x47>
  8011d6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8011d9:	39 d0                	cmp    %edx,%eax
  8011db:	73 2e                	jae    80120b <memmove+0x47>
		s += n;
		d += n;
  8011dd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8011e0:	89 d6                	mov    %edx,%esi
  8011e2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8011e4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8011ea:	75 13                	jne    8011ff <memmove+0x3b>
  8011ec:	f6 c1 03             	test   $0x3,%cl
  8011ef:	75 0e                	jne    8011ff <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011f1:	83 ef 04             	sub    $0x4,%edi
  8011f4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8011f7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011fa:	fd                   	std    
  8011fb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8011fd:	eb 09                	jmp    801208 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011ff:	83 ef 01             	sub    $0x1,%edi
  801202:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801205:	fd                   	std    
  801206:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801208:	fc                   	cld    
  801209:	eb 1d                	jmp    801228 <memmove+0x64>
  80120b:	89 f2                	mov    %esi,%edx
  80120d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80120f:	f6 c2 03             	test   $0x3,%dl
  801212:	75 0f                	jne    801223 <memmove+0x5f>
  801214:	f6 c1 03             	test   $0x3,%cl
  801217:	75 0a                	jne    801223 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801219:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80121c:	89 c7                	mov    %eax,%edi
  80121e:	fc                   	cld    
  80121f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801221:	eb 05                	jmp    801228 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801223:	89 c7                	mov    %eax,%edi
  801225:	fc                   	cld    
  801226:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801228:	5e                   	pop    %esi
  801229:	5f                   	pop    %edi
  80122a:	5d                   	pop    %ebp
  80122b:	c3                   	ret    

0080122c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801232:	8b 45 10             	mov    0x10(%ebp),%eax
  801235:	89 44 24 08          	mov    %eax,0x8(%esp)
  801239:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	89 04 24             	mov    %eax,(%esp)
  801246:	e8 79 ff ff ff       	call   8011c4 <memmove>
}
  80124b:	c9                   	leave  
  80124c:	c3                   	ret    

0080124d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
  801250:	56                   	push   %esi
  801251:	53                   	push   %ebx
  801252:	8b 55 08             	mov    0x8(%ebp),%edx
  801255:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801258:	89 d6                	mov    %edx,%esi
  80125a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80125d:	eb 1a                	jmp    801279 <memcmp+0x2c>
		if (*s1 != *s2)
  80125f:	0f b6 02             	movzbl (%edx),%eax
  801262:	0f b6 19             	movzbl (%ecx),%ebx
  801265:	38 d8                	cmp    %bl,%al
  801267:	74 0a                	je     801273 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  801269:	0f b6 c0             	movzbl %al,%eax
  80126c:	0f b6 db             	movzbl %bl,%ebx
  80126f:	29 d8                	sub    %ebx,%eax
  801271:	eb 0f                	jmp    801282 <memcmp+0x35>
		s1++, s2++;
  801273:	83 c2 01             	add    $0x1,%edx
  801276:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801279:	39 f2                	cmp    %esi,%edx
  80127b:	75 e2                	jne    80125f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80127d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801282:	5b                   	pop    %ebx
  801283:	5e                   	pop    %esi
  801284:	5d                   	pop    %ebp
  801285:	c3                   	ret    

00801286 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80128f:	89 c2                	mov    %eax,%edx
  801291:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801294:	eb 07                	jmp    80129d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  801296:	38 08                	cmp    %cl,(%eax)
  801298:	74 07                	je     8012a1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80129a:	83 c0 01             	add    $0x1,%eax
  80129d:	39 d0                	cmp    %edx,%eax
  80129f:	72 f5                	jb     801296 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8012a1:	5d                   	pop    %ebp
  8012a2:	c3                   	ret    

008012a3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	57                   	push   %edi
  8012a7:	56                   	push   %esi
  8012a8:	53                   	push   %ebx
  8012a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ac:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012af:	eb 03                	jmp    8012b4 <strtol+0x11>
		s++;
  8012b1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8012b4:	0f b6 0a             	movzbl (%edx),%ecx
  8012b7:	80 f9 09             	cmp    $0x9,%cl
  8012ba:	74 f5                	je     8012b1 <strtol+0xe>
  8012bc:	80 f9 20             	cmp    $0x20,%cl
  8012bf:	74 f0                	je     8012b1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8012c1:	80 f9 2b             	cmp    $0x2b,%cl
  8012c4:	75 0a                	jne    8012d0 <strtol+0x2d>
		s++;
  8012c6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8012c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8012ce:	eb 11                	jmp    8012e1 <strtol+0x3e>
  8012d0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8012d5:	80 f9 2d             	cmp    $0x2d,%cl
  8012d8:	75 07                	jne    8012e1 <strtol+0x3e>
		s++, neg = 1;
  8012da:	8d 52 01             	lea    0x1(%edx),%edx
  8012dd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012e1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  8012e6:	75 15                	jne    8012fd <strtol+0x5a>
  8012e8:	80 3a 30             	cmpb   $0x30,(%edx)
  8012eb:	75 10                	jne    8012fd <strtol+0x5a>
  8012ed:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8012f1:	75 0a                	jne    8012fd <strtol+0x5a>
		s += 2, base = 16;
  8012f3:	83 c2 02             	add    $0x2,%edx
  8012f6:	b8 10 00 00 00       	mov    $0x10,%eax
  8012fb:	eb 10                	jmp    80130d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  8012fd:	85 c0                	test   %eax,%eax
  8012ff:	75 0c                	jne    80130d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801301:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801303:	80 3a 30             	cmpb   $0x30,(%edx)
  801306:	75 05                	jne    80130d <strtol+0x6a>
		s++, base = 8;
  801308:	83 c2 01             	add    $0x1,%edx
  80130b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80130d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801312:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801315:	0f b6 0a             	movzbl (%edx),%ecx
  801318:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80131b:	89 f0                	mov    %esi,%eax
  80131d:	3c 09                	cmp    $0x9,%al
  80131f:	77 08                	ja     801329 <strtol+0x86>
			dig = *s - '0';
  801321:	0f be c9             	movsbl %cl,%ecx
  801324:	83 e9 30             	sub    $0x30,%ecx
  801327:	eb 20                	jmp    801349 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  801329:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80132c:	89 f0                	mov    %esi,%eax
  80132e:	3c 19                	cmp    $0x19,%al
  801330:	77 08                	ja     80133a <strtol+0x97>
			dig = *s - 'a' + 10;
  801332:	0f be c9             	movsbl %cl,%ecx
  801335:	83 e9 57             	sub    $0x57,%ecx
  801338:	eb 0f                	jmp    801349 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80133a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80133d:	89 f0                	mov    %esi,%eax
  80133f:	3c 19                	cmp    $0x19,%al
  801341:	77 16                	ja     801359 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801343:	0f be c9             	movsbl %cl,%ecx
  801346:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801349:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80134c:	7d 0f                	jge    80135d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80134e:	83 c2 01             	add    $0x1,%edx
  801351:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801355:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801357:	eb bc                	jmp    801315 <strtol+0x72>
  801359:	89 d8                	mov    %ebx,%eax
  80135b:	eb 02                	jmp    80135f <strtol+0xbc>
  80135d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80135f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801363:	74 05                	je     80136a <strtol+0xc7>
		*endptr = (char *) s;
  801365:	8b 75 0c             	mov    0xc(%ebp),%esi
  801368:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80136a:	f7 d8                	neg    %eax
  80136c:	85 ff                	test   %edi,%edi
  80136e:	0f 44 c3             	cmove  %ebx,%eax
}
  801371:	5b                   	pop    %ebx
  801372:	5e                   	pop    %esi
  801373:	5f                   	pop    %edi
  801374:	5d                   	pop    %ebp
  801375:	c3                   	ret    

00801376 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	57                   	push   %edi
  80137a:	56                   	push   %esi
  80137b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80137c:	b8 00 00 00 00       	mov    $0x0,%eax
  801381:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801384:	8b 55 08             	mov    0x8(%ebp),%edx
  801387:	89 c3                	mov    %eax,%ebx
  801389:	89 c7                	mov    %eax,%edi
  80138b:	89 c6                	mov    %eax,%esi
  80138d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80138f:	5b                   	pop    %ebx
  801390:	5e                   	pop    %esi
  801391:	5f                   	pop    %edi
  801392:	5d                   	pop    %ebp
  801393:	c3                   	ret    

00801394 <sys_cgetc>:

int
sys_cgetc(void)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	57                   	push   %edi
  801398:	56                   	push   %esi
  801399:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80139a:	ba 00 00 00 00       	mov    $0x0,%edx
  80139f:	b8 01 00 00 00       	mov    $0x1,%eax
  8013a4:	89 d1                	mov    %edx,%ecx
  8013a6:	89 d3                	mov    %edx,%ebx
  8013a8:	89 d7                	mov    %edx,%edi
  8013aa:	89 d6                	mov    %edx,%esi
  8013ac:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8013ae:	5b                   	pop    %ebx
  8013af:	5e                   	pop    %esi
  8013b0:	5f                   	pop    %edi
  8013b1:	5d                   	pop    %ebp
  8013b2:	c3                   	ret    

008013b3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	57                   	push   %edi
  8013b7:	56                   	push   %esi
  8013b8:	53                   	push   %ebx
  8013b9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013c1:	b8 03 00 00 00       	mov    $0x3,%eax
  8013c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c9:	89 cb                	mov    %ecx,%ebx
  8013cb:	89 cf                	mov    %ecx,%edi
  8013cd:	89 ce                	mov    %ecx,%esi
  8013cf:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8013d1:	85 c0                	test   %eax,%eax
  8013d3:	7e 28                	jle    8013fd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013d9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8013e0:	00 
  8013e1:	c7 44 24 08 a7 36 80 	movl   $0x8036a7,0x8(%esp)
  8013e8:	00 
  8013e9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013f0:	00 
  8013f1:	c7 04 24 c4 36 80 00 	movl   $0x8036c4,(%esp)
  8013f8:	e8 01 f5 ff ff       	call   8008fe <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8013fd:	83 c4 2c             	add    $0x2c,%esp
  801400:	5b                   	pop    %ebx
  801401:	5e                   	pop    %esi
  801402:	5f                   	pop    %edi
  801403:	5d                   	pop    %ebp
  801404:	c3                   	ret    

00801405 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	57                   	push   %edi
  801409:	56                   	push   %esi
  80140a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80140b:	ba 00 00 00 00       	mov    $0x0,%edx
  801410:	b8 02 00 00 00       	mov    $0x2,%eax
  801415:	89 d1                	mov    %edx,%ecx
  801417:	89 d3                	mov    %edx,%ebx
  801419:	89 d7                	mov    %edx,%edi
  80141b:	89 d6                	mov    %edx,%esi
  80141d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80141f:	5b                   	pop    %ebx
  801420:	5e                   	pop    %esi
  801421:	5f                   	pop    %edi
  801422:	5d                   	pop    %ebp
  801423:	c3                   	ret    

00801424 <sys_yield>:

void
sys_yield(void)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	57                   	push   %edi
  801428:	56                   	push   %esi
  801429:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80142a:	ba 00 00 00 00       	mov    $0x0,%edx
  80142f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801434:	89 d1                	mov    %edx,%ecx
  801436:	89 d3                	mov    %edx,%ebx
  801438:	89 d7                	mov    %edx,%edi
  80143a:	89 d6                	mov    %edx,%esi
  80143c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80143e:	5b                   	pop    %ebx
  80143f:	5e                   	pop    %esi
  801440:	5f                   	pop    %edi
  801441:	5d                   	pop    %ebp
  801442:	c3                   	ret    

00801443 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	57                   	push   %edi
  801447:	56                   	push   %esi
  801448:	53                   	push   %ebx
  801449:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80144c:	be 00 00 00 00       	mov    $0x0,%esi
  801451:	b8 04 00 00 00       	mov    $0x4,%eax
  801456:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801459:	8b 55 08             	mov    0x8(%ebp),%edx
  80145c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80145f:	89 f7                	mov    %esi,%edi
  801461:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801463:	85 c0                	test   %eax,%eax
  801465:	7e 28                	jle    80148f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801467:	89 44 24 10          	mov    %eax,0x10(%esp)
  80146b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801472:	00 
  801473:	c7 44 24 08 a7 36 80 	movl   $0x8036a7,0x8(%esp)
  80147a:	00 
  80147b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801482:	00 
  801483:	c7 04 24 c4 36 80 00 	movl   $0x8036c4,(%esp)
  80148a:	e8 6f f4 ff ff       	call   8008fe <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80148f:	83 c4 2c             	add    $0x2c,%esp
  801492:	5b                   	pop    %ebx
  801493:	5e                   	pop    %esi
  801494:	5f                   	pop    %edi
  801495:	5d                   	pop    %ebp
  801496:	c3                   	ret    

00801497 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	57                   	push   %edi
  80149b:	56                   	push   %esi
  80149c:	53                   	push   %ebx
  80149d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8014a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014ae:	8b 7d 14             	mov    0x14(%ebp),%edi
  8014b1:	8b 75 18             	mov    0x18(%ebp),%esi
  8014b4:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8014b6:	85 c0                	test   %eax,%eax
  8014b8:	7e 28                	jle    8014e2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014ba:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014be:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8014c5:	00 
  8014c6:	c7 44 24 08 a7 36 80 	movl   $0x8036a7,0x8(%esp)
  8014cd:	00 
  8014ce:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014d5:	00 
  8014d6:	c7 04 24 c4 36 80 00 	movl   $0x8036c4,(%esp)
  8014dd:	e8 1c f4 ff ff       	call   8008fe <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8014e2:	83 c4 2c             	add    $0x2c,%esp
  8014e5:	5b                   	pop    %ebx
  8014e6:	5e                   	pop    %esi
  8014e7:	5f                   	pop    %edi
  8014e8:	5d                   	pop    %ebp
  8014e9:	c3                   	ret    

008014ea <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
  8014ed:	57                   	push   %edi
  8014ee:	56                   	push   %esi
  8014ef:	53                   	push   %ebx
  8014f0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014f8:	b8 06 00 00 00       	mov    $0x6,%eax
  8014fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801500:	8b 55 08             	mov    0x8(%ebp),%edx
  801503:	89 df                	mov    %ebx,%edi
  801505:	89 de                	mov    %ebx,%esi
  801507:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801509:	85 c0                	test   %eax,%eax
  80150b:	7e 28                	jle    801535 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80150d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801511:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801518:	00 
  801519:	c7 44 24 08 a7 36 80 	movl   $0x8036a7,0x8(%esp)
  801520:	00 
  801521:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801528:	00 
  801529:	c7 04 24 c4 36 80 00 	movl   $0x8036c4,(%esp)
  801530:	e8 c9 f3 ff ff       	call   8008fe <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801535:	83 c4 2c             	add    $0x2c,%esp
  801538:	5b                   	pop    %ebx
  801539:	5e                   	pop    %esi
  80153a:	5f                   	pop    %edi
  80153b:	5d                   	pop    %ebp
  80153c:	c3                   	ret    

0080153d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
  801540:	57                   	push   %edi
  801541:	56                   	push   %esi
  801542:	53                   	push   %ebx
  801543:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801546:	bb 00 00 00 00       	mov    $0x0,%ebx
  80154b:	b8 08 00 00 00       	mov    $0x8,%eax
  801550:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801553:	8b 55 08             	mov    0x8(%ebp),%edx
  801556:	89 df                	mov    %ebx,%edi
  801558:	89 de                	mov    %ebx,%esi
  80155a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80155c:	85 c0                	test   %eax,%eax
  80155e:	7e 28                	jle    801588 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801560:	89 44 24 10          	mov    %eax,0x10(%esp)
  801564:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80156b:	00 
  80156c:	c7 44 24 08 a7 36 80 	movl   $0x8036a7,0x8(%esp)
  801573:	00 
  801574:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80157b:	00 
  80157c:	c7 04 24 c4 36 80 00 	movl   $0x8036c4,(%esp)
  801583:	e8 76 f3 ff ff       	call   8008fe <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801588:	83 c4 2c             	add    $0x2c,%esp
  80158b:	5b                   	pop    %ebx
  80158c:	5e                   	pop    %esi
  80158d:	5f                   	pop    %edi
  80158e:	5d                   	pop    %ebp
  80158f:	c3                   	ret    

00801590 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	57                   	push   %edi
  801594:	56                   	push   %esi
  801595:	53                   	push   %ebx
  801596:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801599:	bb 00 00 00 00       	mov    $0x0,%ebx
  80159e:	b8 09 00 00 00       	mov    $0x9,%eax
  8015a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a9:	89 df                	mov    %ebx,%edi
  8015ab:	89 de                	mov    %ebx,%esi
  8015ad:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8015af:	85 c0                	test   %eax,%eax
  8015b1:	7e 28                	jle    8015db <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015b3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015b7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8015be:	00 
  8015bf:	c7 44 24 08 a7 36 80 	movl   $0x8036a7,0x8(%esp)
  8015c6:	00 
  8015c7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8015ce:	00 
  8015cf:	c7 04 24 c4 36 80 00 	movl   $0x8036c4,(%esp)
  8015d6:	e8 23 f3 ff ff       	call   8008fe <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8015db:	83 c4 2c             	add    $0x2c,%esp
  8015de:	5b                   	pop    %ebx
  8015df:	5e                   	pop    %esi
  8015e0:	5f                   	pop    %edi
  8015e1:	5d                   	pop    %ebp
  8015e2:	c3                   	ret    

008015e3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	57                   	push   %edi
  8015e7:	56                   	push   %esi
  8015e8:	53                   	push   %ebx
  8015e9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015f1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8015fc:	89 df                	mov    %ebx,%edi
  8015fe:	89 de                	mov    %ebx,%esi
  801600:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801602:	85 c0                	test   %eax,%eax
  801604:	7e 28                	jle    80162e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801606:	89 44 24 10          	mov    %eax,0x10(%esp)
  80160a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801611:	00 
  801612:	c7 44 24 08 a7 36 80 	movl   $0x8036a7,0x8(%esp)
  801619:	00 
  80161a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801621:	00 
  801622:	c7 04 24 c4 36 80 00 	movl   $0x8036c4,(%esp)
  801629:	e8 d0 f2 ff ff       	call   8008fe <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80162e:	83 c4 2c             	add    $0x2c,%esp
  801631:	5b                   	pop    %ebx
  801632:	5e                   	pop    %esi
  801633:	5f                   	pop    %edi
  801634:	5d                   	pop    %ebp
  801635:	c3                   	ret    

00801636 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	57                   	push   %edi
  80163a:	56                   	push   %esi
  80163b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80163c:	be 00 00 00 00       	mov    $0x0,%esi
  801641:	b8 0c 00 00 00       	mov    $0xc,%eax
  801646:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801649:	8b 55 08             	mov    0x8(%ebp),%edx
  80164c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80164f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801652:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801654:	5b                   	pop    %ebx
  801655:	5e                   	pop    %esi
  801656:	5f                   	pop    %edi
  801657:	5d                   	pop    %ebp
  801658:	c3                   	ret    

00801659 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	57                   	push   %edi
  80165d:	56                   	push   %esi
  80165e:	53                   	push   %ebx
  80165f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801662:	b9 00 00 00 00       	mov    $0x0,%ecx
  801667:	b8 0d 00 00 00       	mov    $0xd,%eax
  80166c:	8b 55 08             	mov    0x8(%ebp),%edx
  80166f:	89 cb                	mov    %ecx,%ebx
  801671:	89 cf                	mov    %ecx,%edi
  801673:	89 ce                	mov    %ecx,%esi
  801675:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801677:	85 c0                	test   %eax,%eax
  801679:	7e 28                	jle    8016a3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80167b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80167f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801686:	00 
  801687:	c7 44 24 08 a7 36 80 	movl   $0x8036a7,0x8(%esp)
  80168e:	00 
  80168f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801696:	00 
  801697:	c7 04 24 c4 36 80 00 	movl   $0x8036c4,(%esp)
  80169e:	e8 5b f2 ff ff       	call   8008fe <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8016a3:	83 c4 2c             	add    $0x2c,%esp
  8016a6:	5b                   	pop    %ebx
  8016a7:	5e                   	pop    %esi
  8016a8:	5f                   	pop    %edi
  8016a9:	5d                   	pop    %ebp
  8016aa:	c3                   	ret    

008016ab <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	57                   	push   %edi
  8016af:	56                   	push   %esi
  8016b0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8016bb:	89 d1                	mov    %edx,%ecx
  8016bd:	89 d3                	mov    %edx,%ebx
  8016bf:	89 d7                	mov    %edx,%edi
  8016c1:	89 d6                	mov    %edx,%esi
  8016c3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8016c5:	5b                   	pop    %ebx
  8016c6:	5e                   	pop    %esi
  8016c7:	5f                   	pop    %edi
  8016c8:	5d                   	pop    %ebp
  8016c9:	c3                   	ret    

008016ca <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	57                   	push   %edi
  8016ce:	56                   	push   %esi
  8016cf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016d5:	b8 0f 00 00 00       	mov    $0xf,%eax
  8016da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e0:	89 df                	mov    %ebx,%edi
  8016e2:	89 de                	mov    %ebx,%esi
  8016e4:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  8016e6:	5b                   	pop    %ebx
  8016e7:	5e                   	pop    %esi
  8016e8:	5f                   	pop    %edi
  8016e9:	5d                   	pop    %ebp
  8016ea:	c3                   	ret    

008016eb <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	57                   	push   %edi
  8016ef:	56                   	push   %esi
  8016f0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016f6:	b8 10 00 00 00       	mov    $0x10,%eax
  8016fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016fe:	8b 55 08             	mov    0x8(%ebp),%edx
  801701:	89 df                	mov    %ebx,%edi
  801703:	89 de                	mov    %ebx,%esi
  801705:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  801707:	5b                   	pop    %ebx
  801708:	5e                   	pop    %esi
  801709:	5f                   	pop    %edi
  80170a:	5d                   	pop    %ebp
  80170b:	c3                   	ret    

0080170c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	57                   	push   %edi
  801710:	56                   	push   %esi
  801711:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801712:	b9 00 00 00 00       	mov    $0x0,%ecx
  801717:	b8 11 00 00 00       	mov    $0x11,%eax
  80171c:	8b 55 08             	mov    0x8(%ebp),%edx
  80171f:	89 cb                	mov    %ecx,%ebx
  801721:	89 cf                	mov    %ecx,%edi
  801723:	89 ce                	mov    %ecx,%esi
  801725:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  801727:	5b                   	pop    %ebx
  801728:	5e                   	pop    %esi
  801729:	5f                   	pop    %edi
  80172a:	5d                   	pop    %ebp
  80172b:	c3                   	ret    

0080172c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	57                   	push   %edi
  801730:	56                   	push   %esi
  801731:	53                   	push   %ebx
  801732:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801735:	be 00 00 00 00       	mov    $0x0,%esi
  80173a:	b8 12 00 00 00       	mov    $0x12,%eax
  80173f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801742:	8b 55 08             	mov    0x8(%ebp),%edx
  801745:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801748:	8b 7d 14             	mov    0x14(%ebp),%edi
  80174b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80174d:	85 c0                	test   %eax,%eax
  80174f:	7e 28                	jle    801779 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  801751:	89 44 24 10          	mov    %eax,0x10(%esp)
  801755:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  80175c:	00 
  80175d:	c7 44 24 08 a7 36 80 	movl   $0x8036a7,0x8(%esp)
  801764:	00 
  801765:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80176c:	00 
  80176d:	c7 04 24 c4 36 80 00 	movl   $0x8036c4,(%esp)
  801774:	e8 85 f1 ff ff       	call   8008fe <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  801779:	83 c4 2c             	add    $0x2c,%esp
  80177c:	5b                   	pop    %ebx
  80177d:	5e                   	pop    %esi
  80177e:	5f                   	pop    %edi
  80177f:	5d                   	pop    %ebp
  801780:	c3                   	ret    
  801781:	66 90                	xchg   %ax,%ax
  801783:	66 90                	xchg   %ax,%ax
  801785:	66 90                	xchg   %ax,%ax
  801787:	66 90                	xchg   %ax,%ax
  801789:	66 90                	xchg   %ax,%ax
  80178b:	66 90                	xchg   %ax,%ax
  80178d:	66 90                	xchg   %ax,%ax
  80178f:	90                   	nop

00801790 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
  801796:	05 00 00 00 30       	add    $0x30000000,%eax
  80179b:	c1 e8 0c             	shr    $0xc,%eax
}
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    

008017a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8017ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017b0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017b5:	5d                   	pop    %ebp
  8017b6:	c3                   	ret    

008017b7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017bd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017c2:	89 c2                	mov    %eax,%edx
  8017c4:	c1 ea 16             	shr    $0x16,%edx
  8017c7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017ce:	f6 c2 01             	test   $0x1,%dl
  8017d1:	74 11                	je     8017e4 <fd_alloc+0x2d>
  8017d3:	89 c2                	mov    %eax,%edx
  8017d5:	c1 ea 0c             	shr    $0xc,%edx
  8017d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017df:	f6 c2 01             	test   $0x1,%dl
  8017e2:	75 09                	jne    8017ed <fd_alloc+0x36>
			*fd_store = fd;
  8017e4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017eb:	eb 17                	jmp    801804 <fd_alloc+0x4d>
  8017ed:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8017f2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017f7:	75 c9                	jne    8017c2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017f9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8017ff:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801804:	5d                   	pop    %ebp
  801805:	c3                   	ret    

00801806 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80180c:	83 f8 1f             	cmp    $0x1f,%eax
  80180f:	77 36                	ja     801847 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801811:	c1 e0 0c             	shl    $0xc,%eax
  801814:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801819:	89 c2                	mov    %eax,%edx
  80181b:	c1 ea 16             	shr    $0x16,%edx
  80181e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801825:	f6 c2 01             	test   $0x1,%dl
  801828:	74 24                	je     80184e <fd_lookup+0x48>
  80182a:	89 c2                	mov    %eax,%edx
  80182c:	c1 ea 0c             	shr    $0xc,%edx
  80182f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801836:	f6 c2 01             	test   $0x1,%dl
  801839:	74 1a                	je     801855 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80183b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183e:	89 02                	mov    %eax,(%edx)
	return 0;
  801840:	b8 00 00 00 00       	mov    $0x0,%eax
  801845:	eb 13                	jmp    80185a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801847:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80184c:	eb 0c                	jmp    80185a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80184e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801853:	eb 05                	jmp    80185a <fd_lookup+0x54>
  801855:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80185a:	5d                   	pop    %ebp
  80185b:	c3                   	ret    

0080185c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 18             	sub    $0x18,%esp
  801862:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801865:	ba 00 00 00 00       	mov    $0x0,%edx
  80186a:	eb 13                	jmp    80187f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80186c:	39 08                	cmp    %ecx,(%eax)
  80186e:	75 0c                	jne    80187c <dev_lookup+0x20>
			*dev = devtab[i];
  801870:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801873:	89 01                	mov    %eax,(%ecx)
			return 0;
  801875:	b8 00 00 00 00       	mov    $0x0,%eax
  80187a:	eb 38                	jmp    8018b4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80187c:	83 c2 01             	add    $0x1,%edx
  80187f:	8b 04 95 50 37 80 00 	mov    0x803750(,%edx,4),%eax
  801886:	85 c0                	test   %eax,%eax
  801888:	75 e2                	jne    80186c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80188a:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80188f:	8b 40 48             	mov    0x48(%eax),%eax
  801892:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801896:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189a:	c7 04 24 d4 36 80 00 	movl   $0x8036d4,(%esp)
  8018a1:	e8 51 f1 ff ff       	call   8009f7 <cprintf>
	*dev = 0;
  8018a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8018af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	56                   	push   %esi
  8018ba:	53                   	push   %ebx
  8018bb:	83 ec 20             	sub    $0x20,%esp
  8018be:	8b 75 08             	mov    0x8(%ebp),%esi
  8018c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018cb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018d1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018d4:	89 04 24             	mov    %eax,(%esp)
  8018d7:	e8 2a ff ff ff       	call   801806 <fd_lookup>
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	78 05                	js     8018e5 <fd_close+0x2f>
	    || fd != fd2)
  8018e0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8018e3:	74 0c                	je     8018f1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8018e5:	84 db                	test   %bl,%bl
  8018e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ec:	0f 44 c2             	cmove  %edx,%eax
  8018ef:	eb 3f                	jmp    801930 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f8:	8b 06                	mov    (%esi),%eax
  8018fa:	89 04 24             	mov    %eax,(%esp)
  8018fd:	e8 5a ff ff ff       	call   80185c <dev_lookup>
  801902:	89 c3                	mov    %eax,%ebx
  801904:	85 c0                	test   %eax,%eax
  801906:	78 16                	js     80191e <fd_close+0x68>
		if (dev->dev_close)
  801908:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80190e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801913:	85 c0                	test   %eax,%eax
  801915:	74 07                	je     80191e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801917:	89 34 24             	mov    %esi,(%esp)
  80191a:	ff d0                	call   *%eax
  80191c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80191e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801922:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801929:	e8 bc fb ff ff       	call   8014ea <sys_page_unmap>
	return r;
  80192e:	89 d8                	mov    %ebx,%eax
}
  801930:	83 c4 20             	add    $0x20,%esp
  801933:	5b                   	pop    %ebx
  801934:	5e                   	pop    %esi
  801935:	5d                   	pop    %ebp
  801936:	c3                   	ret    

00801937 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80193d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801940:	89 44 24 04          	mov    %eax,0x4(%esp)
  801944:	8b 45 08             	mov    0x8(%ebp),%eax
  801947:	89 04 24             	mov    %eax,(%esp)
  80194a:	e8 b7 fe ff ff       	call   801806 <fd_lookup>
  80194f:	89 c2                	mov    %eax,%edx
  801951:	85 d2                	test   %edx,%edx
  801953:	78 13                	js     801968 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801955:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80195c:	00 
  80195d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801960:	89 04 24             	mov    %eax,(%esp)
  801963:	e8 4e ff ff ff       	call   8018b6 <fd_close>
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <close_all>:

void
close_all(void)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	53                   	push   %ebx
  80196e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801971:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801976:	89 1c 24             	mov    %ebx,(%esp)
  801979:	e8 b9 ff ff ff       	call   801937 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80197e:	83 c3 01             	add    $0x1,%ebx
  801981:	83 fb 20             	cmp    $0x20,%ebx
  801984:	75 f0                	jne    801976 <close_all+0xc>
		close(i);
}
  801986:	83 c4 14             	add    $0x14,%esp
  801989:	5b                   	pop    %ebx
  80198a:	5d                   	pop    %ebp
  80198b:	c3                   	ret    

0080198c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	57                   	push   %edi
  801990:	56                   	push   %esi
  801991:	53                   	push   %ebx
  801992:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801995:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801998:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	89 04 24             	mov    %eax,(%esp)
  8019a2:	e8 5f fe ff ff       	call   801806 <fd_lookup>
  8019a7:	89 c2                	mov    %eax,%edx
  8019a9:	85 d2                	test   %edx,%edx
  8019ab:	0f 88 e1 00 00 00    	js     801a92 <dup+0x106>
		return r;
	close(newfdnum);
  8019b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b4:	89 04 24             	mov    %eax,(%esp)
  8019b7:	e8 7b ff ff ff       	call   801937 <close>

	newfd = INDEX2FD(newfdnum);
  8019bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8019bf:	c1 e3 0c             	shl    $0xc,%ebx
  8019c2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8019c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019cb:	89 04 24             	mov    %eax,(%esp)
  8019ce:	e8 cd fd ff ff       	call   8017a0 <fd2data>
  8019d3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8019d5:	89 1c 24             	mov    %ebx,(%esp)
  8019d8:	e8 c3 fd ff ff       	call   8017a0 <fd2data>
  8019dd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019df:	89 f0                	mov    %esi,%eax
  8019e1:	c1 e8 16             	shr    $0x16,%eax
  8019e4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019eb:	a8 01                	test   $0x1,%al
  8019ed:	74 43                	je     801a32 <dup+0xa6>
  8019ef:	89 f0                	mov    %esi,%eax
  8019f1:	c1 e8 0c             	shr    $0xc,%eax
  8019f4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019fb:	f6 c2 01             	test   $0x1,%dl
  8019fe:	74 32                	je     801a32 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a00:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a07:	25 07 0e 00 00       	and    $0xe07,%eax
  801a0c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a10:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a14:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a1b:	00 
  801a1c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a20:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a27:	e8 6b fa ff ff       	call   801497 <sys_page_map>
  801a2c:	89 c6                	mov    %eax,%esi
  801a2e:	85 c0                	test   %eax,%eax
  801a30:	78 3e                	js     801a70 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a35:	89 c2                	mov    %eax,%edx
  801a37:	c1 ea 0c             	shr    $0xc,%edx
  801a3a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a41:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a47:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801a4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a56:	00 
  801a57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a62:	e8 30 fa ff ff       	call   801497 <sys_page_map>
  801a67:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801a69:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a6c:	85 f6                	test   %esi,%esi
  801a6e:	79 22                	jns    801a92 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801a70:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a74:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a7b:	e8 6a fa ff ff       	call   8014ea <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a80:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a8b:	e8 5a fa ff ff       	call   8014ea <sys_page_unmap>
	return r;
  801a90:	89 f0                	mov    %esi,%eax
}
  801a92:	83 c4 3c             	add    $0x3c,%esp
  801a95:	5b                   	pop    %ebx
  801a96:	5e                   	pop    %esi
  801a97:	5f                   	pop    %edi
  801a98:	5d                   	pop    %ebp
  801a99:	c3                   	ret    

00801a9a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	53                   	push   %ebx
  801a9e:	83 ec 24             	sub    $0x24,%esp
  801aa1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aa4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aab:	89 1c 24             	mov    %ebx,(%esp)
  801aae:	e8 53 fd ff ff       	call   801806 <fd_lookup>
  801ab3:	89 c2                	mov    %eax,%edx
  801ab5:	85 d2                	test   %edx,%edx
  801ab7:	78 6d                	js     801b26 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ab9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801abc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac3:	8b 00                	mov    (%eax),%eax
  801ac5:	89 04 24             	mov    %eax,(%esp)
  801ac8:	e8 8f fd ff ff       	call   80185c <dev_lookup>
  801acd:	85 c0                	test   %eax,%eax
  801acf:	78 55                	js     801b26 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad4:	8b 50 08             	mov    0x8(%eax),%edx
  801ad7:	83 e2 03             	and    $0x3,%edx
  801ada:	83 fa 01             	cmp    $0x1,%edx
  801add:	75 23                	jne    801b02 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801adf:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801ae4:	8b 40 48             	mov    0x48(%eax),%eax
  801ae7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aef:	c7 04 24 15 37 80 00 	movl   $0x803715,(%esp)
  801af6:	e8 fc ee ff ff       	call   8009f7 <cprintf>
		return -E_INVAL;
  801afb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b00:	eb 24                	jmp    801b26 <read+0x8c>
	}
	if (!dev->dev_read)
  801b02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b05:	8b 52 08             	mov    0x8(%edx),%edx
  801b08:	85 d2                	test   %edx,%edx
  801b0a:	74 15                	je     801b21 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b0c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b0f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b16:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b1a:	89 04 24             	mov    %eax,(%esp)
  801b1d:	ff d2                	call   *%edx
  801b1f:	eb 05                	jmp    801b26 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801b21:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801b26:	83 c4 24             	add    $0x24,%esp
  801b29:	5b                   	pop    %ebx
  801b2a:	5d                   	pop    %ebp
  801b2b:	c3                   	ret    

00801b2c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	57                   	push   %edi
  801b30:	56                   	push   %esi
  801b31:	53                   	push   %ebx
  801b32:	83 ec 1c             	sub    $0x1c,%esp
  801b35:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b38:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b40:	eb 23                	jmp    801b65 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b42:	89 f0                	mov    %esi,%eax
  801b44:	29 d8                	sub    %ebx,%eax
  801b46:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b4a:	89 d8                	mov    %ebx,%eax
  801b4c:	03 45 0c             	add    0xc(%ebp),%eax
  801b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b53:	89 3c 24             	mov    %edi,(%esp)
  801b56:	e8 3f ff ff ff       	call   801a9a <read>
		if (m < 0)
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	78 10                	js     801b6f <readn+0x43>
			return m;
		if (m == 0)
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	74 0a                	je     801b6d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b63:	01 c3                	add    %eax,%ebx
  801b65:	39 f3                	cmp    %esi,%ebx
  801b67:	72 d9                	jb     801b42 <readn+0x16>
  801b69:	89 d8                	mov    %ebx,%eax
  801b6b:	eb 02                	jmp    801b6f <readn+0x43>
  801b6d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801b6f:	83 c4 1c             	add    $0x1c,%esp
  801b72:	5b                   	pop    %ebx
  801b73:	5e                   	pop    %esi
  801b74:	5f                   	pop    %edi
  801b75:	5d                   	pop    %ebp
  801b76:	c3                   	ret    

00801b77 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	53                   	push   %ebx
  801b7b:	83 ec 24             	sub    $0x24,%esp
  801b7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b81:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b84:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b88:	89 1c 24             	mov    %ebx,(%esp)
  801b8b:	e8 76 fc ff ff       	call   801806 <fd_lookup>
  801b90:	89 c2                	mov    %eax,%edx
  801b92:	85 d2                	test   %edx,%edx
  801b94:	78 68                	js     801bfe <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b96:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba0:	8b 00                	mov    (%eax),%eax
  801ba2:	89 04 24             	mov    %eax,(%esp)
  801ba5:	e8 b2 fc ff ff       	call   80185c <dev_lookup>
  801baa:	85 c0                	test   %eax,%eax
  801bac:	78 50                	js     801bfe <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bb5:	75 23                	jne    801bda <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801bb7:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801bbc:	8b 40 48             	mov    0x48(%eax),%eax
  801bbf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc7:	c7 04 24 31 37 80 00 	movl   $0x803731,(%esp)
  801bce:	e8 24 ee ff ff       	call   8009f7 <cprintf>
		return -E_INVAL;
  801bd3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bd8:	eb 24                	jmp    801bfe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bdd:	8b 52 0c             	mov    0xc(%edx),%edx
  801be0:	85 d2                	test   %edx,%edx
  801be2:	74 15                	je     801bf9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801be4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801beb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bf2:	89 04 24             	mov    %eax,(%esp)
  801bf5:	ff d2                	call   *%edx
  801bf7:	eb 05                	jmp    801bfe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801bf9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801bfe:	83 c4 24             	add    $0x24,%esp
  801c01:	5b                   	pop    %ebx
  801c02:	5d                   	pop    %ebp
  801c03:	c3                   	ret    

00801c04 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
  801c07:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c0a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	89 04 24             	mov    %eax,(%esp)
  801c17:	e8 ea fb ff ff       	call   801806 <fd_lookup>
  801c1c:	85 c0                	test   %eax,%eax
  801c1e:	78 0e                	js     801c2e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801c20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c26:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	53                   	push   %ebx
  801c34:	83 ec 24             	sub    $0x24,%esp
  801c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c3a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c41:	89 1c 24             	mov    %ebx,(%esp)
  801c44:	e8 bd fb ff ff       	call   801806 <fd_lookup>
  801c49:	89 c2                	mov    %eax,%edx
  801c4b:	85 d2                	test   %edx,%edx
  801c4d:	78 61                	js     801cb0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c52:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c59:	8b 00                	mov    (%eax),%eax
  801c5b:	89 04 24             	mov    %eax,(%esp)
  801c5e:	e8 f9 fb ff ff       	call   80185c <dev_lookup>
  801c63:	85 c0                	test   %eax,%eax
  801c65:	78 49                	js     801cb0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c6e:	75 23                	jne    801c93 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801c70:	a1 1c 50 80 00       	mov    0x80501c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c75:	8b 40 48             	mov    0x48(%eax),%eax
  801c78:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c80:	c7 04 24 f4 36 80 00 	movl   $0x8036f4,(%esp)
  801c87:	e8 6b ed ff ff       	call   8009f7 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801c8c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c91:	eb 1d                	jmp    801cb0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801c93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c96:	8b 52 18             	mov    0x18(%edx),%edx
  801c99:	85 d2                	test   %edx,%edx
  801c9b:	74 0e                	je     801cab <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ca0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ca4:	89 04 24             	mov    %eax,(%esp)
  801ca7:	ff d2                	call   *%edx
  801ca9:	eb 05                	jmp    801cb0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801cab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801cb0:	83 c4 24             	add    $0x24,%esp
  801cb3:	5b                   	pop    %ebx
  801cb4:	5d                   	pop    %ebp
  801cb5:	c3                   	ret    

00801cb6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	53                   	push   %ebx
  801cba:	83 ec 24             	sub    $0x24,%esp
  801cbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cc0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	89 04 24             	mov    %eax,(%esp)
  801ccd:	e8 34 fb ff ff       	call   801806 <fd_lookup>
  801cd2:	89 c2                	mov    %eax,%edx
  801cd4:	85 d2                	test   %edx,%edx
  801cd6:	78 52                	js     801d2a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce2:	8b 00                	mov    (%eax),%eax
  801ce4:	89 04 24             	mov    %eax,(%esp)
  801ce7:	e8 70 fb ff ff       	call   80185c <dev_lookup>
  801cec:	85 c0                	test   %eax,%eax
  801cee:	78 3a                	js     801d2a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801cf7:	74 2c                	je     801d25 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801cf9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801cfc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d03:	00 00 00 
	stat->st_isdir = 0;
  801d06:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d0d:	00 00 00 
	stat->st_dev = dev;
  801d10:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d16:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d1d:	89 14 24             	mov    %edx,(%esp)
  801d20:	ff 50 14             	call   *0x14(%eax)
  801d23:	eb 05                	jmp    801d2a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801d25:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801d2a:	83 c4 24             	add    $0x24,%esp
  801d2d:	5b                   	pop    %ebx
  801d2e:	5d                   	pop    %ebp
  801d2f:	c3                   	ret    

00801d30 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	56                   	push   %esi
  801d34:	53                   	push   %ebx
  801d35:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d38:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d3f:	00 
  801d40:	8b 45 08             	mov    0x8(%ebp),%eax
  801d43:	89 04 24             	mov    %eax,(%esp)
  801d46:	e8 84 02 00 00       	call   801fcf <open>
  801d4b:	89 c3                	mov    %eax,%ebx
  801d4d:	85 db                	test   %ebx,%ebx
  801d4f:	78 1b                	js     801d6c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d58:	89 1c 24             	mov    %ebx,(%esp)
  801d5b:	e8 56 ff ff ff       	call   801cb6 <fstat>
  801d60:	89 c6                	mov    %eax,%esi
	close(fd);
  801d62:	89 1c 24             	mov    %ebx,(%esp)
  801d65:	e8 cd fb ff ff       	call   801937 <close>
	return r;
  801d6a:	89 f0                	mov    %esi,%eax
}
  801d6c:	83 c4 10             	add    $0x10,%esp
  801d6f:	5b                   	pop    %ebx
  801d70:	5e                   	pop    %esi
  801d71:	5d                   	pop    %ebp
  801d72:	c3                   	ret    

00801d73 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	56                   	push   %esi
  801d77:	53                   	push   %ebx
  801d78:	83 ec 10             	sub    $0x10,%esp
  801d7b:	89 c6                	mov    %eax,%esi
  801d7d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d7f:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801d86:	75 11                	jne    801d99 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801d8f:	e8 b1 10 00 00       	call   802e45 <ipc_find_env>
  801d94:	a3 10 50 80 00       	mov    %eax,0x805010
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d99:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801da0:	00 
  801da1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801da8:	00 
  801da9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dad:	a1 10 50 80 00       	mov    0x805010,%eax
  801db2:	89 04 24             	mov    %eax,(%esp)
  801db5:	e8 fe 0f 00 00       	call   802db8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801dba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dc1:	00 
  801dc2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dc6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dcd:	e8 7e 0f 00 00       	call   802d50 <ipc_recv>
}
  801dd2:	83 c4 10             	add    $0x10,%esp
  801dd5:	5b                   	pop    %ebx
  801dd6:	5e                   	pop    %esi
  801dd7:	5d                   	pop    %ebp
  801dd8:	c3                   	ret    

00801dd9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  801de2:	8b 40 0c             	mov    0xc(%eax),%eax
  801de5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ded:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801df2:	ba 00 00 00 00       	mov    $0x0,%edx
  801df7:	b8 02 00 00 00       	mov    $0x2,%eax
  801dfc:	e8 72 ff ff ff       	call   801d73 <fsipc>
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e0f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e14:	ba 00 00 00 00       	mov    $0x0,%edx
  801e19:	b8 06 00 00 00       	mov    $0x6,%eax
  801e1e:	e8 50 ff ff ff       	call   801d73 <fsipc>
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	53                   	push   %ebx
  801e29:	83 ec 14             	sub    $0x14,%esp
  801e2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	8b 40 0c             	mov    0xc(%eax),%eax
  801e35:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e3f:	b8 05 00 00 00       	mov    $0x5,%eax
  801e44:	e8 2a ff ff ff       	call   801d73 <fsipc>
  801e49:	89 c2                	mov    %eax,%edx
  801e4b:	85 d2                	test   %edx,%edx
  801e4d:	78 2b                	js     801e7a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e4f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e56:	00 
  801e57:	89 1c 24             	mov    %ebx,(%esp)
  801e5a:	e8 c8 f1 ff ff       	call   801027 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e5f:	a1 80 60 80 00       	mov    0x806080,%eax
  801e64:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e6a:	a1 84 60 80 00       	mov    0x806084,%eax
  801e6f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7a:	83 c4 14             	add    $0x14,%esp
  801e7d:	5b                   	pop    %ebx
  801e7e:	5d                   	pop    %ebp
  801e7f:	c3                   	ret    

00801e80 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	53                   	push   %ebx
  801e84:	83 ec 14             	sub    $0x14,%esp
  801e87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e90:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801e95:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801e9b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801ea0:	0f 46 c3             	cmovbe %ebx,%eax
  801ea3:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801ea8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eaf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb3:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801eba:	e8 05 f3 ff ff       	call   8011c4 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec4:	b8 04 00 00 00       	mov    $0x4,%eax
  801ec9:	e8 a5 fe ff ff       	call   801d73 <fsipc>
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	78 53                	js     801f25 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801ed2:	39 c3                	cmp    %eax,%ebx
  801ed4:	73 24                	jae    801efa <devfile_write+0x7a>
  801ed6:	c7 44 24 0c 64 37 80 	movl   $0x803764,0xc(%esp)
  801edd:	00 
  801ede:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  801ee5:	00 
  801ee6:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801eed:	00 
  801eee:	c7 04 24 80 37 80 00 	movl   $0x803780,(%esp)
  801ef5:	e8 04 ea ff ff       	call   8008fe <_panic>
	assert(r <= PGSIZE);
  801efa:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801eff:	7e 24                	jle    801f25 <devfile_write+0xa5>
  801f01:	c7 44 24 0c 8b 37 80 	movl   $0x80378b,0xc(%esp)
  801f08:	00 
  801f09:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  801f10:	00 
  801f11:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801f18:	00 
  801f19:	c7 04 24 80 37 80 00 	movl   $0x803780,(%esp)
  801f20:	e8 d9 e9 ff ff       	call   8008fe <_panic>
	return r;
}
  801f25:	83 c4 14             	add    $0x14,%esp
  801f28:	5b                   	pop    %ebx
  801f29:	5d                   	pop    %ebp
  801f2a:	c3                   	ret    

00801f2b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	56                   	push   %esi
  801f2f:	53                   	push   %ebx
  801f30:	83 ec 10             	sub    $0x10,%esp
  801f33:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	8b 40 0c             	mov    0xc(%eax),%eax
  801f3c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f41:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f47:	ba 00 00 00 00       	mov    $0x0,%edx
  801f4c:	b8 03 00 00 00       	mov    $0x3,%eax
  801f51:	e8 1d fe ff ff       	call   801d73 <fsipc>
  801f56:	89 c3                	mov    %eax,%ebx
  801f58:	85 c0                	test   %eax,%eax
  801f5a:	78 6a                	js     801fc6 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801f5c:	39 c6                	cmp    %eax,%esi
  801f5e:	73 24                	jae    801f84 <devfile_read+0x59>
  801f60:	c7 44 24 0c 64 37 80 	movl   $0x803764,0xc(%esp)
  801f67:	00 
  801f68:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  801f6f:	00 
  801f70:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801f77:	00 
  801f78:	c7 04 24 80 37 80 00 	movl   $0x803780,(%esp)
  801f7f:	e8 7a e9 ff ff       	call   8008fe <_panic>
	assert(r <= PGSIZE);
  801f84:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f89:	7e 24                	jle    801faf <devfile_read+0x84>
  801f8b:	c7 44 24 0c 8b 37 80 	movl   $0x80378b,0xc(%esp)
  801f92:	00 
  801f93:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  801f9a:	00 
  801f9b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801fa2:	00 
  801fa3:	c7 04 24 80 37 80 00 	movl   $0x803780,(%esp)
  801faa:	e8 4f e9 ff ff       	call   8008fe <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801faf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fb3:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801fba:	00 
  801fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbe:	89 04 24             	mov    %eax,(%esp)
  801fc1:	e8 fe f1 ff ff       	call   8011c4 <memmove>
	return r;
}
  801fc6:	89 d8                	mov    %ebx,%eax
  801fc8:	83 c4 10             	add    $0x10,%esp
  801fcb:	5b                   	pop    %ebx
  801fcc:	5e                   	pop    %esi
  801fcd:	5d                   	pop    %ebp
  801fce:	c3                   	ret    

00801fcf <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	53                   	push   %ebx
  801fd3:	83 ec 24             	sub    $0x24,%esp
  801fd6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801fd9:	89 1c 24             	mov    %ebx,(%esp)
  801fdc:	e8 0f f0 ff ff       	call   800ff0 <strlen>
  801fe1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801fe6:	7f 60                	jg     802048 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801fe8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801feb:	89 04 24             	mov    %eax,(%esp)
  801fee:	e8 c4 f7 ff ff       	call   8017b7 <fd_alloc>
  801ff3:	89 c2                	mov    %eax,%edx
  801ff5:	85 d2                	test   %edx,%edx
  801ff7:	78 54                	js     80204d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801ff9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ffd:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  802004:	e8 1e f0 ff ff       	call   801027 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80200c:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802011:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802014:	b8 01 00 00 00       	mov    $0x1,%eax
  802019:	e8 55 fd ff ff       	call   801d73 <fsipc>
  80201e:	89 c3                	mov    %eax,%ebx
  802020:	85 c0                	test   %eax,%eax
  802022:	79 17                	jns    80203b <open+0x6c>
		fd_close(fd, 0);
  802024:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80202b:	00 
  80202c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202f:	89 04 24             	mov    %eax,(%esp)
  802032:	e8 7f f8 ff ff       	call   8018b6 <fd_close>
		return r;
  802037:	89 d8                	mov    %ebx,%eax
  802039:	eb 12                	jmp    80204d <open+0x7e>
	}

	return fd2num(fd);
  80203b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203e:	89 04 24             	mov    %eax,(%esp)
  802041:	e8 4a f7 ff ff       	call   801790 <fd2num>
  802046:	eb 05                	jmp    80204d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  802048:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80204d:	83 c4 24             	add    $0x24,%esp
  802050:	5b                   	pop    %ebx
  802051:	5d                   	pop    %ebp
  802052:	c3                   	ret    

00802053 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802059:	ba 00 00 00 00       	mov    $0x0,%edx
  80205e:	b8 08 00 00 00       	mov    $0x8,%eax
  802063:	e8 0b fd ff ff       	call   801d73 <fsipc>
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    
  80206a:	66 90                	xchg   %ax,%ax
  80206c:	66 90                	xchg   %ax,%ax
  80206e:	66 90                	xchg   %ax,%ax

00802070 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802076:	c7 44 24 04 97 37 80 	movl   $0x803797,0x4(%esp)
  80207d:	00 
  80207e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802081:	89 04 24             	mov    %eax,(%esp)
  802084:	e8 9e ef ff ff       	call   801027 <strcpy>
	return 0;
}
  802089:	b8 00 00 00 00       	mov    $0x0,%eax
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	53                   	push   %ebx
  802094:	83 ec 14             	sub    $0x14,%esp
  802097:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80209a:	89 1c 24             	mov    %ebx,(%esp)
  80209d:	e8 dd 0d 00 00       	call   802e7f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8020a2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8020a7:	83 f8 01             	cmp    $0x1,%eax
  8020aa:	75 0d                	jne    8020b9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8020ac:	8b 43 0c             	mov    0xc(%ebx),%eax
  8020af:	89 04 24             	mov    %eax,(%esp)
  8020b2:	e8 29 03 00 00       	call   8023e0 <nsipc_close>
  8020b7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8020b9:	89 d0                	mov    %edx,%eax
  8020bb:	83 c4 14             	add    $0x14,%esp
  8020be:	5b                   	pop    %ebx
  8020bf:	5d                   	pop    %ebp
  8020c0:	c3                   	ret    

008020c1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020c7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020ce:	00 
  8020cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e3:	89 04 24             	mov    %eax,(%esp)
  8020e6:	e8 f0 03 00 00       	call   8024db <nsipc_send>
}
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
  8020f0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020fa:	00 
  8020fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8020fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  802102:	8b 45 0c             	mov    0xc(%ebp),%eax
  802105:	89 44 24 04          	mov    %eax,0x4(%esp)
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	8b 40 0c             	mov    0xc(%eax),%eax
  80210f:	89 04 24             	mov    %eax,(%esp)
  802112:	e8 44 03 00 00       	call   80245b <nsipc_recv>
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80211f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802122:	89 54 24 04          	mov    %edx,0x4(%esp)
  802126:	89 04 24             	mov    %eax,(%esp)
  802129:	e8 d8 f6 ff ff       	call   801806 <fd_lookup>
  80212e:	85 c0                	test   %eax,%eax
  802130:	78 17                	js     802149 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802135:	8b 0d 40 40 80 00    	mov    0x804040,%ecx
  80213b:	39 08                	cmp    %ecx,(%eax)
  80213d:	75 05                	jne    802144 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80213f:	8b 40 0c             	mov    0xc(%eax),%eax
  802142:	eb 05                	jmp    802149 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802144:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	56                   	push   %esi
  80214f:	53                   	push   %ebx
  802150:	83 ec 20             	sub    $0x20,%esp
  802153:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802155:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802158:	89 04 24             	mov    %eax,(%esp)
  80215b:	e8 57 f6 ff ff       	call   8017b7 <fd_alloc>
  802160:	89 c3                	mov    %eax,%ebx
  802162:	85 c0                	test   %eax,%eax
  802164:	78 21                	js     802187 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802166:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80216d:	00 
  80216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802171:	89 44 24 04          	mov    %eax,0x4(%esp)
  802175:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80217c:	e8 c2 f2 ff ff       	call   801443 <sys_page_alloc>
  802181:	89 c3                	mov    %eax,%ebx
  802183:	85 c0                	test   %eax,%eax
  802185:	79 0c                	jns    802193 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802187:	89 34 24             	mov    %esi,(%esp)
  80218a:	e8 51 02 00 00       	call   8023e0 <nsipc_close>
		return r;
  80218f:	89 d8                	mov    %ebx,%eax
  802191:	eb 20                	jmp    8021b3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802193:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80219e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8021a8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8021ab:	89 14 24             	mov    %edx,(%esp)
  8021ae:	e8 dd f5 ff ff       	call   801790 <fd2num>
}
  8021b3:	83 c4 20             	add    $0x20,%esp
  8021b6:	5b                   	pop    %ebx
  8021b7:	5e                   	pop    %esi
  8021b8:	5d                   	pop    %ebp
  8021b9:	c3                   	ret    

008021ba <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	e8 51 ff ff ff       	call   802119 <fd2sockid>
		return r;
  8021c8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021ca:	85 c0                	test   %eax,%eax
  8021cc:	78 23                	js     8021f1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021ce:	8b 55 10             	mov    0x10(%ebp),%edx
  8021d1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021dc:	89 04 24             	mov    %eax,(%esp)
  8021df:	e8 45 01 00 00       	call   802329 <nsipc_accept>
		return r;
  8021e4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021e6:	85 c0                	test   %eax,%eax
  8021e8:	78 07                	js     8021f1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8021ea:	e8 5c ff ff ff       	call   80214b <alloc_sockfd>
  8021ef:	89 c1                	mov    %eax,%ecx
}
  8021f1:	89 c8                	mov    %ecx,%eax
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	e8 16 ff ff ff       	call   802119 <fd2sockid>
  802203:	89 c2                	mov    %eax,%edx
  802205:	85 d2                	test   %edx,%edx
  802207:	78 16                	js     80221f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802209:	8b 45 10             	mov    0x10(%ebp),%eax
  80220c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802210:	8b 45 0c             	mov    0xc(%ebp),%eax
  802213:	89 44 24 04          	mov    %eax,0x4(%esp)
  802217:	89 14 24             	mov    %edx,(%esp)
  80221a:	e8 60 01 00 00       	call   80237f <nsipc_bind>
}
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

00802221 <shutdown>:

int
shutdown(int s, int how)
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
  802224:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	e8 ea fe ff ff       	call   802119 <fd2sockid>
  80222f:	89 c2                	mov    %eax,%edx
  802231:	85 d2                	test   %edx,%edx
  802233:	78 0f                	js     802244 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802235:	8b 45 0c             	mov    0xc(%ebp),%eax
  802238:	89 44 24 04          	mov    %eax,0x4(%esp)
  80223c:	89 14 24             	mov    %edx,(%esp)
  80223f:	e8 7a 01 00 00       	call   8023be <nsipc_shutdown>
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	e8 c5 fe ff ff       	call   802119 <fd2sockid>
  802254:	89 c2                	mov    %eax,%edx
  802256:	85 d2                	test   %edx,%edx
  802258:	78 16                	js     802270 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80225a:	8b 45 10             	mov    0x10(%ebp),%eax
  80225d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802261:	8b 45 0c             	mov    0xc(%ebp),%eax
  802264:	89 44 24 04          	mov    %eax,0x4(%esp)
  802268:	89 14 24             	mov    %edx,(%esp)
  80226b:	e8 8a 01 00 00       	call   8023fa <nsipc_connect>
}
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <listen>:

int
listen(int s, int backlog)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
  802275:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	e8 99 fe ff ff       	call   802119 <fd2sockid>
  802280:	89 c2                	mov    %eax,%edx
  802282:	85 d2                	test   %edx,%edx
  802284:	78 0f                	js     802295 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802286:	8b 45 0c             	mov    0xc(%ebp),%eax
  802289:	89 44 24 04          	mov    %eax,0x4(%esp)
  80228d:	89 14 24             	mov    %edx,(%esp)
  802290:	e8 a4 01 00 00       	call   802439 <nsipc_listen>
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80229d:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	89 04 24             	mov    %eax,(%esp)
  8022b1:	e8 98 02 00 00       	call   80254e <nsipc_socket>
  8022b6:	89 c2                	mov    %eax,%edx
  8022b8:	85 d2                	test   %edx,%edx
  8022ba:	78 05                	js     8022c1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8022bc:	e8 8a fe ff ff       	call   80214b <alloc_sockfd>
}
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
  8022c6:	53                   	push   %ebx
  8022c7:	83 ec 14             	sub    $0x14,%esp
  8022ca:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8022cc:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  8022d3:	75 11                	jne    8022e6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022d5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8022dc:	e8 64 0b 00 00       	call   802e45 <ipc_find_env>
  8022e1:	a3 14 50 80 00       	mov    %eax,0x805014
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022e6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8022ed:	00 
  8022ee:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8022f5:	00 
  8022f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022fa:	a1 14 50 80 00       	mov    0x805014,%eax
  8022ff:	89 04 24             	mov    %eax,(%esp)
  802302:	e8 b1 0a 00 00       	call   802db8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802307:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80230e:	00 
  80230f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802316:	00 
  802317:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80231e:	e8 2d 0a 00 00       	call   802d50 <ipc_recv>
}
  802323:	83 c4 14             	add    $0x14,%esp
  802326:	5b                   	pop    %ebx
  802327:	5d                   	pop    %ebp
  802328:	c3                   	ret    

00802329 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
  80232c:	56                   	push   %esi
  80232d:	53                   	push   %ebx
  80232e:	83 ec 10             	sub    $0x10,%esp
  802331:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80233c:	8b 06                	mov    (%esi),%eax
  80233e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802343:	b8 01 00 00 00       	mov    $0x1,%eax
  802348:	e8 76 ff ff ff       	call   8022c3 <nsipc>
  80234d:	89 c3                	mov    %eax,%ebx
  80234f:	85 c0                	test   %eax,%eax
  802351:	78 23                	js     802376 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802353:	a1 10 70 80 00       	mov    0x807010,%eax
  802358:	89 44 24 08          	mov    %eax,0x8(%esp)
  80235c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802363:	00 
  802364:	8b 45 0c             	mov    0xc(%ebp),%eax
  802367:	89 04 24             	mov    %eax,(%esp)
  80236a:	e8 55 ee ff ff       	call   8011c4 <memmove>
		*addrlen = ret->ret_addrlen;
  80236f:	a1 10 70 80 00       	mov    0x807010,%eax
  802374:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802376:	89 d8                	mov    %ebx,%eax
  802378:	83 c4 10             	add    $0x10,%esp
  80237b:	5b                   	pop    %ebx
  80237c:	5e                   	pop    %esi
  80237d:	5d                   	pop    %ebp
  80237e:	c3                   	ret    

0080237f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
  802382:	53                   	push   %ebx
  802383:	83 ec 14             	sub    $0x14,%esp
  802386:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802389:	8b 45 08             	mov    0x8(%ebp),%eax
  80238c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802391:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802395:	8b 45 0c             	mov    0xc(%ebp),%eax
  802398:	89 44 24 04          	mov    %eax,0x4(%esp)
  80239c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8023a3:	e8 1c ee ff ff       	call   8011c4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8023a8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8023ae:	b8 02 00 00 00       	mov    $0x2,%eax
  8023b3:	e8 0b ff ff ff       	call   8022c3 <nsipc>
}
  8023b8:	83 c4 14             	add    $0x14,%esp
  8023bb:	5b                   	pop    %ebx
  8023bc:	5d                   	pop    %ebp
  8023bd:	c3                   	ret    

008023be <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
  8023c1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8023cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023cf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8023d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8023d9:	e8 e5 fe ff ff       	call   8022c3 <nsipc>
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <nsipc_close>:

int
nsipc_close(int s)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
  8023e3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8023ee:	b8 04 00 00 00       	mov    $0x4,%eax
  8023f3:	e8 cb fe ff ff       	call   8022c3 <nsipc>
}
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    

008023fa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	53                   	push   %ebx
  8023fe:	83 ec 14             	sub    $0x14,%esp
  802401:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802404:	8b 45 08             	mov    0x8(%ebp),%eax
  802407:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80240c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802410:	8b 45 0c             	mov    0xc(%ebp),%eax
  802413:	89 44 24 04          	mov    %eax,0x4(%esp)
  802417:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80241e:	e8 a1 ed ff ff       	call   8011c4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802423:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802429:	b8 05 00 00 00       	mov    $0x5,%eax
  80242e:	e8 90 fe ff ff       	call   8022c3 <nsipc>
}
  802433:	83 c4 14             	add    $0x14,%esp
  802436:	5b                   	pop    %ebx
  802437:	5d                   	pop    %ebp
  802438:	c3                   	ret    

00802439 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802439:	55                   	push   %ebp
  80243a:	89 e5                	mov    %esp,%ebp
  80243c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80244f:	b8 06 00 00 00       	mov    $0x6,%eax
  802454:	e8 6a fe ff ff       	call   8022c3 <nsipc>
}
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
  80245e:	56                   	push   %esi
  80245f:	53                   	push   %ebx
  802460:	83 ec 10             	sub    $0x10,%esp
  802463:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802466:	8b 45 08             	mov    0x8(%ebp),%eax
  802469:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80246e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802474:	8b 45 14             	mov    0x14(%ebp),%eax
  802477:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80247c:	b8 07 00 00 00       	mov    $0x7,%eax
  802481:	e8 3d fe ff ff       	call   8022c3 <nsipc>
  802486:	89 c3                	mov    %eax,%ebx
  802488:	85 c0                	test   %eax,%eax
  80248a:	78 46                	js     8024d2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80248c:	39 f0                	cmp    %esi,%eax
  80248e:	7f 07                	jg     802497 <nsipc_recv+0x3c>
  802490:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802495:	7e 24                	jle    8024bb <nsipc_recv+0x60>
  802497:	c7 44 24 0c a3 37 80 	movl   $0x8037a3,0xc(%esp)
  80249e:	00 
  80249f:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  8024a6:	00 
  8024a7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8024ae:	00 
  8024af:	c7 04 24 b8 37 80 00 	movl   $0x8037b8,(%esp)
  8024b6:	e8 43 e4 ff ff       	call   8008fe <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8024bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024bf:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8024c6:	00 
  8024c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ca:	89 04 24             	mov    %eax,(%esp)
  8024cd:	e8 f2 ec ff ff       	call   8011c4 <memmove>
	}

	return r;
}
  8024d2:	89 d8                	mov    %ebx,%eax
  8024d4:	83 c4 10             	add    $0x10,%esp
  8024d7:	5b                   	pop    %ebx
  8024d8:	5e                   	pop    %esi
  8024d9:	5d                   	pop    %ebp
  8024da:	c3                   	ret    

008024db <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
  8024de:	53                   	push   %ebx
  8024df:	83 ec 14             	sub    $0x14,%esp
  8024e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8024e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8024ed:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8024f3:	7e 24                	jle    802519 <nsipc_send+0x3e>
  8024f5:	c7 44 24 0c c4 37 80 	movl   $0x8037c4,0xc(%esp)
  8024fc:	00 
  8024fd:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  802504:	00 
  802505:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80250c:	00 
  80250d:	c7 04 24 b8 37 80 00 	movl   $0x8037b8,(%esp)
  802514:	e8 e5 e3 ff ff       	call   8008fe <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802519:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80251d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802520:	89 44 24 04          	mov    %eax,0x4(%esp)
  802524:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80252b:	e8 94 ec ff ff       	call   8011c4 <memmove>
	nsipcbuf.send.req_size = size;
  802530:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802536:	8b 45 14             	mov    0x14(%ebp),%eax
  802539:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80253e:	b8 08 00 00 00       	mov    $0x8,%eax
  802543:	e8 7b fd ff ff       	call   8022c3 <nsipc>
}
  802548:	83 c4 14             	add    $0x14,%esp
  80254b:	5b                   	pop    %ebx
  80254c:	5d                   	pop    %ebp
  80254d:	c3                   	ret    

0080254e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
  802551:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802554:	8b 45 08             	mov    0x8(%ebp),%eax
  802557:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80255c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80255f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802564:	8b 45 10             	mov    0x10(%ebp),%eax
  802567:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80256c:	b8 09 00 00 00       	mov    $0x9,%eax
  802571:	e8 4d fd ff ff       	call   8022c3 <nsipc>
}
  802576:	c9                   	leave  
  802577:	c3                   	ret    
  802578:	66 90                	xchg   %ax,%ax
  80257a:	66 90                	xchg   %ax,%ax
  80257c:	66 90                	xchg   %ax,%ax
  80257e:	66 90                	xchg   %ax,%ax

00802580 <free>:
	return v;
}

void
free(void *v)
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
  802583:	53                   	push   %ebx
  802584:	83 ec 14             	sub    $0x14,%esp
  802587:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  80258a:	85 db                	test   %ebx,%ebx
  80258c:	0f 84 ba 00 00 00    	je     80264c <free+0xcc>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  802592:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  802598:	76 08                	jbe    8025a2 <free+0x22>
  80259a:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  8025a0:	76 24                	jbe    8025c6 <free+0x46>
  8025a2:	c7 44 24 0c d0 37 80 	movl   $0x8037d0,0xc(%esp)
  8025a9:	00 
  8025aa:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  8025b1:	00 
  8025b2:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  8025b9:	00 
  8025ba:	c7 04 24 00 38 80 00 	movl   $0x803800,(%esp)
  8025c1:	e8 38 e3 ff ff       	call   8008fe <_panic>

	c = ROUNDDOWN(v, PGSIZE);
  8025c6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  8025cc:	eb 4a                	jmp    802618 <free+0x98>
		sys_page_unmap(0, c);
  8025ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025d9:	e8 0c ef ff ff       	call   8014ea <sys_page_unmap>
		c += PGSIZE;
  8025de:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  8025e4:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  8025ea:	76 08                	jbe    8025f4 <free+0x74>
  8025ec:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  8025f2:	76 24                	jbe    802618 <free+0x98>
  8025f4:	c7 44 24 0c 0d 38 80 	movl   $0x80380d,0xc(%esp)
  8025fb:	00 
  8025fc:	c7 44 24 08 6b 37 80 	movl   $0x80376b,0x8(%esp)
  802603:	00 
  802604:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
  80260b:	00 
  80260c:	c7 04 24 00 38 80 00 	movl   $0x803800,(%esp)
  802613:	e8 e6 e2 ff ff       	call   8008fe <_panic>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);

	c = ROUNDDOWN(v, PGSIZE);

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  802618:	89 d8                	mov    %ebx,%eax
  80261a:	c1 e8 0c             	shr    $0xc,%eax
  80261d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802624:	f6 c4 02             	test   $0x2,%ah
  802627:	75 a5                	jne    8025ce <free+0x4e>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  802629:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  80262f:	83 e8 01             	sub    $0x1,%eax
  802632:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  802638:	85 c0                	test   %eax,%eax
  80263a:	75 10                	jne    80264c <free+0xcc>
		sys_page_unmap(0, c);
  80263c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802640:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802647:	e8 9e ee ff ff       	call   8014ea <sys_page_unmap>
}
  80264c:	83 c4 14             	add    $0x14,%esp
  80264f:	5b                   	pop    %ebx
  802650:	5d                   	pop    %ebp
  802651:	c3                   	ret    

00802652 <malloc>:
	return 1;
}

void*
malloc(size_t n)
{
  802652:	55                   	push   %ebp
  802653:	89 e5                	mov    %esp,%ebp
  802655:	57                   	push   %edi
  802656:	56                   	push   %esi
  802657:	53                   	push   %ebx
  802658:	83 ec 2c             	sub    $0x2c,%esp
	int i, cont;
	int nwrap;
	uint32_t *ref;
	void *v;

	if (mptr == 0)
  80265b:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  802662:	75 0a                	jne    80266e <malloc+0x1c>
		mptr = mbegin;
  802664:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  80266b:	00 00 08 

	n = ROUNDUP(n, 4);
  80266e:	8b 45 08             	mov    0x8(%ebp),%eax
  802671:	83 c0 03             	add    $0x3,%eax
  802674:	83 e0 fc             	and    $0xfffffffc,%eax
  802677:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (n >= MAXMALLOC)
  80267a:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
  80267f:	0f 87 64 01 00 00    	ja     8027e9 <malloc+0x197>
		return 0;

	if ((uintptr_t) mptr % PGSIZE){
  802685:	a1 18 50 80 00       	mov    0x805018,%eax
  80268a:	a9 ff 0f 00 00       	test   $0xfff,%eax
  80268f:	75 15                	jne    8026a6 <malloc+0x54>
  802691:	8b 35 18 50 80 00    	mov    0x805018,%esi
	return 1;
}

void*
malloc(size_t n)
{
  802697:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
  80269e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a1:	8d 78 04             	lea    0x4(%eax),%edi
  8026a4:	eb 50                	jmp    8026f6 <malloc+0xa4>
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  8026a6:	89 c1                	mov    %eax,%ecx
  8026a8:	c1 e9 0c             	shr    $0xc,%ecx
  8026ab:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8026ae:	8d 54 18 03          	lea    0x3(%eax,%ebx,1),%edx
  8026b2:	c1 ea 0c             	shr    $0xc,%edx
  8026b5:	39 d1                	cmp    %edx,%ecx
  8026b7:	75 1f                	jne    8026d8 <malloc+0x86>
		/*
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  8026b9:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  8026bf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
			(*ref)++;
  8026c5:	83 42 fc 01          	addl   $0x1,-0x4(%edx)
			v = mptr;
			mptr += n;
  8026c9:	89 da                	mov    %ebx,%edx
  8026cb:	01 c2                	add    %eax,%edx
  8026cd:	89 15 18 50 80 00    	mov    %edx,0x805018
			return v;
  8026d3:	e9 2f 01 00 00       	jmp    802807 <malloc+0x1b5>
		}
		/*
		 * stop working on this page and move on.
		 */
		free(mptr);	/* drop reference to this page */
  8026d8:	89 04 24             	mov    %eax,(%esp)
  8026db:	e8 a0 fe ff ff       	call   802580 <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  8026e0:	a1 18 50 80 00       	mov    0x805018,%eax
  8026e5:	05 00 10 00 00       	add    $0x1000,%eax
  8026ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8026ef:	a3 18 50 80 00       	mov    %eax,0x805018
  8026f4:	eb 9b                	jmp    802691 <malloc+0x3f>
  8026f6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
  8026f9:	89 fb                	mov    %edi,%ebx
  8026fb:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  8026fe:	89 f0                	mov    %esi,%eax
  802700:	eb 36                	jmp    802738 <malloc+0xe6>
		if (va >= (uintptr_t) mend
  802702:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  802707:	0f 87 e3 00 00 00    	ja     8027f0 <malloc+0x19e>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  80270d:	89 c2                	mov    %eax,%edx
  80270f:	c1 ea 16             	shr    $0x16,%edx
  802712:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802719:	f6 c2 01             	test   $0x1,%dl
  80271c:	74 15                	je     802733 <malloc+0xe1>
  80271e:	89 c2                	mov    %eax,%edx
  802720:	c1 ea 0c             	shr    $0xc,%edx
  802723:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80272a:	f6 c2 01             	test   $0x1,%dl
  80272d:	0f 85 bd 00 00 00    	jne    8027f0 <malloc+0x19e>
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  802733:	05 00 10 00 00       	add    $0x1000,%eax
  802738:	39 c1                	cmp    %eax,%ecx
  80273a:	77 c6                	ja     802702 <malloc+0xb0>
  80273c:	eb 7e                	jmp    8027bc <malloc+0x16a>
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
		if (mptr == mend) {
			mptr = mbegin;
			if (++nwrap == 2)
  80273e:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
  802742:	74 07                	je     80274b <malloc+0xf9>
	while (1) {
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
		if (mptr == mend) {
			mptr = mbegin;
  802744:	be 00 00 00 08       	mov    $0x8000000,%esi
  802749:	eb ab                	jmp    8026f6 <malloc+0xa4>
  80274b:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  802752:	00 00 08 
			if (++nwrap == 2)
				return 0;	/* out of address space */
  802755:	b8 00 00 00 00       	mov    $0x0,%eax
  80275a:	e9 a8 00 00 00       	jmp    802807 <malloc+0x1b5>

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  80275f:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
  802765:	39 df                	cmp    %ebx,%edi
  802767:	19 c0                	sbb    %eax,%eax
  802769:	25 00 02 00 00       	and    $0x200,%eax
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  80276e:	83 c8 07             	or     $0x7,%eax
  802771:	89 44 24 08          	mov    %eax,0x8(%esp)
  802775:	03 15 18 50 80 00    	add    0x805018,%edx
  80277b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80277f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802786:	e8 b8 ec ff ff       	call   801443 <sys_page_alloc>
  80278b:	85 c0                	test   %eax,%eax
  80278d:	78 22                	js     8027b1 <malloc+0x15f>
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  80278f:	89 fe                	mov    %edi,%esi
  802791:	eb 36                	jmp    8027c9 <malloc+0x177>
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
				sys_page_unmap(0, mptr + i);
  802793:	89 f0                	mov    %esi,%eax
  802795:	03 05 18 50 80 00    	add    0x805018,%eax
  80279b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80279f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027a6:	e8 3f ed ff ff       	call   8014ea <sys_page_unmap>
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
  8027ab:	81 ee 00 10 00 00    	sub    $0x1000,%esi
  8027b1:	85 f6                	test   %esi,%esi
  8027b3:	79 de                	jns    802793 <malloc+0x141>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
  8027b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ba:	eb 4b                	jmp    802807 <malloc+0x1b5>
  8027bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bf:	a3 18 50 80 00       	mov    %eax,0x805018
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  8027c4:	be 00 00 00 00       	mov    $0x0,%esi
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  8027c9:	89 f2                	mov    %esi,%edx
  8027cb:	39 de                	cmp    %ebx,%esi
  8027cd:	72 90                	jb     80275f <malloc+0x10d>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
		}
	}

	ref = (uint32_t*) (mptr + i - 4);
  8027cf:	a1 18 50 80 00       	mov    0x805018,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  8027d4:	c7 44 30 fc 02 00 00 	movl   $0x2,-0x4(%eax,%esi,1)
  8027db:	00 
	v = mptr;
	mptr += n;
  8027dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027df:	01 c2                	add    %eax,%edx
  8027e1:	89 15 18 50 80 00    	mov    %edx,0x805018
	return v;
  8027e7:	eb 1e                	jmp    802807 <malloc+0x1b5>
		mptr = mbegin;

	n = ROUNDUP(n, 4);

	if (n >= MAXMALLOC)
		return 0;
  8027e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ee:	eb 17                	jmp    802807 <malloc+0x1b5>
  8027f0:	81 c6 00 10 00 00    	add    $0x1000,%esi
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
		if (mptr == mend) {
  8027f6:	81 fe 00 00 00 10    	cmp    $0x10000000,%esi
  8027fc:	0f 84 3c ff ff ff    	je     80273e <malloc+0xec>
  802802:	e9 ef fe ff ff       	jmp    8026f6 <malloc+0xa4>
	ref = (uint32_t*) (mptr + i - 4);
	*ref = 2;	/* reference for mptr, reference for returned block */
	v = mptr;
	mptr += n;
	return v;
}
  802807:	83 c4 2c             	add    $0x2c,%esp
  80280a:	5b                   	pop    %ebx
  80280b:	5e                   	pop    %esi
  80280c:	5f                   	pop    %edi
  80280d:	5d                   	pop    %ebp
  80280e:	c3                   	ret    

0080280f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80280f:	55                   	push   %ebp
  802810:	89 e5                	mov    %esp,%ebp
  802812:	56                   	push   %esi
  802813:	53                   	push   %ebx
  802814:	83 ec 10             	sub    $0x10,%esp
  802817:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	89 04 24             	mov    %eax,(%esp)
  802820:	e8 7b ef ff ff       	call   8017a0 <fd2data>
  802825:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802827:	c7 44 24 04 25 38 80 	movl   $0x803825,0x4(%esp)
  80282e:	00 
  80282f:	89 1c 24             	mov    %ebx,(%esp)
  802832:	e8 f0 e7 ff ff       	call   801027 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802837:	8b 46 04             	mov    0x4(%esi),%eax
  80283a:	2b 06                	sub    (%esi),%eax
  80283c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802842:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802849:	00 00 00 
	stat->st_dev = &devpipe;
  80284c:	c7 83 88 00 00 00 5c 	movl   $0x80405c,0x88(%ebx)
  802853:	40 80 00 
	return 0;
}
  802856:	b8 00 00 00 00       	mov    $0x0,%eax
  80285b:	83 c4 10             	add    $0x10,%esp
  80285e:	5b                   	pop    %ebx
  80285f:	5e                   	pop    %esi
  802860:	5d                   	pop    %ebp
  802861:	c3                   	ret    

00802862 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802862:	55                   	push   %ebp
  802863:	89 e5                	mov    %esp,%ebp
  802865:	53                   	push   %ebx
  802866:	83 ec 14             	sub    $0x14,%esp
  802869:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80286c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802870:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802877:	e8 6e ec ff ff       	call   8014ea <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80287c:	89 1c 24             	mov    %ebx,(%esp)
  80287f:	e8 1c ef ff ff       	call   8017a0 <fd2data>
  802884:	89 44 24 04          	mov    %eax,0x4(%esp)
  802888:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80288f:	e8 56 ec ff ff       	call   8014ea <sys_page_unmap>
}
  802894:	83 c4 14             	add    $0x14,%esp
  802897:	5b                   	pop    %ebx
  802898:	5d                   	pop    %ebp
  802899:	c3                   	ret    

0080289a <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80289a:	55                   	push   %ebp
  80289b:	89 e5                	mov    %esp,%ebp
  80289d:	57                   	push   %edi
  80289e:	56                   	push   %esi
  80289f:	53                   	push   %ebx
  8028a0:	83 ec 2c             	sub    $0x2c,%esp
  8028a3:	89 c6                	mov    %eax,%esi
  8028a5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8028a8:	a1 1c 50 80 00       	mov    0x80501c,%eax
  8028ad:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8028b0:	89 34 24             	mov    %esi,(%esp)
  8028b3:	e8 c7 05 00 00       	call   802e7f <pageref>
  8028b8:	89 c7                	mov    %eax,%edi
  8028ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028bd:	89 04 24             	mov    %eax,(%esp)
  8028c0:	e8 ba 05 00 00       	call   802e7f <pageref>
  8028c5:	39 c7                	cmp    %eax,%edi
  8028c7:	0f 94 c2             	sete   %dl
  8028ca:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8028cd:	8b 0d 1c 50 80 00    	mov    0x80501c,%ecx
  8028d3:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8028d6:	39 fb                	cmp    %edi,%ebx
  8028d8:	74 21                	je     8028fb <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8028da:	84 d2                	test   %dl,%dl
  8028dc:	74 ca                	je     8028a8 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8028de:	8b 51 58             	mov    0x58(%ecx),%edx
  8028e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028e5:	89 54 24 08          	mov    %edx,0x8(%esp)
  8028e9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8028ed:	c7 04 24 2c 38 80 00 	movl   $0x80382c,(%esp)
  8028f4:	e8 fe e0 ff ff       	call   8009f7 <cprintf>
  8028f9:	eb ad                	jmp    8028a8 <_pipeisclosed+0xe>
	}
}
  8028fb:	83 c4 2c             	add    $0x2c,%esp
  8028fe:	5b                   	pop    %ebx
  8028ff:	5e                   	pop    %esi
  802900:	5f                   	pop    %edi
  802901:	5d                   	pop    %ebp
  802902:	c3                   	ret    

00802903 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802903:	55                   	push   %ebp
  802904:	89 e5                	mov    %esp,%ebp
  802906:	57                   	push   %edi
  802907:	56                   	push   %esi
  802908:	53                   	push   %ebx
  802909:	83 ec 1c             	sub    $0x1c,%esp
  80290c:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80290f:	89 34 24             	mov    %esi,(%esp)
  802912:	e8 89 ee ff ff       	call   8017a0 <fd2data>
  802917:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802919:	bf 00 00 00 00       	mov    $0x0,%edi
  80291e:	eb 45                	jmp    802965 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802920:	89 da                	mov    %ebx,%edx
  802922:	89 f0                	mov    %esi,%eax
  802924:	e8 71 ff ff ff       	call   80289a <_pipeisclosed>
  802929:	85 c0                	test   %eax,%eax
  80292b:	75 41                	jne    80296e <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80292d:	e8 f2 ea ff ff       	call   801424 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802932:	8b 43 04             	mov    0x4(%ebx),%eax
  802935:	8b 0b                	mov    (%ebx),%ecx
  802937:	8d 51 20             	lea    0x20(%ecx),%edx
  80293a:	39 d0                	cmp    %edx,%eax
  80293c:	73 e2                	jae    802920 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80293e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802941:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802945:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802948:	99                   	cltd   
  802949:	c1 ea 1b             	shr    $0x1b,%edx
  80294c:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  80294f:	83 e1 1f             	and    $0x1f,%ecx
  802952:	29 d1                	sub    %edx,%ecx
  802954:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802958:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  80295c:	83 c0 01             	add    $0x1,%eax
  80295f:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802962:	83 c7 01             	add    $0x1,%edi
  802965:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802968:	75 c8                	jne    802932 <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  80296a:	89 f8                	mov    %edi,%eax
  80296c:	eb 05                	jmp    802973 <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80296e:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  802973:	83 c4 1c             	add    $0x1c,%esp
  802976:	5b                   	pop    %ebx
  802977:	5e                   	pop    %esi
  802978:	5f                   	pop    %edi
  802979:	5d                   	pop    %ebp
  80297a:	c3                   	ret    

0080297b <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80297b:	55                   	push   %ebp
  80297c:	89 e5                	mov    %esp,%ebp
  80297e:	57                   	push   %edi
  80297f:	56                   	push   %esi
  802980:	53                   	push   %ebx
  802981:	83 ec 1c             	sub    $0x1c,%esp
  802984:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802987:	89 3c 24             	mov    %edi,(%esp)
  80298a:	e8 11 ee ff ff       	call   8017a0 <fd2data>
  80298f:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802991:	be 00 00 00 00       	mov    $0x0,%esi
  802996:	eb 3d                	jmp    8029d5 <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802998:	85 f6                	test   %esi,%esi
  80299a:	74 04                	je     8029a0 <devpipe_read+0x25>
				return i;
  80299c:	89 f0                	mov    %esi,%eax
  80299e:	eb 43                	jmp    8029e3 <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8029a0:	89 da                	mov    %ebx,%edx
  8029a2:	89 f8                	mov    %edi,%eax
  8029a4:	e8 f1 fe ff ff       	call   80289a <_pipeisclosed>
  8029a9:	85 c0                	test   %eax,%eax
  8029ab:	75 31                	jne    8029de <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8029ad:	e8 72 ea ff ff       	call   801424 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8029b2:	8b 03                	mov    (%ebx),%eax
  8029b4:	3b 43 04             	cmp    0x4(%ebx),%eax
  8029b7:	74 df                	je     802998 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8029b9:	99                   	cltd   
  8029ba:	c1 ea 1b             	shr    $0x1b,%edx
  8029bd:	01 d0                	add    %edx,%eax
  8029bf:	83 e0 1f             	and    $0x1f,%eax
  8029c2:	29 d0                	sub    %edx,%eax
  8029c4:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8029c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029cc:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8029cf:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8029d2:	83 c6 01             	add    $0x1,%esi
  8029d5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8029d8:	75 d8                	jne    8029b2 <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8029da:	89 f0                	mov    %esi,%eax
  8029dc:	eb 05                	jmp    8029e3 <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8029de:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8029e3:	83 c4 1c             	add    $0x1c,%esp
  8029e6:	5b                   	pop    %ebx
  8029e7:	5e                   	pop    %esi
  8029e8:	5f                   	pop    %edi
  8029e9:	5d                   	pop    %ebp
  8029ea:	c3                   	ret    

008029eb <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8029eb:	55                   	push   %ebp
  8029ec:	89 e5                	mov    %esp,%ebp
  8029ee:	56                   	push   %esi
  8029ef:	53                   	push   %ebx
  8029f0:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8029f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029f6:	89 04 24             	mov    %eax,(%esp)
  8029f9:	e8 b9 ed ff ff       	call   8017b7 <fd_alloc>
  8029fe:	89 c2                	mov    %eax,%edx
  802a00:	85 d2                	test   %edx,%edx
  802a02:	0f 88 4d 01 00 00    	js     802b55 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a08:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a0f:	00 
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a1e:	e8 20 ea ff ff       	call   801443 <sys_page_alloc>
  802a23:	89 c2                	mov    %eax,%edx
  802a25:	85 d2                	test   %edx,%edx
  802a27:	0f 88 28 01 00 00    	js     802b55 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802a2d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802a30:	89 04 24             	mov    %eax,(%esp)
  802a33:	e8 7f ed ff ff       	call   8017b7 <fd_alloc>
  802a38:	89 c3                	mov    %eax,%ebx
  802a3a:	85 c0                	test   %eax,%eax
  802a3c:	0f 88 fe 00 00 00    	js     802b40 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a42:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a49:	00 
  802a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a58:	e8 e6 e9 ff ff       	call   801443 <sys_page_alloc>
  802a5d:	89 c3                	mov    %eax,%ebx
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	0f 88 d9 00 00 00    	js     802b40 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	89 04 24             	mov    %eax,(%esp)
  802a6d:	e8 2e ed ff ff       	call   8017a0 <fd2data>
  802a72:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a74:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a7b:	00 
  802a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a87:	e8 b7 e9 ff ff       	call   801443 <sys_page_alloc>
  802a8c:	89 c3                	mov    %eax,%ebx
  802a8e:	85 c0                	test   %eax,%eax
  802a90:	0f 88 97 00 00 00    	js     802b2d <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a99:	89 04 24             	mov    %eax,(%esp)
  802a9c:	e8 ff ec ff ff       	call   8017a0 <fd2data>
  802aa1:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802aa8:	00 
  802aa9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802aad:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802ab4:	00 
  802ab5:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ab9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ac0:	e8 d2 e9 ff ff       	call   801497 <sys_page_map>
  802ac5:	89 c3                	mov    %eax,%ebx
  802ac7:	85 c0                	test   %eax,%eax
  802ac9:	78 52                	js     802b1d <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802acb:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802ae0:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae9:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aee:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af8:	89 04 24             	mov    %eax,(%esp)
  802afb:	e8 90 ec ff ff       	call   801790 <fd2num>
  802b00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b03:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b08:	89 04 24             	mov    %eax,(%esp)
  802b0b:	e8 80 ec ff ff       	call   801790 <fd2num>
  802b10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b13:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802b16:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1b:	eb 38                	jmp    802b55 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802b1d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b28:	e8 bd e9 ff ff       	call   8014ea <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b30:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b3b:	e8 aa e9 ff ff       	call   8014ea <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b4e:	e8 97 e9 ff ff       	call   8014ea <sys_page_unmap>
  802b53:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802b55:	83 c4 30             	add    $0x30,%esp
  802b58:	5b                   	pop    %ebx
  802b59:	5e                   	pop    %esi
  802b5a:	5d                   	pop    %ebp
  802b5b:	c3                   	ret    

00802b5c <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802b5c:	55                   	push   %ebp
  802b5d:	89 e5                	mov    %esp,%ebp
  802b5f:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b65:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b69:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6c:	89 04 24             	mov    %eax,(%esp)
  802b6f:	e8 92 ec ff ff       	call   801806 <fd_lookup>
  802b74:	89 c2                	mov    %eax,%edx
  802b76:	85 d2                	test   %edx,%edx
  802b78:	78 15                	js     802b8f <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7d:	89 04 24             	mov    %eax,(%esp)
  802b80:	e8 1b ec ff ff       	call   8017a0 <fd2data>
	return _pipeisclosed(fd, p);
  802b85:	89 c2                	mov    %eax,%edx
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	e8 0b fd ff ff       	call   80289a <_pipeisclosed>
}
  802b8f:	c9                   	leave  
  802b90:	c3                   	ret    
  802b91:	66 90                	xchg   %ax,%ax
  802b93:	66 90                	xchg   %ax,%ax
  802b95:	66 90                	xchg   %ax,%ax
  802b97:	66 90                	xchg   %ax,%ax
  802b99:	66 90                	xchg   %ax,%ax
  802b9b:	66 90                	xchg   %ax,%ax
  802b9d:	66 90                	xchg   %ax,%ax
  802b9f:	90                   	nop

00802ba0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802ba0:	55                   	push   %ebp
  802ba1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba8:	5d                   	pop    %ebp
  802ba9:	c3                   	ret    

00802baa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802baa:	55                   	push   %ebp
  802bab:	89 e5                	mov    %esp,%ebp
  802bad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802bb0:	c7 44 24 04 44 38 80 	movl   $0x803844,0x4(%esp)
  802bb7:	00 
  802bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bbb:	89 04 24             	mov    %eax,(%esp)
  802bbe:	e8 64 e4 ff ff       	call   801027 <strcpy>
	return 0;
}
  802bc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc8:	c9                   	leave  
  802bc9:	c3                   	ret    

00802bca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802bca:	55                   	push   %ebp
  802bcb:	89 e5                	mov    %esp,%ebp
  802bcd:	57                   	push   %edi
  802bce:	56                   	push   %esi
  802bcf:	53                   	push   %ebx
  802bd0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802bd6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802bdb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802be1:	eb 31                	jmp    802c14 <devcons_write+0x4a>
		m = n - tot;
  802be3:	8b 75 10             	mov    0x10(%ebp),%esi
  802be6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802be8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802beb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802bf0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802bf3:	89 74 24 08          	mov    %esi,0x8(%esp)
  802bf7:	03 45 0c             	add    0xc(%ebp),%eax
  802bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bfe:	89 3c 24             	mov    %edi,(%esp)
  802c01:	e8 be e5 ff ff       	call   8011c4 <memmove>
		sys_cputs(buf, m);
  802c06:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c0a:	89 3c 24             	mov    %edi,(%esp)
  802c0d:	e8 64 e7 ff ff       	call   801376 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802c12:	01 f3                	add    %esi,%ebx
  802c14:	89 d8                	mov    %ebx,%eax
  802c16:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802c19:	72 c8                	jb     802be3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802c1b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802c21:	5b                   	pop    %ebx
  802c22:	5e                   	pop    %esi
  802c23:	5f                   	pop    %edi
  802c24:	5d                   	pop    %ebp
  802c25:	c3                   	ret    

00802c26 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802c26:	55                   	push   %ebp
  802c27:	89 e5                	mov    %esp,%ebp
  802c29:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802c2c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802c31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802c35:	75 07                	jne    802c3e <devcons_read+0x18>
  802c37:	eb 2a                	jmp    802c63 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802c39:	e8 e6 e7 ff ff       	call   801424 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802c3e:	66 90                	xchg   %ax,%ax
  802c40:	e8 4f e7 ff ff       	call   801394 <sys_cgetc>
  802c45:	85 c0                	test   %eax,%eax
  802c47:	74 f0                	je     802c39 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802c49:	85 c0                	test   %eax,%eax
  802c4b:	78 16                	js     802c63 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802c4d:	83 f8 04             	cmp    $0x4,%eax
  802c50:	74 0c                	je     802c5e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802c52:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c55:	88 02                	mov    %al,(%edx)
	return 1;
  802c57:	b8 01 00 00 00       	mov    $0x1,%eax
  802c5c:	eb 05                	jmp    802c63 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802c5e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802c63:	c9                   	leave  
  802c64:	c3                   	ret    

00802c65 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802c65:	55                   	push   %ebp
  802c66:	89 e5                	mov    %esp,%ebp
  802c68:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802c71:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802c78:	00 
  802c79:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802c7c:	89 04 24             	mov    %eax,(%esp)
  802c7f:	e8 f2 e6 ff ff       	call   801376 <sys_cputs>
}
  802c84:	c9                   	leave  
  802c85:	c3                   	ret    

00802c86 <getchar>:

int
getchar(void)
{
  802c86:	55                   	push   %ebp
  802c87:	89 e5                	mov    %esp,%ebp
  802c89:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802c8c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802c93:	00 
  802c94:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802c97:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c9b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ca2:	e8 f3 ed ff ff       	call   801a9a <read>
	if (r < 0)
  802ca7:	85 c0                	test   %eax,%eax
  802ca9:	78 0f                	js     802cba <getchar+0x34>
		return r;
	if (r < 1)
  802cab:	85 c0                	test   %eax,%eax
  802cad:	7e 06                	jle    802cb5 <getchar+0x2f>
		return -E_EOF;
	return c;
  802caf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802cb3:	eb 05                	jmp    802cba <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802cb5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802cba:	c9                   	leave  
  802cbb:	c3                   	ret    

00802cbc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802cbc:	55                   	push   %ebp
  802cbd:	89 e5                	mov    %esp,%ebp
  802cbf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cc2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	89 04 24             	mov    %eax,(%esp)
  802ccf:	e8 32 eb ff ff       	call   801806 <fd_lookup>
  802cd4:	85 c0                	test   %eax,%eax
  802cd6:	78 11                	js     802ce9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdb:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802ce1:	39 10                	cmp    %edx,(%eax)
  802ce3:	0f 94 c0             	sete   %al
  802ce6:	0f b6 c0             	movzbl %al,%eax
}
  802ce9:	c9                   	leave  
  802cea:	c3                   	ret    

00802ceb <opencons>:

int
opencons(void)
{
  802ceb:	55                   	push   %ebp
  802cec:	89 e5                	mov    %esp,%ebp
  802cee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802cf1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802cf4:	89 04 24             	mov    %eax,(%esp)
  802cf7:	e8 bb ea ff ff       	call   8017b7 <fd_alloc>
		return r;
  802cfc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802cfe:	85 c0                	test   %eax,%eax
  802d00:	78 40                	js     802d42 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802d02:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802d09:	00 
  802d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d18:	e8 26 e7 ff ff       	call   801443 <sys_page_alloc>
		return r;
  802d1d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	78 1f                	js     802d42 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802d23:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d31:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802d38:	89 04 24             	mov    %eax,(%esp)
  802d3b:	e8 50 ea ff ff       	call   801790 <fd2num>
  802d40:	89 c2                	mov    %eax,%edx
}
  802d42:	89 d0                	mov    %edx,%eax
  802d44:	c9                   	leave  
  802d45:	c3                   	ret    
  802d46:	66 90                	xchg   %ax,%ax
  802d48:	66 90                	xchg   %ax,%ax
  802d4a:	66 90                	xchg   %ax,%ax
  802d4c:	66 90                	xchg   %ax,%ax
  802d4e:	66 90                	xchg   %ax,%ax

00802d50 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802d50:	55                   	push   %ebp
  802d51:	89 e5                	mov    %esp,%ebp
  802d53:	56                   	push   %esi
  802d54:	53                   	push   %ebx
  802d55:	83 ec 10             	sub    $0x10,%esp
  802d58:	8b 75 08             	mov    0x8(%ebp),%esi
  802d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802d61:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802d63:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802d68:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  802d6b:	89 04 24             	mov    %eax,(%esp)
  802d6e:	e8 e6 e8 ff ff       	call   801659 <sys_ipc_recv>
  802d73:	85 c0                	test   %eax,%eax
  802d75:	74 16                	je     802d8d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802d77:	85 f6                	test   %esi,%esi
  802d79:	74 06                	je     802d81 <ipc_recv+0x31>
			*from_env_store = 0;
  802d7b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802d81:	85 db                	test   %ebx,%ebx
  802d83:	74 2c                	je     802db1 <ipc_recv+0x61>
			*perm_store = 0;
  802d85:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802d8b:	eb 24                	jmp    802db1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  802d8d:	85 f6                	test   %esi,%esi
  802d8f:	74 0a                	je     802d9b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802d91:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802d96:	8b 40 74             	mov    0x74(%eax),%eax
  802d99:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  802d9b:	85 db                	test   %ebx,%ebx
  802d9d:	74 0a                	je     802da9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  802d9f:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802da4:	8b 40 78             	mov    0x78(%eax),%eax
  802da7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802da9:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802dae:	8b 40 70             	mov    0x70(%eax),%eax
}
  802db1:	83 c4 10             	add    $0x10,%esp
  802db4:	5b                   	pop    %ebx
  802db5:	5e                   	pop    %esi
  802db6:	5d                   	pop    %ebp
  802db7:	c3                   	ret    

00802db8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802db8:	55                   	push   %ebp
  802db9:	89 e5                	mov    %esp,%ebp
  802dbb:	57                   	push   %edi
  802dbc:	56                   	push   %esi
  802dbd:	53                   	push   %ebx
  802dbe:	83 ec 1c             	sub    $0x1c,%esp
  802dc1:	8b 75 0c             	mov    0xc(%ebp),%esi
  802dc4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802dc7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  802dca:	85 db                	test   %ebx,%ebx
  802dcc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802dd1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  802dd4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802dd8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802ddc:	89 74 24 04          	mov    %esi,0x4(%esp)
  802de0:	8b 45 08             	mov    0x8(%ebp),%eax
  802de3:	89 04 24             	mov    %eax,(%esp)
  802de6:	e8 4b e8 ff ff       	call   801636 <sys_ipc_try_send>
	if (r == 0) return;
  802deb:	85 c0                	test   %eax,%eax
  802ded:	75 22                	jne    802e11 <ipc_send+0x59>
  802def:	eb 4c                	jmp    802e3d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802df1:	84 d2                	test   %dl,%dl
  802df3:	75 48                	jne    802e3d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802df5:	e8 2a e6 ff ff       	call   801424 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  802dfa:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802dfe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e02:	89 74 24 04          	mov    %esi,0x4(%esp)
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	89 04 24             	mov    %eax,(%esp)
  802e0c:	e8 25 e8 ff ff       	call   801636 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802e11:	85 c0                	test   %eax,%eax
  802e13:	0f 94 c2             	sete   %dl
  802e16:	74 d9                	je     802df1 <ipc_send+0x39>
  802e18:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802e1b:	74 d4                	je     802df1 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  802e1d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e21:	c7 44 24 08 50 38 80 	movl   $0x803850,0x8(%esp)
  802e28:	00 
  802e29:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802e30:	00 
  802e31:	c7 04 24 5e 38 80 00 	movl   $0x80385e,(%esp)
  802e38:	e8 c1 da ff ff       	call   8008fe <_panic>
}
  802e3d:	83 c4 1c             	add    $0x1c,%esp
  802e40:	5b                   	pop    %ebx
  802e41:	5e                   	pop    %esi
  802e42:	5f                   	pop    %edi
  802e43:	5d                   	pop    %ebp
  802e44:	c3                   	ret    

00802e45 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802e45:	55                   	push   %ebp
  802e46:	89 e5                	mov    %esp,%ebp
  802e48:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802e4b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802e50:	89 c2                	mov    %eax,%edx
  802e52:	c1 e2 07             	shl    $0x7,%edx
  802e55:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802e5b:	8b 52 50             	mov    0x50(%edx),%edx
  802e5e:	39 ca                	cmp    %ecx,%edx
  802e60:	75 0d                	jne    802e6f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802e62:	c1 e0 07             	shl    $0x7,%eax
  802e65:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802e6a:	8b 40 40             	mov    0x40(%eax),%eax
  802e6d:	eb 0e                	jmp    802e7d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802e6f:	83 c0 01             	add    $0x1,%eax
  802e72:	3d 00 04 00 00       	cmp    $0x400,%eax
  802e77:	75 d7                	jne    802e50 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802e79:	66 b8 00 00          	mov    $0x0,%ax
}
  802e7d:	5d                   	pop    %ebp
  802e7e:	c3                   	ret    

00802e7f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802e7f:	55                   	push   %ebp
  802e80:	89 e5                	mov    %esp,%ebp
  802e82:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802e85:	89 d0                	mov    %edx,%eax
  802e87:	c1 e8 16             	shr    $0x16,%eax
  802e8a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802e91:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802e96:	f6 c1 01             	test   $0x1,%cl
  802e99:	74 1d                	je     802eb8 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802e9b:	c1 ea 0c             	shr    $0xc,%edx
  802e9e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802ea5:	f6 c2 01             	test   $0x1,%dl
  802ea8:	74 0e                	je     802eb8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802eaa:	c1 ea 0c             	shr    $0xc,%edx
  802ead:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802eb4:	ef 
  802eb5:	0f b7 c0             	movzwl %ax,%eax
}
  802eb8:	5d                   	pop    %ebp
  802eb9:	c3                   	ret    
  802eba:	66 90                	xchg   %ax,%ax
  802ebc:	66 90                	xchg   %ax,%ax
  802ebe:	66 90                	xchg   %ax,%ax

00802ec0 <__udivdi3>:
  802ec0:	55                   	push   %ebp
  802ec1:	57                   	push   %edi
  802ec2:	56                   	push   %esi
  802ec3:	83 ec 0c             	sub    $0xc,%esp
  802ec6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802eca:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802ece:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802ed2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802ed6:	85 c0                	test   %eax,%eax
  802ed8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802edc:	89 ea                	mov    %ebp,%edx
  802ede:	89 0c 24             	mov    %ecx,(%esp)
  802ee1:	75 2d                	jne    802f10 <__udivdi3+0x50>
  802ee3:	39 e9                	cmp    %ebp,%ecx
  802ee5:	77 61                	ja     802f48 <__udivdi3+0x88>
  802ee7:	85 c9                	test   %ecx,%ecx
  802ee9:	89 ce                	mov    %ecx,%esi
  802eeb:	75 0b                	jne    802ef8 <__udivdi3+0x38>
  802eed:	b8 01 00 00 00       	mov    $0x1,%eax
  802ef2:	31 d2                	xor    %edx,%edx
  802ef4:	f7 f1                	div    %ecx
  802ef6:	89 c6                	mov    %eax,%esi
  802ef8:	31 d2                	xor    %edx,%edx
  802efa:	89 e8                	mov    %ebp,%eax
  802efc:	f7 f6                	div    %esi
  802efe:	89 c5                	mov    %eax,%ebp
  802f00:	89 f8                	mov    %edi,%eax
  802f02:	f7 f6                	div    %esi
  802f04:	89 ea                	mov    %ebp,%edx
  802f06:	83 c4 0c             	add    $0xc,%esp
  802f09:	5e                   	pop    %esi
  802f0a:	5f                   	pop    %edi
  802f0b:	5d                   	pop    %ebp
  802f0c:	c3                   	ret    
  802f0d:	8d 76 00             	lea    0x0(%esi),%esi
  802f10:	39 e8                	cmp    %ebp,%eax
  802f12:	77 24                	ja     802f38 <__udivdi3+0x78>
  802f14:	0f bd e8             	bsr    %eax,%ebp
  802f17:	83 f5 1f             	xor    $0x1f,%ebp
  802f1a:	75 3c                	jne    802f58 <__udivdi3+0x98>
  802f1c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802f20:	39 34 24             	cmp    %esi,(%esp)
  802f23:	0f 86 9f 00 00 00    	jbe    802fc8 <__udivdi3+0x108>
  802f29:	39 d0                	cmp    %edx,%eax
  802f2b:	0f 82 97 00 00 00    	jb     802fc8 <__udivdi3+0x108>
  802f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802f38:	31 d2                	xor    %edx,%edx
  802f3a:	31 c0                	xor    %eax,%eax
  802f3c:	83 c4 0c             	add    $0xc,%esp
  802f3f:	5e                   	pop    %esi
  802f40:	5f                   	pop    %edi
  802f41:	5d                   	pop    %ebp
  802f42:	c3                   	ret    
  802f43:	90                   	nop
  802f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f48:	89 f8                	mov    %edi,%eax
  802f4a:	f7 f1                	div    %ecx
  802f4c:	31 d2                	xor    %edx,%edx
  802f4e:	83 c4 0c             	add    $0xc,%esp
  802f51:	5e                   	pop    %esi
  802f52:	5f                   	pop    %edi
  802f53:	5d                   	pop    %ebp
  802f54:	c3                   	ret    
  802f55:	8d 76 00             	lea    0x0(%esi),%esi
  802f58:	89 e9                	mov    %ebp,%ecx
  802f5a:	8b 3c 24             	mov    (%esp),%edi
  802f5d:	d3 e0                	shl    %cl,%eax
  802f5f:	89 c6                	mov    %eax,%esi
  802f61:	b8 20 00 00 00       	mov    $0x20,%eax
  802f66:	29 e8                	sub    %ebp,%eax
  802f68:	89 c1                	mov    %eax,%ecx
  802f6a:	d3 ef                	shr    %cl,%edi
  802f6c:	89 e9                	mov    %ebp,%ecx
  802f6e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802f72:	8b 3c 24             	mov    (%esp),%edi
  802f75:	09 74 24 08          	or     %esi,0x8(%esp)
  802f79:	89 d6                	mov    %edx,%esi
  802f7b:	d3 e7                	shl    %cl,%edi
  802f7d:	89 c1                	mov    %eax,%ecx
  802f7f:	89 3c 24             	mov    %edi,(%esp)
  802f82:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802f86:	d3 ee                	shr    %cl,%esi
  802f88:	89 e9                	mov    %ebp,%ecx
  802f8a:	d3 e2                	shl    %cl,%edx
  802f8c:	89 c1                	mov    %eax,%ecx
  802f8e:	d3 ef                	shr    %cl,%edi
  802f90:	09 d7                	or     %edx,%edi
  802f92:	89 f2                	mov    %esi,%edx
  802f94:	89 f8                	mov    %edi,%eax
  802f96:	f7 74 24 08          	divl   0x8(%esp)
  802f9a:	89 d6                	mov    %edx,%esi
  802f9c:	89 c7                	mov    %eax,%edi
  802f9e:	f7 24 24             	mull   (%esp)
  802fa1:	39 d6                	cmp    %edx,%esi
  802fa3:	89 14 24             	mov    %edx,(%esp)
  802fa6:	72 30                	jb     802fd8 <__udivdi3+0x118>
  802fa8:	8b 54 24 04          	mov    0x4(%esp),%edx
  802fac:	89 e9                	mov    %ebp,%ecx
  802fae:	d3 e2                	shl    %cl,%edx
  802fb0:	39 c2                	cmp    %eax,%edx
  802fb2:	73 05                	jae    802fb9 <__udivdi3+0xf9>
  802fb4:	3b 34 24             	cmp    (%esp),%esi
  802fb7:	74 1f                	je     802fd8 <__udivdi3+0x118>
  802fb9:	89 f8                	mov    %edi,%eax
  802fbb:	31 d2                	xor    %edx,%edx
  802fbd:	e9 7a ff ff ff       	jmp    802f3c <__udivdi3+0x7c>
  802fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802fc8:	31 d2                	xor    %edx,%edx
  802fca:	b8 01 00 00 00       	mov    $0x1,%eax
  802fcf:	e9 68 ff ff ff       	jmp    802f3c <__udivdi3+0x7c>
  802fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802fd8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802fdb:	31 d2                	xor    %edx,%edx
  802fdd:	83 c4 0c             	add    $0xc,%esp
  802fe0:	5e                   	pop    %esi
  802fe1:	5f                   	pop    %edi
  802fe2:	5d                   	pop    %ebp
  802fe3:	c3                   	ret    
  802fe4:	66 90                	xchg   %ax,%ax
  802fe6:	66 90                	xchg   %ax,%ax
  802fe8:	66 90                	xchg   %ax,%ax
  802fea:	66 90                	xchg   %ax,%ax
  802fec:	66 90                	xchg   %ax,%ax
  802fee:	66 90                	xchg   %ax,%ax

00802ff0 <__umoddi3>:
  802ff0:	55                   	push   %ebp
  802ff1:	57                   	push   %edi
  802ff2:	56                   	push   %esi
  802ff3:	83 ec 14             	sub    $0x14,%esp
  802ff6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802ffa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802ffe:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803002:	89 c7                	mov    %eax,%edi
  803004:	89 44 24 04          	mov    %eax,0x4(%esp)
  803008:	8b 44 24 30          	mov    0x30(%esp),%eax
  80300c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803010:	89 34 24             	mov    %esi,(%esp)
  803013:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803017:	85 c0                	test   %eax,%eax
  803019:	89 c2                	mov    %eax,%edx
  80301b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80301f:	75 17                	jne    803038 <__umoddi3+0x48>
  803021:	39 fe                	cmp    %edi,%esi
  803023:	76 4b                	jbe    803070 <__umoddi3+0x80>
  803025:	89 c8                	mov    %ecx,%eax
  803027:	89 fa                	mov    %edi,%edx
  803029:	f7 f6                	div    %esi
  80302b:	89 d0                	mov    %edx,%eax
  80302d:	31 d2                	xor    %edx,%edx
  80302f:	83 c4 14             	add    $0x14,%esp
  803032:	5e                   	pop    %esi
  803033:	5f                   	pop    %edi
  803034:	5d                   	pop    %ebp
  803035:	c3                   	ret    
  803036:	66 90                	xchg   %ax,%ax
  803038:	39 f8                	cmp    %edi,%eax
  80303a:	77 54                	ja     803090 <__umoddi3+0xa0>
  80303c:	0f bd e8             	bsr    %eax,%ebp
  80303f:	83 f5 1f             	xor    $0x1f,%ebp
  803042:	75 5c                	jne    8030a0 <__umoddi3+0xb0>
  803044:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803048:	39 3c 24             	cmp    %edi,(%esp)
  80304b:	0f 87 e7 00 00 00    	ja     803138 <__umoddi3+0x148>
  803051:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803055:	29 f1                	sub    %esi,%ecx
  803057:	19 c7                	sbb    %eax,%edi
  803059:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80305d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803061:	8b 44 24 08          	mov    0x8(%esp),%eax
  803065:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803069:	83 c4 14             	add    $0x14,%esp
  80306c:	5e                   	pop    %esi
  80306d:	5f                   	pop    %edi
  80306e:	5d                   	pop    %ebp
  80306f:	c3                   	ret    
  803070:	85 f6                	test   %esi,%esi
  803072:	89 f5                	mov    %esi,%ebp
  803074:	75 0b                	jne    803081 <__umoddi3+0x91>
  803076:	b8 01 00 00 00       	mov    $0x1,%eax
  80307b:	31 d2                	xor    %edx,%edx
  80307d:	f7 f6                	div    %esi
  80307f:	89 c5                	mov    %eax,%ebp
  803081:	8b 44 24 04          	mov    0x4(%esp),%eax
  803085:	31 d2                	xor    %edx,%edx
  803087:	f7 f5                	div    %ebp
  803089:	89 c8                	mov    %ecx,%eax
  80308b:	f7 f5                	div    %ebp
  80308d:	eb 9c                	jmp    80302b <__umoddi3+0x3b>
  80308f:	90                   	nop
  803090:	89 c8                	mov    %ecx,%eax
  803092:	89 fa                	mov    %edi,%edx
  803094:	83 c4 14             	add    $0x14,%esp
  803097:	5e                   	pop    %esi
  803098:	5f                   	pop    %edi
  803099:	5d                   	pop    %ebp
  80309a:	c3                   	ret    
  80309b:	90                   	nop
  80309c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8030a0:	8b 04 24             	mov    (%esp),%eax
  8030a3:	be 20 00 00 00       	mov    $0x20,%esi
  8030a8:	89 e9                	mov    %ebp,%ecx
  8030aa:	29 ee                	sub    %ebp,%esi
  8030ac:	d3 e2                	shl    %cl,%edx
  8030ae:	89 f1                	mov    %esi,%ecx
  8030b0:	d3 e8                	shr    %cl,%eax
  8030b2:	89 e9                	mov    %ebp,%ecx
  8030b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030b8:	8b 04 24             	mov    (%esp),%eax
  8030bb:	09 54 24 04          	or     %edx,0x4(%esp)
  8030bf:	89 fa                	mov    %edi,%edx
  8030c1:	d3 e0                	shl    %cl,%eax
  8030c3:	89 f1                	mov    %esi,%ecx
  8030c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8030c9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8030cd:	d3 ea                	shr    %cl,%edx
  8030cf:	89 e9                	mov    %ebp,%ecx
  8030d1:	d3 e7                	shl    %cl,%edi
  8030d3:	89 f1                	mov    %esi,%ecx
  8030d5:	d3 e8                	shr    %cl,%eax
  8030d7:	89 e9                	mov    %ebp,%ecx
  8030d9:	09 f8                	or     %edi,%eax
  8030db:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8030df:	f7 74 24 04          	divl   0x4(%esp)
  8030e3:	d3 e7                	shl    %cl,%edi
  8030e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030e9:	89 d7                	mov    %edx,%edi
  8030eb:	f7 64 24 08          	mull   0x8(%esp)
  8030ef:	39 d7                	cmp    %edx,%edi
  8030f1:	89 c1                	mov    %eax,%ecx
  8030f3:	89 14 24             	mov    %edx,(%esp)
  8030f6:	72 2c                	jb     803124 <__umoddi3+0x134>
  8030f8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8030fc:	72 22                	jb     803120 <__umoddi3+0x130>
  8030fe:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803102:	29 c8                	sub    %ecx,%eax
  803104:	19 d7                	sbb    %edx,%edi
  803106:	89 e9                	mov    %ebp,%ecx
  803108:	89 fa                	mov    %edi,%edx
  80310a:	d3 e8                	shr    %cl,%eax
  80310c:	89 f1                	mov    %esi,%ecx
  80310e:	d3 e2                	shl    %cl,%edx
  803110:	89 e9                	mov    %ebp,%ecx
  803112:	d3 ef                	shr    %cl,%edi
  803114:	09 d0                	or     %edx,%eax
  803116:	89 fa                	mov    %edi,%edx
  803118:	83 c4 14             	add    $0x14,%esp
  80311b:	5e                   	pop    %esi
  80311c:	5f                   	pop    %edi
  80311d:	5d                   	pop    %ebp
  80311e:	c3                   	ret    
  80311f:	90                   	nop
  803120:	39 d7                	cmp    %edx,%edi
  803122:	75 da                	jne    8030fe <__umoddi3+0x10e>
  803124:	8b 14 24             	mov    (%esp),%edx
  803127:	89 c1                	mov    %eax,%ecx
  803129:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80312d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803131:	eb cb                	jmp    8030fe <__umoddi3+0x10e>
  803133:	90                   	nop
  803134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803138:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80313c:	0f 82 0f ff ff ff    	jb     803051 <__umoddi3+0x61>
  803142:	e9 1a ff ff ff       	jmp    803061 <__umoddi3+0x71>
