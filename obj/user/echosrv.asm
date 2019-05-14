
obj/user/echosrv.debug:     file format elf32-i386


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
  80002c:	e8 fc 04 00 00       	call   80052d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	cprintf("%s\n", m);
  800039:	89 44 24 04          	mov    %eax,0x4(%esp)
  80003d:	c7 04 24 90 2b 80 00 	movl   $0x802b90,(%esp)
  800044:	e8 e8 05 00 00       	call   800631 <cprintf>
	exit();
  800049:	e8 27 05 00 00       	call   800575 <exit>
}
  80004e:	c9                   	leave  
  80004f:	c3                   	ret    

00800050 <handle_client>:

void
handle_client(int sock)
{
  800050:	55                   	push   %ebp
  800051:	89 e5                	mov    %esp,%ebp
  800053:	57                   	push   %edi
  800054:	56                   	push   %esi
  800055:	53                   	push   %ebx
  800056:	83 ec 3c             	sub    $0x3c,%esp
  800059:	8b 75 08             	mov    0x8(%ebp),%esi
	char buffer[BUFFSIZE];
	int received = -1;
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80005c:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  800063:	00 
  800064:	8d 45 c8             	lea    -0x38(%ebp),%eax
  800067:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006b:	89 34 24             	mov    %esi,(%esp)
  80006e:	e8 57 16 00 00       	call   8016ca <read>
  800073:	89 c3                	mov    %eax,%ebx
  800075:	85 c0                	test   %eax,%eax
  800077:	78 05                	js     80007e <handle_client+0x2e>
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
		// Send back received data
		if (write(sock, buffer, received) != received)
  800079:	8d 7d c8             	lea    -0x38(%ebp),%edi
  80007c:	eb 4e                	jmp    8000cc <handle_client+0x7c>
{
	char buffer[BUFFSIZE];
	int received = -1;
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
		die("Failed to receive initial bytes from client");
  80007e:	b8 94 2b 80 00       	mov    $0x802b94,%eax
  800083:	e8 ab ff ff ff       	call   800033 <die>
  800088:	eb ef                	jmp    800079 <handle_client+0x29>

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
		// Send back received data
		if (write(sock, buffer, received) != received)
  80008a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80008e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800092:	89 34 24             	mov    %esi,(%esp)
  800095:	e8 0d 17 00 00       	call   8017a7 <write>
  80009a:	39 d8                	cmp    %ebx,%eax
  80009c:	74 0a                	je     8000a8 <handle_client+0x58>
			die("Failed to send bytes to client");
  80009e:	b8 c0 2b 80 00       	mov    $0x802bc0,%eax
  8000a3:	e8 8b ff ff ff       	call   800033 <die>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  8000a8:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  8000af:	00 
  8000b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8000b4:	89 34 24             	mov    %esi,(%esp)
  8000b7:	e8 0e 16 00 00       	call   8016ca <read>
  8000bc:	89 c3                	mov    %eax,%ebx
  8000be:	85 c0                	test   %eax,%eax
  8000c0:	79 0a                	jns    8000cc <handle_client+0x7c>
			die("Failed to receive additional bytes from client");
  8000c2:	b8 e0 2b 80 00       	mov    $0x802be0,%eax
  8000c7:	e8 67 ff ff ff       	call   800033 <die>
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  8000cc:	85 db                	test   %ebx,%ebx
  8000ce:	7f ba                	jg     80008a <handle_client+0x3a>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 8f 14 00 00       	call   801567 <close>
}
  8000d8:	83 c4 3c             	add    $0x3c,%esp
  8000db:	5b                   	pop    %ebx
  8000dc:	5e                   	pop    %esi
  8000dd:	5f                   	pop    %edi
  8000de:	5d                   	pop    %ebp
  8000df:	c3                   	ret    

008000e0 <umain>:

void
umain(int argc, char **argv)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	57                   	push   %edi
  8000e4:	56                   	push   %esi
  8000e5:	53                   	push   %ebx
  8000e6:	83 ec 4c             	sub    $0x4c,%esp
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8000e9:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  8000f0:	00 
  8000f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8000f8:	00 
  8000f9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800100:	e8 c2 1d 00 00       	call   801ec7 <socket>
  800105:	89 c6                	mov    %eax,%esi
  800107:	85 c0                	test   %eax,%eax
  800109:	79 0a                	jns    800115 <umain+0x35>
		die("Failed to create socket");
  80010b:	b8 40 2b 80 00       	mov    $0x802b40,%eax
  800110:	e8 1e ff ff ff       	call   800033 <die>

	cprintf("opened socket\n");
  800115:	c7 04 24 58 2b 80 00 	movl   $0x802b58,(%esp)
  80011c:	e8 10 05 00 00       	call   800631 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800121:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800128:	00 
  800129:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800130:	00 
  800131:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  800134:	89 1c 24             	mov    %ebx,(%esp)
  800137:	e8 6b 0c 00 00       	call   800da7 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  80013c:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  800140:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800147:	e8 94 01 00 00       	call   8002e0 <htonl>
  80014c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  80014f:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800156:	e8 6b 01 00 00       	call   8002c6 <htons>
  80015b:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to bind\n");
  80015f:	c7 04 24 67 2b 80 00 	movl   $0x802b67,(%esp)
  800166:	e8 c6 04 00 00       	call   800631 <cprintf>

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  80016b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800172:	00 
  800173:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800177:	89 34 24             	mov    %esi,(%esp)
  80017a:	e8 a6 1c 00 00       	call   801e25 <bind>
  80017f:	85 c0                	test   %eax,%eax
  800181:	79 0a                	jns    80018d <umain+0xad>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
  800183:	b8 10 2c 80 00       	mov    $0x802c10,%eax
  800188:	e8 a6 fe ff ff       	call   800033 <die>
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  80018d:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  800194:	00 
  800195:	89 34 24             	mov    %esi,(%esp)
  800198:	e8 05 1d 00 00       	call   801ea2 <listen>
  80019d:	85 c0                	test   %eax,%eax
  80019f:	79 0a                	jns    8001ab <umain+0xcb>
		die("Failed to listen on server socket");
  8001a1:	b8 34 2c 80 00       	mov    $0x802c34,%eax
  8001a6:	e8 88 fe ff ff       	call   800033 <die>

	cprintf("bound\n");
  8001ab:	c7 04 24 77 2b 80 00 	movl   $0x802b77,(%esp)
  8001b2:	e8 7a 04 00 00       	call   800631 <cprintf>

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
		// Wait for client connection
		if ((clientsock =
  8001b7:	8d 7d c4             	lea    -0x3c(%ebp),%edi

	cprintf("bound\n");

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
  8001ba:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		// Wait for client connection
		if ((clientsock =
  8001c1:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8001c5:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8001c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001cc:	89 34 24             	mov    %esi,(%esp)
  8001cf:	e8 16 1c 00 00       	call   801dea <accept>
  8001d4:	89 c3                	mov    %eax,%ebx
  8001d6:	85 c0                	test   %eax,%eax
  8001d8:	79 0a                	jns    8001e4 <umain+0x104>
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8001da:	b8 58 2c 80 00       	mov    $0x802c58,%eax
  8001df:	e8 4f fe ff ff       	call   800033 <die>
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8001e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001e7:	89 04 24             	mov    %eax,(%esp)
  8001ea:	e8 21 00 00 00       	call   800210 <inet_ntoa>
  8001ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f3:	c7 04 24 7e 2b 80 00 	movl   $0x802b7e,(%esp)
  8001fa:	e8 32 04 00 00       	call   800631 <cprintf>
		handle_client(clientsock);
  8001ff:	89 1c 24             	mov    %ebx,(%esp)
  800202:	e8 49 fe ff ff       	call   800050 <handle_client>
	}
  800207:	eb b1                	jmp    8001ba <umain+0xda>
  800209:	66 90                	xchg   %ax,%ax
  80020b:	66 90                	xchg   %ax,%ax
  80020d:	66 90                	xchg   %ax,%ax
  80020f:	90                   	nop

00800210 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	57                   	push   %edi
  800214:	56                   	push   %esi
  800215:	53                   	push   %ebx
  800216:	83 ec 19             	sub    $0x19,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800219:	8b 45 08             	mov    0x8(%ebp),%eax
  80021c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80021f:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  800223:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  800226:	c7 45 dc 00 50 80 00 	movl   $0x805000,-0x24(%ebp)
 */
char *
inet_ntoa(struct in_addr addr)
{
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80022d:	be 00 00 00 00       	mov    $0x0,%esi
  800232:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800235:	eb 02                	jmp    800239 <inet_ntoa+0x29>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  800237:	89 ce                	mov    %ecx,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800239:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80023c:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  80023f:	0f b6 c2             	movzbl %dl,%eax
  800242:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  800245:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
  800248:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80024b:	66 c1 e8 0b          	shr    $0xb,%ax
  80024f:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  800251:	8d 4e 01             	lea    0x1(%esi),%ecx
  800254:	89 f3                	mov    %esi,%ebx
  800256:	0f b6 f3             	movzbl %bl,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800259:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  80025c:	01 ff                	add    %edi,%edi
  80025e:	89 fb                	mov    %edi,%ebx
  800260:	29 da                	sub    %ebx,%edx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
  800262:	83 c2 30             	add    $0x30,%edx
  800265:	88 54 35 ed          	mov    %dl,-0x13(%ebp,%esi,1)
    } while(*ap);
  800269:	84 c0                	test   %al,%al
  80026b:	75 ca                	jne    800237 <inet_ntoa+0x27>
  80026d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800270:	89 c8                	mov    %ecx,%eax
  800272:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800275:	89 cf                	mov    %ecx,%edi
  800277:	eb 0d                	jmp    800286 <inet_ntoa+0x76>
    while(i--)
      *rp++ = inv[i];
  800279:	0f b6 f0             	movzbl %al,%esi
  80027c:	0f b6 4c 35 ed       	movzbl -0x13(%ebp,%esi,1),%ecx
  800281:	88 0a                	mov    %cl,(%edx)
  800283:	83 c2 01             	add    $0x1,%edx
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  800286:	83 e8 01             	sub    $0x1,%eax
  800289:	3c ff                	cmp    $0xff,%al
  80028b:	75 ec                	jne    800279 <inet_ntoa+0x69>
  80028d:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800290:	89 f9                	mov    %edi,%ecx
  800292:	0f b6 c9             	movzbl %cl,%ecx
  800295:	03 4d dc             	add    -0x24(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  800298:	8d 41 01             	lea    0x1(%ecx),%eax
  80029b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    ap++;
  80029e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8002a2:	80 45 db 01          	addb   $0x1,-0x25(%ebp)
  8002a6:	80 7d db 03          	cmpb   $0x3,-0x25(%ebp)
  8002aa:	77 0a                	ja     8002b6 <inet_ntoa+0xa6>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  8002ac:	c6 01 2e             	movb   $0x2e,(%ecx)
  8002af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b4:	eb 81                	jmp    800237 <inet_ntoa+0x27>
    ap++;
  }
  *--rp = 0;
  8002b6:	c6 01 00             	movb   $0x0,(%ecx)
  return str;
}
  8002b9:	b8 00 50 80 00       	mov    $0x805000,%eax
  8002be:	83 c4 19             	add    $0x19,%esp
  8002c1:	5b                   	pop    %ebx
  8002c2:	5e                   	pop    %esi
  8002c3:	5f                   	pop    %edi
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    

008002c6 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8002c9:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002cd:	66 c1 c0 08          	rol    $0x8,%ax
}
  8002d1:	5d                   	pop    %ebp
  8002d2:	c3                   	ret    

008002d3 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8002d6:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002da:	66 c1 c0 08          	rol    $0x8,%ax
 */
u16_t
ntohs(u16_t n)
{
  return htons(n);
}
  8002de:	5d                   	pop    %ebp
  8002df:	c3                   	ret    

008002e0 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8002e6:	89 d1                	mov    %edx,%ecx
  8002e8:	c1 e9 18             	shr    $0x18,%ecx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8002eb:	89 d0                	mov    %edx,%eax
  8002ed:	c1 e0 18             	shl    $0x18,%eax
  8002f0:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8002f2:	89 d1                	mov    %edx,%ecx
  8002f4:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  8002fa:	c1 e1 08             	shl    $0x8,%ecx
  8002fd:	09 c8                	or     %ecx,%eax
    ((n & 0xff0000UL) >> 8) |
  8002ff:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  800305:	c1 ea 08             	shr    $0x8,%edx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  800308:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80030a:	5d                   	pop    %ebp
  80030b:	c3                   	ret    

0080030c <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80030c:	55                   	push   %ebp
  80030d:	89 e5                	mov    %esp,%ebp
  80030f:	57                   	push   %edi
  800310:	56                   	push   %esi
  800311:	53                   	push   %ebx
  800312:	83 ec 20             	sub    $0x20,%esp
  800315:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  800318:	0f be 10             	movsbl (%eax),%edx
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  80031b:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80031e:	89 75 d8             	mov    %esi,-0x28(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  800321:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800324:	80 f9 09             	cmp    $0x9,%cl
  800327:	0f 87 a6 01 00 00    	ja     8004d3 <inet_aton+0x1c7>
      return (0);
    val = 0;
    base = 10;
  80032d:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
    if (c == '0') {
  800334:	83 fa 30             	cmp    $0x30,%edx
  800337:	75 2b                	jne    800364 <inet_aton+0x58>
      c = *++cp;
  800339:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  80033d:	89 d1                	mov    %edx,%ecx
  80033f:	83 e1 df             	and    $0xffffffdf,%ecx
  800342:	80 f9 58             	cmp    $0x58,%cl
  800345:	74 0f                	je     800356 <inet_aton+0x4a>
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
  800347:	83 c0 01             	add    $0x1,%eax
  80034a:	0f be d2             	movsbl %dl,%edx
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
      } else
        base = 8;
  80034d:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  800354:	eb 0e                	jmp    800364 <inet_aton+0x58>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  800356:	0f be 50 02          	movsbl 0x2(%eax),%edx
  80035a:	8d 40 02             	lea    0x2(%eax),%eax
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  80035d:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  800364:	83 c0 01             	add    $0x1,%eax
  800367:	bf 00 00 00 00       	mov    $0x0,%edi
  80036c:	eb 03                	jmp    800371 <inet_aton+0x65>
  80036e:	83 c0 01             	add    $0x1,%eax
  800371:	8d 70 ff             	lea    -0x1(%eax),%esi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  800374:	89 d3                	mov    %edx,%ebx
  800376:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800379:	80 f9 09             	cmp    $0x9,%cl
  80037c:	77 0d                	ja     80038b <inet_aton+0x7f>
        val = (val * base) + (int)(c - '0');
  80037e:	0f af 7d e0          	imul   -0x20(%ebp),%edi
  800382:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  800386:	0f be 10             	movsbl (%eax),%edx
  800389:	eb e3                	jmp    80036e <inet_aton+0x62>
      } else if (base == 16 && isxdigit(c)) {
  80038b:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  80038f:	75 30                	jne    8003c1 <inet_aton+0xb5>
  800391:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
  800394:	88 4d df             	mov    %cl,-0x21(%ebp)
  800397:	89 d1                	mov    %edx,%ecx
  800399:	83 e1 df             	and    $0xffffffdf,%ecx
  80039c:	83 e9 41             	sub    $0x41,%ecx
  80039f:	80 f9 05             	cmp    $0x5,%cl
  8003a2:	77 23                	ja     8003c7 <inet_aton+0xbb>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8003a4:	89 fb                	mov    %edi,%ebx
  8003a6:	c1 e3 04             	shl    $0x4,%ebx
  8003a9:	8d 7a 0a             	lea    0xa(%edx),%edi
  8003ac:	80 7d df 1a          	cmpb   $0x1a,-0x21(%ebp)
  8003b0:	19 c9                	sbb    %ecx,%ecx
  8003b2:	83 e1 20             	and    $0x20,%ecx
  8003b5:	83 c1 41             	add    $0x41,%ecx
  8003b8:	29 cf                	sub    %ecx,%edi
  8003ba:	09 df                	or     %ebx,%edi
        c = *++cp;
  8003bc:	0f be 10             	movsbl (%eax),%edx
  8003bf:	eb ad                	jmp    80036e <inet_aton+0x62>
  8003c1:	89 d0                	mov    %edx,%eax
  8003c3:	89 f9                	mov    %edi,%ecx
  8003c5:	eb 04                	jmp    8003cb <inet_aton+0xbf>
  8003c7:	89 d0                	mov    %edx,%eax
  8003c9:	89 f9                	mov    %edi,%ecx
      } else
        break;
    }
    if (c == '.') {
  8003cb:	83 f8 2e             	cmp    $0x2e,%eax
  8003ce:	75 22                	jne    8003f2 <inet_aton+0xe6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8003d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8003d3:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8003d6:	0f 84 fe 00 00 00    	je     8004da <inet_aton+0x1ce>
        return (0);
      *pp++ = val;
  8003dc:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  8003e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003e3:	89 48 fc             	mov    %ecx,-0x4(%eax)
      c = *++cp;
  8003e6:	8d 46 01             	lea    0x1(%esi),%eax
  8003e9:	0f be 56 01          	movsbl 0x1(%esi),%edx
    } else
      break;
  }
  8003ed:	e9 2f ff ff ff       	jmp    800321 <inet_aton+0x15>
  8003f2:	89 f9                	mov    %edi,%ecx
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003f4:	85 d2                	test   %edx,%edx
  8003f6:	74 27                	je     80041f <inet_aton+0x113>
    return (0);
  8003f8:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003fd:	80 fb 1f             	cmp    $0x1f,%bl
  800400:	0f 86 e7 00 00 00    	jbe    8004ed <inet_aton+0x1e1>
  800406:	84 d2                	test   %dl,%dl
  800408:	0f 88 d3 00 00 00    	js     8004e1 <inet_aton+0x1d5>
  80040e:	83 fa 20             	cmp    $0x20,%edx
  800411:	74 0c                	je     80041f <inet_aton+0x113>
  800413:	83 ea 09             	sub    $0x9,%edx
  800416:	83 fa 04             	cmp    $0x4,%edx
  800419:	0f 87 ce 00 00 00    	ja     8004ed <inet_aton+0x1e1>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  80041f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800422:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800425:	29 c2                	sub    %eax,%edx
  800427:	c1 fa 02             	sar    $0x2,%edx
  80042a:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  80042d:	83 fa 02             	cmp    $0x2,%edx
  800430:	74 22                	je     800454 <inet_aton+0x148>
  800432:	83 fa 02             	cmp    $0x2,%edx
  800435:	7f 0f                	jg     800446 <inet_aton+0x13a>

  case 0:
    return (0);       /* initial nondigit */
  800437:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  80043c:	85 d2                	test   %edx,%edx
  80043e:	0f 84 a9 00 00 00    	je     8004ed <inet_aton+0x1e1>
  800444:	eb 73                	jmp    8004b9 <inet_aton+0x1ad>
  800446:	83 fa 03             	cmp    $0x3,%edx
  800449:	74 26                	je     800471 <inet_aton+0x165>
  80044b:	83 fa 04             	cmp    $0x4,%edx
  80044e:	66 90                	xchg   %ax,%ax
  800450:	74 40                	je     800492 <inet_aton+0x186>
  800452:	eb 65                	jmp    8004b9 <inet_aton+0x1ad>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  800454:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  800459:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  80045f:	0f 87 88 00 00 00    	ja     8004ed <inet_aton+0x1e1>
      return (0);
    val |= parts[0] << 24;
  800465:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800468:	c1 e0 18             	shl    $0x18,%eax
  80046b:	89 cf                	mov    %ecx,%edi
  80046d:	09 c7                	or     %eax,%edi
    break;
  80046f:	eb 48                	jmp    8004b9 <inet_aton+0x1ad>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  800471:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  800476:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  80047c:	77 6f                	ja     8004ed <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  80047e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800481:	c1 e2 10             	shl    $0x10,%edx
  800484:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800487:	c1 e0 18             	shl    $0x18,%eax
  80048a:	09 d0                	or     %edx,%eax
  80048c:	09 c8                	or     %ecx,%eax
  80048e:	89 c7                	mov    %eax,%edi
    break;
  800490:	eb 27                	jmp    8004b9 <inet_aton+0x1ad>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  800492:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  800497:	81 f9 ff 00 00 00    	cmp    $0xff,%ecx
  80049d:	77 4e                	ja     8004ed <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80049f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004a2:	c1 e2 10             	shl    $0x10,%edx
  8004a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a8:	c1 e0 18             	shl    $0x18,%eax
  8004ab:	09 c2                	or     %eax,%edx
  8004ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004b0:	c1 e0 08             	shl    $0x8,%eax
  8004b3:	09 d0                	or     %edx,%eax
  8004b5:	09 c8                	or     %ecx,%eax
  8004b7:	89 c7                	mov    %eax,%edi
    break;
  }
  if (addr)
  8004b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004bd:	74 29                	je     8004e8 <inet_aton+0x1dc>
    addr->s_addr = htonl(val);
  8004bf:	89 3c 24             	mov    %edi,(%esp)
  8004c2:	e8 19 fe ff ff       	call   8002e0 <htonl>
  8004c7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004ca:	89 06                	mov    %eax,(%esi)
  return (1);
  8004cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8004d1:	eb 1a                	jmp    8004ed <inet_aton+0x1e1>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  8004d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d8:	eb 13                	jmp    8004ed <inet_aton+0x1e1>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  8004da:	b8 00 00 00 00       	mov    $0x0,%eax
  8004df:	eb 0c                	jmp    8004ed <inet_aton+0x1e1>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  8004e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e6:	eb 05                	jmp    8004ed <inet_aton+0x1e1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  8004e8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8004ed:	83 c4 20             	add    $0x20,%esp
  8004f0:	5b                   	pop    %ebx
  8004f1:	5e                   	pop    %esi
  8004f2:	5f                   	pop    %edi
  8004f3:	5d                   	pop    %ebp
  8004f4:	c3                   	ret    

