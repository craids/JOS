
obj/user/faultregs.debug:     file format elf32-i386


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
  80002c:	e8 6a 05 00 00       	call   80059b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	8b 45 08             	mov    0x8(%ebp),%eax
  800043:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800047:	89 54 24 08          	mov    %edx,0x8(%esp)
  80004b:	c7 44 24 04 71 2c 80 	movl   $0x802c71,0x4(%esp)
  800052:	00 
  800053:	c7 04 24 40 2c 80 00 	movl   $0x802c40,(%esp)
  80005a:	e8 96 06 00 00       	call   8006f5 <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  80005f:	8b 03                	mov    (%ebx),%eax
  800061:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800065:	8b 06                	mov    (%esi),%eax
  800067:	89 44 24 08          	mov    %eax,0x8(%esp)
  80006b:	c7 44 24 04 50 2c 80 	movl   $0x802c50,0x4(%esp)
  800072:	00 
  800073:	c7 04 24 54 2c 80 00 	movl   $0x802c54,(%esp)
  80007a:	e8 76 06 00 00       	call   8006f5 <cprintf>
  80007f:	8b 03                	mov    (%ebx),%eax
  800081:	39 06                	cmp    %eax,(%esi)
  800083:	75 13                	jne    800098 <check_regs+0x65>
  800085:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  80008c:	e8 64 06 00 00       	call   8006f5 <cprintf>

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
	int mismatch = 0;
  800091:	bf 00 00 00 00       	mov    $0x0,%edi
  800096:	eb 11                	jmp    8000a9 <check_regs+0x76>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800098:	c7 04 24 68 2c 80 00 	movl   $0x802c68,(%esp)
  80009f:	e8 51 06 00 00       	call   8006f5 <cprintf>
  8000a4:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  8000a9:	8b 43 04             	mov    0x4(%ebx),%eax
  8000ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b0:	8b 46 04             	mov    0x4(%esi),%eax
  8000b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000b7:	c7 44 24 04 72 2c 80 	movl   $0x802c72,0x4(%esp)
  8000be:	00 
  8000bf:	c7 04 24 54 2c 80 00 	movl   $0x802c54,(%esp)
  8000c6:	e8 2a 06 00 00       	call   8006f5 <cprintf>
  8000cb:	8b 43 04             	mov    0x4(%ebx),%eax
  8000ce:	39 46 04             	cmp    %eax,0x4(%esi)
  8000d1:	75 0e                	jne    8000e1 <check_regs+0xae>
  8000d3:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  8000da:	e8 16 06 00 00       	call   8006f5 <cprintf>
  8000df:	eb 11                	jmp    8000f2 <check_regs+0xbf>
  8000e1:	c7 04 24 68 2c 80 00 	movl   $0x802c68,(%esp)
  8000e8:	e8 08 06 00 00       	call   8006f5 <cprintf>
  8000ed:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000f2:	8b 43 08             	mov    0x8(%ebx),%eax
  8000f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f9:	8b 46 08             	mov    0x8(%esi),%eax
  8000fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800100:	c7 44 24 04 76 2c 80 	movl   $0x802c76,0x4(%esp)
  800107:	00 
  800108:	c7 04 24 54 2c 80 00 	movl   $0x802c54,(%esp)
  80010f:	e8 e1 05 00 00       	call   8006f5 <cprintf>
  800114:	8b 43 08             	mov    0x8(%ebx),%eax
  800117:	39 46 08             	cmp    %eax,0x8(%esi)
  80011a:	75 0e                	jne    80012a <check_regs+0xf7>
  80011c:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  800123:	e8 cd 05 00 00       	call   8006f5 <cprintf>
  800128:	eb 11                	jmp    80013b <check_regs+0x108>
  80012a:	c7 04 24 68 2c 80 00 	movl   $0x802c68,(%esp)
  800131:	e8 bf 05 00 00       	call   8006f5 <cprintf>
  800136:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  80013b:	8b 43 10             	mov    0x10(%ebx),%eax
  80013e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800142:	8b 46 10             	mov    0x10(%esi),%eax
  800145:	89 44 24 08          	mov    %eax,0x8(%esp)
  800149:	c7 44 24 04 7a 2c 80 	movl   $0x802c7a,0x4(%esp)
  800150:	00 
  800151:	c7 04 24 54 2c 80 00 	movl   $0x802c54,(%esp)
  800158:	e8 98 05 00 00       	call   8006f5 <cprintf>
  80015d:	8b 43 10             	mov    0x10(%ebx),%eax
  800160:	39 46 10             	cmp    %eax,0x10(%esi)
  800163:	75 0e                	jne    800173 <check_regs+0x140>
  800165:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  80016c:	e8 84 05 00 00       	call   8006f5 <cprintf>
  800171:	eb 11                	jmp    800184 <check_regs+0x151>
  800173:	c7 04 24 68 2c 80 00 	movl   $0x802c68,(%esp)
  80017a:	e8 76 05 00 00       	call   8006f5 <cprintf>
  80017f:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800184:	8b 43 14             	mov    0x14(%ebx),%eax
  800187:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80018b:	8b 46 14             	mov    0x14(%esi),%eax
  80018e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800192:	c7 44 24 04 7e 2c 80 	movl   $0x802c7e,0x4(%esp)
  800199:	00 
  80019a:	c7 04 24 54 2c 80 00 	movl   $0x802c54,(%esp)
  8001a1:	e8 4f 05 00 00       	call   8006f5 <cprintf>
  8001a6:	8b 43 14             	mov    0x14(%ebx),%eax
  8001a9:	39 46 14             	cmp    %eax,0x14(%esi)
  8001ac:	75 0e                	jne    8001bc <check_regs+0x189>
  8001ae:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  8001b5:	e8 3b 05 00 00       	call   8006f5 <cprintf>
  8001ba:	eb 11                	jmp    8001cd <check_regs+0x19a>
  8001bc:	c7 04 24 68 2c 80 00 	movl   $0x802c68,(%esp)
  8001c3:	e8 2d 05 00 00       	call   8006f5 <cprintf>
  8001c8:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  8001cd:	8b 43 18             	mov    0x18(%ebx),%eax
  8001d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001d4:	8b 46 18             	mov    0x18(%esi),%eax
  8001d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001db:	c7 44 24 04 82 2c 80 	movl   $0x802c82,0x4(%esp)
  8001e2:	00 
  8001e3:	c7 04 24 54 2c 80 00 	movl   $0x802c54,(%esp)
  8001ea:	e8 06 05 00 00       	call   8006f5 <cprintf>
  8001ef:	8b 43 18             	mov    0x18(%ebx),%eax
  8001f2:	39 46 18             	cmp    %eax,0x18(%esi)
  8001f5:	75 0e                	jne    800205 <check_regs+0x1d2>
  8001f7:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  8001fe:	e8 f2 04 00 00       	call   8006f5 <cprintf>
  800203:	eb 11                	jmp    800216 <check_regs+0x1e3>
  800205:	c7 04 24 68 2c 80 00 	movl   $0x802c68,(%esp)
  80020c:	e8 e4 04 00 00       	call   8006f5 <cprintf>
  800211:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  800216:	8b 43 1c             	mov    0x1c(%ebx),%eax
  800219:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80021d:	8b 46 1c             	mov    0x1c(%esi),%eax
  800220:	89 44 24 08          	mov    %eax,0x8(%esp)
  800224:	c7 44 24 04 86 2c 80 	movl   $0x802c86,0x4(%esp)
  80022b:	00 
  80022c:	c7 04 24 54 2c 80 00 	movl   $0x802c54,(%esp)
  800233:	e8 bd 04 00 00       	call   8006f5 <cprintf>
  800238:	8b 43 1c             	mov    0x1c(%ebx),%eax
  80023b:	39 46 1c             	cmp    %eax,0x1c(%esi)
  80023e:	75 0e                	jne    80024e <check_regs+0x21b>
  800240:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  800247:	e8 a9 04 00 00       	call   8006f5 <cprintf>
  80024c:	eb 11                	jmp    80025f <check_regs+0x22c>
  80024e:	c7 04 24 68 2c 80 00 	movl   $0x802c68,(%esp)
  800255:	e8 9b 04 00 00       	call   8006f5 <cprintf>
  80025a:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  80025f:	8b 43 20             	mov    0x20(%ebx),%eax
  800262:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800266:	8b 46 20             	mov    0x20(%esi),%eax
  800269:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026d:	c7 44 24 04 8a 2c 80 	movl   $0x802c8a,0x4(%esp)
  800274:	00 
  800275:	c7 04 24 54 2c 80 00 	movl   $0x802c54,(%esp)
  80027c:	e8 74 04 00 00       	call   8006f5 <cprintf>
  800281:	8b 43 20             	mov    0x20(%ebx),%eax
  800284:	39 46 20             	cmp    %eax,0x20(%esi)
  800287:	75 0e                	jne    800297 <check_regs+0x264>
  800289:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  800290:	e8 60 04 00 00       	call   8006f5 <cprintf>
  800295:	eb 11                	jmp    8002a8 <check_regs+0x275>
  800297:	c7 04 24 68 2c 80 00 	movl   $0x802c68,(%esp)
  80029e:	e8 52 04 00 00       	call   8006f5 <cprintf>
  8002a3:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  8002a8:	8b 43 24             	mov    0x24(%ebx),%eax
  8002ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002af:	8b 46 24             	mov    0x24(%esi),%eax
  8002b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b6:	c7 44 24 04 8e 2c 80 	movl   $0x802c8e,0x4(%esp)
  8002bd:	00 
  8002be:	c7 04 24 54 2c 80 00 	movl   $0x802c54,(%esp)
  8002c5:	e8 2b 04 00 00       	call   8006f5 <cprintf>
  8002ca:	8b 43 24             	mov    0x24(%ebx),%eax
  8002cd:	39 46 24             	cmp    %eax,0x24(%esi)
  8002d0:	75 0e                	jne    8002e0 <check_regs+0x2ad>
  8002d2:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  8002d9:	e8 17 04 00 00       	call   8006f5 <cprintf>
  8002de:	eb 11                	jmp    8002f1 <check_regs+0x2be>
  8002e0:	c7 04 24 68 2c 80 00 	movl   $0x802c68,(%esp)
  8002e7:	e8 09 04 00 00       	call   8006f5 <cprintf>
  8002ec:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esp, esp);
  8002f1:	8b 43 28             	mov    0x28(%ebx),%eax
  8002f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002f8:	8b 46 28             	mov    0x28(%esi),%eax
  8002fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ff:	c7 44 24 04 95 2c 80 	movl   $0x802c95,0x4(%esp)
  800306:	00 
  800307:	c7 04 24 54 2c 80 00 	movl   $0x802c54,(%esp)
  80030e:	e8 e2 03 00 00       	call   8006f5 <cprintf>
  800313:	8b 43 28             	mov    0x28(%ebx),%eax
  800316:	39 46 28             	cmp    %eax,0x28(%esi)
  800319:	75 25                	jne    800340 <check_regs+0x30d>
  80031b:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  800322:	e8 ce 03 00 00       	call   8006f5 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032e:	c7 04 24 99 2c 80 00 	movl   $0x802c99,(%esp)
  800335:	e8 bb 03 00 00       	call   8006f5 <cprintf>
	if (!mismatch)
  80033a:	85 ff                	test   %edi,%edi
  80033c:	74 23                	je     800361 <check_regs+0x32e>
  80033e:	eb 2f                	jmp    80036f <check_regs+0x33c>
	CHECK(edx, regs.reg_edx);
	CHECK(ecx, regs.reg_ecx);
	CHECK(eax, regs.reg_eax);
	CHECK(eip, eip);
	CHECK(eflags, eflags);
	CHECK(esp, esp);
  800340:	c7 04 24 68 2c 80 00 	movl   $0x802c68,(%esp)
  800347:	e8 a9 03 00 00       	call   8006f5 <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  80034c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800353:	c7 04 24 99 2c 80 00 	movl   $0x802c99,(%esp)
  80035a:	e8 96 03 00 00       	call   8006f5 <cprintf>
  80035f:	eb 0e                	jmp    80036f <check_regs+0x33c>
	if (!mismatch)
		cprintf("OK\n");
  800361:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  800368:	e8 88 03 00 00       	call   8006f5 <cprintf>
  80036d:	eb 0c                	jmp    80037b <check_regs+0x348>
	else
		cprintf("MISMATCH\n");
  80036f:	c7 04 24 68 2c 80 00 	movl   $0x802c68,(%esp)
  800376:	e8 7a 03 00 00       	call   8006f5 <cprintf>
}
  80037b:	83 c4 1c             	add    $0x1c,%esp
  80037e:	5b                   	pop    %ebx
  80037f:	5e                   	pop    %esi
  800380:	5f                   	pop    %edi
  800381:	5d                   	pop    %ebp
  800382:	c3                   	ret    

00800383 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	83 ec 28             	sub    $0x28,%esp
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  80038c:	8b 10                	mov    (%eax),%edx
  80038e:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  800394:	74 27                	je     8003bd <pgfault+0x3a>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  800396:	8b 40 28             	mov    0x28(%eax),%eax
  800399:	89 44 24 10          	mov    %eax,0x10(%esp)
  80039d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003a1:	c7 44 24 08 00 2d 80 	movl   $0x802d00,0x8(%esp)
  8003a8:	00 
  8003a9:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
  8003b0:	00 
  8003b1:	c7 04 24 a7 2c 80 00 	movl   $0x802ca7,(%esp)
  8003b8:	e8 3f 02 00 00       	call   8005fc <_panic>
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003bd:	8b 50 08             	mov    0x8(%eax),%edx
  8003c0:	89 15 40 50 80 00    	mov    %edx,0x805040
  8003c6:	8b 50 0c             	mov    0xc(%eax),%edx
  8003c9:	89 15 44 50 80 00    	mov    %edx,0x805044
  8003cf:	8b 50 10             	mov    0x10(%eax),%edx
  8003d2:	89 15 48 50 80 00    	mov    %edx,0x805048
  8003d8:	8b 50 14             	mov    0x14(%eax),%edx
  8003db:	89 15 4c 50 80 00    	mov    %edx,0x80504c
  8003e1:	8b 50 18             	mov    0x18(%eax),%edx
  8003e4:	89 15 50 50 80 00    	mov    %edx,0x805050
  8003ea:	8b 50 1c             	mov    0x1c(%eax),%edx
  8003ed:	89 15 54 50 80 00    	mov    %edx,0x805054
  8003f3:	8b 50 20             	mov    0x20(%eax),%edx
  8003f6:	89 15 58 50 80 00    	mov    %edx,0x805058
  8003fc:	8b 50 24             	mov    0x24(%eax),%edx
  8003ff:	89 15 5c 50 80 00    	mov    %edx,0x80505c
	during.eip = utf->utf_eip;
  800405:	8b 50 28             	mov    0x28(%eax),%edx
  800408:	89 15 60 50 80 00    	mov    %edx,0x805060
	during.eflags = utf->utf_eflags & ~FL_RF;
  80040e:	8b 50 2c             	mov    0x2c(%eax),%edx
  800411:	81 e2 ff ff fe ff    	and    $0xfffeffff,%edx
  800417:	89 15 64 50 80 00    	mov    %edx,0x805064
	during.esp = utf->utf_esp;
  80041d:	8b 40 30             	mov    0x30(%eax),%eax
  800420:	a3 68 50 80 00       	mov    %eax,0x805068
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800425:	c7 44 24 04 bf 2c 80 	movl   $0x802cbf,0x4(%esp)
  80042c:	00 
  80042d:	c7 04 24 cd 2c 80 00 	movl   $0x802ccd,(%esp)
  800434:	b9 40 50 80 00       	mov    $0x805040,%ecx
  800439:	ba b8 2c 80 00       	mov    $0x802cb8,%edx
  80043e:	b8 80 50 80 00       	mov    $0x805080,%eax
  800443:	e8 eb fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800448:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80044f:	00 
  800450:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  800457:	00 
  800458:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80045f:	e8 cf 0c 00 00       	call   801133 <sys_page_alloc>
  800464:	85 c0                	test   %eax,%eax
  800466:	79 20                	jns    800488 <pgfault+0x105>
		panic("sys_page_alloc: %e", r);
  800468:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80046c:	c7 44 24 08 d4 2c 80 	movl   $0x802cd4,0x8(%esp)
  800473:	00 
  800474:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  80047b:	00 
  80047c:	c7 04 24 a7 2c 80 00 	movl   $0x802ca7,(%esp)
  800483:	e8 74 01 00 00       	call   8005fc <_panic>
}
  800488:	c9                   	leave  
  800489:	c3                   	ret    

0080048a <umain>:

void
umain(int argc, char **argv)
{
  80048a:	55                   	push   %ebp
  80048b:	89 e5                	mov    %esp,%ebp
  80048d:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(pgfault);
  800490:	c7 04 24 83 03 80 00 	movl   $0x800383,(%esp)
  800497:	e8 d5 0f 00 00       	call   801471 <set_pgfault_handler>

	asm volatile(
  80049c:	50                   	push   %eax
  80049d:	9c                   	pushf  
  80049e:	58                   	pop    %eax
  80049f:	0d d5 08 00 00       	or     $0x8d5,%eax
  8004a4:	50                   	push   %eax
  8004a5:	9d                   	popf   
  8004a6:	a3 a4 50 80 00       	mov    %eax,0x8050a4
  8004ab:	8d 05 e6 04 80 00    	lea    0x8004e6,%eax
  8004b1:	a3 a0 50 80 00       	mov    %eax,0x8050a0
  8004b6:	58                   	pop    %eax
  8004b7:	89 3d 80 50 80 00    	mov    %edi,0x805080
  8004bd:	89 35 84 50 80 00    	mov    %esi,0x805084
  8004c3:	89 2d 88 50 80 00    	mov    %ebp,0x805088
  8004c9:	89 1d 90 50 80 00    	mov    %ebx,0x805090
  8004cf:	89 15 94 50 80 00    	mov    %edx,0x805094
  8004d5:	89 0d 98 50 80 00    	mov    %ecx,0x805098
  8004db:	a3 9c 50 80 00       	mov    %eax,0x80509c
  8004e0:	89 25 a8 50 80 00    	mov    %esp,0x8050a8
  8004e6:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  8004ed:	00 00 00 
  8004f0:	89 3d 00 50 80 00    	mov    %edi,0x805000
  8004f6:	89 35 04 50 80 00    	mov    %esi,0x805004
  8004fc:	89 2d 08 50 80 00    	mov    %ebp,0x805008
  800502:	89 1d 10 50 80 00    	mov    %ebx,0x805010
  800508:	89 15 14 50 80 00    	mov    %edx,0x805014
  80050e:	89 0d 18 50 80 00    	mov    %ecx,0x805018
  800514:	a3 1c 50 80 00       	mov    %eax,0x80501c
  800519:	89 25 28 50 80 00    	mov    %esp,0x805028
  80051f:	8b 3d 80 50 80 00    	mov    0x805080,%edi
  800525:	8b 35 84 50 80 00    	mov    0x805084,%esi
  80052b:	8b 2d 88 50 80 00    	mov    0x805088,%ebp
  800531:	8b 1d 90 50 80 00    	mov    0x805090,%ebx
  800537:	8b 15 94 50 80 00    	mov    0x805094,%edx
  80053d:	8b 0d 98 50 80 00    	mov    0x805098,%ecx
  800543:	a1 9c 50 80 00       	mov    0x80509c,%eax
  800548:	8b 25 a8 50 80 00    	mov    0x8050a8,%esp
  80054e:	50                   	push   %eax
  80054f:	9c                   	pushf  
  800550:	58                   	pop    %eax
  800551:	a3 24 50 80 00       	mov    %eax,0x805024
  800556:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  800557:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  80055e:	74 0c                	je     80056c <umain+0xe2>
		cprintf("EIP after page-fault MISMATCH\n");
  800560:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  800567:	e8 89 01 00 00       	call   8006f5 <cprintf>
	after.eip = before.eip;
  80056c:	a1 a0 50 80 00       	mov    0x8050a0,%eax
  800571:	a3 20 50 80 00       	mov    %eax,0x805020

	check_regs(&before, "before", &after, "after", "after page-fault");
  800576:	c7 44 24 04 e7 2c 80 	movl   $0x802ce7,0x4(%esp)
  80057d:	00 
  80057e:	c7 04 24 f8 2c 80 00 	movl   $0x802cf8,(%esp)
  800585:	b9 00 50 80 00       	mov    $0x805000,%ecx
  80058a:	ba b8 2c 80 00       	mov    $0x802cb8,%edx
  80058f:	b8 80 50 80 00       	mov    $0x805080,%eax
  800594:	e8 9a fa ff ff       	call   800033 <check_regs>
}
  800599:	c9                   	leave  
  80059a:	c3                   	ret    

0080059b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80059b:	55                   	push   %ebp
  80059c:	89 e5                	mov    %esp,%ebp
  80059e:	56                   	push   %esi
  80059f:	53                   	push   %ebx
  8005a0:	83 ec 10             	sub    $0x10,%esp
  8005a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005a6:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8005a9:	e8 47 0b 00 00       	call   8010f5 <sys_getenvid>
  8005ae:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005b3:	c1 e0 07             	shl    $0x7,%eax
  8005b6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005bb:	a3 b4 50 80 00       	mov    %eax,0x8050b4

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005c0:	85 db                	test   %ebx,%ebx
  8005c2:	7e 07                	jle    8005cb <libmain+0x30>
		binaryname = argv[0];
  8005c4:	8b 06                	mov    (%esi),%eax
  8005c6:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8005cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005cf:	89 1c 24             	mov    %ebx,(%esp)
  8005d2:	e8 b3 fe ff ff       	call   80048a <umain>

	// exit gracefully
	exit();
  8005d7:	e8 07 00 00 00       	call   8005e3 <exit>
}
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	5b                   	pop    %ebx
  8005e0:	5e                   	pop    %esi
  8005e1:	5d                   	pop    %ebp
  8005e2:	c3                   	ret    

