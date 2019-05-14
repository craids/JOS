
obj/net/testinput:     file format elf32-i386


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
  80002c:	e8 5c 09 00 00       	call   80098d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	envid_t ns_envid = sys_getenvid();
  80004c:	e8 a4 14 00 00       	call   8014f5 <sys_getenvid>
  800051:	89 c3                	mov    %eax,%ebx
	int i, r, first = 1;

	binaryname = "testinput";
  800053:	c7 05 00 40 80 00 40 	movl   $0x803440,0x804000
  80005a:	34 80 00 

	output_envid = fork();
  80005d:	e8 1e 19 00 00       	call   801980 <fork>
  800062:	a3 04 50 80 00       	mov    %eax,0x805004
	if (output_envid < 0)
  800067:	85 c0                	test   %eax,%eax
  800069:	79 1c                	jns    800087 <umain+0x47>
		panic("error forking");
  80006b:	c7 44 24 08 4a 34 80 	movl   $0x80344a,0x8(%esp)
  800072:	00 
  800073:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  80007a:	00 
  80007b:	c7 04 24 58 34 80 00 	movl   $0x803458,(%esp)
  800082:	e8 67 09 00 00       	call   8009ee <_panic>
	else if (output_envid == 0) {
  800087:	85 c0                	test   %eax,%eax
  800089:	75 0d                	jne    800098 <umain+0x58>
		output(ns_envid);
  80008b:	89 1c 24             	mov    %ebx,(%esp)
  80008e:	e8 39 05 00 00       	call   8005cc <output>
		return;
  800093:	e9 a5 03 00 00       	jmp    80043d <umain+0x3fd>
	}

	input_envid = fork();
  800098:	e8 e3 18 00 00       	call   801980 <fork>
  80009d:	a3 00 50 80 00       	mov    %eax,0x805000
	if (input_envid < 0)
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	79 1c                	jns    8000c2 <umain+0x82>
		panic("error forking");
  8000a6:	c7 44 24 08 4a 34 80 	movl   $0x80344a,0x8(%esp)
  8000ad:	00 
  8000ae:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  8000b5:	00 
  8000b6:	c7 04 24 58 34 80 00 	movl   $0x803458,(%esp)
  8000bd:	e8 2c 09 00 00       	call   8009ee <_panic>
	else if (input_envid == 0) {
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	75 0f                	jne    8000d5 <umain+0x95>
		input(ns_envid);
  8000c6:	89 1c 24             	mov    %ebx,(%esp)
  8000c9:	e8 47 04 00 00       	call   800515 <input>
		return;
  8000ce:	66 90                	xchg   %ax,%ax
  8000d0:	e9 68 03 00 00       	jmp    80043d <umain+0x3fd>
	}

	cprintf("Sending ARP announcement...\n");
  8000d5:	c7 04 24 68 34 80 00 	movl   $0x803468,(%esp)
  8000dc:	e8 06 0a 00 00       	call   800ae7 <cprintf>
	// with ARP requests.  Ideally, we would use gratuitous ARP
	// for this, but QEMU's ARP implementation is dumb and only
	// listens for very specific ARP requests, such as requests
	// for the gateway IP.

	uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  8000e1:	c6 45 98 52          	movb   $0x52,-0x68(%ebp)
  8000e5:	c6 45 99 54          	movb   $0x54,-0x67(%ebp)
  8000e9:	c6 45 9a 00          	movb   $0x0,-0x66(%ebp)
  8000ed:	c6 45 9b 12          	movb   $0x12,-0x65(%ebp)
  8000f1:	c6 45 9c 34          	movb   $0x34,-0x64(%ebp)
  8000f5:	c6 45 9d 56          	movb   $0x56,-0x63(%ebp)
	uint32_t myip = inet_addr(IP);
  8000f9:	c7 04 24 85 34 80 00 	movl   $0x803485,(%esp)
  800100:	e8 50 08 00 00       	call   800955 <inet_addr>
  800105:	89 45 90             	mov    %eax,-0x70(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  800108:	c7 04 24 8f 34 80 00 	movl   $0x80348f,(%esp)
  80010f:	e8 41 08 00 00       	call   800955 <inet_addr>
  800114:	89 45 94             	mov    %eax,-0x6c(%ebp)
	int r;

	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800117:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  800126:	0f 
  800127:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80012e:	e8 00 14 00 00       	call   801533 <sys_page_alloc>
  800133:	85 c0                	test   %eax,%eax
  800135:	79 20                	jns    800157 <umain+0x117>
		panic("sys_page_map: %e", r);
  800137:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013b:	c7 44 24 08 98 34 80 	movl   $0x803498,0x8(%esp)
  800142:	00 
  800143:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  80014a:	00 
  80014b:	c7 04 24 58 34 80 00 	movl   $0x803458,(%esp)
  800152:	e8 97 08 00 00       	call   8009ee <_panic>

	struct etharp_hdr *arp = (struct etharp_hdr*)pkt->jp_data;
	pkt->jp_len = sizeof(*arp);
  800157:	c7 05 00 b0 fe 0f 2a 	movl   $0x2a,0xffeb000
  80015e:	00 00 00 

	memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  800161:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800168:	00 
  800169:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800170:	00 
  800171:	c7 04 24 04 b0 fe 0f 	movl   $0xffeb004,(%esp)
  800178:	e8 ea 10 00 00       	call   801267 <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  80017d:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800184:	00 
  800185:	8d 5d 98             	lea    -0x68(%ebp),%ebx
  800188:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80018c:	c7 04 24 0a b0 fe 0f 	movl   $0xffeb00a,(%esp)
  800193:	e8 84 11 00 00       	call   80131c <memcpy>
	arp->ethhdr.type = htons(ETHTYPE_ARP);
  800198:	c7 04 24 06 08 00 00 	movl   $0x806,(%esp)
  80019f:	e8 82 05 00 00       	call   800726 <htons>
  8001a4:	66 a3 10 b0 fe 0f    	mov    %ax,0xffeb010
	arp->hwtype = htons(1); // Ethernet
  8001aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001b1:	e8 70 05 00 00       	call   800726 <htons>
  8001b6:	66 a3 12 b0 fe 0f    	mov    %ax,0xffeb012
	arp->proto = htons(ETHTYPE_IP);
  8001bc:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  8001c3:	e8 5e 05 00 00       	call   800726 <htons>
  8001c8:	66 a3 14 b0 fe 0f    	mov    %ax,0xffeb014
	arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  8001ce:	c7 04 24 04 06 00 00 	movl   $0x604,(%esp)
  8001d5:	e8 4c 05 00 00       	call   800726 <htons>
  8001da:	66 a3 16 b0 fe 0f    	mov    %ax,0xffeb016
	arp->opcode = htons(ARP_REQUEST);
  8001e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001e7:	e8 3a 05 00 00       	call   800726 <htons>
  8001ec:	66 a3 18 b0 fe 0f    	mov    %ax,0xffeb018
	memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  8001f2:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  8001f9:	00 
  8001fa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001fe:	c7 04 24 1a b0 fe 0f 	movl   $0xffeb01a,(%esp)
  800205:	e8 12 11 00 00       	call   80131c <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  80020a:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800211:	00 
  800212:	8d 45 90             	lea    -0x70(%ebp),%eax
  800215:	89 44 24 04          	mov    %eax,0x4(%esp)
  800219:	c7 04 24 20 b0 fe 0f 	movl   $0xffeb020,(%esp)
  800220:	e8 f7 10 00 00       	call   80131c <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  800225:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  80022c:	00 
  80022d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800234:	00 
  800235:	c7 04 24 24 b0 fe 0f 	movl   $0xffeb024,(%esp)
  80023c:	e8 26 10 00 00       	call   801267 <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  800241:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800248:	00 
  800249:	8d 45 94             	lea    -0x6c(%ebp),%eax
  80024c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800250:	c7 04 24 2a b0 fe 0f 	movl   $0xffeb02a,(%esp)
  800257:	e8 c0 10 00 00       	call   80131c <memcpy>

	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  80025c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800263:	00 
  800264:	c7 44 24 08 00 b0 fe 	movl   $0xffeb000,0x8(%esp)
  80026b:	0f 
  80026c:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800273:	00 
  800274:	a1 04 50 80 00       	mov    0x805004,%eax
  800279:	89 04 24             	mov    %eax,(%esp)
  80027c:	e8 67 1a 00 00       	call   801ce8 <ipc_send>
	sys_page_unmap(0, pkt);
  800281:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  800288:	0f 
  800289:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800290:	e8 45 13 00 00       	call   8015da <sys_page_unmap>

void
umain(int argc, char **argv)
{
	envid_t ns_envid = sys_getenvid();
	int i, r, first = 1;
  800295:	c7 85 7c ff ff ff 01 	movl   $0x1,-0x84(%ebp)
  80029c:	00 00 00 

	while (1) {
		envid_t whom;
		int perm;

		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  80029f:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8002a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002a6:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  8002ad:	0f 
  8002ae:	8d 45 90             	lea    -0x70(%ebp),%eax
  8002b1:	89 04 24             	mov    %eax,(%esp)
  8002b4:	e8 c7 19 00 00       	call   801c80 <ipc_recv>
		if (req < 0)
  8002b9:	85 c0                	test   %eax,%eax
  8002bb:	79 20                	jns    8002dd <umain+0x29d>
			panic("ipc_recv: %e", req);
  8002bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002c1:	c7 44 24 08 a9 34 80 	movl   $0x8034a9,0x8(%esp)
  8002c8:	00 
  8002c9:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8002d0:	00 
  8002d1:	c7 04 24 58 34 80 00 	movl   $0x803458,(%esp)
  8002d8:	e8 11 07 00 00       	call   8009ee <_panic>
		if (whom != input_envid)
  8002dd:	8b 55 90             	mov    -0x70(%ebp),%edx
  8002e0:	3b 15 00 50 80 00    	cmp    0x805000,%edx
  8002e6:	74 20                	je     800308 <umain+0x2c8>
			panic("IPC from unexpected environment %08x", whom);
  8002e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002ec:	c7 44 24 08 00 35 80 	movl   $0x803500,0x8(%esp)
  8002f3:	00 
  8002f4:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8002fb:	00 
  8002fc:	c7 04 24 58 34 80 00 	movl   $0x803458,(%esp)
  800303:	e8 e6 06 00 00       	call   8009ee <_panic>
		if (req != NSREQ_INPUT)
  800308:	83 f8 0a             	cmp    $0xa,%eax
  80030b:	74 20                	je     80032d <umain+0x2ed>
			panic("Unexpected IPC %d", req);
  80030d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800311:	c7 44 24 08 b6 34 80 	movl   $0x8034b6,0x8(%esp)
  800318:	00 
  800319:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
  800320:	00 
  800321:	c7 04 24 58 34 80 00 	movl   $0x803458,(%esp)
  800328:	e8 c1 06 00 00       	call   8009ee <_panic>

		hexdump("input: ", pkt->jp_data, pkt->jp_len);
  80032d:	a1 00 b0 fe 0f       	mov    0xffeb000,%eax
  800332:	89 45 84             	mov    %eax,-0x7c(%ebp)
hexdump(const char *prefix, const void *data, int len)
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
  800335:	be 00 00 00 00       	mov    $0x0,%esi
	for (i = 0; i < len; i++) {
  80033a:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (i % 16 == 0)
			out = buf + snprintf(buf, end - buf,
					     "%s%04x   ", prefix, i);
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
		if (i % 16 == 15 || i == len - 1)
  80033f:	83 e8 01             	sub    $0x1,%eax
  800342:	89 45 80             	mov    %eax,-0x80(%ebp)
  800345:	e9 ba 00 00 00       	jmp    800404 <umain+0x3c4>
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
		if (i % 16 == 0)
  80034a:	89 df                	mov    %ebx,%edi
  80034c:	f6 c3 0f             	test   $0xf,%bl
  80034f:	75 2d                	jne    80037e <umain+0x33e>
			out = buf + snprintf(buf, end - buf,
  800351:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  800355:	c7 44 24 0c c8 34 80 	movl   $0x8034c8,0xc(%esp)
  80035c:	00 
  80035d:	c7 44 24 08 d0 34 80 	movl   $0x8034d0,0x8(%esp)
  800364:	00 
  800365:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  80036c:	00 
  80036d:	8d 45 98             	lea    -0x68(%ebp),%eax
  800370:	89 04 24             	mov    %eax,(%esp)
  800373:	e8 32 0d 00 00       	call   8010aa <snprintf>
  800378:	8d 4d 98             	lea    -0x68(%ebp),%ecx
  80037b:	8d 34 01             	lea    (%ecx,%eax,1),%esi
					     "%s%04x   ", prefix, i);
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  80037e:	b8 04 b0 fe 0f       	mov    $0xffeb004,%eax
  800383:	0f b6 04 38          	movzbl (%eax,%edi,1),%eax
  800387:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80038b:	c7 44 24 08 da 34 80 	movl   $0x8034da,0x8(%esp)
  800392:	00 
  800393:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800396:	29 f0                	sub    %esi,%eax
  800398:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039c:	89 34 24             	mov    %esi,(%esp)
  80039f:	e8 06 0d 00 00       	call   8010aa <snprintf>
  8003a4:	01 c6                	add    %eax,%esi
		if (i % 16 == 15 || i == len - 1)
  8003a6:	89 d8                	mov    %ebx,%eax
  8003a8:	c1 f8 1f             	sar    $0x1f,%eax
  8003ab:	c1 e8 1c             	shr    $0x1c,%eax
  8003ae:	8d 3c 03             	lea    (%ebx,%eax,1),%edi
  8003b1:	83 e7 0f             	and    $0xf,%edi
  8003b4:	29 c7                	sub    %eax,%edi
  8003b6:	83 ff 0f             	cmp    $0xf,%edi
  8003b9:	74 05                	je     8003c0 <umain+0x380>
  8003bb:	3b 5d 80             	cmp    -0x80(%ebp),%ebx
  8003be:	75 1e                	jne    8003de <umain+0x39e>
			cprintf("%.*s\n", out - buf, buf);
  8003c0:	8d 45 98             	lea    -0x68(%ebp),%eax
  8003c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003c7:	89 f0                	mov    %esi,%eax
  8003c9:	8d 4d 98             	lea    -0x68(%ebp),%ecx
  8003cc:	29 c8                	sub    %ecx,%eax
  8003ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d2:	c7 04 24 df 34 80 00 	movl   $0x8034df,(%esp)
  8003d9:	e8 09 07 00 00       	call   800ae7 <cprintf>
		if (i % 2 == 1)
  8003de:	89 d8                	mov    %ebx,%eax
  8003e0:	c1 e8 1f             	shr    $0x1f,%eax
  8003e3:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8003e6:	83 e2 01             	and    $0x1,%edx
  8003e9:	29 c2                	sub    %eax,%edx
  8003eb:	83 fa 01             	cmp    $0x1,%edx
  8003ee:	75 06                	jne    8003f6 <umain+0x3b6>
			*(out++) = ' ';
  8003f0:	c6 06 20             	movb   $0x20,(%esi)
  8003f3:	8d 76 01             	lea    0x1(%esi),%esi
		if (i % 16 == 7)
  8003f6:	83 ff 07             	cmp    $0x7,%edi
  8003f9:	75 06                	jne    800401 <umain+0x3c1>
			*(out++) = ' ';
  8003fb:	c6 06 20             	movb   $0x20,(%esi)
  8003fe:	8d 76 01             	lea    0x1(%esi),%esi
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
  800401:	83 c3 01             	add    $0x1,%ebx
  800404:	39 5d 84             	cmp    %ebx,-0x7c(%ebp)
  800407:	0f 8f 3d ff ff ff    	jg     80034a <umain+0x30a>
			panic("IPC from unexpected environment %08x", whom);
		if (req != NSREQ_INPUT)
			panic("Unexpected IPC %d", req);

		hexdump("input: ", pkt->jp_data, pkt->jp_len);
		cprintf("\n");
  80040d:	c7 04 24 fb 34 80 00 	movl   $0x8034fb,(%esp)
  800414:	e8 ce 06 00 00       	call   800ae7 <cprintf>

		// Only indicate that we're waiting for packets once
		// we've received the ARP reply
		if (first)
  800419:	83 bd 7c ff ff ff 00 	cmpl   $0x0,-0x84(%ebp)
  800420:	74 0c                	je     80042e <umain+0x3ee>
			cprintf("Waiting for packets...\n");
  800422:	c7 04 24 e5 34 80 00 	movl   $0x8034e5,(%esp)
  800429:	e8 b9 06 00 00       	call   800ae7 <cprintf>
		first = 0;
  80042e:	c7 85 7c ff ff ff 00 	movl   $0x0,-0x84(%ebp)
  800435:	00 00 00 
	}
  800438:	e9 62 fe ff ff       	jmp    80029f <umain+0x25f>
}
  80043d:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  800443:	5b                   	pop    %ebx
  800444:	5e                   	pop    %esi
  800445:	5f                   	pop    %edi
  800446:	5d                   	pop    %ebp
  800447:	c3                   	ret    
  800448:	66 90                	xchg   %ax,%ax
  80044a:	66 90                	xchg   %ax,%ax
  80044c:	66 90                	xchg   %ax,%ax
  80044e:	66 90                	xchg   %ax,%ax

00800450 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
  800453:	57                   	push   %edi
  800454:	56                   	push   %esi
  800455:	53                   	push   %ebx
  800456:	83 ec 2c             	sub    $0x2c,%esp
  800459:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  80045c:	e8 3a 13 00 00       	call   80179b <sys_time_msec>
  800461:	03 45 0c             	add    0xc(%ebp),%eax
  800464:	89 c6                	mov    %eax,%esi

	binaryname = "ns_timer";
  800466:	c7 05 00 40 80 00 25 	movl   $0x803525,0x804000
  80046d:	35 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800470:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800473:	eb 05                	jmp    80047a <timer+0x2a>

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
			sys_yield();
  800475:	e8 9a 10 00 00       	call   801514 <sys_yield>
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
  80047a:	e8 1c 13 00 00       	call   80179b <sys_time_msec>
  80047f:	39 c6                	cmp    %eax,%esi
  800481:	76 06                	jbe    800489 <timer+0x39>
  800483:	85 c0                	test   %eax,%eax
  800485:	79 ee                	jns    800475 <timer+0x25>
  800487:	eb 09                	jmp    800492 <timer+0x42>
			sys_yield();
		}
		if (r < 0)
  800489:	85 c0                	test   %eax,%eax
  80048b:	90                   	nop
  80048c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800490:	79 20                	jns    8004b2 <timer+0x62>
			panic("sys_time_msec: %e", r);
  800492:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800496:	c7 44 24 08 2e 35 80 	movl   $0x80352e,0x8(%esp)
  80049d:	00 
  80049e:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8004a5:	00 
  8004a6:	c7 04 24 40 35 80 00 	movl   $0x803540,(%esp)
  8004ad:	e8 3c 05 00 00       	call   8009ee <_panic>

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8004b2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004b9:	00 
  8004ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8004c1:	00 
  8004c2:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  8004c9:	00 
  8004ca:	89 1c 24             	mov    %ebx,(%esp)
  8004cd:	e8 16 18 00 00       	call   801ce8 <ipc_send>

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8004d2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8004d9:	00 
  8004da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004e1:	00 
  8004e2:	89 3c 24             	mov    %edi,(%esp)
  8004e5:	e8 96 17 00 00       	call   801c80 <ipc_recv>
  8004ea:	89 c6                	mov    %eax,%esi

			if (whom != ns_envid) {
  8004ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004ef:	39 c3                	cmp    %eax,%ebx
  8004f1:	74 12                	je     800505 <timer+0xb5>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8004f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004f7:	c7 04 24 4c 35 80 00 	movl   $0x80354c,(%esp)
  8004fe:	e8 e4 05 00 00       	call   800ae7 <cprintf>
  800503:	eb cd                	jmp    8004d2 <timer+0x82>
				continue;
			}

			stop = sys_time_msec() + to;
  800505:	e8 91 12 00 00       	call   80179b <sys_time_msec>
  80050a:	01 c6                	add    %eax,%esi
  80050c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800510:	e9 65 ff ff ff       	jmp    80047a <timer+0x2a>

00800515 <input>:

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	57                   	push   %edi
  800519:	56                   	push   %esi
  80051a:	53                   	push   %ebx
  80051b:	81 ec 2c 08 00 00    	sub    $0x82c,%esp
  800521:	8b 7d 08             	mov    0x8(%ebp),%edi
	binaryname = "ns_input";
  800524:	c7 05 00 40 80 00 87 	movl   $0x803587,0x804000
  80052b:	35 80 00 
	int perm = PTE_P | PTE_W | PTE_U;
	size_t length;
	char pkt[PKT_BUF_SIZE];

	while (1) {
		while (sys_e1000_receive(pkt, &length) == -E_E1000_RXBUF_EMPTY);
  80052e:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800531:	8d 9d e4 f7 ff ff    	lea    -0x81c(%ebp),%ebx
  800537:	89 74 24 04          	mov    %esi,0x4(%esp)
  80053b:	89 1c 24             	mov    %ebx,(%esp)
  80053e:	e8 98 12 00 00       	call   8017db <sys_e1000_receive>
  800543:	83 f8 ef             	cmp    $0xffffffef,%eax
  800546:	74 ef                	je     800537 <input+0x22>

		int r;
		if ((r = sys_page_alloc(0, &nsipcbuf, perm)) < 0)
  800548:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80054f:	00 
  800550:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  800557:	00 
  800558:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80055f:	e8 cf 0f 00 00       	call   801533 <sys_page_alloc>
  800564:	85 c0                	test   %eax,%eax
  800566:	79 20                	jns    800588 <input+0x73>
			panic("input: unable to allocate new page, error %e\n", r);
  800568:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80056c:	c7 44 24 08 9c 35 80 	movl   $0x80359c,0x8(%esp)
  800573:	00 
  800574:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  80057b:	00 
  80057c:	c7 04 24 90 35 80 00 	movl   $0x803590,(%esp)
  800583:	e8 66 04 00 00       	call   8009ee <_panic>

		memmove(nsipcbuf.pkt.jp_data, pkt, length);
  800588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80058b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80058f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800593:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80059a:	e8 15 0d 00 00       	call   8012b4 <memmove>
		nsipcbuf.pkt.jp_len = length;
  80059f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005a2:	a3 00 70 80 00       	mov    %eax,0x807000

		ipc_send(ns_envid, NSREQ_INPUT, &nsipcbuf, perm);
  8005a7:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8005ae:	00 
  8005af:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8005b6:	00 
  8005b7:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8005be:	00 
  8005bf:	89 3c 24             	mov    %edi,(%esp)
  8005c2:	e8 21 17 00 00       	call   801ce8 <ipc_send>
	}
  8005c7:	e9 6b ff ff ff       	jmp    800537 <input+0x22>

008005cc <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  8005cc:	55                   	push   %ebp
  8005cd:	89 e5                	mov    %esp,%ebp
  8005cf:	57                   	push   %edi
  8005d0:	56                   	push   %esi
  8005d1:	53                   	push   %ebx
  8005d2:	83 ec 2c             	sub    $0x2c,%esp
  8005d5:	8b 7d 08             	mov    0x8(%ebp),%edi
	binaryname = "ns_output";
  8005d8:	c7 05 00 40 80 00 ca 	movl   $0x8035ca,0x804000
  8005df:	35 80 00 
	uint32_t req;
	int perm;

	while(1) {
		perm = 0;
		req = ipc_recv(&sender_envid, &nsipcbuf, &perm);
  8005e2:	8d 75 e0             	lea    -0x20(%ebp),%esi
  8005e5:	8d 5d e4             	lea    -0x1c(%ebp),%ebx
	envid_t sender_envid;
	uint32_t req;
	int perm;

	while(1) {
		perm = 0;
  8005e8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		req = ipc_recv(&sender_envid, &nsipcbuf, &perm);
  8005ef:	89 74 24 08          	mov    %esi,0x8(%esp)
  8005f3:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8005fa:	00 
  8005fb:	89 1c 24             	mov    %ebx,(%esp)
  8005fe:	e8 7d 16 00 00       	call   801c80 <ipc_recv>

		if (((uint32_t *) sender_envid == 0) || (perm == 0)) {
  800603:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800606:	85 d2                	test   %edx,%edx
  800608:	74 06                	je     800610 <output+0x44>
  80060a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80060e:	75 12                	jne    800622 <output+0x56>
			cprintf("Invalid request; ipc_recv encountered an error %e\n", req);
  800610:	89 44 24 04          	mov    %eax,0x4(%esp)
  800614:	c7 04 24 d4 35 80 00 	movl   $0x8035d4,(%esp)
  80061b:	e8 c7 04 00 00       	call   800ae7 <cprintf>
			continue;
  800620:	eb c6                	jmp    8005e8 <output+0x1c>
		}

		if (sender_envid != ns_envid) {
  800622:	39 fa                	cmp    %edi,%edx
  800624:	74 16                	je     80063c <output+0x70>
			cprintf("Received IPC from envid %08x, expected to receive from %08x\n",
  800626:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80062a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80062e:	c7 04 24 08 36 80 00 	movl   $0x803608,(%esp)
  800635:	e8 ad 04 00 00       	call   800ae7 <cprintf>
				sender_envid, ns_envid);
			continue;
  80063a:	eb ac                	jmp    8005e8 <output+0x1c>
		}

		if (sys_e1000_transmit(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len) == -E_E1000_TXBUF_FULL)
  80063c:	a1 00 70 80 00       	mov    0x807000,%eax
  800641:	89 44 24 04          	mov    %eax,0x4(%esp)
  800645:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80064c:	e8 69 11 00 00       	call   8017ba <sys_e1000_transmit>
  800651:	83 f8 f0             	cmp    $0xfffffff0,%eax
  800654:	75 92                	jne    8005e8 <output+0x1c>
			cprintf("Dropping packet, after 20 tries cannot transmit");
  800656:	c7 04 24 48 36 80 00 	movl   $0x803648,(%esp)
  80065d:	e8 85 04 00 00       	call   800ae7 <cprintf>
  800662:	eb 84                	jmp    8005e8 <output+0x1c>
  800664:	66 90                	xchg   %ax,%ax
  800666:	66 90                	xchg   %ax,%ax
  800668:	66 90                	xchg   %ax,%ax
  80066a:	66 90                	xchg   %ax,%ax
  80066c:	66 90                	xchg   %ax,%ax
  80066e:	66 90                	xchg   %ax,%ax

00800670 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800670:	55                   	push   %ebp
  800671:	89 e5                	mov    %esp,%ebp
  800673:	57                   	push   %edi
  800674:	56                   	push   %esi
  800675:	53                   	push   %ebx
  800676:	83 ec 19             	sub    $0x19,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80067f:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  800683:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  800686:	c7 45 dc 08 50 80 00 	movl   $0x805008,-0x24(%ebp)
 */
char *
inet_ntoa(struct in_addr addr)
{
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80068d:	be 00 00 00 00       	mov    $0x0,%esi
  800692:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800695:	eb 02                	jmp    800699 <inet_ntoa+0x29>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  800697:	89 ce                	mov    %ecx,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800699:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80069c:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  80069f:	0f b6 c2             	movzbl %dl,%eax
  8006a2:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  8006a5:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
  8006a8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8006ab:	66 c1 e8 0b          	shr    $0xb,%ax
  8006af:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  8006b1:	8d 4e 01             	lea    0x1(%esi),%ecx
  8006b4:	89 f3                	mov    %esi,%ebx
  8006b6:	0f b6 f3             	movzbl %bl,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  8006b9:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  8006bc:	01 ff                	add    %edi,%edi
  8006be:	89 fb                	mov    %edi,%ebx
  8006c0:	29 da                	sub    %ebx,%edx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
  8006c2:	83 c2 30             	add    $0x30,%edx
  8006c5:	88 54 35 ed          	mov    %dl,-0x13(%ebp,%esi,1)
    } while(*ap);
  8006c9:	84 c0                	test   %al,%al
  8006cb:	75 ca                	jne    800697 <inet_ntoa+0x27>
  8006cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006d0:	89 c8                	mov    %ecx,%eax
  8006d2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006d5:	89 cf                	mov    %ecx,%edi
  8006d7:	eb 0d                	jmp    8006e6 <inet_ntoa+0x76>
    while(i--)
      *rp++ = inv[i];
  8006d9:	0f b6 f0             	movzbl %al,%esi
  8006dc:	0f b6 4c 35 ed       	movzbl -0x13(%ebp,%esi,1),%ecx
  8006e1:	88 0a                	mov    %cl,(%edx)
  8006e3:	83 c2 01             	add    $0x1,%edx
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8006e6:	83 e8 01             	sub    $0x1,%eax
  8006e9:	3c ff                	cmp    $0xff,%al
  8006eb:	75 ec                	jne    8006d9 <inet_ntoa+0x69>
  8006ed:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  8006f0:	89 f9                	mov    %edi,%ecx
  8006f2:	0f b6 c9             	movzbl %cl,%ecx
  8006f5:	03 4d dc             	add    -0x24(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  8006f8:	8d 41 01             	lea    0x1(%ecx),%eax
  8006fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
    ap++;
  8006fe:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  800702:	80 45 db 01          	addb   $0x1,-0x25(%ebp)
  800706:	80 7d db 03          	cmpb   $0x3,-0x25(%ebp)
  80070a:	77 0a                	ja     800716 <inet_ntoa+0xa6>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  80070c:	c6 01 2e             	movb   $0x2e,(%ecx)
  80070f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800714:	eb 81                	jmp    800697 <inet_ntoa+0x27>
    ap++;
  }
  *--rp = 0;
  800716:	c6 01 00             	movb   $0x0,(%ecx)
  return str;
}
  800719:	b8 08 50 80 00       	mov    $0x805008,%eax
  80071e:	83 c4 19             	add    $0x19,%esp
  800721:	5b                   	pop    %ebx
  800722:	5e                   	pop    %esi
  800723:	5f                   	pop    %edi
  800724:	5d                   	pop    %ebp
  800725:	c3                   	ret    

00800726 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800729:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80072d:	66 c1 c0 08          	rol    $0x8,%ax
}
  800731:	5d                   	pop    %ebp
  800732:	c3                   	ret    

00800733 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800733:	55                   	push   %ebp
  800734:	89 e5                	mov    %esp,%ebp
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800736:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80073a:	66 c1 c0 08          	rol    $0x8,%ax
 */
u16_t
ntohs(u16_t n)
{
  return htons(n);
}
  80073e:	5d                   	pop    %ebp
  80073f:	c3                   	ret    

00800740 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  800746:	89 d1                	mov    %edx,%ecx
  800748:	c1 e9 18             	shr    $0x18,%ecx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80074b:	89 d0                	mov    %edx,%eax
  80074d:	c1 e0 18             	shl    $0x18,%eax
  800750:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  800752:	89 d1                	mov    %edx,%ecx
  800754:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  80075a:	c1 e1 08             	shl    $0x8,%ecx
  80075d:	09 c8                	or     %ecx,%eax
    ((n & 0xff0000UL) >> 8) |
  80075f:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  800765:	c1 ea 08             	shr    $0x8,%edx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  800768:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80076a:	5d                   	pop    %ebp
  80076b:	c3                   	ret    

0080076c <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80076c:	55                   	push   %ebp
  80076d:	89 e5                	mov    %esp,%ebp
  80076f:	57                   	push   %edi
  800770:	56                   	push   %esi
  800771:	53                   	push   %ebx
  800772:	83 ec 20             	sub    $0x20,%esp
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  800778:	0f be 10             	movsbl (%eax),%edx
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  80077b:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80077e:	89 75 d8             	mov    %esi,-0x28(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  800781:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800784:	80 f9 09             	cmp    $0x9,%cl
  800787:	0f 87 a6 01 00 00    	ja     800933 <inet_aton+0x1c7>
      return (0);
    val = 0;
    base = 10;
  80078d:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
    if (c == '0') {
  800794:	83 fa 30             	cmp    $0x30,%edx
  800797:	75 2b                	jne    8007c4 <inet_aton+0x58>
      c = *++cp;
  800799:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  80079d:	89 d1                	mov    %edx,%ecx
  80079f:	83 e1 df             	and    $0xffffffdf,%ecx
  8007a2:	80 f9 58             	cmp    $0x58,%cl
  8007a5:	74 0f                	je     8007b6 <inet_aton+0x4a>
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
  8007a7:	83 c0 01             	add    $0x1,%eax
  8007aa:	0f be d2             	movsbl %dl,%edx
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
      } else
        base = 8;
  8007ad:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  8007b4:	eb 0e                	jmp    8007c4 <inet_aton+0x58>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  8007b6:	0f be 50 02          	movsbl 0x2(%eax),%edx
  8007ba:	8d 40 02             	lea    0x2(%eax),%eax
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  8007bd:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  8007c4:	83 c0 01             	add    $0x1,%eax
  8007c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8007cc:	eb 03                	jmp    8007d1 <inet_aton+0x65>
  8007ce:	83 c0 01             	add    $0x1,%eax
  8007d1:	8d 70 ff             	lea    -0x1(%eax),%esi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  8007d4:	89 d3                	mov    %edx,%ebx
  8007d6:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8007d9:	80 f9 09             	cmp    $0x9,%cl
  8007dc:	77 0d                	ja     8007eb <inet_aton+0x7f>
        val = (val * base) + (int)(c - '0');
  8007de:	0f af 7d e0          	imul   -0x20(%ebp),%edi
  8007e2:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  8007e6:	0f be 10             	movsbl (%eax),%edx
  8007e9:	eb e3                	jmp    8007ce <inet_aton+0x62>
      } else if (base == 16 && isxdigit(c)) {
  8007eb:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  8007ef:	75 30                	jne    800821 <inet_aton+0xb5>
  8007f1:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
  8007f4:	88 4d df             	mov    %cl,-0x21(%ebp)
  8007f7:	89 d1                	mov    %edx,%ecx
  8007f9:	83 e1 df             	and    $0xffffffdf,%ecx
  8007fc:	83 e9 41             	sub    $0x41,%ecx
  8007ff:	80 f9 05             	cmp    $0x5,%cl
  800802:	77 23                	ja     800827 <inet_aton+0xbb>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  800804:	89 fb                	mov    %edi,%ebx
  800806:	c1 e3 04             	shl    $0x4,%ebx
  800809:	8d 7a 0a             	lea    0xa(%edx),%edi
  80080c:	80 7d df 1a          	cmpb   $0x1a,-0x21(%ebp)
  800810:	19 c9                	sbb    %ecx,%ecx
  800812:	83 e1 20             	and    $0x20,%ecx
  800815:	83 c1 41             	add    $0x41,%ecx
  800818:	29 cf                	sub    %ecx,%edi
  80081a:	09 df                	or     %ebx,%edi
        c = *++cp;
  80081c:	0f be 10             	movsbl (%eax),%edx
  80081f:	eb ad                	jmp    8007ce <inet_aton+0x62>
  800821:	89 d0                	mov    %edx,%eax
  800823:	89 f9                	mov    %edi,%ecx
  800825:	eb 04                	jmp    80082b <inet_aton+0xbf>
  800827:	89 d0                	mov    %edx,%eax
  800829:	89 f9                	mov    %edi,%ecx
      } else
        break;
    }
    if (c == '.') {
  80082b:	83 f8 2e             	cmp    $0x2e,%eax
  80082e:	75 22                	jne    800852 <inet_aton+0xe6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  800830:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800833:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  800836:	0f 84 fe 00 00 00    	je     80093a <inet_aton+0x1ce>
        return (0);
      *pp++ = val;
  80083c:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  800840:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800843:	89 48 fc             	mov    %ecx,-0x4(%eax)
      c = *++cp;
  800846:	8d 46 01             	lea    0x1(%esi),%eax
  800849:	0f be 56 01          	movsbl 0x1(%esi),%edx
    } else
      break;
  }
  80084d:	e9 2f ff ff ff       	jmp    800781 <inet_aton+0x15>
  800852:	89 f9                	mov    %edi,%ecx
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800854:	85 d2                	test   %edx,%edx
  800856:	74 27                	je     80087f <inet_aton+0x113>
    return (0);
  800858:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80085d:	80 fb 1f             	cmp    $0x1f,%bl
  800860:	0f 86 e7 00 00 00    	jbe    80094d <inet_aton+0x1e1>
  800866:	84 d2                	test   %dl,%dl
  800868:	0f 88 d3 00 00 00    	js     800941 <inet_aton+0x1d5>
  80086e:	83 fa 20             	cmp    $0x20,%edx
  800871:	74 0c                	je     80087f <inet_aton+0x113>
  800873:	83 ea 09             	sub    $0x9,%edx
  800876:	83 fa 04             	cmp    $0x4,%edx
  800879:	0f 87 ce 00 00 00    	ja     80094d <inet_aton+0x1e1>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  80087f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800882:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800885:	29 c2                	sub    %eax,%edx
  800887:	c1 fa 02             	sar    $0x2,%edx
  80088a:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  80088d:	83 fa 02             	cmp    $0x2,%edx
  800890:	74 22                	je     8008b4 <inet_aton+0x148>
  800892:	83 fa 02             	cmp    $0x2,%edx
  800895:	7f 0f                	jg     8008a6 <inet_aton+0x13a>

  case 0:
    return (0);       /* initial nondigit */
  800897:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  80089c:	85 d2                	test   %edx,%edx
  80089e:	0f 84 a9 00 00 00    	je     80094d <inet_aton+0x1e1>
  8008a4:	eb 73                	jmp    800919 <inet_aton+0x1ad>
  8008a6:	83 fa 03             	cmp    $0x3,%edx
  8008a9:	74 26                	je     8008d1 <inet_aton+0x165>
  8008ab:	83 fa 04             	cmp    $0x4,%edx
  8008ae:	66 90                	xchg   %ax,%ax
  8008b0:	74 40                	je     8008f2 <inet_aton+0x186>
  8008b2:	eb 65                	jmp    800919 <inet_aton+0x1ad>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  8008b4:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8008b9:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  8008bf:	0f 87 88 00 00 00    	ja     80094d <inet_aton+0x1e1>
      return (0);
    val |= parts[0] << 24;
  8008c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008c8:	c1 e0 18             	shl    $0x18,%eax
  8008cb:	89 cf                	mov    %ecx,%edi
  8008cd:	09 c7                	or     %eax,%edi
    break;
  8008cf:	eb 48                	jmp    800919 <inet_aton+0x1ad>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  8008d1:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8008d6:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  8008dc:	77 6f                	ja     80094d <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  8008de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008e1:	c1 e2 10             	shl    $0x10,%edx
  8008e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008e7:	c1 e0 18             	shl    $0x18,%eax
  8008ea:	09 d0                	or     %edx,%eax
  8008ec:	09 c8                	or     %ecx,%eax
  8008ee:	89 c7                	mov    %eax,%edi
    break;
  8008f0:	eb 27                	jmp    800919 <inet_aton+0x1ad>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  8008f2:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  8008f7:	81 f9 ff 00 00 00    	cmp    $0xff,%ecx
  8008fd:	77 4e                	ja     80094d <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8008ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800902:	c1 e2 10             	shl    $0x10,%edx
  800905:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800908:	c1 e0 18             	shl    $0x18,%eax
  80090b:	09 c2                	or     %eax,%edx
  80090d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800910:	c1 e0 08             	shl    $0x8,%eax
  800913:	09 d0                	or     %edx,%eax
  800915:	09 c8                	or     %ecx,%eax
  800917:	89 c7                	mov    %eax,%edi
    break;
  }
  if (addr)
  800919:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80091d:	74 29                	je     800948 <inet_aton+0x1dc>
    addr->s_addr = htonl(val);
  80091f:	89 3c 24             	mov    %edi,(%esp)
  800922:	e8 19 fe ff ff       	call   800740 <htonl>
  800927:	8b 75 0c             	mov    0xc(%ebp),%esi
  80092a:	89 06                	mov    %eax,(%esi)
  return (1);
  80092c:	b8 01 00 00 00       	mov    $0x1,%eax
  800931:	eb 1a                	jmp    80094d <inet_aton+0x1e1>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  800933:	b8 00 00 00 00       	mov    $0x0,%eax
  800938:	eb 13                	jmp    80094d <inet_aton+0x1e1>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  80093a:	b8 00 00 00 00       	mov    $0x0,%eax
  80093f:	eb 0c                	jmp    80094d <inet_aton+0x1e1>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  800941:	b8 00 00 00 00       	mov    $0x0,%eax
  800946:	eb 05                	jmp    80094d <inet_aton+0x1e1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  800948:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80094d:	83 c4 20             	add    $0x20,%esp
  800950:	5b                   	pop    %ebx
  800951:	5e                   	pop    %esi
  800952:	5f                   	pop    %edi
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  80095b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80095e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	89 04 24             	mov    %eax,(%esp)
  800968:	e8 ff fd ff ff       	call   80076c <inet_aton>
  80096d:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  80096f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800974:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  800978:	c9                   	leave  
  800979:	c3                   	ret    