008004f5 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8004fb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8004fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800502:	8b 45 08             	mov    0x8(%ebp),%eax
  800505:	89 04 24             	mov    %eax,(%esp)
  800508:	e8 ff fd ff ff       	call   80030c <inet_aton>
  80050d:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  80050f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800514:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  800518:	c9                   	leave  
  800519:	c3                   	ret    

0080051a <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	89 04 24             	mov    %eax,(%esp)
  800526:	e8 b5 fd ff ff       	call   8002e0 <htonl>
}
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	56                   	push   %esi
  800531:	53                   	push   %ebx
  800532:	83 ec 10             	sub    $0x10,%esp
  800535:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800538:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80053b:	e8 f5 0a 00 00       	call   801035 <sys_getenvid>
  800540:	25 ff 03 00 00       	and    $0x3ff,%eax
  800545:	c1 e0 07             	shl    $0x7,%eax
  800548:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80054d:	a3 18 50 80 00       	mov    %eax,0x805018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800552:	85 db                	test   %ebx,%ebx
  800554:	7e 07                	jle    80055d <libmain+0x30>
		binaryname = argv[0];
  800556:	8b 06                	mov    (%esi),%eax
  800558:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80055d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800561:	89 1c 24             	mov    %ebx,(%esp)
  800564:	e8 77 fb ff ff       	call   8000e0 <umain>

	// exit gracefully
	exit();
  800569:	e8 07 00 00 00       	call   800575 <exit>
}
  80056e:	83 c4 10             	add    $0x10,%esp
  800571:	5b                   	pop    %ebx
  800572:	5e                   	pop    %esi
  800573:	5d                   	pop    %ebp
  800574:	c3                   	ret    

00800575 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800575:	55                   	push   %ebp
  800576:	89 e5                	mov    %esp,%ebp
  800578:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80057b:	e8 1a 10 00 00       	call   80159a <close_all>
	sys_env_destroy(0);
  800580:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800587:	e8 57 0a 00 00       	call   800fe3 <sys_env_destroy>
}
  80058c:	c9                   	leave  
  80058d:	c3                   	ret    

0080058e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	53                   	push   %ebx
  800592:	83 ec 14             	sub    $0x14,%esp
  800595:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800598:	8b 13                	mov    (%ebx),%edx
  80059a:	8d 42 01             	lea    0x1(%edx),%eax
  80059d:	89 03                	mov    %eax,(%ebx)
  80059f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005a2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8005a6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005ab:	75 19                	jne    8005c6 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8005ad:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8005b4:	00 
  8005b5:	8d 43 08             	lea    0x8(%ebx),%eax
  8005b8:	89 04 24             	mov    %eax,(%esp)
  8005bb:	e8 e6 09 00 00       	call   800fa6 <sys_cputs>
		b->idx = 0;
  8005c0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8005c6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8005ca:	83 c4 14             	add    $0x14,%esp
  8005cd:	5b                   	pop    %ebx
  8005ce:	5d                   	pop    %ebp
  8005cf:	c3                   	ret    

008005d0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005d0:	55                   	push   %ebp
  8005d1:	89 e5                	mov    %esp,%ebp
  8005d3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8005d9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005e0:	00 00 00 
	b.cnt = 0;
  8005e3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005ea:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800601:	89 44 24 04          	mov    %eax,0x4(%esp)
  800605:	c7 04 24 8e 05 80 00 	movl   $0x80058e,(%esp)
  80060c:	e8 ad 01 00 00       	call   8007be <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800611:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800617:	89 44 24 04          	mov    %eax,0x4(%esp)
  80061b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800621:	89 04 24             	mov    %eax,(%esp)
  800624:	e8 7d 09 00 00       	call   800fa6 <sys_cputs>

	return b.cnt;
}
  800629:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80062f:	c9                   	leave  
  800630:	c3                   	ret    

00800631 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800631:	55                   	push   %ebp
  800632:	89 e5                	mov    %esp,%ebp
  800634:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800637:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80063a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	89 04 24             	mov    %eax,(%esp)
  800644:	e8 87 ff ff ff       	call   8005d0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800649:	c9                   	leave  
  80064a:	c3                   	ret    
  80064b:	66 90                	xchg   %ax,%ax
  80064d:	66 90                	xchg   %ax,%ax
  80064f:	90                   	nop

00800650 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800650:	55                   	push   %ebp
  800651:	89 e5                	mov    %esp,%ebp
  800653:	57                   	push   %edi
  800654:	56                   	push   %esi
  800655:	53                   	push   %ebx
  800656:	83 ec 3c             	sub    $0x3c,%esp
  800659:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80065c:	89 d7                	mov    %edx,%edi
  80065e:	8b 45 08             	mov    0x8(%ebp),%eax
  800661:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800664:	8b 45 0c             	mov    0xc(%ebp),%eax
  800667:	89 c3                	mov    %eax,%ebx
  800669:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80066c:	8b 45 10             	mov    0x10(%ebp),%eax
  80066f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800672:	b9 00 00 00 00       	mov    $0x0,%ecx
  800677:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80067a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80067d:	39 d9                	cmp    %ebx,%ecx
  80067f:	72 05                	jb     800686 <printnum+0x36>
  800681:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800684:	77 69                	ja     8006ef <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800686:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800689:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80068d:	83 ee 01             	sub    $0x1,%esi
  800690:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800694:	89 44 24 08          	mov    %eax,0x8(%esp)
  800698:	8b 44 24 08          	mov    0x8(%esp),%eax
  80069c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8006a0:	89 c3                	mov    %eax,%ebx
  8006a2:	89 d6                	mov    %edx,%esi
  8006a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006a7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006aa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8006ae:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8006b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b5:	89 04 24             	mov    %eax,(%esp)
  8006b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006bf:	e8 dc 21 00 00       	call   8028a0 <__udivdi3>
  8006c4:	89 d9                	mov    %ebx,%ecx
  8006c6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006ca:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006ce:	89 04 24             	mov    %eax,(%esp)
  8006d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006d5:	89 fa                	mov    %edi,%edx
  8006d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006da:	e8 71 ff ff ff       	call   800650 <printnum>
  8006df:	eb 1b                	jmp    8006fc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006e1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006e5:	8b 45 18             	mov    0x18(%ebp),%eax
  8006e8:	89 04 24             	mov    %eax,(%esp)
  8006eb:	ff d3                	call   *%ebx
  8006ed:	eb 03                	jmp    8006f2 <printnum+0xa2>
  8006ef:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f2:	83 ee 01             	sub    $0x1,%esi
  8006f5:	85 f6                	test   %esi,%esi
  8006f7:	7f e8                	jg     8006e1 <printnum+0x91>
  8006f9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006fc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800700:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800704:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800707:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80070a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80070e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800712:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800715:	89 04 24             	mov    %eax,(%esp)
  800718:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80071b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80071f:	e8 ac 22 00 00       	call   8029d0 <__umoddi3>
  800724:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800728:	0f be 80 85 2c 80 00 	movsbl 0x802c85(%eax),%eax
  80072f:	89 04 24             	mov    %eax,(%esp)
  800732:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800735:	ff d0                	call   *%eax
}
  800737:	83 c4 3c             	add    $0x3c,%esp
  80073a:	5b                   	pop    %ebx
  80073b:	5e                   	pop    %esi
  80073c:	5f                   	pop    %edi
  80073d:	5d                   	pop    %ebp
  80073e:	c3                   	ret    

0080073f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80073f:	55                   	push   %ebp
  800740:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800742:	83 fa 01             	cmp    $0x1,%edx
  800745:	7e 0e                	jle    800755 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800747:	8b 10                	mov    (%eax),%edx
  800749:	8d 4a 08             	lea    0x8(%edx),%ecx
  80074c:	89 08                	mov    %ecx,(%eax)
  80074e:	8b 02                	mov    (%edx),%eax
  800750:	8b 52 04             	mov    0x4(%edx),%edx
  800753:	eb 22                	jmp    800777 <getuint+0x38>
	else if (lflag)
  800755:	85 d2                	test   %edx,%edx
  800757:	74 10                	je     800769 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800759:	8b 10                	mov    (%eax),%edx
  80075b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80075e:	89 08                	mov    %ecx,(%eax)
  800760:	8b 02                	mov    (%edx),%eax
  800762:	ba 00 00 00 00       	mov    $0x0,%edx
  800767:	eb 0e                	jmp    800777 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800769:	8b 10                	mov    (%eax),%edx
  80076b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80076e:	89 08                	mov    %ecx,(%eax)
  800770:	8b 02                	mov    (%edx),%eax
  800772:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800777:	5d                   	pop    %ebp
  800778:	c3                   	ret    

00800779 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
  80077c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80077f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800783:	8b 10                	mov    (%eax),%edx
  800785:	3b 50 04             	cmp    0x4(%eax),%edx
  800788:	73 0a                	jae    800794 <sprintputch+0x1b>
		*b->buf++ = ch;
  80078a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80078d:	89 08                	mov    %ecx,(%eax)
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	88 02                	mov    %al,(%edx)
}
  800794:	5d                   	pop    %ebp
  800795:	c3                   	ret    

00800796 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800796:	55                   	push   %ebp
  800797:	89 e5                	mov    %esp,%ebp
  800799:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80079c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80079f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	89 04 24             	mov    %eax,(%esp)
  8007b7:	e8 02 00 00 00       	call   8007be <vprintfmt>
	va_end(ap);
}
  8007bc:	c9                   	leave  
  8007bd:	c3                   	ret    

008007be <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007be:	55                   	push   %ebp
  8007bf:	89 e5                	mov    %esp,%ebp
  8007c1:	57                   	push   %edi
  8007c2:	56                   	push   %esi
  8007c3:	53                   	push   %ebx
  8007c4:	83 ec 3c             	sub    $0x3c,%esp
  8007c7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8007ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007cd:	eb 14                	jmp    8007e3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8007cf:	85 c0                	test   %eax,%eax
  8007d1:	0f 84 b3 03 00 00    	je     800b8a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8007d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007db:	89 04 24             	mov    %eax,(%esp)
  8007de:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e1:	89 f3                	mov    %esi,%ebx
  8007e3:	8d 73 01             	lea    0x1(%ebx),%esi
  8007e6:	0f b6 03             	movzbl (%ebx),%eax
  8007e9:	83 f8 25             	cmp    $0x25,%eax
  8007ec:	75 e1                	jne    8007cf <vprintfmt+0x11>
  8007ee:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8007f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8007f9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800800:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800807:	ba 00 00 00 00       	mov    $0x0,%edx
  80080c:	eb 1d                	jmp    80082b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80080e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800810:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800814:	eb 15                	jmp    80082b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800816:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800818:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80081c:	eb 0d                	jmp    80082b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80081e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800821:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800824:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80082b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80082e:	0f b6 0e             	movzbl (%esi),%ecx
  800831:	0f b6 c1             	movzbl %cl,%eax
  800834:	83 e9 23             	sub    $0x23,%ecx
  800837:	80 f9 55             	cmp    $0x55,%cl
  80083a:	0f 87 2a 03 00 00    	ja     800b6a <vprintfmt+0x3ac>
  800840:	0f b6 c9             	movzbl %cl,%ecx
  800843:	ff 24 8d c0 2d 80 00 	jmp    *0x802dc0(,%ecx,4)
  80084a:	89 de                	mov    %ebx,%esi
  80084c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800851:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800854:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800858:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80085b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80085e:	83 fb 09             	cmp    $0x9,%ebx
  800861:	77 36                	ja     800899 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800863:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800866:	eb e9                	jmp    800851 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	8d 48 04             	lea    0x4(%eax),%ecx
  80086e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800871:	8b 00                	mov    (%eax),%eax
  800873:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800876:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800878:	eb 22                	jmp    80089c <vprintfmt+0xde>
  80087a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80087d:	85 c9                	test   %ecx,%ecx
  80087f:	b8 00 00 00 00       	mov    $0x0,%eax
  800884:	0f 49 c1             	cmovns %ecx,%eax
  800887:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80088a:	89 de                	mov    %ebx,%esi
  80088c:	eb 9d                	jmp    80082b <vprintfmt+0x6d>
  80088e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800890:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800897:	eb 92                	jmp    80082b <vprintfmt+0x6d>
  800899:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80089c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008a0:	79 89                	jns    80082b <vprintfmt+0x6d>
  8008a2:	e9 77 ff ff ff       	jmp    80081e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008a7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008aa:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8008ac:	e9 7a ff ff ff       	jmp    80082b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	8d 50 04             	lea    0x4(%eax),%edx
  8008b7:	89 55 14             	mov    %edx,0x14(%ebp)
  8008ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	89 04 24             	mov    %eax,(%esp)
  8008c3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008c6:	e9 18 ff ff ff       	jmp    8007e3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	8d 50 04             	lea    0x4(%eax),%edx
  8008d1:	89 55 14             	mov    %edx,0x14(%ebp)
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	99                   	cltd   
  8008d7:	31 d0                	xor    %edx,%eax
  8008d9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008db:	83 f8 11             	cmp    $0x11,%eax
  8008de:	7f 0b                	jg     8008eb <vprintfmt+0x12d>
  8008e0:	8b 14 85 20 2f 80 00 	mov    0x802f20(,%eax,4),%edx
  8008e7:	85 d2                	test   %edx,%edx
  8008e9:	75 20                	jne    80090b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8008eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008ef:	c7 44 24 08 9d 2c 80 	movl   $0x802c9d,0x8(%esp)
  8008f6:	00 
  8008f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 04 24             	mov    %eax,(%esp)
  800901:	e8 90 fe ff ff       	call   800796 <printfmt>
  800906:	e9 d8 fe ff ff       	jmp    8007e3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80090b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80090f:	c7 44 24 08 5d 30 80 	movl   $0x80305d,0x8(%esp)
  800916:	00 
  800917:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	89 04 24             	mov    %eax,(%esp)
  800921:	e8 70 fe ff ff       	call   800796 <printfmt>
  800926:	e9 b8 fe ff ff       	jmp    8007e3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80092b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80092e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800931:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	8d 50 04             	lea    0x4(%eax),%edx
  80093a:	89 55 14             	mov    %edx,0x14(%ebp)
  80093d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80093f:	85 f6                	test   %esi,%esi
  800941:	b8 96 2c 80 00       	mov    $0x802c96,%eax
  800946:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800949:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80094d:	0f 84 97 00 00 00    	je     8009ea <vprintfmt+0x22c>
  800953:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800957:	0f 8e 9b 00 00 00    	jle    8009f8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80095d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800961:	89 34 24             	mov    %esi,(%esp)
  800964:	e8 cf 02 00 00       	call   800c38 <strnlen>
  800969:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80096c:	29 c2                	sub    %eax,%edx
  80096e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800971:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800975:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800978:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80097b:	8b 75 08             	mov    0x8(%ebp),%esi
  80097e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800981:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800983:	eb 0f                	jmp    800994 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800985:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800989:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80098c:	89 04 24             	mov    %eax,(%esp)
  80098f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800991:	83 eb 01             	sub    $0x1,%ebx
  800994:	85 db                	test   %ebx,%ebx
  800996:	7f ed                	jg     800985 <vprintfmt+0x1c7>
  800998:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80099b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80099e:	85 d2                	test   %edx,%edx
  8009a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a5:	0f 49 c2             	cmovns %edx,%eax
  8009a8:	29 c2                	sub    %eax,%edx
  8009aa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8009ad:	89 d7                	mov    %edx,%edi
  8009af:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009b2:	eb 50                	jmp    800a04 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8009b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009b8:	74 1e                	je     8009d8 <vprintfmt+0x21a>
  8009ba:	0f be d2             	movsbl %dl,%edx
  8009bd:	83 ea 20             	sub    $0x20,%edx
  8009c0:	83 fa 5e             	cmp    $0x5e,%edx
  8009c3:	76 13                	jbe    8009d8 <vprintfmt+0x21a>
					putch('?', putdat);
  8009c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009cc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8009d3:	ff 55 08             	call   *0x8(%ebp)
  8009d6:	eb 0d                	jmp    8009e5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8009d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009db:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009df:	89 04 24             	mov    %eax,(%esp)
  8009e2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009e5:	83 ef 01             	sub    $0x1,%edi
  8009e8:	eb 1a                	jmp    800a04 <vprintfmt+0x246>
  8009ea:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8009ed:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8009f0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009f3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009f6:	eb 0c                	jmp    800a04 <vprintfmt+0x246>
  8009f8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8009fb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8009fe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a01:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a04:	83 c6 01             	add    $0x1,%esi
  800a07:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800a0b:	0f be c2             	movsbl %dl,%eax
  800a0e:	85 c0                	test   %eax,%eax
  800a10:	74 27                	je     800a39 <vprintfmt+0x27b>
  800a12:	85 db                	test   %ebx,%ebx
  800a14:	78 9e                	js     8009b4 <vprintfmt+0x1f6>
  800a16:	83 eb 01             	sub    $0x1,%ebx
  800a19:	79 99                	jns    8009b4 <vprintfmt+0x1f6>
  800a1b:	89 f8                	mov    %edi,%eax
  800a1d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a20:	8b 75 08             	mov    0x8(%ebp),%esi
  800a23:	89 c3                	mov    %eax,%ebx
  800a25:	eb 1a                	jmp    800a41 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a27:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a2b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800a32:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a34:	83 eb 01             	sub    $0x1,%ebx
  800a37:	eb 08                	jmp    800a41 <vprintfmt+0x283>
  800a39:	89 fb                	mov    %edi,%ebx
  800a3b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a3e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a41:	85 db                	test   %ebx,%ebx
  800a43:	7f e2                	jg     800a27 <vprintfmt+0x269>
  800a45:	89 75 08             	mov    %esi,0x8(%ebp)
  800a48:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800a4b:	e9 93 fd ff ff       	jmp    8007e3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800a50:	83 fa 01             	cmp    $0x1,%edx
  800a53:	7e 16                	jle    800a6b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800a55:	8b 45 14             	mov    0x14(%ebp),%eax
  800a58:	8d 50 08             	lea    0x8(%eax),%edx
  800a5b:	89 55 14             	mov    %edx,0x14(%ebp)
  800a5e:	8b 50 04             	mov    0x4(%eax),%edx
  800a61:	8b 00                	mov    (%eax),%eax
  800a63:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a66:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a69:	eb 32                	jmp    800a9d <vprintfmt+0x2df>
	else if (lflag)
  800a6b:	85 d2                	test   %edx,%edx
  800a6d:	74 18                	je     800a87 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800a6f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a72:	8d 50 04             	lea    0x4(%eax),%edx
  800a75:	89 55 14             	mov    %edx,0x14(%ebp)
  800a78:	8b 30                	mov    (%eax),%esi
  800a7a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800a7d:	89 f0                	mov    %esi,%eax
  800a7f:	c1 f8 1f             	sar    $0x1f,%eax
  800a82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a85:	eb 16                	jmp    800a9d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800a87:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8a:	8d 50 04             	lea    0x4(%eax),%edx
  800a8d:	89 55 14             	mov    %edx,0x14(%ebp)
  800a90:	8b 30                	mov    (%eax),%esi
  800a92:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800a95:	89 f0                	mov    %esi,%eax
  800a97:	c1 f8 1f             	sar    $0x1f,%eax
  800a9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800aa3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800aa8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aac:	0f 89 80 00 00 00    	jns    800b32 <vprintfmt+0x374>
				putch('-', putdat);
  800ab2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ab6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800abd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800ac0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ac6:	f7 d8                	neg    %eax
  800ac8:	83 d2 00             	adc    $0x0,%edx
  800acb:	f7 da                	neg    %edx
			}
			base = 10;
  800acd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ad2:	eb 5e                	jmp    800b32 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ad4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ad7:	e8 63 fc ff ff       	call   80073f <getuint>
			base = 10;
  800adc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800ae1:	eb 4f                	jmp    800b32 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800ae3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae6:	e8 54 fc ff ff       	call   80073f <getuint>
			base = 8;
  800aeb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800af0:	eb 40                	jmp    800b32 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800af2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800af6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800afd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800b00:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b04:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b0b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800b0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b11:	8d 50 04             	lea    0x4(%eax),%edx
  800b14:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b17:	8b 00                	mov    (%eax),%eax
  800b19:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800b1e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800b23:	eb 0d                	jmp    800b32 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b25:	8d 45 14             	lea    0x14(%ebp),%eax
  800b28:	e8 12 fc ff ff       	call   80073f <getuint>
			base = 16;
  800b2d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b32:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800b36:	89 74 24 10          	mov    %esi,0x10(%esp)
  800b3a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800b3d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800b41:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800b45:	89 04 24             	mov    %eax,(%esp)
  800b48:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b4c:	89 fa                	mov    %edi,%edx
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	e8 fa fa ff ff       	call   800650 <printnum>
			break;
  800b56:	e9 88 fc ff ff       	jmp    8007e3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b5b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b5f:	89 04 24             	mov    %eax,(%esp)
  800b62:	ff 55 08             	call   *0x8(%ebp)
			break;
  800b65:	e9 79 fc ff ff       	jmp    8007e3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b6a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b6e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800b75:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b78:	89 f3                	mov    %esi,%ebx
  800b7a:	eb 03                	jmp    800b7f <vprintfmt+0x3c1>
  800b7c:	83 eb 01             	sub    $0x1,%ebx
  800b7f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800b83:	75 f7                	jne    800b7c <vprintfmt+0x3be>
  800b85:	e9 59 fc ff ff       	jmp    8007e3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800b8a:	83 c4 3c             	add    $0x3c,%esp
  800b8d:	5b                   	pop    %ebx
  800b8e:	5e                   	pop    %esi
  800b8f:	5f                   	pop    %edi
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	83 ec 28             	sub    $0x28,%esp
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ba1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ba5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ba8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800baf:	85 c0                	test   %eax,%eax
  800bb1:	74 30                	je     800be3 <vsnprintf+0x51>
  800bb3:	85 d2                	test   %edx,%edx
  800bb5:	7e 2c                	jle    800be3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bc5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bcc:	c7 04 24 79 07 80 00 	movl   $0x800779,(%esp)
  800bd3:	e8 e6 fb ff ff       	call   8007be <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bdb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800be1:	eb 05                	jmp    800be8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800be3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800be8:	c9                   	leave  
  800be9:	c3                   	ret    

