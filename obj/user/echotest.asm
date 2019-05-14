
obj/user/echotest.debug:     file format elf32-i386


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
  80002c:	e8 dc 04 00 00       	call   80050d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:

const char *msg = "Hello world!\n";

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	cprintf("%s\n", m);
  800039:	89 44 24 04          	mov    %eax,0x4(%esp)
  80003d:	c7 04 24 20 2b 80 00 	movl   $0x802b20,(%esp)
  800044:	e8 c8 05 00 00       	call   800611 <cprintf>
	exit();
  800049:	e8 07 05 00 00       	call   800555 <exit>
}
  80004e:	c9                   	leave  
  80004f:	c3                   	ret    

00800050 <umain>:

void umain(int argc, char **argv)
{
  800050:	55                   	push   %ebp
  800051:	89 e5                	mov    %esp,%ebp
  800053:	57                   	push   %edi
  800054:	56                   	push   %esi
  800055:	53                   	push   %ebx
  800056:	83 ec 5c             	sub    $0x5c,%esp
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	cprintf("Connecting to:\n");
  800059:	c7 04 24 24 2b 80 00 	movl   $0x802b24,(%esp)
  800060:	e8 ac 05 00 00       	call   800611 <cprintf>
	cprintf("\tip address %s = %x\n", IPADDR, inet_addr(IPADDR));
  800065:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  80006c:	e8 64 04 00 00       	call   8004d5 <inet_addr>
  800071:	89 44 24 08          	mov    %eax,0x8(%esp)
  800075:	c7 44 24 04 34 2b 80 	movl   $0x802b34,0x4(%esp)
  80007c:	00 
  80007d:	c7 04 24 3e 2b 80 00 	movl   $0x802b3e,(%esp)
  800084:	e8 88 05 00 00       	call   800611 <cprintf>

	// Create the TCP socket
	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800089:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800090:	00 
  800091:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800098:	00 
  800099:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8000a0:	e8 02 1e 00 00       	call   801ea7 <socket>
  8000a5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8000a8:	85 c0                	test   %eax,%eax
  8000aa:	79 0a                	jns    8000b6 <umain+0x66>
		die("Failed to create socket");
  8000ac:	b8 53 2b 80 00       	mov    $0x802b53,%eax
  8000b1:	e8 7d ff ff ff       	call   800033 <die>

	cprintf("opened socket\n");
  8000b6:	c7 04 24 6b 2b 80 00 	movl   $0x802b6b,(%esp)
  8000bd:	e8 4f 05 00 00       	call   800611 <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  8000c2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  8000c9:	00 
  8000ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000d1:	00 
  8000d2:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8000d5:	89 1c 24             	mov    %ebx,(%esp)
  8000d8:	e8 aa 0c 00 00       	call   800d87 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  8000dd:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = inet_addr(IPADDR);   // IP address
  8000e1:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  8000e8:	e8 e8 03 00 00       	call   8004d5 <inet_addr>
  8000ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  8000f0:	c7 04 24 10 27 00 00 	movl   $0x2710,(%esp)
  8000f7:	e8 aa 01 00 00       	call   8002a6 <htons>
  8000fc:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to connect to server\n");
  800100:	c7 04 24 7a 2b 80 00 	movl   $0x802b7a,(%esp)
  800107:	e8 05 05 00 00       	call   800611 <cprintf>

	// Establish connection
	if (connect(sock, (struct sockaddr *) &echoserver, sizeof(echoserver)) < 0)
  80010c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800113:	00 
  800114:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800118:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80011b:	89 04 24             	mov    %eax,(%esp)
  80011e:	e8 33 1d 00 00       	call   801e56 <connect>
  800123:	85 c0                	test   %eax,%eax
  800125:	79 0a                	jns    800131 <umain+0xe1>
		die("Failed to connect with server");
  800127:	b8 97 2b 80 00       	mov    $0x802b97,%eax
  80012c:	e8 02 ff ff ff       	call   800033 <die>

	cprintf("connected to server\n");
  800131:	c7 04 24 b5 2b 80 00 	movl   $0x802bb5,(%esp)
  800138:	e8 d4 04 00 00       	call   800611 <cprintf>

	// Send the word to the server
	echolen = strlen(msg);
  80013d:	a1 00 40 80 00       	mov    0x804000,%eax
  800142:	89 04 24             	mov    %eax,(%esp)
  800145:	e8 b6 0a 00 00       	call   800c00 <strlen>
  80014a:	89 c7                	mov    %eax,%edi
  80014c:	89 45 b0             	mov    %eax,-0x50(%ebp)
	if (write(sock, msg, echolen) != echolen)
  80014f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800153:	a1 00 40 80 00       	mov    0x804000,%eax
  800158:	89 44 24 04          	mov    %eax,0x4(%esp)
  80015c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80015f:	89 04 24             	mov    %eax,(%esp)
  800162:	e8 20 16 00 00       	call   801787 <write>
  800167:	39 f8                	cmp    %edi,%eax
  800169:	74 0a                	je     800175 <umain+0x125>
		die("Mismatch in number of sent bytes");
  80016b:	b8 e4 2b 80 00       	mov    $0x802be4,%eax
  800170:	e8 be fe ff ff       	call   800033 <die>

	// Receive the word back from the server
	cprintf("Received: \n");
  800175:	c7 04 24 ca 2b 80 00 	movl   $0x802bca,(%esp)
  80017c:	e8 90 04 00 00       	call   800611 <cprintf>
{
	int sock;
	struct sockaddr_in echoserver;
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;
  800181:	be 00 00 00 00       	mov    $0x0,%esi

	// Receive the word back from the server
	cprintf("Received: \n");
	while (received < echolen) {
		int bytes = 0;
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  800186:	8d 7d b8             	lea    -0x48(%ebp),%edi
	if (write(sock, msg, echolen) != echolen)
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
	while (received < echolen) {
  800189:	eb 36                	jmp    8001c1 <umain+0x171>
		int bytes = 0;
		if ((bytes = read(sock, buffer, BUFFSIZE-1)) < 1) {
  80018b:	c7 44 24 08 1f 00 00 	movl   $0x1f,0x8(%esp)
  800192:	00 
  800193:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800197:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80019a:	89 04 24             	mov    %eax,(%esp)
  80019d:	e8 08 15 00 00       	call   8016aa <read>
  8001a2:	89 c3                	mov    %eax,%ebx
  8001a4:	85 c0                	test   %eax,%eax
  8001a6:	7f 0a                	jg     8001b2 <umain+0x162>
			die("Failed to receive bytes from server");
  8001a8:	b8 08 2c 80 00       	mov    $0x802c08,%eax
  8001ad:	e8 81 fe ff ff       	call   800033 <die>
		}
		received += bytes;
  8001b2:	01 de                	add    %ebx,%esi
		buffer[bytes] = '\0';        // Assure null terminated string
  8001b4:	c6 44 1d b8 00       	movb   $0x0,-0x48(%ebp,%ebx,1)
		cprintf(buffer);
  8001b9:	89 3c 24             	mov    %edi,(%esp)
  8001bc:	e8 50 04 00 00       	call   800611 <cprintf>
	if (write(sock, msg, echolen) != echolen)
		die("Mismatch in number of sent bytes");

	// Receive the word back from the server
	cprintf("Received: \n");
	while (received < echolen) {
  8001c1:	39 75 b0             	cmp    %esi,-0x50(%ebp)
  8001c4:	77 c5                	ja     80018b <umain+0x13b>
		}
		received += bytes;
		buffer[bytes] = '\0';        // Assure null terminated string
		cprintf(buffer);
	}
	cprintf("\n");
  8001c6:	c7 04 24 d4 2b 80 00 	movl   $0x802bd4,(%esp)
  8001cd:	e8 3f 04 00 00       	call   800611 <cprintf>

	close(sock);
  8001d2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8001d5:	89 04 24             	mov    %eax,(%esp)
  8001d8:	e8 6a 13 00 00       	call   801547 <close>
}
  8001dd:	83 c4 5c             	add    $0x5c,%esp
  8001e0:	5b                   	pop    %ebx
  8001e1:	5e                   	pop    %esi
  8001e2:	5f                   	pop    %edi
  8001e3:	5d                   	pop    %ebp
  8001e4:	c3                   	ret    
  8001e5:	66 90                	xchg   %ax,%ax
  8001e7:	66 90                	xchg   %ax,%ax
  8001e9:	66 90                	xchg   %ax,%ax
  8001eb:	66 90                	xchg   %ax,%ax
  8001ed:	66 90                	xchg   %ax,%ax
  8001ef:	90                   	nop

008001f0 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	57                   	push   %edi
  8001f4:	56                   	push   %esi
  8001f5:	53                   	push   %ebx
  8001f6:	83 ec 19             	sub    $0x19,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  8001f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8001ff:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  800203:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  800206:	c7 45 dc 00 50 80 00 	movl   $0x805000,-0x24(%ebp)
 */
char *
inet_ntoa(struct in_addr addr)
{
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80020d:	be 00 00 00 00       	mov    $0x0,%esi
  800212:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800215:	eb 02                	jmp    800219 <inet_ntoa+0x29>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  800217:	89 ce                	mov    %ecx,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800219:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80021c:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  80021f:	0f b6 c2             	movzbl %dl,%eax
  800222:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  800225:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
  800228:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80022b:	66 c1 e8 0b          	shr    $0xb,%ax
  80022f:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  800231:	8d 4e 01             	lea    0x1(%esi),%ecx
  800234:	89 f3                	mov    %esi,%ebx
  800236:	0f b6 f3             	movzbl %bl,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800239:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  80023c:	01 ff                	add    %edi,%edi
  80023e:	89 fb                	mov    %edi,%ebx
  800240:	29 da                	sub    %ebx,%edx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
  800242:	83 c2 30             	add    $0x30,%edx
  800245:	88 54 35 ed          	mov    %dl,-0x13(%ebp,%esi,1)
    } while(*ap);
  800249:	84 c0                	test   %al,%al
  80024b:	75 ca                	jne    800217 <inet_ntoa+0x27>
  80024d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800250:	89 c8                	mov    %ecx,%eax
  800252:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800255:	89 cf                	mov    %ecx,%edi
  800257:	eb 0d                	jmp    800266 <inet_ntoa+0x76>
    while(i--)
      *rp++ = inv[i];
  800259:	0f b6 f0             	movzbl %al,%esi
  80025c:	0f b6 4c 35 ed       	movzbl -0x13(%ebp,%esi,1),%ecx
  800261:	88 0a                	mov    %cl,(%edx)
  800263:	83 c2 01             	add    $0x1,%edx
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  800266:	83 e8 01             	sub    $0x1,%eax
  800269:	3c ff                	cmp    $0xff,%al
  80026b:	75 ec                	jne    800259 <inet_ntoa+0x69>
  80026d:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800270:	89 f9                	mov    %edi,%ecx
  800272:	0f b6 c9             	movzbl %cl,%ecx
  800275:	03 4d dc             	add    -0x24(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  800278:	8d 41 01             	lea    0x1(%ecx),%eax
  80027b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    ap++;
  80027e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  800282:	80 45 db 01          	addb   $0x1,-0x25(%ebp)
  800286:	80 7d db 03          	cmpb   $0x3,-0x25(%ebp)
  80028a:	77 0a                	ja     800296 <inet_ntoa+0xa6>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  80028c:	c6 01 2e             	movb   $0x2e,(%ecx)
  80028f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800294:	eb 81                	jmp    800217 <inet_ntoa+0x27>
    ap++;
  }
  *--rp = 0;
  800296:	c6 01 00             	movb   $0x0,(%ecx)
  return str;
}
  800299:	b8 00 50 80 00       	mov    $0x805000,%eax
  80029e:	83 c4 19             	add    $0x19,%esp
  8002a1:	5b                   	pop    %ebx
  8002a2:	5e                   	pop    %esi
  8002a3:	5f                   	pop    %edi
  8002a4:	5d                   	pop    %ebp
  8002a5:	c3                   	ret    

008002a6 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8002a9:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002ad:	66 c1 c0 08          	rol    $0x8,%ax
}
  8002b1:	5d                   	pop    %ebp
  8002b2:	c3                   	ret    

008002b3 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8002b3:	55                   	push   %ebp
  8002b4:	89 e5                	mov    %esp,%ebp
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8002b6:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002ba:	66 c1 c0 08          	rol    $0x8,%ax
 */
u16_t
ntohs(u16_t n)
{
  return htons(n);
}
  8002be:	5d                   	pop    %ebp
  8002bf:	c3                   	ret    

008002c0 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8002c6:	89 d1                	mov    %edx,%ecx
  8002c8:	c1 e9 18             	shr    $0x18,%ecx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8002cb:	89 d0                	mov    %edx,%eax
  8002cd:	c1 e0 18             	shl    $0x18,%eax
  8002d0:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8002d2:	89 d1                	mov    %edx,%ecx
  8002d4:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  8002da:	c1 e1 08             	shl    $0x8,%ecx
  8002dd:	09 c8                	or     %ecx,%eax
    ((n & 0xff0000UL) >> 8) |
  8002df:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  8002e5:	c1 ea 08             	shr    $0x8,%edx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8002e8:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  8002ea:	5d                   	pop    %ebp
  8002eb:	c3                   	ret    

008002ec <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	57                   	push   %edi
  8002f0:	56                   	push   %esi
  8002f1:	53                   	push   %ebx
  8002f2:	83 ec 20             	sub    $0x20,%esp
  8002f5:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  8002f8:	0f be 10             	movsbl (%eax),%edx
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  8002fb:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8002fe:	89 75 d8             	mov    %esi,-0x28(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  800301:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800304:	80 f9 09             	cmp    $0x9,%cl
  800307:	0f 87 a6 01 00 00    	ja     8004b3 <inet_aton+0x1c7>
      return (0);
    val = 0;
    base = 10;
  80030d:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
    if (c == '0') {
  800314:	83 fa 30             	cmp    $0x30,%edx
  800317:	75 2b                	jne    800344 <inet_aton+0x58>
      c = *++cp;
  800319:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  80031d:	89 d1                	mov    %edx,%ecx
  80031f:	83 e1 df             	and    $0xffffffdf,%ecx
  800322:	80 f9 58             	cmp    $0x58,%cl
  800325:	74 0f                	je     800336 <inet_aton+0x4a>
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
  800327:	83 c0 01             	add    $0x1,%eax
  80032a:	0f be d2             	movsbl %dl,%edx
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
      } else
        base = 8;
  80032d:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  800334:	eb 0e                	jmp    800344 <inet_aton+0x58>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  800336:	0f be 50 02          	movsbl 0x2(%eax),%edx
  80033a:	8d 40 02             	lea    0x2(%eax),%eax
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  80033d:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  800344:	83 c0 01             	add    $0x1,%eax
  800347:	bf 00 00 00 00       	mov    $0x0,%edi
  80034c:	eb 03                	jmp    800351 <inet_aton+0x65>
  80034e:	83 c0 01             	add    $0x1,%eax
  800351:	8d 70 ff             	lea    -0x1(%eax),%esi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  800354:	89 d3                	mov    %edx,%ebx
  800356:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800359:	80 f9 09             	cmp    $0x9,%cl
  80035c:	77 0d                	ja     80036b <inet_aton+0x7f>
        val = (val * base) + (int)(c - '0');
  80035e:	0f af 7d e0          	imul   -0x20(%ebp),%edi
  800362:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  800366:	0f be 10             	movsbl (%eax),%edx
  800369:	eb e3                	jmp    80034e <inet_aton+0x62>
      } else if (base == 16 && isxdigit(c)) {
  80036b:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  80036f:	75 30                	jne    8003a1 <inet_aton+0xb5>
  800371:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
  800374:	88 4d df             	mov    %cl,-0x21(%ebp)
  800377:	89 d1                	mov    %edx,%ecx
  800379:	83 e1 df             	and    $0xffffffdf,%ecx
  80037c:	83 e9 41             	sub    $0x41,%ecx
  80037f:	80 f9 05             	cmp    $0x5,%cl
  800382:	77 23                	ja     8003a7 <inet_aton+0xbb>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800384:	89 fb                	mov    %edi,%ebx
  800386:	c1 e3 04             	shl    $0x4,%ebx
  800389:	8d 7a 0a             	lea    0xa(%edx),%edi
  80038c:	80 7d df 1a          	cmpb   $0x1a,-0x21(%ebp)
  800390:	19 c9                	sbb    %ecx,%ecx
  800392:	83 e1 20             	and    $0x20,%ecx
  800395:	83 c1 41             	add    $0x41,%ecx
  800398:	29 cf                	sub    %ecx,%edi
  80039a:	09 df                	or     %ebx,%edi
        c = *++cp;
  80039c:	0f be 10             	movsbl (%eax),%edx
  80039f:	eb ad                	jmp    80034e <inet_aton+0x62>
  8003a1:	89 d0                	mov    %edx,%eax
  8003a3:	89 f9                	mov    %edi,%ecx
  8003a5:	eb 04                	jmp    8003ab <inet_aton+0xbf>
  8003a7:	89 d0                	mov    %edx,%eax
  8003a9:	89 f9                	mov    %edi,%ecx
      } else
        break;
    }
    if (c == '.') {
  8003ab:	83 f8 2e             	cmp    $0x2e,%eax
  8003ae:	75 22                	jne    8003d2 <inet_aton+0xe6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8003b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8003b3:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8003b6:	0f 84 fe 00 00 00    	je     8004ba <inet_aton+0x1ce>
        return (0);
      *pp++ = val;
  8003bc:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  8003c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c3:	89 48 fc             	mov    %ecx,-0x4(%eax)
      c = *++cp;
  8003c6:	8d 46 01             	lea    0x1(%esi),%eax
  8003c9:	0f be 56 01          	movsbl 0x1(%esi),%edx
    } else
      break;
  }
  8003cd:	e9 2f ff ff ff       	jmp    800301 <inet_aton+0x15>
  8003d2:	89 f9                	mov    %edi,%ecx
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003d4:	85 d2                	test   %edx,%edx
  8003d6:	74 27                	je     8003ff <inet_aton+0x113>
    return (0);
  8003d8:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003dd:	80 fb 1f             	cmp    $0x1f,%bl
  8003e0:	0f 86 e7 00 00 00    	jbe    8004cd <inet_aton+0x1e1>
  8003e6:	84 d2                	test   %dl,%dl
  8003e8:	0f 88 d3 00 00 00    	js     8004c1 <inet_aton+0x1d5>
  8003ee:	83 fa 20             	cmp    $0x20,%edx
  8003f1:	74 0c                	je     8003ff <inet_aton+0x113>
  8003f3:	83 ea 09             	sub    $0x9,%edx
  8003f6:	83 fa 04             	cmp    $0x4,%edx
  8003f9:	0f 87 ce 00 00 00    	ja     8004cd <inet_aton+0x1e1>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  8003ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800402:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800405:	29 c2                	sub    %eax,%edx
  800407:	c1 fa 02             	sar    $0x2,%edx
  80040a:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  80040d:	83 fa 02             	cmp    $0x2,%edx
  800410:	74 22                	je     800434 <inet_aton+0x148>
  800412:	83 fa 02             	cmp    $0x2,%edx
  800415:	7f 0f                	jg     800426 <inet_aton+0x13a>

  case 0:
    return (0);       /* initial nondigit */
  800417:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  80041c:	85 d2                	test   %edx,%edx
  80041e:	0f 84 a9 00 00 00    	je     8004cd <inet_aton+0x1e1>
  800424:	eb 73                	jmp    800499 <inet_aton+0x1ad>
  800426:	83 fa 03             	cmp    $0x3,%edx
  800429:	74 26                	je     800451 <inet_aton+0x165>
  80042b:	83 fa 04             	cmp    $0x4,%edx
  80042e:	66 90                	xchg   %ax,%ax
  800430:	74 40                	je     800472 <inet_aton+0x186>
  800432:	eb 65                	jmp    800499 <inet_aton+0x1ad>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  800434:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  800439:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  80043f:	0f 87 88 00 00 00    	ja     8004cd <inet_aton+0x1e1>
      return (0);
    val |= parts[0] << 24;
  800445:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800448:	c1 e0 18             	shl    $0x18,%eax
  80044b:	89 cf                	mov    %ecx,%edi
  80044d:	09 c7                	or     %eax,%edi
    break;
  80044f:	eb 48                	jmp    800499 <inet_aton+0x1ad>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  800451:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  800456:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  80045c:	77 6f                	ja     8004cd <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  80045e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800461:	c1 e2 10             	shl    $0x10,%edx
  800464:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800467:	c1 e0 18             	shl    $0x18,%eax
  80046a:	09 d0                	or     %edx,%eax
  80046c:	09 c8                	or     %ecx,%eax
  80046e:	89 c7                	mov    %eax,%edi
    break;
  800470:	eb 27                	jmp    800499 <inet_aton+0x1ad>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  800472:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  800477:	81 f9 ff 00 00 00    	cmp    $0xff,%ecx
  80047d:	77 4e                	ja     8004cd <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80047f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800482:	c1 e2 10             	shl    $0x10,%edx
  800485:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800488:	c1 e0 18             	shl    $0x18,%eax
  80048b:	09 c2                	or     %eax,%edx
  80048d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800490:	c1 e0 08             	shl    $0x8,%eax
  800493:	09 d0                	or     %edx,%eax
  800495:	09 c8                	or     %ecx,%eax
  800497:	89 c7                	mov    %eax,%edi
    break;
  }
  if (addr)
  800499:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80049d:	74 29                	je     8004c8 <inet_aton+0x1dc>
    addr->s_addr = htonl(val);
  80049f:	89 3c 24             	mov    %edi,(%esp)
  8004a2:	e8 19 fe ff ff       	call   8002c0 <htonl>
  8004a7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004aa:	89 06                	mov    %eax,(%esi)
  return (1);
  8004ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8004b1:	eb 1a                	jmp    8004cd <inet_aton+0x1e1>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  8004b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b8:	eb 13                	jmp    8004cd <inet_aton+0x1e1>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  8004ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bf:	eb 0c                	jmp    8004cd <inet_aton+0x1e1>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  8004c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c6:	eb 05                	jmp    8004cd <inet_aton+0x1e1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  8004c8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8004cd:	83 c4 20             	add    $0x20,%esp
  8004d0:	5b                   	pop    %ebx
  8004d1:	5e                   	pop    %esi
  8004d2:	5f                   	pop    %edi
  8004d3:	5d                   	pop    %ebp
  8004d4:	c3                   	ret    