008005e3 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005e3:	55                   	push   %ebp
  8005e4:	89 e5                	mov    %esp,%ebp
  8005e6:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8005e9:	e8 0c 11 00 00       	call   8016fa <close_all>
	sys_env_destroy(0);
  8005ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005f5:	e8 a9 0a 00 00       	call   8010a3 <sys_env_destroy>
}
  8005fa:	c9                   	leave  
  8005fb:	c3                   	ret    

008005fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005fc:	55                   	push   %ebp
  8005fd:	89 e5                	mov    %esp,%ebp
  8005ff:	56                   	push   %esi
  800600:	53                   	push   %ebx
  800601:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800604:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800607:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80060d:	e8 e3 0a 00 00       	call   8010f5 <sys_getenvid>
  800612:	8b 55 0c             	mov    0xc(%ebp),%edx
  800615:	89 54 24 10          	mov    %edx,0x10(%esp)
  800619:	8b 55 08             	mov    0x8(%ebp),%edx
  80061c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800620:	89 74 24 08          	mov    %esi,0x8(%esp)
  800624:	89 44 24 04          	mov    %eax,0x4(%esp)
  800628:	c7 04 24 60 2d 80 00 	movl   $0x802d60,(%esp)
  80062f:	e8 c1 00 00 00       	call   8006f5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800634:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800638:	8b 45 10             	mov    0x10(%ebp),%eax
  80063b:	89 04 24             	mov    %eax,(%esp)
  80063e:	e8 51 00 00 00       	call   800694 <vcprintf>
	cprintf("\n");
  800643:	c7 04 24 70 2c 80 00 	movl   $0x802c70,(%esp)
  80064a:	e8 a6 00 00 00       	call   8006f5 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80064f:	cc                   	int3   
  800650:	eb fd                	jmp    80064f <_panic+0x53>

00800652 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800652:	55                   	push   %ebp
  800653:	89 e5                	mov    %esp,%ebp
  800655:	53                   	push   %ebx
  800656:	83 ec 14             	sub    $0x14,%esp
  800659:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80065c:	8b 13                	mov    (%ebx),%edx
  80065e:	8d 42 01             	lea    0x1(%edx),%eax
  800661:	89 03                	mov    %eax,(%ebx)
  800663:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800666:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80066a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80066f:	75 19                	jne    80068a <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800671:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800678:	00 
  800679:	8d 43 08             	lea    0x8(%ebx),%eax
  80067c:	89 04 24             	mov    %eax,(%esp)
  80067f:	e8 e2 09 00 00       	call   801066 <sys_cputs>
		b->idx = 0;
  800684:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80068a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80068e:	83 c4 14             	add    $0x14,%esp
  800691:	5b                   	pop    %ebx
  800692:	5d                   	pop    %ebp
  800693:	c3                   	ret    

00800694 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800694:	55                   	push   %ebp
  800695:	89 e5                	mov    %esp,%ebp
  800697:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80069d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006a4:	00 00 00 
	b.cnt = 0;
  8006a7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006ae:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006bf:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006c9:	c7 04 24 52 06 80 00 	movl   $0x800652,(%esp)
  8006d0:	e8 a9 01 00 00       	call   80087e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006d5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8006db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006df:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8006e5:	89 04 24             	mov    %eax,(%esp)
  8006e8:	e8 79 09 00 00       	call   801066 <sys_cputs>

	return b.cnt;
}
  8006ed:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8006f3:	c9                   	leave  
  8006f4:	c3                   	ret    

008006f5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006f5:	55                   	push   %ebp
  8006f6:	89 e5                	mov    %esp,%ebp
  8006f8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006fb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8006fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	89 04 24             	mov    %eax,(%esp)
  800708:	e8 87 ff ff ff       	call   800694 <vcprintf>
	va_end(ap);

	return cnt;
}
  80070d:	c9                   	leave  
  80070e:	c3                   	ret    
  80070f:	90                   	nop

00800710 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	57                   	push   %edi
  800714:	56                   	push   %esi
  800715:	53                   	push   %ebx
  800716:	83 ec 3c             	sub    $0x3c,%esp
  800719:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80071c:	89 d7                	mov    %edx,%edi
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800724:	8b 45 0c             	mov    0xc(%ebp),%eax
  800727:	89 c3                	mov    %eax,%ebx
  800729:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80072c:	8b 45 10             	mov    0x10(%ebp),%eax
  80072f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800732:	b9 00 00 00 00       	mov    $0x0,%ecx
  800737:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80073d:	39 d9                	cmp    %ebx,%ecx
  80073f:	72 05                	jb     800746 <printnum+0x36>
  800741:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800744:	77 69                	ja     8007af <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800746:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800749:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80074d:	83 ee 01             	sub    $0x1,%esi
  800750:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800754:	89 44 24 08          	mov    %eax,0x8(%esp)
  800758:	8b 44 24 08          	mov    0x8(%esp),%eax
  80075c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800760:	89 c3                	mov    %eax,%ebx
  800762:	89 d6                	mov    %edx,%esi
  800764:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800767:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80076a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80076e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800772:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800775:	89 04 24             	mov    %eax,(%esp)
  800778:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80077b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80077f:	e8 2c 22 00 00       	call   8029b0 <__udivdi3>
  800784:	89 d9                	mov    %ebx,%ecx
  800786:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80078a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80078e:	89 04 24             	mov    %eax,(%esp)
  800791:	89 54 24 04          	mov    %edx,0x4(%esp)
  800795:	89 fa                	mov    %edi,%edx
  800797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80079a:	e8 71 ff ff ff       	call   800710 <printnum>
  80079f:	eb 1b                	jmp    8007bc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007a1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007a5:	8b 45 18             	mov    0x18(%ebp),%eax
  8007a8:	89 04 24             	mov    %eax,(%esp)
  8007ab:	ff d3                	call   *%ebx
  8007ad:	eb 03                	jmp    8007b2 <printnum+0xa2>
  8007af:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b2:	83 ee 01             	sub    $0x1,%esi
  8007b5:	85 f6                	test   %esi,%esi
  8007b7:	7f e8                	jg     8007a1 <printnum+0x91>
  8007b9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007bc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007c0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8007c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007ce:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007d5:	89 04 24             	mov    %eax,(%esp)
  8007d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007df:	e8 fc 22 00 00       	call   802ae0 <__umoddi3>
  8007e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e8:	0f be 80 83 2d 80 00 	movsbl 0x802d83(%eax),%eax
  8007ef:	89 04 24             	mov    %eax,(%esp)
  8007f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007f5:	ff d0                	call   *%eax
}
  8007f7:	83 c4 3c             	add    $0x3c,%esp
  8007fa:	5b                   	pop    %ebx
  8007fb:	5e                   	pop    %esi
  8007fc:	5f                   	pop    %edi
  8007fd:	5d                   	pop    %ebp
  8007fe:	c3                   	ret    

008007ff <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800802:	83 fa 01             	cmp    $0x1,%edx
  800805:	7e 0e                	jle    800815 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800807:	8b 10                	mov    (%eax),%edx
  800809:	8d 4a 08             	lea    0x8(%edx),%ecx
  80080c:	89 08                	mov    %ecx,(%eax)
  80080e:	8b 02                	mov    (%edx),%eax
  800810:	8b 52 04             	mov    0x4(%edx),%edx
  800813:	eb 22                	jmp    800837 <getuint+0x38>
	else if (lflag)
  800815:	85 d2                	test   %edx,%edx
  800817:	74 10                	je     800829 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800819:	8b 10                	mov    (%eax),%edx
  80081b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80081e:	89 08                	mov    %ecx,(%eax)
  800820:	8b 02                	mov    (%edx),%eax
  800822:	ba 00 00 00 00       	mov    $0x0,%edx
  800827:	eb 0e                	jmp    800837 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800829:	8b 10                	mov    (%eax),%edx
  80082b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80082e:	89 08                	mov    %ecx,(%eax)
  800830:	8b 02                	mov    (%edx),%eax
  800832:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800837:	5d                   	pop    %ebp
  800838:	c3                   	ret    

00800839 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800839:	55                   	push   %ebp
  80083a:	89 e5                	mov    %esp,%ebp
  80083c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80083f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800843:	8b 10                	mov    (%eax),%edx
  800845:	3b 50 04             	cmp    0x4(%eax),%edx
  800848:	73 0a                	jae    800854 <sprintputch+0x1b>
		*b->buf++ = ch;
  80084a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80084d:	89 08                	mov    %ecx,(%eax)
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	88 02                	mov    %al,(%edx)
}
  800854:	5d                   	pop    %ebp
  800855:	c3                   	ret    

00800856 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
  800859:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80085c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80085f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800863:	8b 45 10             	mov    0x10(%ebp),%eax
  800866:	89 44 24 08          	mov    %eax,0x8(%esp)
  80086a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	89 04 24             	mov    %eax,(%esp)
  800877:	e8 02 00 00 00       	call   80087e <vprintfmt>
	va_end(ap);
}
  80087c:	c9                   	leave  
  80087d:	c3                   	ret    

0080087e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	57                   	push   %edi
  800882:	56                   	push   %esi
  800883:	53                   	push   %ebx
  800884:	83 ec 3c             	sub    $0x3c,%esp
  800887:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80088a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80088d:	eb 14                	jmp    8008a3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80088f:	85 c0                	test   %eax,%eax
  800891:	0f 84 b3 03 00 00    	je     800c4a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800897:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80089b:	89 04 24             	mov    %eax,(%esp)
  80089e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a1:	89 f3                	mov    %esi,%ebx
  8008a3:	8d 73 01             	lea    0x1(%ebx),%esi
  8008a6:	0f b6 03             	movzbl (%ebx),%eax
  8008a9:	83 f8 25             	cmp    $0x25,%eax
  8008ac:	75 e1                	jne    80088f <vprintfmt+0x11>
  8008ae:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8008b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008b9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8008c0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8008c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8008cc:	eb 1d                	jmp    8008eb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ce:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8008d0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8008d4:	eb 15                	jmp    8008eb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008d8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8008dc:	eb 0d                	jmp    8008eb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8008de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008e4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008eb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8008ee:	0f b6 0e             	movzbl (%esi),%ecx
  8008f1:	0f b6 c1             	movzbl %cl,%eax
  8008f4:	83 e9 23             	sub    $0x23,%ecx
  8008f7:	80 f9 55             	cmp    $0x55,%cl
  8008fa:	0f 87 2a 03 00 00    	ja     800c2a <vprintfmt+0x3ac>
  800900:	0f b6 c9             	movzbl %cl,%ecx
  800903:	ff 24 8d c0 2e 80 00 	jmp    *0x802ec0(,%ecx,4)
  80090a:	89 de                	mov    %ebx,%esi
  80090c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800911:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800914:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800918:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80091b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80091e:	83 fb 09             	cmp    $0x9,%ebx
  800921:	77 36                	ja     800959 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800923:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800926:	eb e9                	jmp    800911 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800928:	8b 45 14             	mov    0x14(%ebp),%eax
  80092b:	8d 48 04             	lea    0x4(%eax),%ecx
  80092e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800931:	8b 00                	mov    (%eax),%eax
  800933:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800936:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800938:	eb 22                	jmp    80095c <vprintfmt+0xde>
  80093a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80093d:	85 c9                	test   %ecx,%ecx
  80093f:	b8 00 00 00 00       	mov    $0x0,%eax
  800944:	0f 49 c1             	cmovns %ecx,%eax
  800947:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80094a:	89 de                	mov    %ebx,%esi
  80094c:	eb 9d                	jmp    8008eb <vprintfmt+0x6d>
  80094e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800950:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800957:	eb 92                	jmp    8008eb <vprintfmt+0x6d>
  800959:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80095c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800960:	79 89                	jns    8008eb <vprintfmt+0x6d>
  800962:	e9 77 ff ff ff       	jmp    8008de <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800967:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80096c:	e9 7a ff ff ff       	jmp    8008eb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800971:	8b 45 14             	mov    0x14(%ebp),%eax
  800974:	8d 50 04             	lea    0x4(%eax),%edx
  800977:	89 55 14             	mov    %edx,0x14(%ebp)
  80097a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80097e:	8b 00                	mov    (%eax),%eax
  800980:	89 04 24             	mov    %eax,(%esp)
  800983:	ff 55 08             	call   *0x8(%ebp)
			break;
  800986:	e9 18 ff ff ff       	jmp    8008a3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80098b:	8b 45 14             	mov    0x14(%ebp),%eax
  80098e:	8d 50 04             	lea    0x4(%eax),%edx
  800991:	89 55 14             	mov    %edx,0x14(%ebp)
  800994:	8b 00                	mov    (%eax),%eax
  800996:	99                   	cltd   
  800997:	31 d0                	xor    %edx,%eax
  800999:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80099b:	83 f8 11             	cmp    $0x11,%eax
  80099e:	7f 0b                	jg     8009ab <vprintfmt+0x12d>
  8009a0:	8b 14 85 20 30 80 00 	mov    0x803020(,%eax,4),%edx
  8009a7:	85 d2                	test   %edx,%edx
  8009a9:	75 20                	jne    8009cb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8009ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009af:	c7 44 24 08 9b 2d 80 	movl   $0x802d9b,0x8(%esp)
  8009b6:	00 
  8009b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	89 04 24             	mov    %eax,(%esp)
  8009c1:	e8 90 fe ff ff       	call   800856 <printfmt>
  8009c6:	e9 d8 fe ff ff       	jmp    8008a3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8009cb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009cf:	c7 44 24 08 b9 31 80 	movl   $0x8031b9,0x8(%esp)
  8009d6:	00 
  8009d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	89 04 24             	mov    %eax,(%esp)
  8009e1:	e8 70 fe ff ff       	call   800856 <printfmt>
  8009e6:	e9 b8 fe ff ff       	jmp    8008a3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009eb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8009ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f7:	8d 50 04             	lea    0x4(%eax),%edx
  8009fa:	89 55 14             	mov    %edx,0x14(%ebp)
  8009fd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8009ff:	85 f6                	test   %esi,%esi
  800a01:	b8 94 2d 80 00       	mov    $0x802d94,%eax
  800a06:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800a09:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800a0d:	0f 84 97 00 00 00    	je     800aaa <vprintfmt+0x22c>
  800a13:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800a17:	0f 8e 9b 00 00 00    	jle    800ab8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a1d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a21:	89 34 24             	mov    %esi,(%esp)
  800a24:	e8 cf 02 00 00       	call   800cf8 <strnlen>
  800a29:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800a2c:	29 c2                	sub    %eax,%edx
  800a2e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800a31:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800a35:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a38:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800a3b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a3e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a41:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a43:	eb 0f                	jmp    800a54 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800a45:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a4c:	89 04 24             	mov    %eax,(%esp)
  800a4f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a51:	83 eb 01             	sub    $0x1,%ebx
  800a54:	85 db                	test   %ebx,%ebx
  800a56:	7f ed                	jg     800a45 <vprintfmt+0x1c7>
  800a58:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800a5b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800a5e:	85 d2                	test   %edx,%edx
  800a60:	b8 00 00 00 00       	mov    $0x0,%eax
  800a65:	0f 49 c2             	cmovns %edx,%eax
  800a68:	29 c2                	sub    %eax,%edx
  800a6a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800a6d:	89 d7                	mov    %edx,%edi
  800a6f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a72:	eb 50                	jmp    800ac4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a74:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a78:	74 1e                	je     800a98 <vprintfmt+0x21a>
  800a7a:	0f be d2             	movsbl %dl,%edx
  800a7d:	83 ea 20             	sub    $0x20,%edx
  800a80:	83 fa 5e             	cmp    $0x5e,%edx
  800a83:	76 13                	jbe    800a98 <vprintfmt+0x21a>
					putch('?', putdat);
  800a85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a88:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a8c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800a93:	ff 55 08             	call   *0x8(%ebp)
  800a96:	eb 0d                	jmp    800aa5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a9f:	89 04 24             	mov    %eax,(%esp)
  800aa2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa5:	83 ef 01             	sub    $0x1,%edi
  800aa8:	eb 1a                	jmp    800ac4 <vprintfmt+0x246>
  800aaa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800aad:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800ab0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ab3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ab6:	eb 0c                	jmp    800ac4 <vprintfmt+0x246>
  800ab8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800abb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800abe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800ac1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ac4:	83 c6 01             	add    $0x1,%esi
  800ac7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800acb:	0f be c2             	movsbl %dl,%eax
  800ace:	85 c0                	test   %eax,%eax
  800ad0:	74 27                	je     800af9 <vprintfmt+0x27b>
  800ad2:	85 db                	test   %ebx,%ebx
  800ad4:	78 9e                	js     800a74 <vprintfmt+0x1f6>
  800ad6:	83 eb 01             	sub    $0x1,%ebx
  800ad9:	79 99                	jns    800a74 <vprintfmt+0x1f6>
  800adb:	89 f8                	mov    %edi,%eax
  800add:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800ae0:	8b 75 08             	mov    0x8(%ebp),%esi
  800ae3:	89 c3                	mov    %eax,%ebx
  800ae5:	eb 1a                	jmp    800b01 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800ae7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800aeb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800af2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800af4:	83 eb 01             	sub    $0x1,%ebx
  800af7:	eb 08                	jmp    800b01 <vprintfmt+0x283>
  800af9:	89 fb                	mov    %edi,%ebx
  800afb:	8b 75 08             	mov    0x8(%ebp),%esi
  800afe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800b01:	85 db                	test   %ebx,%ebx
  800b03:	7f e2                	jg     800ae7 <vprintfmt+0x269>
  800b05:	89 75 08             	mov    %esi,0x8(%ebp)
  800b08:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b0b:	e9 93 fd ff ff       	jmp    8008a3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800b10:	83 fa 01             	cmp    $0x1,%edx
  800b13:	7e 16                	jle    800b2b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	8d 50 08             	lea    0x8(%eax),%edx
  800b1b:	89 55 14             	mov    %edx,0x14(%ebp)
  800b1e:	8b 50 04             	mov    0x4(%eax),%edx
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b26:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b29:	eb 32                	jmp    800b5d <vprintfmt+0x2df>
	else if (lflag)
  800b2b:	85 d2                	test   %edx,%edx
  800b2d:	74 18                	je     800b47 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800b2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b32:	8d 50 04             	lea    0x4(%eax),%edx
  800b35:	89 55 14             	mov    %edx,0x14(%ebp)
  800b38:	8b 30                	mov    (%eax),%esi
  800b3a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800b3d:	89 f0                	mov    %esi,%eax
  800b3f:	c1 f8 1f             	sar    $0x1f,%eax
  800b42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b45:	eb 16                	jmp    800b5d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800b47:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4a:	8d 50 04             	lea    0x4(%eax),%edx
  800b4d:	89 55 14             	mov    %edx,0x14(%ebp)
  800b50:	8b 30                	mov    (%eax),%esi
  800b52:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800b55:	89 f0                	mov    %esi,%eax
  800b57:	c1 f8 1f             	sar    $0x1f,%eax
  800b5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800b63:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800b68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b6c:	0f 89 80 00 00 00    	jns    800bf2 <vprintfmt+0x374>
				putch('-', putdat);
  800b72:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b76:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800b7d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800b80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b86:	f7 d8                	neg    %eax
  800b88:	83 d2 00             	adc    $0x0,%edx
  800b8b:	f7 da                	neg    %edx
			}
			base = 10;
  800b8d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800b92:	eb 5e                	jmp    800bf2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b94:	8d 45 14             	lea    0x14(%ebp),%eax
  800b97:	e8 63 fc ff ff       	call   8007ff <getuint>
			base = 10;
  800b9c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800ba1:	eb 4f                	jmp    800bf2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800ba3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba6:	e8 54 fc ff ff       	call   8007ff <getuint>
			base = 8;
  800bab:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800bb0:	eb 40                	jmp    800bf2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800bb2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bb6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800bbd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800bc0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bc4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800bcb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800bce:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd1:	8d 50 04             	lea    0x4(%eax),%edx
  800bd4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800bde:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800be3:	eb 0d                	jmp    800bf2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800be5:	8d 45 14             	lea    0x14(%ebp),%eax
  800be8:	e8 12 fc ff ff       	call   8007ff <getuint>
			base = 16;
  800bed:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bf2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800bf6:	89 74 24 10          	mov    %esi,0x10(%esp)
  800bfa:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800bfd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800c01:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800c05:	89 04 24             	mov    %eax,(%esp)
  800c08:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c0c:	89 fa                	mov    %edi,%edx
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	e8 fa fa ff ff       	call   800710 <printnum>
			break;
  800c16:	e9 88 fc ff ff       	jmp    8008a3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c1b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c1f:	89 04 24             	mov    %eax,(%esp)
  800c22:	ff 55 08             	call   *0x8(%ebp)
			break;
  800c25:	e9 79 fc ff ff       	jmp    8008a3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c2a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c2e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800c35:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c38:	89 f3                	mov    %esi,%ebx
  800c3a:	eb 03                	jmp    800c3f <vprintfmt+0x3c1>
  800c3c:	83 eb 01             	sub    $0x1,%ebx
  800c3f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800c43:	75 f7                	jne    800c3c <vprintfmt+0x3be>
  800c45:	e9 59 fc ff ff       	jmp    8008a3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800c4a:	83 c4 3c             	add    $0x3c,%esp
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5f                   	pop    %edi
  800c50:	5d                   	pop    %ebp
  800c51:	c3                   	ret    