00800bea <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bf0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bf3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfa:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	89 04 24             	mov    %eax,(%esp)
  800c0b:	e8 82 ff ff ff       	call   800b92 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    
  800c12:	66 90                	xchg   %ax,%ax
  800c14:	66 90                	xchg   %ax,%ax
  800c16:	66 90                	xchg   %ax,%ax
  800c18:	66 90                	xchg   %ax,%ax
  800c1a:	66 90                	xchg   %ax,%ax
  800c1c:	66 90                	xchg   %ax,%ax
  800c1e:	66 90                	xchg   %ax,%ax

00800c20 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c26:	b8 00 00 00 00       	mov    $0x0,%eax
  800c2b:	eb 03                	jmp    800c30 <strlen+0x10>
		n++;
  800c2d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c30:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c34:	75 f7                	jne    800c2d <strlen+0xd>
		n++;
	return n;
}
  800c36:	5d                   	pop    %ebp
  800c37:	c3                   	ret    

00800c38 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c38:	55                   	push   %ebp
  800c39:	89 e5                	mov    %esp,%ebp
  800c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c41:	b8 00 00 00 00       	mov    $0x0,%eax
  800c46:	eb 03                	jmp    800c4b <strnlen+0x13>
		n++;
  800c48:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c4b:	39 d0                	cmp    %edx,%eax
  800c4d:	74 06                	je     800c55 <strnlen+0x1d>
  800c4f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800c53:	75 f3                	jne    800c48 <strnlen+0x10>
		n++;
	return n;
}
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    

00800c57 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	53                   	push   %ebx
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c61:	89 c2                	mov    %eax,%edx
  800c63:	83 c2 01             	add    $0x1,%edx
  800c66:	83 c1 01             	add    $0x1,%ecx
  800c69:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800c6d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c70:	84 db                	test   %bl,%bl
  800c72:	75 ef                	jne    800c63 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800c74:	5b                   	pop    %ebx
  800c75:	5d                   	pop    %ebp
  800c76:	c3                   	ret    

00800c77 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	53                   	push   %ebx
  800c7b:	83 ec 08             	sub    $0x8,%esp
  800c7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c81:	89 1c 24             	mov    %ebx,(%esp)
  800c84:	e8 97 ff ff ff       	call   800c20 <strlen>
	strcpy(dst + len, src);
  800c89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c90:	01 d8                	add    %ebx,%eax
  800c92:	89 04 24             	mov    %eax,(%esp)
  800c95:	e8 bd ff ff ff       	call   800c57 <strcpy>
	return dst;
}
  800c9a:	89 d8                	mov    %ebx,%eax
  800c9c:	83 c4 08             	add    $0x8,%esp
  800c9f:	5b                   	pop    %ebx
  800ca0:	5d                   	pop    %ebp
  800ca1:	c3                   	ret    

00800ca2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	56                   	push   %esi
  800ca6:	53                   	push   %ebx
  800ca7:	8b 75 08             	mov    0x8(%ebp),%esi
  800caa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cad:	89 f3                	mov    %esi,%ebx
  800caf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb2:	89 f2                	mov    %esi,%edx
  800cb4:	eb 0f                	jmp    800cc5 <strncpy+0x23>
		*dst++ = *src;
  800cb6:	83 c2 01             	add    $0x1,%edx
  800cb9:	0f b6 01             	movzbl (%ecx),%eax
  800cbc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800cbf:	80 39 01             	cmpb   $0x1,(%ecx)
  800cc2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cc5:	39 da                	cmp    %ebx,%edx
  800cc7:	75 ed                	jne    800cb6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800cc9:	89 f0                	mov    %esi,%eax
  800ccb:	5b                   	pop    %ebx
  800ccc:	5e                   	pop    %esi
  800ccd:	5d                   	pop    %ebp
  800cce:	c3                   	ret    

00800ccf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	56                   	push   %esi
  800cd3:	53                   	push   %ebx
  800cd4:	8b 75 08             	mov    0x8(%ebp),%esi
  800cd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cda:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800cdd:	89 f0                	mov    %esi,%eax
  800cdf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ce3:	85 c9                	test   %ecx,%ecx
  800ce5:	75 0b                	jne    800cf2 <strlcpy+0x23>
  800ce7:	eb 1d                	jmp    800d06 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ce9:	83 c0 01             	add    $0x1,%eax
  800cec:	83 c2 01             	add    $0x1,%edx
  800cef:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cf2:	39 d8                	cmp    %ebx,%eax
  800cf4:	74 0b                	je     800d01 <strlcpy+0x32>
  800cf6:	0f b6 0a             	movzbl (%edx),%ecx
  800cf9:	84 c9                	test   %cl,%cl
  800cfb:	75 ec                	jne    800ce9 <strlcpy+0x1a>
  800cfd:	89 c2                	mov    %eax,%edx
  800cff:	eb 02                	jmp    800d03 <strlcpy+0x34>
  800d01:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800d03:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800d06:	29 f0                	sub    %esi,%eax
}
  800d08:	5b                   	pop    %ebx
  800d09:	5e                   	pop    %esi
  800d0a:	5d                   	pop    %ebp
  800d0b:	c3                   	ret    

00800d0c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d12:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d15:	eb 06                	jmp    800d1d <strcmp+0x11>
		p++, q++;
  800d17:	83 c1 01             	add    $0x1,%ecx
  800d1a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d1d:	0f b6 01             	movzbl (%ecx),%eax
  800d20:	84 c0                	test   %al,%al
  800d22:	74 04                	je     800d28 <strcmp+0x1c>
  800d24:	3a 02                	cmp    (%edx),%al
  800d26:	74 ef                	je     800d17 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d28:	0f b6 c0             	movzbl %al,%eax
  800d2b:	0f b6 12             	movzbl (%edx),%edx
  800d2e:	29 d0                	sub    %edx,%eax
}
  800d30:	5d                   	pop    %ebp
  800d31:	c3                   	ret    

00800d32 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	53                   	push   %ebx
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3c:	89 c3                	mov    %eax,%ebx
  800d3e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d41:	eb 06                	jmp    800d49 <strncmp+0x17>
		n--, p++, q++;
  800d43:	83 c0 01             	add    $0x1,%eax
  800d46:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800d49:	39 d8                	cmp    %ebx,%eax
  800d4b:	74 15                	je     800d62 <strncmp+0x30>
  800d4d:	0f b6 08             	movzbl (%eax),%ecx
  800d50:	84 c9                	test   %cl,%cl
  800d52:	74 04                	je     800d58 <strncmp+0x26>
  800d54:	3a 0a                	cmp    (%edx),%cl
  800d56:	74 eb                	je     800d43 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d58:	0f b6 00             	movzbl (%eax),%eax
  800d5b:	0f b6 12             	movzbl (%edx),%edx
  800d5e:	29 d0                	sub    %edx,%eax
  800d60:	eb 05                	jmp    800d67 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800d62:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800d67:	5b                   	pop    %ebx
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d74:	eb 07                	jmp    800d7d <strchr+0x13>
		if (*s == c)
  800d76:	38 ca                	cmp    %cl,%dl
  800d78:	74 0f                	je     800d89 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d7a:	83 c0 01             	add    $0x1,%eax
  800d7d:	0f b6 10             	movzbl (%eax),%edx
  800d80:	84 d2                	test   %dl,%dl
  800d82:	75 f2                	jne    800d76 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800d84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    

00800d8b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d95:	eb 07                	jmp    800d9e <strfind+0x13>
		if (*s == c)
  800d97:	38 ca                	cmp    %cl,%dl
  800d99:	74 0a                	je     800da5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d9b:	83 c0 01             	add    $0x1,%eax
  800d9e:	0f b6 10             	movzbl (%eax),%edx
  800da1:	84 d2                	test   %dl,%dl
  800da3:	75 f2                	jne    800d97 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800da5:	5d                   	pop    %ebp
  800da6:	c3                   	ret    

00800da7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	57                   	push   %edi
  800dab:	56                   	push   %esi
  800dac:	53                   	push   %ebx
  800dad:	8b 7d 08             	mov    0x8(%ebp),%edi
  800db0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800db3:	85 c9                	test   %ecx,%ecx
  800db5:	74 36                	je     800ded <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800db7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800dbd:	75 28                	jne    800de7 <memset+0x40>
  800dbf:	f6 c1 03             	test   $0x3,%cl
  800dc2:	75 23                	jne    800de7 <memset+0x40>
		c &= 0xFF;
  800dc4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800dc8:	89 d3                	mov    %edx,%ebx
  800dca:	c1 e3 08             	shl    $0x8,%ebx
  800dcd:	89 d6                	mov    %edx,%esi
  800dcf:	c1 e6 18             	shl    $0x18,%esi
  800dd2:	89 d0                	mov    %edx,%eax
  800dd4:	c1 e0 10             	shl    $0x10,%eax
  800dd7:	09 f0                	or     %esi,%eax
  800dd9:	09 c2                	or     %eax,%edx
  800ddb:	89 d0                	mov    %edx,%eax
  800ddd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ddf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800de2:	fc                   	cld    
  800de3:	f3 ab                	rep stos %eax,%es:(%edi)
  800de5:	eb 06                	jmp    800ded <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dea:	fc                   	cld    
  800deb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ded:	89 f8                	mov    %edi,%eax
  800def:	5b                   	pop    %ebx
  800df0:	5e                   	pop    %esi
  800df1:	5f                   	pop    %edi
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    

00800df4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	57                   	push   %edi
  800df8:	56                   	push   %esi
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e02:	39 c6                	cmp    %eax,%esi
  800e04:	73 35                	jae    800e3b <memmove+0x47>
  800e06:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e09:	39 d0                	cmp    %edx,%eax
  800e0b:	73 2e                	jae    800e3b <memmove+0x47>
		s += n;
		d += n;
  800e0d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800e10:	89 d6                	mov    %edx,%esi
  800e12:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e14:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e1a:	75 13                	jne    800e2f <memmove+0x3b>
  800e1c:	f6 c1 03             	test   $0x3,%cl
  800e1f:	75 0e                	jne    800e2f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e21:	83 ef 04             	sub    $0x4,%edi
  800e24:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e27:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800e2a:	fd                   	std    
  800e2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e2d:	eb 09                	jmp    800e38 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e2f:	83 ef 01             	sub    $0x1,%edi
  800e32:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800e35:	fd                   	std    
  800e36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e38:	fc                   	cld    
  800e39:	eb 1d                	jmp    800e58 <memmove+0x64>
  800e3b:	89 f2                	mov    %esi,%edx
  800e3d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e3f:	f6 c2 03             	test   $0x3,%dl
  800e42:	75 0f                	jne    800e53 <memmove+0x5f>
  800e44:	f6 c1 03             	test   $0x3,%cl
  800e47:	75 0a                	jne    800e53 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e49:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800e4c:	89 c7                	mov    %eax,%edi
  800e4e:	fc                   	cld    
  800e4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e51:	eb 05                	jmp    800e58 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800e53:	89 c7                	mov    %eax,%edi
  800e55:	fc                   	cld    
  800e56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e58:	5e                   	pop    %esi
  800e59:	5f                   	pop    %edi
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    

00800e5c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e62:	8b 45 10             	mov    0x10(%ebp),%eax
  800e65:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	89 04 24             	mov    %eax,(%esp)
  800e76:	e8 79 ff ff ff       	call   800df4 <memmove>
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	56                   	push   %esi
  800e81:	53                   	push   %ebx
  800e82:	8b 55 08             	mov    0x8(%ebp),%edx
  800e85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e88:	89 d6                	mov    %edx,%esi
  800e8a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e8d:	eb 1a                	jmp    800ea9 <memcmp+0x2c>
		if (*s1 != *s2)
  800e8f:	0f b6 02             	movzbl (%edx),%eax
  800e92:	0f b6 19             	movzbl (%ecx),%ebx
  800e95:	38 d8                	cmp    %bl,%al
  800e97:	74 0a                	je     800ea3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800e99:	0f b6 c0             	movzbl %al,%eax
  800e9c:	0f b6 db             	movzbl %bl,%ebx
  800e9f:	29 d8                	sub    %ebx,%eax
  800ea1:	eb 0f                	jmp    800eb2 <memcmp+0x35>
		s1++, s2++;
  800ea3:	83 c2 01             	add    $0x1,%edx
  800ea6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ea9:	39 f2                	cmp    %esi,%edx
  800eab:	75 e2                	jne    800e8f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ead:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb2:	5b                   	pop    %ebx
  800eb3:	5e                   	pop    %esi
  800eb4:	5d                   	pop    %ebp
  800eb5:	c3                   	ret    

00800eb6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ebf:	89 c2                	mov    %eax,%edx
  800ec1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ec4:	eb 07                	jmp    800ecd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ec6:	38 08                	cmp    %cl,(%eax)
  800ec8:	74 07                	je     800ed1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eca:	83 c0 01             	add    $0x1,%eax
  800ecd:	39 d0                	cmp    %edx,%eax
  800ecf:	72 f5                	jb     800ec6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	57                   	push   %edi
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
  800ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  800edc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800edf:	eb 03                	jmp    800ee4 <strtol+0x11>
		s++;
  800ee1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ee4:	0f b6 0a             	movzbl (%edx),%ecx
  800ee7:	80 f9 09             	cmp    $0x9,%cl
  800eea:	74 f5                	je     800ee1 <strtol+0xe>
  800eec:	80 f9 20             	cmp    $0x20,%cl
  800eef:	74 f0                	je     800ee1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ef1:	80 f9 2b             	cmp    $0x2b,%cl
  800ef4:	75 0a                	jne    800f00 <strtol+0x2d>
		s++;
  800ef6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ef9:	bf 00 00 00 00       	mov    $0x0,%edi
  800efe:	eb 11                	jmp    800f11 <strtol+0x3e>
  800f00:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800f05:	80 f9 2d             	cmp    $0x2d,%cl
  800f08:	75 07                	jne    800f11 <strtol+0x3e>
		s++, neg = 1;
  800f0a:	8d 52 01             	lea    0x1(%edx),%edx
  800f0d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f11:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800f16:	75 15                	jne    800f2d <strtol+0x5a>
  800f18:	80 3a 30             	cmpb   $0x30,(%edx)
  800f1b:	75 10                	jne    800f2d <strtol+0x5a>
  800f1d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800f21:	75 0a                	jne    800f2d <strtol+0x5a>
		s += 2, base = 16;
  800f23:	83 c2 02             	add    $0x2,%edx
  800f26:	b8 10 00 00 00       	mov    $0x10,%eax
  800f2b:	eb 10                	jmp    800f3d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800f2d:	85 c0                	test   %eax,%eax
  800f2f:	75 0c                	jne    800f3d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f31:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f33:	80 3a 30             	cmpb   $0x30,(%edx)
  800f36:	75 05                	jne    800f3d <strtol+0x6a>
		s++, base = 8;
  800f38:	83 c2 01             	add    $0x1,%edx
  800f3b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800f3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f42:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f45:	0f b6 0a             	movzbl (%edx),%ecx
  800f48:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800f4b:	89 f0                	mov    %esi,%eax
  800f4d:	3c 09                	cmp    $0x9,%al
  800f4f:	77 08                	ja     800f59 <strtol+0x86>
			dig = *s - '0';
  800f51:	0f be c9             	movsbl %cl,%ecx
  800f54:	83 e9 30             	sub    $0x30,%ecx
  800f57:	eb 20                	jmp    800f79 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800f59:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800f5c:	89 f0                	mov    %esi,%eax
  800f5e:	3c 19                	cmp    $0x19,%al
  800f60:	77 08                	ja     800f6a <strtol+0x97>
			dig = *s - 'a' + 10;
  800f62:	0f be c9             	movsbl %cl,%ecx
  800f65:	83 e9 57             	sub    $0x57,%ecx
  800f68:	eb 0f                	jmp    800f79 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800f6a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800f6d:	89 f0                	mov    %esi,%eax
  800f6f:	3c 19                	cmp    $0x19,%al
  800f71:	77 16                	ja     800f89 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800f73:	0f be c9             	movsbl %cl,%ecx
  800f76:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f79:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800f7c:	7d 0f                	jge    800f8d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800f7e:	83 c2 01             	add    $0x1,%edx
  800f81:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800f85:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800f87:	eb bc                	jmp    800f45 <strtol+0x72>
  800f89:	89 d8                	mov    %ebx,%eax
  800f8b:	eb 02                	jmp    800f8f <strtol+0xbc>
  800f8d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800f8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f93:	74 05                	je     800f9a <strtol+0xc7>
		*endptr = (char *) s;
  800f95:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f98:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800f9a:	f7 d8                	neg    %eax
  800f9c:	85 ff                	test   %edi,%edi
  800f9e:	0f 44 c3             	cmove  %ebx,%eax
}
  800fa1:	5b                   	pop    %ebx
  800fa2:	5e                   	pop    %esi
  800fa3:	5f                   	pop    %edi
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    