008004d5 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8004d5:	55                   	push   %ebp
  8004d6:	89 e5                	mov    %esp,%ebp
  8004d8:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8004db:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8004de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	89 04 24             	mov    %eax,(%esp)
  8004e8:	e8 ff fd ff ff       	call   8002ec <inet_aton>
  8004ed:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  8004ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8004f4:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  8004f8:	c9                   	leave  
  8004f9:	c3                   	ret    

008004fa <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
  8004fd:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	89 04 24             	mov    %eax,(%esp)
  800506:	e8 b5 fd ff ff       	call   8002c0 <htonl>
}
  80050b:	c9                   	leave  
  80050c:	c3                   	ret    

0080050d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80050d:	55                   	push   %ebp
  80050e:	89 e5                	mov    %esp,%ebp
  800510:	56                   	push   %esi
  800511:	53                   	push   %ebx
  800512:	83 ec 10             	sub    $0x10,%esp
  800515:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800518:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80051b:	e8 f5 0a 00 00       	call   801015 <sys_getenvid>
  800520:	25 ff 03 00 00       	and    $0x3ff,%eax
  800525:	c1 e0 07             	shl    $0x7,%eax
  800528:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80052d:	a3 18 50 80 00       	mov    %eax,0x805018

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800532:	85 db                	test   %ebx,%ebx
  800534:	7e 07                	jle    80053d <libmain+0x30>
		binaryname = argv[0];
  800536:	8b 06                	mov    (%esi),%eax
  800538:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  80053d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800541:	89 1c 24             	mov    %ebx,(%esp)
  800544:	e8 07 fb ff ff       	call   800050 <umain>

	// exit gracefully
	exit();
  800549:	e8 07 00 00 00       	call   800555 <exit>
}
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	5b                   	pop    %ebx
  800552:	5e                   	pop    %esi
  800553:	5d                   	pop    %ebp
  800554:	c3                   	ret    

00800555 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80055b:	e8 1a 10 00 00       	call   80157a <close_all>
	sys_env_destroy(0);
  800560:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800567:	e8 57 0a 00 00       	call   800fc3 <sys_env_destroy>
}
  80056c:	c9                   	leave  
  80056d:	c3                   	ret    

0080056e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
  800571:	53                   	push   %ebx
  800572:	83 ec 14             	sub    $0x14,%esp
  800575:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800578:	8b 13                	mov    (%ebx),%edx
  80057a:	8d 42 01             	lea    0x1(%edx),%eax
  80057d:	89 03                	mov    %eax,(%ebx)
  80057f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800582:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800586:	3d ff 00 00 00       	cmp    $0xff,%eax
  80058b:	75 19                	jne    8005a6 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80058d:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800594:	00 
  800595:	8d 43 08             	lea    0x8(%ebx),%eax
  800598:	89 04 24             	mov    %eax,(%esp)
  80059b:	e8 e6 09 00 00       	call   800f86 <sys_cputs>
		b->idx = 0;
  8005a0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8005a6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8005aa:	83 c4 14             	add    $0x14,%esp
  8005ad:	5b                   	pop    %ebx
  8005ae:	5d                   	pop    %ebp
  8005af:	c3                   	ret    

008005b0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005b0:	55                   	push   %ebp
  8005b1:	89 e5                	mov    %esp,%ebp
  8005b3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8005b9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c0:	00 00 00 
	b.cnt = 0;
  8005c3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005ca:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005e5:	c7 04 24 6e 05 80 00 	movl   $0x80056e,(%esp)
  8005ec:	e8 ad 01 00 00       	call   80079e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005f1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8005f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005fb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800601:	89 04 24             	mov    %eax,(%esp)
  800604:	e8 7d 09 00 00       	call   800f86 <sys_cputs>

	return b.cnt;
}
  800609:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80060f:	c9                   	leave  
  800610:	c3                   	ret    

00800611 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800611:	55                   	push   %ebp
  800612:	89 e5                	mov    %esp,%ebp
  800614:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800617:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80061a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80061e:	8b 45 08             	mov    0x8(%ebp),%eax
  800621:	89 04 24             	mov    %eax,(%esp)
  800624:	e8 87 ff ff ff       	call   8005b0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800629:	c9                   	leave  
  80062a:	c3                   	ret    
  80062b:	66 90                	xchg   %ax,%ax
  80062d:	66 90                	xchg   %ax,%ax
  80062f:	90                   	nop

00800630 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800630:	55                   	push   %ebp
  800631:	89 e5                	mov    %esp,%ebp
  800633:	57                   	push   %edi
  800634:	56                   	push   %esi
  800635:	53                   	push   %ebx
  800636:	83 ec 3c             	sub    $0x3c,%esp
  800639:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80063c:	89 d7                	mov    %edx,%edi
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800644:	8b 45 0c             	mov    0xc(%ebp),%eax
  800647:	89 c3                	mov    %eax,%ebx
  800649:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80064c:	8b 45 10             	mov    0x10(%ebp),%eax
  80064f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800652:	b9 00 00 00 00       	mov    $0x0,%ecx
  800657:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80065d:	39 d9                	cmp    %ebx,%ecx
  80065f:	72 05                	jb     800666 <printnum+0x36>
  800661:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800664:	77 69                	ja     8006cf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800666:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800669:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80066d:	83 ee 01             	sub    $0x1,%esi
  800670:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800674:	89 44 24 08          	mov    %eax,0x8(%esp)
  800678:	8b 44 24 08          	mov    0x8(%esp),%eax
  80067c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800680:	89 c3                	mov    %eax,%ebx
  800682:	89 d6                	mov    %edx,%esi
  800684:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800687:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80068a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80068e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800692:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800695:	89 04 24             	mov    %eax,(%esp)
  800698:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80069b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80069f:	e8 dc 21 00 00       	call   802880 <__udivdi3>
  8006a4:	89 d9                	mov    %ebx,%ecx
  8006a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006aa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006ae:	89 04 24             	mov    %eax,(%esp)
  8006b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006b5:	89 fa                	mov    %edi,%edx
  8006b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ba:	e8 71 ff ff ff       	call   800630 <printnum>
  8006bf:	eb 1b                	jmp    8006dc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006c1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c5:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c8:	89 04 24             	mov    %eax,(%esp)
  8006cb:	ff d3                	call   *%ebx
  8006cd:	eb 03                	jmp    8006d2 <printnum+0xa2>
  8006cf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006d2:	83 ee 01             	sub    $0x1,%esi
  8006d5:	85 f6                	test   %esi,%esi
  8006d7:	7f e8                	jg     8006c1 <printnum+0x91>
  8006d9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006e0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8006e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006ee:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006f5:	89 04 24             	mov    %eax,(%esp)
  8006f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ff:	e8 ac 22 00 00       	call   8029b0 <__umoddi3>
  800704:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800708:	0f be 80 36 2c 80 00 	movsbl 0x802c36(%eax),%eax
  80070f:	89 04 24             	mov    %eax,(%esp)
  800712:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800715:	ff d0                	call   *%eax
}
  800717:	83 c4 3c             	add    $0x3c,%esp
  80071a:	5b                   	pop    %ebx
  80071b:	5e                   	pop    %esi
  80071c:	5f                   	pop    %edi
  80071d:	5d                   	pop    %ebp
  80071e:	c3                   	ret    

0080071f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800722:	83 fa 01             	cmp    $0x1,%edx
  800725:	7e 0e                	jle    800735 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800727:	8b 10                	mov    (%eax),%edx
  800729:	8d 4a 08             	lea    0x8(%edx),%ecx
  80072c:	89 08                	mov    %ecx,(%eax)
  80072e:	8b 02                	mov    (%edx),%eax
  800730:	8b 52 04             	mov    0x4(%edx),%edx
  800733:	eb 22                	jmp    800757 <getuint+0x38>
	else if (lflag)
  800735:	85 d2                	test   %edx,%edx
  800737:	74 10                	je     800749 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800739:	8b 10                	mov    (%eax),%edx
  80073b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80073e:	89 08                	mov    %ecx,(%eax)
  800740:	8b 02                	mov    (%edx),%eax
  800742:	ba 00 00 00 00       	mov    $0x0,%edx
  800747:	eb 0e                	jmp    800757 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800749:	8b 10                	mov    (%eax),%edx
  80074b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80074e:	89 08                	mov    %ecx,(%eax)
  800750:	8b 02                	mov    (%edx),%eax
  800752:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800757:	5d                   	pop    %ebp
  800758:	c3                   	ret    

00800759 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800759:	55                   	push   %ebp
  80075a:	89 e5                	mov    %esp,%ebp
  80075c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80075f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800763:	8b 10                	mov    (%eax),%edx
  800765:	3b 50 04             	cmp    0x4(%eax),%edx
  800768:	73 0a                	jae    800774 <sprintputch+0x1b>
		*b->buf++ = ch;
  80076a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80076d:	89 08                	mov    %ecx,(%eax)
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	88 02                	mov    %al,(%edx)
}
  800774:	5d                   	pop    %ebp
  800775:	c3                   	ret    

00800776 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800776:	55                   	push   %ebp
  800777:	89 e5                	mov    %esp,%ebp
  800779:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80077c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80077f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800783:	8b 45 10             	mov    0x10(%ebp),%eax
  800786:	89 44 24 08          	mov    %eax,0x8(%esp)
  80078a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	89 04 24             	mov    %eax,(%esp)
  800797:	e8 02 00 00 00       	call   80079e <vprintfmt>
	va_end(ap);
}
  80079c:	c9                   	leave  
  80079d:	c3                   	ret    

0080079e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80079e:	55                   	push   %ebp
  80079f:	89 e5                	mov    %esp,%ebp
  8007a1:	57                   	push   %edi
  8007a2:	56                   	push   %esi
  8007a3:	53                   	push   %ebx
  8007a4:	83 ec 3c             	sub    $0x3c,%esp
  8007a7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8007aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007ad:	eb 14                	jmp    8007c3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8007af:	85 c0                	test   %eax,%eax
  8007b1:	0f 84 b3 03 00 00    	je     800b6a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8007b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007bb:	89 04 24             	mov    %eax,(%esp)
  8007be:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c1:	89 f3                	mov    %esi,%ebx
  8007c3:	8d 73 01             	lea    0x1(%ebx),%esi
  8007c6:	0f b6 03             	movzbl (%ebx),%eax
  8007c9:	83 f8 25             	cmp    $0x25,%eax
  8007cc:	75 e1                	jne    8007af <vprintfmt+0x11>
  8007ce:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8007d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8007d9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8007e0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8007e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ec:	eb 1d                	jmp    80080b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ee:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8007f0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8007f4:	eb 15                	jmp    80080b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007f6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007f8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8007fc:	eb 0d                	jmp    80080b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8007fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800801:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800804:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80080b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80080e:	0f b6 0e             	movzbl (%esi),%ecx
  800811:	0f b6 c1             	movzbl %cl,%eax
  800814:	83 e9 23             	sub    $0x23,%ecx
  800817:	80 f9 55             	cmp    $0x55,%cl
  80081a:	0f 87 2a 03 00 00    	ja     800b4a <vprintfmt+0x3ac>
  800820:	0f b6 c9             	movzbl %cl,%ecx
  800823:	ff 24 8d 80 2d 80 00 	jmp    *0x802d80(,%ecx,4)
  80082a:	89 de                	mov    %ebx,%esi
  80082c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800831:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800834:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800838:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80083b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80083e:	83 fb 09             	cmp    $0x9,%ebx
  800841:	77 36                	ja     800879 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800843:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800846:	eb e9                	jmp    800831 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800848:	8b 45 14             	mov    0x14(%ebp),%eax
  80084b:	8d 48 04             	lea    0x4(%eax),%ecx
  80084e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800851:	8b 00                	mov    (%eax),%eax
  800853:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800856:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800858:	eb 22                	jmp    80087c <vprintfmt+0xde>
  80085a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80085d:	85 c9                	test   %ecx,%ecx
  80085f:	b8 00 00 00 00       	mov    $0x0,%eax
  800864:	0f 49 c1             	cmovns %ecx,%eax
  800867:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80086a:	89 de                	mov    %ebx,%esi
  80086c:	eb 9d                	jmp    80080b <vprintfmt+0x6d>
  80086e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800870:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800877:	eb 92                	jmp    80080b <vprintfmt+0x6d>
  800879:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80087c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800880:	79 89                	jns    80080b <vprintfmt+0x6d>
  800882:	e9 77 ff ff ff       	jmp    8007fe <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800887:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80088a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80088c:	e9 7a ff ff ff       	jmp    80080b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	8d 50 04             	lea    0x4(%eax),%edx
  800897:	89 55 14             	mov    %edx,0x14(%ebp)
  80089a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80089e:	8b 00                	mov    (%eax),%eax
  8008a0:	89 04 24             	mov    %eax,(%esp)
  8008a3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008a6:	e9 18 ff ff ff       	jmp    8007c3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ae:	8d 50 04             	lea    0x4(%eax),%edx
  8008b1:	89 55 14             	mov    %edx,0x14(%ebp)
  8008b4:	8b 00                	mov    (%eax),%eax
  8008b6:	99                   	cltd   
  8008b7:	31 d0                	xor    %edx,%eax
  8008b9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008bb:	83 f8 11             	cmp    $0x11,%eax
  8008be:	7f 0b                	jg     8008cb <vprintfmt+0x12d>
  8008c0:	8b 14 85 e0 2e 80 00 	mov    0x802ee0(,%eax,4),%edx
  8008c7:	85 d2                	test   %edx,%edx
  8008c9:	75 20                	jne    8008eb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8008cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008cf:	c7 44 24 08 4e 2c 80 	movl   $0x802c4e,0x8(%esp)
  8008d6:	00 
  8008d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	89 04 24             	mov    %eax,(%esp)
  8008e1:	e8 90 fe ff ff       	call   800776 <printfmt>
  8008e6:	e9 d8 fe ff ff       	jmp    8007c3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8008eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008ef:	c7 44 24 08 1d 30 80 	movl   $0x80301d,0x8(%esp)
  8008f6:	00 
  8008f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 04 24             	mov    %eax,(%esp)
  800901:	e8 70 fe ff ff       	call   800776 <printfmt>
  800906:	e9 b8 fe ff ff       	jmp    8007c3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80090b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80090e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800911:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800914:	8b 45 14             	mov    0x14(%ebp),%eax
  800917:	8d 50 04             	lea    0x4(%eax),%edx
  80091a:	89 55 14             	mov    %edx,0x14(%ebp)
  80091d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80091f:	85 f6                	test   %esi,%esi
  800921:	b8 47 2c 80 00       	mov    $0x802c47,%eax
  800926:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800929:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80092d:	0f 84 97 00 00 00    	je     8009ca <vprintfmt+0x22c>
  800933:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800937:	0f 8e 9b 00 00 00    	jle    8009d8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80093d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800941:	89 34 24             	mov    %esi,(%esp)
  800944:	e8 cf 02 00 00       	call   800c18 <strnlen>
  800949:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80094c:	29 c2                	sub    %eax,%edx
  80094e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800951:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800955:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800958:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80095b:	8b 75 08             	mov    0x8(%ebp),%esi
  80095e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800961:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800963:	eb 0f                	jmp    800974 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800965:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800969:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80096c:	89 04 24             	mov    %eax,(%esp)
  80096f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800971:	83 eb 01             	sub    $0x1,%ebx
  800974:	85 db                	test   %ebx,%ebx
  800976:	7f ed                	jg     800965 <vprintfmt+0x1c7>
  800978:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80097b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80097e:	85 d2                	test   %edx,%edx
  800980:	b8 00 00 00 00       	mov    $0x0,%eax
  800985:	0f 49 c2             	cmovns %edx,%eax
  800988:	29 c2                	sub    %eax,%edx
  80098a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80098d:	89 d7                	mov    %edx,%edi
  80098f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800992:	eb 50                	jmp    8009e4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800994:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800998:	74 1e                	je     8009b8 <vprintfmt+0x21a>
  80099a:	0f be d2             	movsbl %dl,%edx
  80099d:	83 ea 20             	sub    $0x20,%edx
  8009a0:	83 fa 5e             	cmp    $0x5e,%edx
  8009a3:	76 13                	jbe    8009b8 <vprintfmt+0x21a>
					putch('?', putdat);
  8009a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ac:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8009b3:	ff 55 08             	call   *0x8(%ebp)
  8009b6:	eb 0d                	jmp    8009c5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8009b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009bf:	89 04 24             	mov    %eax,(%esp)
  8009c2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009c5:	83 ef 01             	sub    $0x1,%edi
  8009c8:	eb 1a                	jmp    8009e4 <vprintfmt+0x246>
  8009ca:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8009cd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8009d0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009d3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009d6:	eb 0c                	jmp    8009e4 <vprintfmt+0x246>
  8009d8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8009db:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8009de:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009e1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009e4:	83 c6 01             	add    $0x1,%esi
  8009e7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8009eb:	0f be c2             	movsbl %dl,%eax
  8009ee:	85 c0                	test   %eax,%eax
  8009f0:	74 27                	je     800a19 <vprintfmt+0x27b>
  8009f2:	85 db                	test   %ebx,%ebx
  8009f4:	78 9e                	js     800994 <vprintfmt+0x1f6>
  8009f6:	83 eb 01             	sub    $0x1,%ebx
  8009f9:	79 99                	jns    800994 <vprintfmt+0x1f6>
  8009fb:	89 f8                	mov    %edi,%eax
  8009fd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a00:	8b 75 08             	mov    0x8(%ebp),%esi
  800a03:	89 c3                	mov    %eax,%ebx
  800a05:	eb 1a                	jmp    800a21 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a07:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a0b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800a12:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a14:	83 eb 01             	sub    $0x1,%ebx
  800a17:	eb 08                	jmp    800a21 <vprintfmt+0x283>
  800a19:	89 fb                	mov    %edi,%ebx
  800a1b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a1e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a21:	85 db                	test   %ebx,%ebx
  800a23:	7f e2                	jg     800a07 <vprintfmt+0x269>
  800a25:	89 75 08             	mov    %esi,0x8(%ebp)
  800a28:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800a2b:	e9 93 fd ff ff       	jmp    8007c3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800a30:	83 fa 01             	cmp    $0x1,%edx
  800a33:	7e 16                	jle    800a4b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	8d 50 08             	lea    0x8(%eax),%edx
  800a3b:	89 55 14             	mov    %edx,0x14(%ebp)
  800a3e:	8b 50 04             	mov    0x4(%eax),%edx
  800a41:	8b 00                	mov    (%eax),%eax
  800a43:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a46:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a49:	eb 32                	jmp    800a7d <vprintfmt+0x2df>
	else if (lflag)
  800a4b:	85 d2                	test   %edx,%edx
  800a4d:	74 18                	je     800a67 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800a4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a52:	8d 50 04             	lea    0x4(%eax),%edx
  800a55:	89 55 14             	mov    %edx,0x14(%ebp)
  800a58:	8b 30                	mov    (%eax),%esi
  800a5a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800a5d:	89 f0                	mov    %esi,%eax
  800a5f:	c1 f8 1f             	sar    $0x1f,%eax
  800a62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a65:	eb 16                	jmp    800a7d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800a67:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6a:	8d 50 04             	lea    0x4(%eax),%edx
  800a6d:	89 55 14             	mov    %edx,0x14(%ebp)
  800a70:	8b 30                	mov    (%eax),%esi
  800a72:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800a75:	89 f0                	mov    %esi,%eax
  800a77:	c1 f8 1f             	sar    $0x1f,%eax
  800a7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800a83:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800a88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a8c:	0f 89 80 00 00 00    	jns    800b12 <vprintfmt+0x374>
				putch('-', putdat);
  800a92:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a96:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800a9d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800aa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aa3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800aa6:	f7 d8                	neg    %eax
  800aa8:	83 d2 00             	adc    $0x0,%edx
  800aab:	f7 da                	neg    %edx
			}
			base = 10;
  800aad:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ab2:	eb 5e                	jmp    800b12 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ab4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ab7:	e8 63 fc ff ff       	call   80071f <getuint>
			base = 10;
  800abc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800ac1:	eb 4f                	jmp    800b12 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800ac3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac6:	e8 54 fc ff ff       	call   80071f <getuint>
			base = 8;
  800acb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800ad0:	eb 40                	jmp    800b12 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800ad2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ad6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800add:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800ae0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ae4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800aeb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800aee:	8b 45 14             	mov    0x14(%ebp),%eax
  800af1:	8d 50 04             	lea    0x4(%eax),%edx
  800af4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800af7:	8b 00                	mov    (%eax),%eax
  800af9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800afe:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800b03:	eb 0d                	jmp    800b12 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b05:	8d 45 14             	lea    0x14(%ebp),%eax
  800b08:	e8 12 fc ff ff       	call   80071f <getuint>
			base = 16;
  800b0d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b12:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800b16:	89 74 24 10          	mov    %esi,0x10(%esp)
  800b1a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800b1d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800b21:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800b25:	89 04 24             	mov    %eax,(%esp)
  800b28:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b2c:	89 fa                	mov    %edi,%edx
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	e8 fa fa ff ff       	call   800630 <printnum>
			break;
  800b36:	e9 88 fc ff ff       	jmp    8007c3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b3b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b3f:	89 04 24             	mov    %eax,(%esp)
  800b42:	ff 55 08             	call   *0x8(%ebp)
			break;
  800b45:	e9 79 fc ff ff       	jmp    8007c3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b4a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b4e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800b55:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b58:	89 f3                	mov    %esi,%ebx
  800b5a:	eb 03                	jmp    800b5f <vprintfmt+0x3c1>
  800b5c:	83 eb 01             	sub    $0x1,%ebx
  800b5f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800b63:	75 f7                	jne    800b5c <vprintfmt+0x3be>
  800b65:	e9 59 fc ff ff       	jmp    8007c3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800b6a:	83 c4 3c             	add    $0x3c,%esp
  800b6d:	5b                   	pop    %ebx
  800b6e:	5e                   	pop    %esi
  800b6f:	5f                   	pop    %edi
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	83 ec 28             	sub    $0x28,%esp
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b81:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b85:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b8f:	85 c0                	test   %eax,%eax
  800b91:	74 30                	je     800bc3 <vsnprintf+0x51>
  800b93:	85 d2                	test   %edx,%edx
  800b95:	7e 2c                	jle    800bc3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b97:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ba5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bac:	c7 04 24 59 07 80 00 	movl   $0x800759,(%esp)
  800bb3:	e8 e6 fb ff ff       	call   80079e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bc1:	eb 05                	jmp    800bc8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800bc3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800bc8:	c9                   	leave  
  800bc9:	c3                   	ret    