0080097a <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	89 04 24             	mov    %eax,(%esp)
  800986:	e8 b5 fd ff ff       	call   800740 <htonl>
}
  80098b:	c9                   	leave  
  80098c:	c3                   	ret    

0080098d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	56                   	push   %esi
  800991:	53                   	push   %ebx
  800992:	83 ec 10             	sub    $0x10,%esp
  800995:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800998:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80099b:	e8 55 0b 00 00       	call   8014f5 <sys_getenvid>
  8009a0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8009a5:	c1 e0 07             	shl    $0x7,%eax
  8009a8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8009ad:	a3 20 50 80 00       	mov    %eax,0x805020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009b2:	85 db                	test   %ebx,%ebx
  8009b4:	7e 07                	jle    8009bd <libmain+0x30>
		binaryname = argv[0];
  8009b6:	8b 06                	mov    (%esi),%eax
  8009b8:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8009bd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009c1:	89 1c 24             	mov    %ebx,(%esp)
  8009c4:	e8 77 f6 ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  8009c9:	e8 07 00 00 00       	call   8009d5 <exit>
}
  8009ce:	83 c4 10             	add    $0x10,%esp
  8009d1:	5b                   	pop    %ebx
  8009d2:	5e                   	pop    %esi
  8009d3:	5d                   	pop    %ebp
  8009d4:	c3                   	ret    

008009d5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8009db:	e8 aa 15 00 00       	call   801f8a <close_all>
	sys_env_destroy(0);
  8009e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8009e7:	e8 b7 0a 00 00       	call   8014a3 <sys_env_destroy>
}
  8009ec:	c9                   	leave  
  8009ed:	c3                   	ret    

008009ee <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	56                   	push   %esi
  8009f2:	53                   	push   %ebx
  8009f3:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8009f6:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8009f9:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8009ff:	e8 f1 0a 00 00       	call   8014f5 <sys_getenvid>
  800a04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a07:	89 54 24 10          	mov    %edx,0x10(%esp)
  800a0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800a0e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a12:	89 74 24 08          	mov    %esi,0x8(%esp)
  800a16:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a1a:	c7 04 24 84 36 80 00 	movl   $0x803684,(%esp)
  800a21:	e8 c1 00 00 00       	call   800ae7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800a26:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2d:	89 04 24             	mov    %eax,(%esp)
  800a30:	e8 51 00 00 00       	call   800a86 <vcprintf>
	cprintf("\n");
  800a35:	c7 04 24 fb 34 80 00 	movl   $0x8034fb,(%esp)
  800a3c:	e8 a6 00 00 00       	call   800ae7 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800a41:	cc                   	int3   
  800a42:	eb fd                	jmp    800a41 <_panic+0x53>

00800a44 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	53                   	push   %ebx
  800a48:	83 ec 14             	sub    $0x14,%esp
  800a4b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800a4e:	8b 13                	mov    (%ebx),%edx
  800a50:	8d 42 01             	lea    0x1(%edx),%eax
  800a53:	89 03                	mov    %eax,(%ebx)
  800a55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a58:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800a5c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a61:	75 19                	jne    800a7c <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800a63:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800a6a:	00 
  800a6b:	8d 43 08             	lea    0x8(%ebx),%eax
  800a6e:	89 04 24             	mov    %eax,(%esp)
  800a71:	e8 f0 09 00 00       	call   801466 <sys_cputs>
		b->idx = 0;
  800a76:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800a7c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800a80:	83 c4 14             	add    $0x14,%esp
  800a83:	5b                   	pop    %ebx
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    

00800a86 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800a8f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a96:	00 00 00 
	b.cnt = 0;
  800a99:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800aa0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ab1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800abb:	c7 04 24 44 0a 80 00 	movl   $0x800a44,(%esp)
  800ac2:	e8 b7 01 00 00       	call   800c7e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800ac7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800acd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ad1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800ad7:	89 04 24             	mov    %eax,(%esp)
  800ada:	e8 87 09 00 00       	call   801466 <sys_cputs>

	return b.cnt;
}
  800adf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800ae5:	c9                   	leave  
  800ae6:	c3                   	ret    

00800ae7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800aed:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800af0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800af4:	8b 45 08             	mov    0x8(%ebp),%eax
  800af7:	89 04 24             	mov    %eax,(%esp)
  800afa:	e8 87 ff ff ff       	call   800a86 <vcprintf>
	va_end(ap);

	return cnt;
}
  800aff:	c9                   	leave  
  800b00:	c3                   	ret    
  800b01:	66 90                	xchg   %ax,%ax
  800b03:	66 90                	xchg   %ax,%ax
  800b05:	66 90                	xchg   %ax,%ax
  800b07:	66 90                	xchg   %ax,%ax
  800b09:	66 90                	xchg   %ax,%ax
  800b0b:	66 90                	xchg   %ax,%ax
  800b0d:	66 90                	xchg   %ax,%ax
  800b0f:	90                   	nop

00800b10 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	57                   	push   %edi
  800b14:	56                   	push   %esi
  800b15:	53                   	push   %ebx
  800b16:	83 ec 3c             	sub    $0x3c,%esp
  800b19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b1c:	89 d7                	mov    %edx,%edi
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b27:	89 c3                	mov    %eax,%ebx
  800b29:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800b2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b32:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b37:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b3a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b3d:	39 d9                	cmp    %ebx,%ecx
  800b3f:	72 05                	jb     800b46 <printnum+0x36>
  800b41:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800b44:	77 69                	ja     800baf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b46:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b49:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800b4d:	83 ee 01             	sub    $0x1,%esi
  800b50:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800b54:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b58:	8b 44 24 08          	mov    0x8(%esp),%eax
  800b5c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800b60:	89 c3                	mov    %eax,%ebx
  800b62:	89 d6                	mov    %edx,%esi
  800b64:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b67:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800b6a:	89 54 24 08          	mov    %edx,0x8(%esp)
  800b6e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800b72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b75:	89 04 24             	mov    %eax,(%esp)
  800b78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b7f:	e8 2c 26 00 00       	call   8031b0 <__udivdi3>
  800b84:	89 d9                	mov    %ebx,%ecx
  800b86:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800b8a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800b8e:	89 04 24             	mov    %eax,(%esp)
  800b91:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b95:	89 fa                	mov    %edi,%edx
  800b97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b9a:	e8 71 ff ff ff       	call   800b10 <printnum>
  800b9f:	eb 1b                	jmp    800bbc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ba1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ba5:	8b 45 18             	mov    0x18(%ebp),%eax
  800ba8:	89 04 24             	mov    %eax,(%esp)
  800bab:	ff d3                	call   *%ebx
  800bad:	eb 03                	jmp    800bb2 <printnum+0xa2>
  800baf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bb2:	83 ee 01             	sub    $0x1,%esi
  800bb5:	85 f6                	test   %esi,%esi
  800bb7:	7f e8                	jg     800ba1 <printnum+0x91>
  800bb9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bbc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bc0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800bc4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800bc7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800bca:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bce:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800bd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bd5:	89 04 24             	mov    %eax,(%esp)
  800bd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bdf:	e8 fc 26 00 00       	call   8032e0 <__umoddi3>
  800be4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800be8:	0f be 80 a7 36 80 00 	movsbl 0x8036a7(%eax),%eax
  800bef:	89 04 24             	mov    %eax,(%esp)
  800bf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bf5:	ff d0                	call   *%eax
}
  800bf7:	83 c4 3c             	add    $0x3c,%esp
  800bfa:	5b                   	pop    %ebx
  800bfb:	5e                   	pop    %esi
  800bfc:	5f                   	pop    %edi
  800bfd:	5d                   	pop    %ebp
  800bfe:	c3                   	ret    

00800bff <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c02:	83 fa 01             	cmp    $0x1,%edx
  800c05:	7e 0e                	jle    800c15 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800c07:	8b 10                	mov    (%eax),%edx
  800c09:	8d 4a 08             	lea    0x8(%edx),%ecx
  800c0c:	89 08                	mov    %ecx,(%eax)
  800c0e:	8b 02                	mov    (%edx),%eax
  800c10:	8b 52 04             	mov    0x4(%edx),%edx
  800c13:	eb 22                	jmp    800c37 <getuint+0x38>
	else if (lflag)
  800c15:	85 d2                	test   %edx,%edx
  800c17:	74 10                	je     800c29 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800c19:	8b 10                	mov    (%eax),%edx
  800c1b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800c1e:	89 08                	mov    %ecx,(%eax)
  800c20:	8b 02                	mov    (%edx),%eax
  800c22:	ba 00 00 00 00       	mov    $0x0,%edx
  800c27:	eb 0e                	jmp    800c37 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800c29:	8b 10                	mov    (%eax),%edx
  800c2b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800c2e:	89 08                	mov    %ecx,(%eax)
  800c30:	8b 02                	mov    (%edx),%eax
  800c32:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c37:	5d                   	pop    %ebp
  800c38:	c3                   	ret    

00800c39 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800c3f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800c43:	8b 10                	mov    (%eax),%edx
  800c45:	3b 50 04             	cmp    0x4(%eax),%edx
  800c48:	73 0a                	jae    800c54 <sprintputch+0x1b>
		*b->buf++ = ch;
  800c4a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c4d:	89 08                	mov    %ecx,(%eax)
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	88 02                	mov    %al,(%edx)
}
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    

00800c56 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c5c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c5f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c63:	8b 45 10             	mov    0x10(%ebp),%eax
  800c66:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	89 04 24             	mov    %eax,(%esp)
  800c77:	e8 02 00 00 00       	call   800c7e <vprintfmt>
	va_end(ap);
}
  800c7c:	c9                   	leave  
  800c7d:	c3                   	ret    