00800fa6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	57                   	push   %edi
  800faa:	56                   	push   %esi
  800fab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fac:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb7:	89 c3                	mov    %eax,%ebx
  800fb9:	89 c7                	mov    %eax,%edi
  800fbb:	89 c6                	mov    %eax,%esi
  800fbd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800fbf:	5b                   	pop    %ebx
  800fc0:	5e                   	pop    %esi
  800fc1:	5f                   	pop    %edi
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    

00800fc4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
  800fc7:	57                   	push   %edi
  800fc8:	56                   	push   %esi
  800fc9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fca:	ba 00 00 00 00       	mov    $0x0,%edx
  800fcf:	b8 01 00 00 00       	mov    $0x1,%eax
  800fd4:	89 d1                	mov    %edx,%ecx
  800fd6:	89 d3                	mov    %edx,%ebx
  800fd8:	89 d7                	mov    %edx,%edi
  800fda:	89 d6                	mov    %edx,%esi
  800fdc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fde:	5b                   	pop    %ebx
  800fdf:	5e                   	pop    %esi
  800fe0:	5f                   	pop    %edi
  800fe1:	5d                   	pop    %ebp
  800fe2:	c3                   	ret    

00800fe3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fe3:	55                   	push   %ebp
  800fe4:	89 e5                	mov    %esp,%ebp
  800fe6:	57                   	push   %edi
  800fe7:	56                   	push   %esi
  800fe8:	53                   	push   %ebx
  800fe9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fec:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff1:	b8 03 00 00 00       	mov    $0x3,%eax
  800ff6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff9:	89 cb                	mov    %ecx,%ebx
  800ffb:	89 cf                	mov    %ecx,%edi
  800ffd:	89 ce                	mov    %ecx,%esi
  800fff:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801001:	85 c0                	test   %eax,%eax
  801003:	7e 28                	jle    80102d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801005:	89 44 24 10          	mov    %eax,0x10(%esp)
  801009:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801010:	00 
  801011:	c7 44 24 08 87 2f 80 	movl   $0x802f87,0x8(%esp)
  801018:	00 
  801019:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801020:	00 
  801021:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  801028:	e8 a9 16 00 00       	call   8026d6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80102d:	83 c4 2c             	add    $0x2c,%esp
  801030:	5b                   	pop    %ebx
  801031:	5e                   	pop    %esi
  801032:	5f                   	pop    %edi
  801033:	5d                   	pop    %ebp
  801034:	c3                   	ret    

00801035 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	57                   	push   %edi
  801039:	56                   	push   %esi
  80103a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80103b:	ba 00 00 00 00       	mov    $0x0,%edx
  801040:	b8 02 00 00 00       	mov    $0x2,%eax
  801045:	89 d1                	mov    %edx,%ecx
  801047:	89 d3                	mov    %edx,%ebx
  801049:	89 d7                	mov    %edx,%edi
  80104b:	89 d6                	mov    %edx,%esi
  80104d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80104f:	5b                   	pop    %ebx
  801050:	5e                   	pop    %esi
  801051:	5f                   	pop    %edi
  801052:	5d                   	pop    %ebp
  801053:	c3                   	ret    

00801054 <sys_yield>:

void
sys_yield(void)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	57                   	push   %edi
  801058:	56                   	push   %esi
  801059:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105a:	ba 00 00 00 00       	mov    $0x0,%edx
  80105f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801064:	89 d1                	mov    %edx,%ecx
  801066:	89 d3                	mov    %edx,%ebx
  801068:	89 d7                	mov    %edx,%edi
  80106a:	89 d6                	mov    %edx,%esi
  80106c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80106e:	5b                   	pop    %ebx
  80106f:	5e                   	pop    %esi
  801070:	5f                   	pop    %edi
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	57                   	push   %edi
  801077:	56                   	push   %esi
  801078:	53                   	push   %ebx
  801079:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80107c:	be 00 00 00 00       	mov    $0x0,%esi
  801081:	b8 04 00 00 00       	mov    $0x4,%eax
  801086:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801089:	8b 55 08             	mov    0x8(%ebp),%edx
  80108c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80108f:	89 f7                	mov    %esi,%edi
  801091:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801093:	85 c0                	test   %eax,%eax
  801095:	7e 28                	jle    8010bf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801097:	89 44 24 10          	mov    %eax,0x10(%esp)
  80109b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8010a2:	00 
  8010a3:	c7 44 24 08 87 2f 80 	movl   $0x802f87,0x8(%esp)
  8010aa:	00 
  8010ab:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b2:	00 
  8010b3:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  8010ba:	e8 17 16 00 00       	call   8026d6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010bf:	83 c4 2c             	add    $0x2c,%esp
  8010c2:	5b                   	pop    %ebx
  8010c3:	5e                   	pop    %esi
  8010c4:	5f                   	pop    %edi
  8010c5:	5d                   	pop    %ebp
  8010c6:	c3                   	ret    

008010c7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	57                   	push   %edi
  8010cb:	56                   	push   %esi
  8010cc:	53                   	push   %ebx
  8010cd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d0:	b8 05 00 00 00       	mov    $0x5,%eax
  8010d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010db:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010de:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010e1:	8b 75 18             	mov    0x18(%ebp),%esi
  8010e4:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	7e 28                	jle    801112 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ea:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ee:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8010f5:	00 
  8010f6:	c7 44 24 08 87 2f 80 	movl   $0x802f87,0x8(%esp)
  8010fd:	00 
  8010fe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801105:	00 
  801106:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  80110d:	e8 c4 15 00 00       	call   8026d6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801112:	83 c4 2c             	add    $0x2c,%esp
  801115:	5b                   	pop    %ebx
  801116:	5e                   	pop    %esi
  801117:	5f                   	pop    %edi
  801118:	5d                   	pop    %ebp
  801119:	c3                   	ret    

0080111a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	57                   	push   %edi
  80111e:	56                   	push   %esi
  80111f:	53                   	push   %ebx
  801120:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801123:	bb 00 00 00 00       	mov    $0x0,%ebx
  801128:	b8 06 00 00 00       	mov    $0x6,%eax
  80112d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801130:	8b 55 08             	mov    0x8(%ebp),%edx
  801133:	89 df                	mov    %ebx,%edi
  801135:	89 de                	mov    %ebx,%esi
  801137:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801139:	85 c0                	test   %eax,%eax
  80113b:	7e 28                	jle    801165 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80113d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801141:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801148:	00 
  801149:	c7 44 24 08 87 2f 80 	movl   $0x802f87,0x8(%esp)
  801150:	00 
  801151:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801158:	00 
  801159:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  801160:	e8 71 15 00 00       	call   8026d6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801165:	83 c4 2c             	add    $0x2c,%esp
  801168:	5b                   	pop    %ebx
  801169:	5e                   	pop    %esi
  80116a:	5f                   	pop    %edi
  80116b:	5d                   	pop    %ebp
  80116c:	c3                   	ret    

0080116d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
  801170:	57                   	push   %edi
  801171:	56                   	push   %esi
  801172:	53                   	push   %ebx
  801173:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801176:	bb 00 00 00 00       	mov    $0x0,%ebx
  80117b:	b8 08 00 00 00       	mov    $0x8,%eax
  801180:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801183:	8b 55 08             	mov    0x8(%ebp),%edx
  801186:	89 df                	mov    %ebx,%edi
  801188:	89 de                	mov    %ebx,%esi
  80118a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80118c:	85 c0                	test   %eax,%eax
  80118e:	7e 28                	jle    8011b8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801190:	89 44 24 10          	mov    %eax,0x10(%esp)
  801194:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80119b:	00 
  80119c:	c7 44 24 08 87 2f 80 	movl   $0x802f87,0x8(%esp)
  8011a3:	00 
  8011a4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011ab:	00 
  8011ac:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  8011b3:	e8 1e 15 00 00       	call   8026d6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011b8:	83 c4 2c             	add    $0x2c,%esp
  8011bb:	5b                   	pop    %ebx
  8011bc:	5e                   	pop    %esi
  8011bd:	5f                   	pop    %edi
  8011be:	5d                   	pop    %ebp
  8011bf:	c3                   	ret    

008011c0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	57                   	push   %edi
  8011c4:	56                   	push   %esi
  8011c5:	53                   	push   %ebx
  8011c6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ce:	b8 09 00 00 00       	mov    $0x9,%eax
  8011d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d9:	89 df                	mov    %ebx,%edi
  8011db:	89 de                	mov    %ebx,%esi
  8011dd:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	7e 28                	jle    80120b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011e3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011e7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8011ee:	00 
  8011ef:	c7 44 24 08 87 2f 80 	movl   $0x802f87,0x8(%esp)
  8011f6:	00 
  8011f7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011fe:	00 
  8011ff:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  801206:	e8 cb 14 00 00       	call   8026d6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80120b:	83 c4 2c             	add    $0x2c,%esp
  80120e:	5b                   	pop    %ebx
  80120f:	5e                   	pop    %esi
  801210:	5f                   	pop    %edi
  801211:	5d                   	pop    %ebp
  801212:	c3                   	ret    

00801213 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	57                   	push   %edi
  801217:	56                   	push   %esi
  801218:	53                   	push   %ebx
  801219:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80121c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801221:	b8 0a 00 00 00       	mov    $0xa,%eax
  801226:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801229:	8b 55 08             	mov    0x8(%ebp),%edx
  80122c:	89 df                	mov    %ebx,%edi
  80122e:	89 de                	mov    %ebx,%esi
  801230:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801232:	85 c0                	test   %eax,%eax
  801234:	7e 28                	jle    80125e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801236:	89 44 24 10          	mov    %eax,0x10(%esp)
  80123a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801241:	00 
  801242:	c7 44 24 08 87 2f 80 	movl   $0x802f87,0x8(%esp)
  801249:	00 
  80124a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801251:	00 
  801252:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  801259:	e8 78 14 00 00       	call   8026d6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80125e:	83 c4 2c             	add    $0x2c,%esp
  801261:	5b                   	pop    %ebx
  801262:	5e                   	pop    %esi
  801263:	5f                   	pop    %edi
  801264:	5d                   	pop    %ebp
  801265:	c3                   	ret    

00801266 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	57                   	push   %edi
  80126a:	56                   	push   %esi
  80126b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80126c:	be 00 00 00 00       	mov    $0x0,%esi
  801271:	b8 0c 00 00 00       	mov    $0xc,%eax
  801276:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801279:	8b 55 08             	mov    0x8(%ebp),%edx
  80127c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80127f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801282:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801284:	5b                   	pop    %ebx
  801285:	5e                   	pop    %esi
  801286:	5f                   	pop    %edi
  801287:	5d                   	pop    %ebp
  801288:	c3                   	ret    

00801289 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
  80128c:	57                   	push   %edi
  80128d:	56                   	push   %esi
  80128e:	53                   	push   %ebx
  80128f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801292:	b9 00 00 00 00       	mov    $0x0,%ecx
  801297:	b8 0d 00 00 00       	mov    $0xd,%eax
  80129c:	8b 55 08             	mov    0x8(%ebp),%edx
  80129f:	89 cb                	mov    %ecx,%ebx
  8012a1:	89 cf                	mov    %ecx,%edi
  8012a3:	89 ce                	mov    %ecx,%esi
  8012a5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8012a7:	85 c0                	test   %eax,%eax
  8012a9:	7e 28                	jle    8012d3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012ab:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012af:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8012b6:	00 
  8012b7:	c7 44 24 08 87 2f 80 	movl   $0x802f87,0x8(%esp)
  8012be:	00 
  8012bf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012c6:	00 
  8012c7:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  8012ce:	e8 03 14 00 00       	call   8026d6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012d3:	83 c4 2c             	add    $0x2c,%esp
  8012d6:	5b                   	pop    %ebx
  8012d7:	5e                   	pop    %esi
  8012d8:	5f                   	pop    %edi
  8012d9:	5d                   	pop    %ebp
  8012da:	c3                   	ret    

008012db <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	57                   	push   %edi
  8012df:	56                   	push   %esi
  8012e0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8012e6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012eb:	89 d1                	mov    %edx,%ecx
  8012ed:	89 d3                	mov    %edx,%ebx
  8012ef:	89 d7                	mov    %edx,%edi
  8012f1:	89 d6                	mov    %edx,%esi
  8012f3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8012f5:	5b                   	pop    %ebx
  8012f6:	5e                   	pop    %esi
  8012f7:	5f                   	pop    %edi
  8012f8:	5d                   	pop    %ebp
  8012f9:	c3                   	ret    

008012fa <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
  8012fd:	57                   	push   %edi
  8012fe:	56                   	push   %esi
  8012ff:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801300:	bb 00 00 00 00       	mov    $0x0,%ebx
  801305:	b8 0f 00 00 00       	mov    $0xf,%eax
  80130a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80130d:	8b 55 08             	mov    0x8(%ebp),%edx
  801310:	89 df                	mov    %ebx,%edi
  801312:	89 de                	mov    %ebx,%esi
  801314:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  801316:	5b                   	pop    %ebx
  801317:	5e                   	pop    %esi
  801318:	5f                   	pop    %edi
  801319:	5d                   	pop    %ebp
  80131a:	c3                   	ret    

0080131b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	57                   	push   %edi
  80131f:	56                   	push   %esi
  801320:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801321:	bb 00 00 00 00       	mov    $0x0,%ebx
  801326:	b8 10 00 00 00       	mov    $0x10,%eax
  80132b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80132e:	8b 55 08             	mov    0x8(%ebp),%edx
  801331:	89 df                	mov    %ebx,%edi
  801333:	89 de                	mov    %ebx,%esi
  801335:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  801337:	5b                   	pop    %ebx
  801338:	5e                   	pop    %esi
  801339:	5f                   	pop    %edi
  80133a:	5d                   	pop    %ebp
  80133b:	c3                   	ret    

0080133c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	57                   	push   %edi
  801340:	56                   	push   %esi
  801341:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801342:	b9 00 00 00 00       	mov    $0x0,%ecx
  801347:	b8 11 00 00 00       	mov    $0x11,%eax
  80134c:	8b 55 08             	mov    0x8(%ebp),%edx
  80134f:	89 cb                	mov    %ecx,%ebx
  801351:	89 cf                	mov    %ecx,%edi
  801353:	89 ce                	mov    %ecx,%esi
  801355:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  801357:	5b                   	pop    %ebx
  801358:	5e                   	pop    %esi
  801359:	5f                   	pop    %edi
  80135a:	5d                   	pop    %ebp
  80135b:	c3                   	ret    

0080135c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	57                   	push   %edi
  801360:	56                   	push   %esi
  801361:	53                   	push   %ebx
  801362:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801365:	be 00 00 00 00       	mov    $0x0,%esi
  80136a:	b8 12 00 00 00       	mov    $0x12,%eax
  80136f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801372:	8b 55 08             	mov    0x8(%ebp),%edx
  801375:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801378:	8b 7d 14             	mov    0x14(%ebp),%edi
  80137b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80137d:	85 c0                	test   %eax,%eax
  80137f:	7e 28                	jle    8013a9 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  801381:	89 44 24 10          	mov    %eax,0x10(%esp)
  801385:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  80138c:	00 
  80138d:	c7 44 24 08 87 2f 80 	movl   $0x802f87,0x8(%esp)
  801394:	00 
  801395:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80139c:	00 
  80139d:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  8013a4:	e8 2d 13 00 00       	call   8026d6 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  8013a9:	83 c4 2c             	add    $0x2c,%esp
  8013ac:	5b                   	pop    %ebx
  8013ad:	5e                   	pop    %esi
  8013ae:	5f                   	pop    %edi
  8013af:	5d                   	pop    %ebp
  8013b0:	c3                   	ret    
  8013b1:	66 90                	xchg   %ax,%ax
  8013b3:	66 90                	xchg   %ax,%ax
  8013b5:	66 90                	xchg   %ax,%ax
  8013b7:	66 90                	xchg   %ax,%ax
  8013b9:	66 90                	xchg   %ax,%ax
  8013bb:	66 90                	xchg   %ax,%ax
  8013bd:	66 90                	xchg   %ax,%ax
  8013bf:	90                   	nop

008013c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	05 00 00 00 30       	add    $0x30000000,%eax
  8013cb:	c1 e8 0c             	shr    $0xc,%eax
}
  8013ce:	5d                   	pop    %ebp
  8013cf:	c3                   	ret    

008013d0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8013db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013e0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013e5:	5d                   	pop    %ebp
  8013e6:	c3                   	ret    

008013e7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013ed:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013f2:	89 c2                	mov    %eax,%edx
  8013f4:	c1 ea 16             	shr    $0x16,%edx
  8013f7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013fe:	f6 c2 01             	test   $0x1,%dl
  801401:	74 11                	je     801414 <fd_alloc+0x2d>
  801403:	89 c2                	mov    %eax,%edx
  801405:	c1 ea 0c             	shr    $0xc,%edx
  801408:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80140f:	f6 c2 01             	test   $0x1,%dl
  801412:	75 09                	jne    80141d <fd_alloc+0x36>
			*fd_store = fd;
  801414:	89 01                	mov    %eax,(%ecx)
			return 0;
  801416:	b8 00 00 00 00       	mov    $0x0,%eax
  80141b:	eb 17                	jmp    801434 <fd_alloc+0x4d>
  80141d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801422:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801427:	75 c9                	jne    8013f2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801429:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80142f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801434:	5d                   	pop    %ebp
  801435:	c3                   	ret    