00800bca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bd0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bd3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bda:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	89 04 24             	mov    %eax,(%esp)
  800beb:	e8 82 ff ff ff       	call   800b72 <vsnprintf>
	va_end(ap);

	return rc;
}
  800bf0:	c9                   	leave  
  800bf1:	c3                   	ret    
  800bf2:	66 90                	xchg   %ax,%ax
  800bf4:	66 90                	xchg   %ax,%ax
  800bf6:	66 90                	xchg   %ax,%ax
  800bf8:	66 90                	xchg   %ax,%ax
  800bfa:	66 90                	xchg   %ax,%ax
  800bfc:	66 90                	xchg   %ax,%ax
  800bfe:	66 90                	xchg   %ax,%ax

00800c00 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c06:	b8 00 00 00 00       	mov    $0x0,%eax
  800c0b:	eb 03                	jmp    800c10 <strlen+0x10>
		n++;
  800c0d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c10:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c14:	75 f7                	jne    800c0d <strlen+0xd>
		n++;
	return n;
}
  800c16:	5d                   	pop    %ebp
  800c17:	c3                   	ret    

00800c18 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c1e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c21:	b8 00 00 00 00       	mov    $0x0,%eax
  800c26:	eb 03                	jmp    800c2b <strnlen+0x13>
		n++;
  800c28:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c2b:	39 d0                	cmp    %edx,%eax
  800c2d:	74 06                	je     800c35 <strnlen+0x1d>
  800c2f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800c33:	75 f3                	jne    800c28 <strnlen+0x10>
		n++;
	return n;
}
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	53                   	push   %ebx
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c41:	89 c2                	mov    %eax,%edx
  800c43:	83 c2 01             	add    $0x1,%edx
  800c46:	83 c1 01             	add    $0x1,%ecx
  800c49:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800c4d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c50:	84 db                	test   %bl,%bl
  800c52:	75 ef                	jne    800c43 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800c54:	5b                   	pop    %ebx
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    

00800c57 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	53                   	push   %ebx
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c61:	89 1c 24             	mov    %ebx,(%esp)
  800c64:	e8 97 ff ff ff       	call   800c00 <strlen>
	strcpy(dst + len, src);
  800c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c70:	01 d8                	add    %ebx,%eax
  800c72:	89 04 24             	mov    %eax,(%esp)
  800c75:	e8 bd ff ff ff       	call   800c37 <strcpy>
	return dst;
}
  800c7a:	89 d8                	mov    %ebx,%eax
  800c7c:	83 c4 08             	add    $0x8,%esp
  800c7f:	5b                   	pop    %ebx
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	56                   	push   %esi
  800c86:	53                   	push   %ebx
  800c87:	8b 75 08             	mov    0x8(%ebp),%esi
  800c8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c8d:	89 f3                	mov    %esi,%ebx
  800c8f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c92:	89 f2                	mov    %esi,%edx
  800c94:	eb 0f                	jmp    800ca5 <strncpy+0x23>
		*dst++ = *src;
  800c96:	83 c2 01             	add    $0x1,%edx
  800c99:	0f b6 01             	movzbl (%ecx),%eax
  800c9c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c9f:	80 39 01             	cmpb   $0x1,(%ecx)
  800ca2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ca5:	39 da                	cmp    %ebx,%edx
  800ca7:	75 ed                	jne    800c96 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800ca9:	89 f0                	mov    %esi,%eax
  800cab:	5b                   	pop    %ebx
  800cac:	5e                   	pop    %esi
  800cad:	5d                   	pop    %ebp
  800cae:	c3                   	ret    

00800caf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	56                   	push   %esi
  800cb3:	53                   	push   %ebx
  800cb4:	8b 75 08             	mov    0x8(%ebp),%esi
  800cb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800cbd:	89 f0                	mov    %esi,%eax
  800cbf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800cc3:	85 c9                	test   %ecx,%ecx
  800cc5:	75 0b                	jne    800cd2 <strlcpy+0x23>
  800cc7:	eb 1d                	jmp    800ce6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800cc9:	83 c0 01             	add    $0x1,%eax
  800ccc:	83 c2 01             	add    $0x1,%edx
  800ccf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd2:	39 d8                	cmp    %ebx,%eax
  800cd4:	74 0b                	je     800ce1 <strlcpy+0x32>
  800cd6:	0f b6 0a             	movzbl (%edx),%ecx
  800cd9:	84 c9                	test   %cl,%cl
  800cdb:	75 ec                	jne    800cc9 <strlcpy+0x1a>
  800cdd:	89 c2                	mov    %eax,%edx
  800cdf:	eb 02                	jmp    800ce3 <strlcpy+0x34>
  800ce1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800ce3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800ce6:	29 f0                	sub    %esi,%eax
}
  800ce8:	5b                   	pop    %ebx
  800ce9:	5e                   	pop    %esi
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    

00800cec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cf2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cf5:	eb 06                	jmp    800cfd <strcmp+0x11>
		p++, q++;
  800cf7:	83 c1 01             	add    $0x1,%ecx
  800cfa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cfd:	0f b6 01             	movzbl (%ecx),%eax
  800d00:	84 c0                	test   %al,%al
  800d02:	74 04                	je     800d08 <strcmp+0x1c>
  800d04:	3a 02                	cmp    (%edx),%al
  800d06:	74 ef                	je     800cf7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d08:	0f b6 c0             	movzbl %al,%eax
  800d0b:	0f b6 12             	movzbl (%edx),%edx
  800d0e:	29 d0                	sub    %edx,%eax
}
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	53                   	push   %ebx
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1c:	89 c3                	mov    %eax,%ebx
  800d1e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d21:	eb 06                	jmp    800d29 <strncmp+0x17>
		n--, p++, q++;
  800d23:	83 c0 01             	add    $0x1,%eax
  800d26:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800d29:	39 d8                	cmp    %ebx,%eax
  800d2b:	74 15                	je     800d42 <strncmp+0x30>
  800d2d:	0f b6 08             	movzbl (%eax),%ecx
  800d30:	84 c9                	test   %cl,%cl
  800d32:	74 04                	je     800d38 <strncmp+0x26>
  800d34:	3a 0a                	cmp    (%edx),%cl
  800d36:	74 eb                	je     800d23 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d38:	0f b6 00             	movzbl (%eax),%eax
  800d3b:	0f b6 12             	movzbl (%edx),%edx
  800d3e:	29 d0                	sub    %edx,%eax
  800d40:	eb 05                	jmp    800d47 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800d42:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800d47:	5b                   	pop    %ebx
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d54:	eb 07                	jmp    800d5d <strchr+0x13>
		if (*s == c)
  800d56:	38 ca                	cmp    %cl,%dl
  800d58:	74 0f                	je     800d69 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d5a:	83 c0 01             	add    $0x1,%eax
  800d5d:	0f b6 10             	movzbl (%eax),%edx
  800d60:	84 d2                	test   %dl,%dl
  800d62:	75 f2                	jne    800d56 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800d64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d69:	5d                   	pop    %ebp
  800d6a:	c3                   	ret    

00800d6b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d75:	eb 07                	jmp    800d7e <strfind+0x13>
		if (*s == c)
  800d77:	38 ca                	cmp    %cl,%dl
  800d79:	74 0a                	je     800d85 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d7b:	83 c0 01             	add    $0x1,%eax
  800d7e:	0f b6 10             	movzbl (%eax),%edx
  800d81:	84 d2                	test   %dl,%dl
  800d83:	75 f2                	jne    800d77 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800d85:	5d                   	pop    %ebp
  800d86:	c3                   	ret    

00800d87 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	57                   	push   %edi
  800d8b:	56                   	push   %esi
  800d8c:	53                   	push   %ebx
  800d8d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d90:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d93:	85 c9                	test   %ecx,%ecx
  800d95:	74 36                	je     800dcd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d97:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d9d:	75 28                	jne    800dc7 <memset+0x40>
  800d9f:	f6 c1 03             	test   $0x3,%cl
  800da2:	75 23                	jne    800dc7 <memset+0x40>
		c &= 0xFF;
  800da4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800da8:	89 d3                	mov    %edx,%ebx
  800daa:	c1 e3 08             	shl    $0x8,%ebx
  800dad:	89 d6                	mov    %edx,%esi
  800daf:	c1 e6 18             	shl    $0x18,%esi
  800db2:	89 d0                	mov    %edx,%eax
  800db4:	c1 e0 10             	shl    $0x10,%eax
  800db7:	09 f0                	or     %esi,%eax
  800db9:	09 c2                	or     %eax,%edx
  800dbb:	89 d0                	mov    %edx,%eax
  800dbd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800dbf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800dc2:	fc                   	cld    
  800dc3:	f3 ab                	rep stos %eax,%es:(%edi)
  800dc5:	eb 06                	jmp    800dcd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dca:	fc                   	cld    
  800dcb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800dcd:	89 f8                	mov    %edi,%eax
  800dcf:	5b                   	pop    %ebx
  800dd0:	5e                   	pop    %esi
  800dd1:	5f                   	pop    %edi
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	57                   	push   %edi
  800dd8:	56                   	push   %esi
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ddf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800de2:	39 c6                	cmp    %eax,%esi
  800de4:	73 35                	jae    800e1b <memmove+0x47>
  800de6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800de9:	39 d0                	cmp    %edx,%eax
  800deb:	73 2e                	jae    800e1b <memmove+0x47>
		s += n;
		d += n;
  800ded:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800df0:	89 d6                	mov    %edx,%esi
  800df2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800df4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dfa:	75 13                	jne    800e0f <memmove+0x3b>
  800dfc:	f6 c1 03             	test   $0x3,%cl
  800dff:	75 0e                	jne    800e0f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e01:	83 ef 04             	sub    $0x4,%edi
  800e04:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e07:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800e0a:	fd                   	std    
  800e0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e0d:	eb 09                	jmp    800e18 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e0f:	83 ef 01             	sub    $0x1,%edi
  800e12:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800e15:	fd                   	std    
  800e16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e18:	fc                   	cld    
  800e19:	eb 1d                	jmp    800e38 <memmove+0x64>
  800e1b:	89 f2                	mov    %esi,%edx
  800e1d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e1f:	f6 c2 03             	test   $0x3,%dl
  800e22:	75 0f                	jne    800e33 <memmove+0x5f>
  800e24:	f6 c1 03             	test   $0x3,%cl
  800e27:	75 0a                	jne    800e33 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e29:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800e2c:	89 c7                	mov    %eax,%edi
  800e2e:	fc                   	cld    
  800e2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e31:	eb 05                	jmp    800e38 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800e33:	89 c7                	mov    %eax,%edi
  800e35:	fc                   	cld    
  800e36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e38:	5e                   	pop    %esi
  800e39:	5f                   	pop    %edi
  800e3a:	5d                   	pop    %ebp
  800e3b:	c3                   	ret    

00800e3c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e42:	8b 45 10             	mov    0x10(%ebp),%eax
  800e45:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	89 04 24             	mov    %eax,(%esp)
  800e56:	e8 79 ff ff ff       	call   800dd4 <memmove>
}
  800e5b:	c9                   	leave  
  800e5c:	c3                   	ret    

00800e5d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	56                   	push   %esi
  800e61:	53                   	push   %ebx
  800e62:	8b 55 08             	mov    0x8(%ebp),%edx
  800e65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e68:	89 d6                	mov    %edx,%esi
  800e6a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e6d:	eb 1a                	jmp    800e89 <memcmp+0x2c>
		if (*s1 != *s2)
  800e6f:	0f b6 02             	movzbl (%edx),%eax
  800e72:	0f b6 19             	movzbl (%ecx),%ebx
  800e75:	38 d8                	cmp    %bl,%al
  800e77:	74 0a                	je     800e83 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800e79:	0f b6 c0             	movzbl %al,%eax
  800e7c:	0f b6 db             	movzbl %bl,%ebx
  800e7f:	29 d8                	sub    %ebx,%eax
  800e81:	eb 0f                	jmp    800e92 <memcmp+0x35>
		s1++, s2++;
  800e83:	83 c2 01             	add    $0x1,%edx
  800e86:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e89:	39 f2                	cmp    %esi,%edx
  800e8b:	75 e2                	jne    800e6f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e92:	5b                   	pop    %ebx
  800e93:	5e                   	pop    %esi
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    

00800e96 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e9f:	89 c2                	mov    %eax,%edx
  800ea1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ea4:	eb 07                	jmp    800ead <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ea6:	38 08                	cmp    %cl,(%eax)
  800ea8:	74 07                	je     800eb1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eaa:	83 c0 01             	add    $0x1,%eax
  800ead:	39 d0                	cmp    %edx,%eax
  800eaf:	72 f5                	jb     800ea6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    