00800c52 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	83 ec 28             	sub    $0x28,%esp
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c61:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c65:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c6f:	85 c0                	test   %eax,%eax
  800c71:	74 30                	je     800ca3 <vsnprintf+0x51>
  800c73:	85 d2                	test   %edx,%edx
  800c75:	7e 2c                	jle    800ca3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c77:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c85:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c8c:	c7 04 24 39 08 80 00 	movl   $0x800839,(%esp)
  800c93:	e8 e6 fb ff ff       	call   80087e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ca1:	eb 05                	jmp    800ca8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800ca3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cb0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800cb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cba:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	89 04 24             	mov    %eax,(%esp)
  800ccb:	e8 82 ff ff ff       	call   800c52 <vsnprintf>
	va_end(ap);

	return rc;
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    
  800cd2:	66 90                	xchg   %ax,%ax
  800cd4:	66 90                	xchg   %ax,%ax
  800cd6:	66 90                	xchg   %ax,%ax
  800cd8:	66 90                	xchg   %ax,%ax
  800cda:	66 90                	xchg   %ax,%ax
  800cdc:	66 90                	xchg   %ax,%ax
  800cde:	66 90                	xchg   %ax,%ax

00800ce0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ceb:	eb 03                	jmp    800cf0 <strlen+0x10>
		n++;
  800ced:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cf0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800cf4:	75 f7                	jne    800ced <strlen+0xd>
		n++;
	return n;
}
  800cf6:	5d                   	pop    %ebp
  800cf7:	c3                   	ret    

00800cf8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
  800cfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cfe:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d01:	b8 00 00 00 00       	mov    $0x0,%eax
  800d06:	eb 03                	jmp    800d0b <strnlen+0x13>
		n++;
  800d08:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d0b:	39 d0                	cmp    %edx,%eax
  800d0d:	74 06                	je     800d15 <strnlen+0x1d>
  800d0f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800d13:	75 f3                	jne    800d08 <strnlen+0x10>
		n++;
	return n;
}
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    

00800d17 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	53                   	push   %ebx
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d21:	89 c2                	mov    %eax,%edx
  800d23:	83 c2 01             	add    $0x1,%edx
  800d26:	83 c1 01             	add    $0x1,%ecx
  800d29:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800d2d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d30:	84 db                	test   %bl,%bl
  800d32:	75 ef                	jne    800d23 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800d34:	5b                   	pop    %ebx
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	53                   	push   %ebx
  800d3b:	83 ec 08             	sub    $0x8,%esp
  800d3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d41:	89 1c 24             	mov    %ebx,(%esp)
  800d44:	e8 97 ff ff ff       	call   800ce0 <strlen>
	strcpy(dst + len, src);
  800d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800d50:	01 d8                	add    %ebx,%eax
  800d52:	89 04 24             	mov    %eax,(%esp)
  800d55:	e8 bd ff ff ff       	call   800d17 <strcpy>
	return dst;
}
  800d5a:	89 d8                	mov    %ebx,%eax
  800d5c:	83 c4 08             	add    $0x8,%esp
  800d5f:	5b                   	pop    %ebx
  800d60:	5d                   	pop    %ebp
  800d61:	c3                   	ret    

00800d62 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	56                   	push   %esi
  800d66:	53                   	push   %ebx
  800d67:	8b 75 08             	mov    0x8(%ebp),%esi
  800d6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6d:	89 f3                	mov    %esi,%ebx
  800d6f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d72:	89 f2                	mov    %esi,%edx
  800d74:	eb 0f                	jmp    800d85 <strncpy+0x23>
		*dst++ = *src;
  800d76:	83 c2 01             	add    $0x1,%edx
  800d79:	0f b6 01             	movzbl (%ecx),%eax
  800d7c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d7f:	80 39 01             	cmpb   $0x1,(%ecx)
  800d82:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d85:	39 da                	cmp    %ebx,%edx
  800d87:	75 ed                	jne    800d76 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800d89:	89 f0                	mov    %esi,%eax
  800d8b:	5b                   	pop    %ebx
  800d8c:	5e                   	pop    %esi
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
  800d94:	8b 75 08             	mov    0x8(%ebp),%esi
  800d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d9d:	89 f0                	mov    %esi,%eax
  800d9f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800da3:	85 c9                	test   %ecx,%ecx
  800da5:	75 0b                	jne    800db2 <strlcpy+0x23>
  800da7:	eb 1d                	jmp    800dc6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800da9:	83 c0 01             	add    $0x1,%eax
  800dac:	83 c2 01             	add    $0x1,%edx
  800daf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800db2:	39 d8                	cmp    %ebx,%eax
  800db4:	74 0b                	je     800dc1 <strlcpy+0x32>
  800db6:	0f b6 0a             	movzbl (%edx),%ecx
  800db9:	84 c9                	test   %cl,%cl
  800dbb:	75 ec                	jne    800da9 <strlcpy+0x1a>
  800dbd:	89 c2                	mov    %eax,%edx
  800dbf:	eb 02                	jmp    800dc3 <strlcpy+0x34>
  800dc1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800dc3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800dc6:	29 f0                	sub    %esi,%eax
}
  800dc8:	5b                   	pop    %ebx
  800dc9:	5e                   	pop    %esi
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    

00800dcc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800dd5:	eb 06                	jmp    800ddd <strcmp+0x11>
		p++, q++;
  800dd7:	83 c1 01             	add    $0x1,%ecx
  800dda:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ddd:	0f b6 01             	movzbl (%ecx),%eax
  800de0:	84 c0                	test   %al,%al
  800de2:	74 04                	je     800de8 <strcmp+0x1c>
  800de4:	3a 02                	cmp    (%edx),%al
  800de6:	74 ef                	je     800dd7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800de8:	0f b6 c0             	movzbl %al,%eax
  800deb:	0f b6 12             	movzbl (%edx),%edx
  800dee:	29 d0                	sub    %edx,%eax
}
  800df0:	5d                   	pop    %ebp
  800df1:	c3                   	ret    

00800df2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	53                   	push   %ebx
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfc:	89 c3                	mov    %eax,%ebx
  800dfe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800e01:	eb 06                	jmp    800e09 <strncmp+0x17>
		n--, p++, q++;
  800e03:	83 c0 01             	add    $0x1,%eax
  800e06:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800e09:	39 d8                	cmp    %ebx,%eax
  800e0b:	74 15                	je     800e22 <strncmp+0x30>
  800e0d:	0f b6 08             	movzbl (%eax),%ecx
  800e10:	84 c9                	test   %cl,%cl
  800e12:	74 04                	je     800e18 <strncmp+0x26>
  800e14:	3a 0a                	cmp    (%edx),%cl
  800e16:	74 eb                	je     800e03 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e18:	0f b6 00             	movzbl (%eax),%eax
  800e1b:	0f b6 12             	movzbl (%edx),%edx
  800e1e:	29 d0                	sub    %edx,%eax
  800e20:	eb 05                	jmp    800e27 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800e22:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800e27:	5b                   	pop    %ebx
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e34:	eb 07                	jmp    800e3d <strchr+0x13>
		if (*s == c)
  800e36:	38 ca                	cmp    %cl,%dl
  800e38:	74 0f                	je     800e49 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e3a:	83 c0 01             	add    $0x1,%eax
  800e3d:	0f b6 10             	movzbl (%eax),%edx
  800e40:	84 d2                	test   %dl,%dl
  800e42:	75 f2                	jne    800e36 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800e44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    

00800e4b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e55:	eb 07                	jmp    800e5e <strfind+0x13>
		if (*s == c)
  800e57:	38 ca                	cmp    %cl,%dl
  800e59:	74 0a                	je     800e65 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e5b:	83 c0 01             	add    $0x1,%eax
  800e5e:	0f b6 10             	movzbl (%eax),%edx
  800e61:	84 d2                	test   %dl,%dl
  800e63:	75 f2                	jne    800e57 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    

00800e67 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	57                   	push   %edi
  800e6b:	56                   	push   %esi
  800e6c:	53                   	push   %ebx
  800e6d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e70:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e73:	85 c9                	test   %ecx,%ecx
  800e75:	74 36                	je     800ead <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e77:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e7d:	75 28                	jne    800ea7 <memset+0x40>
  800e7f:	f6 c1 03             	test   $0x3,%cl
  800e82:	75 23                	jne    800ea7 <memset+0x40>
		c &= 0xFF;
  800e84:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e88:	89 d3                	mov    %edx,%ebx
  800e8a:	c1 e3 08             	shl    $0x8,%ebx
  800e8d:	89 d6                	mov    %edx,%esi
  800e8f:	c1 e6 18             	shl    $0x18,%esi
  800e92:	89 d0                	mov    %edx,%eax
  800e94:	c1 e0 10             	shl    $0x10,%eax
  800e97:	09 f0                	or     %esi,%eax
  800e99:	09 c2                	or     %eax,%edx
  800e9b:	89 d0                	mov    %edx,%eax
  800e9d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e9f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ea2:	fc                   	cld    
  800ea3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ea5:	eb 06                	jmp    800ead <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaa:	fc                   	cld    
  800eab:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ead:	89 f8                	mov    %edi,%eax
  800eaf:	5b                   	pop    %ebx
  800eb0:	5e                   	pop    %esi
  800eb1:	5f                   	pop    %edi
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    

00800eb4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	57                   	push   %edi
  800eb8:	56                   	push   %esi
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ebf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ec2:	39 c6                	cmp    %eax,%esi
  800ec4:	73 35                	jae    800efb <memmove+0x47>
  800ec6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ec9:	39 d0                	cmp    %edx,%eax
  800ecb:	73 2e                	jae    800efb <memmove+0x47>
		s += n;
		d += n;
  800ecd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800ed0:	89 d6                	mov    %edx,%esi
  800ed2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ed4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800eda:	75 13                	jne    800eef <memmove+0x3b>
  800edc:	f6 c1 03             	test   $0x3,%cl
  800edf:	75 0e                	jne    800eef <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ee1:	83 ef 04             	sub    $0x4,%edi
  800ee4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ee7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800eea:	fd                   	std    
  800eeb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800eed:	eb 09                	jmp    800ef8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800eef:	83 ef 01             	sub    $0x1,%edi
  800ef2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ef5:	fd                   	std    
  800ef6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ef8:	fc                   	cld    
  800ef9:	eb 1d                	jmp    800f18 <memmove+0x64>
  800efb:	89 f2                	mov    %esi,%edx
  800efd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eff:	f6 c2 03             	test   $0x3,%dl
  800f02:	75 0f                	jne    800f13 <memmove+0x5f>
  800f04:	f6 c1 03             	test   $0x3,%cl
  800f07:	75 0a                	jne    800f13 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800f09:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800f0c:	89 c7                	mov    %eax,%edi
  800f0e:	fc                   	cld    
  800f0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f11:	eb 05                	jmp    800f18 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800f13:	89 c7                	mov    %eax,%edi
  800f15:	fc                   	cld    
  800f16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800f18:	5e                   	pop    %esi
  800f19:	5f                   	pop    %edi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    

00800f1c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800f22:	8b 45 10             	mov    0x10(%ebp),%eax
  800f25:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	89 04 24             	mov    %eax,(%esp)
  800f36:	e8 79 ff ff ff       	call   800eb4 <memmove>
}
  800f3b:	c9                   	leave  
  800f3c:	c3                   	ret    

00800f3d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	56                   	push   %esi
  800f41:	53                   	push   %ebx
  800f42:	8b 55 08             	mov    0x8(%ebp),%edx
  800f45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f48:	89 d6                	mov    %edx,%esi
  800f4a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f4d:	eb 1a                	jmp    800f69 <memcmp+0x2c>
		if (*s1 != *s2)
  800f4f:	0f b6 02             	movzbl (%edx),%eax
  800f52:	0f b6 19             	movzbl (%ecx),%ebx
  800f55:	38 d8                	cmp    %bl,%al
  800f57:	74 0a                	je     800f63 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800f59:	0f b6 c0             	movzbl %al,%eax
  800f5c:	0f b6 db             	movzbl %bl,%ebx
  800f5f:	29 d8                	sub    %ebx,%eax
  800f61:	eb 0f                	jmp    800f72 <memcmp+0x35>
		s1++, s2++;
  800f63:	83 c2 01             	add    $0x1,%edx
  800f66:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f69:	39 f2                	cmp    %esi,%edx
  800f6b:	75 e2                	jne    800f4f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f72:	5b                   	pop    %ebx
  800f73:	5e                   	pop    %esi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    

00800f76 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f7f:	89 c2                	mov    %eax,%edx
  800f81:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f84:	eb 07                	jmp    800f8d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f86:	38 08                	cmp    %cl,(%eax)
  800f88:	74 07                	je     800f91 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f8a:	83 c0 01             	add    $0x1,%eax
  800f8d:	39 d0                	cmp    %edx,%eax
  800f8f:	72 f5                	jb     800f86 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800f91:	5d                   	pop    %ebp
  800f92:	c3                   	ret    

00800f93 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	57                   	push   %edi
  800f97:	56                   	push   %esi
  800f98:	53                   	push   %ebx
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f9f:	eb 03                	jmp    800fa4 <strtol+0x11>
		s++;
  800fa1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fa4:	0f b6 0a             	movzbl (%edx),%ecx
  800fa7:	80 f9 09             	cmp    $0x9,%cl
  800faa:	74 f5                	je     800fa1 <strtol+0xe>
  800fac:	80 f9 20             	cmp    $0x20,%cl
  800faf:	74 f0                	je     800fa1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fb1:	80 f9 2b             	cmp    $0x2b,%cl
  800fb4:	75 0a                	jne    800fc0 <strtol+0x2d>
		s++;
  800fb6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800fb9:	bf 00 00 00 00       	mov    $0x0,%edi
  800fbe:	eb 11                	jmp    800fd1 <strtol+0x3e>
  800fc0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800fc5:	80 f9 2d             	cmp    $0x2d,%cl
  800fc8:	75 07                	jne    800fd1 <strtol+0x3e>
		s++, neg = 1;
  800fca:	8d 52 01             	lea    0x1(%edx),%edx
  800fcd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fd1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800fd6:	75 15                	jne    800fed <strtol+0x5a>
  800fd8:	80 3a 30             	cmpb   $0x30,(%edx)
  800fdb:	75 10                	jne    800fed <strtol+0x5a>
  800fdd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800fe1:	75 0a                	jne    800fed <strtol+0x5a>
		s += 2, base = 16;
  800fe3:	83 c2 02             	add    $0x2,%edx
  800fe6:	b8 10 00 00 00       	mov    $0x10,%eax
  800feb:	eb 10                	jmp    800ffd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800fed:	85 c0                	test   %eax,%eax
  800fef:	75 0c                	jne    800ffd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ff1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ff3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ff6:	75 05                	jne    800ffd <strtol+0x6a>
		s++, base = 8;
  800ff8:	83 c2 01             	add    $0x1,%edx
  800ffb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800ffd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801002:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801005:	0f b6 0a             	movzbl (%edx),%ecx
  801008:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80100b:	89 f0                	mov    %esi,%eax
  80100d:	3c 09                	cmp    $0x9,%al
  80100f:	77 08                	ja     801019 <strtol+0x86>
			dig = *s - '0';
  801011:	0f be c9             	movsbl %cl,%ecx
  801014:	83 e9 30             	sub    $0x30,%ecx
  801017:	eb 20                	jmp    801039 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  801019:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80101c:	89 f0                	mov    %esi,%eax
  80101e:	3c 19                	cmp    $0x19,%al
  801020:	77 08                	ja     80102a <strtol+0x97>
			dig = *s - 'a' + 10;
  801022:	0f be c9             	movsbl %cl,%ecx
  801025:	83 e9 57             	sub    $0x57,%ecx
  801028:	eb 0f                	jmp    801039 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80102a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80102d:	89 f0                	mov    %esi,%eax
  80102f:	3c 19                	cmp    $0x19,%al
  801031:	77 16                	ja     801049 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801033:	0f be c9             	movsbl %cl,%ecx
  801036:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801039:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80103c:	7d 0f                	jge    80104d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80103e:	83 c2 01             	add    $0x1,%edx
  801041:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801045:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801047:	eb bc                	jmp    801005 <strtol+0x72>
  801049:	89 d8                	mov    %ebx,%eax
  80104b:	eb 02                	jmp    80104f <strtol+0xbc>
  80104d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80104f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801053:	74 05                	je     80105a <strtol+0xc7>
		*endptr = (char *) s;
  801055:	8b 75 0c             	mov    0xc(%ebp),%esi
  801058:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80105a:	f7 d8                	neg    %eax
  80105c:	85 ff                	test   %edi,%edi
  80105e:	0f 44 c3             	cmove  %ebx,%eax
}
  801061:	5b                   	pop    %ebx
  801062:	5e                   	pop    %esi
  801063:	5f                   	pop    %edi
  801064:	5d                   	pop    %ebp
  801065:	c3                   	ret    