00801436 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80143c:	83 f8 1f             	cmp    $0x1f,%eax
  80143f:	77 36                	ja     801477 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801441:	c1 e0 0c             	shl    $0xc,%eax
  801444:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801449:	89 c2                	mov    %eax,%edx
  80144b:	c1 ea 16             	shr    $0x16,%edx
  80144e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801455:	f6 c2 01             	test   $0x1,%dl
  801458:	74 24                	je     80147e <fd_lookup+0x48>
  80145a:	89 c2                	mov    %eax,%edx
  80145c:	c1 ea 0c             	shr    $0xc,%edx
  80145f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801466:	f6 c2 01             	test   $0x1,%dl
  801469:	74 1a                	je     801485 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80146b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146e:	89 02                	mov    %eax,(%edx)
	return 0;
  801470:	b8 00 00 00 00       	mov    $0x0,%eax
  801475:	eb 13                	jmp    80148a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801477:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80147c:	eb 0c                	jmp    80148a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80147e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801483:	eb 05                	jmp    80148a <fd_lookup+0x54>
  801485:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80148a:	5d                   	pop    %ebp
  80148b:	c3                   	ret    

0080148c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 18             	sub    $0x18,%esp
  801492:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801495:	ba 00 00 00 00       	mov    $0x0,%edx
  80149a:	eb 13                	jmp    8014af <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80149c:	39 08                	cmp    %ecx,(%eax)
  80149e:	75 0c                	jne    8014ac <dev_lookup+0x20>
			*dev = devtab[i];
  8014a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014aa:	eb 38                	jmp    8014e4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8014ac:	83 c2 01             	add    $0x1,%edx
  8014af:	8b 04 95 30 30 80 00 	mov    0x803030(,%edx,4),%eax
  8014b6:	85 c0                	test   %eax,%eax
  8014b8:	75 e2                	jne    80149c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014ba:	a1 18 50 80 00       	mov    0x805018,%eax
  8014bf:	8b 40 48             	mov    0x48(%eax),%eax
  8014c2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ca:	c7 04 24 b4 2f 80 00 	movl   $0x802fb4,(%esp)
  8014d1:	e8 5b f1 ff ff       	call   800631 <cprintf>
	*dev = 0;
  8014d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	56                   	push   %esi
  8014ea:	53                   	push   %ebx
  8014eb:	83 ec 20             	sub    $0x20,%esp
  8014ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8014f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014fb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801501:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801504:	89 04 24             	mov    %eax,(%esp)
  801507:	e8 2a ff ff ff       	call   801436 <fd_lookup>
  80150c:	85 c0                	test   %eax,%eax
  80150e:	78 05                	js     801515 <fd_close+0x2f>
	    || fd != fd2)
  801510:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801513:	74 0c                	je     801521 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801515:	84 db                	test   %bl,%bl
  801517:	ba 00 00 00 00       	mov    $0x0,%edx
  80151c:	0f 44 c2             	cmove  %edx,%eax
  80151f:	eb 3f                	jmp    801560 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801521:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801524:	89 44 24 04          	mov    %eax,0x4(%esp)
  801528:	8b 06                	mov    (%esi),%eax
  80152a:	89 04 24             	mov    %eax,(%esp)
  80152d:	e8 5a ff ff ff       	call   80148c <dev_lookup>
  801532:	89 c3                	mov    %eax,%ebx
  801534:	85 c0                	test   %eax,%eax
  801536:	78 16                	js     80154e <fd_close+0x68>
		if (dev->dev_close)
  801538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80153e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801543:	85 c0                	test   %eax,%eax
  801545:	74 07                	je     80154e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801547:	89 34 24             	mov    %esi,(%esp)
  80154a:	ff d0                	call   *%eax
  80154c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80154e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801552:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801559:	e8 bc fb ff ff       	call   80111a <sys_page_unmap>
	return r;
  80155e:	89 d8                	mov    %ebx,%eax
}
  801560:	83 c4 20             	add    $0x20,%esp
  801563:	5b                   	pop    %ebx
  801564:	5e                   	pop    %esi
  801565:	5d                   	pop    %ebp
  801566:	c3                   	ret    

00801567 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
  80156a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80156d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801570:	89 44 24 04          	mov    %eax,0x4(%esp)
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	89 04 24             	mov    %eax,(%esp)
  80157a:	e8 b7 fe ff ff       	call   801436 <fd_lookup>
  80157f:	89 c2                	mov    %eax,%edx
  801581:	85 d2                	test   %edx,%edx
  801583:	78 13                	js     801598 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801585:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80158c:	00 
  80158d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801590:	89 04 24             	mov    %eax,(%esp)
  801593:	e8 4e ff ff ff       	call   8014e6 <fd_close>
}
  801598:	c9                   	leave  
  801599:	c3                   	ret    

0080159a <close_all>:

void
close_all(void)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	53                   	push   %ebx
  80159e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015a1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015a6:	89 1c 24             	mov    %ebx,(%esp)
  8015a9:	e8 b9 ff ff ff       	call   801567 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8015ae:	83 c3 01             	add    $0x1,%ebx
  8015b1:	83 fb 20             	cmp    $0x20,%ebx
  8015b4:	75 f0                	jne    8015a6 <close_all+0xc>
		close(i);
}
  8015b6:	83 c4 14             	add    $0x14,%esp
  8015b9:	5b                   	pop    %ebx
  8015ba:	5d                   	pop    %ebp
  8015bb:	c3                   	ret    

008015bc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	57                   	push   %edi
  8015c0:	56                   	push   %esi
  8015c1:	53                   	push   %ebx
  8015c2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cf:	89 04 24             	mov    %eax,(%esp)
  8015d2:	e8 5f fe ff ff       	call   801436 <fd_lookup>
  8015d7:	89 c2                	mov    %eax,%edx
  8015d9:	85 d2                	test   %edx,%edx
  8015db:	0f 88 e1 00 00 00    	js     8016c2 <dup+0x106>
		return r;
	close(newfdnum);
  8015e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e4:	89 04 24             	mov    %eax,(%esp)
  8015e7:	e8 7b ff ff ff       	call   801567 <close>

	newfd = INDEX2FD(newfdnum);
  8015ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8015ef:	c1 e3 0c             	shl    $0xc,%ebx
  8015f2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8015f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015fb:	89 04 24             	mov    %eax,(%esp)
  8015fe:	e8 cd fd ff ff       	call   8013d0 <fd2data>
  801603:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801605:	89 1c 24             	mov    %ebx,(%esp)
  801608:	e8 c3 fd ff ff       	call   8013d0 <fd2data>
  80160d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80160f:	89 f0                	mov    %esi,%eax
  801611:	c1 e8 16             	shr    $0x16,%eax
  801614:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80161b:	a8 01                	test   $0x1,%al
  80161d:	74 43                	je     801662 <dup+0xa6>
  80161f:	89 f0                	mov    %esi,%eax
  801621:	c1 e8 0c             	shr    $0xc,%eax
  801624:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80162b:	f6 c2 01             	test   $0x1,%dl
  80162e:	74 32                	je     801662 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801630:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801637:	25 07 0e 00 00       	and    $0xe07,%eax
  80163c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801640:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801644:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80164b:	00 
  80164c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801650:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801657:	e8 6b fa ff ff       	call   8010c7 <sys_page_map>
  80165c:	89 c6                	mov    %eax,%esi
  80165e:	85 c0                	test   %eax,%eax
  801660:	78 3e                	js     8016a0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801665:	89 c2                	mov    %eax,%edx
  801667:	c1 ea 0c             	shr    $0xc,%edx
  80166a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801671:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801677:	89 54 24 10          	mov    %edx,0x10(%esp)
  80167b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80167f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801686:	00 
  801687:	89 44 24 04          	mov    %eax,0x4(%esp)
  80168b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801692:	e8 30 fa ff ff       	call   8010c7 <sys_page_map>
  801697:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801699:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80169c:	85 f6                	test   %esi,%esi
  80169e:	79 22                	jns    8016c2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8016a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016ab:	e8 6a fa ff ff       	call   80111a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016bb:	e8 5a fa ff ff       	call   80111a <sys_page_unmap>
	return r;
  8016c0:	89 f0                	mov    %esi,%eax
}
  8016c2:	83 c4 3c             	add    $0x3c,%esp
  8016c5:	5b                   	pop    %ebx
  8016c6:	5e                   	pop    %esi
  8016c7:	5f                   	pop    %edi
  8016c8:	5d                   	pop    %ebp
  8016c9:	c3                   	ret    

008016ca <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	53                   	push   %ebx
  8016ce:	83 ec 24             	sub    $0x24,%esp
  8016d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016db:	89 1c 24             	mov    %ebx,(%esp)
  8016de:	e8 53 fd ff ff       	call   801436 <fd_lookup>
  8016e3:	89 c2                	mov    %eax,%edx
  8016e5:	85 d2                	test   %edx,%edx
  8016e7:	78 6d                	js     801756 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f3:	8b 00                	mov    (%eax),%eax
  8016f5:	89 04 24             	mov    %eax,(%esp)
  8016f8:	e8 8f fd ff ff       	call   80148c <dev_lookup>
  8016fd:	85 c0                	test   %eax,%eax
  8016ff:	78 55                	js     801756 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801704:	8b 50 08             	mov    0x8(%eax),%edx
  801707:	83 e2 03             	and    $0x3,%edx
  80170a:	83 fa 01             	cmp    $0x1,%edx
  80170d:	75 23                	jne    801732 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80170f:	a1 18 50 80 00       	mov    0x805018,%eax
  801714:	8b 40 48             	mov    0x48(%eax),%eax
  801717:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80171b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171f:	c7 04 24 f5 2f 80 00 	movl   $0x802ff5,(%esp)
  801726:	e8 06 ef ff ff       	call   800631 <cprintf>
		return -E_INVAL;
  80172b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801730:	eb 24                	jmp    801756 <read+0x8c>
	}
	if (!dev->dev_read)
  801732:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801735:	8b 52 08             	mov    0x8(%edx),%edx
  801738:	85 d2                	test   %edx,%edx
  80173a:	74 15                	je     801751 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80173c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801743:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801746:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80174a:	89 04 24             	mov    %eax,(%esp)
  80174d:	ff d2                	call   *%edx
  80174f:	eb 05                	jmp    801756 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801751:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801756:	83 c4 24             	add    $0x24,%esp
  801759:	5b                   	pop    %ebx
  80175a:	5d                   	pop    %ebp
  80175b:	c3                   	ret    

0080175c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	57                   	push   %edi
  801760:	56                   	push   %esi
  801761:	53                   	push   %ebx
  801762:	83 ec 1c             	sub    $0x1c,%esp
  801765:	8b 7d 08             	mov    0x8(%ebp),%edi
  801768:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80176b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801770:	eb 23                	jmp    801795 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801772:	89 f0                	mov    %esi,%eax
  801774:	29 d8                	sub    %ebx,%eax
  801776:	89 44 24 08          	mov    %eax,0x8(%esp)
  80177a:	89 d8                	mov    %ebx,%eax
  80177c:	03 45 0c             	add    0xc(%ebp),%eax
  80177f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801783:	89 3c 24             	mov    %edi,(%esp)
  801786:	e8 3f ff ff ff       	call   8016ca <read>
		if (m < 0)
  80178b:	85 c0                	test   %eax,%eax
  80178d:	78 10                	js     80179f <readn+0x43>
			return m;
		if (m == 0)
  80178f:	85 c0                	test   %eax,%eax
  801791:	74 0a                	je     80179d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801793:	01 c3                	add    %eax,%ebx
  801795:	39 f3                	cmp    %esi,%ebx
  801797:	72 d9                	jb     801772 <readn+0x16>
  801799:	89 d8                	mov    %ebx,%eax
  80179b:	eb 02                	jmp    80179f <readn+0x43>
  80179d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80179f:	83 c4 1c             	add    $0x1c,%esp
  8017a2:	5b                   	pop    %ebx
  8017a3:	5e                   	pop    %esi
  8017a4:	5f                   	pop    %edi
  8017a5:	5d                   	pop    %ebp
  8017a6:	c3                   	ret    

008017a7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	53                   	push   %ebx
  8017ab:	83 ec 24             	sub    $0x24,%esp
  8017ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b8:	89 1c 24             	mov    %ebx,(%esp)
  8017bb:	e8 76 fc ff ff       	call   801436 <fd_lookup>
  8017c0:	89 c2                	mov    %eax,%edx
  8017c2:	85 d2                	test   %edx,%edx
  8017c4:	78 68                	js     80182e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d0:	8b 00                	mov    (%eax),%eax
  8017d2:	89 04 24             	mov    %eax,(%esp)
  8017d5:	e8 b2 fc ff ff       	call   80148c <dev_lookup>
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	78 50                	js     80182e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017e5:	75 23                	jne    80180a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017e7:	a1 18 50 80 00       	mov    0x805018,%eax
  8017ec:	8b 40 48             	mov    0x48(%eax),%eax
  8017ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f7:	c7 04 24 11 30 80 00 	movl   $0x803011,(%esp)
  8017fe:	e8 2e ee ff ff       	call   800631 <cprintf>
		return -E_INVAL;
  801803:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801808:	eb 24                	jmp    80182e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80180a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80180d:	8b 52 0c             	mov    0xc(%edx),%edx
  801810:	85 d2                	test   %edx,%edx
  801812:	74 15                	je     801829 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801814:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801817:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80181b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80181e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801822:	89 04 24             	mov    %eax,(%esp)
  801825:	ff d2                	call   *%edx
  801827:	eb 05                	jmp    80182e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801829:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80182e:	83 c4 24             	add    $0x24,%esp
  801831:	5b                   	pop    %ebx
  801832:	5d                   	pop    %ebp
  801833:	c3                   	ret    

00801834 <seek>:

int
seek(int fdnum, off_t offset)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80183a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80183d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	89 04 24             	mov    %eax,(%esp)
  801847:	e8 ea fb ff ff       	call   801436 <fd_lookup>
  80184c:	85 c0                	test   %eax,%eax
  80184e:	78 0e                	js     80185e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801850:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801853:	8b 55 0c             	mov    0xc(%ebp),%edx
  801856:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801859:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	53                   	push   %ebx
  801864:	83 ec 24             	sub    $0x24,%esp
  801867:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80186a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80186d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801871:	89 1c 24             	mov    %ebx,(%esp)
  801874:	e8 bd fb ff ff       	call   801436 <fd_lookup>
  801879:	89 c2                	mov    %eax,%edx
  80187b:	85 d2                	test   %edx,%edx
  80187d:	78 61                	js     8018e0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80187f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801882:	89 44 24 04          	mov    %eax,0x4(%esp)
  801886:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801889:	8b 00                	mov    (%eax),%eax
  80188b:	89 04 24             	mov    %eax,(%esp)
  80188e:	e8 f9 fb ff ff       	call   80148c <dev_lookup>
  801893:	85 c0                	test   %eax,%eax
  801895:	78 49                	js     8018e0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801897:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80189e:	75 23                	jne    8018c3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8018a0:	a1 18 50 80 00       	mov    0x805018,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018a5:	8b 40 48             	mov    0x48(%eax),%eax
  8018a8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b0:	c7 04 24 d4 2f 80 00 	movl   $0x802fd4,(%esp)
  8018b7:	e8 75 ed ff ff       	call   800631 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8018bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018c1:	eb 1d                	jmp    8018e0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8018c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c6:	8b 52 18             	mov    0x18(%edx),%edx
  8018c9:	85 d2                	test   %edx,%edx
  8018cb:	74 0e                	je     8018db <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018d0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018d4:	89 04 24             	mov    %eax,(%esp)
  8018d7:	ff d2                	call   *%edx
  8018d9:	eb 05                	jmp    8018e0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8018db:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8018e0:	83 c4 24             	add    $0x24,%esp
  8018e3:	5b                   	pop    %ebx
  8018e4:	5d                   	pop    %ebp
  8018e5:	c3                   	ret    

008018e6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	53                   	push   %ebx
  8018ea:	83 ec 24             	sub    $0x24,%esp
  8018ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	89 04 24             	mov    %eax,(%esp)
  8018fd:	e8 34 fb ff ff       	call   801436 <fd_lookup>
  801902:	89 c2                	mov    %eax,%edx
  801904:	85 d2                	test   %edx,%edx
  801906:	78 52                	js     80195a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801908:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801912:	8b 00                	mov    (%eax),%eax
  801914:	89 04 24             	mov    %eax,(%esp)
  801917:	e8 70 fb ff ff       	call   80148c <dev_lookup>
  80191c:	85 c0                	test   %eax,%eax
  80191e:	78 3a                	js     80195a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801923:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801927:	74 2c                	je     801955 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801929:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80192c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801933:	00 00 00 
	stat->st_isdir = 0;
  801936:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80193d:	00 00 00 
	stat->st_dev = dev;
  801940:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801946:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80194a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80194d:	89 14 24             	mov    %edx,(%esp)
  801950:	ff 50 14             	call   *0x14(%eax)
  801953:	eb 05                	jmp    80195a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801955:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80195a:	83 c4 24             	add    $0x24,%esp
  80195d:	5b                   	pop    %ebx
  80195e:	5d                   	pop    %ebp
  80195f:	c3                   	ret    

00801960 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	56                   	push   %esi
  801964:	53                   	push   %ebx
  801965:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801968:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80196f:	00 
  801970:	8b 45 08             	mov    0x8(%ebp),%eax
  801973:	89 04 24             	mov    %eax,(%esp)
  801976:	e8 84 02 00 00       	call   801bff <open>
  80197b:	89 c3                	mov    %eax,%ebx
  80197d:	85 db                	test   %ebx,%ebx
  80197f:	78 1b                	js     80199c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801981:	8b 45 0c             	mov    0xc(%ebp),%eax
  801984:	89 44 24 04          	mov    %eax,0x4(%esp)
  801988:	89 1c 24             	mov    %ebx,(%esp)
  80198b:	e8 56 ff ff ff       	call   8018e6 <fstat>
  801990:	89 c6                	mov    %eax,%esi
	close(fd);
  801992:	89 1c 24             	mov    %ebx,(%esp)
  801995:	e8 cd fb ff ff       	call   801567 <close>
	return r;
  80199a:	89 f0                	mov    %esi,%eax
}
  80199c:	83 c4 10             	add    $0x10,%esp
  80199f:	5b                   	pop    %ebx
  8019a0:	5e                   	pop    %esi
  8019a1:	5d                   	pop    %ebp
  8019a2:	c3                   	ret    

008019a3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	56                   	push   %esi
  8019a7:	53                   	push   %ebx
  8019a8:	83 ec 10             	sub    $0x10,%esp
  8019ab:	89 c6                	mov    %eax,%esi
  8019ad:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019af:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  8019b6:	75 11                	jne    8019c9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8019bf:	e8 61 0e 00 00       	call   802825 <ipc_find_env>
  8019c4:	a3 10 50 80 00       	mov    %eax,0x805010
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019c9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8019d0:	00 
  8019d1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8019d8:	00 
  8019d9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019dd:	a1 10 50 80 00       	mov    0x805010,%eax
  8019e2:	89 04 24             	mov    %eax,(%esp)
  8019e5:	e8 ae 0d 00 00       	call   802798 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019f1:	00 
  8019f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019fd:	e8 2e 0d 00 00       	call   802730 <ipc_recv>
}
  801a02:	83 c4 10             	add    $0x10,%esp
  801a05:	5b                   	pop    %ebx
  801a06:	5e                   	pop    %esi
  801a07:	5d                   	pop    %ebp
  801a08:	c3                   	ret    