00800eb3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
  800eb6:	57                   	push   %edi
  800eb7:	56                   	push   %esi
  800eb8:	53                   	push   %ebx
  800eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ebf:	eb 03                	jmp    800ec4 <strtol+0x11>
		s++;
  800ec1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ec4:	0f b6 0a             	movzbl (%edx),%ecx
  800ec7:	80 f9 09             	cmp    $0x9,%cl
  800eca:	74 f5                	je     800ec1 <strtol+0xe>
  800ecc:	80 f9 20             	cmp    $0x20,%cl
  800ecf:	74 f0                	je     800ec1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ed1:	80 f9 2b             	cmp    $0x2b,%cl
  800ed4:	75 0a                	jne    800ee0 <strtol+0x2d>
		s++;
  800ed6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ed9:	bf 00 00 00 00       	mov    $0x0,%edi
  800ede:	eb 11                	jmp    800ef1 <strtol+0x3e>
  800ee0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800ee5:	80 f9 2d             	cmp    $0x2d,%cl
  800ee8:	75 07                	jne    800ef1 <strtol+0x3e>
		s++, neg = 1;
  800eea:	8d 52 01             	lea    0x1(%edx),%edx
  800eed:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ef1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800ef6:	75 15                	jne    800f0d <strtol+0x5a>
  800ef8:	80 3a 30             	cmpb   $0x30,(%edx)
  800efb:	75 10                	jne    800f0d <strtol+0x5a>
  800efd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800f01:	75 0a                	jne    800f0d <strtol+0x5a>
		s += 2, base = 16;
  800f03:	83 c2 02             	add    $0x2,%edx
  800f06:	b8 10 00 00 00       	mov    $0x10,%eax
  800f0b:	eb 10                	jmp    800f1d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800f0d:	85 c0                	test   %eax,%eax
  800f0f:	75 0c                	jne    800f1d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f11:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f13:	80 3a 30             	cmpb   $0x30,(%edx)
  800f16:	75 05                	jne    800f1d <strtol+0x6a>
		s++, base = 8;
  800f18:	83 c2 01             	add    $0x1,%edx
  800f1b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800f1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f22:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f25:	0f b6 0a             	movzbl (%edx),%ecx
  800f28:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800f2b:	89 f0                	mov    %esi,%eax
  800f2d:	3c 09                	cmp    $0x9,%al
  800f2f:	77 08                	ja     800f39 <strtol+0x86>
			dig = *s - '0';
  800f31:	0f be c9             	movsbl %cl,%ecx
  800f34:	83 e9 30             	sub    $0x30,%ecx
  800f37:	eb 20                	jmp    800f59 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800f39:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800f3c:	89 f0                	mov    %esi,%eax
  800f3e:	3c 19                	cmp    $0x19,%al
  800f40:	77 08                	ja     800f4a <strtol+0x97>
			dig = *s - 'a' + 10;
  800f42:	0f be c9             	movsbl %cl,%ecx
  800f45:	83 e9 57             	sub    $0x57,%ecx
  800f48:	eb 0f                	jmp    800f59 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800f4a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800f4d:	89 f0                	mov    %esi,%eax
  800f4f:	3c 19                	cmp    $0x19,%al
  800f51:	77 16                	ja     800f69 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800f53:	0f be c9             	movsbl %cl,%ecx
  800f56:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f59:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800f5c:	7d 0f                	jge    800f6d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800f5e:	83 c2 01             	add    $0x1,%edx
  800f61:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800f65:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800f67:	eb bc                	jmp    800f25 <strtol+0x72>
  800f69:	89 d8                	mov    %ebx,%eax
  800f6b:	eb 02                	jmp    800f6f <strtol+0xbc>
  800f6d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800f6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f73:	74 05                	je     800f7a <strtol+0xc7>
		*endptr = (char *) s;
  800f75:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f78:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800f7a:	f7 d8                	neg    %eax
  800f7c:	85 ff                	test   %edi,%edi
  800f7e:	0f 44 c3             	cmove  %ebx,%eax
}
  800f81:	5b                   	pop    %ebx
  800f82:	5e                   	pop    %esi
  800f83:	5f                   	pop    %edi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    

00800f86 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	57                   	push   %edi
  800f8a:	56                   	push   %esi
  800f8b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f94:	8b 55 08             	mov    0x8(%ebp),%edx
  800f97:	89 c3                	mov    %eax,%ebx
  800f99:	89 c7                	mov    %eax,%edi
  800f9b:	89 c6                	mov    %eax,%esi
  800f9d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f9f:	5b                   	pop    %ebx
  800fa0:	5e                   	pop    %esi
  800fa1:	5f                   	pop    %edi
  800fa2:	5d                   	pop    %ebp
  800fa3:	c3                   	ret    

00800fa4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	57                   	push   %edi
  800fa8:	56                   	push   %esi
  800fa9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800faa:	ba 00 00 00 00       	mov    $0x0,%edx
  800faf:	b8 01 00 00 00       	mov    $0x1,%eax
  800fb4:	89 d1                	mov    %edx,%ecx
  800fb6:	89 d3                	mov    %edx,%ebx
  800fb8:	89 d7                	mov    %edx,%edi
  800fba:	89 d6                	mov    %edx,%esi
  800fbc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fbe:	5b                   	pop    %ebx
  800fbf:	5e                   	pop    %esi
  800fc0:	5f                   	pop    %edi
  800fc1:	5d                   	pop    %ebp
  800fc2:	c3                   	ret    

00800fc3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	57                   	push   %edi
  800fc7:	56                   	push   %esi
  800fc8:	53                   	push   %ebx
  800fc9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fcc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd1:	b8 03 00 00 00       	mov    $0x3,%eax
  800fd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd9:	89 cb                	mov    %ecx,%ebx
  800fdb:	89 cf                	mov    %ecx,%edi
  800fdd:	89 ce                	mov    %ecx,%esi
  800fdf:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	7e 28                	jle    80100d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ff0:	00 
  800ff1:	c7 44 24 08 47 2f 80 	movl   $0x802f47,0x8(%esp)
  800ff8:	00 
  800ff9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801000:	00 
  801001:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  801008:	e8 a9 16 00 00       	call   8026b6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80100d:	83 c4 2c             	add    $0x2c,%esp
  801010:	5b                   	pop    %ebx
  801011:	5e                   	pop    %esi
  801012:	5f                   	pop    %edi
  801013:	5d                   	pop    %ebp
  801014:	c3                   	ret    

00801015 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801015:	55                   	push   %ebp
  801016:	89 e5                	mov    %esp,%ebp
  801018:	57                   	push   %edi
  801019:	56                   	push   %esi
  80101a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101b:	ba 00 00 00 00       	mov    $0x0,%edx
  801020:	b8 02 00 00 00       	mov    $0x2,%eax
  801025:	89 d1                	mov    %edx,%ecx
  801027:	89 d3                	mov    %edx,%ebx
  801029:	89 d7                	mov    %edx,%edi
  80102b:	89 d6                	mov    %edx,%esi
  80102d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80102f:	5b                   	pop    %ebx
  801030:	5e                   	pop    %esi
  801031:	5f                   	pop    %edi
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    

00801034 <sys_yield>:

void
sys_yield(void)
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
  80103f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801044:	89 d1                	mov    %edx,%ecx
  801046:	89 d3                	mov    %edx,%ebx
  801048:	89 d7                	mov    %edx,%edi
  80104a:	89 d6                	mov    %edx,%esi
  80104c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80104e:	5b                   	pop    %ebx
  80104f:	5e                   	pop    %esi
  801050:	5f                   	pop    %edi
  801051:	5d                   	pop    %ebp
  801052:	c3                   	ret    

00801053 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  80105c:	be 00 00 00 00       	mov    $0x0,%esi
  801061:	b8 04 00 00 00       	mov    $0x4,%eax
  801066:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801069:	8b 55 08             	mov    0x8(%ebp),%edx
  80106c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80106f:	89 f7                	mov    %esi,%edi
  801071:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801073:	85 c0                	test   %eax,%eax
  801075:	7e 28                	jle    80109f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801077:	89 44 24 10          	mov    %eax,0x10(%esp)
  80107b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801082:	00 
  801083:	c7 44 24 08 47 2f 80 	movl   $0x802f47,0x8(%esp)
  80108a:	00 
  80108b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801092:	00 
  801093:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  80109a:	e8 17 16 00 00       	call   8026b6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80109f:	83 c4 2c             	add    $0x2c,%esp
  8010a2:	5b                   	pop    %ebx
  8010a3:	5e                   	pop    %esi
  8010a4:	5f                   	pop    %edi
  8010a5:	5d                   	pop    %ebp
  8010a6:	c3                   	ret    

008010a7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	57                   	push   %edi
  8010ab:	56                   	push   %esi
  8010ac:	53                   	push   %ebx
  8010ad:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010b0:	b8 05 00 00 00       	mov    $0x5,%eax
  8010b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010be:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010c1:	8b 75 18             	mov    0x18(%ebp),%esi
  8010c4:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	7e 28                	jle    8010f2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ca:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ce:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8010d5:	00 
  8010d6:	c7 44 24 08 47 2f 80 	movl   $0x802f47,0x8(%esp)
  8010dd:	00 
  8010de:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010e5:	00 
  8010e6:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  8010ed:	e8 c4 15 00 00       	call   8026b6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010f2:	83 c4 2c             	add    $0x2c,%esp
  8010f5:	5b                   	pop    %ebx
  8010f6:	5e                   	pop    %esi
  8010f7:	5f                   	pop    %edi
  8010f8:	5d                   	pop    %ebp
  8010f9:	c3                   	ret    

008010fa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	57                   	push   %edi
  8010fe:	56                   	push   %esi
  8010ff:	53                   	push   %ebx
  801100:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801103:	bb 00 00 00 00       	mov    $0x0,%ebx
  801108:	b8 06 00 00 00       	mov    $0x6,%eax
  80110d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801110:	8b 55 08             	mov    0x8(%ebp),%edx
  801113:	89 df                	mov    %ebx,%edi
  801115:	89 de                	mov    %ebx,%esi
  801117:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801119:	85 c0                	test   %eax,%eax
  80111b:	7e 28                	jle    801145 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80111d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801121:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801128:	00 
  801129:	c7 44 24 08 47 2f 80 	movl   $0x802f47,0x8(%esp)
  801130:	00 
  801131:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801138:	00 
  801139:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  801140:	e8 71 15 00 00       	call   8026b6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801145:	83 c4 2c             	add    $0x2c,%esp
  801148:	5b                   	pop    %ebx
  801149:	5e                   	pop    %esi
  80114a:	5f                   	pop    %edi
  80114b:	5d                   	pop    %ebp
  80114c:	c3                   	ret    

0080114d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	57                   	push   %edi
  801151:	56                   	push   %esi
  801152:	53                   	push   %ebx
  801153:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801156:	bb 00 00 00 00       	mov    $0x0,%ebx
  80115b:	b8 08 00 00 00       	mov    $0x8,%eax
  801160:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801163:	8b 55 08             	mov    0x8(%ebp),%edx
  801166:	89 df                	mov    %ebx,%edi
  801168:	89 de                	mov    %ebx,%esi
  80116a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80116c:	85 c0                	test   %eax,%eax
  80116e:	7e 28                	jle    801198 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801170:	89 44 24 10          	mov    %eax,0x10(%esp)
  801174:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80117b:	00 
  80117c:	c7 44 24 08 47 2f 80 	movl   $0x802f47,0x8(%esp)
  801183:	00 
  801184:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80118b:	00 
  80118c:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  801193:	e8 1e 15 00 00       	call   8026b6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801198:	83 c4 2c             	add    $0x2c,%esp
  80119b:	5b                   	pop    %ebx
  80119c:	5e                   	pop    %esi
  80119d:	5f                   	pop    %edi
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    

008011a0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	57                   	push   %edi
  8011a4:	56                   	push   %esi
  8011a5:	53                   	push   %ebx
  8011a6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ae:	b8 09 00 00 00       	mov    $0x9,%eax
  8011b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b9:	89 df                	mov    %ebx,%edi
  8011bb:	89 de                	mov    %ebx,%esi
  8011bd:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	7e 28                	jle    8011eb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011c3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011c7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8011ce:	00 
  8011cf:	c7 44 24 08 47 2f 80 	movl   $0x802f47,0x8(%esp)
  8011d6:	00 
  8011d7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011de:	00 
  8011df:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  8011e6:	e8 cb 14 00 00       	call   8026b6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011eb:	83 c4 2c             	add    $0x2c,%esp
  8011ee:	5b                   	pop    %ebx
  8011ef:	5e                   	pop    %esi
  8011f0:	5f                   	pop    %edi
  8011f1:	5d                   	pop    %ebp
  8011f2:	c3                   	ret    

008011f3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	57                   	push   %edi
  8011f7:	56                   	push   %esi
  8011f8:	53                   	push   %ebx
  8011f9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801201:	b8 0a 00 00 00       	mov    $0xa,%eax
  801206:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801209:	8b 55 08             	mov    0x8(%ebp),%edx
  80120c:	89 df                	mov    %ebx,%edi
  80120e:	89 de                	mov    %ebx,%esi
  801210:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801212:	85 c0                	test   %eax,%eax
  801214:	7e 28                	jle    80123e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801216:	89 44 24 10          	mov    %eax,0x10(%esp)
  80121a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801221:	00 
  801222:	c7 44 24 08 47 2f 80 	movl   $0x802f47,0x8(%esp)
  801229:	00 
  80122a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801231:	00 
  801232:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  801239:	e8 78 14 00 00       	call   8026b6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80123e:	83 c4 2c             	add    $0x2c,%esp
  801241:	5b                   	pop    %ebx
  801242:	5e                   	pop    %esi
  801243:	5f                   	pop    %edi
  801244:	5d                   	pop    %ebp
  801245:	c3                   	ret    

00801246 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	57                   	push   %edi
  80124a:	56                   	push   %esi
  80124b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80124c:	be 00 00 00 00       	mov    $0x0,%esi
  801251:	b8 0c 00 00 00       	mov    $0xc,%eax
  801256:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801259:	8b 55 08             	mov    0x8(%ebp),%edx
  80125c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80125f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801262:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801264:	5b                   	pop    %ebx
  801265:	5e                   	pop    %esi
  801266:	5f                   	pop    %edi
  801267:	5d                   	pop    %ebp
  801268:	c3                   	ret    

00801269 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801269:	55                   	push   %ebp
  80126a:	89 e5                	mov    %esp,%ebp
  80126c:	57                   	push   %edi
  80126d:	56                   	push   %esi
  80126e:	53                   	push   %ebx
  80126f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801272:	b9 00 00 00 00       	mov    $0x0,%ecx
  801277:	b8 0d 00 00 00       	mov    $0xd,%eax
  80127c:	8b 55 08             	mov    0x8(%ebp),%edx
  80127f:	89 cb                	mov    %ecx,%ebx
  801281:	89 cf                	mov    %ecx,%edi
  801283:	89 ce                	mov    %ecx,%esi
  801285:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801287:	85 c0                	test   %eax,%eax
  801289:	7e 28                	jle    8012b3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80128b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80128f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801296:	00 
  801297:	c7 44 24 08 47 2f 80 	movl   $0x802f47,0x8(%esp)
  80129e:	00 
  80129f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012a6:	00 
  8012a7:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  8012ae:	e8 03 14 00 00       	call   8026b6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012b3:	83 c4 2c             	add    $0x2c,%esp
  8012b6:	5b                   	pop    %ebx
  8012b7:	5e                   	pop    %esi
  8012b8:	5f                   	pop    %edi
  8012b9:	5d                   	pop    %ebp
  8012ba:	c3                   	ret    

008012bb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	57                   	push   %edi
  8012bf:	56                   	push   %esi
  8012c0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8012c6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012cb:	89 d1                	mov    %edx,%ecx
  8012cd:	89 d3                	mov    %edx,%ebx
  8012cf:	89 d7                	mov    %edx,%edi
  8012d1:	89 d6                	mov    %edx,%esi
  8012d3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8012d5:	5b                   	pop    %ebx
  8012d6:	5e                   	pop    %esi
  8012d7:	5f                   	pop    %edi
  8012d8:	5d                   	pop    %ebp
  8012d9:	c3                   	ret    

008012da <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	57                   	push   %edi
  8012de:	56                   	push   %esi
  8012df:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e5:	b8 0f 00 00 00       	mov    $0xf,%eax
  8012ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f0:	89 df                	mov    %ebx,%edi
  8012f2:	89 de                	mov    %ebx,%esi
  8012f4:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  8012f6:	5b                   	pop    %ebx
  8012f7:	5e                   	pop    %esi
  8012f8:	5f                   	pop    %edi
  8012f9:	5d                   	pop    %ebp
  8012fa:	c3                   	ret    

008012fb <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	57                   	push   %edi
  8012ff:	56                   	push   %esi
  801300:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801301:	bb 00 00 00 00       	mov    $0x0,%ebx
  801306:	b8 10 00 00 00       	mov    $0x10,%eax
  80130b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80130e:	8b 55 08             	mov    0x8(%ebp),%edx
  801311:	89 df                	mov    %ebx,%edi
  801313:	89 de                	mov    %ebx,%esi
  801315:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  801317:	5b                   	pop    %ebx
  801318:	5e                   	pop    %esi
  801319:	5f                   	pop    %edi
  80131a:	5d                   	pop    %ebp
  80131b:	c3                   	ret    

0080131c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	57                   	push   %edi
  801320:	56                   	push   %esi
  801321:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801322:	b9 00 00 00 00       	mov    $0x0,%ecx
  801327:	b8 11 00 00 00       	mov    $0x11,%eax
  80132c:	8b 55 08             	mov    0x8(%ebp),%edx
  80132f:	89 cb                	mov    %ecx,%ebx
  801331:	89 cf                	mov    %ecx,%edi
  801333:	89 ce                	mov    %ecx,%esi
  801335:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  801337:	5b                   	pop    %ebx
  801338:	5e                   	pop    %esi
  801339:	5f                   	pop    %edi
  80133a:	5d                   	pop    %ebp
  80133b:	c3                   	ret    

0080133c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	57                   	push   %edi
  801340:	56                   	push   %esi
  801341:	53                   	push   %ebx
  801342:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801345:	be 00 00 00 00       	mov    $0x0,%esi
  80134a:	b8 12 00 00 00       	mov    $0x12,%eax
  80134f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801352:	8b 55 08             	mov    0x8(%ebp),%edx
  801355:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801358:	8b 7d 14             	mov    0x14(%ebp),%edi
  80135b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80135d:	85 c0                	test   %eax,%eax
  80135f:	7e 28                	jle    801389 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  801361:	89 44 24 10          	mov    %eax,0x10(%esp)
  801365:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  80136c:	00 
  80136d:	c7 44 24 08 47 2f 80 	movl   $0x802f47,0x8(%esp)
  801374:	00 
  801375:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80137c:	00 
  80137d:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  801384:	e8 2d 13 00 00       	call   8026b6 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  801389:	83 c4 2c             	add    $0x2c,%esp
  80138c:	5b                   	pop    %ebx
  80138d:	5e                   	pop    %esi
  80138e:	5f                   	pop    %edi
  80138f:	5d                   	pop    %ebp
  801390:	c3                   	ret    
  801391:	66 90                	xchg   %ax,%ax
  801393:	66 90                	xchg   %ax,%ax
  801395:	66 90                	xchg   %ax,%ax
  801397:	66 90                	xchg   %ax,%ax
  801399:	66 90                	xchg   %ax,%ax
  80139b:	66 90                	xchg   %ax,%ax
  80139d:	66 90                	xchg   %ax,%ax
  80139f:	90                   	nop

008013a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8013ab:	c1 e8 0c             	shr    $0xc,%eax
}
  8013ae:	5d                   	pop    %ebp
  8013af:	c3                   	ret    

008013b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8013bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013c0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013c5:	5d                   	pop    %ebp
  8013c6:	c3                   	ret    

008013c7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013cd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013d2:	89 c2                	mov    %eax,%edx
  8013d4:	c1 ea 16             	shr    $0x16,%edx
  8013d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013de:	f6 c2 01             	test   $0x1,%dl
  8013e1:	74 11                	je     8013f4 <fd_alloc+0x2d>
  8013e3:	89 c2                	mov    %eax,%edx
  8013e5:	c1 ea 0c             	shr    $0xc,%edx
  8013e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013ef:	f6 c2 01             	test   $0x1,%dl
  8013f2:	75 09                	jne    8013fd <fd_alloc+0x36>
			*fd_store = fd;
  8013f4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fb:	eb 17                	jmp    801414 <fd_alloc+0x4d>
  8013fd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801402:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801407:	75 c9                	jne    8013d2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801409:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80140f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801414:	5d                   	pop    %ebp
  801415:	c3                   	ret    

00801416 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80141c:	83 f8 1f             	cmp    $0x1f,%eax
  80141f:	77 36                	ja     801457 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801421:	c1 e0 0c             	shl    $0xc,%eax
  801424:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801429:	89 c2                	mov    %eax,%edx
  80142b:	c1 ea 16             	shr    $0x16,%edx
  80142e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801435:	f6 c2 01             	test   $0x1,%dl
  801438:	74 24                	je     80145e <fd_lookup+0x48>
  80143a:	89 c2                	mov    %eax,%edx
  80143c:	c1 ea 0c             	shr    $0xc,%edx
  80143f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801446:	f6 c2 01             	test   $0x1,%dl
  801449:	74 1a                	je     801465 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80144b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144e:	89 02                	mov    %eax,(%edx)
	return 0;
  801450:	b8 00 00 00 00       	mov    $0x0,%eax
  801455:	eb 13                	jmp    80146a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801457:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80145c:	eb 0c                	jmp    80146a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80145e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801463:	eb 05                	jmp    80146a <fd_lookup+0x54>
  801465:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80146a:	5d                   	pop    %ebp
  80146b:	c3                   	ret    