00801066 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	57                   	push   %edi
  80106a:	56                   	push   %esi
  80106b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106c:	b8 00 00 00 00       	mov    $0x0,%eax
  801071:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801074:	8b 55 08             	mov    0x8(%ebp),%edx
  801077:	89 c3                	mov    %eax,%ebx
  801079:	89 c7                	mov    %eax,%edi
  80107b:	89 c6                	mov    %eax,%esi
  80107d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80107f:	5b                   	pop    %ebx
  801080:	5e                   	pop    %esi
  801081:	5f                   	pop    %edi
  801082:	5d                   	pop    %ebp
  801083:	c3                   	ret    

00801084 <sys_cgetc>:

int
sys_cgetc(void)
{
  801084:	55                   	push   %ebp
  801085:	89 e5                	mov    %esp,%ebp
  801087:	57                   	push   %edi
  801088:	56                   	push   %esi
  801089:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108a:	ba 00 00 00 00       	mov    $0x0,%edx
  80108f:	b8 01 00 00 00       	mov    $0x1,%eax
  801094:	89 d1                	mov    %edx,%ecx
  801096:	89 d3                	mov    %edx,%ebx
  801098:	89 d7                	mov    %edx,%edi
  80109a:	89 d6                	mov    %edx,%esi
  80109c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80109e:	5b                   	pop    %ebx
  80109f:	5e                   	pop    %esi
  8010a0:	5f                   	pop    %edi
  8010a1:	5d                   	pop    %ebp
  8010a2:	c3                   	ret    

008010a3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	57                   	push   %edi
  8010a7:	56                   	push   %esi
  8010a8:	53                   	push   %ebx
  8010a9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b1:	b8 03 00 00 00       	mov    $0x3,%eax
  8010b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b9:	89 cb                	mov    %ecx,%ebx
  8010bb:	89 cf                	mov    %ecx,%edi
  8010bd:	89 ce                	mov    %ecx,%esi
  8010bf:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8010c1:	85 c0                	test   %eax,%eax
  8010c3:	7e 28                	jle    8010ed <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8010d0:	00 
  8010d1:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  8010d8:	00 
  8010d9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010e0:	00 
  8010e1:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  8010e8:	e8 0f f5 ff ff       	call   8005fc <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010ed:	83 c4 2c             	add    $0x2c,%esp
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5f                   	pop    %edi
  8010f3:	5d                   	pop    %ebp
  8010f4:	c3                   	ret    

008010f5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	57                   	push   %edi
  8010f9:	56                   	push   %esi
  8010fa:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801100:	b8 02 00 00 00       	mov    $0x2,%eax
  801105:	89 d1                	mov    %edx,%ecx
  801107:	89 d3                	mov    %edx,%ebx
  801109:	89 d7                	mov    %edx,%edi
  80110b:	89 d6                	mov    %edx,%esi
  80110d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80110f:	5b                   	pop    %ebx
  801110:	5e                   	pop    %esi
  801111:	5f                   	pop    %edi
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    

00801114 <sys_yield>:

void
sys_yield(void)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	57                   	push   %edi
  801118:	56                   	push   %esi
  801119:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80111a:	ba 00 00 00 00       	mov    $0x0,%edx
  80111f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801124:	89 d1                	mov    %edx,%ecx
  801126:	89 d3                	mov    %edx,%ebx
  801128:	89 d7                	mov    %edx,%edi
  80112a:	89 d6                	mov    %edx,%esi
  80112c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80112e:	5b                   	pop    %ebx
  80112f:	5e                   	pop    %esi
  801130:	5f                   	pop    %edi
  801131:	5d                   	pop    %ebp
  801132:	c3                   	ret    

00801133 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
  801136:	57                   	push   %edi
  801137:	56                   	push   %esi
  801138:	53                   	push   %ebx
  801139:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80113c:	be 00 00 00 00       	mov    $0x0,%esi
  801141:	b8 04 00 00 00       	mov    $0x4,%eax
  801146:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801149:	8b 55 08             	mov    0x8(%ebp),%edx
  80114c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80114f:	89 f7                	mov    %esi,%edi
  801151:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801153:	85 c0                	test   %eax,%eax
  801155:	7e 28                	jle    80117f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801157:	89 44 24 10          	mov    %eax,0x10(%esp)
  80115b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801162:	00 
  801163:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  80116a:	00 
  80116b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801172:	00 
  801173:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  80117a:	e8 7d f4 ff ff       	call   8005fc <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80117f:	83 c4 2c             	add    $0x2c,%esp
  801182:	5b                   	pop    %ebx
  801183:	5e                   	pop    %esi
  801184:	5f                   	pop    %edi
  801185:	5d                   	pop    %ebp
  801186:	c3                   	ret    

00801187 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801187:	55                   	push   %ebp
  801188:	89 e5                	mov    %esp,%ebp
  80118a:	57                   	push   %edi
  80118b:	56                   	push   %esi
  80118c:	53                   	push   %ebx
  80118d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801190:	b8 05 00 00 00       	mov    $0x5,%eax
  801195:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801198:	8b 55 08             	mov    0x8(%ebp),%edx
  80119b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80119e:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011a1:	8b 75 18             	mov    0x18(%ebp),%esi
  8011a4:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	7e 28                	jle    8011d2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011aa:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011ae:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8011b5:	00 
  8011b6:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  8011bd:	00 
  8011be:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011c5:	00 
  8011c6:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  8011cd:	e8 2a f4 ff ff       	call   8005fc <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8011d2:	83 c4 2c             	add    $0x2c,%esp
  8011d5:	5b                   	pop    %ebx
  8011d6:	5e                   	pop    %esi
  8011d7:	5f                   	pop    %edi
  8011d8:	5d                   	pop    %ebp
  8011d9:	c3                   	ret    

008011da <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	57                   	push   %edi
  8011de:	56                   	push   %esi
  8011df:	53                   	push   %ebx
  8011e0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e8:	b8 06 00 00 00       	mov    $0x6,%eax
  8011ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f3:	89 df                	mov    %ebx,%edi
  8011f5:	89 de                	mov    %ebx,%esi
  8011f7:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8011f9:	85 c0                	test   %eax,%eax
  8011fb:	7e 28                	jle    801225 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011fd:	89 44 24 10          	mov    %eax,0x10(%esp)
  801201:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801208:	00 
  801209:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  801210:	00 
  801211:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801218:	00 
  801219:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  801220:	e8 d7 f3 ff ff       	call   8005fc <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801225:	83 c4 2c             	add    $0x2c,%esp
  801228:	5b                   	pop    %ebx
  801229:	5e                   	pop    %esi
  80122a:	5f                   	pop    %edi
  80122b:	5d                   	pop    %ebp
  80122c:	c3                   	ret    

0080122d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	57                   	push   %edi
  801231:	56                   	push   %esi
  801232:	53                   	push   %ebx
  801233:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801236:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123b:	b8 08 00 00 00       	mov    $0x8,%eax
  801240:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801243:	8b 55 08             	mov    0x8(%ebp),%edx
  801246:	89 df                	mov    %ebx,%edi
  801248:	89 de                	mov    %ebx,%esi
  80124a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80124c:	85 c0                	test   %eax,%eax
  80124e:	7e 28                	jle    801278 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801250:	89 44 24 10          	mov    %eax,0x10(%esp)
  801254:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80125b:	00 
  80125c:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  801263:	00 
  801264:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80126b:	00 
  80126c:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  801273:	e8 84 f3 ff ff       	call   8005fc <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801278:	83 c4 2c             	add    $0x2c,%esp
  80127b:	5b                   	pop    %ebx
  80127c:	5e                   	pop    %esi
  80127d:	5f                   	pop    %edi
  80127e:	5d                   	pop    %ebp
  80127f:	c3                   	ret    

00801280 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	57                   	push   %edi
  801284:	56                   	push   %esi
  801285:	53                   	push   %ebx
  801286:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801289:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128e:	b8 09 00 00 00       	mov    $0x9,%eax
  801293:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801296:	8b 55 08             	mov    0x8(%ebp),%edx
  801299:	89 df                	mov    %ebx,%edi
  80129b:	89 de                	mov    %ebx,%esi
  80129d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80129f:	85 c0                	test   %eax,%eax
  8012a1:	7e 28                	jle    8012cb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012a7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8012ae:	00 
  8012af:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  8012b6:	00 
  8012b7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012be:	00 
  8012bf:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  8012c6:	e8 31 f3 ff ff       	call   8005fc <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8012cb:	83 c4 2c             	add    $0x2c,%esp
  8012ce:	5b                   	pop    %ebx
  8012cf:	5e                   	pop    %esi
  8012d0:	5f                   	pop    %edi
  8012d1:	5d                   	pop    %ebp
  8012d2:	c3                   	ret    

008012d3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
  8012d6:	57                   	push   %edi
  8012d7:	56                   	push   %esi
  8012d8:	53                   	push   %ebx
  8012d9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ec:	89 df                	mov    %ebx,%edi
  8012ee:	89 de                	mov    %ebx,%esi
  8012f0:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8012f2:	85 c0                	test   %eax,%eax
  8012f4:	7e 28                	jle    80131e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012f6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012fa:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801301:	00 
  801302:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  801309:	00 
  80130a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801311:	00 
  801312:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  801319:	e8 de f2 ff ff       	call   8005fc <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80131e:	83 c4 2c             	add    $0x2c,%esp
  801321:	5b                   	pop    %ebx
  801322:	5e                   	pop    %esi
  801323:	5f                   	pop    %edi
  801324:	5d                   	pop    %ebp
  801325:	c3                   	ret    

00801326 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	57                   	push   %edi
  80132a:	56                   	push   %esi
  80132b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80132c:	be 00 00 00 00       	mov    $0x0,%esi
  801331:	b8 0c 00 00 00       	mov    $0xc,%eax
  801336:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801339:	8b 55 08             	mov    0x8(%ebp),%edx
  80133c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80133f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801342:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801344:	5b                   	pop    %ebx
  801345:	5e                   	pop    %esi
  801346:	5f                   	pop    %edi
  801347:	5d                   	pop    %ebp
  801348:	c3                   	ret    

00801349 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	57                   	push   %edi
  80134d:	56                   	push   %esi
  80134e:	53                   	push   %ebx
  80134f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801352:	b9 00 00 00 00       	mov    $0x0,%ecx
  801357:	b8 0d 00 00 00       	mov    $0xd,%eax
  80135c:	8b 55 08             	mov    0x8(%ebp),%edx
  80135f:	89 cb                	mov    %ecx,%ebx
  801361:	89 cf                	mov    %ecx,%edi
  801363:	89 ce                	mov    %ecx,%esi
  801365:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801367:	85 c0                	test   %eax,%eax
  801369:	7e 28                	jle    801393 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80136b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80136f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801376:	00 
  801377:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  80137e:	00 
  80137f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801386:	00 
  801387:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  80138e:	e8 69 f2 ff ff       	call   8005fc <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801393:	83 c4 2c             	add    $0x2c,%esp
  801396:	5b                   	pop    %ebx
  801397:	5e                   	pop    %esi
  801398:	5f                   	pop    %edi
  801399:	5d                   	pop    %ebp
  80139a:	c3                   	ret    

0080139b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	57                   	push   %edi
  80139f:	56                   	push   %esi
  8013a0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8013ab:	89 d1                	mov    %edx,%ecx
  8013ad:	89 d3                	mov    %edx,%ebx
  8013af:	89 d7                	mov    %edx,%edi
  8013b1:	89 d6                	mov    %edx,%esi
  8013b3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8013b5:	5b                   	pop    %ebx
  8013b6:	5e                   	pop    %esi
  8013b7:	5f                   	pop    %edi
  8013b8:	5d                   	pop    %ebp
  8013b9:	c3                   	ret    

008013ba <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	57                   	push   %edi
  8013be:	56                   	push   %esi
  8013bf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c5:	b8 0f 00 00 00       	mov    $0xf,%eax
  8013ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d0:	89 df                	mov    %ebx,%edi
  8013d2:	89 de                	mov    %ebx,%esi
  8013d4:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  8013d6:	5b                   	pop    %ebx
  8013d7:	5e                   	pop    %esi
  8013d8:	5f                   	pop    %edi
  8013d9:	5d                   	pop    %ebp
  8013da:	c3                   	ret    

008013db <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
  8013de:	57                   	push   %edi
  8013df:	56                   	push   %esi
  8013e0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e6:	b8 10 00 00 00       	mov    $0x10,%eax
  8013eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f1:	89 df                	mov    %ebx,%edi
  8013f3:	89 de                	mov    %ebx,%esi
  8013f5:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  8013f7:	5b                   	pop    %ebx
  8013f8:	5e                   	pop    %esi
  8013f9:	5f                   	pop    %edi
  8013fa:	5d                   	pop    %ebp
  8013fb:	c3                   	ret    

008013fc <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	57                   	push   %edi
  801400:	56                   	push   %esi
  801401:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801402:	b9 00 00 00 00       	mov    $0x0,%ecx
  801407:	b8 11 00 00 00       	mov    $0x11,%eax
  80140c:	8b 55 08             	mov    0x8(%ebp),%edx
  80140f:	89 cb                	mov    %ecx,%ebx
  801411:	89 cf                	mov    %ecx,%edi
  801413:	89 ce                	mov    %ecx,%esi
  801415:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  801417:	5b                   	pop    %ebx
  801418:	5e                   	pop    %esi
  801419:	5f                   	pop    %edi
  80141a:	5d                   	pop    %ebp
  80141b:	c3                   	ret    

0080141c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	57                   	push   %edi
  801420:	56                   	push   %esi
  801421:	53                   	push   %ebx
  801422:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801425:	be 00 00 00 00       	mov    $0x0,%esi
  80142a:	b8 12 00 00 00       	mov    $0x12,%eax
  80142f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801432:	8b 55 08             	mov    0x8(%ebp),%edx
  801435:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801438:	8b 7d 14             	mov    0x14(%ebp),%edi
  80143b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80143d:	85 c0                	test   %eax,%eax
  80143f:	7e 28                	jle    801469 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  801441:	89 44 24 10          	mov    %eax,0x10(%esp)
  801445:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  80144c:	00 
  80144d:	c7 44 24 08 87 30 80 	movl   $0x803087,0x8(%esp)
  801454:	00 
  801455:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80145c:	00 
  80145d:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  801464:	e8 93 f1 ff ff       	call   8005fc <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  801469:	83 c4 2c             	add    $0x2c,%esp
  80146c:	5b                   	pop    %ebx
  80146d:	5e                   	pop    %esi
  80146e:	5f                   	pop    %edi
  80146f:	5d                   	pop    %ebp
  801470:	c3                   	ret    

00801471 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  801477:	83 3d b8 50 80 00 00 	cmpl   $0x0,0x8050b8
  80147e:	75 68                	jne    8014e8 <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  801480:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801485:	8b 40 48             	mov    0x48(%eax),%eax
  801488:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80148f:	00 
  801490:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801497:	ee 
  801498:	89 04 24             	mov    %eax,(%esp)
  80149b:	e8 93 fc ff ff       	call   801133 <sys_page_alloc>
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	74 2c                	je     8014d0 <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  8014a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a8:	c7 04 24 b4 30 80 00 	movl   $0x8030b4,(%esp)
  8014af:	e8 41 f2 ff ff       	call   8006f5 <cprintf>
			panic("set_pg_fault_handler");
  8014b4:	c7 44 24 08 e7 30 80 	movl   $0x8030e7,0x8(%esp)
  8014bb:	00 
  8014bc:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8014c3:	00 
  8014c4:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  8014cb:	e8 2c f1 ff ff       	call   8005fc <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  8014d0:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8014d5:	8b 40 48             	mov    0x48(%eax),%eax
  8014d8:	c7 44 24 04 f2 14 80 	movl   $0x8014f2,0x4(%esp)
  8014df:	00 
  8014e0:	89 04 24             	mov    %eax,(%esp)
  8014e3:	e8 eb fd ff ff       	call   8012d3 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	a3 b8 50 80 00       	mov    %eax,0x8050b8
}
  8014f0:	c9                   	leave  
  8014f1:	c3                   	ret    

008014f2 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8014f2:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8014f3:	a1 b8 50 80 00       	mov    0x8050b8,%eax
	call *%eax
  8014f8:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8014fa:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  8014fd:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  801501:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  801503:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  801507:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  801508:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  80150b:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  80150d:	58                   	pop    %eax
	popl %eax
  80150e:	58                   	pop    %eax
	popal
  80150f:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801510:	83 c4 04             	add    $0x4,%esp
	popfl
  801513:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801514:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801515:	c3                   	ret    
  801516:	66 90                	xchg   %ax,%ax
  801518:	66 90                	xchg   %ax,%ax
  80151a:	66 90                	xchg   %ax,%ax
  80151c:	66 90                	xchg   %ax,%ax
  80151e:	66 90                	xchg   %ax,%ax

00801520 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	05 00 00 00 30       	add    $0x30000000,%eax
  80152b:	c1 e8 0c             	shr    $0xc,%eax
}
  80152e:	5d                   	pop    %ebp
  80152f:	c3                   	ret    

00801530 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80153b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801540:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801545:	5d                   	pop    %ebp
  801546:	c3                   	ret    

00801547 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
  80154a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80154d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801552:	89 c2                	mov    %eax,%edx
  801554:	c1 ea 16             	shr    $0x16,%edx
  801557:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80155e:	f6 c2 01             	test   $0x1,%dl
  801561:	74 11                	je     801574 <fd_alloc+0x2d>
  801563:	89 c2                	mov    %eax,%edx
  801565:	c1 ea 0c             	shr    $0xc,%edx
  801568:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80156f:	f6 c2 01             	test   $0x1,%dl
  801572:	75 09                	jne    80157d <fd_alloc+0x36>
			*fd_store = fd;
  801574:	89 01                	mov    %eax,(%ecx)
			return 0;
  801576:	b8 00 00 00 00       	mov    $0x0,%eax
  80157b:	eb 17                	jmp    801594 <fd_alloc+0x4d>
  80157d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801582:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801587:	75 c9                	jne    801552 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801589:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80158f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801594:	5d                   	pop    %ebp
  801595:	c3                   	ret    