00801a09 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	8b 40 0c             	mov    0xc(%eax),%eax
  801a15:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a22:	ba 00 00 00 00       	mov    $0x0,%edx
  801a27:	b8 02 00 00 00       	mov    $0x2,%eax
  801a2c:	e8 72 ff ff ff       	call   8019a3 <fsipc>
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a39:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a3f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a44:	ba 00 00 00 00       	mov    $0x0,%edx
  801a49:	b8 06 00 00 00       	mov    $0x6,%eax
  801a4e:	e8 50 ff ff ff       	call   8019a3 <fsipc>
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	53                   	push   %ebx
  801a59:	83 ec 14             	sub    $0x14,%esp
  801a5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	8b 40 0c             	mov    0xc(%eax),%eax
  801a65:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a6a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6f:	b8 05 00 00 00       	mov    $0x5,%eax
  801a74:	e8 2a ff ff ff       	call   8019a3 <fsipc>
  801a79:	89 c2                	mov    %eax,%edx
  801a7b:	85 d2                	test   %edx,%edx
  801a7d:	78 2b                	js     801aaa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a7f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801a86:	00 
  801a87:	89 1c 24             	mov    %ebx,(%esp)
  801a8a:	e8 c8 f1 ff ff       	call   800c57 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a8f:	a1 80 60 80 00       	mov    0x806080,%eax
  801a94:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a9a:	a1 84 60 80 00       	mov    0x806084,%eax
  801a9f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801aa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aaa:	83 c4 14             	add    $0x14,%esp
  801aad:	5b                   	pop    %ebx
  801aae:	5d                   	pop    %ebp
  801aaf:	c3                   	ret    

00801ab0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	53                   	push   %ebx
  801ab4:	83 ec 14             	sub    $0x14,%esp
  801ab7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ac0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801ac5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801acb:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801ad0:	0f 46 c3             	cmovbe %ebx,%eax
  801ad3:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801ad8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae3:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801aea:	e8 05 f3 ff ff       	call   800df4 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801aef:	ba 00 00 00 00       	mov    $0x0,%edx
  801af4:	b8 04 00 00 00       	mov    $0x4,%eax
  801af9:	e8 a5 fe ff ff       	call   8019a3 <fsipc>
  801afe:	85 c0                	test   %eax,%eax
  801b00:	78 53                	js     801b55 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801b02:	39 c3                	cmp    %eax,%ebx
  801b04:	73 24                	jae    801b2a <devfile_write+0x7a>
  801b06:	c7 44 24 0c 44 30 80 	movl   $0x803044,0xc(%esp)
  801b0d:	00 
  801b0e:	c7 44 24 08 4b 30 80 	movl   $0x80304b,0x8(%esp)
  801b15:	00 
  801b16:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801b1d:	00 
  801b1e:	c7 04 24 60 30 80 00 	movl   $0x803060,(%esp)
  801b25:	e8 ac 0b 00 00       	call   8026d6 <_panic>
	assert(r <= PGSIZE);
  801b2a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b2f:	7e 24                	jle    801b55 <devfile_write+0xa5>
  801b31:	c7 44 24 0c 6b 30 80 	movl   $0x80306b,0xc(%esp)
  801b38:	00 
  801b39:	c7 44 24 08 4b 30 80 	movl   $0x80304b,0x8(%esp)
  801b40:	00 
  801b41:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801b48:	00 
  801b49:	c7 04 24 60 30 80 00 	movl   $0x803060,(%esp)
  801b50:	e8 81 0b 00 00       	call   8026d6 <_panic>
	return r;
}
  801b55:	83 c4 14             	add    $0x14,%esp
  801b58:	5b                   	pop    %ebx
  801b59:	5d                   	pop    %ebp
  801b5a:	c3                   	ret    

00801b5b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	56                   	push   %esi
  801b5f:	53                   	push   %ebx
  801b60:	83 ec 10             	sub    $0x10,%esp
  801b63:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	8b 40 0c             	mov    0xc(%eax),%eax
  801b6c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b71:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b77:	ba 00 00 00 00       	mov    $0x0,%edx
  801b7c:	b8 03 00 00 00       	mov    $0x3,%eax
  801b81:	e8 1d fe ff ff       	call   8019a3 <fsipc>
  801b86:	89 c3                	mov    %eax,%ebx
  801b88:	85 c0                	test   %eax,%eax
  801b8a:	78 6a                	js     801bf6 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801b8c:	39 c6                	cmp    %eax,%esi
  801b8e:	73 24                	jae    801bb4 <devfile_read+0x59>
  801b90:	c7 44 24 0c 44 30 80 	movl   $0x803044,0xc(%esp)
  801b97:	00 
  801b98:	c7 44 24 08 4b 30 80 	movl   $0x80304b,0x8(%esp)
  801b9f:	00 
  801ba0:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801ba7:	00 
  801ba8:	c7 04 24 60 30 80 00 	movl   $0x803060,(%esp)
  801baf:	e8 22 0b 00 00       	call   8026d6 <_panic>
	assert(r <= PGSIZE);
  801bb4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bb9:	7e 24                	jle    801bdf <devfile_read+0x84>
  801bbb:	c7 44 24 0c 6b 30 80 	movl   $0x80306b,0xc(%esp)
  801bc2:	00 
  801bc3:	c7 44 24 08 4b 30 80 	movl   $0x80304b,0x8(%esp)
  801bca:	00 
  801bcb:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801bd2:	00 
  801bd3:	c7 04 24 60 30 80 00 	movl   $0x803060,(%esp)
  801bda:	e8 f7 0a 00 00       	call   8026d6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801bdf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801be3:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801bea:	00 
  801beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bee:	89 04 24             	mov    %eax,(%esp)
  801bf1:	e8 fe f1 ff ff       	call   800df4 <memmove>
	return r;
}
  801bf6:	89 d8                	mov    %ebx,%eax
  801bf8:	83 c4 10             	add    $0x10,%esp
  801bfb:	5b                   	pop    %ebx
  801bfc:	5e                   	pop    %esi
  801bfd:	5d                   	pop    %ebp
  801bfe:	c3                   	ret    

00801bff <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	53                   	push   %ebx
  801c03:	83 ec 24             	sub    $0x24,%esp
  801c06:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c09:	89 1c 24             	mov    %ebx,(%esp)
  801c0c:	e8 0f f0 ff ff       	call   800c20 <strlen>
  801c11:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c16:	7f 60                	jg     801c78 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c1b:	89 04 24             	mov    %eax,(%esp)
  801c1e:	e8 c4 f7 ff ff       	call   8013e7 <fd_alloc>
  801c23:	89 c2                	mov    %eax,%edx
  801c25:	85 d2                	test   %edx,%edx
  801c27:	78 54                	js     801c7d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c29:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c2d:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801c34:	e8 1e f0 ff ff       	call   800c57 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c39:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3c:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c44:	b8 01 00 00 00       	mov    $0x1,%eax
  801c49:	e8 55 fd ff ff       	call   8019a3 <fsipc>
  801c4e:	89 c3                	mov    %eax,%ebx
  801c50:	85 c0                	test   %eax,%eax
  801c52:	79 17                	jns    801c6b <open+0x6c>
		fd_close(fd, 0);
  801c54:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c5b:	00 
  801c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5f:	89 04 24             	mov    %eax,(%esp)
  801c62:	e8 7f f8 ff ff       	call   8014e6 <fd_close>
		return r;
  801c67:	89 d8                	mov    %ebx,%eax
  801c69:	eb 12                	jmp    801c7d <open+0x7e>
	}

	return fd2num(fd);
  801c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6e:	89 04 24             	mov    %eax,(%esp)
  801c71:	e8 4a f7 ff ff       	call   8013c0 <fd2num>
  801c76:	eb 05                	jmp    801c7d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c78:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801c7d:	83 c4 24             	add    $0x24,%esp
  801c80:	5b                   	pop    %ebx
  801c81:	5d                   	pop    %ebp
  801c82:	c3                   	ret    

00801c83 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c89:	ba 00 00 00 00       	mov    $0x0,%edx
  801c8e:	b8 08 00 00 00       	mov    $0x8,%eax
  801c93:	e8 0b fd ff ff       	call   8019a3 <fsipc>
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    
  801c9a:	66 90                	xchg   %ax,%ax
  801c9c:	66 90                	xchg   %ax,%ax
  801c9e:	66 90                	xchg   %ax,%ax

00801ca0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801ca6:	c7 44 24 04 77 30 80 	movl   $0x803077,0x4(%esp)
  801cad:	00 
  801cae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb1:	89 04 24             	mov    %eax,(%esp)
  801cb4:	e8 9e ef ff ff       	call   800c57 <strcpy>
	return 0;
}
  801cb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	53                   	push   %ebx
  801cc4:	83 ec 14             	sub    $0x14,%esp
  801cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801cca:	89 1c 24             	mov    %ebx,(%esp)
  801ccd:	e8 8d 0b 00 00       	call   80285f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801cd2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801cd7:	83 f8 01             	cmp    $0x1,%eax
  801cda:	75 0d                	jne    801ce9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801cdc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801cdf:	89 04 24             	mov    %eax,(%esp)
  801ce2:	e8 29 03 00 00       	call   802010 <nsipc_close>
  801ce7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801ce9:	89 d0                	mov    %edx,%eax
  801ceb:	83 c4 14             	add    $0x14,%esp
  801cee:	5b                   	pop    %ebx
  801cef:	5d                   	pop    %ebp
  801cf0:	c3                   	ret    

00801cf1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801cf7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cfe:	00 
  801cff:	8b 45 10             	mov    0x10(%ebp),%eax
  801d02:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d09:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d10:	8b 40 0c             	mov    0xc(%eax),%eax
  801d13:	89 04 24             	mov    %eax,(%esp)
  801d16:	e8 f0 03 00 00       	call   80210b <nsipc_send>
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d23:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d2a:	00 
  801d2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d35:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d3f:	89 04 24             	mov    %eax,(%esp)
  801d42:	e8 44 03 00 00       	call   80208b <nsipc_recv>
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d4f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d52:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d56:	89 04 24             	mov    %eax,(%esp)
  801d59:	e8 d8 f6 ff ff       	call   801436 <fd_lookup>
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	78 17                	js     801d79 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d65:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801d6b:	39 08                	cmp    %ecx,(%eax)
  801d6d:	75 05                	jne    801d74 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801d6f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d72:	eb 05                	jmp    801d79 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801d74:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	56                   	push   %esi
  801d7f:	53                   	push   %ebx
  801d80:	83 ec 20             	sub    $0x20,%esp
  801d83:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d88:	89 04 24             	mov    %eax,(%esp)
  801d8b:	e8 57 f6 ff ff       	call   8013e7 <fd_alloc>
  801d90:	89 c3                	mov    %eax,%ebx
  801d92:	85 c0                	test   %eax,%eax
  801d94:	78 21                	js     801db7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d96:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d9d:	00 
  801d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dac:	e8 c2 f2 ff ff       	call   801073 <sys_page_alloc>
  801db1:	89 c3                	mov    %eax,%ebx
  801db3:	85 c0                	test   %eax,%eax
  801db5:	79 0c                	jns    801dc3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801db7:	89 34 24             	mov    %esi,(%esp)
  801dba:	e8 51 02 00 00       	call   802010 <nsipc_close>
		return r;
  801dbf:	89 d8                	mov    %ebx,%eax
  801dc1:	eb 20                	jmp    801de3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801dc3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801dd8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801ddb:	89 14 24             	mov    %edx,(%esp)
  801dde:	e8 dd f5 ff ff       	call   8013c0 <fd2num>
}
  801de3:	83 c4 20             	add    $0x20,%esp
  801de6:	5b                   	pop    %ebx
  801de7:	5e                   	pop    %esi
  801de8:	5d                   	pop    %ebp
  801de9:	c3                   	ret    

00801dea <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
  801ded:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801df0:	8b 45 08             	mov    0x8(%ebp),%eax
  801df3:	e8 51 ff ff ff       	call   801d49 <fd2sockid>
		return r;
  801df8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dfa:	85 c0                	test   %eax,%eax
  801dfc:	78 23                	js     801e21 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801dfe:	8b 55 10             	mov    0x10(%ebp),%edx
  801e01:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e08:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e0c:	89 04 24             	mov    %eax,(%esp)
  801e0f:	e8 45 01 00 00       	call   801f59 <nsipc_accept>
		return r;
  801e14:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e16:	85 c0                	test   %eax,%eax
  801e18:	78 07                	js     801e21 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801e1a:	e8 5c ff ff ff       	call   801d7b <alloc_sockfd>
  801e1f:	89 c1                	mov    %eax,%ecx
}
  801e21:	89 c8                	mov    %ecx,%eax
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2e:	e8 16 ff ff ff       	call   801d49 <fd2sockid>
  801e33:	89 c2                	mov    %eax,%edx
  801e35:	85 d2                	test   %edx,%edx
  801e37:	78 16                	js     801e4f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801e39:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e47:	89 14 24             	mov    %edx,(%esp)
  801e4a:	e8 60 01 00 00       	call   801faf <nsipc_bind>
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <shutdown>:

int
shutdown(int s, int how)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	e8 ea fe ff ff       	call   801d49 <fd2sockid>
  801e5f:	89 c2                	mov    %eax,%edx
  801e61:	85 d2                	test   %edx,%edx
  801e63:	78 0f                	js     801e74 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e6c:	89 14 24             	mov    %edx,(%esp)
  801e6f:	e8 7a 01 00 00       	call   801fee <nsipc_shutdown>
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	e8 c5 fe ff ff       	call   801d49 <fd2sockid>
  801e84:	89 c2                	mov    %eax,%edx
  801e86:	85 d2                	test   %edx,%edx
  801e88:	78 16                	js     801ea0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801e8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e98:	89 14 24             	mov    %edx,(%esp)
  801e9b:	e8 8a 01 00 00       	call   80202a <nsipc_connect>
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <listen>:

int
listen(int s, int backlog)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eab:	e8 99 fe ff ff       	call   801d49 <fd2sockid>
  801eb0:	89 c2                	mov    %eax,%edx
  801eb2:	85 d2                	test   %edx,%edx
  801eb4:	78 0f                	js     801ec5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ebd:	89 14 24             	mov    %edx,(%esp)
  801ec0:	e8 a4 01 00 00       	call   802069 <nsipc_listen>
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ecd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	89 04 24             	mov    %eax,(%esp)
  801ee1:	e8 98 02 00 00       	call   80217e <nsipc_socket>
  801ee6:	89 c2                	mov    %eax,%edx
  801ee8:	85 d2                	test   %edx,%edx
  801eea:	78 05                	js     801ef1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801eec:	e8 8a fe ff ff       	call   801d7b <alloc_sockfd>
}
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	53                   	push   %ebx
  801ef7:	83 ec 14             	sub    $0x14,%esp
  801efa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801efc:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  801f03:	75 11                	jne    801f16 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f05:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801f0c:	e8 14 09 00 00       	call   802825 <ipc_find_env>
  801f11:	a3 14 50 80 00       	mov    %eax,0x805014
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f16:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801f1d:	00 
  801f1e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801f25:	00 
  801f26:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f2a:	a1 14 50 80 00       	mov    0x805014,%eax
  801f2f:	89 04 24             	mov    %eax,(%esp)
  801f32:	e8 61 08 00 00       	call   802798 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f37:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f3e:	00 
  801f3f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f46:	00 
  801f47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f4e:	e8 dd 07 00 00       	call   802730 <ipc_recv>
}
  801f53:	83 c4 14             	add    $0x14,%esp
  801f56:	5b                   	pop    %ebx
  801f57:	5d                   	pop    %ebp
  801f58:	c3                   	ret    

00801f59 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	56                   	push   %esi
  801f5d:	53                   	push   %ebx
  801f5e:	83 ec 10             	sub    $0x10,%esp
  801f61:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f6c:	8b 06                	mov    (%esi),%eax
  801f6e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f73:	b8 01 00 00 00       	mov    $0x1,%eax
  801f78:	e8 76 ff ff ff       	call   801ef3 <nsipc>
  801f7d:	89 c3                	mov    %eax,%ebx
  801f7f:	85 c0                	test   %eax,%eax
  801f81:	78 23                	js     801fa6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f83:	a1 10 70 80 00       	mov    0x807010,%eax
  801f88:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f8c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801f93:	00 
  801f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f97:	89 04 24             	mov    %eax,(%esp)
  801f9a:	e8 55 ee ff ff       	call   800df4 <memmove>
		*addrlen = ret->ret_addrlen;
  801f9f:	a1 10 70 80 00       	mov    0x807010,%eax
  801fa4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801fa6:	89 d8                	mov    %ebx,%eax
  801fa8:	83 c4 10             	add    $0x10,%esp
  801fab:	5b                   	pop    %ebx
  801fac:	5e                   	pop    %esi
  801fad:	5d                   	pop    %ebp
  801fae:	c3                   	ret    

00801faf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	53                   	push   %ebx
  801fb3:	83 ec 14             	sub    $0x14,%esp
  801fb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fc1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fcc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  801fd3:	e8 1c ee ff ff       	call   800df4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801fd8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801fde:	b8 02 00 00 00       	mov    $0x2,%eax
  801fe3:	e8 0b ff ff ff       	call   801ef3 <nsipc>
}
  801fe8:	83 c4 14             	add    $0x14,%esp
  801feb:	5b                   	pop    %ebx
  801fec:	5d                   	pop    %ebp
  801fed:	c3                   	ret    

00801fee <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fff:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802004:	b8 03 00 00 00       	mov    $0x3,%eax
  802009:	e8 e5 fe ff ff       	call   801ef3 <nsipc>
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <nsipc_close>:

int
nsipc_close(int s)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802016:	8b 45 08             	mov    0x8(%ebp),%eax
  802019:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80201e:	b8 04 00 00 00       	mov    $0x4,%eax
  802023:	e8 cb fe ff ff       	call   801ef3 <nsipc>
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	53                   	push   %ebx
  80202e:	83 ec 14             	sub    $0x14,%esp
  802031:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80203c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802040:	8b 45 0c             	mov    0xc(%ebp),%eax
  802043:	89 44 24 04          	mov    %eax,0x4(%esp)
  802047:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80204e:	e8 a1 ed ff ff       	call   800df4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802053:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802059:	b8 05 00 00 00       	mov    $0x5,%eax
  80205e:	e8 90 fe ff ff       	call   801ef3 <nsipc>
}
  802063:	83 c4 14             	add    $0x14,%esp
  802066:	5b                   	pop    %ebx
  802067:	5d                   	pop    %ebp
  802068:	c3                   	ret    

00802069 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80207f:	b8 06 00 00 00       	mov    $0x6,%eax
  802084:	e8 6a fe ff ff       	call   801ef3 <nsipc>
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	56                   	push   %esi
  80208f:	53                   	push   %ebx
  802090:	83 ec 10             	sub    $0x10,%esp
  802093:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80209e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8020a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8020a7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8020ac:	b8 07 00 00 00       	mov    $0x7,%eax
  8020b1:	e8 3d fe ff ff       	call   801ef3 <nsipc>
  8020b6:	89 c3                	mov    %eax,%ebx
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	78 46                	js     802102 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8020bc:	39 f0                	cmp    %esi,%eax
  8020be:	7f 07                	jg     8020c7 <nsipc_recv+0x3c>
  8020c0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8020c5:	7e 24                	jle    8020eb <nsipc_recv+0x60>
  8020c7:	c7 44 24 0c 83 30 80 	movl   $0x803083,0xc(%esp)
  8020ce:	00 
  8020cf:	c7 44 24 08 4b 30 80 	movl   $0x80304b,0x8(%esp)
  8020d6:	00 
  8020d7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8020de:	00 
  8020df:	c7 04 24 98 30 80 00 	movl   $0x803098,(%esp)
  8020e6:	e8 eb 05 00 00       	call   8026d6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020ef:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8020f6:	00 
  8020f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fa:	89 04 24             	mov    %eax,(%esp)
  8020fd:	e8 f2 ec ff ff       	call   800df4 <memmove>
	}

	return r;
}
  802102:	89 d8                	mov    %ebx,%eax
  802104:	83 c4 10             	add    $0x10,%esp
  802107:	5b                   	pop    %ebx
  802108:	5e                   	pop    %esi
  802109:	5d                   	pop    %ebp
  80210a:	c3                   	ret    