0080146c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	83 ec 18             	sub    $0x18,%esp
  801472:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801475:	ba 00 00 00 00       	mov    $0x0,%edx
  80147a:	eb 13                	jmp    80148f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80147c:	39 08                	cmp    %ecx,(%eax)
  80147e:	75 0c                	jne    80148c <dev_lookup+0x20>
			*dev = devtab[i];
  801480:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801483:	89 01                	mov    %eax,(%ecx)
			return 0;
  801485:	b8 00 00 00 00       	mov    $0x0,%eax
  80148a:	eb 38                	jmp    8014c4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80148c:	83 c2 01             	add    $0x1,%edx
  80148f:	8b 04 95 f0 2f 80 00 	mov    0x802ff0(,%edx,4),%eax
  801496:	85 c0                	test   %eax,%eax
  801498:	75 e2                	jne    80147c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80149a:	a1 18 50 80 00       	mov    0x805018,%eax
  80149f:	8b 40 48             	mov    0x48(%eax),%eax
  8014a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014aa:	c7 04 24 74 2f 80 00 	movl   $0x802f74,(%esp)
  8014b1:	e8 5b f1 ff ff       	call   800611 <cprintf>
	*dev = 0;
  8014b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	56                   	push   %esi
  8014ca:	53                   	push   %ebx
  8014cb:	83 ec 20             	sub    $0x20,%esp
  8014ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8014d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014e1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014e4:	89 04 24             	mov    %eax,(%esp)
  8014e7:	e8 2a ff ff ff       	call   801416 <fd_lookup>
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	78 05                	js     8014f5 <fd_close+0x2f>
	    || fd != fd2)
  8014f0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8014f3:	74 0c                	je     801501 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8014f5:	84 db                	test   %bl,%bl
  8014f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014fc:	0f 44 c2             	cmove  %edx,%eax
  8014ff:	eb 3f                	jmp    801540 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801501:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801504:	89 44 24 04          	mov    %eax,0x4(%esp)
  801508:	8b 06                	mov    (%esi),%eax
  80150a:	89 04 24             	mov    %eax,(%esp)
  80150d:	e8 5a ff ff ff       	call   80146c <dev_lookup>
  801512:	89 c3                	mov    %eax,%ebx
  801514:	85 c0                	test   %eax,%eax
  801516:	78 16                	js     80152e <fd_close+0x68>
		if (dev->dev_close)
  801518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80151e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801523:	85 c0                	test   %eax,%eax
  801525:	74 07                	je     80152e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801527:	89 34 24             	mov    %esi,(%esp)
  80152a:	ff d0                	call   *%eax
  80152c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80152e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801532:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801539:	e8 bc fb ff ff       	call   8010fa <sys_page_unmap>
	return r;
  80153e:	89 d8                	mov    %ebx,%eax
}
  801540:	83 c4 20             	add    $0x20,%esp
  801543:	5b                   	pop    %ebx
  801544:	5e                   	pop    %esi
  801545:	5d                   	pop    %ebp
  801546:	c3                   	ret    

00801547 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
  80154a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80154d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801550:	89 44 24 04          	mov    %eax,0x4(%esp)
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	89 04 24             	mov    %eax,(%esp)
  80155a:	e8 b7 fe ff ff       	call   801416 <fd_lookup>
  80155f:	89 c2                	mov    %eax,%edx
  801561:	85 d2                	test   %edx,%edx
  801563:	78 13                	js     801578 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801565:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80156c:	00 
  80156d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801570:	89 04 24             	mov    %eax,(%esp)
  801573:	e8 4e ff ff ff       	call   8014c6 <fd_close>
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <close_all>:

void
close_all(void)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	53                   	push   %ebx
  80157e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801581:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801586:	89 1c 24             	mov    %ebx,(%esp)
  801589:	e8 b9 ff ff ff       	call   801547 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80158e:	83 c3 01             	add    $0x1,%ebx
  801591:	83 fb 20             	cmp    $0x20,%ebx
  801594:	75 f0                	jne    801586 <close_all+0xc>
		close(i);
}
  801596:	83 c4 14             	add    $0x14,%esp
  801599:	5b                   	pop    %ebx
  80159a:	5d                   	pop    %ebp
  80159b:	c3                   	ret    

0080159c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	57                   	push   %edi
  8015a0:	56                   	push   %esi
  8015a1:	53                   	push   %ebx
  8015a2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	89 04 24             	mov    %eax,(%esp)
  8015b2:	e8 5f fe ff ff       	call   801416 <fd_lookup>
  8015b7:	89 c2                	mov    %eax,%edx
  8015b9:	85 d2                	test   %edx,%edx
  8015bb:	0f 88 e1 00 00 00    	js     8016a2 <dup+0x106>
		return r;
	close(newfdnum);
  8015c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c4:	89 04 24             	mov    %eax,(%esp)
  8015c7:	e8 7b ff ff ff       	call   801547 <close>

	newfd = INDEX2FD(newfdnum);
  8015cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8015cf:	c1 e3 0c             	shl    $0xc,%ebx
  8015d2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8015d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015db:	89 04 24             	mov    %eax,(%esp)
  8015de:	e8 cd fd ff ff       	call   8013b0 <fd2data>
  8015e3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8015e5:	89 1c 24             	mov    %ebx,(%esp)
  8015e8:	e8 c3 fd ff ff       	call   8013b0 <fd2data>
  8015ed:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015ef:	89 f0                	mov    %esi,%eax
  8015f1:	c1 e8 16             	shr    $0x16,%eax
  8015f4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015fb:	a8 01                	test   $0x1,%al
  8015fd:	74 43                	je     801642 <dup+0xa6>
  8015ff:	89 f0                	mov    %esi,%eax
  801601:	c1 e8 0c             	shr    $0xc,%eax
  801604:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80160b:	f6 c2 01             	test   $0x1,%dl
  80160e:	74 32                	je     801642 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801610:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801617:	25 07 0e 00 00       	and    $0xe07,%eax
  80161c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801620:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801624:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80162b:	00 
  80162c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801630:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801637:	e8 6b fa ff ff       	call   8010a7 <sys_page_map>
  80163c:	89 c6                	mov    %eax,%esi
  80163e:	85 c0                	test   %eax,%eax
  801640:	78 3e                	js     801680 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801645:	89 c2                	mov    %eax,%edx
  801647:	c1 ea 0c             	shr    $0xc,%edx
  80164a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801651:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801657:	89 54 24 10          	mov    %edx,0x10(%esp)
  80165b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80165f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801666:	00 
  801667:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801672:	e8 30 fa ff ff       	call   8010a7 <sys_page_map>
  801677:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801679:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80167c:	85 f6                	test   %esi,%esi
  80167e:	79 22                	jns    8016a2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801680:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801684:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80168b:	e8 6a fa ff ff       	call   8010fa <sys_page_unmap>
	sys_page_unmap(0, nva);
  801690:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801694:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80169b:	e8 5a fa ff ff       	call   8010fa <sys_page_unmap>
	return r;
  8016a0:	89 f0                	mov    %esi,%eax
}
  8016a2:	83 c4 3c             	add    $0x3c,%esp
  8016a5:	5b                   	pop    %ebx
  8016a6:	5e                   	pop    %esi
  8016a7:	5f                   	pop    %edi
  8016a8:	5d                   	pop    %ebp
  8016a9:	c3                   	ret    

008016aa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	53                   	push   %ebx
  8016ae:	83 ec 24             	sub    $0x24,%esp
  8016b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016bb:	89 1c 24             	mov    %ebx,(%esp)
  8016be:	e8 53 fd ff ff       	call   801416 <fd_lookup>
  8016c3:	89 c2                	mov    %eax,%edx
  8016c5:	85 d2                	test   %edx,%edx
  8016c7:	78 6d                	js     801736 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d3:	8b 00                	mov    (%eax),%eax
  8016d5:	89 04 24             	mov    %eax,(%esp)
  8016d8:	e8 8f fd ff ff       	call   80146c <dev_lookup>
  8016dd:	85 c0                	test   %eax,%eax
  8016df:	78 55                	js     801736 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e4:	8b 50 08             	mov    0x8(%eax),%edx
  8016e7:	83 e2 03             	and    $0x3,%edx
  8016ea:	83 fa 01             	cmp    $0x1,%edx
  8016ed:	75 23                	jne    801712 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016ef:	a1 18 50 80 00       	mov    0x805018,%eax
  8016f4:	8b 40 48             	mov    0x48(%eax),%eax
  8016f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ff:	c7 04 24 b5 2f 80 00 	movl   $0x802fb5,(%esp)
  801706:	e8 06 ef ff ff       	call   800611 <cprintf>
		return -E_INVAL;
  80170b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801710:	eb 24                	jmp    801736 <read+0x8c>
	}
	if (!dev->dev_read)
  801712:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801715:	8b 52 08             	mov    0x8(%edx),%edx
  801718:	85 d2                	test   %edx,%edx
  80171a:	74 15                	je     801731 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80171c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80171f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801723:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801726:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80172a:	89 04 24             	mov    %eax,(%esp)
  80172d:	ff d2                	call   *%edx
  80172f:	eb 05                	jmp    801736 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801731:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801736:	83 c4 24             	add    $0x24,%esp
  801739:	5b                   	pop    %ebx
  80173a:	5d                   	pop    %ebp
  80173b:	c3                   	ret    

0080173c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	57                   	push   %edi
  801740:	56                   	push   %esi
  801741:	53                   	push   %ebx
  801742:	83 ec 1c             	sub    $0x1c,%esp
  801745:	8b 7d 08             	mov    0x8(%ebp),%edi
  801748:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80174b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801750:	eb 23                	jmp    801775 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801752:	89 f0                	mov    %esi,%eax
  801754:	29 d8                	sub    %ebx,%eax
  801756:	89 44 24 08          	mov    %eax,0x8(%esp)
  80175a:	89 d8                	mov    %ebx,%eax
  80175c:	03 45 0c             	add    0xc(%ebp),%eax
  80175f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801763:	89 3c 24             	mov    %edi,(%esp)
  801766:	e8 3f ff ff ff       	call   8016aa <read>
		if (m < 0)
  80176b:	85 c0                	test   %eax,%eax
  80176d:	78 10                	js     80177f <readn+0x43>
			return m;
		if (m == 0)
  80176f:	85 c0                	test   %eax,%eax
  801771:	74 0a                	je     80177d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801773:	01 c3                	add    %eax,%ebx
  801775:	39 f3                	cmp    %esi,%ebx
  801777:	72 d9                	jb     801752 <readn+0x16>
  801779:	89 d8                	mov    %ebx,%eax
  80177b:	eb 02                	jmp    80177f <readn+0x43>
  80177d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80177f:	83 c4 1c             	add    $0x1c,%esp
  801782:	5b                   	pop    %ebx
  801783:	5e                   	pop    %esi
  801784:	5f                   	pop    %edi
  801785:	5d                   	pop    %ebp
  801786:	c3                   	ret    

00801787 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	53                   	push   %ebx
  80178b:	83 ec 24             	sub    $0x24,%esp
  80178e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801791:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801794:	89 44 24 04          	mov    %eax,0x4(%esp)
  801798:	89 1c 24             	mov    %ebx,(%esp)
  80179b:	e8 76 fc ff ff       	call   801416 <fd_lookup>
  8017a0:	89 c2                	mov    %eax,%edx
  8017a2:	85 d2                	test   %edx,%edx
  8017a4:	78 68                	js     80180e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b0:	8b 00                	mov    (%eax),%eax
  8017b2:	89 04 24             	mov    %eax,(%esp)
  8017b5:	e8 b2 fc ff ff       	call   80146c <dev_lookup>
  8017ba:	85 c0                	test   %eax,%eax
  8017bc:	78 50                	js     80180e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017c5:	75 23                	jne    8017ea <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017c7:	a1 18 50 80 00       	mov    0x805018,%eax
  8017cc:	8b 40 48             	mov    0x48(%eax),%eax
  8017cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d7:	c7 04 24 d1 2f 80 00 	movl   $0x802fd1,(%esp)
  8017de:	e8 2e ee ff ff       	call   800611 <cprintf>
		return -E_INVAL;
  8017e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017e8:	eb 24                	jmp    80180e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ed:	8b 52 0c             	mov    0xc(%edx),%edx
  8017f0:	85 d2                	test   %edx,%edx
  8017f2:	74 15                	je     801809 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801802:	89 04 24             	mov    %eax,(%esp)
  801805:	ff d2                	call   *%edx
  801807:	eb 05                	jmp    80180e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801809:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80180e:	83 c4 24             	add    $0x24,%esp
  801811:	5b                   	pop    %ebx
  801812:	5d                   	pop    %ebp
  801813:	c3                   	ret    

00801814 <seek>:

int
seek(int fdnum, off_t offset)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
  801817:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80181a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80181d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	89 04 24             	mov    %eax,(%esp)
  801827:	e8 ea fb ff ff       	call   801416 <fd_lookup>
  80182c:	85 c0                	test   %eax,%eax
  80182e:	78 0e                	js     80183e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801830:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801833:	8b 55 0c             	mov    0xc(%ebp),%edx
  801836:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801839:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	53                   	push   %ebx
  801844:	83 ec 24             	sub    $0x24,%esp
  801847:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80184a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80184d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801851:	89 1c 24             	mov    %ebx,(%esp)
  801854:	e8 bd fb ff ff       	call   801416 <fd_lookup>
  801859:	89 c2                	mov    %eax,%edx
  80185b:	85 d2                	test   %edx,%edx
  80185d:	78 61                	js     8018c0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80185f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801862:	89 44 24 04          	mov    %eax,0x4(%esp)
  801866:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801869:	8b 00                	mov    (%eax),%eax
  80186b:	89 04 24             	mov    %eax,(%esp)
  80186e:	e8 f9 fb ff ff       	call   80146c <dev_lookup>
  801873:	85 c0                	test   %eax,%eax
  801875:	78 49                	js     8018c0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80187e:	75 23                	jne    8018a3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801880:	a1 18 50 80 00       	mov    0x805018,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801885:	8b 40 48             	mov    0x48(%eax),%eax
  801888:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80188c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801890:	c7 04 24 94 2f 80 00 	movl   $0x802f94,(%esp)
  801897:	e8 75 ed ff ff       	call   800611 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80189c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018a1:	eb 1d                	jmp    8018c0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8018a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a6:	8b 52 18             	mov    0x18(%edx),%edx
  8018a9:	85 d2                	test   %edx,%edx
  8018ab:	74 0e                	je     8018bb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018b0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018b4:	89 04 24             	mov    %eax,(%esp)
  8018b7:	ff d2                	call   *%edx
  8018b9:	eb 05                	jmp    8018c0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8018bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8018c0:	83 c4 24             	add    $0x24,%esp
  8018c3:	5b                   	pop    %ebx
  8018c4:	5d                   	pop    %ebp
  8018c5:	c3                   	ret    

008018c6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	53                   	push   %ebx
  8018ca:	83 ec 24             	sub    $0x24,%esp
  8018cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	89 04 24             	mov    %eax,(%esp)
  8018dd:	e8 34 fb ff ff       	call   801416 <fd_lookup>
  8018e2:	89 c2                	mov    %eax,%edx
  8018e4:	85 d2                	test   %edx,%edx
  8018e6:	78 52                	js     80193a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f2:	8b 00                	mov    (%eax),%eax
  8018f4:	89 04 24             	mov    %eax,(%esp)
  8018f7:	e8 70 fb ff ff       	call   80146c <dev_lookup>
  8018fc:	85 c0                	test   %eax,%eax
  8018fe:	78 3a                	js     80193a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801903:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801907:	74 2c                	je     801935 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801909:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80190c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801913:	00 00 00 
	stat->st_isdir = 0;
  801916:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80191d:	00 00 00 
	stat->st_dev = dev;
  801920:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801926:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80192a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80192d:	89 14 24             	mov    %edx,(%esp)
  801930:	ff 50 14             	call   *0x14(%eax)
  801933:	eb 05                	jmp    80193a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801935:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80193a:	83 c4 24             	add    $0x24,%esp
  80193d:	5b                   	pop    %ebx
  80193e:	5d                   	pop    %ebp
  80193f:	c3                   	ret    

00801940 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	56                   	push   %esi
  801944:	53                   	push   %ebx
  801945:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801948:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80194f:	00 
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	89 04 24             	mov    %eax,(%esp)
  801956:	e8 84 02 00 00       	call   801bdf <open>
  80195b:	89 c3                	mov    %eax,%ebx
  80195d:	85 db                	test   %ebx,%ebx
  80195f:	78 1b                	js     80197c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801961:	8b 45 0c             	mov    0xc(%ebp),%eax
  801964:	89 44 24 04          	mov    %eax,0x4(%esp)
  801968:	89 1c 24             	mov    %ebx,(%esp)
  80196b:	e8 56 ff ff ff       	call   8018c6 <fstat>
  801970:	89 c6                	mov    %eax,%esi
	close(fd);
  801972:	89 1c 24             	mov    %ebx,(%esp)
  801975:	e8 cd fb ff ff       	call   801547 <close>
	return r;
  80197a:	89 f0                	mov    %esi,%eax
}
  80197c:	83 c4 10             	add    $0x10,%esp
  80197f:	5b                   	pop    %ebx
  801980:	5e                   	pop    %esi
  801981:	5d                   	pop    %ebp
  801982:	c3                   	ret    

00801983 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	56                   	push   %esi
  801987:	53                   	push   %ebx
  801988:	83 ec 10             	sub    $0x10,%esp
  80198b:	89 c6                	mov    %eax,%esi
  80198d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80198f:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801996:	75 11                	jne    8019a9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801998:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80199f:	e8 61 0e 00 00       	call   802805 <ipc_find_env>
  8019a4:	a3 10 50 80 00       	mov    %eax,0x805010
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019a9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8019b0:	00 
  8019b1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8019b8:	00 
  8019b9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019bd:	a1 10 50 80 00       	mov    0x805010,%eax
  8019c2:	89 04 24             	mov    %eax,(%esp)
  8019c5:	e8 ae 0d 00 00       	call   802778 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019d1:	00 
  8019d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019dd:	e8 2e 0d 00 00       	call   802710 <ipc_recv>
}
  8019e2:	83 c4 10             	add    $0x10,%esp
  8019e5:	5b                   	pop    %ebx
  8019e6:	5e                   	pop    %esi
  8019e7:	5d                   	pop    %ebp
  8019e8:	c3                   	ret    

008019e9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8019fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019fd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a02:	ba 00 00 00 00       	mov    $0x0,%edx
  801a07:	b8 02 00 00 00       	mov    $0x2,%eax
  801a0c:	e8 72 ff ff ff       	call   801983 <fsipc>
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a1f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a24:	ba 00 00 00 00       	mov    $0x0,%edx
  801a29:	b8 06 00 00 00       	mov    $0x6,%eax
  801a2e:	e8 50 ff ff ff       	call   801983 <fsipc>
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	53                   	push   %ebx
  801a39:	83 ec 14             	sub    $0x14,%esp
  801a3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	8b 40 0c             	mov    0xc(%eax),%eax
  801a45:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4f:	b8 05 00 00 00       	mov    $0x5,%eax
  801a54:	e8 2a ff ff ff       	call   801983 <fsipc>
  801a59:	89 c2                	mov    %eax,%edx
  801a5b:	85 d2                	test   %edx,%edx
  801a5d:	78 2b                	js     801a8a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a5f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801a66:	00 
  801a67:	89 1c 24             	mov    %ebx,(%esp)
  801a6a:	e8 c8 f1 ff ff       	call   800c37 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a6f:	a1 80 60 80 00       	mov    0x806080,%eax
  801a74:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a7a:	a1 84 60 80 00       	mov    0x806084,%eax
  801a7f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a8a:	83 c4 14             	add    $0x14,%esp
  801a8d:	5b                   	pop    %ebx
  801a8e:	5d                   	pop    %ebp
  801a8f:	c3                   	ret    