00800c7e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	57                   	push   %edi
  800c82:	56                   	push   %esi
  800c83:	53                   	push   %ebx
  800c84:	83 ec 3c             	sub    $0x3c,%esp
  800c87:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800c8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c8d:	eb 14                	jmp    800ca3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800c8f:	85 c0                	test   %eax,%eax
  800c91:	0f 84 b3 03 00 00    	je     80104a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800c97:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c9b:	89 04 24             	mov    %eax,(%esp)
  800c9e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ca1:	89 f3                	mov    %esi,%ebx
  800ca3:	8d 73 01             	lea    0x1(%ebx),%esi
  800ca6:	0f b6 03             	movzbl (%ebx),%eax
  800ca9:	83 f8 25             	cmp    $0x25,%eax
  800cac:	75 e1                	jne    800c8f <vprintfmt+0x11>
  800cae:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800cb2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800cb9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800cc0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800cc7:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccc:	eb 1d                	jmp    800ceb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cce:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800cd0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800cd4:	eb 15                	jmp    800ceb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cd6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800cd8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800cdc:	eb 0d                	jmp    800ceb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800cde:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ce1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800ce4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ceb:	8d 5e 01             	lea    0x1(%esi),%ebx
  800cee:	0f b6 0e             	movzbl (%esi),%ecx
  800cf1:	0f b6 c1             	movzbl %cl,%eax
  800cf4:	83 e9 23             	sub    $0x23,%ecx
  800cf7:	80 f9 55             	cmp    $0x55,%cl
  800cfa:	0f 87 2a 03 00 00    	ja     80102a <vprintfmt+0x3ac>
  800d00:	0f b6 c9             	movzbl %cl,%ecx
  800d03:	ff 24 8d e0 37 80 00 	jmp    *0x8037e0(,%ecx,4)
  800d0a:	89 de                	mov    %ebx,%esi
  800d0c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800d11:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800d14:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800d18:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800d1b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800d1e:	83 fb 09             	cmp    $0x9,%ebx
  800d21:	77 36                	ja     800d59 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d23:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d26:	eb e9                	jmp    800d11 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d28:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2b:	8d 48 04             	lea    0x4(%eax),%ecx
  800d2e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800d31:	8b 00                	mov    (%eax),%eax
  800d33:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d36:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800d38:	eb 22                	jmp    800d5c <vprintfmt+0xde>
  800d3a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800d3d:	85 c9                	test   %ecx,%ecx
  800d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800d44:	0f 49 c1             	cmovns %ecx,%eax
  800d47:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d4a:	89 de                	mov    %ebx,%esi
  800d4c:	eb 9d                	jmp    800ceb <vprintfmt+0x6d>
  800d4e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800d50:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800d57:	eb 92                	jmp    800ceb <vprintfmt+0x6d>
  800d59:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  800d5c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d60:	79 89                	jns    800ceb <vprintfmt+0x6d>
  800d62:	e9 77 ff ff ff       	jmp    800cde <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d67:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d6a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800d6c:	e9 7a ff ff ff       	jmp    800ceb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d71:	8b 45 14             	mov    0x14(%ebp),%eax
  800d74:	8d 50 04             	lea    0x4(%eax),%edx
  800d77:	89 55 14             	mov    %edx,0x14(%ebp)
  800d7a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d7e:	8b 00                	mov    (%eax),%eax
  800d80:	89 04 24             	mov    %eax,(%esp)
  800d83:	ff 55 08             	call   *0x8(%ebp)
			break;
  800d86:	e9 18 ff ff ff       	jmp    800ca3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d8b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8e:	8d 50 04             	lea    0x4(%eax),%edx
  800d91:	89 55 14             	mov    %edx,0x14(%ebp)
  800d94:	8b 00                	mov    (%eax),%eax
  800d96:	99                   	cltd   
  800d97:	31 d0                	xor    %edx,%eax
  800d99:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800d9b:	83 f8 11             	cmp    $0x11,%eax
  800d9e:	7f 0b                	jg     800dab <vprintfmt+0x12d>
  800da0:	8b 14 85 40 39 80 00 	mov    0x803940(,%eax,4),%edx
  800da7:	85 d2                	test   %edx,%edx
  800da9:	75 20                	jne    800dcb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  800dab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800daf:	c7 44 24 08 bf 36 80 	movl   $0x8036bf,0x8(%esp)
  800db6:	00 
  800db7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 04 24             	mov    %eax,(%esp)
  800dc1:	e8 90 fe ff ff       	call   800c56 <printfmt>
  800dc6:	e9 d8 fe ff ff       	jmp    800ca3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800dcb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800dcf:	c7 44 24 08 85 3b 80 	movl   $0x803b85,0x8(%esp)
  800dd6:	00 
  800dd7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	89 04 24             	mov    %eax,(%esp)
  800de1:	e8 70 fe ff ff       	call   800c56 <printfmt>
  800de6:	e9 b8 fe ff ff       	jmp    800ca3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800deb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800dee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800df1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800df4:	8b 45 14             	mov    0x14(%ebp),%eax
  800df7:	8d 50 04             	lea    0x4(%eax),%edx
  800dfa:	89 55 14             	mov    %edx,0x14(%ebp)
  800dfd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800dff:	85 f6                	test   %esi,%esi
  800e01:	b8 b8 36 80 00       	mov    $0x8036b8,%eax
  800e06:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800e09:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800e0d:	0f 84 97 00 00 00    	je     800eaa <vprintfmt+0x22c>
  800e13:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800e17:	0f 8e 9b 00 00 00    	jle    800eb8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e1d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800e21:	89 34 24             	mov    %esi,(%esp)
  800e24:	e8 cf 02 00 00       	call   8010f8 <strnlen>
  800e29:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800e2c:	29 c2                	sub    %eax,%edx
  800e2e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800e31:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800e35:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800e38:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800e3b:	8b 75 08             	mov    0x8(%ebp),%esi
  800e3e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800e41:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e43:	eb 0f                	jmp    800e54 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800e45:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800e4c:	89 04 24             	mov    %eax,(%esp)
  800e4f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e51:	83 eb 01             	sub    $0x1,%ebx
  800e54:	85 db                	test   %ebx,%ebx
  800e56:	7f ed                	jg     800e45 <vprintfmt+0x1c7>
  800e58:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800e5b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800e5e:	85 d2                	test   %edx,%edx
  800e60:	b8 00 00 00 00       	mov    $0x0,%eax
  800e65:	0f 49 c2             	cmovns %edx,%eax
  800e68:	29 c2                	sub    %eax,%edx
  800e6a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800e6d:	89 d7                	mov    %edx,%edi
  800e6f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800e72:	eb 50                	jmp    800ec4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800e74:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e78:	74 1e                	je     800e98 <vprintfmt+0x21a>
  800e7a:	0f be d2             	movsbl %dl,%edx
  800e7d:	83 ea 20             	sub    $0x20,%edx
  800e80:	83 fa 5e             	cmp    $0x5e,%edx
  800e83:	76 13                	jbe    800e98 <vprintfmt+0x21a>
					putch('?', putdat);
  800e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e88:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e8c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800e93:	ff 55 08             	call   *0x8(%ebp)
  800e96:	eb 0d                	jmp    800ea5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e9f:	89 04 24             	mov    %eax,(%esp)
  800ea2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ea5:	83 ef 01             	sub    $0x1,%edi
  800ea8:	eb 1a                	jmp    800ec4 <vprintfmt+0x246>
  800eaa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800ead:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800eb0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800eb3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800eb6:	eb 0c                	jmp    800ec4 <vprintfmt+0x246>
  800eb8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800ebb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800ebe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ec1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ec4:	83 c6 01             	add    $0x1,%esi
  800ec7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800ecb:	0f be c2             	movsbl %dl,%eax
  800ece:	85 c0                	test   %eax,%eax
  800ed0:	74 27                	je     800ef9 <vprintfmt+0x27b>
  800ed2:	85 db                	test   %ebx,%ebx
  800ed4:	78 9e                	js     800e74 <vprintfmt+0x1f6>
  800ed6:	83 eb 01             	sub    $0x1,%ebx
  800ed9:	79 99                	jns    800e74 <vprintfmt+0x1f6>
  800edb:	89 f8                	mov    %edi,%eax
  800edd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800ee0:	8b 75 08             	mov    0x8(%ebp),%esi
  800ee3:	89 c3                	mov    %eax,%ebx
  800ee5:	eb 1a                	jmp    800f01 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800ee7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800eeb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800ef2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ef4:	83 eb 01             	sub    $0x1,%ebx
  800ef7:	eb 08                	jmp    800f01 <vprintfmt+0x283>
  800ef9:	89 fb                	mov    %edi,%ebx
  800efb:	8b 75 08             	mov    0x8(%ebp),%esi
  800efe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f01:	85 db                	test   %ebx,%ebx
  800f03:	7f e2                	jg     800ee7 <vprintfmt+0x269>
  800f05:	89 75 08             	mov    %esi,0x8(%ebp)
  800f08:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f0b:	e9 93 fd ff ff       	jmp    800ca3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800f10:	83 fa 01             	cmp    $0x1,%edx
  800f13:	7e 16                	jle    800f2b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800f15:	8b 45 14             	mov    0x14(%ebp),%eax
  800f18:	8d 50 08             	lea    0x8(%eax),%edx
  800f1b:	89 55 14             	mov    %edx,0x14(%ebp)
  800f1e:	8b 50 04             	mov    0x4(%eax),%edx
  800f21:	8b 00                	mov    (%eax),%eax
  800f23:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f26:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800f29:	eb 32                	jmp    800f5d <vprintfmt+0x2df>
	else if (lflag)
  800f2b:	85 d2                	test   %edx,%edx
  800f2d:	74 18                	je     800f47 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800f2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f32:	8d 50 04             	lea    0x4(%eax),%edx
  800f35:	89 55 14             	mov    %edx,0x14(%ebp)
  800f38:	8b 30                	mov    (%eax),%esi
  800f3a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800f3d:	89 f0                	mov    %esi,%eax
  800f3f:	c1 f8 1f             	sar    $0x1f,%eax
  800f42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f45:	eb 16                	jmp    800f5d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800f47:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4a:	8d 50 04             	lea    0x4(%eax),%edx
  800f4d:	89 55 14             	mov    %edx,0x14(%ebp)
  800f50:	8b 30                	mov    (%eax),%esi
  800f52:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800f55:	89 f0                	mov    %esi,%eax
  800f57:	c1 f8 1f             	sar    $0x1f,%eax
  800f5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800f63:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800f68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f6c:	0f 89 80 00 00 00    	jns    800ff2 <vprintfmt+0x374>
				putch('-', putdat);
  800f72:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f76:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800f7d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800f80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f86:	f7 d8                	neg    %eax
  800f88:	83 d2 00             	adc    $0x0,%edx
  800f8b:	f7 da                	neg    %edx
			}
			base = 10;
  800f8d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f92:	eb 5e                	jmp    800ff2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f94:	8d 45 14             	lea    0x14(%ebp),%eax
  800f97:	e8 63 fc ff ff       	call   800bff <getuint>
			base = 10;
  800f9c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800fa1:	eb 4f                	jmp    800ff2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800fa3:	8d 45 14             	lea    0x14(%ebp),%eax
  800fa6:	e8 54 fc ff ff       	call   800bff <getuint>
			base = 8;
  800fab:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800fb0:	eb 40                	jmp    800ff2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800fb2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800fb6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800fbd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800fc0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800fc4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800fcb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800fce:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd1:	8d 50 04             	lea    0x4(%eax),%edx
  800fd4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fd7:	8b 00                	mov    (%eax),%eax
  800fd9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800fde:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800fe3:	eb 0d                	jmp    800ff2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800fe5:	8d 45 14             	lea    0x14(%ebp),%eax
  800fe8:	e8 12 fc ff ff       	call   800bff <getuint>
			base = 16;
  800fed:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ff2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800ff6:	89 74 24 10          	mov    %esi,0x10(%esp)
  800ffa:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800ffd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801001:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801005:	89 04 24             	mov    %eax,(%esp)
  801008:	89 54 24 04          	mov    %edx,0x4(%esp)
  80100c:	89 fa                	mov    %edi,%edx
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	e8 fa fa ff ff       	call   800b10 <printnum>
			break;
  801016:	e9 88 fc ff ff       	jmp    800ca3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80101b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80101f:	89 04 24             	mov    %eax,(%esp)
  801022:	ff 55 08             	call   *0x8(%ebp)
			break;
  801025:	e9 79 fc ff ff       	jmp    800ca3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80102a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80102e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801035:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801038:	89 f3                	mov    %esi,%ebx
  80103a:	eb 03                	jmp    80103f <vprintfmt+0x3c1>
  80103c:	83 eb 01             	sub    $0x1,%ebx
  80103f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801043:	75 f7                	jne    80103c <vprintfmt+0x3be>
  801045:	e9 59 fc ff ff       	jmp    800ca3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80104a:	83 c4 3c             	add    $0x3c,%esp
  80104d:	5b                   	pop    %ebx
  80104e:	5e                   	pop    %esi
  80104f:	5f                   	pop    %edi
  801050:	5d                   	pop    %ebp
  801051:	c3                   	ret    

00801052 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 28             	sub    $0x28,%esp
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80105e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801061:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801065:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801068:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80106f:	85 c0                	test   %eax,%eax
  801071:	74 30                	je     8010a3 <vsnprintf+0x51>
  801073:	85 d2                	test   %edx,%edx
  801075:	7e 2c                	jle    8010a3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801077:	8b 45 14             	mov    0x14(%ebp),%eax
  80107a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80107e:	8b 45 10             	mov    0x10(%ebp),%eax
  801081:	89 44 24 08          	mov    %eax,0x8(%esp)
  801085:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801088:	89 44 24 04          	mov    %eax,0x4(%esp)
  80108c:	c7 04 24 39 0c 80 00 	movl   $0x800c39,(%esp)
  801093:	e8 e6 fb ff ff       	call   800c7e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801098:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80109b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80109e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010a1:	eb 05                	jmp    8010a8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8010a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010b0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8010b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	89 04 24             	mov    %eax,(%esp)
  8010cb:	e8 82 ff ff ff       	call   801052 <vsnprintf>
	va_end(ap);

	return rc;
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    
  8010d2:	66 90                	xchg   %ax,%ax
  8010d4:	66 90                	xchg   %ax,%ax
  8010d6:	66 90                	xchg   %ax,%ax
  8010d8:	66 90                	xchg   %ax,%ax
  8010da:	66 90                	xchg   %ax,%ax
  8010dc:	66 90                	xchg   %ax,%ax
  8010de:	66 90                	xchg   %ax,%ax

008010e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8010e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010eb:	eb 03                	jmp    8010f0 <strlen+0x10>
		n++;
  8010ed:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010f0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8010f4:	75 f7                	jne    8010ed <strlen+0xd>
		n++;
	return n;
}
  8010f6:	5d                   	pop    %ebp
  8010f7:	c3                   	ret    

008010f8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010fe:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801101:	b8 00 00 00 00       	mov    $0x0,%eax
  801106:	eb 03                	jmp    80110b <strnlen+0x13>
		n++;
  801108:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80110b:	39 d0                	cmp    %edx,%eax
  80110d:	74 06                	je     801115 <strnlen+0x1d>
  80110f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801113:	75 f3                	jne    801108 <strnlen+0x10>
		n++;
	return n;
}
  801115:	5d                   	pop    %ebp
  801116:	c3                   	ret    

00801117 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	53                   	push   %ebx
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801121:	89 c2                	mov    %eax,%edx
  801123:	83 c2 01             	add    $0x1,%edx
  801126:	83 c1 01             	add    $0x1,%ecx
  801129:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80112d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801130:	84 db                	test   %bl,%bl
  801132:	75 ef                	jne    801123 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801134:	5b                   	pop    %ebx
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    

00801137 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	53                   	push   %ebx
  80113b:	83 ec 08             	sub    $0x8,%esp
  80113e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801141:	89 1c 24             	mov    %ebx,(%esp)
  801144:	e8 97 ff ff ff       	call   8010e0 <strlen>
	strcpy(dst + len, src);
  801149:	8b 55 0c             	mov    0xc(%ebp),%edx
  80114c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801150:	01 d8                	add    %ebx,%eax
  801152:	89 04 24             	mov    %eax,(%esp)
  801155:	e8 bd ff ff ff       	call   801117 <strcpy>
	return dst;
}
  80115a:	89 d8                	mov    %ebx,%eax
  80115c:	83 c4 08             	add    $0x8,%esp
  80115f:	5b                   	pop    %ebx
  801160:	5d                   	pop    %ebp
  801161:	c3                   	ret    

00801162 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	56                   	push   %esi
  801166:	53                   	push   %ebx
  801167:	8b 75 08             	mov    0x8(%ebp),%esi
  80116a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116d:	89 f3                	mov    %esi,%ebx
  80116f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801172:	89 f2                	mov    %esi,%edx
  801174:	eb 0f                	jmp    801185 <strncpy+0x23>
		*dst++ = *src;
  801176:	83 c2 01             	add    $0x1,%edx
  801179:	0f b6 01             	movzbl (%ecx),%eax
  80117c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80117f:	80 39 01             	cmpb   $0x1,(%ecx)
  801182:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801185:	39 da                	cmp    %ebx,%edx
  801187:	75 ed                	jne    801176 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801189:	89 f0                	mov    %esi,%eax
  80118b:	5b                   	pop    %ebx
  80118c:	5e                   	pop    %esi
  80118d:	5d                   	pop    %ebp
  80118e:	c3                   	ret    

0080118f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	56                   	push   %esi
  801193:	53                   	push   %ebx
  801194:	8b 75 08             	mov    0x8(%ebp),%esi
  801197:	8b 55 0c             	mov    0xc(%ebp),%edx
  80119a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80119d:	89 f0                	mov    %esi,%eax
  80119f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8011a3:	85 c9                	test   %ecx,%ecx
  8011a5:	75 0b                	jne    8011b2 <strlcpy+0x23>
  8011a7:	eb 1d                	jmp    8011c6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8011a9:	83 c0 01             	add    $0x1,%eax
  8011ac:	83 c2 01             	add    $0x1,%edx
  8011af:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011b2:	39 d8                	cmp    %ebx,%eax
  8011b4:	74 0b                	je     8011c1 <strlcpy+0x32>
  8011b6:	0f b6 0a             	movzbl (%edx),%ecx
  8011b9:	84 c9                	test   %cl,%cl
  8011bb:	75 ec                	jne    8011a9 <strlcpy+0x1a>
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	eb 02                	jmp    8011c3 <strlcpy+0x34>
  8011c1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8011c3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8011c6:	29 f0                	sub    %esi,%eax
}
  8011c8:	5b                   	pop    %ebx
  8011c9:	5e                   	pop    %esi
  8011ca:	5d                   	pop    %ebp
  8011cb:	c3                   	ret    

008011cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011cc:	55                   	push   %ebp
  8011cd:	89 e5                	mov    %esp,%ebp
  8011cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011d2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8011d5:	eb 06                	jmp    8011dd <strcmp+0x11>
		p++, q++;
  8011d7:	83 c1 01             	add    $0x1,%ecx
  8011da:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011dd:	0f b6 01             	movzbl (%ecx),%eax
  8011e0:	84 c0                	test   %al,%al
  8011e2:	74 04                	je     8011e8 <strcmp+0x1c>
  8011e4:	3a 02                	cmp    (%edx),%al
  8011e6:	74 ef                	je     8011d7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011e8:	0f b6 c0             	movzbl %al,%eax
  8011eb:	0f b6 12             	movzbl (%edx),%edx
  8011ee:	29 d0                	sub    %edx,%eax
}
  8011f0:	5d                   	pop    %ebp
  8011f1:	c3                   	ret    

008011f2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8011f2:	55                   	push   %ebp
  8011f3:	89 e5                	mov    %esp,%ebp
  8011f5:	53                   	push   %ebx
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011fc:	89 c3                	mov    %eax,%ebx
  8011fe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801201:	eb 06                	jmp    801209 <strncmp+0x17>
		n--, p++, q++;
  801203:	83 c0 01             	add    $0x1,%eax
  801206:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801209:	39 d8                	cmp    %ebx,%eax
  80120b:	74 15                	je     801222 <strncmp+0x30>
  80120d:	0f b6 08             	movzbl (%eax),%ecx
  801210:	84 c9                	test   %cl,%cl
  801212:	74 04                	je     801218 <strncmp+0x26>
  801214:	3a 0a                	cmp    (%edx),%cl
  801216:	74 eb                	je     801203 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801218:	0f b6 00             	movzbl (%eax),%eax
  80121b:	0f b6 12             	movzbl (%edx),%edx
  80121e:	29 d0                	sub    %edx,%eax
  801220:	eb 05                	jmp    801227 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801222:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801227:	5b                   	pop    %ebx
  801228:	5d                   	pop    %ebp
  801229:	c3                   	ret    

0080122a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801234:	eb 07                	jmp    80123d <strchr+0x13>
		if (*s == c)
  801236:	38 ca                	cmp    %cl,%dl
  801238:	74 0f                	je     801249 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80123a:	83 c0 01             	add    $0x1,%eax
  80123d:	0f b6 10             	movzbl (%eax),%edx
  801240:	84 d2                	test   %dl,%dl
  801242:	75 f2                	jne    801236 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801244:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801249:	5d                   	pop    %ebp
  80124a:	c3                   	ret    

0080124b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801255:	eb 07                	jmp    80125e <strfind+0x13>
		if (*s == c)
  801257:	38 ca                	cmp    %cl,%dl
  801259:	74 0a                	je     801265 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80125b:	83 c0 01             	add    $0x1,%eax
  80125e:	0f b6 10             	movzbl (%eax),%edx
  801261:	84 d2                	test   %dl,%dl
  801263:	75 f2                	jne    801257 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  801265:	5d                   	pop    %ebp
  801266:	c3                   	ret    

00801267 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	57                   	push   %edi
  80126b:	56                   	push   %esi
  80126c:	53                   	push   %ebx
  80126d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801270:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801273:	85 c9                	test   %ecx,%ecx
  801275:	74 36                	je     8012ad <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801277:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80127d:	75 28                	jne    8012a7 <memset+0x40>
  80127f:	f6 c1 03             	test   $0x3,%cl
  801282:	75 23                	jne    8012a7 <memset+0x40>
		c &= 0xFF;
  801284:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801288:	89 d3                	mov    %edx,%ebx
  80128a:	c1 e3 08             	shl    $0x8,%ebx
  80128d:	89 d6                	mov    %edx,%esi
  80128f:	c1 e6 18             	shl    $0x18,%esi
  801292:	89 d0                	mov    %edx,%eax
  801294:	c1 e0 10             	shl    $0x10,%eax
  801297:	09 f0                	or     %esi,%eax
  801299:	09 c2                	or     %eax,%edx
  80129b:	89 d0                	mov    %edx,%eax
  80129d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80129f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8012a2:	fc                   	cld    
  8012a3:	f3 ab                	rep stos %eax,%es:(%edi)
  8012a5:	eb 06                	jmp    8012ad <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8012a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012aa:	fc                   	cld    
  8012ab:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8012ad:	89 f8                	mov    %edi,%eax
  8012af:	5b                   	pop    %ebx
  8012b0:	5e                   	pop    %esi
  8012b1:	5f                   	pop    %edi
  8012b2:	5d                   	pop    %ebp
  8012b3:	c3                   	ret    

008012b4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	57                   	push   %edi
  8012b8:	56                   	push   %esi
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012c2:	39 c6                	cmp    %eax,%esi
  8012c4:	73 35                	jae    8012fb <memmove+0x47>
  8012c6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8012c9:	39 d0                	cmp    %edx,%eax
  8012cb:	73 2e                	jae    8012fb <memmove+0x47>
		s += n;
		d += n;
  8012cd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8012d0:	89 d6                	mov    %edx,%esi
  8012d2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8012d4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8012da:	75 13                	jne    8012ef <memmove+0x3b>
  8012dc:	f6 c1 03             	test   $0x3,%cl
  8012df:	75 0e                	jne    8012ef <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8012e1:	83 ef 04             	sub    $0x4,%edi
  8012e4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8012e7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8012ea:	fd                   	std    
  8012eb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8012ed:	eb 09                	jmp    8012f8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8012ef:	83 ef 01             	sub    $0x1,%edi
  8012f2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8012f5:	fd                   	std    
  8012f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8012f8:	fc                   	cld    
  8012f9:	eb 1d                	jmp    801318 <memmove+0x64>
  8012fb:	89 f2                	mov    %esi,%edx
  8012fd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8012ff:	f6 c2 03             	test   $0x3,%dl
  801302:	75 0f                	jne    801313 <memmove+0x5f>
  801304:	f6 c1 03             	test   $0x3,%cl
  801307:	75 0a                	jne    801313 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801309:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80130c:	89 c7                	mov    %eax,%edi
  80130e:	fc                   	cld    
  80130f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801311:	eb 05                	jmp    801318 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801313:	89 c7                	mov    %eax,%edi
  801315:	fc                   	cld    
  801316:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801318:	5e                   	pop    %esi
  801319:	5f                   	pop    %edi
  80131a:	5d                   	pop    %ebp
  80131b:	c3                   	ret    