0080210b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	53                   	push   %ebx
  80210f:	83 ec 14             	sub    $0x14,%esp
  802112:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80211d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802123:	7e 24                	jle    802149 <nsipc_send+0x3e>
  802125:	c7 44 24 0c a4 30 80 	movl   $0x8030a4,0xc(%esp)
  80212c:	00 
  80212d:	c7 44 24 08 4b 30 80 	movl   $0x80304b,0x8(%esp)
  802134:	00 
  802135:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80213c:	00 
  80213d:	c7 04 24 98 30 80 00 	movl   $0x803098,(%esp)
  802144:	e8 8d 05 00 00       	call   8026d6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802149:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80214d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802150:	89 44 24 04          	mov    %eax,0x4(%esp)
  802154:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80215b:	e8 94 ec ff ff       	call   800df4 <memmove>
	nsipcbuf.send.req_size = size;
  802160:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802166:	8b 45 14             	mov    0x14(%ebp),%eax
  802169:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80216e:	b8 08 00 00 00       	mov    $0x8,%eax
  802173:	e8 7b fd ff ff       	call   801ef3 <nsipc>
}
  802178:	83 c4 14             	add    $0x14,%esp
  80217b:	5b                   	pop    %ebx
  80217c:	5d                   	pop    %ebp
  80217d:	c3                   	ret    

0080217e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80218c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802194:	8b 45 10             	mov    0x10(%ebp),%eax
  802197:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80219c:	b8 09 00 00 00       	mov    $0x9,%eax
  8021a1:	e8 4d fd ff ff       	call   801ef3 <nsipc>
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	56                   	push   %esi
  8021ac:	53                   	push   %ebx
  8021ad:	83 ec 10             	sub    $0x10,%esp
  8021b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	89 04 24             	mov    %eax,(%esp)
  8021b9:	e8 12 f2 ff ff       	call   8013d0 <fd2data>
  8021be:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021c0:	c7 44 24 04 b0 30 80 	movl   $0x8030b0,0x4(%esp)
  8021c7:	00 
  8021c8:	89 1c 24             	mov    %ebx,(%esp)
  8021cb:	e8 87 ea ff ff       	call   800c57 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021d0:	8b 46 04             	mov    0x4(%esi),%eax
  8021d3:	2b 06                	sub    (%esi),%eax
  8021d5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8021db:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8021e2:	00 00 00 
	stat->st_dev = &devpipe;
  8021e5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8021ec:	40 80 00 
	return 0;
}
  8021ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f4:	83 c4 10             	add    $0x10,%esp
  8021f7:	5b                   	pop    %ebx
  8021f8:	5e                   	pop    %esi
  8021f9:	5d                   	pop    %ebp
  8021fa:	c3                   	ret    

008021fb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	53                   	push   %ebx
  8021ff:	83 ec 14             	sub    $0x14,%esp
  802202:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802205:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802209:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802210:	e8 05 ef ff ff       	call   80111a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802215:	89 1c 24             	mov    %ebx,(%esp)
  802218:	e8 b3 f1 ff ff       	call   8013d0 <fd2data>
  80221d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802221:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802228:	e8 ed ee ff ff       	call   80111a <sys_page_unmap>
}
  80222d:	83 c4 14             	add    $0x14,%esp
  802230:	5b                   	pop    %ebx
  802231:	5d                   	pop    %ebp
  802232:	c3                   	ret    

00802233 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	57                   	push   %edi
  802237:	56                   	push   %esi
  802238:	53                   	push   %ebx
  802239:	83 ec 2c             	sub    $0x2c,%esp
  80223c:	89 c6                	mov    %eax,%esi
  80223e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802241:	a1 18 50 80 00       	mov    0x805018,%eax
  802246:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802249:	89 34 24             	mov    %esi,(%esp)
  80224c:	e8 0e 06 00 00       	call   80285f <pageref>
  802251:	89 c7                	mov    %eax,%edi
  802253:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802256:	89 04 24             	mov    %eax,(%esp)
  802259:	e8 01 06 00 00       	call   80285f <pageref>
  80225e:	39 c7                	cmp    %eax,%edi
  802260:	0f 94 c2             	sete   %dl
  802263:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802266:	8b 0d 18 50 80 00    	mov    0x805018,%ecx
  80226c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80226f:	39 fb                	cmp    %edi,%ebx
  802271:	74 21                	je     802294 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802273:	84 d2                	test   %dl,%dl
  802275:	74 ca                	je     802241 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802277:	8b 51 58             	mov    0x58(%ecx),%edx
  80227a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80227e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802282:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802286:	c7 04 24 b7 30 80 00 	movl   $0x8030b7,(%esp)
  80228d:	e8 9f e3 ff ff       	call   800631 <cprintf>
  802292:	eb ad                	jmp    802241 <_pipeisclosed+0xe>
	}
}
  802294:	83 c4 2c             	add    $0x2c,%esp
  802297:	5b                   	pop    %ebx
  802298:	5e                   	pop    %esi
  802299:	5f                   	pop    %edi
  80229a:	5d                   	pop    %ebp
  80229b:	c3                   	ret    

0080229c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
  80229f:	57                   	push   %edi
  8022a0:	56                   	push   %esi
  8022a1:	53                   	push   %ebx
  8022a2:	83 ec 1c             	sub    $0x1c,%esp
  8022a5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8022a8:	89 34 24             	mov    %esi,(%esp)
  8022ab:	e8 20 f1 ff ff       	call   8013d0 <fd2data>
  8022b0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b7:	eb 45                	jmp    8022fe <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8022b9:	89 da                	mov    %ebx,%edx
  8022bb:	89 f0                	mov    %esi,%eax
  8022bd:	e8 71 ff ff ff       	call   802233 <_pipeisclosed>
  8022c2:	85 c0                	test   %eax,%eax
  8022c4:	75 41                	jne    802307 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8022c6:	e8 89 ed ff ff       	call   801054 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022cb:	8b 43 04             	mov    0x4(%ebx),%eax
  8022ce:	8b 0b                	mov    (%ebx),%ecx
  8022d0:	8d 51 20             	lea    0x20(%ecx),%edx
  8022d3:	39 d0                	cmp    %edx,%eax
  8022d5:	73 e2                	jae    8022b9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022da:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8022de:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8022e1:	99                   	cltd   
  8022e2:	c1 ea 1b             	shr    $0x1b,%edx
  8022e5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8022e8:	83 e1 1f             	and    $0x1f,%ecx
  8022eb:	29 d1                	sub    %edx,%ecx
  8022ed:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8022f1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8022f5:	83 c0 01             	add    $0x1,%eax
  8022f8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022fb:	83 c7 01             	add    $0x1,%edi
  8022fe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802301:	75 c8                	jne    8022cb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802303:	89 f8                	mov    %edi,%eax
  802305:	eb 05                	jmp    80230c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802307:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80230c:	83 c4 1c             	add    $0x1c,%esp
  80230f:	5b                   	pop    %ebx
  802310:	5e                   	pop    %esi
  802311:	5f                   	pop    %edi
  802312:	5d                   	pop    %ebp
  802313:	c3                   	ret    

00802314 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	57                   	push   %edi
  802318:	56                   	push   %esi
  802319:	53                   	push   %ebx
  80231a:	83 ec 1c             	sub    $0x1c,%esp
  80231d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802320:	89 3c 24             	mov    %edi,(%esp)
  802323:	e8 a8 f0 ff ff       	call   8013d0 <fd2data>
  802328:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80232a:	be 00 00 00 00       	mov    $0x0,%esi
  80232f:	eb 3d                	jmp    80236e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802331:	85 f6                	test   %esi,%esi
  802333:	74 04                	je     802339 <devpipe_read+0x25>
				return i;
  802335:	89 f0                	mov    %esi,%eax
  802337:	eb 43                	jmp    80237c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802339:	89 da                	mov    %ebx,%edx
  80233b:	89 f8                	mov    %edi,%eax
  80233d:	e8 f1 fe ff ff       	call   802233 <_pipeisclosed>
  802342:	85 c0                	test   %eax,%eax
  802344:	75 31                	jne    802377 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802346:	e8 09 ed ff ff       	call   801054 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80234b:	8b 03                	mov    (%ebx),%eax
  80234d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802350:	74 df                	je     802331 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802352:	99                   	cltd   
  802353:	c1 ea 1b             	shr    $0x1b,%edx
  802356:	01 d0                	add    %edx,%eax
  802358:	83 e0 1f             	and    $0x1f,%eax
  80235b:	29 d0                	sub    %edx,%eax
  80235d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802362:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802365:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802368:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80236b:	83 c6 01             	add    $0x1,%esi
  80236e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802371:	75 d8                	jne    80234b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802373:	89 f0                	mov    %esi,%eax
  802375:	eb 05                	jmp    80237c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802377:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80237c:	83 c4 1c             	add    $0x1c,%esp
  80237f:	5b                   	pop    %ebx
  802380:	5e                   	pop    %esi
  802381:	5f                   	pop    %edi
  802382:	5d                   	pop    %ebp
  802383:	c3                   	ret    

00802384 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
  802387:	56                   	push   %esi
  802388:	53                   	push   %ebx
  802389:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80238c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80238f:	89 04 24             	mov    %eax,(%esp)
  802392:	e8 50 f0 ff ff       	call   8013e7 <fd_alloc>
  802397:	89 c2                	mov    %eax,%edx
  802399:	85 d2                	test   %edx,%edx
  80239b:	0f 88 4d 01 00 00    	js     8024ee <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023a1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023a8:	00 
  8023a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023b7:	e8 b7 ec ff ff       	call   801073 <sys_page_alloc>
  8023bc:	89 c2                	mov    %eax,%edx
  8023be:	85 d2                	test   %edx,%edx
  8023c0:	0f 88 28 01 00 00    	js     8024ee <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8023c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023c9:	89 04 24             	mov    %eax,(%esp)
  8023cc:	e8 16 f0 ff ff       	call   8013e7 <fd_alloc>
  8023d1:	89 c3                	mov    %eax,%ebx
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	0f 88 fe 00 00 00    	js     8024d9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023db:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023e2:	00 
  8023e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023f1:	e8 7d ec ff ff       	call   801073 <sys_page_alloc>
  8023f6:	89 c3                	mov    %eax,%ebx
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	0f 88 d9 00 00 00    	js     8024d9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802403:	89 04 24             	mov    %eax,(%esp)
  802406:	e8 c5 ef ff ff       	call   8013d0 <fd2data>
  80240b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80240d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802414:	00 
  802415:	89 44 24 04          	mov    %eax,0x4(%esp)
  802419:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802420:	e8 4e ec ff ff       	call   801073 <sys_page_alloc>
  802425:	89 c3                	mov    %eax,%ebx
  802427:	85 c0                	test   %eax,%eax
  802429:	0f 88 97 00 00 00    	js     8024c6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80242f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802432:	89 04 24             	mov    %eax,(%esp)
  802435:	e8 96 ef ff ff       	call   8013d0 <fd2data>
  80243a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802441:	00 
  802442:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802446:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80244d:	00 
  80244e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802452:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802459:	e8 69 ec ff ff       	call   8010c7 <sys_page_map>
  80245e:	89 c3                	mov    %eax,%ebx
  802460:	85 c0                	test   %eax,%eax
  802462:	78 52                	js     8024b6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802464:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802479:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80247f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802482:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802487:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	89 04 24             	mov    %eax,(%esp)
  802494:	e8 27 ef ff ff       	call   8013c0 <fd2num>
  802499:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80249c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80249e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a1:	89 04 24             	mov    %eax,(%esp)
  8024a4:	e8 17 ef ff ff       	call   8013c0 <fd2num>
  8024a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024ac:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024af:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b4:	eb 38                	jmp    8024ee <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8024b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024c1:	e8 54 ec ff ff       	call   80111a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8024c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d4:	e8 41 ec ff ff       	call   80111a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024e7:	e8 2e ec ff ff       	call   80111a <sys_page_unmap>
  8024ec:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8024ee:	83 c4 30             	add    $0x30,%esp
  8024f1:	5b                   	pop    %ebx
  8024f2:	5e                   	pop    %esi
  8024f3:	5d                   	pop    %ebp
  8024f4:	c3                   	ret    

008024f5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8024f5:	55                   	push   %ebp
  8024f6:	89 e5                	mov    %esp,%ebp
  8024f8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802502:	8b 45 08             	mov    0x8(%ebp),%eax
  802505:	89 04 24             	mov    %eax,(%esp)
  802508:	e8 29 ef ff ff       	call   801436 <fd_lookup>
  80250d:	89 c2                	mov    %eax,%edx
  80250f:	85 d2                	test   %edx,%edx
  802511:	78 15                	js     802528 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	89 04 24             	mov    %eax,(%esp)
  802519:	e8 b2 ee ff ff       	call   8013d0 <fd2data>
	return _pipeisclosed(fd, p);
  80251e:	89 c2                	mov    %eax,%edx
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	e8 0b fd ff ff       	call   802233 <_pipeisclosed>
}
  802528:	c9                   	leave  
  802529:	c3                   	ret    
  80252a:	66 90                	xchg   %ax,%ax
  80252c:	66 90                	xchg   %ax,%ax
  80252e:	66 90                	xchg   %ax,%ax

00802530 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802533:	b8 00 00 00 00       	mov    $0x0,%eax
  802538:	5d                   	pop    %ebp
  802539:	c3                   	ret    

0080253a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80253a:	55                   	push   %ebp
  80253b:	89 e5                	mov    %esp,%ebp
  80253d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802540:	c7 44 24 04 cf 30 80 	movl   $0x8030cf,0x4(%esp)
  802547:	00 
  802548:	8b 45 0c             	mov    0xc(%ebp),%eax
  80254b:	89 04 24             	mov    %eax,(%esp)
  80254e:	e8 04 e7 ff ff       	call   800c57 <strcpy>
	return 0;
}
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
  802558:	c9                   	leave  
  802559:	c3                   	ret    

0080255a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
  80255d:	57                   	push   %edi
  80255e:	56                   	push   %esi
  80255f:	53                   	push   %ebx
  802560:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802566:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80256b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802571:	eb 31                	jmp    8025a4 <devcons_write+0x4a>
		m = n - tot;
  802573:	8b 75 10             	mov    0x10(%ebp),%esi
  802576:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802578:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80257b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802580:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802583:	89 74 24 08          	mov    %esi,0x8(%esp)
  802587:	03 45 0c             	add    0xc(%ebp),%eax
  80258a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80258e:	89 3c 24             	mov    %edi,(%esp)
  802591:	e8 5e e8 ff ff       	call   800df4 <memmove>
		sys_cputs(buf, m);
  802596:	89 74 24 04          	mov    %esi,0x4(%esp)
  80259a:	89 3c 24             	mov    %edi,(%esp)
  80259d:	e8 04 ea ff ff       	call   800fa6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025a2:	01 f3                	add    %esi,%ebx
  8025a4:	89 d8                	mov    %ebx,%eax
  8025a6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8025a9:	72 c8                	jb     802573 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8025ab:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8025b1:	5b                   	pop    %ebx
  8025b2:	5e                   	pop    %esi
  8025b3:	5f                   	pop    %edi
  8025b4:	5d                   	pop    %ebp
  8025b5:	c3                   	ret    

008025b6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025b6:	55                   	push   %ebp
  8025b7:	89 e5                	mov    %esp,%ebp
  8025b9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8025bc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8025c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025c5:	75 07                	jne    8025ce <devcons_read+0x18>
  8025c7:	eb 2a                	jmp    8025f3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8025c9:	e8 86 ea ff ff       	call   801054 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8025ce:	66 90                	xchg   %ax,%ax
  8025d0:	e8 ef e9 ff ff       	call   800fc4 <sys_cgetc>
  8025d5:	85 c0                	test   %eax,%eax
  8025d7:	74 f0                	je     8025c9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	78 16                	js     8025f3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8025dd:	83 f8 04             	cmp    $0x4,%eax
  8025e0:	74 0c                	je     8025ee <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8025e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e5:	88 02                	mov    %al,(%edx)
	return 1;
  8025e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ec:	eb 05                	jmp    8025f3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8025ee:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8025f3:	c9                   	leave  
  8025f4:	c3                   	ret    

008025f5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8025f5:	55                   	push   %ebp
  8025f6:	89 e5                	mov    %esp,%ebp
  8025f8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8025fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fe:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802601:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802608:	00 
  802609:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80260c:	89 04 24             	mov    %eax,(%esp)
  80260f:	e8 92 e9 ff ff       	call   800fa6 <sys_cputs>
}
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <getchar>:

int
getchar(void)
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
  802619:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80261c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802623:	00 
  802624:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802627:	89 44 24 04          	mov    %eax,0x4(%esp)
  80262b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802632:	e8 93 f0 ff ff       	call   8016ca <read>
	if (r < 0)
  802637:	85 c0                	test   %eax,%eax
  802639:	78 0f                	js     80264a <getchar+0x34>
		return r;
	if (r < 1)
  80263b:	85 c0                	test   %eax,%eax
  80263d:	7e 06                	jle    802645 <getchar+0x2f>
		return -E_EOF;
	return c;
  80263f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802643:	eb 05                	jmp    80264a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802645:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80264a:	c9                   	leave  
  80264b:	c3                   	ret    

0080264c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
  80264f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802652:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802655:	89 44 24 04          	mov    %eax,0x4(%esp)
  802659:	8b 45 08             	mov    0x8(%ebp),%eax
  80265c:	89 04 24             	mov    %eax,(%esp)
  80265f:	e8 d2 ed ff ff       	call   801436 <fd_lookup>
  802664:	85 c0                	test   %eax,%eax
  802666:	78 11                	js     802679 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802671:	39 10                	cmp    %edx,(%eax)
  802673:	0f 94 c0             	sete   %al
  802676:	0f b6 c0             	movzbl %al,%eax
}
  802679:	c9                   	leave  
  80267a:	c3                   	ret    

0080267b <opencons>:

int
opencons(void)
{
  80267b:	55                   	push   %ebp
  80267c:	89 e5                	mov    %esp,%ebp
  80267e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802681:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802684:	89 04 24             	mov    %eax,(%esp)
  802687:	e8 5b ed ff ff       	call   8013e7 <fd_alloc>
		return r;
  80268c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80268e:	85 c0                	test   %eax,%eax
  802690:	78 40                	js     8026d2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802692:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802699:	00 
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a8:	e8 c6 e9 ff ff       	call   801073 <sys_page_alloc>
		return r;
  8026ad:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026af:	85 c0                	test   %eax,%eax
  8026b1:	78 1f                	js     8026d2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8026b3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026c8:	89 04 24             	mov    %eax,(%esp)
  8026cb:	e8 f0 ec ff ff       	call   8013c0 <fd2num>
  8026d0:	89 c2                	mov    %eax,%edx
}
  8026d2:	89 d0                	mov    %edx,%eax
  8026d4:	c9                   	leave  
  8026d5:	c3                   	ret    