00801596 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80159c:	83 f8 1f             	cmp    $0x1f,%eax
  80159f:	77 36                	ja     8015d7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015a1:	c1 e0 0c             	shl    $0xc,%eax
  8015a4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015a9:	89 c2                	mov    %eax,%edx
  8015ab:	c1 ea 16             	shr    $0x16,%edx
  8015ae:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015b5:	f6 c2 01             	test   $0x1,%dl
  8015b8:	74 24                	je     8015de <fd_lookup+0x48>
  8015ba:	89 c2                	mov    %eax,%edx
  8015bc:	c1 ea 0c             	shr    $0xc,%edx
  8015bf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015c6:	f6 c2 01             	test   $0x1,%dl
  8015c9:	74 1a                	je     8015e5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ce:	89 02                	mov    %eax,(%edx)
	return 0;
  8015d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d5:	eb 13                	jmp    8015ea <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015dc:	eb 0c                	jmp    8015ea <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015e3:	eb 05                	jmp    8015ea <fd_lookup+0x54>
  8015e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8015ea:	5d                   	pop    %ebp
  8015eb:	c3                   	ret    

008015ec <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 18             	sub    $0x18,%esp
  8015f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8015f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fa:	eb 13                	jmp    80160f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8015fc:	39 08                	cmp    %ecx,(%eax)
  8015fe:	75 0c                	jne    80160c <dev_lookup+0x20>
			*dev = devtab[i];
  801600:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801603:	89 01                	mov    %eax,(%ecx)
			return 0;
  801605:	b8 00 00 00 00       	mov    $0x0,%eax
  80160a:	eb 38                	jmp    801644 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80160c:	83 c2 01             	add    $0x1,%edx
  80160f:	8b 04 95 8c 31 80 00 	mov    0x80318c(,%edx,4),%eax
  801616:	85 c0                	test   %eax,%eax
  801618:	75 e2                	jne    8015fc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80161a:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80161f:	8b 40 48             	mov    0x48(%eax),%eax
  801622:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801626:	89 44 24 04          	mov    %eax,0x4(%esp)
  80162a:	c7 04 24 0c 31 80 00 	movl   $0x80310c,(%esp)
  801631:	e8 bf f0 ff ff       	call   8006f5 <cprintf>
	*dev = 0;
  801636:	8b 45 0c             	mov    0xc(%ebp),%eax
  801639:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80163f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	56                   	push   %esi
  80164a:	53                   	push   %ebx
  80164b:	83 ec 20             	sub    $0x20,%esp
  80164e:	8b 75 08             	mov    0x8(%ebp),%esi
  801651:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801654:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801657:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80165b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801661:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801664:	89 04 24             	mov    %eax,(%esp)
  801667:	e8 2a ff ff ff       	call   801596 <fd_lookup>
  80166c:	85 c0                	test   %eax,%eax
  80166e:	78 05                	js     801675 <fd_close+0x2f>
	    || fd != fd2)
  801670:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801673:	74 0c                	je     801681 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801675:	84 db                	test   %bl,%bl
  801677:	ba 00 00 00 00       	mov    $0x0,%edx
  80167c:	0f 44 c2             	cmove  %edx,%eax
  80167f:	eb 3f                	jmp    8016c0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801681:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801684:	89 44 24 04          	mov    %eax,0x4(%esp)
  801688:	8b 06                	mov    (%esi),%eax
  80168a:	89 04 24             	mov    %eax,(%esp)
  80168d:	e8 5a ff ff ff       	call   8015ec <dev_lookup>
  801692:	89 c3                	mov    %eax,%ebx
  801694:	85 c0                	test   %eax,%eax
  801696:	78 16                	js     8016ae <fd_close+0x68>
		if (dev->dev_close)
  801698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80169e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	74 07                	je     8016ae <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8016a7:	89 34 24             	mov    %esi,(%esp)
  8016aa:	ff d0                	call   *%eax
  8016ac:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8016ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016b9:	e8 1c fb ff ff       	call   8011da <sys_page_unmap>
	return r;
  8016be:	89 d8                	mov    %ebx,%eax
}
  8016c0:	83 c4 20             	add    $0x20,%esp
  8016c3:	5b                   	pop    %ebx
  8016c4:	5e                   	pop    %esi
  8016c5:	5d                   	pop    %ebp
  8016c6:	c3                   	ret    

008016c7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	89 04 24             	mov    %eax,(%esp)
  8016da:	e8 b7 fe ff ff       	call   801596 <fd_lookup>
  8016df:	89 c2                	mov    %eax,%edx
  8016e1:	85 d2                	test   %edx,%edx
  8016e3:	78 13                	js     8016f8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8016e5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016ec:	00 
  8016ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f0:	89 04 24             	mov    %eax,(%esp)
  8016f3:	e8 4e ff ff ff       	call   801646 <fd_close>
}
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <close_all>:

void
close_all(void)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	53                   	push   %ebx
  8016fe:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801701:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801706:	89 1c 24             	mov    %ebx,(%esp)
  801709:	e8 b9 ff ff ff       	call   8016c7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80170e:	83 c3 01             	add    $0x1,%ebx
  801711:	83 fb 20             	cmp    $0x20,%ebx
  801714:	75 f0                	jne    801706 <close_all+0xc>
		close(i);
}
  801716:	83 c4 14             	add    $0x14,%esp
  801719:	5b                   	pop    %ebx
  80171a:	5d                   	pop    %ebp
  80171b:	c3                   	ret    

0080171c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	57                   	push   %edi
  801720:	56                   	push   %esi
  801721:	53                   	push   %ebx
  801722:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801725:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801728:	89 44 24 04          	mov    %eax,0x4(%esp)
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	89 04 24             	mov    %eax,(%esp)
  801732:	e8 5f fe ff ff       	call   801596 <fd_lookup>
  801737:	89 c2                	mov    %eax,%edx
  801739:	85 d2                	test   %edx,%edx
  80173b:	0f 88 e1 00 00 00    	js     801822 <dup+0x106>
		return r;
	close(newfdnum);
  801741:	8b 45 0c             	mov    0xc(%ebp),%eax
  801744:	89 04 24             	mov    %eax,(%esp)
  801747:	e8 7b ff ff ff       	call   8016c7 <close>

	newfd = INDEX2FD(newfdnum);
  80174c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80174f:	c1 e3 0c             	shl    $0xc,%ebx
  801752:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801758:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80175b:	89 04 24             	mov    %eax,(%esp)
  80175e:	e8 cd fd ff ff       	call   801530 <fd2data>
  801763:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801765:	89 1c 24             	mov    %ebx,(%esp)
  801768:	e8 c3 fd ff ff       	call   801530 <fd2data>
  80176d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80176f:	89 f0                	mov    %esi,%eax
  801771:	c1 e8 16             	shr    $0x16,%eax
  801774:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80177b:	a8 01                	test   $0x1,%al
  80177d:	74 43                	je     8017c2 <dup+0xa6>
  80177f:	89 f0                	mov    %esi,%eax
  801781:	c1 e8 0c             	shr    $0xc,%eax
  801784:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80178b:	f6 c2 01             	test   $0x1,%dl
  80178e:	74 32                	je     8017c2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801790:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801797:	25 07 0e 00 00       	and    $0xe07,%eax
  80179c:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017a0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8017a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017ab:	00 
  8017ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017b7:	e8 cb f9 ff ff       	call   801187 <sys_page_map>
  8017bc:	89 c6                	mov    %eax,%esi
  8017be:	85 c0                	test   %eax,%eax
  8017c0:	78 3e                	js     801800 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017c5:	89 c2                	mov    %eax,%edx
  8017c7:	c1 ea 0c             	shr    $0xc,%edx
  8017ca:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017d1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8017d7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8017df:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017e6:	00 
  8017e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017f2:	e8 90 f9 ff ff       	call   801187 <sys_page_map>
  8017f7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8017f9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017fc:	85 f6                	test   %esi,%esi
  8017fe:	79 22                	jns    801822 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801800:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801804:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80180b:	e8 ca f9 ff ff       	call   8011da <sys_page_unmap>
	sys_page_unmap(0, nva);
  801810:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801814:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80181b:	e8 ba f9 ff ff       	call   8011da <sys_page_unmap>
	return r;
  801820:	89 f0                	mov    %esi,%eax
}
  801822:	83 c4 3c             	add    $0x3c,%esp
  801825:	5b                   	pop    %ebx
  801826:	5e                   	pop    %esi
  801827:	5f                   	pop    %edi
  801828:	5d                   	pop    %ebp
  801829:	c3                   	ret    

0080182a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
  80182d:	53                   	push   %ebx
  80182e:	83 ec 24             	sub    $0x24,%esp
  801831:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801834:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801837:	89 44 24 04          	mov    %eax,0x4(%esp)
  80183b:	89 1c 24             	mov    %ebx,(%esp)
  80183e:	e8 53 fd ff ff       	call   801596 <fd_lookup>
  801843:	89 c2                	mov    %eax,%edx
  801845:	85 d2                	test   %edx,%edx
  801847:	78 6d                	js     8018b6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801849:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801850:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801853:	8b 00                	mov    (%eax),%eax
  801855:	89 04 24             	mov    %eax,(%esp)
  801858:	e8 8f fd ff ff       	call   8015ec <dev_lookup>
  80185d:	85 c0                	test   %eax,%eax
  80185f:	78 55                	js     8018b6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801864:	8b 50 08             	mov    0x8(%eax),%edx
  801867:	83 e2 03             	and    $0x3,%edx
  80186a:	83 fa 01             	cmp    $0x1,%edx
  80186d:	75 23                	jne    801892 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80186f:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  801874:	8b 40 48             	mov    0x48(%eax),%eax
  801877:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80187b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187f:	c7 04 24 50 31 80 00 	movl   $0x803150,(%esp)
  801886:	e8 6a ee ff ff       	call   8006f5 <cprintf>
		return -E_INVAL;
  80188b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801890:	eb 24                	jmp    8018b6 <read+0x8c>
	}
	if (!dev->dev_read)
  801892:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801895:	8b 52 08             	mov    0x8(%edx),%edx
  801898:	85 d2                	test   %edx,%edx
  80189a:	74 15                	je     8018b1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80189c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80189f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018aa:	89 04 24             	mov    %eax,(%esp)
  8018ad:	ff d2                	call   *%edx
  8018af:	eb 05                	jmp    8018b6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8018b1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8018b6:	83 c4 24             	add    $0x24,%esp
  8018b9:	5b                   	pop    %ebx
  8018ba:	5d                   	pop    %ebp
  8018bb:	c3                   	ret    

008018bc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	57                   	push   %edi
  8018c0:	56                   	push   %esi
  8018c1:	53                   	push   %ebx
  8018c2:	83 ec 1c             	sub    $0x1c,%esp
  8018c5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018c8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018d0:	eb 23                	jmp    8018f5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018d2:	89 f0                	mov    %esi,%eax
  8018d4:	29 d8                	sub    %ebx,%eax
  8018d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018da:	89 d8                	mov    %ebx,%eax
  8018dc:	03 45 0c             	add    0xc(%ebp),%eax
  8018df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e3:	89 3c 24             	mov    %edi,(%esp)
  8018e6:	e8 3f ff ff ff       	call   80182a <read>
		if (m < 0)
  8018eb:	85 c0                	test   %eax,%eax
  8018ed:	78 10                	js     8018ff <readn+0x43>
			return m;
		if (m == 0)
  8018ef:	85 c0                	test   %eax,%eax
  8018f1:	74 0a                	je     8018fd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018f3:	01 c3                	add    %eax,%ebx
  8018f5:	39 f3                	cmp    %esi,%ebx
  8018f7:	72 d9                	jb     8018d2 <readn+0x16>
  8018f9:	89 d8                	mov    %ebx,%eax
  8018fb:	eb 02                	jmp    8018ff <readn+0x43>
  8018fd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8018ff:	83 c4 1c             	add    $0x1c,%esp
  801902:	5b                   	pop    %ebx
  801903:	5e                   	pop    %esi
  801904:	5f                   	pop    %edi
  801905:	5d                   	pop    %ebp
  801906:	c3                   	ret    

00801907 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
  80190a:	53                   	push   %ebx
  80190b:	83 ec 24             	sub    $0x24,%esp
  80190e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801911:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801914:	89 44 24 04          	mov    %eax,0x4(%esp)
  801918:	89 1c 24             	mov    %ebx,(%esp)
  80191b:	e8 76 fc ff ff       	call   801596 <fd_lookup>
  801920:	89 c2                	mov    %eax,%edx
  801922:	85 d2                	test   %edx,%edx
  801924:	78 68                	js     80198e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801926:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801929:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801930:	8b 00                	mov    (%eax),%eax
  801932:	89 04 24             	mov    %eax,(%esp)
  801935:	e8 b2 fc ff ff       	call   8015ec <dev_lookup>
  80193a:	85 c0                	test   %eax,%eax
  80193c:	78 50                	js     80198e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80193e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801941:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801945:	75 23                	jne    80196a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801947:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80194c:	8b 40 48             	mov    0x48(%eax),%eax
  80194f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801953:	89 44 24 04          	mov    %eax,0x4(%esp)
  801957:	c7 04 24 6c 31 80 00 	movl   $0x80316c,(%esp)
  80195e:	e8 92 ed ff ff       	call   8006f5 <cprintf>
		return -E_INVAL;
  801963:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801968:	eb 24                	jmp    80198e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80196a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80196d:	8b 52 0c             	mov    0xc(%edx),%edx
  801970:	85 d2                	test   %edx,%edx
  801972:	74 15                	je     801989 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801974:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801977:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80197b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80197e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801982:	89 04 24             	mov    %eax,(%esp)
  801985:	ff d2                	call   *%edx
  801987:	eb 05                	jmp    80198e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801989:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80198e:	83 c4 24             	add    $0x24,%esp
  801991:	5b                   	pop    %ebx
  801992:	5d                   	pop    %ebp
  801993:	c3                   	ret    

00801994 <seek>:

int
seek(int fdnum, off_t offset)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80199a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80199d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	89 04 24             	mov    %eax,(%esp)
  8019a7:	e8 ea fb ff ff       	call   801596 <fd_lookup>
  8019ac:	85 c0                	test   %eax,%eax
  8019ae:	78 0e                	js     8019be <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8019b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	53                   	push   %ebx
  8019c4:	83 ec 24             	sub    $0x24,%esp
  8019c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d1:	89 1c 24             	mov    %ebx,(%esp)
  8019d4:	e8 bd fb ff ff       	call   801596 <fd_lookup>
  8019d9:	89 c2                	mov    %eax,%edx
  8019db:	85 d2                	test   %edx,%edx
  8019dd:	78 61                	js     801a40 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e9:	8b 00                	mov    (%eax),%eax
  8019eb:	89 04 24             	mov    %eax,(%esp)
  8019ee:	e8 f9 fb ff ff       	call   8015ec <dev_lookup>
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	78 49                	js     801a40 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019fe:	75 23                	jne    801a23 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a00:	a1 b4 50 80 00       	mov    0x8050b4,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a05:	8b 40 48             	mov    0x48(%eax),%eax
  801a08:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a10:	c7 04 24 2c 31 80 00 	movl   $0x80312c,(%esp)
  801a17:	e8 d9 ec ff ff       	call   8006f5 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a1c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a21:	eb 1d                	jmp    801a40 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801a23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a26:	8b 52 18             	mov    0x18(%edx),%edx
  801a29:	85 d2                	test   %edx,%edx
  801a2b:	74 0e                	je     801a3b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a30:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a34:	89 04 24             	mov    %eax,(%esp)
  801a37:	ff d2                	call   *%edx
  801a39:	eb 05                	jmp    801a40 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a3b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801a40:	83 c4 24             	add    $0x24,%esp
  801a43:	5b                   	pop    %ebx
  801a44:	5d                   	pop    %ebp
  801a45:	c3                   	ret    

00801a46 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	53                   	push   %ebx
  801a4a:	83 ec 24             	sub    $0x24,%esp
  801a4d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a50:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a53:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	89 04 24             	mov    %eax,(%esp)
  801a5d:	e8 34 fb ff ff       	call   801596 <fd_lookup>
  801a62:	89 c2                	mov    %eax,%edx
  801a64:	85 d2                	test   %edx,%edx
  801a66:	78 52                	js     801aba <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a68:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a72:	8b 00                	mov    (%eax),%eax
  801a74:	89 04 24             	mov    %eax,(%esp)
  801a77:	e8 70 fb ff ff       	call   8015ec <dev_lookup>
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	78 3a                	js     801aba <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a83:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a87:	74 2c                	je     801ab5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a89:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a8c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a93:	00 00 00 
	stat->st_isdir = 0;
  801a96:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a9d:	00 00 00 
	stat->st_dev = dev;
  801aa0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801aa6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801aaa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aad:	89 14 24             	mov    %edx,(%esp)
  801ab0:	ff 50 14             	call   *0x14(%eax)
  801ab3:	eb 05                	jmp    801aba <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801ab5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801aba:	83 c4 24             	add    $0x24,%esp
  801abd:	5b                   	pop    %ebx
  801abe:	5d                   	pop    %ebp
  801abf:	c3                   	ret    

00801ac0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	56                   	push   %esi
  801ac4:	53                   	push   %ebx
  801ac5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ac8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801acf:	00 
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	89 04 24             	mov    %eax,(%esp)
  801ad6:	e8 84 02 00 00       	call   801d5f <open>
  801adb:	89 c3                	mov    %eax,%ebx
  801add:	85 db                	test   %ebx,%ebx
  801adf:	78 1b                	js     801afc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae8:	89 1c 24             	mov    %ebx,(%esp)
  801aeb:	e8 56 ff ff ff       	call   801a46 <fstat>
  801af0:	89 c6                	mov    %eax,%esi
	close(fd);
  801af2:	89 1c 24             	mov    %ebx,(%esp)
  801af5:	e8 cd fb ff ff       	call   8016c7 <close>
	return r;
  801afa:	89 f0                	mov    %esi,%eax
}
  801afc:	83 c4 10             	add    $0x10,%esp
  801aff:	5b                   	pop    %ebx
  801b00:	5e                   	pop    %esi
  801b01:	5d                   	pop    %ebp
  801b02:	c3                   	ret    

00801b03 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	56                   	push   %esi
  801b07:	53                   	push   %ebx
  801b08:	83 ec 10             	sub    $0x10,%esp
  801b0b:	89 c6                	mov    %eax,%esi
  801b0d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b0f:	83 3d ac 50 80 00 00 	cmpl   $0x0,0x8050ac
  801b16:	75 11                	jne    801b29 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b18:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b1f:	e8 11 0e 00 00       	call   802935 <ipc_find_env>
  801b24:	a3 ac 50 80 00       	mov    %eax,0x8050ac
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b29:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b30:	00 
  801b31:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801b38:	00 
  801b39:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b3d:	a1 ac 50 80 00       	mov    0x8050ac,%eax
  801b42:	89 04 24             	mov    %eax,(%esp)
  801b45:	e8 5e 0d 00 00       	call   8028a8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b4a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b51:	00 
  801b52:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b56:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b5d:	e8 de 0c 00 00       	call   802840 <ipc_recv>
}
  801b62:	83 c4 10             	add    $0x10,%esp
  801b65:	5b                   	pop    %ebx
  801b66:	5e                   	pop    %esi
  801b67:	5d                   	pop    %ebp
  801b68:	c3                   	ret    