0080131c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801322:	8b 45 10             	mov    0x10(%ebp),%eax
  801325:	89 44 24 08          	mov    %eax,0x8(%esp)
  801329:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	89 04 24             	mov    %eax,(%esp)
  801336:	e8 79 ff ff ff       	call   8012b4 <memmove>
}
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	56                   	push   %esi
  801341:	53                   	push   %ebx
  801342:	8b 55 08             	mov    0x8(%ebp),%edx
  801345:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801348:	89 d6                	mov    %edx,%esi
  80134a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80134d:	eb 1a                	jmp    801369 <memcmp+0x2c>
		if (*s1 != *s2)
  80134f:	0f b6 02             	movzbl (%edx),%eax
  801352:	0f b6 19             	movzbl (%ecx),%ebx
  801355:	38 d8                	cmp    %bl,%al
  801357:	74 0a                	je     801363 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  801359:	0f b6 c0             	movzbl %al,%eax
  80135c:	0f b6 db             	movzbl %bl,%ebx
  80135f:	29 d8                	sub    %ebx,%eax
  801361:	eb 0f                	jmp    801372 <memcmp+0x35>
		s1++, s2++;
  801363:	83 c2 01             	add    $0x1,%edx
  801366:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801369:	39 f2                	cmp    %esi,%edx
  80136b:	75 e2                	jne    80134f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80136d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801372:	5b                   	pop    %ebx
  801373:	5e                   	pop    %esi
  801374:	5d                   	pop    %ebp
  801375:	c3                   	ret    

00801376 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80137f:	89 c2                	mov    %eax,%edx
  801381:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801384:	eb 07                	jmp    80138d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  801386:	38 08                	cmp    %cl,(%eax)
  801388:	74 07                	je     801391 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80138a:	83 c0 01             	add    $0x1,%eax
  80138d:	39 d0                	cmp    %edx,%eax
  80138f:	72 f5                	jb     801386 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801391:	5d                   	pop    %ebp
  801392:	c3                   	ret    

00801393 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	57                   	push   %edi
  801397:	56                   	push   %esi
  801398:	53                   	push   %ebx
  801399:	8b 55 08             	mov    0x8(%ebp),%edx
  80139c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80139f:	eb 03                	jmp    8013a4 <strtol+0x11>
		s++;
  8013a1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013a4:	0f b6 0a             	movzbl (%edx),%ecx
  8013a7:	80 f9 09             	cmp    $0x9,%cl
  8013aa:	74 f5                	je     8013a1 <strtol+0xe>
  8013ac:	80 f9 20             	cmp    $0x20,%cl
  8013af:	74 f0                	je     8013a1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013b1:	80 f9 2b             	cmp    $0x2b,%cl
  8013b4:	75 0a                	jne    8013c0 <strtol+0x2d>
		s++;
  8013b6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8013b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8013be:	eb 11                	jmp    8013d1 <strtol+0x3e>
  8013c0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8013c5:	80 f9 2d             	cmp    $0x2d,%cl
  8013c8:	75 07                	jne    8013d1 <strtol+0x3e>
		s++, neg = 1;
  8013ca:	8d 52 01             	lea    0x1(%edx),%edx
  8013cd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013d1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  8013d6:	75 15                	jne    8013ed <strtol+0x5a>
  8013d8:	80 3a 30             	cmpb   $0x30,(%edx)
  8013db:	75 10                	jne    8013ed <strtol+0x5a>
  8013dd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8013e1:	75 0a                	jne    8013ed <strtol+0x5a>
		s += 2, base = 16;
  8013e3:	83 c2 02             	add    $0x2,%edx
  8013e6:	b8 10 00 00 00       	mov    $0x10,%eax
  8013eb:	eb 10                	jmp    8013fd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	75 0c                	jne    8013fd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8013f1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8013f3:	80 3a 30             	cmpb   $0x30,(%edx)
  8013f6:	75 05                	jne    8013fd <strtol+0x6a>
		s++, base = 8;
  8013f8:	83 c2 01             	add    $0x1,%edx
  8013fb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8013fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801402:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801405:	0f b6 0a             	movzbl (%edx),%ecx
  801408:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80140b:	89 f0                	mov    %esi,%eax
  80140d:	3c 09                	cmp    $0x9,%al
  80140f:	77 08                	ja     801419 <strtol+0x86>
			dig = *s - '0';
  801411:	0f be c9             	movsbl %cl,%ecx
  801414:	83 e9 30             	sub    $0x30,%ecx
  801417:	eb 20                	jmp    801439 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  801419:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80141c:	89 f0                	mov    %esi,%eax
  80141e:	3c 19                	cmp    $0x19,%al
  801420:	77 08                	ja     80142a <strtol+0x97>
			dig = *s - 'a' + 10;
  801422:	0f be c9             	movsbl %cl,%ecx
  801425:	83 e9 57             	sub    $0x57,%ecx
  801428:	eb 0f                	jmp    801439 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80142a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80142d:	89 f0                	mov    %esi,%eax
  80142f:	3c 19                	cmp    $0x19,%al
  801431:	77 16                	ja     801449 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801433:	0f be c9             	movsbl %cl,%ecx
  801436:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801439:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80143c:	7d 0f                	jge    80144d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80143e:	83 c2 01             	add    $0x1,%edx
  801441:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801445:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801447:	eb bc                	jmp    801405 <strtol+0x72>
  801449:	89 d8                	mov    %ebx,%eax
  80144b:	eb 02                	jmp    80144f <strtol+0xbc>
  80144d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80144f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801453:	74 05                	je     80145a <strtol+0xc7>
		*endptr = (char *) s;
  801455:	8b 75 0c             	mov    0xc(%ebp),%esi
  801458:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80145a:	f7 d8                	neg    %eax
  80145c:	85 ff                	test   %edi,%edi
  80145e:	0f 44 c3             	cmove  %ebx,%eax
}
  801461:	5b                   	pop    %ebx
  801462:	5e                   	pop    %esi
  801463:	5f                   	pop    %edi
  801464:	5d                   	pop    %ebp
  801465:	c3                   	ret    

00801466 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	57                   	push   %edi
  80146a:	56                   	push   %esi
  80146b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80146c:	b8 00 00 00 00       	mov    $0x0,%eax
  801471:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801474:	8b 55 08             	mov    0x8(%ebp),%edx
  801477:	89 c3                	mov    %eax,%ebx
  801479:	89 c7                	mov    %eax,%edi
  80147b:	89 c6                	mov    %eax,%esi
  80147d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80147f:	5b                   	pop    %ebx
  801480:	5e                   	pop    %esi
  801481:	5f                   	pop    %edi
  801482:	5d                   	pop    %ebp
  801483:	c3                   	ret    

00801484 <sys_cgetc>:

int
sys_cgetc(void)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	57                   	push   %edi
  801488:	56                   	push   %esi
  801489:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80148a:	ba 00 00 00 00       	mov    $0x0,%edx
  80148f:	b8 01 00 00 00       	mov    $0x1,%eax
  801494:	89 d1                	mov    %edx,%ecx
  801496:	89 d3                	mov    %edx,%ebx
  801498:	89 d7                	mov    %edx,%edi
  80149a:	89 d6                	mov    %edx,%esi
  80149c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80149e:	5b                   	pop    %ebx
  80149f:	5e                   	pop    %esi
  8014a0:	5f                   	pop    %edi
  8014a1:	5d                   	pop    %ebp
  8014a2:	c3                   	ret    

008014a3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	57                   	push   %edi
  8014a7:	56                   	push   %esi
  8014a8:	53                   	push   %ebx
  8014a9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014b1:	b8 03 00 00 00       	mov    $0x3,%eax
  8014b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b9:	89 cb                	mov    %ecx,%ebx
  8014bb:	89 cf                	mov    %ecx,%edi
  8014bd:	89 ce                	mov    %ecx,%esi
  8014bf:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	7e 28                	jle    8014ed <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014c5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014c9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8014d0:	00 
  8014d1:	c7 44 24 08 a7 39 80 	movl   $0x8039a7,0x8(%esp)
  8014d8:	00 
  8014d9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014e0:	00 
  8014e1:	c7 04 24 c4 39 80 00 	movl   $0x8039c4,(%esp)
  8014e8:	e8 01 f5 ff ff       	call   8009ee <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8014ed:	83 c4 2c             	add    $0x2c,%esp
  8014f0:	5b                   	pop    %ebx
  8014f1:	5e                   	pop    %esi
  8014f2:	5f                   	pop    %edi
  8014f3:	5d                   	pop    %ebp
  8014f4:	c3                   	ret    

008014f5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
  8014f8:	57                   	push   %edi
  8014f9:	56                   	push   %esi
  8014fa:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801500:	b8 02 00 00 00       	mov    $0x2,%eax
  801505:	89 d1                	mov    %edx,%ecx
  801507:	89 d3                	mov    %edx,%ebx
  801509:	89 d7                	mov    %edx,%edi
  80150b:	89 d6                	mov    %edx,%esi
  80150d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80150f:	5b                   	pop    %ebx
  801510:	5e                   	pop    %esi
  801511:	5f                   	pop    %edi
  801512:	5d                   	pop    %ebp
  801513:	c3                   	ret    

00801514 <sys_yield>:

void
sys_yield(void)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	57                   	push   %edi
  801518:	56                   	push   %esi
  801519:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80151a:	ba 00 00 00 00       	mov    $0x0,%edx
  80151f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801524:	89 d1                	mov    %edx,%ecx
  801526:	89 d3                	mov    %edx,%ebx
  801528:	89 d7                	mov    %edx,%edi
  80152a:	89 d6                	mov    %edx,%esi
  80152c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80152e:	5b                   	pop    %ebx
  80152f:	5e                   	pop    %esi
  801530:	5f                   	pop    %edi
  801531:	5d                   	pop    %ebp
  801532:	c3                   	ret    

00801533 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
  801536:	57                   	push   %edi
  801537:	56                   	push   %esi
  801538:	53                   	push   %ebx
  801539:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80153c:	be 00 00 00 00       	mov    $0x0,%esi
  801541:	b8 04 00 00 00       	mov    $0x4,%eax
  801546:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801549:	8b 55 08             	mov    0x8(%ebp),%edx
  80154c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80154f:	89 f7                	mov    %esi,%edi
  801551:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801553:	85 c0                	test   %eax,%eax
  801555:	7e 28                	jle    80157f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801557:	89 44 24 10          	mov    %eax,0x10(%esp)
  80155b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801562:	00 
  801563:	c7 44 24 08 a7 39 80 	movl   $0x8039a7,0x8(%esp)
  80156a:	00 
  80156b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801572:	00 
  801573:	c7 04 24 c4 39 80 00 	movl   $0x8039c4,(%esp)
  80157a:	e8 6f f4 ff ff       	call   8009ee <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80157f:	83 c4 2c             	add    $0x2c,%esp
  801582:	5b                   	pop    %ebx
  801583:	5e                   	pop    %esi
  801584:	5f                   	pop    %edi
  801585:	5d                   	pop    %ebp
  801586:	c3                   	ret    

00801587 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	57                   	push   %edi
  80158b:	56                   	push   %esi
  80158c:	53                   	push   %ebx
  80158d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801590:	b8 05 00 00 00       	mov    $0x5,%eax
  801595:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801598:	8b 55 08             	mov    0x8(%ebp),%edx
  80159b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80159e:	8b 7d 14             	mov    0x14(%ebp),%edi
  8015a1:	8b 75 18             	mov    0x18(%ebp),%esi
  8015a4:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8015a6:	85 c0                	test   %eax,%eax
  8015a8:	7e 28                	jle    8015d2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015aa:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015ae:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8015b5:	00 
  8015b6:	c7 44 24 08 a7 39 80 	movl   $0x8039a7,0x8(%esp)
  8015bd:	00 
  8015be:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8015c5:	00 
  8015c6:	c7 04 24 c4 39 80 00 	movl   $0x8039c4,(%esp)
  8015cd:	e8 1c f4 ff ff       	call   8009ee <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8015d2:	83 c4 2c             	add    $0x2c,%esp
  8015d5:	5b                   	pop    %ebx
  8015d6:	5e                   	pop    %esi
  8015d7:	5f                   	pop    %edi
  8015d8:	5d                   	pop    %ebp
  8015d9:	c3                   	ret    

008015da <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	57                   	push   %edi
  8015de:	56                   	push   %esi
  8015df:	53                   	push   %ebx
  8015e0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015e8:	b8 06 00 00 00       	mov    $0x6,%eax
  8015ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015f3:	89 df                	mov    %ebx,%edi
  8015f5:	89 de                	mov    %ebx,%esi
  8015f7:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8015f9:	85 c0                	test   %eax,%eax
  8015fb:	7e 28                	jle    801625 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015fd:	89 44 24 10          	mov    %eax,0x10(%esp)
  801601:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801608:	00 
  801609:	c7 44 24 08 a7 39 80 	movl   $0x8039a7,0x8(%esp)
  801610:	00 
  801611:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801618:	00 
  801619:	c7 04 24 c4 39 80 00 	movl   $0x8039c4,(%esp)
  801620:	e8 c9 f3 ff ff       	call   8009ee <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801625:	83 c4 2c             	add    $0x2c,%esp
  801628:	5b                   	pop    %ebx
  801629:	5e                   	pop    %esi
  80162a:	5f                   	pop    %edi
  80162b:	5d                   	pop    %ebp
  80162c:	c3                   	ret    

0080162d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	57                   	push   %edi
  801631:	56                   	push   %esi
  801632:	53                   	push   %ebx
  801633:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801636:	bb 00 00 00 00       	mov    $0x0,%ebx
  80163b:	b8 08 00 00 00       	mov    $0x8,%eax
  801640:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801643:	8b 55 08             	mov    0x8(%ebp),%edx
  801646:	89 df                	mov    %ebx,%edi
  801648:	89 de                	mov    %ebx,%esi
  80164a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80164c:	85 c0                	test   %eax,%eax
  80164e:	7e 28                	jle    801678 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801650:	89 44 24 10          	mov    %eax,0x10(%esp)
  801654:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80165b:	00 
  80165c:	c7 44 24 08 a7 39 80 	movl   $0x8039a7,0x8(%esp)
  801663:	00 
  801664:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80166b:	00 
  80166c:	c7 04 24 c4 39 80 00 	movl   $0x8039c4,(%esp)
  801673:	e8 76 f3 ff ff       	call   8009ee <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801678:	83 c4 2c             	add    $0x2c,%esp
  80167b:	5b                   	pop    %ebx
  80167c:	5e                   	pop    %esi
  80167d:	5f                   	pop    %edi
  80167e:	5d                   	pop    %ebp
  80167f:	c3                   	ret    

00801680 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	57                   	push   %edi
  801684:	56                   	push   %esi
  801685:	53                   	push   %ebx
  801686:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801689:	bb 00 00 00 00       	mov    $0x0,%ebx
  80168e:	b8 09 00 00 00       	mov    $0x9,%eax
  801693:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801696:	8b 55 08             	mov    0x8(%ebp),%edx
  801699:	89 df                	mov    %ebx,%edi
  80169b:	89 de                	mov    %ebx,%esi
  80169d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80169f:	85 c0                	test   %eax,%eax
  8016a1:	7e 28                	jle    8016cb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016a3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016a7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8016ae:	00 
  8016af:	c7 44 24 08 a7 39 80 	movl   $0x8039a7,0x8(%esp)
  8016b6:	00 
  8016b7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8016be:	00 
  8016bf:	c7 04 24 c4 39 80 00 	movl   $0x8039c4,(%esp)
  8016c6:	e8 23 f3 ff ff       	call   8009ee <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8016cb:	83 c4 2c             	add    $0x2c,%esp
  8016ce:	5b                   	pop    %ebx
  8016cf:	5e                   	pop    %esi
  8016d0:	5f                   	pop    %edi
  8016d1:	5d                   	pop    %ebp
  8016d2:	c3                   	ret    

008016d3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	57                   	push   %edi
  8016d7:	56                   	push   %esi
  8016d8:	53                   	push   %ebx
  8016d9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8016e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ec:	89 df                	mov    %ebx,%edi
  8016ee:	89 de                	mov    %ebx,%esi
  8016f0:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8016f2:	85 c0                	test   %eax,%eax
  8016f4:	7e 28                	jle    80171e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016f6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016fa:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801701:	00 
  801702:	c7 44 24 08 a7 39 80 	movl   $0x8039a7,0x8(%esp)
  801709:	00 
  80170a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801711:	00 
  801712:	c7 04 24 c4 39 80 00 	movl   $0x8039c4,(%esp)
  801719:	e8 d0 f2 ff ff       	call   8009ee <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80171e:	83 c4 2c             	add    $0x2c,%esp
  801721:	5b                   	pop    %ebx
  801722:	5e                   	pop    %esi
  801723:	5f                   	pop    %edi
  801724:	5d                   	pop    %ebp
  801725:	c3                   	ret    

00801726 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	57                   	push   %edi
  80172a:	56                   	push   %esi
  80172b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80172c:	be 00 00 00 00       	mov    $0x0,%esi
  801731:	b8 0c 00 00 00       	mov    $0xc,%eax
  801736:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801739:	8b 55 08             	mov    0x8(%ebp),%edx
  80173c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80173f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801742:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801744:	5b                   	pop    %ebx
  801745:	5e                   	pop    %esi
  801746:	5f                   	pop    %edi
  801747:	5d                   	pop    %ebp
  801748:	c3                   	ret    

00801749 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	57                   	push   %edi
  80174d:	56                   	push   %esi
  80174e:	53                   	push   %ebx
  80174f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801752:	b9 00 00 00 00       	mov    $0x0,%ecx
  801757:	b8 0d 00 00 00       	mov    $0xd,%eax
  80175c:	8b 55 08             	mov    0x8(%ebp),%edx
  80175f:	89 cb                	mov    %ecx,%ebx
  801761:	89 cf                	mov    %ecx,%edi
  801763:	89 ce                	mov    %ecx,%esi
  801765:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801767:	85 c0                	test   %eax,%eax
  801769:	7e 28                	jle    801793 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80176b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80176f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801776:	00 
  801777:	c7 44 24 08 a7 39 80 	movl   $0x8039a7,0x8(%esp)
  80177e:	00 
  80177f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801786:	00 
  801787:	c7 04 24 c4 39 80 00 	movl   $0x8039c4,(%esp)
  80178e:	e8 5b f2 ff ff       	call   8009ee <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801793:	83 c4 2c             	add    $0x2c,%esp
  801796:	5b                   	pop    %ebx
  801797:	5e                   	pop    %esi
  801798:	5f                   	pop    %edi
  801799:	5d                   	pop    %ebp
  80179a:	c3                   	ret    

0080179b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	57                   	push   %edi
  80179f:	56                   	push   %esi
  8017a0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8017ab:	89 d1                	mov    %edx,%ecx
  8017ad:	89 d3                	mov    %edx,%ebx
  8017af:	89 d7                	mov    %edx,%edi
  8017b1:	89 d6                	mov    %edx,%esi
  8017b3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8017b5:	5b                   	pop    %ebx
  8017b6:	5e                   	pop    %esi
  8017b7:	5f                   	pop    %edi
  8017b8:	5d                   	pop    %ebp
  8017b9:	c3                   	ret    

008017ba <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	57                   	push   %edi
  8017be:	56                   	push   %esi
  8017bf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017c5:	b8 0f 00 00 00       	mov    $0xf,%eax
  8017ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d0:	89 df                	mov    %ebx,%edi
  8017d2:	89 de                	mov    %ebx,%esi
  8017d4:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  8017d6:	5b                   	pop    %ebx
  8017d7:	5e                   	pop    %esi
  8017d8:	5f                   	pop    %edi
  8017d9:	5d                   	pop    %ebp
  8017da:	c3                   	ret    

008017db <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	57                   	push   %edi
  8017df:	56                   	push   %esi
  8017e0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017e6:	b8 10 00 00 00       	mov    $0x10,%eax
  8017eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f1:	89 df                	mov    %ebx,%edi
  8017f3:	89 de                	mov    %ebx,%esi
  8017f5:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  8017f7:	5b                   	pop    %ebx
  8017f8:	5e                   	pop    %esi
  8017f9:	5f                   	pop    %edi
  8017fa:	5d                   	pop    %ebp
  8017fb:	c3                   	ret    

008017fc <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	57                   	push   %edi
  801800:	56                   	push   %esi
  801801:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801802:	b9 00 00 00 00       	mov    $0x0,%ecx
  801807:	b8 11 00 00 00       	mov    $0x11,%eax
  80180c:	8b 55 08             	mov    0x8(%ebp),%edx
  80180f:	89 cb                	mov    %ecx,%ebx
  801811:	89 cf                	mov    %ecx,%edi
  801813:	89 ce                	mov    %ecx,%esi
  801815:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  801817:	5b                   	pop    %ebx
  801818:	5e                   	pop    %esi
  801819:	5f                   	pop    %edi
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	57                   	push   %edi
  801820:	56                   	push   %esi
  801821:	53                   	push   %ebx
  801822:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801825:	be 00 00 00 00       	mov    $0x0,%esi
  80182a:	b8 12 00 00 00       	mov    $0x12,%eax
  80182f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801832:	8b 55 08             	mov    0x8(%ebp),%edx
  801835:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801838:	8b 7d 14             	mov    0x14(%ebp),%edi
  80183b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80183d:	85 c0                	test   %eax,%eax
  80183f:	7e 28                	jle    801869 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  801841:	89 44 24 10          	mov    %eax,0x10(%esp)
  801845:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  80184c:	00 
  80184d:	c7 44 24 08 a7 39 80 	movl   $0x8039a7,0x8(%esp)
  801854:	00 
  801855:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80185c:	00 
  80185d:	c7 04 24 c4 39 80 00 	movl   $0x8039c4,(%esp)
  801864:	e8 85 f1 ff ff       	call   8009ee <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  801869:	83 c4 2c             	add    $0x2c,%esp
  80186c:	5b                   	pop    %ebx
  80186d:	5e                   	pop    %esi
  80186e:	5f                   	pop    %edi
  80186f:	5d                   	pop    %ebp
  801870:	c3                   	ret    

00801871 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
  801874:	53                   	push   %ebx
  801875:	83 ec 24             	sub    $0x24,%esp
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80187b:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0)
  80187d:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801881:	75 20                	jne    8018a3 <pgfault+0x32>
		panic("pgfault: faulting address [%08x] not a write\n", addr);
  801883:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801887:	c7 44 24 08 d4 39 80 	movl   $0x8039d4,0x8(%esp)
  80188e:	00 
  80188f:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  801896:	00 
  801897:	c7 04 24 54 3a 80 00 	movl   $0x803a54,(%esp)
  80189e:	e8 4b f1 ff ff       	call   8009ee <_panic>

	void *page_aligned_addr = (void *) ROUNDDOWN(addr, PGSIZE);
  8018a3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t page_num = (uint32_t) page_aligned_addr / PGSIZE;
  8018a9:	89 d8                	mov    %ebx,%eax
  8018ab:	c1 e8 0c             	shr    $0xc,%eax
	if (!(uvpt[page_num] & PTE_COW))
  8018ae:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018b5:	f6 c4 08             	test   $0x8,%ah
  8018b8:	75 1c                	jne    8018d6 <pgfault+0x65>
		panic("pgfault: fault was not on a copy-on-write page\n");
  8018ba:	c7 44 24 08 04 3a 80 	movl   $0x803a04,0x8(%esp)
  8018c1:	00 
  8018c2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8018c9:	00 
  8018ca:	c7 04 24 54 3a 80 00 	movl   $0x803a54,(%esp)
  8018d1:	e8 18 f1 ff ff       	call   8009ee <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	// Allocate
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8018d6:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8018dd:	00 
  8018de:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8018e5:	00 
  8018e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018ed:	e8 41 fc ff ff       	call   801533 <sys_page_alloc>
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	79 20                	jns    801916 <pgfault+0xa5>
		panic("sys_page_alloc: %e\n", r);
  8018f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018fa:	c7 44 24 08 5f 3a 80 	movl   $0x803a5f,0x8(%esp)
  801901:	00 
  801902:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  801909:	00 
  80190a:	c7 04 24 54 3a 80 00 	movl   $0x803a54,(%esp)
  801911:	e8 d8 f0 ff ff       	call   8009ee <_panic>

	// Copy over
	void *src_addr = (void *) ROUNDDOWN(addr, PGSIZE);
	memmove(PFTEMP, src_addr, PGSIZE);
  801916:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80191d:	00 
  80191e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801922:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801929:	e8 86 f9 ff ff       	call   8012b4 <memmove>

	// Remap
	if ((r = sys_page_map(0, PFTEMP, 0, src_addr, PTE_P | PTE_U | PTE_W)) < 0)
  80192e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801935:	00 
  801936:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80193a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801941:	00 
  801942:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801949:	00 
  80194a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801951:	e8 31 fc ff ff       	call   801587 <sys_page_map>
  801956:	85 c0                	test   %eax,%eax
  801958:	79 20                	jns    80197a <pgfault+0x109>
		panic("sys_page_map: %e\n", r);
  80195a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80195e:	c7 44 24 08 73 3a 80 	movl   $0x803a73,0x8(%esp)
  801965:	00 
  801966:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  80196d:	00 
  80196e:	c7 04 24 54 3a 80 00 	movl   $0x803a54,(%esp)
  801975:	e8 74 f0 ff ff       	call   8009ee <_panic>

	//panic("pgfault not implemented");
}
  80197a:	83 c4 24             	add    $0x24,%esp
  80197d:	5b                   	pop    %ebx
  80197e:	5d                   	pop    %ebp
  80197f:	c3                   	ret    