00801a90 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
  801a93:	53                   	push   %ebx
  801a94:	83 ec 14             	sub    $0x14,%esp
  801a97:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801aa5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801aab:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801ab0:	0f 46 c3             	cmovbe %ebx,%eax
  801ab3:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801ab8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801abc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac3:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801aca:	e8 05 f3 ff ff       	call   800dd4 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801acf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad4:	b8 04 00 00 00       	mov    $0x4,%eax
  801ad9:	e8 a5 fe ff ff       	call   801983 <fsipc>
  801ade:	85 c0                	test   %eax,%eax
  801ae0:	78 53                	js     801b35 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801ae2:	39 c3                	cmp    %eax,%ebx
  801ae4:	73 24                	jae    801b0a <devfile_write+0x7a>
  801ae6:	c7 44 24 0c 04 30 80 	movl   $0x803004,0xc(%esp)
  801aed:	00 
  801aee:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  801af5:	00 
  801af6:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801afd:	00 
  801afe:	c7 04 24 20 30 80 00 	movl   $0x803020,(%esp)
  801b05:	e8 ac 0b 00 00       	call   8026b6 <_panic>
	assert(r <= PGSIZE);
  801b0a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b0f:	7e 24                	jle    801b35 <devfile_write+0xa5>
  801b11:	c7 44 24 0c 2b 30 80 	movl   $0x80302b,0xc(%esp)
  801b18:	00 
  801b19:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  801b20:	00 
  801b21:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801b28:	00 
  801b29:	c7 04 24 20 30 80 00 	movl   $0x803020,(%esp)
  801b30:	e8 81 0b 00 00       	call   8026b6 <_panic>
	return r;
}
  801b35:	83 c4 14             	add    $0x14,%esp
  801b38:	5b                   	pop    %ebx
  801b39:	5d                   	pop    %ebp
  801b3a:	c3                   	ret    

00801b3b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	56                   	push   %esi
  801b3f:	53                   	push   %ebx
  801b40:	83 ec 10             	sub    $0x10,%esp
  801b43:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	8b 40 0c             	mov    0xc(%eax),%eax
  801b4c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b51:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b57:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5c:	b8 03 00 00 00       	mov    $0x3,%eax
  801b61:	e8 1d fe ff ff       	call   801983 <fsipc>
  801b66:	89 c3                	mov    %eax,%ebx
  801b68:	85 c0                	test   %eax,%eax
  801b6a:	78 6a                	js     801bd6 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801b6c:	39 c6                	cmp    %eax,%esi
  801b6e:	73 24                	jae    801b94 <devfile_read+0x59>
  801b70:	c7 44 24 0c 04 30 80 	movl   $0x803004,0xc(%esp)
  801b77:	00 
  801b78:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  801b7f:	00 
  801b80:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801b87:	00 
  801b88:	c7 04 24 20 30 80 00 	movl   $0x803020,(%esp)
  801b8f:	e8 22 0b 00 00       	call   8026b6 <_panic>
	assert(r <= PGSIZE);
  801b94:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b99:	7e 24                	jle    801bbf <devfile_read+0x84>
  801b9b:	c7 44 24 0c 2b 30 80 	movl   $0x80302b,0xc(%esp)
  801ba2:	00 
  801ba3:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  801baa:	00 
  801bab:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801bb2:	00 
  801bb3:	c7 04 24 20 30 80 00 	movl   $0x803020,(%esp)
  801bba:	e8 f7 0a 00 00       	call   8026b6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801bbf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bc3:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801bca:	00 
  801bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bce:	89 04 24             	mov    %eax,(%esp)
  801bd1:	e8 fe f1 ff ff       	call   800dd4 <memmove>
	return r;
}
  801bd6:	89 d8                	mov    %ebx,%eax
  801bd8:	83 c4 10             	add    $0x10,%esp
  801bdb:	5b                   	pop    %ebx
  801bdc:	5e                   	pop    %esi
  801bdd:	5d                   	pop    %ebp
  801bde:	c3                   	ret    

00801bdf <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	53                   	push   %ebx
  801be3:	83 ec 24             	sub    $0x24,%esp
  801be6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801be9:	89 1c 24             	mov    %ebx,(%esp)
  801bec:	e8 0f f0 ff ff       	call   800c00 <strlen>
  801bf1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bf6:	7f 60                	jg     801c58 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801bf8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bfb:	89 04 24             	mov    %eax,(%esp)
  801bfe:	e8 c4 f7 ff ff       	call   8013c7 <fd_alloc>
  801c03:	89 c2                	mov    %eax,%edx
  801c05:	85 d2                	test   %edx,%edx
  801c07:	78 54                	js     801c5d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c09:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c0d:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801c14:	e8 1e f0 ff ff       	call   800c37 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1c:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c24:	b8 01 00 00 00       	mov    $0x1,%eax
  801c29:	e8 55 fd ff ff       	call   801983 <fsipc>
  801c2e:	89 c3                	mov    %eax,%ebx
  801c30:	85 c0                	test   %eax,%eax
  801c32:	79 17                	jns    801c4b <open+0x6c>
		fd_close(fd, 0);
  801c34:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c3b:	00 
  801c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3f:	89 04 24             	mov    %eax,(%esp)
  801c42:	e8 7f f8 ff ff       	call   8014c6 <fd_close>
		return r;
  801c47:	89 d8                	mov    %ebx,%eax
  801c49:	eb 12                	jmp    801c5d <open+0x7e>
	}

	return fd2num(fd);
  801c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4e:	89 04 24             	mov    %eax,(%esp)
  801c51:	e8 4a f7 ff ff       	call   8013a0 <fd2num>
  801c56:	eb 05                	jmp    801c5d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c58:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801c5d:	83 c4 24             	add    $0x24,%esp
  801c60:	5b                   	pop    %ebx
  801c61:	5d                   	pop    %ebp
  801c62:	c3                   	ret    

00801c63 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c69:	ba 00 00 00 00       	mov    $0x0,%edx
  801c6e:	b8 08 00 00 00       	mov    $0x8,%eax
  801c73:	e8 0b fd ff ff       	call   801983 <fsipc>
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    
  801c7a:	66 90                	xchg   %ax,%ax
  801c7c:	66 90                	xchg   %ax,%ax
  801c7e:	66 90                	xchg   %ax,%ax

00801c80 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801c86:	c7 44 24 04 37 30 80 	movl   $0x803037,0x4(%esp)
  801c8d:	00 
  801c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c91:	89 04 24             	mov    %eax,(%esp)
  801c94:	e8 9e ef ff ff       	call   800c37 <strcpy>
	return 0;
}
  801c99:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	53                   	push   %ebx
  801ca4:	83 ec 14             	sub    $0x14,%esp
  801ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801caa:	89 1c 24             	mov    %ebx,(%esp)
  801cad:	e8 8d 0b 00 00       	call   80283f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801cb2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801cb7:	83 f8 01             	cmp    $0x1,%eax
  801cba:	75 0d                	jne    801cc9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801cbc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801cbf:	89 04 24             	mov    %eax,(%esp)
  801cc2:	e8 29 03 00 00       	call   801ff0 <nsipc_close>
  801cc7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801cc9:	89 d0                	mov    %edx,%eax
  801ccb:	83 c4 14             	add    $0x14,%esp
  801cce:	5b                   	pop    %ebx
  801ccf:	5d                   	pop    %ebp
  801cd0:	c3                   	ret    

00801cd1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801cd7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cde:	00 
  801cdf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf3:	89 04 24             	mov    %eax,(%esp)
  801cf6:	e8 f0 03 00 00       	call   8020eb <nsipc_send>
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d03:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d0a:	00 
  801d0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d15:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d1f:	89 04 24             	mov    %eax,(%esp)
  801d22:	e8 44 03 00 00       	call   80206b <nsipc_recv>
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d2f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d32:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d36:	89 04 24             	mov    %eax,(%esp)
  801d39:	e8 d8 f6 ff ff       	call   801416 <fd_lookup>
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	78 17                	js     801d59 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d45:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  801d4b:	39 08                	cmp    %ecx,(%eax)
  801d4d:	75 05                	jne    801d54 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801d4f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d52:	eb 05                	jmp    801d59 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801d54:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	56                   	push   %esi
  801d5f:	53                   	push   %ebx
  801d60:	83 ec 20             	sub    $0x20,%esp
  801d63:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d65:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d68:	89 04 24             	mov    %eax,(%esp)
  801d6b:	e8 57 f6 ff ff       	call   8013c7 <fd_alloc>
  801d70:	89 c3                	mov    %eax,%ebx
  801d72:	85 c0                	test   %eax,%eax
  801d74:	78 21                	js     801d97 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d76:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d7d:	00 
  801d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d81:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d85:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d8c:	e8 c2 f2 ff ff       	call   801053 <sys_page_alloc>
  801d91:	89 c3                	mov    %eax,%ebx
  801d93:	85 c0                	test   %eax,%eax
  801d95:	79 0c                	jns    801da3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801d97:	89 34 24             	mov    %esi,(%esp)
  801d9a:	e8 51 02 00 00       	call   801ff0 <nsipc_close>
		return r;
  801d9f:	89 d8                	mov    %ebx,%eax
  801da1:	eb 20                	jmp    801dc3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801da3:	8b 15 24 40 80 00    	mov    0x804024,%edx
  801da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dac:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801dae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801db1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801db8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801dbb:	89 14 24             	mov    %edx,(%esp)
  801dbe:	e8 dd f5 ff ff       	call   8013a0 <fd2num>
}
  801dc3:	83 c4 20             	add    $0x20,%esp
  801dc6:	5b                   	pop    %ebx
  801dc7:	5e                   	pop    %esi
  801dc8:	5d                   	pop    %ebp
  801dc9:	c3                   	ret    

00801dca <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd3:	e8 51 ff ff ff       	call   801d29 <fd2sockid>
		return r;
  801dd8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dda:	85 c0                	test   %eax,%eax
  801ddc:	78 23                	js     801e01 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801dde:	8b 55 10             	mov    0x10(%ebp),%edx
  801de1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801de5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dec:	89 04 24             	mov    %eax,(%esp)
  801def:	e8 45 01 00 00       	call   801f39 <nsipc_accept>
		return r;
  801df4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801df6:	85 c0                	test   %eax,%eax
  801df8:	78 07                	js     801e01 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801dfa:	e8 5c ff ff ff       	call   801d5b <alloc_sockfd>
  801dff:	89 c1                	mov    %eax,%ecx
}
  801e01:	89 c8                	mov    %ecx,%eax
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0e:	e8 16 ff ff ff       	call   801d29 <fd2sockid>
  801e13:	89 c2                	mov    %eax,%edx
  801e15:	85 d2                	test   %edx,%edx
  801e17:	78 16                	js     801e2f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801e19:	8b 45 10             	mov    0x10(%ebp),%eax
  801e1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e23:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e27:	89 14 24             	mov    %edx,(%esp)
  801e2a:	e8 60 01 00 00       	call   801f8f <nsipc_bind>
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <shutdown>:

int
shutdown(int s, int how)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	e8 ea fe ff ff       	call   801d29 <fd2sockid>
  801e3f:	89 c2                	mov    %eax,%edx
  801e41:	85 d2                	test   %edx,%edx
  801e43:	78 0f                	js     801e54 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e48:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4c:	89 14 24             	mov    %edx,(%esp)
  801e4f:	e8 7a 01 00 00       	call   801fce <nsipc_shutdown>
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	e8 c5 fe ff ff       	call   801d29 <fd2sockid>
  801e64:	89 c2                	mov    %eax,%edx
  801e66:	85 d2                	test   %edx,%edx
  801e68:	78 16                	js     801e80 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801e6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e6d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e78:	89 14 24             	mov    %edx,(%esp)
  801e7b:	e8 8a 01 00 00       	call   80200a <nsipc_connect>
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <listen>:

int
listen(int s, int backlog)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8b:	e8 99 fe ff ff       	call   801d29 <fd2sockid>
  801e90:	89 c2                	mov    %eax,%edx
  801e92:	85 d2                	test   %edx,%edx
  801e94:	78 0f                	js     801ea5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e9d:	89 14 24             	mov    %edx,(%esp)
  801ea0:	e8 a4 01 00 00       	call   802049 <nsipc_listen>
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ead:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	89 04 24             	mov    %eax,(%esp)
  801ec1:	e8 98 02 00 00       	call   80215e <nsipc_socket>
  801ec6:	89 c2                	mov    %eax,%edx
  801ec8:	85 d2                	test   %edx,%edx
  801eca:	78 05                	js     801ed1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801ecc:	e8 8a fe ff ff       	call   801d5b <alloc_sockfd>
}
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	53                   	push   %ebx
  801ed7:	83 ec 14             	sub    $0x14,%esp
  801eda:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801edc:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  801ee3:	75 11                	jne    801ef6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ee5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801eec:	e8 14 09 00 00       	call   802805 <ipc_find_env>
  801ef1:	a3 14 50 80 00       	mov    %eax,0x805014
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ef6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801efd:	00 
  801efe:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801f05:	00 
  801f06:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f0a:	a1 14 50 80 00       	mov    0x805014,%eax
  801f0f:	89 04 24             	mov    %eax,(%esp)
  801f12:	e8 61 08 00 00       	call   802778 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f17:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f1e:	00 
  801f1f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f26:	00 
  801f27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f2e:	e8 dd 07 00 00       	call   802710 <ipc_recv>
}
  801f33:	83 c4 14             	add    $0x14,%esp
  801f36:	5b                   	pop    %ebx
  801f37:	5d                   	pop    %ebp
  801f38:	c3                   	ret    

00801f39 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	56                   	push   %esi
  801f3d:	53                   	push   %ebx
  801f3e:	83 ec 10             	sub    $0x10,%esp
  801f41:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f4c:	8b 06                	mov    (%esi),%eax
  801f4e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f53:	b8 01 00 00 00       	mov    $0x1,%eax
  801f58:	e8 76 ff ff ff       	call   801ed3 <nsipc>
  801f5d:	89 c3                	mov    %eax,%ebx
  801f5f:	85 c0                	test   %eax,%eax
  801f61:	78 23                	js     801f86 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f63:	a1 10 70 80 00       	mov    0x807010,%eax
  801f68:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f6c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801f73:	00 
  801f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f77:	89 04 24             	mov    %eax,(%esp)
  801f7a:	e8 55 ee ff ff       	call   800dd4 <memmove>
		*addrlen = ret->ret_addrlen;
  801f7f:	a1 10 70 80 00       	mov    0x807010,%eax
  801f84:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801f86:	89 d8                	mov    %ebx,%eax
  801f88:	83 c4 10             	add    $0x10,%esp
  801f8b:	5b                   	pop    %ebx
  801f8c:	5e                   	pop    %esi
  801f8d:	5d                   	pop    %ebp
  801f8e:	c3                   	ret    

00801f8f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
  801f92:	53                   	push   %ebx
  801f93:	83 ec 14             	sub    $0x14,%esp
  801f96:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f99:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fa1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fac:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  801fb3:	e8 1c ee ff ff       	call   800dd4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801fb8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801fbe:	b8 02 00 00 00       	mov    $0x2,%eax
  801fc3:	e8 0b ff ff ff       	call   801ed3 <nsipc>
}
  801fc8:	83 c4 14             	add    $0x14,%esp
  801fcb:	5b                   	pop    %ebx
  801fcc:	5d                   	pop    %ebp
  801fcd:	c3                   	ret    

00801fce <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fdf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801fe4:	b8 03 00 00 00       	mov    $0x3,%eax
  801fe9:	e8 e5 fe ff ff       	call   801ed3 <nsipc>
}
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    

00801ff0 <nsipc_close>:

int
nsipc_close(int s)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801ffe:	b8 04 00 00 00       	mov    $0x4,%eax
  802003:	e8 cb fe ff ff       	call   801ed3 <nsipc>
}
  802008:	c9                   	leave  
  802009:	c3                   	ret    

0080200a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	53                   	push   %ebx
  80200e:	83 ec 14             	sub    $0x14,%esp
  802011:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80201c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802020:	8b 45 0c             	mov    0xc(%ebp),%eax
  802023:	89 44 24 04          	mov    %eax,0x4(%esp)
  802027:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80202e:	e8 a1 ed ff ff       	call   800dd4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802033:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802039:	b8 05 00 00 00       	mov    $0x5,%eax
  80203e:	e8 90 fe ff ff       	call   801ed3 <nsipc>
}
  802043:	83 c4 14             	add    $0x14,%esp
  802046:	5b                   	pop    %ebx
  802047:	5d                   	pop    %ebp
  802048:	c3                   	ret    

00802049 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80204f:	8b 45 08             	mov    0x8(%ebp),%eax
  802052:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802057:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80205f:	b8 06 00 00 00       	mov    $0x6,%eax
  802064:	e8 6a fe ff ff       	call   801ed3 <nsipc>
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	56                   	push   %esi
  80206f:	53                   	push   %ebx
  802070:	83 ec 10             	sub    $0x10,%esp
  802073:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80207e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802084:	8b 45 14             	mov    0x14(%ebp),%eax
  802087:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80208c:	b8 07 00 00 00       	mov    $0x7,%eax
  802091:	e8 3d fe ff ff       	call   801ed3 <nsipc>
  802096:	89 c3                	mov    %eax,%ebx
  802098:	85 c0                	test   %eax,%eax
  80209a:	78 46                	js     8020e2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80209c:	39 f0                	cmp    %esi,%eax
  80209e:	7f 07                	jg     8020a7 <nsipc_recv+0x3c>
  8020a0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8020a5:	7e 24                	jle    8020cb <nsipc_recv+0x60>
  8020a7:	c7 44 24 0c 43 30 80 	movl   $0x803043,0xc(%esp)
  8020ae:	00 
  8020af:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  8020b6:	00 
  8020b7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8020be:	00 
  8020bf:	c7 04 24 58 30 80 00 	movl   $0x803058,(%esp)
  8020c6:	e8 eb 05 00 00       	call   8026b6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020cf:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8020d6:	00 
  8020d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020da:	89 04 24             	mov    %eax,(%esp)
  8020dd:	e8 f2 ec ff ff       	call   800dd4 <memmove>
	}

	return r;
}
  8020e2:	89 d8                	mov    %ebx,%eax
  8020e4:	83 c4 10             	add    $0x10,%esp
  8020e7:	5b                   	pop    %ebx
  8020e8:	5e                   	pop    %esi
  8020e9:	5d                   	pop    %ebp
  8020ea:	c3                   	ret    

008020eb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	53                   	push   %ebx
  8020ef:	83 ec 14             	sub    $0x14,%esp
  8020f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8020fd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802103:	7e 24                	jle    802129 <nsipc_send+0x3e>
  802105:	c7 44 24 0c 64 30 80 	movl   $0x803064,0xc(%esp)
  80210c:	00 
  80210d:	c7 44 24 08 0b 30 80 	movl   $0x80300b,0x8(%esp)
  802114:	00 
  802115:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80211c:	00 
  80211d:	c7 04 24 58 30 80 00 	movl   $0x803058,(%esp)
  802124:	e8 8d 05 00 00       	call   8026b6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802129:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80212d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802130:	89 44 24 04          	mov    %eax,0x4(%esp)
  802134:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80213b:	e8 94 ec ff ff       	call   800dd4 <memmove>
	nsipcbuf.send.req_size = size;
  802140:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802146:	8b 45 14             	mov    0x14(%ebp),%eax
  802149:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80214e:	b8 08 00 00 00       	mov    $0x8,%eax
  802153:	e8 7b fd ff ff       	call   801ed3 <nsipc>
}
  802158:	83 c4 14             	add    $0x14,%esp
  80215b:	5b                   	pop    %ebx
  80215c:	5d                   	pop    %ebp
  80215d:	c3                   	ret    