008026d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8026d6:	55                   	push   %ebp
  8026d7:	89 e5                	mov    %esp,%ebp
  8026d9:	56                   	push   %esi
  8026da:	53                   	push   %ebx
  8026db:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8026de:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8026e1:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8026e7:	e8 49 e9 ff ff       	call   801035 <sys_getenvid>
  8026ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ef:	89 54 24 10          	mov    %edx,0x10(%esp)
  8026f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8026fa:	89 74 24 08          	mov    %esi,0x8(%esp)
  8026fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802702:	c7 04 24 dc 30 80 00 	movl   $0x8030dc,(%esp)
  802709:	e8 23 df ff ff       	call   800631 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80270e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802712:	8b 45 10             	mov    0x10(%ebp),%eax
  802715:	89 04 24             	mov    %eax,(%esp)
  802718:	e8 b3 de ff ff       	call   8005d0 <vcprintf>
	cprintf("\n");
  80271d:	c7 04 24 c8 30 80 00 	movl   $0x8030c8,(%esp)
  802724:	e8 08 df ff ff       	call   800631 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802729:	cc                   	int3   
  80272a:	eb fd                	jmp    802729 <_panic+0x53>
  80272c:	66 90                	xchg   %ax,%ax
  80272e:	66 90                	xchg   %ax,%ax

00802730 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802730:	55                   	push   %ebp
  802731:	89 e5                	mov    %esp,%ebp
  802733:	56                   	push   %esi
  802734:	53                   	push   %ebx
  802735:	83 ec 10             	sub    $0x10,%esp
  802738:	8b 75 08             	mov    0x8(%ebp),%esi
  80273b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80273e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802741:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802743:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802748:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80274b:	89 04 24             	mov    %eax,(%esp)
  80274e:	e8 36 eb ff ff       	call   801289 <sys_ipc_recv>
  802753:	85 c0                	test   %eax,%eax
  802755:	74 16                	je     80276d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802757:	85 f6                	test   %esi,%esi
  802759:	74 06                	je     802761 <ipc_recv+0x31>
			*from_env_store = 0;
  80275b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802761:	85 db                	test   %ebx,%ebx
  802763:	74 2c                	je     802791 <ipc_recv+0x61>
			*perm_store = 0;
  802765:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80276b:	eb 24                	jmp    802791 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  80276d:	85 f6                	test   %esi,%esi
  80276f:	74 0a                	je     80277b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802771:	a1 18 50 80 00       	mov    0x805018,%eax
  802776:	8b 40 74             	mov    0x74(%eax),%eax
  802779:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80277b:	85 db                	test   %ebx,%ebx
  80277d:	74 0a                	je     802789 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80277f:	a1 18 50 80 00       	mov    0x805018,%eax
  802784:	8b 40 78             	mov    0x78(%eax),%eax
  802787:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802789:	a1 18 50 80 00       	mov    0x805018,%eax
  80278e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802791:	83 c4 10             	add    $0x10,%esp
  802794:	5b                   	pop    %ebx
  802795:	5e                   	pop    %esi
  802796:	5d                   	pop    %ebp
  802797:	c3                   	ret    

00802798 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
  80279b:	57                   	push   %edi
  80279c:	56                   	push   %esi
  80279d:	53                   	push   %ebx
  80279e:	83 ec 1c             	sub    $0x1c,%esp
  8027a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8027a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027a7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  8027aa:	85 db                	test   %ebx,%ebx
  8027ac:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8027b1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  8027b4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027b8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c3:	89 04 24             	mov    %eax,(%esp)
  8027c6:	e8 9b ea ff ff       	call   801266 <sys_ipc_try_send>
	if (r == 0) return;
  8027cb:	85 c0                	test   %eax,%eax
  8027cd:	75 22                	jne    8027f1 <ipc_send+0x59>
  8027cf:	eb 4c                	jmp    80281d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  8027d1:	84 d2                	test   %dl,%dl
  8027d3:	75 48                	jne    80281d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  8027d5:	e8 7a e8 ff ff       	call   801054 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  8027da:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027de:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e9:	89 04 24             	mov    %eax,(%esp)
  8027ec:	e8 75 ea ff ff       	call   801266 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  8027f1:	85 c0                	test   %eax,%eax
  8027f3:	0f 94 c2             	sete   %dl
  8027f6:	74 d9                	je     8027d1 <ipc_send+0x39>
  8027f8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8027fb:	74 d4                	je     8027d1 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  8027fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802801:	c7 44 24 08 00 31 80 	movl   $0x803100,0x8(%esp)
  802808:	00 
  802809:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802810:	00 
  802811:	c7 04 24 0e 31 80 00 	movl   $0x80310e,(%esp)
  802818:	e8 b9 fe ff ff       	call   8026d6 <_panic>
}
  80281d:	83 c4 1c             	add    $0x1c,%esp
  802820:	5b                   	pop    %ebx
  802821:	5e                   	pop    %esi
  802822:	5f                   	pop    %edi
  802823:	5d                   	pop    %ebp
  802824:	c3                   	ret    

00802825 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
  802828:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80282b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802830:	89 c2                	mov    %eax,%edx
  802832:	c1 e2 07             	shl    $0x7,%edx
  802835:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80283b:	8b 52 50             	mov    0x50(%edx),%edx
  80283e:	39 ca                	cmp    %ecx,%edx
  802840:	75 0d                	jne    80284f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802842:	c1 e0 07             	shl    $0x7,%eax
  802845:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80284a:	8b 40 40             	mov    0x40(%eax),%eax
  80284d:	eb 0e                	jmp    80285d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80284f:	83 c0 01             	add    $0x1,%eax
  802852:	3d 00 04 00 00       	cmp    $0x400,%eax
  802857:	75 d7                	jne    802830 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802859:	66 b8 00 00          	mov    $0x0,%ax
}
  80285d:	5d                   	pop    %ebp
  80285e:	c3                   	ret    

0080285f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80285f:	55                   	push   %ebp
  802860:	89 e5                	mov    %esp,%ebp
  802862:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802865:	89 d0                	mov    %edx,%eax
  802867:	c1 e8 16             	shr    $0x16,%eax
  80286a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802871:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802876:	f6 c1 01             	test   $0x1,%cl
  802879:	74 1d                	je     802898 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80287b:	c1 ea 0c             	shr    $0xc,%edx
  80287e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802885:	f6 c2 01             	test   $0x1,%dl
  802888:	74 0e                	je     802898 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80288a:	c1 ea 0c             	shr    $0xc,%edx
  80288d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802894:	ef 
  802895:	0f b7 c0             	movzwl %ax,%eax
}
  802898:	5d                   	pop    %ebp
  802899:	c3                   	ret    
  80289a:	66 90                	xchg   %ax,%ax
  80289c:	66 90                	xchg   %ax,%ax
  80289e:	66 90                	xchg   %ax,%ax

008028a0 <__udivdi3>:
  8028a0:	55                   	push   %ebp
  8028a1:	57                   	push   %edi
  8028a2:	56                   	push   %esi
  8028a3:	83 ec 0c             	sub    $0xc,%esp
  8028a6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8028aa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8028ae:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8028b2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8028b6:	85 c0                	test   %eax,%eax
  8028b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8028bc:	89 ea                	mov    %ebp,%edx
  8028be:	89 0c 24             	mov    %ecx,(%esp)
  8028c1:	75 2d                	jne    8028f0 <__udivdi3+0x50>
  8028c3:	39 e9                	cmp    %ebp,%ecx
  8028c5:	77 61                	ja     802928 <__udivdi3+0x88>
  8028c7:	85 c9                	test   %ecx,%ecx
  8028c9:	89 ce                	mov    %ecx,%esi
  8028cb:	75 0b                	jne    8028d8 <__udivdi3+0x38>
  8028cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8028d2:	31 d2                	xor    %edx,%edx
  8028d4:	f7 f1                	div    %ecx
  8028d6:	89 c6                	mov    %eax,%esi
  8028d8:	31 d2                	xor    %edx,%edx
  8028da:	89 e8                	mov    %ebp,%eax
  8028dc:	f7 f6                	div    %esi
  8028de:	89 c5                	mov    %eax,%ebp
  8028e0:	89 f8                	mov    %edi,%eax
  8028e2:	f7 f6                	div    %esi
  8028e4:	89 ea                	mov    %ebp,%edx
  8028e6:	83 c4 0c             	add    $0xc,%esp
  8028e9:	5e                   	pop    %esi
  8028ea:	5f                   	pop    %edi
  8028eb:	5d                   	pop    %ebp
  8028ec:	c3                   	ret    
  8028ed:	8d 76 00             	lea    0x0(%esi),%esi
  8028f0:	39 e8                	cmp    %ebp,%eax
  8028f2:	77 24                	ja     802918 <__udivdi3+0x78>
  8028f4:	0f bd e8             	bsr    %eax,%ebp
  8028f7:	83 f5 1f             	xor    $0x1f,%ebp
  8028fa:	75 3c                	jne    802938 <__udivdi3+0x98>
  8028fc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802900:	39 34 24             	cmp    %esi,(%esp)
  802903:	0f 86 9f 00 00 00    	jbe    8029a8 <__udivdi3+0x108>
  802909:	39 d0                	cmp    %edx,%eax
  80290b:	0f 82 97 00 00 00    	jb     8029a8 <__udivdi3+0x108>
  802911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802918:	31 d2                	xor    %edx,%edx
  80291a:	31 c0                	xor    %eax,%eax
  80291c:	83 c4 0c             	add    $0xc,%esp
  80291f:	5e                   	pop    %esi
  802920:	5f                   	pop    %edi
  802921:	5d                   	pop    %ebp
  802922:	c3                   	ret    
  802923:	90                   	nop
  802924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802928:	89 f8                	mov    %edi,%eax
  80292a:	f7 f1                	div    %ecx
  80292c:	31 d2                	xor    %edx,%edx
  80292e:	83 c4 0c             	add    $0xc,%esp
  802931:	5e                   	pop    %esi
  802932:	5f                   	pop    %edi
  802933:	5d                   	pop    %ebp
  802934:	c3                   	ret    
  802935:	8d 76 00             	lea    0x0(%esi),%esi
  802938:	89 e9                	mov    %ebp,%ecx
  80293a:	8b 3c 24             	mov    (%esp),%edi
  80293d:	d3 e0                	shl    %cl,%eax
  80293f:	89 c6                	mov    %eax,%esi
  802941:	b8 20 00 00 00       	mov    $0x20,%eax
  802946:	29 e8                	sub    %ebp,%eax
  802948:	89 c1                	mov    %eax,%ecx
  80294a:	d3 ef                	shr    %cl,%edi
  80294c:	89 e9                	mov    %ebp,%ecx
  80294e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802952:	8b 3c 24             	mov    (%esp),%edi
  802955:	09 74 24 08          	or     %esi,0x8(%esp)
  802959:	89 d6                	mov    %edx,%esi
  80295b:	d3 e7                	shl    %cl,%edi
  80295d:	89 c1                	mov    %eax,%ecx
  80295f:	89 3c 24             	mov    %edi,(%esp)
  802962:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802966:	d3 ee                	shr    %cl,%esi
  802968:	89 e9                	mov    %ebp,%ecx
  80296a:	d3 e2                	shl    %cl,%edx
  80296c:	89 c1                	mov    %eax,%ecx
  80296e:	d3 ef                	shr    %cl,%edi
  802970:	09 d7                	or     %edx,%edi
  802972:	89 f2                	mov    %esi,%edx
  802974:	89 f8                	mov    %edi,%eax
  802976:	f7 74 24 08          	divl   0x8(%esp)
  80297a:	89 d6                	mov    %edx,%esi
  80297c:	89 c7                	mov    %eax,%edi
  80297e:	f7 24 24             	mull   (%esp)
  802981:	39 d6                	cmp    %edx,%esi
  802983:	89 14 24             	mov    %edx,(%esp)
  802986:	72 30                	jb     8029b8 <__udivdi3+0x118>
  802988:	8b 54 24 04          	mov    0x4(%esp),%edx
  80298c:	89 e9                	mov    %ebp,%ecx
  80298e:	d3 e2                	shl    %cl,%edx
  802990:	39 c2                	cmp    %eax,%edx
  802992:	73 05                	jae    802999 <__udivdi3+0xf9>
  802994:	3b 34 24             	cmp    (%esp),%esi
  802997:	74 1f                	je     8029b8 <__udivdi3+0x118>
  802999:	89 f8                	mov    %edi,%eax
  80299b:	31 d2                	xor    %edx,%edx
  80299d:	e9 7a ff ff ff       	jmp    80291c <__udivdi3+0x7c>
  8029a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029a8:	31 d2                	xor    %edx,%edx
  8029aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8029af:	e9 68 ff ff ff       	jmp    80291c <__udivdi3+0x7c>
  8029b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029b8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8029bb:	31 d2                	xor    %edx,%edx
  8029bd:	83 c4 0c             	add    $0xc,%esp
  8029c0:	5e                   	pop    %esi
  8029c1:	5f                   	pop    %edi
  8029c2:	5d                   	pop    %ebp
  8029c3:	c3                   	ret    
  8029c4:	66 90                	xchg   %ax,%ax
  8029c6:	66 90                	xchg   %ax,%ax
  8029c8:	66 90                	xchg   %ax,%ax
  8029ca:	66 90                	xchg   %ax,%ax
  8029cc:	66 90                	xchg   %ax,%ax
  8029ce:	66 90                	xchg   %ax,%ax

008029d0 <__umoddi3>:
  8029d0:	55                   	push   %ebp
  8029d1:	57                   	push   %edi
  8029d2:	56                   	push   %esi
  8029d3:	83 ec 14             	sub    $0x14,%esp
  8029d6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8029da:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8029de:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8029e2:	89 c7                	mov    %eax,%edi
  8029e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029e8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8029ec:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8029f0:	89 34 24             	mov    %esi,(%esp)
  8029f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029f7:	85 c0                	test   %eax,%eax
  8029f9:	89 c2                	mov    %eax,%edx
  8029fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029ff:	75 17                	jne    802a18 <__umoddi3+0x48>
  802a01:	39 fe                	cmp    %edi,%esi
  802a03:	76 4b                	jbe    802a50 <__umoddi3+0x80>
  802a05:	89 c8                	mov    %ecx,%eax
  802a07:	89 fa                	mov    %edi,%edx
  802a09:	f7 f6                	div    %esi
  802a0b:	89 d0                	mov    %edx,%eax
  802a0d:	31 d2                	xor    %edx,%edx
  802a0f:	83 c4 14             	add    $0x14,%esp
  802a12:	5e                   	pop    %esi
  802a13:	5f                   	pop    %edi
  802a14:	5d                   	pop    %ebp
  802a15:	c3                   	ret    
  802a16:	66 90                	xchg   %ax,%ax
  802a18:	39 f8                	cmp    %edi,%eax
  802a1a:	77 54                	ja     802a70 <__umoddi3+0xa0>
  802a1c:	0f bd e8             	bsr    %eax,%ebp
  802a1f:	83 f5 1f             	xor    $0x1f,%ebp
  802a22:	75 5c                	jne    802a80 <__umoddi3+0xb0>
  802a24:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802a28:	39 3c 24             	cmp    %edi,(%esp)
  802a2b:	0f 87 e7 00 00 00    	ja     802b18 <__umoddi3+0x148>
  802a31:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a35:	29 f1                	sub    %esi,%ecx
  802a37:	19 c7                	sbb    %eax,%edi
  802a39:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a3d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a41:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a45:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802a49:	83 c4 14             	add    $0x14,%esp
  802a4c:	5e                   	pop    %esi
  802a4d:	5f                   	pop    %edi
  802a4e:	5d                   	pop    %ebp
  802a4f:	c3                   	ret    
  802a50:	85 f6                	test   %esi,%esi
  802a52:	89 f5                	mov    %esi,%ebp
  802a54:	75 0b                	jne    802a61 <__umoddi3+0x91>
  802a56:	b8 01 00 00 00       	mov    $0x1,%eax
  802a5b:	31 d2                	xor    %edx,%edx
  802a5d:	f7 f6                	div    %esi
  802a5f:	89 c5                	mov    %eax,%ebp
  802a61:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a65:	31 d2                	xor    %edx,%edx
  802a67:	f7 f5                	div    %ebp
  802a69:	89 c8                	mov    %ecx,%eax
  802a6b:	f7 f5                	div    %ebp
  802a6d:	eb 9c                	jmp    802a0b <__umoddi3+0x3b>
  802a6f:	90                   	nop
  802a70:	89 c8                	mov    %ecx,%eax
  802a72:	89 fa                	mov    %edi,%edx
  802a74:	83 c4 14             	add    $0x14,%esp
  802a77:	5e                   	pop    %esi
  802a78:	5f                   	pop    %edi
  802a79:	5d                   	pop    %ebp
  802a7a:	c3                   	ret    
  802a7b:	90                   	nop
  802a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a80:	8b 04 24             	mov    (%esp),%eax
  802a83:	be 20 00 00 00       	mov    $0x20,%esi
  802a88:	89 e9                	mov    %ebp,%ecx
  802a8a:	29 ee                	sub    %ebp,%esi
  802a8c:	d3 e2                	shl    %cl,%edx
  802a8e:	89 f1                	mov    %esi,%ecx
  802a90:	d3 e8                	shr    %cl,%eax
  802a92:	89 e9                	mov    %ebp,%ecx
  802a94:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a98:	8b 04 24             	mov    (%esp),%eax
  802a9b:	09 54 24 04          	or     %edx,0x4(%esp)
  802a9f:	89 fa                	mov    %edi,%edx
  802aa1:	d3 e0                	shl    %cl,%eax
  802aa3:	89 f1                	mov    %esi,%ecx
  802aa5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802aa9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802aad:	d3 ea                	shr    %cl,%edx
  802aaf:	89 e9                	mov    %ebp,%ecx
  802ab1:	d3 e7                	shl    %cl,%edi
  802ab3:	89 f1                	mov    %esi,%ecx
  802ab5:	d3 e8                	shr    %cl,%eax
  802ab7:	89 e9                	mov    %ebp,%ecx
  802ab9:	09 f8                	or     %edi,%eax
  802abb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802abf:	f7 74 24 04          	divl   0x4(%esp)
  802ac3:	d3 e7                	shl    %cl,%edi
  802ac5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ac9:	89 d7                	mov    %edx,%edi
  802acb:	f7 64 24 08          	mull   0x8(%esp)
  802acf:	39 d7                	cmp    %edx,%edi
  802ad1:	89 c1                	mov    %eax,%ecx
  802ad3:	89 14 24             	mov    %edx,(%esp)
  802ad6:	72 2c                	jb     802b04 <__umoddi3+0x134>
  802ad8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802adc:	72 22                	jb     802b00 <__umoddi3+0x130>
  802ade:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802ae2:	29 c8                	sub    %ecx,%eax
  802ae4:	19 d7                	sbb    %edx,%edi
  802ae6:	89 e9                	mov    %ebp,%ecx
  802ae8:	89 fa                	mov    %edi,%edx
  802aea:	d3 e8                	shr    %cl,%eax
  802aec:	89 f1                	mov    %esi,%ecx
  802aee:	d3 e2                	shl    %cl,%edx
  802af0:	89 e9                	mov    %ebp,%ecx
  802af2:	d3 ef                	shr    %cl,%edi
  802af4:	09 d0                	or     %edx,%eax
  802af6:	89 fa                	mov    %edi,%edx
  802af8:	83 c4 14             	add    $0x14,%esp
  802afb:	5e                   	pop    %esi
  802afc:	5f                   	pop    %edi
  802afd:	5d                   	pop    %ebp
  802afe:	c3                   	ret    
  802aff:	90                   	nop
  802b00:	39 d7                	cmp    %edx,%edi
  802b02:	75 da                	jne    802ade <__umoddi3+0x10e>
  802b04:	8b 14 24             	mov    (%esp),%edx
  802b07:	89 c1                	mov    %eax,%ecx
  802b09:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802b0d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802b11:	eb cb                	jmp    802ade <__umoddi3+0x10e>
  802b13:	90                   	nop
  802b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b18:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802b1c:	0f 82 0f ff ff ff    	jb     802a31 <__umoddi3+0x61>
  802b22:	e9 1a ff ff ff       	jmp    802a41 <__umoddi3+0x71>