00801980 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	57                   	push   %edi
  801984:	56                   	push   %esi
  801985:	53                   	push   %ebx
  801986:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.
	int r;
	envid_t child_envid;

	set_pgfault_handler(pgfault);
  801989:	c7 04 24 71 18 80 00 	movl   $0x801871,(%esp)
  801990:	e8 31 17 00 00       	call   8030c6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801995:	b8 07 00 00 00       	mov    $0x7,%eax
  80199a:	cd 30                	int    $0x30
  80199c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80199f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	child_envid = sys_exofork();
	if (child_envid < 0)
  8019a2:	85 c0                	test   %eax,%eax
  8019a4:	79 20                	jns    8019c6 <fork+0x46>
		panic("sys_exofork: %e\n", child_envid);
  8019a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019aa:	c7 44 24 08 85 3a 80 	movl   $0x803a85,0x8(%esp)
  8019b1:	00 
  8019b2:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  8019b9:	00 
  8019ba:	c7 04 24 54 3a 80 00 	movl   $0x803a54,(%esp)
  8019c1:	e8 28 f0 ff ff       	call   8009ee <_panic>
	if (child_envid == 0) { // child
  8019c6:	bf 00 00 00 00       	mov    $0x0,%edi
  8019cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8019d4:	75 21                	jne    8019f7 <fork+0x77>
		// Fix thisenv like dumbfork does and return 0
		thisenv = &envs[ENVX(sys_getenvid())];
  8019d6:	e8 1a fb ff ff       	call   8014f5 <sys_getenvid>
  8019db:	25 ff 03 00 00       	and    $0x3ff,%eax
  8019e0:	c1 e0 07             	shl    $0x7,%eax
  8019e3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8019e8:	a3 20 50 80 00       	mov    %eax,0x805020
		return 0;
  8019ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f2:	e9 53 02 00 00       	jmp    801c4a <fork+0x2ca>
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
  8019f7:	89 d8                	mov    %ebx,%eax
  8019f9:	c1 e8 0a             	shr    $0xa,%eax
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  8019fc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a03:	a8 01                	test   $0x1,%al
  801a05:	0f 84 7a 01 00 00    	je     801b85 <fork+0x205>
			((uvpt[page_num] & PTE_P) == PTE_P)) {
  801a0b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  801a12:	a8 01                	test   $0x1,%al
  801a14:	0f 84 6b 01 00 00    	je     801b85 <fork+0x205>
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
	envid_t this_envid = thisenv->env_id;
  801a1a:	a1 20 50 80 00       	mov    0x805020,%eax
  801a1f:	8b 40 48             	mov    0x48(%eax),%eax
  801a22:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// LAB 4: Your code here.
	if (uvpt[pn] & PTE_SHARE) {
  801a25:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801a2c:	f6 c4 04             	test   $0x4,%ah
  801a2f:	74 52                	je     801a83 <fork+0x103>
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801a31:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801a38:	25 07 0e 00 00       	and    $0xe07,%eax
  801a3d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a41:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a48:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a4c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a53:	89 04 24             	mov    %eax,(%esp)
  801a56:	e8 2c fb ff ff       	call   801587 <sys_page_map>
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	0f 89 22 01 00 00    	jns    801b85 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801a63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a67:	c7 44 24 08 73 3a 80 	movl   $0x803a73,0x8(%esp)
  801a6e:	00 
  801a6f:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  801a76:	00 
  801a77:	c7 04 24 54 3a 80 00 	movl   $0x803a54,(%esp)
  801a7e:	e8 6b ef ff ff       	call   8009ee <_panic>
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
  801a83:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801a8a:	f6 c4 08             	test   $0x8,%ah
  801a8d:	75 0f                	jne    801a9e <fork+0x11e>
  801a8f:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801a96:	a8 02                	test   $0x2,%al
  801a98:	0f 84 99 00 00 00    	je     801b37 <fork+0x1b7>
		if (uvpt[pn] & PTE_U)
  801a9e:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801aa5:	83 e0 04             	and    $0x4,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
  801aa8:	83 f8 01             	cmp    $0x1,%eax
  801aab:	19 f6                	sbb    %esi,%esi
  801aad:	83 e6 fc             	and    $0xfffffffc,%esi
  801ab0:	81 c6 05 08 00 00    	add    $0x805,%esi
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
		if (uvpt[pn] & PTE_U)
			perm |= PTE_U;

		// Map page COW, U and P in child
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), perm)) < 0)
  801ab6:	89 74 24 10          	mov    %esi,0x10(%esp)
  801aba:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801abe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ac1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ac5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ac9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801acc:	89 04 24             	mov    %eax,(%esp)
  801acf:	e8 b3 fa ff ff       	call   801587 <sys_page_map>
  801ad4:	85 c0                	test   %eax,%eax
  801ad6:	79 20                	jns    801af8 <fork+0x178>
			panic("sys_page_map: %e\n", r);
  801ad8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801adc:	c7 44 24 08 73 3a 80 	movl   $0x803a73,0x8(%esp)
  801ae3:	00 
  801ae4:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  801aeb:	00 
  801aec:	c7 04 24 54 3a 80 00 	movl   $0x803a54,(%esp)
  801af3:	e8 f6 ee ff ff       	call   8009ee <_panic>

		// Map page COW, U and P in parent
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), this_envid, (void *) (pn*PGSIZE), perm)) < 0)
  801af8:	89 74 24 10          	mov    %esi,0x10(%esp)
  801afc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b03:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b07:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b0b:	89 04 24             	mov    %eax,(%esp)
  801b0e:	e8 74 fa ff ff       	call   801587 <sys_page_map>
  801b13:	85 c0                	test   %eax,%eax
  801b15:	79 6e                	jns    801b85 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801b17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b1b:	c7 44 24 08 73 3a 80 	movl   $0x803a73,0x8(%esp)
  801b22:	00 
  801b23:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  801b2a:	00 
  801b2b:	c7 04 24 54 3a 80 00 	movl   $0x803a54,(%esp)
  801b32:	e8 b7 ee ff ff       	call   8009ee <_panic>

	} else { // map pages that are present but not writable or COW with their original permissions
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801b37:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801b3e:	25 07 0e 00 00       	and    $0xe07,%eax
  801b43:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b47:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b52:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b59:	89 04 24             	mov    %eax,(%esp)
  801b5c:	e8 26 fa ff ff       	call   801587 <sys_page_map>
  801b61:	85 c0                	test   %eax,%eax
  801b63:	79 20                	jns    801b85 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801b65:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b69:	c7 44 24 08 73 3a 80 	movl   $0x803a73,0x8(%esp)
  801b70:	00 
  801b71:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
  801b78:	00 
  801b79:	c7 04 24 54 3a 80 00 	movl   $0x803a54,(%esp)
  801b80:	e8 69 ee ff ff       	call   8009ee <_panic>
	// and let duppage worry about the permissions.
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
  801b85:	83 c3 01             	add    $0x1,%ebx
  801b88:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801b8e:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  801b94:	0f 85 5d fe ff ff    	jne    8019f7 <fork+0x77>
	}

	// Allocate exception stack space for child. The child can't do this themselves
	// because the mechanism by which it would is to run the pgfault handler, which
	// needs to run on the exception stack (catch 22).
	if ((r = sys_page_alloc(child_envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801b9a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801ba1:	00 
  801ba2:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801ba9:	ee 
  801baa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bad:	89 04 24             	mov    %eax,(%esp)
  801bb0:	e8 7e f9 ff ff       	call   801533 <sys_page_alloc>
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	79 20                	jns    801bd9 <fork+0x259>
		panic("sys_page_alloc: %e\n", r);
  801bb9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bbd:	c7 44 24 08 5f 3a 80 	movl   $0x803a5f,0x8(%esp)
  801bc4:	00 
  801bc5:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  801bcc:	00 
  801bcd:	c7 04 24 54 3a 80 00 	movl   $0x803a54,(%esp)
  801bd4:	e8 15 ee ff ff       	call   8009ee <_panic>

	// Set page fault handler for the child
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801bd9:	c7 44 24 04 47 31 80 	movl   $0x803147,0x4(%esp)
  801be0:	00 
  801be1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801be4:	89 04 24             	mov    %eax,(%esp)
  801be7:	e8 e7 fa ff ff       	call   8016d3 <sys_env_set_pgfault_upcall>
  801bec:	85 c0                	test   %eax,%eax
  801bee:	79 20                	jns    801c10 <fork+0x290>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801bf0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bf4:	c7 44 24 08 34 3a 80 	movl   $0x803a34,0x8(%esp)
  801bfb:	00 
  801bfc:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801c03:	00 
  801c04:	c7 04 24 54 3a 80 00 	movl   $0x803a54,(%esp)
  801c0b:	e8 de ed ff ff       	call   8009ee <_panic>

	// Mark child environment as runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  801c10:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801c17:	00 
  801c18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c1b:	89 04 24             	mov    %eax,(%esp)
  801c1e:	e8 0a fa ff ff       	call   80162d <sys_env_set_status>
  801c23:	85 c0                	test   %eax,%eax
  801c25:	79 20                	jns    801c47 <fork+0x2c7>
		panic("sys_env_set_status: %e\n", r);
  801c27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c2b:	c7 44 24 08 96 3a 80 	movl   $0x803a96,0x8(%esp)
  801c32:	00 
  801c33:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  801c3a:	00 
  801c3b:	c7 04 24 54 3a 80 00 	movl   $0x803a54,(%esp)
  801c42:	e8 a7 ed ff ff       	call   8009ee <_panic>

	return child_envid;
  801c47:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  801c4a:	83 c4 2c             	add    $0x2c,%esp
  801c4d:	5b                   	pop    %ebx
  801c4e:	5e                   	pop    %esi
  801c4f:	5f                   	pop    %edi
  801c50:	5d                   	pop    %ebp
  801c51:	c3                   	ret    

00801c52 <sfork>:

// Challenge!
int
sfork(void)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
  801c55:	83 ec 18             	sub    $0x18,%esp
//	return __fork(1);
	panic("sfork not implemented");
  801c58:	c7 44 24 08 ae 3a 80 	movl   $0x803aae,0x8(%esp)
  801c5f:	00 
  801c60:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  801c67:	00 
  801c68:	c7 04 24 54 3a 80 00 	movl   $0x803a54,(%esp)
  801c6f:	e8 7a ed ff ff       	call   8009ee <_panic>
  801c74:	66 90                	xchg   %ax,%ax
  801c76:	66 90                	xchg   %ax,%ax
  801c78:	66 90                	xchg   %ax,%ax
  801c7a:	66 90                	xchg   %ax,%ax
  801c7c:	66 90                	xchg   %ax,%ax
  801c7e:	66 90                	xchg   %ax,%ax

00801c80 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	56                   	push   %esi
  801c84:	53                   	push   %ebx
  801c85:	83 ec 10             	sub    $0x10,%esp
  801c88:	8b 75 08             	mov    0x8(%ebp),%esi
  801c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  801c91:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  801c93:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  801c98:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  801c9b:	89 04 24             	mov    %eax,(%esp)
  801c9e:	e8 a6 fa ff ff       	call   801749 <sys_ipc_recv>
  801ca3:	85 c0                	test   %eax,%eax
  801ca5:	74 16                	je     801cbd <ipc_recv+0x3d>
		if (from_env_store != NULL)
  801ca7:	85 f6                	test   %esi,%esi
  801ca9:	74 06                	je     801cb1 <ipc_recv+0x31>
			*from_env_store = 0;
  801cab:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  801cb1:	85 db                	test   %ebx,%ebx
  801cb3:	74 2c                	je     801ce1 <ipc_recv+0x61>
			*perm_store = 0;
  801cb5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801cbb:	eb 24                	jmp    801ce1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  801cbd:	85 f6                	test   %esi,%esi
  801cbf:	74 0a                	je     801ccb <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  801cc1:	a1 20 50 80 00       	mov    0x805020,%eax
  801cc6:	8b 40 74             	mov    0x74(%eax),%eax
  801cc9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  801ccb:	85 db                	test   %ebx,%ebx
  801ccd:	74 0a                	je     801cd9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  801ccf:	a1 20 50 80 00       	mov    0x805020,%eax
  801cd4:	8b 40 78             	mov    0x78(%eax),%eax
  801cd7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  801cd9:	a1 20 50 80 00       	mov    0x805020,%eax
  801cde:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ce1:	83 c4 10             	add    $0x10,%esp
  801ce4:	5b                   	pop    %ebx
  801ce5:	5e                   	pop    %esi
  801ce6:	5d                   	pop    %ebp
  801ce7:	c3                   	ret    

00801ce8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	57                   	push   %edi
  801cec:	56                   	push   %esi
  801ced:	53                   	push   %ebx
  801cee:	83 ec 1c             	sub    $0x1c,%esp
  801cf1:	8b 75 0c             	mov    0xc(%ebp),%esi
  801cf4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801cf7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  801cfa:	85 db                	test   %ebx,%ebx
  801cfc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  801d01:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  801d04:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d08:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d0c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	89 04 24             	mov    %eax,(%esp)
  801d16:	e8 0b fa ff ff       	call   801726 <sys_ipc_try_send>
	if (r == 0) return;
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	75 22                	jne    801d41 <ipc_send+0x59>
  801d1f:	eb 4c                	jmp    801d6d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  801d21:	84 d2                	test   %dl,%dl
  801d23:	75 48                	jne    801d6d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  801d25:	e8 ea f7 ff ff       	call   801514 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  801d2a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d2e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d32:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d36:	8b 45 08             	mov    0x8(%ebp),%eax
  801d39:	89 04 24             	mov    %eax,(%esp)
  801d3c:	e8 e5 f9 ff ff       	call   801726 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  801d41:	85 c0                	test   %eax,%eax
  801d43:	0f 94 c2             	sete   %dl
  801d46:	74 d9                	je     801d21 <ipc_send+0x39>
  801d48:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d4b:	74 d4                	je     801d21 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  801d4d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d51:	c7 44 24 08 c4 3a 80 	movl   $0x803ac4,0x8(%esp)
  801d58:	00 
  801d59:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  801d60:	00 
  801d61:	c7 04 24 d2 3a 80 00 	movl   $0x803ad2,(%esp)
  801d68:	e8 81 ec ff ff       	call   8009ee <_panic>
}
  801d6d:	83 c4 1c             	add    $0x1c,%esp
  801d70:	5b                   	pop    %ebx
  801d71:	5e                   	pop    %esi
  801d72:	5f                   	pop    %edi
  801d73:	5d                   	pop    %ebp
  801d74:	c3                   	ret    

00801d75 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801d7b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801d80:	89 c2                	mov    %eax,%edx
  801d82:	c1 e2 07             	shl    $0x7,%edx
  801d85:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801d8b:	8b 52 50             	mov    0x50(%edx),%edx
  801d8e:	39 ca                	cmp    %ecx,%edx
  801d90:	75 0d                	jne    801d9f <ipc_find_env+0x2a>
			return envs[i].env_id;
  801d92:	c1 e0 07             	shl    $0x7,%eax
  801d95:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801d9a:	8b 40 40             	mov    0x40(%eax),%eax
  801d9d:	eb 0e                	jmp    801dad <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801d9f:	83 c0 01             	add    $0x1,%eax
  801da2:	3d 00 04 00 00       	cmp    $0x400,%eax
  801da7:	75 d7                	jne    801d80 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801da9:	66 b8 00 00          	mov    $0x0,%ax
}
  801dad:	5d                   	pop    %ebp
  801dae:	c3                   	ret    
  801daf:	90                   	nop

00801db0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801db3:	8b 45 08             	mov    0x8(%ebp),%eax
  801db6:	05 00 00 00 30       	add    $0x30000000,%eax
  801dbb:	c1 e8 0c             	shr    $0xc,%eax
}
  801dbe:	5d                   	pop    %ebp
  801dbf:	c3                   	ret    

00801dc0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  801dcb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801dd0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801dd5:	5d                   	pop    %ebp
  801dd6:	c3                   	ret    

00801dd7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
  801dda:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ddd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801de2:	89 c2                	mov    %eax,%edx
  801de4:	c1 ea 16             	shr    $0x16,%edx
  801de7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801dee:	f6 c2 01             	test   $0x1,%dl
  801df1:	74 11                	je     801e04 <fd_alloc+0x2d>
  801df3:	89 c2                	mov    %eax,%edx
  801df5:	c1 ea 0c             	shr    $0xc,%edx
  801df8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801dff:	f6 c2 01             	test   $0x1,%dl
  801e02:	75 09                	jne    801e0d <fd_alloc+0x36>
			*fd_store = fd;
  801e04:	89 01                	mov    %eax,(%ecx)
			return 0;
  801e06:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0b:	eb 17                	jmp    801e24 <fd_alloc+0x4d>
  801e0d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e12:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801e17:	75 c9                	jne    801de2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e19:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801e1f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801e24:	5d                   	pop    %ebp
  801e25:	c3                   	ret    

00801e26 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e2c:	83 f8 1f             	cmp    $0x1f,%eax
  801e2f:	77 36                	ja     801e67 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801e31:	c1 e0 0c             	shl    $0xc,%eax
  801e34:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e39:	89 c2                	mov    %eax,%edx
  801e3b:	c1 ea 16             	shr    $0x16,%edx
  801e3e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801e45:	f6 c2 01             	test   $0x1,%dl
  801e48:	74 24                	je     801e6e <fd_lookup+0x48>
  801e4a:	89 c2                	mov    %eax,%edx
  801e4c:	c1 ea 0c             	shr    $0xc,%edx
  801e4f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801e56:	f6 c2 01             	test   $0x1,%dl
  801e59:	74 1a                	je     801e75 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5e:	89 02                	mov    %eax,(%edx)
	return 0;
  801e60:	b8 00 00 00 00       	mov    $0x0,%eax
  801e65:	eb 13                	jmp    801e7a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e67:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e6c:	eb 0c                	jmp    801e7a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e73:	eb 05                	jmp    801e7a <fd_lookup+0x54>
  801e75:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801e7a:	5d                   	pop    %ebp
  801e7b:	c3                   	ret    

00801e7c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	83 ec 18             	sub    $0x18,%esp
  801e82:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801e85:	ba 00 00 00 00       	mov    $0x0,%edx
  801e8a:	eb 13                	jmp    801e9f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  801e8c:	39 08                	cmp    %ecx,(%eax)
  801e8e:	75 0c                	jne    801e9c <dev_lookup+0x20>
			*dev = devtab[i];
  801e90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e93:	89 01                	mov    %eax,(%ecx)
			return 0;
  801e95:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9a:	eb 38                	jmp    801ed4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801e9c:	83 c2 01             	add    $0x1,%edx
  801e9f:	8b 04 95 58 3b 80 00 	mov    0x803b58(,%edx,4),%eax
  801ea6:	85 c0                	test   %eax,%eax
  801ea8:	75 e2                	jne    801e8c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801eaa:	a1 20 50 80 00       	mov    0x805020,%eax
  801eaf:	8b 40 48             	mov    0x48(%eax),%eax
  801eb2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801eb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eba:	c7 04 24 dc 3a 80 00 	movl   $0x803adc,(%esp)
  801ec1:	e8 21 ec ff ff       	call   800ae7 <cprintf>
	*dev = 0;
  801ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801ecf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	56                   	push   %esi
  801eda:	53                   	push   %ebx
  801edb:	83 ec 20             	sub    $0x20,%esp
  801ede:	8b 75 08             	mov    0x8(%ebp),%esi
  801ee1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ee4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ee7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801eeb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801ef1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ef4:	89 04 24             	mov    %eax,(%esp)
  801ef7:	e8 2a ff ff ff       	call   801e26 <fd_lookup>
  801efc:	85 c0                	test   %eax,%eax
  801efe:	78 05                	js     801f05 <fd_close+0x2f>
	    || fd != fd2)
  801f00:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801f03:	74 0c                	je     801f11 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801f05:	84 db                	test   %bl,%bl
  801f07:	ba 00 00 00 00       	mov    $0x0,%edx
  801f0c:	0f 44 c2             	cmove  %edx,%eax
  801f0f:	eb 3f                	jmp    801f50 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f11:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f18:	8b 06                	mov    (%esi),%eax
  801f1a:	89 04 24             	mov    %eax,(%esp)
  801f1d:	e8 5a ff ff ff       	call   801e7c <dev_lookup>
  801f22:	89 c3                	mov    %eax,%ebx
  801f24:	85 c0                	test   %eax,%eax
  801f26:	78 16                	js     801f3e <fd_close+0x68>
		if (dev->dev_close)
  801f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801f2e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801f33:	85 c0                	test   %eax,%eax
  801f35:	74 07                	je     801f3e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801f37:	89 34 24             	mov    %esi,(%esp)
  801f3a:	ff d0                	call   *%eax
  801f3c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f3e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f42:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f49:	e8 8c f6 ff ff       	call   8015da <sys_page_unmap>
	return r;
  801f4e:	89 d8                	mov    %ebx,%eax
}
  801f50:	83 c4 20             	add    $0x20,%esp
  801f53:	5b                   	pop    %ebx
  801f54:	5e                   	pop    %esi
  801f55:	5d                   	pop    %ebp
  801f56:	c3                   	ret    

00801f57 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
  801f5a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f5d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f60:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	89 04 24             	mov    %eax,(%esp)
  801f6a:	e8 b7 fe ff ff       	call   801e26 <fd_lookup>
  801f6f:	89 c2                	mov    %eax,%edx
  801f71:	85 d2                	test   %edx,%edx
  801f73:	78 13                	js     801f88 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801f75:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801f7c:	00 
  801f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f80:	89 04 24             	mov    %eax,(%esp)
  801f83:	e8 4e ff ff ff       	call   801ed6 <fd_close>
}
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <close_all>:

void
close_all(void)
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
  801f8d:	53                   	push   %ebx
  801f8e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801f91:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801f96:	89 1c 24             	mov    %ebx,(%esp)
  801f99:	e8 b9 ff ff ff       	call   801f57 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801f9e:	83 c3 01             	add    $0x1,%ebx
  801fa1:	83 fb 20             	cmp    $0x20,%ebx
  801fa4:	75 f0                	jne    801f96 <close_all+0xc>
		close(i);
}
  801fa6:	83 c4 14             	add    $0x14,%esp
  801fa9:	5b                   	pop    %ebx
  801faa:	5d                   	pop    %ebp
  801fab:	c3                   	ret    

00801fac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	57                   	push   %edi
  801fb0:	56                   	push   %esi
  801fb1:	53                   	push   %ebx
  801fb2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801fb5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801fb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	89 04 24             	mov    %eax,(%esp)
  801fc2:	e8 5f fe ff ff       	call   801e26 <fd_lookup>
  801fc7:	89 c2                	mov    %eax,%edx
  801fc9:	85 d2                	test   %edx,%edx
  801fcb:	0f 88 e1 00 00 00    	js     8020b2 <dup+0x106>
		return r;
	close(newfdnum);
  801fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd4:	89 04 24             	mov    %eax,(%esp)
  801fd7:	e8 7b ff ff ff       	call   801f57 <close>

	newfd = INDEX2FD(newfdnum);
  801fdc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801fdf:	c1 e3 0c             	shl    $0xc,%ebx
  801fe2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801fe8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801feb:	89 04 24             	mov    %eax,(%esp)
  801fee:	e8 cd fd ff ff       	call   801dc0 <fd2data>
  801ff3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801ff5:	89 1c 24             	mov    %ebx,(%esp)
  801ff8:	e8 c3 fd ff ff       	call   801dc0 <fd2data>
  801ffd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801fff:	89 f0                	mov    %esi,%eax
  802001:	c1 e8 16             	shr    $0x16,%eax
  802004:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80200b:	a8 01                	test   $0x1,%al
  80200d:	74 43                	je     802052 <dup+0xa6>
  80200f:	89 f0                	mov    %esi,%eax
  802011:	c1 e8 0c             	shr    $0xc,%eax
  802014:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80201b:	f6 c2 01             	test   $0x1,%dl
  80201e:	74 32                	je     802052 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  802020:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802027:	25 07 0e 00 00       	and    $0xe07,%eax
  80202c:	89 44 24 10          	mov    %eax,0x10(%esp)
  802030:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802034:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80203b:	00 
  80203c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802040:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802047:	e8 3b f5 ff ff       	call   801587 <sys_page_map>
  80204c:	89 c6                	mov    %eax,%esi
  80204e:	85 c0                	test   %eax,%eax
  802050:	78 3e                	js     802090 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  802052:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802055:	89 c2                	mov    %eax,%edx
  802057:	c1 ea 0c             	shr    $0xc,%edx
  80205a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802061:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  802067:	89 54 24 10          	mov    %edx,0x10(%esp)
  80206b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80206f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802076:	00 
  802077:	89 44 24 04          	mov    %eax,0x4(%esp)
  80207b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802082:	e8 00 f5 ff ff       	call   801587 <sys_page_map>
  802087:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  802089:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80208c:	85 f6                	test   %esi,%esi
  80208e:	79 22                	jns    8020b2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802090:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802094:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80209b:	e8 3a f5 ff ff       	call   8015da <sys_page_unmap>
	sys_page_unmap(0, nva);
  8020a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8020a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020ab:	e8 2a f5 ff ff       	call   8015da <sys_page_unmap>
	return r;
  8020b0:	89 f0                	mov    %esi,%eax
}
  8020b2:	83 c4 3c             	add    $0x3c,%esp
  8020b5:	5b                   	pop    %ebx
  8020b6:	5e                   	pop    %esi
  8020b7:	5f                   	pop    %edi
  8020b8:	5d                   	pop    %ebp
  8020b9:	c3                   	ret    