00801b69 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	8b 40 0c             	mov    0xc(%eax),%eax
  801b75:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b82:	ba 00 00 00 00       	mov    $0x0,%edx
  801b87:	b8 02 00 00 00       	mov    $0x2,%eax
  801b8c:	e8 72 ff ff ff       	call   801b03 <fsipc>
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b99:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b9f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ba4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba9:	b8 06 00 00 00       	mov    $0x6,%eax
  801bae:	e8 50 ff ff ff       	call   801b03 <fsipc>
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	53                   	push   %ebx
  801bb9:	83 ec 14             	sub    $0x14,%esp
  801bbc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bc5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bca:	ba 00 00 00 00       	mov    $0x0,%edx
  801bcf:	b8 05 00 00 00       	mov    $0x5,%eax
  801bd4:	e8 2a ff ff ff       	call   801b03 <fsipc>
  801bd9:	89 c2                	mov    %eax,%edx
  801bdb:	85 d2                	test   %edx,%edx
  801bdd:	78 2b                	js     801c0a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bdf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801be6:	00 
  801be7:	89 1c 24             	mov    %ebx,(%esp)
  801bea:	e8 28 f1 ff ff       	call   800d17 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bef:	a1 80 60 80 00       	mov    0x806080,%eax
  801bf4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bfa:	a1 84 60 80 00       	mov    0x806084,%eax
  801bff:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c0a:	83 c4 14             	add    $0x14,%esp
  801c0d:	5b                   	pop    %ebx
  801c0e:	5d                   	pop    %ebp
  801c0f:	c3                   	ret    

00801c10 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	53                   	push   %ebx
  801c14:	83 ec 14             	sub    $0x14,%esp
  801c17:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c20:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801c25:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801c2b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801c30:	0f 46 c3             	cmovbe %ebx,%eax
  801c33:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801c38:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c43:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801c4a:	e8 65 f2 ff ff       	call   800eb4 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c4f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c54:	b8 04 00 00 00       	mov    $0x4,%eax
  801c59:	e8 a5 fe ff ff       	call   801b03 <fsipc>
  801c5e:	85 c0                	test   %eax,%eax
  801c60:	78 53                	js     801cb5 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801c62:	39 c3                	cmp    %eax,%ebx
  801c64:	73 24                	jae    801c8a <devfile_write+0x7a>
  801c66:	c7 44 24 0c a0 31 80 	movl   $0x8031a0,0xc(%esp)
  801c6d:	00 
  801c6e:	c7 44 24 08 a7 31 80 	movl   $0x8031a7,0x8(%esp)
  801c75:	00 
  801c76:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801c7d:	00 
  801c7e:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  801c85:	e8 72 e9 ff ff       	call   8005fc <_panic>
	assert(r <= PGSIZE);
  801c8a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c8f:	7e 24                	jle    801cb5 <devfile_write+0xa5>
  801c91:	c7 44 24 0c c7 31 80 	movl   $0x8031c7,0xc(%esp)
  801c98:	00 
  801c99:	c7 44 24 08 a7 31 80 	movl   $0x8031a7,0x8(%esp)
  801ca0:	00 
  801ca1:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801ca8:	00 
  801ca9:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  801cb0:	e8 47 e9 ff ff       	call   8005fc <_panic>
	return r;
}
  801cb5:	83 c4 14             	add    $0x14,%esp
  801cb8:	5b                   	pop    %ebx
  801cb9:	5d                   	pop    %ebp
  801cba:	c3                   	ret    

00801cbb <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	56                   	push   %esi
  801cbf:	53                   	push   %ebx
  801cc0:	83 ec 10             	sub    $0x10,%esp
  801cc3:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	8b 40 0c             	mov    0xc(%eax),%eax
  801ccc:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801cd1:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cd7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cdc:	b8 03 00 00 00       	mov    $0x3,%eax
  801ce1:	e8 1d fe ff ff       	call   801b03 <fsipc>
  801ce6:	89 c3                	mov    %eax,%ebx
  801ce8:	85 c0                	test   %eax,%eax
  801cea:	78 6a                	js     801d56 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801cec:	39 c6                	cmp    %eax,%esi
  801cee:	73 24                	jae    801d14 <devfile_read+0x59>
  801cf0:	c7 44 24 0c a0 31 80 	movl   $0x8031a0,0xc(%esp)
  801cf7:	00 
  801cf8:	c7 44 24 08 a7 31 80 	movl   $0x8031a7,0x8(%esp)
  801cff:	00 
  801d00:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801d07:	00 
  801d08:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  801d0f:	e8 e8 e8 ff ff       	call   8005fc <_panic>
	assert(r <= PGSIZE);
  801d14:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d19:	7e 24                	jle    801d3f <devfile_read+0x84>
  801d1b:	c7 44 24 0c c7 31 80 	movl   $0x8031c7,0xc(%esp)
  801d22:	00 
  801d23:	c7 44 24 08 a7 31 80 	movl   $0x8031a7,0x8(%esp)
  801d2a:	00 
  801d2b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801d32:	00 
  801d33:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  801d3a:	e8 bd e8 ff ff       	call   8005fc <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d3f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d43:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d4a:	00 
  801d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4e:	89 04 24             	mov    %eax,(%esp)
  801d51:	e8 5e f1 ff ff       	call   800eb4 <memmove>
	return r;
}
  801d56:	89 d8                	mov    %ebx,%eax
  801d58:	83 c4 10             	add    $0x10,%esp
  801d5b:	5b                   	pop    %ebx
  801d5c:	5e                   	pop    %esi
  801d5d:	5d                   	pop    %ebp
  801d5e:	c3                   	ret    

00801d5f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	53                   	push   %ebx
  801d63:	83 ec 24             	sub    $0x24,%esp
  801d66:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d69:	89 1c 24             	mov    %ebx,(%esp)
  801d6c:	e8 6f ef ff ff       	call   800ce0 <strlen>
  801d71:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d76:	7f 60                	jg     801dd8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801d78:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d7b:	89 04 24             	mov    %eax,(%esp)
  801d7e:	e8 c4 f7 ff ff       	call   801547 <fd_alloc>
  801d83:	89 c2                	mov    %eax,%edx
  801d85:	85 d2                	test   %edx,%edx
  801d87:	78 54                	js     801ddd <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d89:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d8d:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801d94:	e8 7e ef ff ff       	call   800d17 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d9c:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801da1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da4:	b8 01 00 00 00       	mov    $0x1,%eax
  801da9:	e8 55 fd ff ff       	call   801b03 <fsipc>
  801dae:	89 c3                	mov    %eax,%ebx
  801db0:	85 c0                	test   %eax,%eax
  801db2:	79 17                	jns    801dcb <open+0x6c>
		fd_close(fd, 0);
  801db4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801dbb:	00 
  801dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbf:	89 04 24             	mov    %eax,(%esp)
  801dc2:	e8 7f f8 ff ff       	call   801646 <fd_close>
		return r;
  801dc7:	89 d8                	mov    %ebx,%eax
  801dc9:	eb 12                	jmp    801ddd <open+0x7e>
	}

	return fd2num(fd);
  801dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dce:	89 04 24             	mov    %eax,(%esp)
  801dd1:	e8 4a f7 ff ff       	call   801520 <fd2num>
  801dd6:	eb 05                	jmp    801ddd <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801dd8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801ddd:	83 c4 24             	add    $0x24,%esp
  801de0:	5b                   	pop    %ebx
  801de1:	5d                   	pop    %ebp
  801de2:	c3                   	ret    

00801de3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801de9:	ba 00 00 00 00       	mov    $0x0,%edx
  801dee:	b8 08 00 00 00       	mov    $0x8,%eax
  801df3:	e8 0b fd ff ff       	call   801b03 <fsipc>
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    
  801dfa:	66 90                	xchg   %ax,%ax
  801dfc:	66 90                	xchg   %ax,%ax
  801dfe:	66 90                	xchg   %ax,%ax

00801e00 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801e06:	c7 44 24 04 d3 31 80 	movl   $0x8031d3,0x4(%esp)
  801e0d:	00 
  801e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e11:	89 04 24             	mov    %eax,(%esp)
  801e14:	e8 fe ee ff ff       	call   800d17 <strcpy>
	return 0;
}
  801e19:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	53                   	push   %ebx
  801e24:	83 ec 14             	sub    $0x14,%esp
  801e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e2a:	89 1c 24             	mov    %ebx,(%esp)
  801e2d:	e8 3d 0b 00 00       	call   80296f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801e32:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801e37:	83 f8 01             	cmp    $0x1,%eax
  801e3a:	75 0d                	jne    801e49 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801e3c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e3f:	89 04 24             	mov    %eax,(%esp)
  801e42:	e8 29 03 00 00       	call   802170 <nsipc_close>
  801e47:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801e49:	89 d0                	mov    %edx,%eax
  801e4b:	83 c4 14             	add    $0x14,%esp
  801e4e:	5b                   	pop    %ebx
  801e4f:	5d                   	pop    %ebp
  801e50:	c3                   	ret    

00801e51 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e57:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e5e:	00 
  801e5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e62:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e70:	8b 40 0c             	mov    0xc(%eax),%eax
  801e73:	89 04 24             	mov    %eax,(%esp)
  801e76:	e8 f0 03 00 00       	call   80226b <nsipc_send>
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e83:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e8a:	00 
  801e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e95:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e99:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e9f:	89 04 24             	mov    %eax,(%esp)
  801ea2:	e8 44 03 00 00       	call   8021eb <nsipc_recv>
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
  801eac:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801eaf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801eb2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801eb6:	89 04 24             	mov    %eax,(%esp)
  801eb9:	e8 d8 f6 ff ff       	call   801596 <fd_lookup>
  801ebe:	85 c0                	test   %eax,%eax
  801ec0:	78 17                	js     801ed9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801ecb:	39 08                	cmp    %ecx,(%eax)
  801ecd:	75 05                	jne    801ed4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801ecf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed2:	eb 05                	jmp    801ed9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801ed4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801ed9:	c9                   	leave  
  801eda:	c3                   	ret    

00801edb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	56                   	push   %esi
  801edf:	53                   	push   %ebx
  801ee0:	83 ec 20             	sub    $0x20,%esp
  801ee3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ee5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ee8:	89 04 24             	mov    %eax,(%esp)
  801eeb:	e8 57 f6 ff ff       	call   801547 <fd_alloc>
  801ef0:	89 c3                	mov    %eax,%ebx
  801ef2:	85 c0                	test   %eax,%eax
  801ef4:	78 21                	js     801f17 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ef6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801efd:	00 
  801efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f01:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f05:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f0c:	e8 22 f2 ff ff       	call   801133 <sys_page_alloc>
  801f11:	89 c3                	mov    %eax,%ebx
  801f13:	85 c0                	test   %eax,%eax
  801f15:	79 0c                	jns    801f23 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801f17:	89 34 24             	mov    %esi,(%esp)
  801f1a:	e8 51 02 00 00       	call   802170 <nsipc_close>
		return r;
  801f1f:	89 d8                	mov    %ebx,%eax
  801f21:	eb 20                	jmp    801f43 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f23:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f31:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801f38:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801f3b:	89 14 24             	mov    %edx,(%esp)
  801f3e:	e8 dd f5 ff ff       	call   801520 <fd2num>
}
  801f43:	83 c4 20             	add    $0x20,%esp
  801f46:	5b                   	pop    %ebx
  801f47:	5e                   	pop    %esi
  801f48:	5d                   	pop    %ebp
  801f49:	c3                   	ret    

00801f4a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f50:	8b 45 08             	mov    0x8(%ebp),%eax
  801f53:	e8 51 ff ff ff       	call   801ea9 <fd2sockid>
		return r;
  801f58:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	78 23                	js     801f81 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f5e:	8b 55 10             	mov    0x10(%ebp),%edx
  801f61:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f68:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f6c:	89 04 24             	mov    %eax,(%esp)
  801f6f:	e8 45 01 00 00       	call   8020b9 <nsipc_accept>
		return r;
  801f74:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f76:	85 c0                	test   %eax,%eax
  801f78:	78 07                	js     801f81 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801f7a:	e8 5c ff ff ff       	call   801edb <alloc_sockfd>
  801f7f:	89 c1                	mov    %eax,%ecx
}
  801f81:	89 c8                	mov    %ecx,%eax
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8e:	e8 16 ff ff ff       	call   801ea9 <fd2sockid>
  801f93:	89 c2                	mov    %eax,%edx
  801f95:	85 d2                	test   %edx,%edx
  801f97:	78 16                	js     801faf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801f99:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa7:	89 14 24             	mov    %edx,(%esp)
  801faa:	e8 60 01 00 00       	call   80210f <nsipc_bind>
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <shutdown>:

int
shutdown(int s, int how)
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
  801fb4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fba:	e8 ea fe ff ff       	call   801ea9 <fd2sockid>
  801fbf:	89 c2                	mov    %eax,%edx
  801fc1:	85 d2                	test   %edx,%edx
  801fc3:	78 0f                	js     801fd4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fcc:	89 14 24             	mov    %edx,(%esp)
  801fcf:	e8 7a 01 00 00       	call   80214e <nsipc_shutdown>
}
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
  801fd9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	e8 c5 fe ff ff       	call   801ea9 <fd2sockid>
  801fe4:	89 c2                	mov    %eax,%edx
  801fe6:	85 d2                	test   %edx,%edx
  801fe8:	78 16                	js     802000 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801fea:	8b 45 10             	mov    0x10(%ebp),%eax
  801fed:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ff1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff8:	89 14 24             	mov    %edx,(%esp)
  801ffb:	e8 8a 01 00 00       	call   80218a <nsipc_connect>
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <listen>:

int
listen(int s, int backlog)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802008:	8b 45 08             	mov    0x8(%ebp),%eax
  80200b:	e8 99 fe ff ff       	call   801ea9 <fd2sockid>
  802010:	89 c2                	mov    %eax,%edx
  802012:	85 d2                	test   %edx,%edx
  802014:	78 0f                	js     802025 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802016:	8b 45 0c             	mov    0xc(%ebp),%eax
  802019:	89 44 24 04          	mov    %eax,0x4(%esp)
  80201d:	89 14 24             	mov    %edx,(%esp)
  802020:	e8 a4 01 00 00       	call   8021c9 <nsipc_listen>
}
  802025:	c9                   	leave  
  802026:	c3                   	ret    

00802027 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80202d:	8b 45 10             	mov    0x10(%ebp),%eax
  802030:	89 44 24 08          	mov    %eax,0x8(%esp)
  802034:	8b 45 0c             	mov    0xc(%ebp),%eax
  802037:	89 44 24 04          	mov    %eax,0x4(%esp)
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	89 04 24             	mov    %eax,(%esp)
  802041:	e8 98 02 00 00       	call   8022de <nsipc_socket>
  802046:	89 c2                	mov    %eax,%edx
  802048:	85 d2                	test   %edx,%edx
  80204a:	78 05                	js     802051 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80204c:	e8 8a fe ff ff       	call   801edb <alloc_sockfd>
}
  802051:	c9                   	leave  
  802052:	c3                   	ret    

00802053 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	53                   	push   %ebx
  802057:	83 ec 14             	sub    $0x14,%esp
  80205a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80205c:	83 3d b0 50 80 00 00 	cmpl   $0x0,0x8050b0
  802063:	75 11                	jne    802076 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802065:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80206c:	e8 c4 08 00 00       	call   802935 <ipc_find_env>
  802071:	a3 b0 50 80 00       	mov    %eax,0x8050b0
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802076:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80207d:	00 
  80207e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802085:	00 
  802086:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80208a:	a1 b0 50 80 00       	mov    0x8050b0,%eax
  80208f:	89 04 24             	mov    %eax,(%esp)
  802092:	e8 11 08 00 00       	call   8028a8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802097:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80209e:	00 
  80209f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8020a6:	00 
  8020a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020ae:	e8 8d 07 00 00       	call   802840 <ipc_recv>
}
  8020b3:	83 c4 14             	add    $0x14,%esp
  8020b6:	5b                   	pop    %ebx
  8020b7:	5d                   	pop    %ebp
  8020b8:	c3                   	ret    

008020b9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	56                   	push   %esi
  8020bd:	53                   	push   %ebx
  8020be:	83 ec 10             	sub    $0x10,%esp
  8020c1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020cc:	8b 06                	mov    (%esi),%eax
  8020ce:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d8:	e8 76 ff ff ff       	call   802053 <nsipc>
  8020dd:	89 c3                	mov    %eax,%ebx
  8020df:	85 c0                	test   %eax,%eax
  8020e1:	78 23                	js     802106 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020e3:	a1 10 70 80 00       	mov    0x807010,%eax
  8020e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020ec:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8020f3:	00 
  8020f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f7:	89 04 24             	mov    %eax,(%esp)
  8020fa:	e8 b5 ed ff ff       	call   800eb4 <memmove>
		*addrlen = ret->ret_addrlen;
  8020ff:	a1 10 70 80 00       	mov    0x807010,%eax
  802104:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802106:	89 d8                	mov    %ebx,%eax
  802108:	83 c4 10             	add    $0x10,%esp
  80210b:	5b                   	pop    %ebx
  80210c:	5e                   	pop    %esi
  80210d:	5d                   	pop    %ebp
  80210e:	c3                   	ret    

0080210f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	53                   	push   %ebx
  802113:	83 ec 14             	sub    $0x14,%esp
  802116:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802121:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802125:	8b 45 0c             	mov    0xc(%ebp),%eax
  802128:	89 44 24 04          	mov    %eax,0x4(%esp)
  80212c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802133:	e8 7c ed ff ff       	call   800eb4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802138:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80213e:	b8 02 00 00 00       	mov    $0x2,%eax
  802143:	e8 0b ff ff ff       	call   802053 <nsipc>
}
  802148:	83 c4 14             	add    $0x14,%esp
  80214b:	5b                   	pop    %ebx
  80214c:	5d                   	pop    %ebp
  80214d:	c3                   	ret    

0080214e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
  802151:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80215c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802164:	b8 03 00 00 00       	mov    $0x3,%eax
  802169:	e8 e5 fe ff ff       	call   802053 <nsipc>
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <nsipc_close>:

int
nsipc_close(int s)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80217e:	b8 04 00 00 00       	mov    $0x4,%eax
  802183:	e8 cb fe ff ff       	call   802053 <nsipc>
}
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
  80218d:	53                   	push   %ebx
  80218e:	83 ec 14             	sub    $0x14,%esp
  802191:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80219c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8021ae:	e8 01 ed ff ff       	call   800eb4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021b3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021b9:	b8 05 00 00 00       	mov    $0x5,%eax
  8021be:	e8 90 fe ff ff       	call   802053 <nsipc>
}
  8021c3:	83 c4 14             	add    $0x14,%esp
  8021c6:	5b                   	pop    %ebx
  8021c7:	5d                   	pop    %ebp
  8021c8:	c3                   	ret    

008021c9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
  8021cc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021da:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021df:	b8 06 00 00 00       	mov    $0x6,%eax
  8021e4:	e8 6a fe ff ff       	call   802053 <nsipc>
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	56                   	push   %esi
  8021ef:	53                   	push   %ebx
  8021f0:	83 ec 10             	sub    $0x10,%esp
  8021f3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021fe:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802204:	8b 45 14             	mov    0x14(%ebp),%eax
  802207:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80220c:	b8 07 00 00 00       	mov    $0x7,%eax
  802211:	e8 3d fe ff ff       	call   802053 <nsipc>
  802216:	89 c3                	mov    %eax,%ebx
  802218:	85 c0                	test   %eax,%eax
  80221a:	78 46                	js     802262 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80221c:	39 f0                	cmp    %esi,%eax
  80221e:	7f 07                	jg     802227 <nsipc_recv+0x3c>
  802220:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802225:	7e 24                	jle    80224b <nsipc_recv+0x60>
  802227:	c7 44 24 0c df 31 80 	movl   $0x8031df,0xc(%esp)
  80222e:	00 
  80222f:	c7 44 24 08 a7 31 80 	movl   $0x8031a7,0x8(%esp)
  802236:	00 
  802237:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80223e:	00 
  80223f:	c7 04 24 f4 31 80 00 	movl   $0x8031f4,(%esp)
  802246:	e8 b1 e3 ff ff       	call   8005fc <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80224b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80224f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802256:	00 
  802257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225a:	89 04 24             	mov    %eax,(%esp)
  80225d:	e8 52 ec ff ff       	call   800eb4 <memmove>
	}

	return r;
}
  802262:	89 d8                	mov    %ebx,%eax
  802264:	83 c4 10             	add    $0x10,%esp
  802267:	5b                   	pop    %ebx
  802268:	5e                   	pop    %esi
  802269:	5d                   	pop    %ebp
  80226a:	c3                   	ret    