0080215e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80216c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802174:	8b 45 10             	mov    0x10(%ebp),%eax
  802177:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80217c:	b8 09 00 00 00       	mov    $0x9,%eax
  802181:	e8 4d fd ff ff       	call   801ed3 <nsipc>
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
  80218b:	56                   	push   %esi
  80218c:	53                   	push   %ebx
  80218d:	83 ec 10             	sub    $0x10,%esp
  802190:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	89 04 24             	mov    %eax,(%esp)
  802199:	e8 12 f2 ff ff       	call   8013b0 <fd2data>
  80219e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021a0:	c7 44 24 04 70 30 80 	movl   $0x803070,0x4(%esp)
  8021a7:	00 
  8021a8:	89 1c 24             	mov    %ebx,(%esp)
  8021ab:	e8 87 ea ff ff       	call   800c37 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021b0:	8b 46 04             	mov    0x4(%esi),%eax
  8021b3:	2b 06                	sub    (%esi),%eax
  8021b5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8021bb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8021c2:	00 00 00 
	stat->st_dev = &devpipe;
  8021c5:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  8021cc:	40 80 00 
	return 0;
}
  8021cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d4:	83 c4 10             	add    $0x10,%esp
  8021d7:	5b                   	pop    %ebx
  8021d8:	5e                   	pop    %esi
  8021d9:	5d                   	pop    %ebp
  8021da:	c3                   	ret    

008021db <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	53                   	push   %ebx
  8021df:	83 ec 14             	sub    $0x14,%esp
  8021e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021e5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021f0:	e8 05 ef ff ff       	call   8010fa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021f5:	89 1c 24             	mov    %ebx,(%esp)
  8021f8:	e8 b3 f1 ff ff       	call   8013b0 <fd2data>
  8021fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802201:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802208:	e8 ed ee ff ff       	call   8010fa <sys_page_unmap>
}
  80220d:	83 c4 14             	add    $0x14,%esp
  802210:	5b                   	pop    %ebx
  802211:	5d                   	pop    %ebp
  802212:	c3                   	ret    

00802213 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
  802216:	57                   	push   %edi
  802217:	56                   	push   %esi
  802218:	53                   	push   %ebx
  802219:	83 ec 2c             	sub    $0x2c,%esp
  80221c:	89 c6                	mov    %eax,%esi
  80221e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802221:	a1 18 50 80 00       	mov    0x805018,%eax
  802226:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802229:	89 34 24             	mov    %esi,(%esp)
  80222c:	e8 0e 06 00 00       	call   80283f <pageref>
  802231:	89 c7                	mov    %eax,%edi
  802233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802236:	89 04 24             	mov    %eax,(%esp)
  802239:	e8 01 06 00 00       	call   80283f <pageref>
  80223e:	39 c7                	cmp    %eax,%edi
  802240:	0f 94 c2             	sete   %dl
  802243:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802246:	8b 0d 18 50 80 00    	mov    0x805018,%ecx
  80224c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80224f:	39 fb                	cmp    %edi,%ebx
  802251:	74 21                	je     802274 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802253:	84 d2                	test   %dl,%dl
  802255:	74 ca                	je     802221 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802257:	8b 51 58             	mov    0x58(%ecx),%edx
  80225a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80225e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802262:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802266:	c7 04 24 77 30 80 00 	movl   $0x803077,(%esp)
  80226d:	e8 9f e3 ff ff       	call   800611 <cprintf>
  802272:	eb ad                	jmp    802221 <_pipeisclosed+0xe>
	}
}
  802274:	83 c4 2c             	add    $0x2c,%esp
  802277:	5b                   	pop    %ebx
  802278:	5e                   	pop    %esi
  802279:	5f                   	pop    %edi
  80227a:	5d                   	pop    %ebp
  80227b:	c3                   	ret    

0080227c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80227c:	55                   	push   %ebp
  80227d:	89 e5                	mov    %esp,%ebp
  80227f:	57                   	push   %edi
  802280:	56                   	push   %esi
  802281:	53                   	push   %ebx
  802282:	83 ec 1c             	sub    $0x1c,%esp
  802285:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802288:	89 34 24             	mov    %esi,(%esp)
  80228b:	e8 20 f1 ff ff       	call   8013b0 <fd2data>
  802290:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802292:	bf 00 00 00 00       	mov    $0x0,%edi
  802297:	eb 45                	jmp    8022de <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802299:	89 da                	mov    %ebx,%edx
  80229b:	89 f0                	mov    %esi,%eax
  80229d:	e8 71 ff ff ff       	call   802213 <_pipeisclosed>
  8022a2:	85 c0                	test   %eax,%eax
  8022a4:	75 41                	jne    8022e7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8022a6:	e8 89 ed ff ff       	call   801034 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022ab:	8b 43 04             	mov    0x4(%ebx),%eax
  8022ae:	8b 0b                	mov    (%ebx),%ecx
  8022b0:	8d 51 20             	lea    0x20(%ecx),%edx
  8022b3:	39 d0                	cmp    %edx,%eax
  8022b5:	73 e2                	jae    802299 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022ba:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8022be:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8022c1:	99                   	cltd   
  8022c2:	c1 ea 1b             	shr    $0x1b,%edx
  8022c5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8022c8:	83 e1 1f             	and    $0x1f,%ecx
  8022cb:	29 d1                	sub    %edx,%ecx
  8022cd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8022d1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8022d5:	83 c0 01             	add    $0x1,%eax
  8022d8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022db:	83 c7 01             	add    $0x1,%edi
  8022de:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8022e1:	75 c8                	jne    8022ab <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8022e3:	89 f8                	mov    %edi,%eax
  8022e5:	eb 05                	jmp    8022ec <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8022e7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8022ec:	83 c4 1c             	add    $0x1c,%esp
  8022ef:	5b                   	pop    %ebx
  8022f0:	5e                   	pop    %esi
  8022f1:	5f                   	pop    %edi
  8022f2:	5d                   	pop    %ebp
  8022f3:	c3                   	ret    

008022f4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
  8022f7:	57                   	push   %edi
  8022f8:	56                   	push   %esi
  8022f9:	53                   	push   %ebx
  8022fa:	83 ec 1c             	sub    $0x1c,%esp
  8022fd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802300:	89 3c 24             	mov    %edi,(%esp)
  802303:	e8 a8 f0 ff ff       	call   8013b0 <fd2data>
  802308:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80230a:	be 00 00 00 00       	mov    $0x0,%esi
  80230f:	eb 3d                	jmp    80234e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802311:	85 f6                	test   %esi,%esi
  802313:	74 04                	je     802319 <devpipe_read+0x25>
				return i;
  802315:	89 f0                	mov    %esi,%eax
  802317:	eb 43                	jmp    80235c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802319:	89 da                	mov    %ebx,%edx
  80231b:	89 f8                	mov    %edi,%eax
  80231d:	e8 f1 fe ff ff       	call   802213 <_pipeisclosed>
  802322:	85 c0                	test   %eax,%eax
  802324:	75 31                	jne    802357 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802326:	e8 09 ed ff ff       	call   801034 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80232b:	8b 03                	mov    (%ebx),%eax
  80232d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802330:	74 df                	je     802311 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802332:	99                   	cltd   
  802333:	c1 ea 1b             	shr    $0x1b,%edx
  802336:	01 d0                	add    %edx,%eax
  802338:	83 e0 1f             	and    $0x1f,%eax
  80233b:	29 d0                	sub    %edx,%eax
  80233d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802342:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802345:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802348:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80234b:	83 c6 01             	add    $0x1,%esi
  80234e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802351:	75 d8                	jne    80232b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802353:	89 f0                	mov    %esi,%eax
  802355:	eb 05                	jmp    80235c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802357:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80235c:	83 c4 1c             	add    $0x1c,%esp
  80235f:	5b                   	pop    %ebx
  802360:	5e                   	pop    %esi
  802361:	5f                   	pop    %edi
  802362:	5d                   	pop    %ebp
  802363:	c3                   	ret    

00802364 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802364:	55                   	push   %ebp
  802365:	89 e5                	mov    %esp,%ebp
  802367:	56                   	push   %esi
  802368:	53                   	push   %ebx
  802369:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80236c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80236f:	89 04 24             	mov    %eax,(%esp)
  802372:	e8 50 f0 ff ff       	call   8013c7 <fd_alloc>
  802377:	89 c2                	mov    %eax,%edx
  802379:	85 d2                	test   %edx,%edx
  80237b:	0f 88 4d 01 00 00    	js     8024ce <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802381:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802388:	00 
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802390:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802397:	e8 b7 ec ff ff       	call   801053 <sys_page_alloc>
  80239c:	89 c2                	mov    %eax,%edx
  80239e:	85 d2                	test   %edx,%edx
  8023a0:	0f 88 28 01 00 00    	js     8024ce <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8023a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023a9:	89 04 24             	mov    %eax,(%esp)
  8023ac:	e8 16 f0 ff ff       	call   8013c7 <fd_alloc>
  8023b1:	89 c3                	mov    %eax,%ebx
  8023b3:	85 c0                	test   %eax,%eax
  8023b5:	0f 88 fe 00 00 00    	js     8024b9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023bb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023c2:	00 
  8023c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023d1:	e8 7d ec ff ff       	call   801053 <sys_page_alloc>
  8023d6:	89 c3                	mov    %eax,%ebx
  8023d8:	85 c0                	test   %eax,%eax
  8023da:	0f 88 d9 00 00 00    	js     8024b9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e3:	89 04 24             	mov    %eax,(%esp)
  8023e6:	e8 c5 ef ff ff       	call   8013b0 <fd2data>
  8023eb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023ed:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023f4:	00 
  8023f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802400:	e8 4e ec ff ff       	call   801053 <sys_page_alloc>
  802405:	89 c3                	mov    %eax,%ebx
  802407:	85 c0                	test   %eax,%eax
  802409:	0f 88 97 00 00 00    	js     8024a6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80240f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802412:	89 04 24             	mov    %eax,(%esp)
  802415:	e8 96 ef ff ff       	call   8013b0 <fd2data>
  80241a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802421:	00 
  802422:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802426:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80242d:	00 
  80242e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802432:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802439:	e8 69 ec ff ff       	call   8010a7 <sys_page_map>
  80243e:	89 c3                	mov    %eax,%ebx
  802440:	85 c0                	test   %eax,%eax
  802442:	78 52                	js     802496 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802444:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802459:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80245f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802462:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802467:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	89 04 24             	mov    %eax,(%esp)
  802474:	e8 27 ef ff ff       	call   8013a0 <fd2num>
  802479:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80247c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80247e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802481:	89 04 24             	mov    %eax,(%esp)
  802484:	e8 17 ef ff ff       	call   8013a0 <fd2num>
  802489:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80248c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80248f:	b8 00 00 00 00       	mov    $0x0,%eax
  802494:	eb 38                	jmp    8024ce <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802496:	89 74 24 04          	mov    %esi,0x4(%esp)
  80249a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024a1:	e8 54 ec ff ff       	call   8010fa <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8024a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024b4:	e8 41 ec ff ff       	call   8010fa <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024c7:	e8 2e ec ff ff       	call   8010fa <sys_page_unmap>
  8024cc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8024ce:	83 c4 30             	add    $0x30,%esp
  8024d1:	5b                   	pop    %ebx
  8024d2:	5e                   	pop    %esi
  8024d3:	5d                   	pop    %ebp
  8024d4:	c3                   	ret    

008024d5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
  8024d8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e5:	89 04 24             	mov    %eax,(%esp)
  8024e8:	e8 29 ef ff ff       	call   801416 <fd_lookup>
  8024ed:	89 c2                	mov    %eax,%edx
  8024ef:	85 d2                	test   %edx,%edx
  8024f1:	78 15                	js     802508 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8024f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f6:	89 04 24             	mov    %eax,(%esp)
  8024f9:	e8 b2 ee ff ff       	call   8013b0 <fd2data>
	return _pipeisclosed(fd, p);
  8024fe:	89 c2                	mov    %eax,%edx
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	e8 0b fd ff ff       	call   802213 <_pipeisclosed>
}
  802508:	c9                   	leave  
  802509:	c3                   	ret    
  80250a:	66 90                	xchg   %ax,%ax
  80250c:	66 90                	xchg   %ax,%ax
  80250e:	66 90                	xchg   %ax,%ax

00802510 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802513:	b8 00 00 00 00       	mov    $0x0,%eax
  802518:	5d                   	pop    %ebp
  802519:	c3                   	ret    

0080251a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80251a:	55                   	push   %ebp
  80251b:	89 e5                	mov    %esp,%ebp
  80251d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802520:	c7 44 24 04 8f 30 80 	movl   $0x80308f,0x4(%esp)
  802527:	00 
  802528:	8b 45 0c             	mov    0xc(%ebp),%eax
  80252b:	89 04 24             	mov    %eax,(%esp)
  80252e:	e8 04 e7 ff ff       	call   800c37 <strcpy>
	return 0;
}
  802533:	b8 00 00 00 00       	mov    $0x0,%eax
  802538:	c9                   	leave  
  802539:	c3                   	ret    

0080253a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80253a:	55                   	push   %ebp
  80253b:	89 e5                	mov    %esp,%ebp
  80253d:	57                   	push   %edi
  80253e:	56                   	push   %esi
  80253f:	53                   	push   %ebx
  802540:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802546:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80254b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802551:	eb 31                	jmp    802584 <devcons_write+0x4a>
		m = n - tot;
  802553:	8b 75 10             	mov    0x10(%ebp),%esi
  802556:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802558:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80255b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802560:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802563:	89 74 24 08          	mov    %esi,0x8(%esp)
  802567:	03 45 0c             	add    0xc(%ebp),%eax
  80256a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80256e:	89 3c 24             	mov    %edi,(%esp)
  802571:	e8 5e e8 ff ff       	call   800dd4 <memmove>
		sys_cputs(buf, m);
  802576:	89 74 24 04          	mov    %esi,0x4(%esp)
  80257a:	89 3c 24             	mov    %edi,(%esp)
  80257d:	e8 04 ea ff ff       	call   800f86 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802582:	01 f3                	add    %esi,%ebx
  802584:	89 d8                	mov    %ebx,%eax
  802586:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802589:	72 c8                	jb     802553 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80258b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802591:	5b                   	pop    %ebx
  802592:	5e                   	pop    %esi
  802593:	5f                   	pop    %edi
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    

00802596 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802596:	55                   	push   %ebp
  802597:	89 e5                	mov    %esp,%ebp
  802599:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80259c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8025a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025a5:	75 07                	jne    8025ae <devcons_read+0x18>
  8025a7:	eb 2a                	jmp    8025d3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8025a9:	e8 86 ea ff ff       	call   801034 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8025ae:	66 90                	xchg   %ax,%ax
  8025b0:	e8 ef e9 ff ff       	call   800fa4 <sys_cgetc>
  8025b5:	85 c0                	test   %eax,%eax
  8025b7:	74 f0                	je     8025a9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8025b9:	85 c0                	test   %eax,%eax
  8025bb:	78 16                	js     8025d3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8025bd:	83 f8 04             	cmp    $0x4,%eax
  8025c0:	74 0c                	je     8025ce <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8025c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c5:	88 02                	mov    %al,(%edx)
	return 1;
  8025c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8025cc:	eb 05                	jmp    8025d3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8025ce:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8025d3:	c9                   	leave  
  8025d4:	c3                   	ret    

008025d5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8025d5:	55                   	push   %ebp
  8025d6:	89 e5                	mov    %esp,%ebp
  8025d8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8025db:	8b 45 08             	mov    0x8(%ebp),%eax
  8025de:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8025e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8025e8:	00 
  8025e9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025ec:	89 04 24             	mov    %eax,(%esp)
  8025ef:	e8 92 e9 ff ff       	call   800f86 <sys_cputs>
}
  8025f4:	c9                   	leave  
  8025f5:	c3                   	ret    

008025f6 <getchar>:

int
getchar(void)
{
  8025f6:	55                   	push   %ebp
  8025f7:	89 e5                	mov    %esp,%ebp
  8025f9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8025fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802603:	00 
  802604:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802607:	89 44 24 04          	mov    %eax,0x4(%esp)
  80260b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802612:	e8 93 f0 ff ff       	call   8016aa <read>
	if (r < 0)
  802617:	85 c0                	test   %eax,%eax
  802619:	78 0f                	js     80262a <getchar+0x34>
		return r;
	if (r < 1)
  80261b:	85 c0                	test   %eax,%eax
  80261d:	7e 06                	jle    802625 <getchar+0x2f>
		return -E_EOF;
	return c;
  80261f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802623:	eb 05                	jmp    80262a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802625:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80262a:	c9                   	leave  
  80262b:	c3                   	ret    

0080262c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80262c:	55                   	push   %ebp
  80262d:	89 e5                	mov    %esp,%ebp
  80262f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802632:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802635:	89 44 24 04          	mov    %eax,0x4(%esp)
  802639:	8b 45 08             	mov    0x8(%ebp),%eax
  80263c:	89 04 24             	mov    %eax,(%esp)
  80263f:	e8 d2 ed ff ff       	call   801416 <fd_lookup>
  802644:	85 c0                	test   %eax,%eax
  802646:	78 11                	js     802659 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802651:	39 10                	cmp    %edx,(%eax)
  802653:	0f 94 c0             	sete   %al
  802656:	0f b6 c0             	movzbl %al,%eax
}
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <opencons>:

int
opencons(void)
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
  80265e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802661:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802664:	89 04 24             	mov    %eax,(%esp)
  802667:	e8 5b ed ff ff       	call   8013c7 <fd_alloc>
		return r;
  80266c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80266e:	85 c0                	test   %eax,%eax
  802670:	78 40                	js     8026b2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802672:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802679:	00 
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802681:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802688:	e8 c6 e9 ff ff       	call   801053 <sys_page_alloc>
		return r;
  80268d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80268f:	85 c0                	test   %eax,%eax
  802691:	78 1f                	js     8026b2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802693:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026a8:	89 04 24             	mov    %eax,(%esp)
  8026ab:	e8 f0 ec ff ff       	call   8013a0 <fd2num>
  8026b0:	89 c2                	mov    %eax,%edx
}
  8026b2:	89 d0                	mov    %edx,%eax
  8026b4:	c9                   	leave  
  8026b5:	c3                   	ret    

008026b6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8026b6:	55                   	push   %ebp
  8026b7:	89 e5                	mov    %esp,%ebp
  8026b9:	56                   	push   %esi
  8026ba:	53                   	push   %ebx
  8026bb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8026be:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8026c1:	8b 35 04 40 80 00    	mov    0x804004,%esi
  8026c7:	e8 49 e9 ff ff       	call   801015 <sys_getenvid>
  8026cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026cf:	89 54 24 10          	mov    %edx,0x10(%esp)
  8026d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8026da:	89 74 24 08          	mov    %esi,0x8(%esp)
  8026de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026e2:	c7 04 24 9c 30 80 00 	movl   $0x80309c,(%esp)
  8026e9:	e8 23 df ff ff       	call   800611 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8026ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8026f5:	89 04 24             	mov    %eax,(%esp)
  8026f8:	e8 b3 de ff ff       	call   8005b0 <vcprintf>
	cprintf("\n");
  8026fd:	c7 04 24 d4 2b 80 00 	movl   $0x802bd4,(%esp)
  802704:	e8 08 df ff ff       	call   800611 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802709:	cc                   	int3   
  80270a:	eb fd                	jmp    802709 <_panic+0x53>
  80270c:	66 90                	xchg   %ax,%ax
  80270e:	66 90                	xchg   %ax,%ax