008020ba <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	53                   	push   %ebx
  8020be:	83 ec 24             	sub    $0x24,%esp
  8020c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020cb:	89 1c 24             	mov    %ebx,(%esp)
  8020ce:	e8 53 fd ff ff       	call   801e26 <fd_lookup>
  8020d3:	89 c2                	mov    %eax,%edx
  8020d5:	85 d2                	test   %edx,%edx
  8020d7:	78 6d                	js     802146 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e3:	8b 00                	mov    (%eax),%eax
  8020e5:	89 04 24             	mov    %eax,(%esp)
  8020e8:	e8 8f fd ff ff       	call   801e7c <dev_lookup>
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	78 55                	js     802146 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8020f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f4:	8b 50 08             	mov    0x8(%eax),%edx
  8020f7:	83 e2 03             	and    $0x3,%edx
  8020fa:	83 fa 01             	cmp    $0x1,%edx
  8020fd:	75 23                	jne    802122 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8020ff:	a1 20 50 80 00       	mov    0x805020,%eax
  802104:	8b 40 48             	mov    0x48(%eax),%eax
  802107:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80210b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80210f:	c7 04 24 1d 3b 80 00 	movl   $0x803b1d,(%esp)
  802116:	e8 cc e9 ff ff       	call   800ae7 <cprintf>
		return -E_INVAL;
  80211b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802120:	eb 24                	jmp    802146 <read+0x8c>
	}
	if (!dev->dev_read)
  802122:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802125:	8b 52 08             	mov    0x8(%edx),%edx
  802128:	85 d2                	test   %edx,%edx
  80212a:	74 15                	je     802141 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80212c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80212f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802133:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802136:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80213a:	89 04 24             	mov    %eax,(%esp)
  80213d:	ff d2                	call   *%edx
  80213f:	eb 05                	jmp    802146 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  802141:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  802146:	83 c4 24             	add    $0x24,%esp
  802149:	5b                   	pop    %ebx
  80214a:	5d                   	pop    %ebp
  80214b:	c3                   	ret    

0080214c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
  80214f:	57                   	push   %edi
  802150:	56                   	push   %esi
  802151:	53                   	push   %ebx
  802152:	83 ec 1c             	sub    $0x1c,%esp
  802155:	8b 7d 08             	mov    0x8(%ebp),%edi
  802158:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80215b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802160:	eb 23                	jmp    802185 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802162:	89 f0                	mov    %esi,%eax
  802164:	29 d8                	sub    %ebx,%eax
  802166:	89 44 24 08          	mov    %eax,0x8(%esp)
  80216a:	89 d8                	mov    %ebx,%eax
  80216c:	03 45 0c             	add    0xc(%ebp),%eax
  80216f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802173:	89 3c 24             	mov    %edi,(%esp)
  802176:	e8 3f ff ff ff       	call   8020ba <read>
		if (m < 0)
  80217b:	85 c0                	test   %eax,%eax
  80217d:	78 10                	js     80218f <readn+0x43>
			return m;
		if (m == 0)
  80217f:	85 c0                	test   %eax,%eax
  802181:	74 0a                	je     80218d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802183:	01 c3                	add    %eax,%ebx
  802185:	39 f3                	cmp    %esi,%ebx
  802187:	72 d9                	jb     802162 <readn+0x16>
  802189:	89 d8                	mov    %ebx,%eax
  80218b:	eb 02                	jmp    80218f <readn+0x43>
  80218d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80218f:	83 c4 1c             	add    $0x1c,%esp
  802192:	5b                   	pop    %ebx
  802193:	5e                   	pop    %esi
  802194:	5f                   	pop    %edi
  802195:	5d                   	pop    %ebp
  802196:	c3                   	ret    

00802197 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
  80219a:	53                   	push   %ebx
  80219b:	83 ec 24             	sub    $0x24,%esp
  80219e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a8:	89 1c 24             	mov    %ebx,(%esp)
  8021ab:	e8 76 fc ff ff       	call   801e26 <fd_lookup>
  8021b0:	89 c2                	mov    %eax,%edx
  8021b2:	85 d2                	test   %edx,%edx
  8021b4:	78 68                	js     80221e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c0:	8b 00                	mov    (%eax),%eax
  8021c2:	89 04 24             	mov    %eax,(%esp)
  8021c5:	e8 b2 fc ff ff       	call   801e7c <dev_lookup>
  8021ca:	85 c0                	test   %eax,%eax
  8021cc:	78 50                	js     80221e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8021d5:	75 23                	jne    8021fa <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8021d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8021dc:	8b 40 48             	mov    0x48(%eax),%eax
  8021df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e7:	c7 04 24 39 3b 80 00 	movl   $0x803b39,(%esp)
  8021ee:	e8 f4 e8 ff ff       	call   800ae7 <cprintf>
		return -E_INVAL;
  8021f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021f8:	eb 24                	jmp    80221e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8021fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021fd:	8b 52 0c             	mov    0xc(%edx),%edx
  802200:	85 d2                	test   %edx,%edx
  802202:	74 15                	je     802219 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802204:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802207:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80220b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80220e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802212:	89 04 24             	mov    %eax,(%esp)
  802215:	ff d2                	call   *%edx
  802217:	eb 05                	jmp    80221e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  802219:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80221e:	83 c4 24             	add    $0x24,%esp
  802221:	5b                   	pop    %ebx
  802222:	5d                   	pop    %ebp
  802223:	c3                   	ret    

00802224 <seek>:

int
seek(int fdnum, off_t offset)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
  802227:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80222a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80222d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802231:	8b 45 08             	mov    0x8(%ebp),%eax
  802234:	89 04 24             	mov    %eax,(%esp)
  802237:	e8 ea fb ff ff       	call   801e26 <fd_lookup>
  80223c:	85 c0                	test   %eax,%eax
  80223e:	78 0e                	js     80224e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  802240:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802243:	8b 55 0c             	mov    0xc(%ebp),%edx
  802246:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802249:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	53                   	push   %ebx
  802254:	83 ec 24             	sub    $0x24,%esp
  802257:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80225a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80225d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802261:	89 1c 24             	mov    %ebx,(%esp)
  802264:	e8 bd fb ff ff       	call   801e26 <fd_lookup>
  802269:	89 c2                	mov    %eax,%edx
  80226b:	85 d2                	test   %edx,%edx
  80226d:	78 61                	js     8022d0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80226f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802272:	89 44 24 04          	mov    %eax,0x4(%esp)
  802276:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802279:	8b 00                	mov    (%eax),%eax
  80227b:	89 04 24             	mov    %eax,(%esp)
  80227e:	e8 f9 fb ff ff       	call   801e7c <dev_lookup>
  802283:	85 c0                	test   %eax,%eax
  802285:	78 49                	js     8022d0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80228e:	75 23                	jne    8022b3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  802290:	a1 20 50 80 00       	mov    0x805020,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802295:	8b 40 48             	mov    0x48(%eax),%eax
  802298:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80229c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a0:	c7 04 24 fc 3a 80 00 	movl   $0x803afc,(%esp)
  8022a7:	e8 3b e8 ff ff       	call   800ae7 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8022ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022b1:	eb 1d                	jmp    8022d0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8022b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b6:	8b 52 18             	mov    0x18(%edx),%edx
  8022b9:	85 d2                	test   %edx,%edx
  8022bb:	74 0e                	je     8022cb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8022bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022c0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022c4:	89 04 24             	mov    %eax,(%esp)
  8022c7:	ff d2                	call   *%edx
  8022c9:	eb 05                	jmp    8022d0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8022cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8022d0:	83 c4 24             	add    $0x24,%esp
  8022d3:	5b                   	pop    %ebx
  8022d4:	5d                   	pop    %ebp
  8022d5:	c3                   	ret    

008022d6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	53                   	push   %ebx
  8022da:	83 ec 24             	sub    $0x24,%esp
  8022dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	89 04 24             	mov    %eax,(%esp)
  8022ed:	e8 34 fb ff ff       	call   801e26 <fd_lookup>
  8022f2:	89 c2                	mov    %eax,%edx
  8022f4:	85 d2                	test   %edx,%edx
  8022f6:	78 52                	js     80234a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802302:	8b 00                	mov    (%eax),%eax
  802304:	89 04 24             	mov    %eax,(%esp)
  802307:	e8 70 fb ff ff       	call   801e7c <dev_lookup>
  80230c:	85 c0                	test   %eax,%eax
  80230e:	78 3a                	js     80234a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  802310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802313:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802317:	74 2c                	je     802345 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802319:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80231c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802323:	00 00 00 
	stat->st_isdir = 0;
  802326:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80232d:	00 00 00 
	stat->st_dev = dev;
  802330:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802336:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80233a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80233d:	89 14 24             	mov    %edx,(%esp)
  802340:	ff 50 14             	call   *0x14(%eax)
  802343:	eb 05                	jmp    80234a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  802345:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80234a:	83 c4 24             	add    $0x24,%esp
  80234d:	5b                   	pop    %ebx
  80234e:	5d                   	pop    %ebp
  80234f:	c3                   	ret    

00802350 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
  802353:	56                   	push   %esi
  802354:	53                   	push   %ebx
  802355:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802358:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80235f:	00 
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	89 04 24             	mov    %eax,(%esp)
  802366:	e8 84 02 00 00       	call   8025ef <open>
  80236b:	89 c3                	mov    %eax,%ebx
  80236d:	85 db                	test   %ebx,%ebx
  80236f:	78 1b                	js     80238c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  802371:	8b 45 0c             	mov    0xc(%ebp),%eax
  802374:	89 44 24 04          	mov    %eax,0x4(%esp)
  802378:	89 1c 24             	mov    %ebx,(%esp)
  80237b:	e8 56 ff ff ff       	call   8022d6 <fstat>
  802380:	89 c6                	mov    %eax,%esi
	close(fd);
  802382:	89 1c 24             	mov    %ebx,(%esp)
  802385:	e8 cd fb ff ff       	call   801f57 <close>
	return r;
  80238a:	89 f0                	mov    %esi,%eax
}
  80238c:	83 c4 10             	add    $0x10,%esp
  80238f:	5b                   	pop    %ebx
  802390:	5e                   	pop    %esi
  802391:	5d                   	pop    %ebp
  802392:	c3                   	ret    

00802393 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
  802396:	56                   	push   %esi
  802397:	53                   	push   %ebx
  802398:	83 ec 10             	sub    $0x10,%esp
  80239b:	89 c6                	mov    %eax,%esi
  80239d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80239f:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  8023a6:	75 11                	jne    8023b9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8023a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8023af:	e8 c1 f9 ff ff       	call   801d75 <ipc_find_env>
  8023b4:	a3 18 50 80 00       	mov    %eax,0x805018
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8023b9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8023c0:	00 
  8023c1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8023c8:	00 
  8023c9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023cd:	a1 18 50 80 00       	mov    0x805018,%eax
  8023d2:	89 04 24             	mov    %eax,(%esp)
  8023d5:	e8 0e f9 ff ff       	call   801ce8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8023da:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023e1:	00 
  8023e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023ed:	e8 8e f8 ff ff       	call   801c80 <ipc_recv>
}
  8023f2:	83 c4 10             	add    $0x10,%esp
  8023f5:	5b                   	pop    %ebx
  8023f6:	5e                   	pop    %esi
  8023f7:	5d                   	pop    %ebp
  8023f8:	c3                   	ret    

008023f9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
  8023fc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	8b 40 0c             	mov    0xc(%eax),%eax
  802405:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80240a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802412:	ba 00 00 00 00       	mov    $0x0,%edx
  802417:	b8 02 00 00 00       	mov    $0x2,%eax
  80241c:	e8 72 ff ff ff       	call   802393 <fsipc>
}
  802421:	c9                   	leave  
  802422:	c3                   	ret    

00802423 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
  802426:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802429:	8b 45 08             	mov    0x8(%ebp),%eax
  80242c:	8b 40 0c             	mov    0xc(%eax),%eax
  80242f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  802434:	ba 00 00 00 00       	mov    $0x0,%edx
  802439:	b8 06 00 00 00       	mov    $0x6,%eax
  80243e:	e8 50 ff ff ff       	call   802393 <fsipc>
}
  802443:	c9                   	leave  
  802444:	c3                   	ret    

00802445 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802445:	55                   	push   %ebp
  802446:	89 e5                	mov    %esp,%ebp
  802448:	53                   	push   %ebx
  802449:	83 ec 14             	sub    $0x14,%esp
  80244c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80244f:	8b 45 08             	mov    0x8(%ebp),%eax
  802452:	8b 40 0c             	mov    0xc(%eax),%eax
  802455:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80245a:	ba 00 00 00 00       	mov    $0x0,%edx
  80245f:	b8 05 00 00 00       	mov    $0x5,%eax
  802464:	e8 2a ff ff ff       	call   802393 <fsipc>
  802469:	89 c2                	mov    %eax,%edx
  80246b:	85 d2                	test   %edx,%edx
  80246d:	78 2b                	js     80249a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80246f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802476:	00 
  802477:	89 1c 24             	mov    %ebx,(%esp)
  80247a:	e8 98 ec ff ff       	call   801117 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80247f:	a1 80 60 80 00       	mov    0x806080,%eax
  802484:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80248a:	a1 84 60 80 00       	mov    0x806084,%eax
  80248f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802495:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80249a:	83 c4 14             	add    $0x14,%esp
  80249d:	5b                   	pop    %ebx
  80249e:	5d                   	pop    %ebp
  80249f:	c3                   	ret    

008024a0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
  8024a3:	53                   	push   %ebx
  8024a4:	83 ec 14             	sub    $0x14,%esp
  8024a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8024aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  8024b5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8024bb:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  8024c0:	0f 46 c3             	cmovbe %ebx,%eax
  8024c3:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8024c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d3:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  8024da:	e8 d5 ed ff ff       	call   8012b4 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8024df:	ba 00 00 00 00       	mov    $0x0,%edx
  8024e4:	b8 04 00 00 00       	mov    $0x4,%eax
  8024e9:	e8 a5 fe ff ff       	call   802393 <fsipc>
  8024ee:	85 c0                	test   %eax,%eax
  8024f0:	78 53                	js     802545 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  8024f2:	39 c3                	cmp    %eax,%ebx
  8024f4:	73 24                	jae    80251a <devfile_write+0x7a>
  8024f6:	c7 44 24 0c 6c 3b 80 	movl   $0x803b6c,0xc(%esp)
  8024fd:	00 
  8024fe:	c7 44 24 08 73 3b 80 	movl   $0x803b73,0x8(%esp)
  802505:	00 
  802506:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  80250d:	00 
  80250e:	c7 04 24 88 3b 80 00 	movl   $0x803b88,(%esp)
  802515:	e8 d4 e4 ff ff       	call   8009ee <_panic>
	assert(r <= PGSIZE);
  80251a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80251f:	7e 24                	jle    802545 <devfile_write+0xa5>
  802521:	c7 44 24 0c 93 3b 80 	movl   $0x803b93,0xc(%esp)
  802528:	00 
  802529:	c7 44 24 08 73 3b 80 	movl   $0x803b73,0x8(%esp)
  802530:	00 
  802531:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  802538:	00 
  802539:	c7 04 24 88 3b 80 00 	movl   $0x803b88,(%esp)
  802540:	e8 a9 e4 ff ff       	call   8009ee <_panic>
	return r;
}
  802545:	83 c4 14             	add    $0x14,%esp
  802548:	5b                   	pop    %ebx
  802549:	5d                   	pop    %ebp
  80254a:	c3                   	ret    

0080254b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80254b:	55                   	push   %ebp
  80254c:	89 e5                	mov    %esp,%ebp
  80254e:	56                   	push   %esi
  80254f:	53                   	push   %ebx
  802550:	83 ec 10             	sub    $0x10,%esp
  802553:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802556:	8b 45 08             	mov    0x8(%ebp),%eax
  802559:	8b 40 0c             	mov    0xc(%eax),%eax
  80255c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  802561:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802567:	ba 00 00 00 00       	mov    $0x0,%edx
  80256c:	b8 03 00 00 00       	mov    $0x3,%eax
  802571:	e8 1d fe ff ff       	call   802393 <fsipc>
  802576:	89 c3                	mov    %eax,%ebx
  802578:	85 c0                	test   %eax,%eax
  80257a:	78 6a                	js     8025e6 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  80257c:	39 c6                	cmp    %eax,%esi
  80257e:	73 24                	jae    8025a4 <devfile_read+0x59>
  802580:	c7 44 24 0c 6c 3b 80 	movl   $0x803b6c,0xc(%esp)
  802587:	00 
  802588:	c7 44 24 08 73 3b 80 	movl   $0x803b73,0x8(%esp)
  80258f:	00 
  802590:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  802597:	00 
  802598:	c7 04 24 88 3b 80 00 	movl   $0x803b88,(%esp)
  80259f:	e8 4a e4 ff ff       	call   8009ee <_panic>
	assert(r <= PGSIZE);
  8025a4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8025a9:	7e 24                	jle    8025cf <devfile_read+0x84>
  8025ab:	c7 44 24 0c 93 3b 80 	movl   $0x803b93,0xc(%esp)
  8025b2:	00 
  8025b3:	c7 44 24 08 73 3b 80 	movl   $0x803b73,0x8(%esp)
  8025ba:	00 
  8025bb:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8025c2:	00 
  8025c3:	c7 04 24 88 3b 80 00 	movl   $0x803b88,(%esp)
  8025ca:	e8 1f e4 ff ff       	call   8009ee <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8025cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025d3:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8025da:	00 
  8025db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025de:	89 04 24             	mov    %eax,(%esp)
  8025e1:	e8 ce ec ff ff       	call   8012b4 <memmove>
	return r;
}
  8025e6:	89 d8                	mov    %ebx,%eax
  8025e8:	83 c4 10             	add    $0x10,%esp
  8025eb:	5b                   	pop    %ebx
  8025ec:	5e                   	pop    %esi
  8025ed:	5d                   	pop    %ebp
  8025ee:	c3                   	ret    

008025ef <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
  8025f2:	53                   	push   %ebx
  8025f3:	83 ec 24             	sub    $0x24,%esp
  8025f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8025f9:	89 1c 24             	mov    %ebx,(%esp)
  8025fc:	e8 df ea ff ff       	call   8010e0 <strlen>
  802601:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802606:	7f 60                	jg     802668 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  802608:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80260b:	89 04 24             	mov    %eax,(%esp)
  80260e:	e8 c4 f7 ff ff       	call   801dd7 <fd_alloc>
  802613:	89 c2                	mov    %eax,%edx
  802615:	85 d2                	test   %edx,%edx
  802617:	78 54                	js     80266d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  802619:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80261d:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  802624:	e8 ee ea ff ff       	call   801117 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80262c:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802631:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802634:	b8 01 00 00 00       	mov    $0x1,%eax
  802639:	e8 55 fd ff ff       	call   802393 <fsipc>
  80263e:	89 c3                	mov    %eax,%ebx
  802640:	85 c0                	test   %eax,%eax
  802642:	79 17                	jns    80265b <open+0x6c>
		fd_close(fd, 0);
  802644:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80264b:	00 
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	89 04 24             	mov    %eax,(%esp)
  802652:	e8 7f f8 ff ff       	call   801ed6 <fd_close>
		return r;
  802657:	89 d8                	mov    %ebx,%eax
  802659:	eb 12                	jmp    80266d <open+0x7e>
	}

	return fd2num(fd);
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	89 04 24             	mov    %eax,(%esp)
  802661:	e8 4a f7 ff ff       	call   801db0 <fd2num>
  802666:	eb 05                	jmp    80266d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  802668:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80266d:	83 c4 24             	add    $0x24,%esp
  802670:	5b                   	pop    %ebx
  802671:	5d                   	pop    %ebp
  802672:	c3                   	ret    

00802673 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
  802676:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802679:	ba 00 00 00 00       	mov    $0x0,%edx
  80267e:	b8 08 00 00 00       	mov    $0x8,%eax
  802683:	e8 0b fd ff ff       	call   802393 <fsipc>
}
  802688:	c9                   	leave  
  802689:	c3                   	ret    
  80268a:	66 90                	xchg   %ax,%ax
  80268c:	66 90                	xchg   %ax,%ax
  80268e:	66 90                	xchg   %ax,%ax

00802690 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802696:	c7 44 24 04 9f 3b 80 	movl   $0x803b9f,0x4(%esp)
  80269d:	00 
  80269e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026a1:	89 04 24             	mov    %eax,(%esp)
  8026a4:	e8 6e ea ff ff       	call   801117 <strcpy>
	return 0;
}
  8026a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ae:	c9                   	leave  
  8026af:	c3                   	ret    

008026b0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8026b0:	55                   	push   %ebp
  8026b1:	89 e5                	mov    %esp,%ebp
  8026b3:	53                   	push   %ebx
  8026b4:	83 ec 14             	sub    $0x14,%esp
  8026b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8026ba:	89 1c 24             	mov    %ebx,(%esp)
  8026bd:	e8 a9 0a 00 00       	call   80316b <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8026c2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8026c7:	83 f8 01             	cmp    $0x1,%eax
  8026ca:	75 0d                	jne    8026d9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8026cc:	8b 43 0c             	mov    0xc(%ebx),%eax
  8026cf:	89 04 24             	mov    %eax,(%esp)
  8026d2:	e8 29 03 00 00       	call   802a00 <nsipc_close>
  8026d7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8026d9:	89 d0                	mov    %edx,%eax
  8026db:	83 c4 14             	add    $0x14,%esp
  8026de:	5b                   	pop    %ebx
  8026df:	5d                   	pop    %ebp
  8026e0:	c3                   	ret    

008026e1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8026e1:	55                   	push   %ebp
  8026e2:	89 e5                	mov    %esp,%ebp
  8026e4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8026e7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8026ee:	00 
  8026ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8026f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802700:	8b 40 0c             	mov    0xc(%eax),%eax
  802703:	89 04 24             	mov    %eax,(%esp)
  802706:	e8 f0 03 00 00       	call   802afb <nsipc_send>
}
  80270b:	c9                   	leave  
  80270c:	c3                   	ret    

0080270d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80270d:	55                   	push   %ebp
  80270e:	89 e5                	mov    %esp,%ebp
  802710:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802713:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80271a:	00 
  80271b:	8b 45 10             	mov    0x10(%ebp),%eax
  80271e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802722:	8b 45 0c             	mov    0xc(%ebp),%eax
  802725:	89 44 24 04          	mov    %eax,0x4(%esp)
  802729:	8b 45 08             	mov    0x8(%ebp),%eax
  80272c:	8b 40 0c             	mov    0xc(%eax),%eax
  80272f:	89 04 24             	mov    %eax,(%esp)
  802732:	e8 44 03 00 00       	call   802a7b <nsipc_recv>
}
  802737:	c9                   	leave  
  802738:	c3                   	ret    

00802739 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802739:	55                   	push   %ebp
  80273a:	89 e5                	mov    %esp,%ebp
  80273c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80273f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802742:	89 54 24 04          	mov    %edx,0x4(%esp)
  802746:	89 04 24             	mov    %eax,(%esp)
  802749:	e8 d8 f6 ff ff       	call   801e26 <fd_lookup>
  80274e:	85 c0                	test   %eax,%eax
  802750:	78 17                	js     802769 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80275b:	39 08                	cmp    %ecx,(%eax)
  80275d:	75 05                	jne    802764 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80275f:	8b 40 0c             	mov    0xc(%eax),%eax
  802762:	eb 05                	jmp    802769 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802764:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802769:	c9                   	leave  
  80276a:	c3                   	ret    

0080276b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80276b:	55                   	push   %ebp
  80276c:	89 e5                	mov    %esp,%ebp
  80276e:	56                   	push   %esi
  80276f:	53                   	push   %ebx
  802770:	83 ec 20             	sub    $0x20,%esp
  802773:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802775:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802778:	89 04 24             	mov    %eax,(%esp)
  80277b:	e8 57 f6 ff ff       	call   801dd7 <fd_alloc>
  802780:	89 c3                	mov    %eax,%ebx
  802782:	85 c0                	test   %eax,%eax
  802784:	78 21                	js     8027a7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802786:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80278d:	00 
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	89 44 24 04          	mov    %eax,0x4(%esp)
  802795:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80279c:	e8 92 ed ff ff       	call   801533 <sys_page_alloc>
  8027a1:	89 c3                	mov    %eax,%ebx
  8027a3:	85 c0                	test   %eax,%eax
  8027a5:	79 0c                	jns    8027b3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8027a7:	89 34 24             	mov    %esi,(%esp)
  8027aa:	e8 51 02 00 00       	call   802a00 <nsipc_close>
		return r;
  8027af:	89 d8                	mov    %ebx,%eax
  8027b1:	eb 20                	jmp    8027d3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8027b3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8027be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8027c8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8027cb:	89 14 24             	mov    %edx,(%esp)
  8027ce:	e8 dd f5 ff ff       	call   801db0 <fd2num>
}
  8027d3:	83 c4 20             	add    $0x20,%esp
  8027d6:	5b                   	pop    %ebx
  8027d7:	5e                   	pop    %esi
  8027d8:	5d                   	pop    %ebp
  8027d9:	c3                   	ret    