0080226b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80226b:	55                   	push   %ebp
  80226c:	89 e5                	mov    %esp,%ebp
  80226e:	53                   	push   %ebx
  80226f:	83 ec 14             	sub    $0x14,%esp
  802272:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80227d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802283:	7e 24                	jle    8022a9 <nsipc_send+0x3e>
  802285:	c7 44 24 0c 00 32 80 	movl   $0x803200,0xc(%esp)
  80228c:	00 
  80228d:	c7 44 24 08 a7 31 80 	movl   $0x8031a7,0x8(%esp)
  802294:	00 
  802295:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80229c:	00 
  80229d:	c7 04 24 f4 31 80 00 	movl   $0x8031f4,(%esp)
  8022a4:	e8 53 e3 ff ff       	call   8005fc <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022b4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8022bb:	e8 f4 eb ff ff       	call   800eb4 <memmove>
	nsipcbuf.send.req_size = size;
  8022c0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8022c9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8022d3:	e8 7b fd ff ff       	call   802053 <nsipc>
}
  8022d8:	83 c4 14             	add    $0x14,%esp
  8022db:	5b                   	pop    %ebx
  8022dc:	5d                   	pop    %ebp
  8022dd:	c3                   	ret    

008022de <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
  8022e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8022ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ef:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8022f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8022fc:	b8 09 00 00 00       	mov    $0x9,%eax
  802301:	e8 4d fd ff ff       	call   802053 <nsipc>
}
  802306:	c9                   	leave  
  802307:	c3                   	ret    

00802308 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
  80230b:	56                   	push   %esi
  80230c:	53                   	push   %ebx
  80230d:	83 ec 10             	sub    $0x10,%esp
  802310:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	89 04 24             	mov    %eax,(%esp)
  802319:	e8 12 f2 ff ff       	call   801530 <fd2data>
  80231e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802320:	c7 44 24 04 0c 32 80 	movl   $0x80320c,0x4(%esp)
  802327:	00 
  802328:	89 1c 24             	mov    %ebx,(%esp)
  80232b:	e8 e7 e9 ff ff       	call   800d17 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802330:	8b 46 04             	mov    0x4(%esi),%eax
  802333:	2b 06                	sub    (%esi),%eax
  802335:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80233b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802342:	00 00 00 
	stat->st_dev = &devpipe;
  802345:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80234c:	40 80 00 
	return 0;
}
  80234f:	b8 00 00 00 00       	mov    $0x0,%eax
  802354:	83 c4 10             	add    $0x10,%esp
  802357:	5b                   	pop    %ebx
  802358:	5e                   	pop    %esi
  802359:	5d                   	pop    %ebp
  80235a:	c3                   	ret    

0080235b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
  80235e:	53                   	push   %ebx
  80235f:	83 ec 14             	sub    $0x14,%esp
  802362:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802365:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802369:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802370:	e8 65 ee ff ff       	call   8011da <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802375:	89 1c 24             	mov    %ebx,(%esp)
  802378:	e8 b3 f1 ff ff       	call   801530 <fd2data>
  80237d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802381:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802388:	e8 4d ee ff ff       	call   8011da <sys_page_unmap>
}
  80238d:	83 c4 14             	add    $0x14,%esp
  802390:	5b                   	pop    %ebx
  802391:	5d                   	pop    %ebp
  802392:	c3                   	ret    

00802393 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
  802396:	57                   	push   %edi
  802397:	56                   	push   %esi
  802398:	53                   	push   %ebx
  802399:	83 ec 2c             	sub    $0x2c,%esp
  80239c:	89 c6                	mov    %eax,%esi
  80239e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8023a1:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  8023a6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023a9:	89 34 24             	mov    %esi,(%esp)
  8023ac:	e8 be 05 00 00       	call   80296f <pageref>
  8023b1:	89 c7                	mov    %eax,%edi
  8023b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023b6:	89 04 24             	mov    %eax,(%esp)
  8023b9:	e8 b1 05 00 00       	call   80296f <pageref>
  8023be:	39 c7                	cmp    %eax,%edi
  8023c0:	0f 94 c2             	sete   %dl
  8023c3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8023c6:	8b 0d b4 50 80 00    	mov    0x8050b4,%ecx
  8023cc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8023cf:	39 fb                	cmp    %edi,%ebx
  8023d1:	74 21                	je     8023f4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8023d3:	84 d2                	test   %dl,%dl
  8023d5:	74 ca                	je     8023a1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023d7:	8b 51 58             	mov    0x58(%ecx),%edx
  8023da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023de:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023e6:	c7 04 24 13 32 80 00 	movl   $0x803213,(%esp)
  8023ed:	e8 03 e3 ff ff       	call   8006f5 <cprintf>
  8023f2:	eb ad                	jmp    8023a1 <_pipeisclosed+0xe>
	}
}
  8023f4:	83 c4 2c             	add    $0x2c,%esp
  8023f7:	5b                   	pop    %ebx
  8023f8:	5e                   	pop    %esi
  8023f9:	5f                   	pop    %edi
  8023fa:	5d                   	pop    %ebp
  8023fb:	c3                   	ret    

008023fc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
  8023ff:	57                   	push   %edi
  802400:	56                   	push   %esi
  802401:	53                   	push   %ebx
  802402:	83 ec 1c             	sub    $0x1c,%esp
  802405:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802408:	89 34 24             	mov    %esi,(%esp)
  80240b:	e8 20 f1 ff ff       	call   801530 <fd2data>
  802410:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802412:	bf 00 00 00 00       	mov    $0x0,%edi
  802417:	eb 45                	jmp    80245e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802419:	89 da                	mov    %ebx,%edx
  80241b:	89 f0                	mov    %esi,%eax
  80241d:	e8 71 ff ff ff       	call   802393 <_pipeisclosed>
  802422:	85 c0                	test   %eax,%eax
  802424:	75 41                	jne    802467 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802426:	e8 e9 ec ff ff       	call   801114 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80242b:	8b 43 04             	mov    0x4(%ebx),%eax
  80242e:	8b 0b                	mov    (%ebx),%ecx
  802430:	8d 51 20             	lea    0x20(%ecx),%edx
  802433:	39 d0                	cmp    %edx,%eax
  802435:	73 e2                	jae    802419 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802437:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80243a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80243e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802441:	99                   	cltd   
  802442:	c1 ea 1b             	shr    $0x1b,%edx
  802445:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802448:	83 e1 1f             	and    $0x1f,%ecx
  80244b:	29 d1                	sub    %edx,%ecx
  80244d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802451:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802455:	83 c0 01             	add    $0x1,%eax
  802458:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80245b:	83 c7 01             	add    $0x1,%edi
  80245e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802461:	75 c8                	jne    80242b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802463:	89 f8                	mov    %edi,%eax
  802465:	eb 05                	jmp    80246c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802467:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80246c:	83 c4 1c             	add    $0x1c,%esp
  80246f:	5b                   	pop    %ebx
  802470:	5e                   	pop    %esi
  802471:	5f                   	pop    %edi
  802472:	5d                   	pop    %ebp
  802473:	c3                   	ret    

00802474 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
  802477:	57                   	push   %edi
  802478:	56                   	push   %esi
  802479:	53                   	push   %ebx
  80247a:	83 ec 1c             	sub    $0x1c,%esp
  80247d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802480:	89 3c 24             	mov    %edi,(%esp)
  802483:	e8 a8 f0 ff ff       	call   801530 <fd2data>
  802488:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80248a:	be 00 00 00 00       	mov    $0x0,%esi
  80248f:	eb 3d                	jmp    8024ce <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802491:	85 f6                	test   %esi,%esi
  802493:	74 04                	je     802499 <devpipe_read+0x25>
				return i;
  802495:	89 f0                	mov    %esi,%eax
  802497:	eb 43                	jmp    8024dc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802499:	89 da                	mov    %ebx,%edx
  80249b:	89 f8                	mov    %edi,%eax
  80249d:	e8 f1 fe ff ff       	call   802393 <_pipeisclosed>
  8024a2:	85 c0                	test   %eax,%eax
  8024a4:	75 31                	jne    8024d7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8024a6:	e8 69 ec ff ff       	call   801114 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8024ab:	8b 03                	mov    (%ebx),%eax
  8024ad:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024b0:	74 df                	je     802491 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024b2:	99                   	cltd   
  8024b3:	c1 ea 1b             	shr    $0x1b,%edx
  8024b6:	01 d0                	add    %edx,%eax
  8024b8:	83 e0 1f             	and    $0x1f,%eax
  8024bb:	29 d0                	sub    %edx,%eax
  8024bd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024c5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024c8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024cb:	83 c6 01             	add    $0x1,%esi
  8024ce:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024d1:	75 d8                	jne    8024ab <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8024d3:	89 f0                	mov    %esi,%eax
  8024d5:	eb 05                	jmp    8024dc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024d7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8024dc:	83 c4 1c             	add    $0x1c,%esp
  8024df:	5b                   	pop    %ebx
  8024e0:	5e                   	pop    %esi
  8024e1:	5f                   	pop    %edi
  8024e2:	5d                   	pop    %ebp
  8024e3:	c3                   	ret    

008024e4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8024e4:	55                   	push   %ebp
  8024e5:	89 e5                	mov    %esp,%ebp
  8024e7:	56                   	push   %esi
  8024e8:	53                   	push   %ebx
  8024e9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8024ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024ef:	89 04 24             	mov    %eax,(%esp)
  8024f2:	e8 50 f0 ff ff       	call   801547 <fd_alloc>
  8024f7:	89 c2                	mov    %eax,%edx
  8024f9:	85 d2                	test   %edx,%edx
  8024fb:	0f 88 4d 01 00 00    	js     80264e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802501:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802508:	00 
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802510:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802517:	e8 17 ec ff ff       	call   801133 <sys_page_alloc>
  80251c:	89 c2                	mov    %eax,%edx
  80251e:	85 d2                	test   %edx,%edx
  802520:	0f 88 28 01 00 00    	js     80264e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802526:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802529:	89 04 24             	mov    %eax,(%esp)
  80252c:	e8 16 f0 ff ff       	call   801547 <fd_alloc>
  802531:	89 c3                	mov    %eax,%ebx
  802533:	85 c0                	test   %eax,%eax
  802535:	0f 88 fe 00 00 00    	js     802639 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80253b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802542:	00 
  802543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802546:	89 44 24 04          	mov    %eax,0x4(%esp)
  80254a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802551:	e8 dd eb ff ff       	call   801133 <sys_page_alloc>
  802556:	89 c3                	mov    %eax,%ebx
  802558:	85 c0                	test   %eax,%eax
  80255a:	0f 88 d9 00 00 00    	js     802639 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	89 04 24             	mov    %eax,(%esp)
  802566:	e8 c5 ef ff ff       	call   801530 <fd2data>
  80256b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80256d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802574:	00 
  802575:	89 44 24 04          	mov    %eax,0x4(%esp)
  802579:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802580:	e8 ae eb ff ff       	call   801133 <sys_page_alloc>
  802585:	89 c3                	mov    %eax,%ebx
  802587:	85 c0                	test   %eax,%eax
  802589:	0f 88 97 00 00 00    	js     802626 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80258f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802592:	89 04 24             	mov    %eax,(%esp)
  802595:	e8 96 ef ff ff       	call   801530 <fd2data>
  80259a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8025a1:	00 
  8025a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8025ad:	00 
  8025ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025b9:	e8 c9 eb ff ff       	call   801187 <sys_page_map>
  8025be:	89 c3                	mov    %eax,%ebx
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	78 52                	js     802616 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8025c4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8025d9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8025e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	89 04 24             	mov    %eax,(%esp)
  8025f4:	e8 27 ef ff ff       	call   801520 <fd2num>
  8025f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025fc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802601:	89 04 24             	mov    %eax,(%esp)
  802604:	e8 17 ef ff ff       	call   801520 <fd2num>
  802609:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80260c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80260f:	b8 00 00 00 00       	mov    $0x0,%eax
  802614:	eb 38                	jmp    80264e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802616:	89 74 24 04          	mov    %esi,0x4(%esp)
  80261a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802621:	e8 b4 eb ff ff       	call   8011da <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802626:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802629:	89 44 24 04          	mov    %eax,0x4(%esp)
  80262d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802634:	e8 a1 eb ff ff       	call   8011da <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802640:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802647:	e8 8e eb ff ff       	call   8011da <sys_page_unmap>
  80264c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80264e:	83 c4 30             	add    $0x30,%esp
  802651:	5b                   	pop    %ebx
  802652:	5e                   	pop    %esi
  802653:	5d                   	pop    %ebp
  802654:	c3                   	ret    

00802655 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802655:	55                   	push   %ebp
  802656:	89 e5                	mov    %esp,%ebp
  802658:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80265b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80265e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802662:	8b 45 08             	mov    0x8(%ebp),%eax
  802665:	89 04 24             	mov    %eax,(%esp)
  802668:	e8 29 ef ff ff       	call   801596 <fd_lookup>
  80266d:	89 c2                	mov    %eax,%edx
  80266f:	85 d2                	test   %edx,%edx
  802671:	78 15                	js     802688 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	89 04 24             	mov    %eax,(%esp)
  802679:	e8 b2 ee ff ff       	call   801530 <fd2data>
	return _pipeisclosed(fd, p);
  80267e:	89 c2                	mov    %eax,%edx
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	e8 0b fd ff ff       	call   802393 <_pipeisclosed>
}
  802688:	c9                   	leave  
  802689:	c3                   	ret    
  80268a:	66 90                	xchg   %ax,%ax
  80268c:	66 90                	xchg   %ax,%ax
  80268e:	66 90                	xchg   %ax,%ax

00802690 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802693:	b8 00 00 00 00       	mov    $0x0,%eax
  802698:	5d                   	pop    %ebp
  802699:	c3                   	ret    

0080269a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80269a:	55                   	push   %ebp
  80269b:	89 e5                	mov    %esp,%ebp
  80269d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8026a0:	c7 44 24 04 2b 32 80 	movl   $0x80322b,0x4(%esp)
  8026a7:	00 
  8026a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ab:	89 04 24             	mov    %eax,(%esp)
  8026ae:	e8 64 e6 ff ff       	call   800d17 <strcpy>
	return 0;
}
  8026b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b8:	c9                   	leave  
  8026b9:	c3                   	ret    

008026ba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
  8026bd:	57                   	push   %edi
  8026be:	56                   	push   %esi
  8026bf:	53                   	push   %ebx
  8026c0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026c6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8026cb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026d1:	eb 31                	jmp    802704 <devcons_write+0x4a>
		m = n - tot;
  8026d3:	8b 75 10             	mov    0x10(%ebp),%esi
  8026d6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8026d8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8026db:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8026e0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8026e3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8026e7:	03 45 0c             	add    0xc(%ebp),%eax
  8026ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ee:	89 3c 24             	mov    %edi,(%esp)
  8026f1:	e8 be e7 ff ff       	call   800eb4 <memmove>
		sys_cputs(buf, m);
  8026f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026fa:	89 3c 24             	mov    %edi,(%esp)
  8026fd:	e8 64 e9 ff ff       	call   801066 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802702:	01 f3                	add    %esi,%ebx
  802704:	89 d8                	mov    %ebx,%eax
  802706:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802709:	72 c8                	jb     8026d3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80270b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802711:	5b                   	pop    %ebx
  802712:	5e                   	pop    %esi
  802713:	5f                   	pop    %edi
  802714:	5d                   	pop    %ebp
  802715:	c3                   	ret    

00802716 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802716:	55                   	push   %ebp
  802717:	89 e5                	mov    %esp,%ebp
  802719:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80271c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802721:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802725:	75 07                	jne    80272e <devcons_read+0x18>
  802727:	eb 2a                	jmp    802753 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802729:	e8 e6 e9 ff ff       	call   801114 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80272e:	66 90                	xchg   %ax,%ax
  802730:	e8 4f e9 ff ff       	call   801084 <sys_cgetc>
  802735:	85 c0                	test   %eax,%eax
  802737:	74 f0                	je     802729 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802739:	85 c0                	test   %eax,%eax
  80273b:	78 16                	js     802753 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80273d:	83 f8 04             	cmp    $0x4,%eax
  802740:	74 0c                	je     80274e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802742:	8b 55 0c             	mov    0xc(%ebp),%edx
  802745:	88 02                	mov    %al,(%edx)
	return 1;
  802747:	b8 01 00 00 00       	mov    $0x1,%eax
  80274c:	eb 05                	jmp    802753 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80274e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802753:	c9                   	leave  
  802754:	c3                   	ret    

00802755 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802755:	55                   	push   %ebp
  802756:	89 e5                	mov    %esp,%ebp
  802758:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80275b:	8b 45 08             	mov    0x8(%ebp),%eax
  80275e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802761:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802768:	00 
  802769:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80276c:	89 04 24             	mov    %eax,(%esp)
  80276f:	e8 f2 e8 ff ff       	call   801066 <sys_cputs>
}
  802774:	c9                   	leave  
  802775:	c3                   	ret    

00802776 <getchar>:

int
getchar(void)
{
  802776:	55                   	push   %ebp
  802777:	89 e5                	mov    %esp,%ebp
  802779:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80277c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802783:	00 
  802784:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802787:	89 44 24 04          	mov    %eax,0x4(%esp)
  80278b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802792:	e8 93 f0 ff ff       	call   80182a <read>
	if (r < 0)
  802797:	85 c0                	test   %eax,%eax
  802799:	78 0f                	js     8027aa <getchar+0x34>
		return r;
	if (r < 1)
  80279b:	85 c0                	test   %eax,%eax
  80279d:	7e 06                	jle    8027a5 <getchar+0x2f>
		return -E_EOF;
	return c;
  80279f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8027a3:	eb 05                	jmp    8027aa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8027a5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8027aa:	c9                   	leave  
  8027ab:	c3                   	ret    

008027ac <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8027ac:	55                   	push   %ebp
  8027ad:	89 e5                	mov    %esp,%ebp
  8027af:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bc:	89 04 24             	mov    %eax,(%esp)
  8027bf:	e8 d2 ed ff ff       	call   801596 <fd_lookup>
  8027c4:	85 c0                	test   %eax,%eax
  8027c6:	78 11                	js     8027d9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027d1:	39 10                	cmp    %edx,(%eax)
  8027d3:	0f 94 c0             	sete   %al
  8027d6:	0f b6 c0             	movzbl %al,%eax
}
  8027d9:	c9                   	leave  
  8027da:	c3                   	ret    

008027db <opencons>:

int
opencons(void)
{
  8027db:	55                   	push   %ebp
  8027dc:	89 e5                	mov    %esp,%ebp
  8027de:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8027e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027e4:	89 04 24             	mov    %eax,(%esp)
  8027e7:	e8 5b ed ff ff       	call   801547 <fd_alloc>
		return r;
  8027ec:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8027ee:	85 c0                	test   %eax,%eax
  8027f0:	78 40                	js     802832 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027f2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027f9:	00 
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802801:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802808:	e8 26 e9 ff ff       	call   801133 <sys_page_alloc>
		return r;
  80280d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80280f:	85 c0                	test   %eax,%eax
  802811:	78 1f                	js     802832 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802813:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802828:	89 04 24             	mov    %eax,(%esp)
  80282b:	e8 f0 ec ff ff       	call   801520 <fd2num>
  802830:	89 c2                	mov    %eax,%edx
}
  802832:	89 d0                	mov    %edx,%eax
  802834:	c9                   	leave  
  802835:	c3                   	ret    
  802836:	66 90                	xchg   %ax,%ax
  802838:	66 90                	xchg   %ax,%ax
  80283a:	66 90                	xchg   %ax,%ax
  80283c:	66 90                	xchg   %ax,%ax
  80283e:	66 90                	xchg   %ax,%ax