00802710 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802710:	55                   	push   %ebp
  802711:	89 e5                	mov    %esp,%ebp
  802713:	56                   	push   %esi
  802714:	53                   	push   %ebx
  802715:	83 ec 10             	sub    $0x10,%esp
  802718:	8b 75 08             	mov    0x8(%ebp),%esi
  80271b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80271e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802721:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802723:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802728:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80272b:	89 04 24             	mov    %eax,(%esp)
  80272e:	e8 36 eb ff ff       	call   801269 <sys_ipc_recv>
  802733:	85 c0                	test   %eax,%eax
  802735:	74 16                	je     80274d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802737:	85 f6                	test   %esi,%esi
  802739:	74 06                	je     802741 <ipc_recv+0x31>
			*from_env_store = 0;
  80273b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802741:	85 db                	test   %ebx,%ebx
  802743:	74 2c                	je     802771 <ipc_recv+0x61>
			*perm_store = 0;
  802745:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80274b:	eb 24                	jmp    802771 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  80274d:	85 f6                	test   %esi,%esi
  80274f:	74 0a                	je     80275b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802751:	a1 18 50 80 00       	mov    0x805018,%eax
  802756:	8b 40 74             	mov    0x74(%eax),%eax
  802759:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80275b:	85 db                	test   %ebx,%ebx
  80275d:	74 0a                	je     802769 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80275f:	a1 18 50 80 00       	mov    0x805018,%eax
  802764:	8b 40 78             	mov    0x78(%eax),%eax
  802767:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802769:	a1 18 50 80 00       	mov    0x805018,%eax
  80276e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802771:	83 c4 10             	add    $0x10,%esp
  802774:	5b                   	pop    %ebx
  802775:	5e                   	pop    %esi
  802776:	5d                   	pop    %ebp
  802777:	c3                   	ret    

00802778 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802778:	55                   	push   %ebp
  802779:	89 e5                	mov    %esp,%ebp
  80277b:	57                   	push   %edi
  80277c:	56                   	push   %esi
  80277d:	53                   	push   %ebx
  80277e:	83 ec 1c             	sub    $0x1c,%esp
  802781:	8b 75 0c             	mov    0xc(%ebp),%esi
  802784:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802787:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  80278a:	85 db                	test   %ebx,%ebx
  80278c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802791:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  802794:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802798:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80279c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a3:	89 04 24             	mov    %eax,(%esp)
  8027a6:	e8 9b ea ff ff       	call   801246 <sys_ipc_try_send>
	if (r == 0) return;
  8027ab:	85 c0                	test   %eax,%eax
  8027ad:	75 22                	jne    8027d1 <ipc_send+0x59>
  8027af:	eb 4c                	jmp    8027fd <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  8027b1:	84 d2                	test   %dl,%dl
  8027b3:	75 48                	jne    8027fd <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  8027b5:	e8 7a e8 ff ff       	call   801034 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  8027ba:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027be:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c9:	89 04 24             	mov    %eax,(%esp)
  8027cc:	e8 75 ea ff ff       	call   801246 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  8027d1:	85 c0                	test   %eax,%eax
  8027d3:	0f 94 c2             	sete   %dl
  8027d6:	74 d9                	je     8027b1 <ipc_send+0x39>
  8027d8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8027db:	74 d4                	je     8027b1 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  8027dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027e1:	c7 44 24 08 c0 30 80 	movl   $0x8030c0,0x8(%esp)
  8027e8:	00 
  8027e9:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  8027f0:	00 
  8027f1:	c7 04 24 ce 30 80 00 	movl   $0x8030ce,(%esp)
  8027f8:	e8 b9 fe ff ff       	call   8026b6 <_panic>
}
  8027fd:	83 c4 1c             	add    $0x1c,%esp
  802800:	5b                   	pop    %ebx
  802801:	5e                   	pop    %esi
  802802:	5f                   	pop    %edi
  802803:	5d                   	pop    %ebp
  802804:	c3                   	ret    

00802805 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802805:	55                   	push   %ebp
  802806:	89 e5                	mov    %esp,%ebp
  802808:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80280b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802810:	89 c2                	mov    %eax,%edx
  802812:	c1 e2 07             	shl    $0x7,%edx
  802815:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80281b:	8b 52 50             	mov    0x50(%edx),%edx
  80281e:	39 ca                	cmp    %ecx,%edx
  802820:	75 0d                	jne    80282f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802822:	c1 e0 07             	shl    $0x7,%eax
  802825:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80282a:	8b 40 40             	mov    0x40(%eax),%eax
  80282d:	eb 0e                	jmp    80283d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80282f:	83 c0 01             	add    $0x1,%eax
  802832:	3d 00 04 00 00       	cmp    $0x400,%eax
  802837:	75 d7                	jne    802810 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802839:	66 b8 00 00          	mov    $0x0,%ax
}
  80283d:	5d                   	pop    %ebp
  80283e:	c3                   	ret    

0080283f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80283f:	55                   	push   %ebp
  802840:	89 e5                	mov    %esp,%ebp
  802842:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802845:	89 d0                	mov    %edx,%eax
  802847:	c1 e8 16             	shr    $0x16,%eax
  80284a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802851:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802856:	f6 c1 01             	test   $0x1,%cl
  802859:	74 1d                	je     802878 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80285b:	c1 ea 0c             	shr    $0xc,%edx
  80285e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802865:	f6 c2 01             	test   $0x1,%dl
  802868:	74 0e                	je     802878 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80286a:	c1 ea 0c             	shr    $0xc,%edx
  80286d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802874:	ef 
  802875:	0f b7 c0             	movzwl %ax,%eax
}
  802878:	5d                   	pop    %ebp
  802879:	c3                   	ret    
  80287a:	66 90                	xchg   %ax,%ax
  80287c:	66 90                	xchg   %ax,%ax
  80287e:	66 90                	xchg   %ax,%ax

00802880 <__udivdi3>:
  802880:	55                   	push   %ebp
  802881:	57                   	push   %edi
  802882:	56                   	push   %esi
  802883:	83 ec 0c             	sub    $0xc,%esp
  802886:	8b 44 24 28          	mov    0x28(%esp),%eax
  80288a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80288e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802892:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802896:	85 c0                	test   %eax,%eax
  802898:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80289c:	89 ea                	mov    %ebp,%edx
  80289e:	89 0c 24             	mov    %ecx,(%esp)
  8028a1:	75 2d                	jne    8028d0 <__udivdi3+0x50>
  8028a3:	39 e9                	cmp    %ebp,%ecx
  8028a5:	77 61                	ja     802908 <__udivdi3+0x88>
  8028a7:	85 c9                	test   %ecx,%ecx
  8028a9:	89 ce                	mov    %ecx,%esi
  8028ab:	75 0b                	jne    8028b8 <__udivdi3+0x38>
  8028ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8028b2:	31 d2                	xor    %edx,%edx
  8028b4:	f7 f1                	div    %ecx
  8028b6:	89 c6                	mov    %eax,%esi
  8028b8:	31 d2                	xor    %edx,%edx
  8028ba:	89 e8                	mov    %ebp,%eax
  8028bc:	f7 f6                	div    %esi
  8028be:	89 c5                	mov    %eax,%ebp
  8028c0:	89 f8                	mov    %edi,%eax
  8028c2:	f7 f6                	div    %esi
  8028c4:	89 ea                	mov    %ebp,%edx
  8028c6:	83 c4 0c             	add    $0xc,%esp
  8028c9:	5e                   	pop    %esi
  8028ca:	5f                   	pop    %edi
  8028cb:	5d                   	pop    %ebp
  8028cc:	c3                   	ret    
  8028cd:	8d 76 00             	lea    0x0(%esi),%esi
  8028d0:	39 e8                	cmp    %ebp,%eax
  8028d2:	77 24                	ja     8028f8 <__udivdi3+0x78>
  8028d4:	0f bd e8             	bsr    %eax,%ebp
  8028d7:	83 f5 1f             	xor    $0x1f,%ebp
  8028da:	75 3c                	jne    802918 <__udivdi3+0x98>
  8028dc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8028e0:	39 34 24             	cmp    %esi,(%esp)
  8028e3:	0f 86 9f 00 00 00    	jbe    802988 <__udivdi3+0x108>
  8028e9:	39 d0                	cmp    %edx,%eax
  8028eb:	0f 82 97 00 00 00    	jb     802988 <__udivdi3+0x108>
  8028f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8028f8:	31 d2                	xor    %edx,%edx
  8028fa:	31 c0                	xor    %eax,%eax
  8028fc:	83 c4 0c             	add    $0xc,%esp
  8028ff:	5e                   	pop    %esi
  802900:	5f                   	pop    %edi
  802901:	5d                   	pop    %ebp
  802902:	c3                   	ret    
  802903:	90                   	nop
  802904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802908:	89 f8                	mov    %edi,%eax
  80290a:	f7 f1                	div    %ecx
  80290c:	31 d2                	xor    %edx,%edx
  80290e:	83 c4 0c             	add    $0xc,%esp
  802911:	5e                   	pop    %esi
  802912:	5f                   	pop    %edi
  802913:	5d                   	pop    %ebp
  802914:	c3                   	ret    
  802915:	8d 76 00             	lea    0x0(%esi),%esi
  802918:	89 e9                	mov    %ebp,%ecx
  80291a:	8b 3c 24             	mov    (%esp),%edi
  80291d:	d3 e0                	shl    %cl,%eax
  80291f:	89 c6                	mov    %eax,%esi
  802921:	b8 20 00 00 00       	mov    $0x20,%eax
  802926:	29 e8                	sub    %ebp,%eax
  802928:	89 c1                	mov    %eax,%ecx
  80292a:	d3 ef                	shr    %cl,%edi
  80292c:	89 e9                	mov    %ebp,%ecx
  80292e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802932:	8b 3c 24             	mov    (%esp),%edi
  802935:	09 74 24 08          	or     %esi,0x8(%esp)
  802939:	89 d6                	mov    %edx,%esi
  80293b:	d3 e7                	shl    %cl,%edi
  80293d:	89 c1                	mov    %eax,%ecx
  80293f:	89 3c 24             	mov    %edi,(%esp)
  802942:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802946:	d3 ee                	shr    %cl,%esi
  802948:	89 e9                	mov    %ebp,%ecx
  80294a:	d3 e2                	shl    %cl,%edx
  80294c:	89 c1                	mov    %eax,%ecx
  80294e:	d3 ef                	shr    %cl,%edi
  802950:	09 d7                	or     %edx,%edi
  802952:	89 f2                	mov    %esi,%edx
  802954:	89 f8                	mov    %edi,%eax
  802956:	f7 74 24 08          	divl   0x8(%esp)
  80295a:	89 d6                	mov    %edx,%esi
  80295c:	89 c7                	mov    %eax,%edi
  80295e:	f7 24 24             	mull   (%esp)
  802961:	39 d6                	cmp    %edx,%esi
  802963:	89 14 24             	mov    %edx,(%esp)
  802966:	72 30                	jb     802998 <__udivdi3+0x118>
  802968:	8b 54 24 04          	mov    0x4(%esp),%edx
  80296c:	89 e9                	mov    %ebp,%ecx
  80296e:	d3 e2                	shl    %cl,%edx
  802970:	39 c2                	cmp    %eax,%edx
  802972:	73 05                	jae    802979 <__udivdi3+0xf9>
  802974:	3b 34 24             	cmp    (%esp),%esi
  802977:	74 1f                	je     802998 <__udivdi3+0x118>
  802979:	89 f8                	mov    %edi,%eax
  80297b:	31 d2                	xor    %edx,%edx
  80297d:	e9 7a ff ff ff       	jmp    8028fc <__udivdi3+0x7c>
  802982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802988:	31 d2                	xor    %edx,%edx
  80298a:	b8 01 00 00 00       	mov    $0x1,%eax
  80298f:	e9 68 ff ff ff       	jmp    8028fc <__udivdi3+0x7c>
  802994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802998:	8d 47 ff             	lea    -0x1(%edi),%eax
  80299b:	31 d2                	xor    %edx,%edx
  80299d:	83 c4 0c             	add    $0xc,%esp
  8029a0:	5e                   	pop    %esi
  8029a1:	5f                   	pop    %edi
  8029a2:	5d                   	pop    %ebp
  8029a3:	c3                   	ret    
  8029a4:	66 90                	xchg   %ax,%ax
  8029a6:	66 90                	xchg   %ax,%ax
  8029a8:	66 90                	xchg   %ax,%ax
  8029aa:	66 90                	xchg   %ax,%ax
  8029ac:	66 90                	xchg   %ax,%ax
  8029ae:	66 90                	xchg   %ax,%ax

008029b0 <__umoddi3>:
  8029b0:	55                   	push   %ebp
  8029b1:	57                   	push   %edi
  8029b2:	56                   	push   %esi
  8029b3:	83 ec 14             	sub    $0x14,%esp
  8029b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8029ba:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8029be:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8029c2:	89 c7                	mov    %eax,%edi
  8029c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8029cc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8029d0:	89 34 24             	mov    %esi,(%esp)
  8029d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029d7:	85 c0                	test   %eax,%eax
  8029d9:	89 c2                	mov    %eax,%edx
  8029db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029df:	75 17                	jne    8029f8 <__umoddi3+0x48>
  8029e1:	39 fe                	cmp    %edi,%esi
  8029e3:	76 4b                	jbe    802a30 <__umoddi3+0x80>
  8029e5:	89 c8                	mov    %ecx,%eax
  8029e7:	89 fa                	mov    %edi,%edx
  8029e9:	f7 f6                	div    %esi
  8029eb:	89 d0                	mov    %edx,%eax
  8029ed:	31 d2                	xor    %edx,%edx
  8029ef:	83 c4 14             	add    $0x14,%esp
  8029f2:	5e                   	pop    %esi
  8029f3:	5f                   	pop    %edi
  8029f4:	5d                   	pop    %ebp
  8029f5:	c3                   	ret    
  8029f6:	66 90                	xchg   %ax,%ax
  8029f8:	39 f8                	cmp    %edi,%eax
  8029fa:	77 54                	ja     802a50 <__umoddi3+0xa0>
  8029fc:	0f bd e8             	bsr    %eax,%ebp
  8029ff:	83 f5 1f             	xor    $0x1f,%ebp
  802a02:	75 5c                	jne    802a60 <__umoddi3+0xb0>
  802a04:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802a08:	39 3c 24             	cmp    %edi,(%esp)
  802a0b:	0f 87 e7 00 00 00    	ja     802af8 <__umoddi3+0x148>
  802a11:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a15:	29 f1                	sub    %esi,%ecx
  802a17:	19 c7                	sbb    %eax,%edi
  802a19:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a1d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a21:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a25:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802a29:	83 c4 14             	add    $0x14,%esp
  802a2c:	5e                   	pop    %esi
  802a2d:	5f                   	pop    %edi
  802a2e:	5d                   	pop    %ebp
  802a2f:	c3                   	ret    
  802a30:	85 f6                	test   %esi,%esi
  802a32:	89 f5                	mov    %esi,%ebp
  802a34:	75 0b                	jne    802a41 <__umoddi3+0x91>
  802a36:	b8 01 00 00 00       	mov    $0x1,%eax
  802a3b:	31 d2                	xor    %edx,%edx
  802a3d:	f7 f6                	div    %esi
  802a3f:	89 c5                	mov    %eax,%ebp
  802a41:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a45:	31 d2                	xor    %edx,%edx
  802a47:	f7 f5                	div    %ebp
  802a49:	89 c8                	mov    %ecx,%eax
  802a4b:	f7 f5                	div    %ebp
  802a4d:	eb 9c                	jmp    8029eb <__umoddi3+0x3b>
  802a4f:	90                   	nop
  802a50:	89 c8                	mov    %ecx,%eax
  802a52:	89 fa                	mov    %edi,%edx
  802a54:	83 c4 14             	add    $0x14,%esp
  802a57:	5e                   	pop    %esi
  802a58:	5f                   	pop    %edi
  802a59:	5d                   	pop    %ebp
  802a5a:	c3                   	ret    
  802a5b:	90                   	nop
  802a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a60:	8b 04 24             	mov    (%esp),%eax
  802a63:	be 20 00 00 00       	mov    $0x20,%esi
  802a68:	89 e9                	mov    %ebp,%ecx
  802a6a:	29 ee                	sub    %ebp,%esi
  802a6c:	d3 e2                	shl    %cl,%edx
  802a6e:	89 f1                	mov    %esi,%ecx
  802a70:	d3 e8                	shr    %cl,%eax
  802a72:	89 e9                	mov    %ebp,%ecx
  802a74:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a78:	8b 04 24             	mov    (%esp),%eax
  802a7b:	09 54 24 04          	or     %edx,0x4(%esp)
  802a7f:	89 fa                	mov    %edi,%edx
  802a81:	d3 e0                	shl    %cl,%eax
  802a83:	89 f1                	mov    %esi,%ecx
  802a85:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a89:	8b 44 24 10          	mov    0x10(%esp),%eax
  802a8d:	d3 ea                	shr    %cl,%edx
  802a8f:	89 e9                	mov    %ebp,%ecx
  802a91:	d3 e7                	shl    %cl,%edi
  802a93:	89 f1                	mov    %esi,%ecx
  802a95:	d3 e8                	shr    %cl,%eax
  802a97:	89 e9                	mov    %ebp,%ecx
  802a99:	09 f8                	or     %edi,%eax
  802a9b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802a9f:	f7 74 24 04          	divl   0x4(%esp)
  802aa3:	d3 e7                	shl    %cl,%edi
  802aa5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802aa9:	89 d7                	mov    %edx,%edi
  802aab:	f7 64 24 08          	mull   0x8(%esp)
  802aaf:	39 d7                	cmp    %edx,%edi
  802ab1:	89 c1                	mov    %eax,%ecx
  802ab3:	89 14 24             	mov    %edx,(%esp)
  802ab6:	72 2c                	jb     802ae4 <__umoddi3+0x134>
  802ab8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802abc:	72 22                	jb     802ae0 <__umoddi3+0x130>
  802abe:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802ac2:	29 c8                	sub    %ecx,%eax
  802ac4:	19 d7                	sbb    %edx,%edi
  802ac6:	89 e9                	mov    %ebp,%ecx
  802ac8:	89 fa                	mov    %edi,%edx
  802aca:	d3 e8                	shr    %cl,%eax
  802acc:	89 f1                	mov    %esi,%ecx
  802ace:	d3 e2                	shl    %cl,%edx
  802ad0:	89 e9                	mov    %ebp,%ecx
  802ad2:	d3 ef                	shr    %cl,%edi
  802ad4:	09 d0                	or     %edx,%eax
  802ad6:	89 fa                	mov    %edi,%edx
  802ad8:	83 c4 14             	add    $0x14,%esp
  802adb:	5e                   	pop    %esi
  802adc:	5f                   	pop    %edi
  802add:	5d                   	pop    %ebp
  802ade:	c3                   	ret    
  802adf:	90                   	nop
  802ae0:	39 d7                	cmp    %edx,%edi
  802ae2:	75 da                	jne    802abe <__umoddi3+0x10e>
  802ae4:	8b 14 24             	mov    (%esp),%edx
  802ae7:	89 c1                	mov    %eax,%ecx
  802ae9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802aed:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802af1:	eb cb                	jmp    802abe <__umoddi3+0x10e>
  802af3:	90                   	nop
  802af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802af8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802afc:	0f 82 0f ff ff ff    	jb     802a11 <__umoddi3+0x61>
  802b02:	e9 1a ff ff ff       	jmp    802a21 <__umoddi3+0x71>