008027da <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8027da:	55                   	push   %ebp
  8027db:	89 e5                	mov    %esp,%ebp
  8027dd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8027e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e3:	e8 51 ff ff ff       	call   802739 <fd2sockid>
		return r;
  8027e8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8027ea:	85 c0                	test   %eax,%eax
  8027ec:	78 23                	js     802811 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8027ee:	8b 55 10             	mov    0x10(%ebp),%edx
  8027f1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8027f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027fc:	89 04 24             	mov    %eax,(%esp)
  8027ff:	e8 45 01 00 00       	call   802949 <nsipc_accept>
		return r;
  802804:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802806:	85 c0                	test   %eax,%eax
  802808:	78 07                	js     802811 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80280a:	e8 5c ff ff ff       	call   80276b <alloc_sockfd>
  80280f:	89 c1                	mov    %eax,%ecx
}
  802811:	89 c8                	mov    %ecx,%eax
  802813:	c9                   	leave  
  802814:	c3                   	ret    

00802815 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802815:	55                   	push   %ebp
  802816:	89 e5                	mov    %esp,%ebp
  802818:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80281b:	8b 45 08             	mov    0x8(%ebp),%eax
  80281e:	e8 16 ff ff ff       	call   802739 <fd2sockid>
  802823:	89 c2                	mov    %eax,%edx
  802825:	85 d2                	test   %edx,%edx
  802827:	78 16                	js     80283f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802829:	8b 45 10             	mov    0x10(%ebp),%eax
  80282c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802830:	8b 45 0c             	mov    0xc(%ebp),%eax
  802833:	89 44 24 04          	mov    %eax,0x4(%esp)
  802837:	89 14 24             	mov    %edx,(%esp)
  80283a:	e8 60 01 00 00       	call   80299f <nsipc_bind>
}
  80283f:	c9                   	leave  
  802840:	c3                   	ret    

00802841 <shutdown>:

int
shutdown(int s, int how)
{
  802841:	55                   	push   %ebp
  802842:	89 e5                	mov    %esp,%ebp
  802844:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802847:	8b 45 08             	mov    0x8(%ebp),%eax
  80284a:	e8 ea fe ff ff       	call   802739 <fd2sockid>
  80284f:	89 c2                	mov    %eax,%edx
  802851:	85 d2                	test   %edx,%edx
  802853:	78 0f                	js     802864 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802855:	8b 45 0c             	mov    0xc(%ebp),%eax
  802858:	89 44 24 04          	mov    %eax,0x4(%esp)
  80285c:	89 14 24             	mov    %edx,(%esp)
  80285f:	e8 7a 01 00 00       	call   8029de <nsipc_shutdown>
}
  802864:	c9                   	leave  
  802865:	c3                   	ret    

00802866 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802866:	55                   	push   %ebp
  802867:	89 e5                	mov    %esp,%ebp
  802869:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80286c:	8b 45 08             	mov    0x8(%ebp),%eax
  80286f:	e8 c5 fe ff ff       	call   802739 <fd2sockid>
  802874:	89 c2                	mov    %eax,%edx
  802876:	85 d2                	test   %edx,%edx
  802878:	78 16                	js     802890 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80287a:	8b 45 10             	mov    0x10(%ebp),%eax
  80287d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802881:	8b 45 0c             	mov    0xc(%ebp),%eax
  802884:	89 44 24 04          	mov    %eax,0x4(%esp)
  802888:	89 14 24             	mov    %edx,(%esp)
  80288b:	e8 8a 01 00 00       	call   802a1a <nsipc_connect>
}
  802890:	c9                   	leave  
  802891:	c3                   	ret    

00802892 <listen>:

int
listen(int s, int backlog)
{
  802892:	55                   	push   %ebp
  802893:	89 e5                	mov    %esp,%ebp
  802895:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802898:	8b 45 08             	mov    0x8(%ebp),%eax
  80289b:	e8 99 fe ff ff       	call   802739 <fd2sockid>
  8028a0:	89 c2                	mov    %eax,%edx
  8028a2:	85 d2                	test   %edx,%edx
  8028a4:	78 0f                	js     8028b5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8028a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ad:	89 14 24             	mov    %edx,(%esp)
  8028b0:	e8 a4 01 00 00       	call   802a59 <nsipc_listen>
}
  8028b5:	c9                   	leave  
  8028b6:	c3                   	ret    

008028b7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8028b7:	55                   	push   %ebp
  8028b8:	89 e5                	mov    %esp,%ebp
  8028ba:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8028bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8028c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ce:	89 04 24             	mov    %eax,(%esp)
  8028d1:	e8 98 02 00 00       	call   802b6e <nsipc_socket>
  8028d6:	89 c2                	mov    %eax,%edx
  8028d8:	85 d2                	test   %edx,%edx
  8028da:	78 05                	js     8028e1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8028dc:	e8 8a fe ff ff       	call   80276b <alloc_sockfd>
}
  8028e1:	c9                   	leave  
  8028e2:	c3                   	ret    

008028e3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
  8028e6:	53                   	push   %ebx
  8028e7:	83 ec 14             	sub    $0x14,%esp
  8028ea:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8028ec:	83 3d 1c 50 80 00 00 	cmpl   $0x0,0x80501c
  8028f3:	75 11                	jne    802906 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8028f5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8028fc:	e8 74 f4 ff ff       	call   801d75 <ipc_find_env>
  802901:	a3 1c 50 80 00       	mov    %eax,0x80501c
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802906:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80290d:	00 
  80290e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802915:	00 
  802916:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80291a:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80291f:	89 04 24             	mov    %eax,(%esp)
  802922:	e8 c1 f3 ff ff       	call   801ce8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802927:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80292e:	00 
  80292f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802936:	00 
  802937:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80293e:	e8 3d f3 ff ff       	call   801c80 <ipc_recv>
}
  802943:	83 c4 14             	add    $0x14,%esp
  802946:	5b                   	pop    %ebx
  802947:	5d                   	pop    %ebp
  802948:	c3                   	ret    

00802949 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802949:	55                   	push   %ebp
  80294a:	89 e5                	mov    %esp,%ebp
  80294c:	56                   	push   %esi
  80294d:	53                   	push   %ebx
  80294e:	83 ec 10             	sub    $0x10,%esp
  802951:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80295c:	8b 06                	mov    (%esi),%eax
  80295e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802963:	b8 01 00 00 00       	mov    $0x1,%eax
  802968:	e8 76 ff ff ff       	call   8028e3 <nsipc>
  80296d:	89 c3                	mov    %eax,%ebx
  80296f:	85 c0                	test   %eax,%eax
  802971:	78 23                	js     802996 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802973:	a1 10 70 80 00       	mov    0x807010,%eax
  802978:	89 44 24 08          	mov    %eax,0x8(%esp)
  80297c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802983:	00 
  802984:	8b 45 0c             	mov    0xc(%ebp),%eax
  802987:	89 04 24             	mov    %eax,(%esp)
  80298a:	e8 25 e9 ff ff       	call   8012b4 <memmove>
		*addrlen = ret->ret_addrlen;
  80298f:	a1 10 70 80 00       	mov    0x807010,%eax
  802994:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802996:	89 d8                	mov    %ebx,%eax
  802998:	83 c4 10             	add    $0x10,%esp
  80299b:	5b                   	pop    %ebx
  80299c:	5e                   	pop    %esi
  80299d:	5d                   	pop    %ebp
  80299e:	c3                   	ret    

0080299f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80299f:	55                   	push   %ebp
  8029a0:	89 e5                	mov    %esp,%ebp
  8029a2:	53                   	push   %ebx
  8029a3:	83 ec 14             	sub    $0x14,%esp
  8029a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8029b1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029bc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8029c3:	e8 ec e8 ff ff       	call   8012b4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8029c8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8029ce:	b8 02 00 00 00       	mov    $0x2,%eax
  8029d3:	e8 0b ff ff ff       	call   8028e3 <nsipc>
}
  8029d8:	83 c4 14             	add    $0x14,%esp
  8029db:	5b                   	pop    %ebx
  8029dc:	5d                   	pop    %ebp
  8029dd:	c3                   	ret    

008029de <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8029de:	55                   	push   %ebp
  8029df:	89 e5                	mov    %esp,%ebp
  8029e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8029ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029ef:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8029f4:	b8 03 00 00 00       	mov    $0x3,%eax
  8029f9:	e8 e5 fe ff ff       	call   8028e3 <nsipc>
}
  8029fe:	c9                   	leave  
  8029ff:	c3                   	ret    

00802a00 <nsipc_close>:

int
nsipc_close(int s)
{
  802a00:	55                   	push   %ebp
  802a01:	89 e5                	mov    %esp,%ebp
  802a03:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802a06:	8b 45 08             	mov    0x8(%ebp),%eax
  802a09:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  802a0e:	b8 04 00 00 00       	mov    $0x4,%eax
  802a13:	e8 cb fe ff ff       	call   8028e3 <nsipc>
}
  802a18:	c9                   	leave  
  802a19:	c3                   	ret    

00802a1a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802a1a:	55                   	push   %ebp
  802a1b:	89 e5                	mov    %esp,%ebp
  802a1d:	53                   	push   %ebx
  802a1e:	83 ec 14             	sub    $0x14,%esp
  802a21:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802a24:	8b 45 08             	mov    0x8(%ebp),%eax
  802a27:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802a2c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a37:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802a3e:	e8 71 e8 ff ff       	call   8012b4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802a43:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802a49:	b8 05 00 00 00       	mov    $0x5,%eax
  802a4e:	e8 90 fe ff ff       	call   8028e3 <nsipc>
}
  802a53:	83 c4 14             	add    $0x14,%esp
  802a56:	5b                   	pop    %ebx
  802a57:	5d                   	pop    %ebp
  802a58:	c3                   	ret    

00802a59 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802a59:	55                   	push   %ebp
  802a5a:	89 e5                	mov    %esp,%ebp
  802a5c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a62:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a6a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  802a6f:	b8 06 00 00 00       	mov    $0x6,%eax
  802a74:	e8 6a fe ff ff       	call   8028e3 <nsipc>
}
  802a79:	c9                   	leave  
  802a7a:	c3                   	ret    

00802a7b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802a7b:	55                   	push   %ebp
  802a7c:	89 e5                	mov    %esp,%ebp
  802a7e:	56                   	push   %esi
  802a7f:	53                   	push   %ebx
  802a80:	83 ec 10             	sub    $0x10,%esp
  802a83:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802a86:	8b 45 08             	mov    0x8(%ebp),%eax
  802a89:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802a8e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802a94:	8b 45 14             	mov    0x14(%ebp),%eax
  802a97:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802a9c:	b8 07 00 00 00       	mov    $0x7,%eax
  802aa1:	e8 3d fe ff ff       	call   8028e3 <nsipc>
  802aa6:	89 c3                	mov    %eax,%ebx
  802aa8:	85 c0                	test   %eax,%eax
  802aaa:	78 46                	js     802af2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802aac:	39 f0                	cmp    %esi,%eax
  802aae:	7f 07                	jg     802ab7 <nsipc_recv+0x3c>
  802ab0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802ab5:	7e 24                	jle    802adb <nsipc_recv+0x60>
  802ab7:	c7 44 24 0c ab 3b 80 	movl   $0x803bab,0xc(%esp)
  802abe:	00 
  802abf:	c7 44 24 08 73 3b 80 	movl   $0x803b73,0x8(%esp)
  802ac6:	00 
  802ac7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  802ace:	00 
  802acf:	c7 04 24 c0 3b 80 00 	movl   $0x803bc0,(%esp)
  802ad6:	e8 13 df ff ff       	call   8009ee <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802adb:	89 44 24 08          	mov    %eax,0x8(%esp)
  802adf:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802ae6:	00 
  802ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aea:	89 04 24             	mov    %eax,(%esp)
  802aed:	e8 c2 e7 ff ff       	call   8012b4 <memmove>
	}

	return r;
}
  802af2:	89 d8                	mov    %ebx,%eax
  802af4:	83 c4 10             	add    $0x10,%esp
  802af7:	5b                   	pop    %ebx
  802af8:	5e                   	pop    %esi
  802af9:	5d                   	pop    %ebp
  802afa:	c3                   	ret    

00802afb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802afb:	55                   	push   %ebp
  802afc:	89 e5                	mov    %esp,%ebp
  802afe:	53                   	push   %ebx
  802aff:	83 ec 14             	sub    $0x14,%esp
  802b02:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802b0d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802b13:	7e 24                	jle    802b39 <nsipc_send+0x3e>
  802b15:	c7 44 24 0c cc 3b 80 	movl   $0x803bcc,0xc(%esp)
  802b1c:	00 
  802b1d:	c7 44 24 08 73 3b 80 	movl   $0x803b73,0x8(%esp)
  802b24:	00 
  802b25:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  802b2c:	00 
  802b2d:	c7 04 24 c0 3b 80 00 	movl   $0x803bc0,(%esp)
  802b34:	e8 b5 de ff ff       	call   8009ee <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802b39:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b40:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b44:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  802b4b:	e8 64 e7 ff ff       	call   8012b4 <memmove>
	nsipcbuf.send.req_size = size;
  802b50:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802b56:	8b 45 14             	mov    0x14(%ebp),%eax
  802b59:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802b5e:	b8 08 00 00 00       	mov    $0x8,%eax
  802b63:	e8 7b fd ff ff       	call   8028e3 <nsipc>
}
  802b68:	83 c4 14             	add    $0x14,%esp
  802b6b:	5b                   	pop    %ebx
  802b6c:	5d                   	pop    %ebp
  802b6d:	c3                   	ret    

00802b6e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802b6e:	55                   	push   %ebp
  802b6f:	89 e5                	mov    %esp,%ebp
  802b71:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b7f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802b84:	8b 45 10             	mov    0x10(%ebp),%eax
  802b87:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802b8c:	b8 09 00 00 00       	mov    $0x9,%eax
  802b91:	e8 4d fd ff ff       	call   8028e3 <nsipc>
}
  802b96:	c9                   	leave  
  802b97:	c3                   	ret    

00802b98 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802b98:	55                   	push   %ebp
  802b99:	89 e5                	mov    %esp,%ebp
  802b9b:	56                   	push   %esi
  802b9c:	53                   	push   %ebx
  802b9d:	83 ec 10             	sub    $0x10,%esp
  802ba0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba6:	89 04 24             	mov    %eax,(%esp)
  802ba9:	e8 12 f2 ff ff       	call   801dc0 <fd2data>
  802bae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802bb0:	c7 44 24 04 d8 3b 80 	movl   $0x803bd8,0x4(%esp)
  802bb7:	00 
  802bb8:	89 1c 24             	mov    %ebx,(%esp)
  802bbb:	e8 57 e5 ff ff       	call   801117 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802bc0:	8b 46 04             	mov    0x4(%esi),%eax
  802bc3:	2b 06                	sub    (%esi),%eax
  802bc5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802bcb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802bd2:	00 00 00 
	stat->st_dev = &devpipe;
  802bd5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802bdc:	40 80 00 
	return 0;
}
  802bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  802be4:	83 c4 10             	add    $0x10,%esp
  802be7:	5b                   	pop    %ebx
  802be8:	5e                   	pop    %esi
  802be9:	5d                   	pop    %ebp
  802bea:	c3                   	ret    

00802beb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802beb:	55                   	push   %ebp
  802bec:	89 e5                	mov    %esp,%ebp
  802bee:	53                   	push   %ebx
  802bef:	83 ec 14             	sub    $0x14,%esp
  802bf2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802bf5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802bf9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c00:	e8 d5 e9 ff ff       	call   8015da <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802c05:	89 1c 24             	mov    %ebx,(%esp)
  802c08:	e8 b3 f1 ff ff       	call   801dc0 <fd2data>
  802c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c18:	e8 bd e9 ff ff       	call   8015da <sys_page_unmap>
}
  802c1d:	83 c4 14             	add    $0x14,%esp
  802c20:	5b                   	pop    %ebx
  802c21:	5d                   	pop    %ebp
  802c22:	c3                   	ret    

00802c23 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802c23:	55                   	push   %ebp
  802c24:	89 e5                	mov    %esp,%ebp
  802c26:	57                   	push   %edi
  802c27:	56                   	push   %esi
  802c28:	53                   	push   %ebx
  802c29:	83 ec 2c             	sub    $0x2c,%esp
  802c2c:	89 c6                	mov    %eax,%esi
  802c2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802c31:	a1 20 50 80 00       	mov    0x805020,%eax
  802c36:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802c39:	89 34 24             	mov    %esi,(%esp)
  802c3c:	e8 2a 05 00 00       	call   80316b <pageref>
  802c41:	89 c7                	mov    %eax,%edi
  802c43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c46:	89 04 24             	mov    %eax,(%esp)
  802c49:	e8 1d 05 00 00       	call   80316b <pageref>
  802c4e:	39 c7                	cmp    %eax,%edi
  802c50:	0f 94 c2             	sete   %dl
  802c53:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802c56:	8b 0d 20 50 80 00    	mov    0x805020,%ecx
  802c5c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802c5f:	39 fb                	cmp    %edi,%ebx
  802c61:	74 21                	je     802c84 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802c63:	84 d2                	test   %dl,%dl
  802c65:	74 ca                	je     802c31 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802c67:	8b 51 58             	mov    0x58(%ecx),%edx
  802c6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c6e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c72:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802c76:	c7 04 24 df 3b 80 00 	movl   $0x803bdf,(%esp)
  802c7d:	e8 65 de ff ff       	call   800ae7 <cprintf>
  802c82:	eb ad                	jmp    802c31 <_pipeisclosed+0xe>
	}
}
  802c84:	83 c4 2c             	add    $0x2c,%esp
  802c87:	5b                   	pop    %ebx
  802c88:	5e                   	pop    %esi
  802c89:	5f                   	pop    %edi
  802c8a:	5d                   	pop    %ebp
  802c8b:	c3                   	ret    

00802c8c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802c8c:	55                   	push   %ebp
  802c8d:	89 e5                	mov    %esp,%ebp
  802c8f:	57                   	push   %edi
  802c90:	56                   	push   %esi
  802c91:	53                   	push   %ebx
  802c92:	83 ec 1c             	sub    $0x1c,%esp
  802c95:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802c98:	89 34 24             	mov    %esi,(%esp)
  802c9b:	e8 20 f1 ff ff       	call   801dc0 <fd2data>
  802ca0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802ca2:	bf 00 00 00 00       	mov    $0x0,%edi
  802ca7:	eb 45                	jmp    802cee <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802ca9:	89 da                	mov    %ebx,%edx
  802cab:	89 f0                	mov    %esi,%eax
  802cad:	e8 71 ff ff ff       	call   802c23 <_pipeisclosed>
  802cb2:	85 c0                	test   %eax,%eax
  802cb4:	75 41                	jne    802cf7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802cb6:	e8 59 e8 ff ff       	call   801514 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802cbb:	8b 43 04             	mov    0x4(%ebx),%eax
  802cbe:	8b 0b                	mov    (%ebx),%ecx
  802cc0:	8d 51 20             	lea    0x20(%ecx),%edx
  802cc3:	39 d0                	cmp    %edx,%eax
  802cc5:	73 e2                	jae    802ca9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802cc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802cca:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802cce:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802cd1:	99                   	cltd   
  802cd2:	c1 ea 1b             	shr    $0x1b,%edx
  802cd5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802cd8:	83 e1 1f             	and    $0x1f,%ecx
  802cdb:	29 d1                	sub    %edx,%ecx
  802cdd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802ce1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802ce5:	83 c0 01             	add    $0x1,%eax
  802ce8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802ceb:	83 c7 01             	add    $0x1,%edi
  802cee:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802cf1:	75 c8                	jne    802cbb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802cf3:	89 f8                	mov    %edi,%eax
  802cf5:	eb 05                	jmp    802cfc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802cf7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  802cfc:	83 c4 1c             	add    $0x1c,%esp
  802cff:	5b                   	pop    %ebx
  802d00:	5e                   	pop    %esi
  802d01:	5f                   	pop    %edi
  802d02:	5d                   	pop    %ebp
  802d03:	c3                   	ret    

00802d04 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802d04:	55                   	push   %ebp
  802d05:	89 e5                	mov    %esp,%ebp
  802d07:	57                   	push   %edi
  802d08:	56                   	push   %esi
  802d09:	53                   	push   %ebx
  802d0a:	83 ec 1c             	sub    $0x1c,%esp
  802d0d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802d10:	89 3c 24             	mov    %edi,(%esp)
  802d13:	e8 a8 f0 ff ff       	call   801dc0 <fd2data>
  802d18:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802d1a:	be 00 00 00 00       	mov    $0x0,%esi
  802d1f:	eb 3d                	jmp    802d5e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802d21:	85 f6                	test   %esi,%esi
  802d23:	74 04                	je     802d29 <devpipe_read+0x25>
				return i;
  802d25:	89 f0                	mov    %esi,%eax
  802d27:	eb 43                	jmp    802d6c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802d29:	89 da                	mov    %ebx,%edx
  802d2b:	89 f8                	mov    %edi,%eax
  802d2d:	e8 f1 fe ff ff       	call   802c23 <_pipeisclosed>
  802d32:	85 c0                	test   %eax,%eax
  802d34:	75 31                	jne    802d67 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802d36:	e8 d9 e7 ff ff       	call   801514 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802d3b:	8b 03                	mov    (%ebx),%eax
  802d3d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802d40:	74 df                	je     802d21 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802d42:	99                   	cltd   
  802d43:	c1 ea 1b             	shr    $0x1b,%edx
  802d46:	01 d0                	add    %edx,%eax
  802d48:	83 e0 1f             	and    $0x1f,%eax
  802d4b:	29 d0                	sub    %edx,%eax
  802d4d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802d52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802d55:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802d58:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802d5b:	83 c6 01             	add    $0x1,%esi
  802d5e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802d61:	75 d8                	jne    802d3b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802d63:	89 f0                	mov    %esi,%eax
  802d65:	eb 05                	jmp    802d6c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802d67:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802d6c:	83 c4 1c             	add    $0x1c,%esp
  802d6f:	5b                   	pop    %ebx
  802d70:	5e                   	pop    %esi
  802d71:	5f                   	pop    %edi
  802d72:	5d                   	pop    %ebp
  802d73:	c3                   	ret    

00802d74 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802d74:	55                   	push   %ebp
  802d75:	89 e5                	mov    %esp,%ebp
  802d77:	56                   	push   %esi
  802d78:	53                   	push   %ebx
  802d79:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802d7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d7f:	89 04 24             	mov    %eax,(%esp)
  802d82:	e8 50 f0 ff ff       	call   801dd7 <fd_alloc>
  802d87:	89 c2                	mov    %eax,%edx
  802d89:	85 d2                	test   %edx,%edx
  802d8b:	0f 88 4d 01 00 00    	js     802ede <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d91:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802d98:	00 
  802d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802da0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802da7:	e8 87 e7 ff ff       	call   801533 <sys_page_alloc>
  802dac:	89 c2                	mov    %eax,%edx
  802dae:	85 d2                	test   %edx,%edx
  802db0:	0f 88 28 01 00 00    	js     802ede <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802db6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802db9:	89 04 24             	mov    %eax,(%esp)
  802dbc:	e8 16 f0 ff ff       	call   801dd7 <fd_alloc>
  802dc1:	89 c3                	mov    %eax,%ebx
  802dc3:	85 c0                	test   %eax,%eax
  802dc5:	0f 88 fe 00 00 00    	js     802ec9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802dcb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802dd2:	00 
  802dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dda:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802de1:	e8 4d e7 ff ff       	call   801533 <sys_page_alloc>
  802de6:	89 c3                	mov    %eax,%ebx
  802de8:	85 c0                	test   %eax,%eax
  802dea:	0f 88 d9 00 00 00    	js     802ec9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	89 04 24             	mov    %eax,(%esp)
  802df6:	e8 c5 ef ff ff       	call   801dc0 <fd2data>
  802dfb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802dfd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802e04:	00 
  802e05:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e10:	e8 1e e7 ff ff       	call   801533 <sys_page_alloc>
  802e15:	89 c3                	mov    %eax,%ebx
  802e17:	85 c0                	test   %eax,%eax
  802e19:	0f 88 97 00 00 00    	js     802eb6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e22:	89 04 24             	mov    %eax,(%esp)
  802e25:	e8 96 ef ff ff       	call   801dc0 <fd2data>
  802e2a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802e31:	00 
  802e32:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e36:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802e3d:	00 
  802e3e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802e42:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e49:	e8 39 e7 ff ff       	call   801587 <sys_page_map>
  802e4e:	89 c3                	mov    %eax,%ebx
  802e50:	85 c0                	test   %eax,%eax
  802e52:	78 52                	js     802ea6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802e54:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802e69:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e72:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e77:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	89 04 24             	mov    %eax,(%esp)
  802e84:	e8 27 ef ff ff       	call   801db0 <fd2num>
  802e89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e8c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e91:	89 04 24             	mov    %eax,(%esp)
  802e94:	e8 17 ef ff ff       	call   801db0 <fd2num>
  802e99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e9c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea4:	eb 38                	jmp    802ede <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802ea6:	89 74 24 04          	mov    %esi,0x4(%esp)
  802eaa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802eb1:	e8 24 e7 ff ff       	call   8015da <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ebd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ec4:	e8 11 e7 ff ff       	call   8015da <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ed0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ed7:	e8 fe e6 ff ff       	call   8015da <sys_page_unmap>
  802edc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802ede:	83 c4 30             	add    $0x30,%esp
  802ee1:	5b                   	pop    %ebx
  802ee2:	5e                   	pop    %esi
  802ee3:	5d                   	pop    %ebp
  802ee4:	c3                   	ret    