00802840 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802840:	55                   	push   %ebp
  802841:	89 e5                	mov    %esp,%ebp
  802843:	56                   	push   %esi
  802844:	53                   	push   %ebx
  802845:	83 ec 10             	sub    $0x10,%esp
  802848:	8b 75 08             	mov    0x8(%ebp),%esi
  80284b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80284e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802851:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802853:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802858:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80285b:	89 04 24             	mov    %eax,(%esp)
  80285e:	e8 e6 ea ff ff       	call   801349 <sys_ipc_recv>
  802863:	85 c0                	test   %eax,%eax
  802865:	74 16                	je     80287d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802867:	85 f6                	test   %esi,%esi
  802869:	74 06                	je     802871 <ipc_recv+0x31>
			*from_env_store = 0;
  80286b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802871:	85 db                	test   %ebx,%ebx
  802873:	74 2c                	je     8028a1 <ipc_recv+0x61>
			*perm_store = 0;
  802875:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80287b:	eb 24                	jmp    8028a1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  80287d:	85 f6                	test   %esi,%esi
  80287f:	74 0a                	je     80288b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802881:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802886:	8b 40 74             	mov    0x74(%eax),%eax
  802889:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80288b:	85 db                	test   %ebx,%ebx
  80288d:	74 0a                	je     802899 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80288f:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  802894:	8b 40 78             	mov    0x78(%eax),%eax
  802897:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802899:	a1 b4 50 80 00       	mov    0x8050b4,%eax
  80289e:	8b 40 70             	mov    0x70(%eax),%eax
}
  8028a1:	83 c4 10             	add    $0x10,%esp
  8028a4:	5b                   	pop    %ebx
  8028a5:	5e                   	pop    %esi
  8028a6:	5d                   	pop    %ebp
  8028a7:	c3                   	ret    

008028a8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028a8:	55                   	push   %ebp
  8028a9:	89 e5                	mov    %esp,%ebp
  8028ab:	57                   	push   %edi
  8028ac:	56                   	push   %esi
  8028ad:	53                   	push   %ebx
  8028ae:	83 ec 1c             	sub    $0x1c,%esp
  8028b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8028b7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  8028ba:	85 db                	test   %ebx,%ebx
  8028bc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8028c1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  8028c4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d3:	89 04 24             	mov    %eax,(%esp)
  8028d6:	e8 4b ea ff ff       	call   801326 <sys_ipc_try_send>
	if (r == 0) return;
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	75 22                	jne    802901 <ipc_send+0x59>
  8028df:	eb 4c                	jmp    80292d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  8028e1:	84 d2                	test   %dl,%dl
  8028e3:	75 48                	jne    80292d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  8028e5:	e8 2a e8 ff ff       	call   801114 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  8028ea:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028ee:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f9:	89 04 24             	mov    %eax,(%esp)
  8028fc:	e8 25 ea ff ff       	call   801326 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802901:	85 c0                	test   %eax,%eax
  802903:	0f 94 c2             	sete   %dl
  802906:	74 d9                	je     8028e1 <ipc_send+0x39>
  802908:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80290b:	74 d4                	je     8028e1 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80290d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802911:	c7 44 24 08 37 32 80 	movl   $0x803237,0x8(%esp)
  802918:	00 
  802919:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802920:	00 
  802921:	c7 04 24 45 32 80 00 	movl   $0x803245,(%esp)
  802928:	e8 cf dc ff ff       	call   8005fc <_panic>
}
  80292d:	83 c4 1c             	add    $0x1c,%esp
  802930:	5b                   	pop    %ebx
  802931:	5e                   	pop    %esi
  802932:	5f                   	pop    %edi
  802933:	5d                   	pop    %ebp
  802934:	c3                   	ret    

00802935 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802935:	55                   	push   %ebp
  802936:	89 e5                	mov    %esp,%ebp
  802938:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80293b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802940:	89 c2                	mov    %eax,%edx
  802942:	c1 e2 07             	shl    $0x7,%edx
  802945:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80294b:	8b 52 50             	mov    0x50(%edx),%edx
  80294e:	39 ca                	cmp    %ecx,%edx
  802950:	75 0d                	jne    80295f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802952:	c1 e0 07             	shl    $0x7,%eax
  802955:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80295a:	8b 40 40             	mov    0x40(%eax),%eax
  80295d:	eb 0e                	jmp    80296d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80295f:	83 c0 01             	add    $0x1,%eax
  802962:	3d 00 04 00 00       	cmp    $0x400,%eax
  802967:	75 d7                	jne    802940 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802969:	66 b8 00 00          	mov    $0x0,%ax
}
  80296d:	5d                   	pop    %ebp
  80296e:	c3                   	ret    

0080296f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80296f:	55                   	push   %ebp
  802970:	89 e5                	mov    %esp,%ebp
  802972:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802975:	89 d0                	mov    %edx,%eax
  802977:	c1 e8 16             	shr    $0x16,%eax
  80297a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802981:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802986:	f6 c1 01             	test   $0x1,%cl
  802989:	74 1d                	je     8029a8 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80298b:	c1 ea 0c             	shr    $0xc,%edx
  80298e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802995:	f6 c2 01             	test   $0x1,%dl
  802998:	74 0e                	je     8029a8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80299a:	c1 ea 0c             	shr    $0xc,%edx
  80299d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8029a4:	ef 
  8029a5:	0f b7 c0             	movzwl %ax,%eax
}
  8029a8:	5d                   	pop    %ebp
  8029a9:	c3                   	ret    
  8029aa:	66 90                	xchg   %ax,%ax
  8029ac:	66 90                	xchg   %ax,%ax
  8029ae:	66 90                	xchg   %ax,%ax

008029b0 <__udivdi3>:
  8029b0:	55                   	push   %ebp
  8029b1:	57                   	push   %edi
  8029b2:	56                   	push   %esi
  8029b3:	83 ec 0c             	sub    $0xc,%esp
  8029b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8029ba:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8029be:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8029c2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8029c6:	85 c0                	test   %eax,%eax
  8029c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8029cc:	89 ea                	mov    %ebp,%edx
  8029ce:	89 0c 24             	mov    %ecx,(%esp)
  8029d1:	75 2d                	jne    802a00 <__udivdi3+0x50>
  8029d3:	39 e9                	cmp    %ebp,%ecx
  8029d5:	77 61                	ja     802a38 <__udivdi3+0x88>
  8029d7:	85 c9                	test   %ecx,%ecx
  8029d9:	89 ce                	mov    %ecx,%esi
  8029db:	75 0b                	jne    8029e8 <__udivdi3+0x38>
  8029dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8029e2:	31 d2                	xor    %edx,%edx
  8029e4:	f7 f1                	div    %ecx
  8029e6:	89 c6                	mov    %eax,%esi
  8029e8:	31 d2                	xor    %edx,%edx
  8029ea:	89 e8                	mov    %ebp,%eax
  8029ec:	f7 f6                	div    %esi
  8029ee:	89 c5                	mov    %eax,%ebp
  8029f0:	89 f8                	mov    %edi,%eax
  8029f2:	f7 f6                	div    %esi
  8029f4:	89 ea                	mov    %ebp,%edx
  8029f6:	83 c4 0c             	add    $0xc,%esp
  8029f9:	5e                   	pop    %esi
  8029fa:	5f                   	pop    %edi
  8029fb:	5d                   	pop    %ebp
  8029fc:	c3                   	ret    
  8029fd:	8d 76 00             	lea    0x0(%esi),%esi
  802a00:	39 e8                	cmp    %ebp,%eax
  802a02:	77 24                	ja     802a28 <__udivdi3+0x78>
  802a04:	0f bd e8             	bsr    %eax,%ebp
  802a07:	83 f5 1f             	xor    $0x1f,%ebp
  802a0a:	75 3c                	jne    802a48 <__udivdi3+0x98>
  802a0c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802a10:	39 34 24             	cmp    %esi,(%esp)
  802a13:	0f 86 9f 00 00 00    	jbe    802ab8 <__udivdi3+0x108>
  802a19:	39 d0                	cmp    %edx,%eax
  802a1b:	0f 82 97 00 00 00    	jb     802ab8 <__udivdi3+0x108>
  802a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a28:	31 d2                	xor    %edx,%edx
  802a2a:	31 c0                	xor    %eax,%eax
  802a2c:	83 c4 0c             	add    $0xc,%esp
  802a2f:	5e                   	pop    %esi
  802a30:	5f                   	pop    %edi
  802a31:	5d                   	pop    %ebp
  802a32:	c3                   	ret    
  802a33:	90                   	nop
  802a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a38:	89 f8                	mov    %edi,%eax
  802a3a:	f7 f1                	div    %ecx
  802a3c:	31 d2                	xor    %edx,%edx
  802a3e:	83 c4 0c             	add    $0xc,%esp
  802a41:	5e                   	pop    %esi
  802a42:	5f                   	pop    %edi
  802a43:	5d                   	pop    %ebp
  802a44:	c3                   	ret    
  802a45:	8d 76 00             	lea    0x0(%esi),%esi
  802a48:	89 e9                	mov    %ebp,%ecx
  802a4a:	8b 3c 24             	mov    (%esp),%edi
  802a4d:	d3 e0                	shl    %cl,%eax
  802a4f:	89 c6                	mov    %eax,%esi
  802a51:	b8 20 00 00 00       	mov    $0x20,%eax
  802a56:	29 e8                	sub    %ebp,%eax
  802a58:	89 c1                	mov    %eax,%ecx
  802a5a:	d3 ef                	shr    %cl,%edi
  802a5c:	89 e9                	mov    %ebp,%ecx
  802a5e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802a62:	8b 3c 24             	mov    (%esp),%edi
  802a65:	09 74 24 08          	or     %esi,0x8(%esp)
  802a69:	89 d6                	mov    %edx,%esi
  802a6b:	d3 e7                	shl    %cl,%edi
  802a6d:	89 c1                	mov    %eax,%ecx
  802a6f:	89 3c 24             	mov    %edi,(%esp)
  802a72:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a76:	d3 ee                	shr    %cl,%esi
  802a78:	89 e9                	mov    %ebp,%ecx
  802a7a:	d3 e2                	shl    %cl,%edx
  802a7c:	89 c1                	mov    %eax,%ecx
  802a7e:	d3 ef                	shr    %cl,%edi
  802a80:	09 d7                	or     %edx,%edi
  802a82:	89 f2                	mov    %esi,%edx
  802a84:	89 f8                	mov    %edi,%eax
  802a86:	f7 74 24 08          	divl   0x8(%esp)
  802a8a:	89 d6                	mov    %edx,%esi
  802a8c:	89 c7                	mov    %eax,%edi
  802a8e:	f7 24 24             	mull   (%esp)
  802a91:	39 d6                	cmp    %edx,%esi
  802a93:	89 14 24             	mov    %edx,(%esp)
  802a96:	72 30                	jb     802ac8 <__udivdi3+0x118>
  802a98:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a9c:	89 e9                	mov    %ebp,%ecx
  802a9e:	d3 e2                	shl    %cl,%edx
  802aa0:	39 c2                	cmp    %eax,%edx
  802aa2:	73 05                	jae    802aa9 <__udivdi3+0xf9>
  802aa4:	3b 34 24             	cmp    (%esp),%esi
  802aa7:	74 1f                	je     802ac8 <__udivdi3+0x118>
  802aa9:	89 f8                	mov    %edi,%eax
  802aab:	31 d2                	xor    %edx,%edx
  802aad:	e9 7a ff ff ff       	jmp    802a2c <__udivdi3+0x7c>
  802ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ab8:	31 d2                	xor    %edx,%edx
  802aba:	b8 01 00 00 00       	mov    $0x1,%eax
  802abf:	e9 68 ff ff ff       	jmp    802a2c <__udivdi3+0x7c>
  802ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ac8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802acb:	31 d2                	xor    %edx,%edx
  802acd:	83 c4 0c             	add    $0xc,%esp
  802ad0:	5e                   	pop    %esi
  802ad1:	5f                   	pop    %edi
  802ad2:	5d                   	pop    %ebp
  802ad3:	c3                   	ret    
  802ad4:	66 90                	xchg   %ax,%ax
  802ad6:	66 90                	xchg   %ax,%ax
  802ad8:	66 90                	xchg   %ax,%ax
  802ada:	66 90                	xchg   %ax,%ax
  802adc:	66 90                	xchg   %ax,%ax
  802ade:	66 90                	xchg   %ax,%ax

00802ae0 <__umoddi3>:
  802ae0:	55                   	push   %ebp
  802ae1:	57                   	push   %edi
  802ae2:	56                   	push   %esi
  802ae3:	83 ec 14             	sub    $0x14,%esp
  802ae6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802aea:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802aee:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802af2:	89 c7                	mov    %eax,%edi
  802af4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802af8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802afc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802b00:	89 34 24             	mov    %esi,(%esp)
  802b03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b07:	85 c0                	test   %eax,%eax
  802b09:	89 c2                	mov    %eax,%edx
  802b0b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b0f:	75 17                	jne    802b28 <__umoddi3+0x48>
  802b11:	39 fe                	cmp    %edi,%esi
  802b13:	76 4b                	jbe    802b60 <__umoddi3+0x80>
  802b15:	89 c8                	mov    %ecx,%eax
  802b17:	89 fa                	mov    %edi,%edx
  802b19:	f7 f6                	div    %esi
  802b1b:	89 d0                	mov    %edx,%eax
  802b1d:	31 d2                	xor    %edx,%edx
  802b1f:	83 c4 14             	add    $0x14,%esp
  802b22:	5e                   	pop    %esi
  802b23:	5f                   	pop    %edi
  802b24:	5d                   	pop    %ebp
  802b25:	c3                   	ret    
  802b26:	66 90                	xchg   %ax,%ax
  802b28:	39 f8                	cmp    %edi,%eax
  802b2a:	77 54                	ja     802b80 <__umoddi3+0xa0>
  802b2c:	0f bd e8             	bsr    %eax,%ebp
  802b2f:	83 f5 1f             	xor    $0x1f,%ebp
  802b32:	75 5c                	jne    802b90 <__umoddi3+0xb0>
  802b34:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802b38:	39 3c 24             	cmp    %edi,(%esp)
  802b3b:	0f 87 e7 00 00 00    	ja     802c28 <__umoddi3+0x148>
  802b41:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b45:	29 f1                	sub    %esi,%ecx
  802b47:	19 c7                	sbb    %eax,%edi
  802b49:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b51:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b55:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802b59:	83 c4 14             	add    $0x14,%esp
  802b5c:	5e                   	pop    %esi
  802b5d:	5f                   	pop    %edi
  802b5e:	5d                   	pop    %ebp
  802b5f:	c3                   	ret    
  802b60:	85 f6                	test   %esi,%esi
  802b62:	89 f5                	mov    %esi,%ebp
  802b64:	75 0b                	jne    802b71 <__umoddi3+0x91>
  802b66:	b8 01 00 00 00       	mov    $0x1,%eax
  802b6b:	31 d2                	xor    %edx,%edx
  802b6d:	f7 f6                	div    %esi
  802b6f:	89 c5                	mov    %eax,%ebp
  802b71:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b75:	31 d2                	xor    %edx,%edx
  802b77:	f7 f5                	div    %ebp
  802b79:	89 c8                	mov    %ecx,%eax
  802b7b:	f7 f5                	div    %ebp
  802b7d:	eb 9c                	jmp    802b1b <__umoddi3+0x3b>
  802b7f:	90                   	nop
  802b80:	89 c8                	mov    %ecx,%eax
  802b82:	89 fa                	mov    %edi,%edx
  802b84:	83 c4 14             	add    $0x14,%esp
  802b87:	5e                   	pop    %esi
  802b88:	5f                   	pop    %edi
  802b89:	5d                   	pop    %ebp
  802b8a:	c3                   	ret    
  802b8b:	90                   	nop
  802b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b90:	8b 04 24             	mov    (%esp),%eax
  802b93:	be 20 00 00 00       	mov    $0x20,%esi
  802b98:	89 e9                	mov    %ebp,%ecx
  802b9a:	29 ee                	sub    %ebp,%esi
  802b9c:	d3 e2                	shl    %cl,%edx
  802b9e:	89 f1                	mov    %esi,%ecx
  802ba0:	d3 e8                	shr    %cl,%eax
  802ba2:	89 e9                	mov    %ebp,%ecx
  802ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ba8:	8b 04 24             	mov    (%esp),%eax
  802bab:	09 54 24 04          	or     %edx,0x4(%esp)
  802baf:	89 fa                	mov    %edi,%edx
  802bb1:	d3 e0                	shl    %cl,%eax
  802bb3:	89 f1                	mov    %esi,%ecx
  802bb5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bb9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802bbd:	d3 ea                	shr    %cl,%edx
  802bbf:	89 e9                	mov    %ebp,%ecx
  802bc1:	d3 e7                	shl    %cl,%edi
  802bc3:	89 f1                	mov    %esi,%ecx
  802bc5:	d3 e8                	shr    %cl,%eax
  802bc7:	89 e9                	mov    %ebp,%ecx
  802bc9:	09 f8                	or     %edi,%eax
  802bcb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802bcf:	f7 74 24 04          	divl   0x4(%esp)
  802bd3:	d3 e7                	shl    %cl,%edi
  802bd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bd9:	89 d7                	mov    %edx,%edi
  802bdb:	f7 64 24 08          	mull   0x8(%esp)
  802bdf:	39 d7                	cmp    %edx,%edi
  802be1:	89 c1                	mov    %eax,%ecx
  802be3:	89 14 24             	mov    %edx,(%esp)
  802be6:	72 2c                	jb     802c14 <__umoddi3+0x134>
  802be8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802bec:	72 22                	jb     802c10 <__umoddi3+0x130>
  802bee:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802bf2:	29 c8                	sub    %ecx,%eax
  802bf4:	19 d7                	sbb    %edx,%edi
  802bf6:	89 e9                	mov    %ebp,%ecx
  802bf8:	89 fa                	mov    %edi,%edx
  802bfa:	d3 e8                	shr    %cl,%eax
  802bfc:	89 f1                	mov    %esi,%ecx
  802bfe:	d3 e2                	shl    %cl,%edx
  802c00:	89 e9                	mov    %ebp,%ecx
  802c02:	d3 ef                	shr    %cl,%edi
  802c04:	09 d0                	or     %edx,%eax
  802c06:	89 fa                	mov    %edi,%edx
  802c08:	83 c4 14             	add    $0x14,%esp
  802c0b:	5e                   	pop    %esi
  802c0c:	5f                   	pop    %edi
  802c0d:	5d                   	pop    %ebp
  802c0e:	c3                   	ret    
  802c0f:	90                   	nop
  802c10:	39 d7                	cmp    %edx,%edi
  802c12:	75 da                	jne    802bee <__umoddi3+0x10e>
  802c14:	8b 14 24             	mov    (%esp),%edx
  802c17:	89 c1                	mov    %eax,%ecx
  802c19:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802c1d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802c21:	eb cb                	jmp    802bee <__umoddi3+0x10e>
  802c23:	90                   	nop
  802c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c28:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802c2c:	0f 82 0f ff ff ff    	jb     802b41 <__umoddi3+0x61>
  802c32:	e9 1a ff ff ff       	jmp    802b51 <__umoddi3+0x71>