00802ee5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802ee5:	55                   	push   %ebp
  802ee6:	89 e5                	mov    %esp,%ebp
  802ee8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802eeb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802eee:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	89 04 24             	mov    %eax,(%esp)
  802ef8:	e8 29 ef ff ff       	call   801e26 <fd_lookup>
  802efd:	89 c2                	mov    %eax,%edx
  802eff:	85 d2                	test   %edx,%edx
  802f01:	78 15                	js     802f18 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	89 04 24             	mov    %eax,(%esp)
  802f09:	e8 b2 ee ff ff       	call   801dc0 <fd2data>
	return _pipeisclosed(fd, p);
  802f0e:	89 c2                	mov    %eax,%edx
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	e8 0b fd ff ff       	call   802c23 <_pipeisclosed>
}
  802f18:	c9                   	leave  
  802f19:	c3                   	ret    
  802f1a:	66 90                	xchg   %ax,%ax
  802f1c:	66 90                	xchg   %ax,%ax
  802f1e:	66 90                	xchg   %ax,%ax

00802f20 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802f20:	55                   	push   %ebp
  802f21:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802f23:	b8 00 00 00 00       	mov    $0x0,%eax
  802f28:	5d                   	pop    %ebp
  802f29:	c3                   	ret    

00802f2a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802f2a:	55                   	push   %ebp
  802f2b:	89 e5                	mov    %esp,%ebp
  802f2d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802f30:	c7 44 24 04 f7 3b 80 	movl   $0x803bf7,0x4(%esp)
  802f37:	00 
  802f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f3b:	89 04 24             	mov    %eax,(%esp)
  802f3e:	e8 d4 e1 ff ff       	call   801117 <strcpy>
	return 0;
}
  802f43:	b8 00 00 00 00       	mov    $0x0,%eax
  802f48:	c9                   	leave  
  802f49:	c3                   	ret    

00802f4a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802f4a:	55                   	push   %ebp
  802f4b:	89 e5                	mov    %esp,%ebp
  802f4d:	57                   	push   %edi
  802f4e:	56                   	push   %esi
  802f4f:	53                   	push   %ebx
  802f50:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802f56:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802f5b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802f61:	eb 31                	jmp    802f94 <devcons_write+0x4a>
		m = n - tot;
  802f63:	8b 75 10             	mov    0x10(%ebp),%esi
  802f66:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802f68:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802f6b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802f70:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802f73:	89 74 24 08          	mov    %esi,0x8(%esp)
  802f77:	03 45 0c             	add    0xc(%ebp),%eax
  802f7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f7e:	89 3c 24             	mov    %edi,(%esp)
  802f81:	e8 2e e3 ff ff       	call   8012b4 <memmove>
		sys_cputs(buf, m);
  802f86:	89 74 24 04          	mov    %esi,0x4(%esp)
  802f8a:	89 3c 24             	mov    %edi,(%esp)
  802f8d:	e8 d4 e4 ff ff       	call   801466 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802f92:	01 f3                	add    %esi,%ebx
  802f94:	89 d8                	mov    %ebx,%eax
  802f96:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802f99:	72 c8                	jb     802f63 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802f9b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802fa1:	5b                   	pop    %ebx
  802fa2:	5e                   	pop    %esi
  802fa3:	5f                   	pop    %edi
  802fa4:	5d                   	pop    %ebp
  802fa5:	c3                   	ret    

00802fa6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802fa6:	55                   	push   %ebp
  802fa7:	89 e5                	mov    %esp,%ebp
  802fa9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802fac:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802fb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802fb5:	75 07                	jne    802fbe <devcons_read+0x18>
  802fb7:	eb 2a                	jmp    802fe3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802fb9:	e8 56 e5 ff ff       	call   801514 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802fbe:	66 90                	xchg   %ax,%ax
  802fc0:	e8 bf e4 ff ff       	call   801484 <sys_cgetc>
  802fc5:	85 c0                	test   %eax,%eax
  802fc7:	74 f0                	je     802fb9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802fc9:	85 c0                	test   %eax,%eax
  802fcb:	78 16                	js     802fe3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802fcd:	83 f8 04             	cmp    $0x4,%eax
  802fd0:	74 0c                	je     802fde <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802fd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd5:	88 02                	mov    %al,(%edx)
	return 1;
  802fd7:	b8 01 00 00 00       	mov    $0x1,%eax
  802fdc:	eb 05                	jmp    802fe3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802fde:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802fe3:	c9                   	leave  
  802fe4:	c3                   	ret    

00802fe5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802fe5:	55                   	push   %ebp
  802fe6:	89 e5                	mov    %esp,%ebp
  802fe8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802ff1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802ff8:	00 
  802ff9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802ffc:	89 04 24             	mov    %eax,(%esp)
  802fff:	e8 62 e4 ff ff       	call   801466 <sys_cputs>
}
  803004:	c9                   	leave  
  803005:	c3                   	ret    

00803006 <getchar>:

int
getchar(void)
{
  803006:	55                   	push   %ebp
  803007:	89 e5                	mov    %esp,%ebp
  803009:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80300c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803013:	00 
  803014:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803017:	89 44 24 04          	mov    %eax,0x4(%esp)
  80301b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803022:	e8 93 f0 ff ff       	call   8020ba <read>
	if (r < 0)
  803027:	85 c0                	test   %eax,%eax
  803029:	78 0f                	js     80303a <getchar+0x34>
		return r;
	if (r < 1)
  80302b:	85 c0                	test   %eax,%eax
  80302d:	7e 06                	jle    803035 <getchar+0x2f>
		return -E_EOF;
	return c;
  80302f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  803033:	eb 05                	jmp    80303a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  803035:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80303a:	c9                   	leave  
  80303b:	c3                   	ret    

0080303c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80303c:	55                   	push   %ebp
  80303d:	89 e5                	mov    %esp,%ebp
  80303f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803042:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803045:	89 44 24 04          	mov    %eax,0x4(%esp)
  803049:	8b 45 08             	mov    0x8(%ebp),%eax
  80304c:	89 04 24             	mov    %eax,(%esp)
  80304f:	e8 d2 ed ff ff       	call   801e26 <fd_lookup>
  803054:	85 c0                	test   %eax,%eax
  803056:	78 11                	js     803069 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  803058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  803061:	39 10                	cmp    %edx,(%eax)
  803063:	0f 94 c0             	sete   %al
  803066:	0f b6 c0             	movzbl %al,%eax
}
  803069:	c9                   	leave  
  80306a:	c3                   	ret    

0080306b <opencons>:

int
opencons(void)
{
  80306b:	55                   	push   %ebp
  80306c:	89 e5                	mov    %esp,%ebp
  80306e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803071:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803074:	89 04 24             	mov    %eax,(%esp)
  803077:	e8 5b ed ff ff       	call   801dd7 <fd_alloc>
		return r;
  80307c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80307e:	85 c0                	test   %eax,%eax
  803080:	78 40                	js     8030c2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803082:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803089:	00 
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803091:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803098:	e8 96 e4 ff ff       	call   801533 <sys_page_alloc>
		return r;
  80309d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80309f:	85 c0                	test   %eax,%eax
  8030a1:	78 1f                	js     8030c2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8030a3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8030ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8030b8:	89 04 24             	mov    %eax,(%esp)
  8030bb:	e8 f0 ec ff ff       	call   801db0 <fd2num>
  8030c0:	89 c2                	mov    %eax,%edx
}
  8030c2:	89 d0                	mov    %edx,%eax
  8030c4:	c9                   	leave  
  8030c5:	c3                   	ret    

008030c6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8030c6:	55                   	push   %ebp
  8030c7:	89 e5                	mov    %esp,%ebp
  8030c9:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8030cc:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8030d3:	75 68                	jne    80313d <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  8030d5:	a1 20 50 80 00       	mov    0x805020,%eax
  8030da:	8b 40 48             	mov    0x48(%eax),%eax
  8030dd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8030e4:	00 
  8030e5:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8030ec:	ee 
  8030ed:	89 04 24             	mov    %eax,(%esp)
  8030f0:	e8 3e e4 ff ff       	call   801533 <sys_page_alloc>
  8030f5:	85 c0                	test   %eax,%eax
  8030f7:	74 2c                	je     803125 <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  8030f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030fd:	c7 04 24 04 3c 80 00 	movl   $0x803c04,(%esp)
  803104:	e8 de d9 ff ff       	call   800ae7 <cprintf>
			panic("set_pg_fault_handler");
  803109:	c7 44 24 08 38 3c 80 	movl   $0x803c38,0x8(%esp)
  803110:	00 
  803111:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  803118:	00 
  803119:	c7 04 24 4d 3c 80 00 	movl   $0x803c4d,(%esp)
  803120:	e8 c9 d8 ff ff       	call   8009ee <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  803125:	a1 20 50 80 00       	mov    0x805020,%eax
  80312a:	8b 40 48             	mov    0x48(%eax),%eax
  80312d:	c7 44 24 04 47 31 80 	movl   $0x803147,0x4(%esp)
  803134:	00 
  803135:	89 04 24             	mov    %eax,(%esp)
  803138:	e8 96 e5 ff ff       	call   8016d3 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	a3 00 80 80 00       	mov    %eax,0x808000
}
  803145:	c9                   	leave  
  803146:	c3                   	ret    

00803147 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803147:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803148:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80314d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80314f:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  803152:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  803156:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  803158:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  80315c:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  80315d:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  803160:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  803162:	58                   	pop    %eax
	popl %eax
  803163:	58                   	pop    %eax
	popal
  803164:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  803165:	83 c4 04             	add    $0x4,%esp
	popfl
  803168:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803169:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80316a:	c3                   	ret    

0080316b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80316b:	55                   	push   %ebp
  80316c:	89 e5                	mov    %esp,%ebp
  80316e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803171:	89 d0                	mov    %edx,%eax
  803173:	c1 e8 16             	shr    $0x16,%eax
  803176:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80317d:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803182:	f6 c1 01             	test   $0x1,%cl
  803185:	74 1d                	je     8031a4 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  803187:	c1 ea 0c             	shr    $0xc,%edx
  80318a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803191:	f6 c2 01             	test   $0x1,%dl
  803194:	74 0e                	je     8031a4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803196:	c1 ea 0c             	shr    $0xc,%edx
  803199:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8031a0:	ef 
  8031a1:	0f b7 c0             	movzwl %ax,%eax
}
  8031a4:	5d                   	pop    %ebp
  8031a5:	c3                   	ret    
  8031a6:	66 90                	xchg   %ax,%ax
  8031a8:	66 90                	xchg   %ax,%ax
  8031aa:	66 90                	xchg   %ax,%ax
  8031ac:	66 90                	xchg   %ax,%ax
  8031ae:	66 90                	xchg   %ax,%ax

008031b0 <__udivdi3>:
  8031b0:	55                   	push   %ebp
  8031b1:	57                   	push   %edi
  8031b2:	56                   	push   %esi
  8031b3:	83 ec 0c             	sub    $0xc,%esp
  8031b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8031ba:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8031be:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8031c2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8031c6:	85 c0                	test   %eax,%eax
  8031c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8031cc:	89 ea                	mov    %ebp,%edx
  8031ce:	89 0c 24             	mov    %ecx,(%esp)
  8031d1:	75 2d                	jne    803200 <__udivdi3+0x50>
  8031d3:	39 e9                	cmp    %ebp,%ecx
  8031d5:	77 61                	ja     803238 <__udivdi3+0x88>
  8031d7:	85 c9                	test   %ecx,%ecx
  8031d9:	89 ce                	mov    %ecx,%esi
  8031db:	75 0b                	jne    8031e8 <__udivdi3+0x38>
  8031dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8031e2:	31 d2                	xor    %edx,%edx
  8031e4:	f7 f1                	div    %ecx
  8031e6:	89 c6                	mov    %eax,%esi
  8031e8:	31 d2                	xor    %edx,%edx
  8031ea:	89 e8                	mov    %ebp,%eax
  8031ec:	f7 f6                	div    %esi
  8031ee:	89 c5                	mov    %eax,%ebp
  8031f0:	89 f8                	mov    %edi,%eax
  8031f2:	f7 f6                	div    %esi
  8031f4:	89 ea                	mov    %ebp,%edx
  8031f6:	83 c4 0c             	add    $0xc,%esp
  8031f9:	5e                   	pop    %esi
  8031fa:	5f                   	pop    %edi
  8031fb:	5d                   	pop    %ebp
  8031fc:	c3                   	ret    
  8031fd:	8d 76 00             	lea    0x0(%esi),%esi
  803200:	39 e8                	cmp    %ebp,%eax
  803202:	77 24                	ja     803228 <__udivdi3+0x78>
  803204:	0f bd e8             	bsr    %eax,%ebp
  803207:	83 f5 1f             	xor    $0x1f,%ebp
  80320a:	75 3c                	jne    803248 <__udivdi3+0x98>
  80320c:	8b 74 24 04          	mov    0x4(%esp),%esi
  803210:	39 34 24             	cmp    %esi,(%esp)
  803213:	0f 86 9f 00 00 00    	jbe    8032b8 <__udivdi3+0x108>
  803219:	39 d0                	cmp    %edx,%eax
  80321b:	0f 82 97 00 00 00    	jb     8032b8 <__udivdi3+0x108>
  803221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803228:	31 d2                	xor    %edx,%edx
  80322a:	31 c0                	xor    %eax,%eax
  80322c:	83 c4 0c             	add    $0xc,%esp
  80322f:	5e                   	pop    %esi
  803230:	5f                   	pop    %edi
  803231:	5d                   	pop    %ebp
  803232:	c3                   	ret    
  803233:	90                   	nop
  803234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803238:	89 f8                	mov    %edi,%eax
  80323a:	f7 f1                	div    %ecx
  80323c:	31 d2                	xor    %edx,%edx
  80323e:	83 c4 0c             	add    $0xc,%esp
  803241:	5e                   	pop    %esi
  803242:	5f                   	pop    %edi
  803243:	5d                   	pop    %ebp
  803244:	c3                   	ret    
  803245:	8d 76 00             	lea    0x0(%esi),%esi
  803248:	89 e9                	mov    %ebp,%ecx
  80324a:	8b 3c 24             	mov    (%esp),%edi
  80324d:	d3 e0                	shl    %cl,%eax
  80324f:	89 c6                	mov    %eax,%esi
  803251:	b8 20 00 00 00       	mov    $0x20,%eax
  803256:	29 e8                	sub    %ebp,%eax
  803258:	89 c1                	mov    %eax,%ecx
  80325a:	d3 ef                	shr    %cl,%edi
  80325c:	89 e9                	mov    %ebp,%ecx
  80325e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803262:	8b 3c 24             	mov    (%esp),%edi
  803265:	09 74 24 08          	or     %esi,0x8(%esp)
  803269:	89 d6                	mov    %edx,%esi
  80326b:	d3 e7                	shl    %cl,%edi
  80326d:	89 c1                	mov    %eax,%ecx
  80326f:	89 3c 24             	mov    %edi,(%esp)
  803272:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803276:	d3 ee                	shr    %cl,%esi
  803278:	89 e9                	mov    %ebp,%ecx
  80327a:	d3 e2                	shl    %cl,%edx
  80327c:	89 c1                	mov    %eax,%ecx
  80327e:	d3 ef                	shr    %cl,%edi
  803280:	09 d7                	or     %edx,%edi
  803282:	89 f2                	mov    %esi,%edx
  803284:	89 f8                	mov    %edi,%eax
  803286:	f7 74 24 08          	divl   0x8(%esp)
  80328a:	89 d6                	mov    %edx,%esi
  80328c:	89 c7                	mov    %eax,%edi
  80328e:	f7 24 24             	mull   (%esp)
  803291:	39 d6                	cmp    %edx,%esi
  803293:	89 14 24             	mov    %edx,(%esp)
  803296:	72 30                	jb     8032c8 <__udivdi3+0x118>
  803298:	8b 54 24 04          	mov    0x4(%esp),%edx
  80329c:	89 e9                	mov    %ebp,%ecx
  80329e:	d3 e2                	shl    %cl,%edx
  8032a0:	39 c2                	cmp    %eax,%edx
  8032a2:	73 05                	jae    8032a9 <__udivdi3+0xf9>
  8032a4:	3b 34 24             	cmp    (%esp),%esi
  8032a7:	74 1f                	je     8032c8 <__udivdi3+0x118>
  8032a9:	89 f8                	mov    %edi,%eax
  8032ab:	31 d2                	xor    %edx,%edx
  8032ad:	e9 7a ff ff ff       	jmp    80322c <__udivdi3+0x7c>
  8032b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8032b8:	31 d2                	xor    %edx,%edx
  8032ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8032bf:	e9 68 ff ff ff       	jmp    80322c <__udivdi3+0x7c>
  8032c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8032c8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8032cb:	31 d2                	xor    %edx,%edx
  8032cd:	83 c4 0c             	add    $0xc,%esp
  8032d0:	5e                   	pop    %esi
  8032d1:	5f                   	pop    %edi
  8032d2:	5d                   	pop    %ebp
  8032d3:	c3                   	ret    
  8032d4:	66 90                	xchg   %ax,%ax
  8032d6:	66 90                	xchg   %ax,%ax
  8032d8:	66 90                	xchg   %ax,%ax
  8032da:	66 90                	xchg   %ax,%ax
  8032dc:	66 90                	xchg   %ax,%ax
  8032de:	66 90                	xchg   %ax,%ax

008032e0 <__umoddi3>:
  8032e0:	55                   	push   %ebp
  8032e1:	57                   	push   %edi
  8032e2:	56                   	push   %esi
  8032e3:	83 ec 14             	sub    $0x14,%esp
  8032e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8032ea:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8032ee:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8032f2:	89 c7                	mov    %eax,%edi
  8032f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032f8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8032fc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803300:	89 34 24             	mov    %esi,(%esp)
  803303:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803307:	85 c0                	test   %eax,%eax
  803309:	89 c2                	mov    %eax,%edx
  80330b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80330f:	75 17                	jne    803328 <__umoddi3+0x48>
  803311:	39 fe                	cmp    %edi,%esi
  803313:	76 4b                	jbe    803360 <__umoddi3+0x80>
  803315:	89 c8                	mov    %ecx,%eax
  803317:	89 fa                	mov    %edi,%edx
  803319:	f7 f6                	div    %esi
  80331b:	89 d0                	mov    %edx,%eax
  80331d:	31 d2                	xor    %edx,%edx
  80331f:	83 c4 14             	add    $0x14,%esp
  803322:	5e                   	pop    %esi
  803323:	5f                   	pop    %edi
  803324:	5d                   	pop    %ebp
  803325:	c3                   	ret    
  803326:	66 90                	xchg   %ax,%ax
  803328:	39 f8                	cmp    %edi,%eax
  80332a:	77 54                	ja     803380 <__umoddi3+0xa0>
  80332c:	0f bd e8             	bsr    %eax,%ebp
  80332f:	83 f5 1f             	xor    $0x1f,%ebp
  803332:	75 5c                	jne    803390 <__umoddi3+0xb0>
  803334:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803338:	39 3c 24             	cmp    %edi,(%esp)
  80333b:	0f 87 e7 00 00 00    	ja     803428 <__umoddi3+0x148>
  803341:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803345:	29 f1                	sub    %esi,%ecx
  803347:	19 c7                	sbb    %eax,%edi
  803349:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80334d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803351:	8b 44 24 08          	mov    0x8(%esp),%eax
  803355:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803359:	83 c4 14             	add    $0x14,%esp
  80335c:	5e                   	pop    %esi
  80335d:	5f                   	pop    %edi
  80335e:	5d                   	pop    %ebp
  80335f:	c3                   	ret    
  803360:	85 f6                	test   %esi,%esi
  803362:	89 f5                	mov    %esi,%ebp
  803364:	75 0b                	jne    803371 <__umoddi3+0x91>
  803366:	b8 01 00 00 00       	mov    $0x1,%eax
  80336b:	31 d2                	xor    %edx,%edx
  80336d:	f7 f6                	div    %esi
  80336f:	89 c5                	mov    %eax,%ebp
  803371:	8b 44 24 04          	mov    0x4(%esp),%eax
  803375:	31 d2                	xor    %edx,%edx
  803377:	f7 f5                	div    %ebp
  803379:	89 c8                	mov    %ecx,%eax
  80337b:	f7 f5                	div    %ebp
  80337d:	eb 9c                	jmp    80331b <__umoddi3+0x3b>
  80337f:	90                   	nop
  803380:	89 c8                	mov    %ecx,%eax
  803382:	89 fa                	mov    %edi,%edx
  803384:	83 c4 14             	add    $0x14,%esp
  803387:	5e                   	pop    %esi
  803388:	5f                   	pop    %edi
  803389:	5d                   	pop    %ebp
  80338a:	c3                   	ret    
  80338b:	90                   	nop
  80338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803390:	8b 04 24             	mov    (%esp),%eax
  803393:	be 20 00 00 00       	mov    $0x20,%esi
  803398:	89 e9                	mov    %ebp,%ecx
  80339a:	29 ee                	sub    %ebp,%esi
  80339c:	d3 e2                	shl    %cl,%edx
  80339e:	89 f1                	mov    %esi,%ecx
  8033a0:	d3 e8                	shr    %cl,%eax
  8033a2:	89 e9                	mov    %ebp,%ecx
  8033a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033a8:	8b 04 24             	mov    (%esp),%eax
  8033ab:	09 54 24 04          	or     %edx,0x4(%esp)
  8033af:	89 fa                	mov    %edi,%edx
  8033b1:	d3 e0                	shl    %cl,%eax
  8033b3:	89 f1                	mov    %esi,%ecx
  8033b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8033b9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8033bd:	d3 ea                	shr    %cl,%edx
  8033bf:	89 e9                	mov    %ebp,%ecx
  8033c1:	d3 e7                	shl    %cl,%edi
  8033c3:	89 f1                	mov    %esi,%ecx
  8033c5:	d3 e8                	shr    %cl,%eax
  8033c7:	89 e9                	mov    %ebp,%ecx
  8033c9:	09 f8                	or     %edi,%eax
  8033cb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8033cf:	f7 74 24 04          	divl   0x4(%esp)
  8033d3:	d3 e7                	shl    %cl,%edi
  8033d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033d9:	89 d7                	mov    %edx,%edi
  8033db:	f7 64 24 08          	mull   0x8(%esp)
  8033df:	39 d7                	cmp    %edx,%edi
  8033e1:	89 c1                	mov    %eax,%ecx
  8033e3:	89 14 24             	mov    %edx,(%esp)
  8033e6:	72 2c                	jb     803414 <__umoddi3+0x134>
  8033e8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8033ec:	72 22                	jb     803410 <__umoddi3+0x130>
  8033ee:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8033f2:	29 c8                	sub    %ecx,%eax
  8033f4:	19 d7                	sbb    %edx,%edi
  8033f6:	89 e9                	mov    %ebp,%ecx
  8033f8:	89 fa                	mov    %edi,%edx
  8033fa:	d3 e8                	shr    %cl,%eax
  8033fc:	89 f1                	mov    %esi,%ecx
  8033fe:	d3 e2                	shl    %cl,%edx
  803400:	89 e9                	mov    %ebp,%ecx
  803402:	d3 ef                	shr    %cl,%edi
  803404:	09 d0                	or     %edx,%eax
  803406:	89 fa                	mov    %edi,%edx
  803408:	83 c4 14             	add    $0x14,%esp
  80340b:	5e                   	pop    %esi
  80340c:	5f                   	pop    %edi
  80340d:	5d                   	pop    %ebp
  80340e:	c3                   	ret    
  80340f:	90                   	nop
  803410:	39 d7                	cmp    %edx,%edi
  803412:	75 da                	jne    8033ee <__umoddi3+0x10e>
  803414:	8b 14 24             	mov    (%esp),%edx
  803417:	89 c1                	mov    %eax,%ecx
  803419:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80341d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803421:	eb cb                	jmp    8033ee <__umoddi3+0x10e>
  803423:	90                   	nop
  803424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803428:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80342c:	0f 82 0f ff ff ff    	jb     803341 <__umoddi3+0x61>
  803432:	e9 1a ff ff ff       	jmp    803351 <__umoddi3+0x71>
