
obj/user/faultevilhandler.debug:     file format elf32-i386


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
  80002c:	e8 44 00 00 00       	call   800075 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800039:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800040:	00 
  800041:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  800048:	ee 
  800049:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800050:	e8 4e 01 00 00       	call   8001a3 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  800055:	c7 44 24 04 20 00 10 	movl   $0xf0100020,0x4(%esp)
  80005c:	f0 
  80005d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800064:	e8 da 02 00 00       	call   800343 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800069:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800070:	00 00 00 
}
  800073:	c9                   	leave  
  800074:	c3                   	ret    

00800075 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800075:	55                   	push   %ebp
  800076:	89 e5                	mov    %esp,%ebp
  800078:	56                   	push   %esi
  800079:	53                   	push   %ebx
  80007a:	83 ec 10             	sub    $0x10,%esp
  80007d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800080:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800083:	e8 dd 00 00 00       	call   800165 <sys_getenvid>
  800088:	25 ff 03 00 00       	and    $0x3ff,%eax
  80008d:	c1 e0 07             	shl    $0x7,%eax
  800090:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800095:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009a:	85 db                	test   %ebx,%ebx
  80009c:	7e 07                	jle    8000a5 <libmain+0x30>
		binaryname = argv[0];
  80009e:	8b 06                	mov    (%esi),%eax
  8000a0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000a5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000a9:	89 1c 24             	mov    %ebx,(%esp)
  8000ac:	e8 82 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b1:	e8 07 00 00 00       	call   8000bd <exit>
}
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	5b                   	pop    %ebx
  8000ba:	5e                   	pop    %esi
  8000bb:	5d                   	pop    %ebp
  8000bc:	c3                   	ret    

008000bd <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000bd:	55                   	push   %ebp
  8000be:	89 e5                	mov    %esp,%ebp
  8000c0:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000c3:	e8 02 06 00 00       	call   8006ca <close_all>
	sys_env_destroy(0);
  8000c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000cf:	e8 3f 00 00 00       	call   800113 <sys_env_destroy>
}
  8000d4:	c9                   	leave  
  8000d5:	c3                   	ret    

008000d6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000d6:	55                   	push   %ebp
  8000d7:	89 e5                	mov    %esp,%ebp
  8000d9:	57                   	push   %edi
  8000da:	56                   	push   %esi
  8000db:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e7:	89 c3                	mov    %eax,%ebx
  8000e9:	89 c7                	mov    %eax,%edi
  8000eb:	89 c6                	mov    %eax,%esi
  8000ed:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000ef:	5b                   	pop    %ebx
  8000f0:	5e                   	pop    %esi
  8000f1:	5f                   	pop    %edi
  8000f2:	5d                   	pop    %ebp
  8000f3:	c3                   	ret    

008000f4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	57                   	push   %edi
  8000f8:	56                   	push   %esi
  8000f9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ff:	b8 01 00 00 00       	mov    $0x1,%eax
  800104:	89 d1                	mov    %edx,%ecx
  800106:	89 d3                	mov    %edx,%ebx
  800108:	89 d7                	mov    %edx,%edi
  80010a:	89 d6                	mov    %edx,%esi
  80010c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80010e:	5b                   	pop    %ebx
  80010f:	5e                   	pop    %esi
  800110:	5f                   	pop    %edi
  800111:	5d                   	pop    %ebp
  800112:	c3                   	ret    

00800113 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800113:	55                   	push   %ebp
  800114:	89 e5                	mov    %esp,%ebp
  800116:	57                   	push   %edi
  800117:	56                   	push   %esi
  800118:	53                   	push   %ebx
  800119:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80011c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800121:	b8 03 00 00 00       	mov    $0x3,%eax
  800126:	8b 55 08             	mov    0x8(%ebp),%edx
  800129:	89 cb                	mov    %ecx,%ebx
  80012b:	89 cf                	mov    %ecx,%edi
  80012d:	89 ce                	mov    %ecx,%esi
  80012f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800131:	85 c0                	test   %eax,%eax
  800133:	7e 28                	jle    80015d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800135:	89 44 24 10          	mov    %eax,0x10(%esp)
  800139:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800140:	00 
  800141:	c7 44 24 08 8a 26 80 	movl   $0x80268a,0x8(%esp)
  800148:	00 
  800149:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800150:	00 
  800151:	c7 04 24 a7 26 80 00 	movl   $0x8026a7,(%esp)
  800158:	e8 a9 16 00 00       	call   801806 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80015d:	83 c4 2c             	add    $0x2c,%esp
  800160:	5b                   	pop    %ebx
  800161:	5e                   	pop    %esi
  800162:	5f                   	pop    %edi
  800163:	5d                   	pop    %ebp
  800164:	c3                   	ret    

00800165 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	57                   	push   %edi
  800169:	56                   	push   %esi
  80016a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80016b:	ba 00 00 00 00       	mov    $0x0,%edx
  800170:	b8 02 00 00 00       	mov    $0x2,%eax
  800175:	89 d1                	mov    %edx,%ecx
  800177:	89 d3                	mov    %edx,%ebx
  800179:	89 d7                	mov    %edx,%edi
  80017b:	89 d6                	mov    %edx,%esi
  80017d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80017f:	5b                   	pop    %ebx
  800180:	5e                   	pop    %esi
  800181:	5f                   	pop    %edi
  800182:	5d                   	pop    %ebp
  800183:	c3                   	ret    

00800184 <sys_yield>:

void
sys_yield(void)
{
  800184:	55                   	push   %ebp
  800185:	89 e5                	mov    %esp,%ebp
  800187:	57                   	push   %edi
  800188:	56                   	push   %esi
  800189:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80018a:	ba 00 00 00 00       	mov    $0x0,%edx
  80018f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800194:	89 d1                	mov    %edx,%ecx
  800196:	89 d3                	mov    %edx,%ebx
  800198:	89 d7                	mov    %edx,%edi
  80019a:	89 d6                	mov    %edx,%esi
  80019c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80019e:	5b                   	pop    %ebx
  80019f:	5e                   	pop    %esi
  8001a0:	5f                   	pop    %edi
  8001a1:	5d                   	pop    %ebp
  8001a2:	c3                   	ret    

008001a3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001a3:	55                   	push   %ebp
  8001a4:	89 e5                	mov    %esp,%ebp
  8001a6:	57                   	push   %edi
  8001a7:	56                   	push   %esi
  8001a8:	53                   	push   %ebx
  8001a9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001ac:	be 00 00 00 00       	mov    $0x0,%esi
  8001b1:	b8 04 00 00 00       	mov    $0x4,%eax
  8001b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001bf:	89 f7                	mov    %esi,%edi
  8001c1:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8001c3:	85 c0                	test   %eax,%eax
  8001c5:	7e 28                	jle    8001ef <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001cb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8001d2:	00 
  8001d3:	c7 44 24 08 8a 26 80 	movl   $0x80268a,0x8(%esp)
  8001da:	00 
  8001db:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001e2:	00 
  8001e3:	c7 04 24 a7 26 80 00 	movl   $0x8026a7,(%esp)
  8001ea:	e8 17 16 00 00       	call   801806 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001ef:	83 c4 2c             	add    $0x2c,%esp
  8001f2:	5b                   	pop    %ebx
  8001f3:	5e                   	pop    %esi
  8001f4:	5f                   	pop    %edi
  8001f5:	5d                   	pop    %ebp
  8001f6:	c3                   	ret    

008001f7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001f7:	55                   	push   %ebp
  8001f8:	89 e5                	mov    %esp,%ebp
  8001fa:	57                   	push   %edi
  8001fb:	56                   	push   %esi
  8001fc:	53                   	push   %ebx
  8001fd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800200:	b8 05 00 00 00       	mov    $0x5,%eax
  800205:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800208:	8b 55 08             	mov    0x8(%ebp),%edx
  80020b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80020e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800211:	8b 75 18             	mov    0x18(%ebp),%esi
  800214:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800216:	85 c0                	test   %eax,%eax
  800218:	7e 28                	jle    800242 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80021a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80021e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800225:	00 
  800226:	c7 44 24 08 8a 26 80 	movl   $0x80268a,0x8(%esp)
  80022d:	00 
  80022e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800235:	00 
  800236:	c7 04 24 a7 26 80 00 	movl   $0x8026a7,(%esp)
  80023d:	e8 c4 15 00 00       	call   801806 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800242:	83 c4 2c             	add    $0x2c,%esp
  800245:	5b                   	pop    %ebx
  800246:	5e                   	pop    %esi
  800247:	5f                   	pop    %edi
  800248:	5d                   	pop    %ebp
  800249:	c3                   	ret    

0080024a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	57                   	push   %edi
  80024e:	56                   	push   %esi
  80024f:	53                   	push   %ebx
  800250:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800253:	bb 00 00 00 00       	mov    $0x0,%ebx
  800258:	b8 06 00 00 00       	mov    $0x6,%eax
  80025d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800260:	8b 55 08             	mov    0x8(%ebp),%edx
  800263:	89 df                	mov    %ebx,%edi
  800265:	89 de                	mov    %ebx,%esi
  800267:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800269:	85 c0                	test   %eax,%eax
  80026b:	7e 28                	jle    800295 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80026d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800271:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800278:	00 
  800279:	c7 44 24 08 8a 26 80 	movl   $0x80268a,0x8(%esp)
  800280:	00 
  800281:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800288:	00 
  800289:	c7 04 24 a7 26 80 00 	movl   $0x8026a7,(%esp)
  800290:	e8 71 15 00 00       	call   801806 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800295:	83 c4 2c             	add    $0x2c,%esp
  800298:	5b                   	pop    %ebx
  800299:	5e                   	pop    %esi
  80029a:	5f                   	pop    %edi
  80029b:	5d                   	pop    %ebp
  80029c:	c3                   	ret    

0080029d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	57                   	push   %edi
  8002a1:	56                   	push   %esi
  8002a2:	53                   	push   %ebx
  8002a3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ab:	b8 08 00 00 00       	mov    $0x8,%eax
  8002b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b6:	89 df                	mov    %ebx,%edi
  8002b8:	89 de                	mov    %ebx,%esi
  8002ba:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8002bc:	85 c0                	test   %eax,%eax
  8002be:	7e 28                	jle    8002e8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002c4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8002cb:	00 
  8002cc:	c7 44 24 08 8a 26 80 	movl   $0x80268a,0x8(%esp)
  8002d3:	00 
  8002d4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002db:	00 
  8002dc:	c7 04 24 a7 26 80 00 	movl   $0x8026a7,(%esp)
  8002e3:	e8 1e 15 00 00       	call   801806 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002e8:	83 c4 2c             	add    $0x2c,%esp
  8002eb:	5b                   	pop    %ebx
  8002ec:	5e                   	pop    %esi
  8002ed:	5f                   	pop    %edi
  8002ee:	5d                   	pop    %ebp
  8002ef:	c3                   	ret    

008002f0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	57                   	push   %edi
  8002f4:	56                   	push   %esi
  8002f5:	53                   	push   %ebx
  8002f6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002fe:	b8 09 00 00 00       	mov    $0x9,%eax
  800303:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800306:	8b 55 08             	mov    0x8(%ebp),%edx
  800309:	89 df                	mov    %ebx,%edi
  80030b:	89 de                	mov    %ebx,%esi
  80030d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80030f:	85 c0                	test   %eax,%eax
  800311:	7e 28                	jle    80033b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800313:	89 44 24 10          	mov    %eax,0x10(%esp)
  800317:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80031e:	00 
  80031f:	c7 44 24 08 8a 26 80 	movl   $0x80268a,0x8(%esp)
  800326:	00 
  800327:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80032e:	00 
  80032f:	c7 04 24 a7 26 80 00 	movl   $0x8026a7,(%esp)
  800336:	e8 cb 14 00 00       	call   801806 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80033b:	83 c4 2c             	add    $0x2c,%esp
  80033e:	5b                   	pop    %ebx
  80033f:	5e                   	pop    %esi
  800340:	5f                   	pop    %edi
  800341:	5d                   	pop    %ebp
  800342:	c3                   	ret    

00800343 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800343:	55                   	push   %ebp
  800344:	89 e5                	mov    %esp,%ebp
  800346:	57                   	push   %edi
  800347:	56                   	push   %esi
  800348:	53                   	push   %ebx
  800349:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80034c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800351:	b8 0a 00 00 00       	mov    $0xa,%eax
  800356:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800359:	8b 55 08             	mov    0x8(%ebp),%edx
  80035c:	89 df                	mov    %ebx,%edi
  80035e:	89 de                	mov    %ebx,%esi
  800360:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800362:	85 c0                	test   %eax,%eax
  800364:	7e 28                	jle    80038e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800366:	89 44 24 10          	mov    %eax,0x10(%esp)
  80036a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800371:	00 
  800372:	c7 44 24 08 8a 26 80 	movl   $0x80268a,0x8(%esp)
  800379:	00 
  80037a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800381:	00 
  800382:	c7 04 24 a7 26 80 00 	movl   $0x8026a7,(%esp)
  800389:	e8 78 14 00 00       	call   801806 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80038e:	83 c4 2c             	add    $0x2c,%esp
  800391:	5b                   	pop    %ebx
  800392:	5e                   	pop    %esi
  800393:	5f                   	pop    %edi
  800394:	5d                   	pop    %ebp
  800395:	c3                   	ret    

00800396 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	57                   	push   %edi
  80039a:	56                   	push   %esi
  80039b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80039c:	be 00 00 00 00       	mov    $0x0,%esi
  8003a1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8003a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003af:	8b 7d 14             	mov    0x14(%ebp),%edi
  8003b2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8003b4:	5b                   	pop    %ebx
  8003b5:	5e                   	pop    %esi
  8003b6:	5f                   	pop    %edi
  8003b7:	5d                   	pop    %ebp
  8003b8:	c3                   	ret    

008003b9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8003b9:	55                   	push   %ebp
  8003ba:	89 e5                	mov    %esp,%ebp
  8003bc:	57                   	push   %edi
  8003bd:	56                   	push   %esi
  8003be:	53                   	push   %ebx
  8003bf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003c7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8003cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8003cf:	89 cb                	mov    %ecx,%ebx
  8003d1:	89 cf                	mov    %ecx,%edi
  8003d3:	89 ce                	mov    %ecx,%esi
  8003d5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8003d7:	85 c0                	test   %eax,%eax
  8003d9:	7e 28                	jle    800403 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003db:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003df:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8003e6:	00 
  8003e7:	c7 44 24 08 8a 26 80 	movl   $0x80268a,0x8(%esp)
  8003ee:	00 
  8003ef:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003f6:	00 
  8003f7:	c7 04 24 a7 26 80 00 	movl   $0x8026a7,(%esp)
  8003fe:	e8 03 14 00 00       	call   801806 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800403:	83 c4 2c             	add    $0x2c,%esp
  800406:	5b                   	pop    %ebx
  800407:	5e                   	pop    %esi
  800408:	5f                   	pop    %edi
  800409:	5d                   	pop    %ebp
  80040a:	c3                   	ret    

0080040b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80040b:	55                   	push   %ebp
  80040c:	89 e5                	mov    %esp,%ebp
  80040e:	57                   	push   %edi
  80040f:	56                   	push   %esi
  800410:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800411:	ba 00 00 00 00       	mov    $0x0,%edx
  800416:	b8 0e 00 00 00       	mov    $0xe,%eax
  80041b:	89 d1                	mov    %edx,%ecx
  80041d:	89 d3                	mov    %edx,%ebx
  80041f:	89 d7                	mov    %edx,%edi
  800421:	89 d6                	mov    %edx,%esi
  800423:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800425:	5b                   	pop    %ebx
  800426:	5e                   	pop    %esi
  800427:	5f                   	pop    %edi
  800428:	5d                   	pop    %ebp
  800429:	c3                   	ret    

0080042a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	57                   	push   %edi
  80042e:	56                   	push   %esi
  80042f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800430:	bb 00 00 00 00       	mov    $0x0,%ebx
  800435:	b8 0f 00 00 00       	mov    $0xf,%eax
  80043a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80043d:	8b 55 08             	mov    0x8(%ebp),%edx
  800440:	89 df                	mov    %ebx,%edi
  800442:	89 de                	mov    %ebx,%esi
  800444:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800446:	5b                   	pop    %ebx
  800447:	5e                   	pop    %esi
  800448:	5f                   	pop    %edi
  800449:	5d                   	pop    %ebp
  80044a:	c3                   	ret    

0080044b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  80044b:	55                   	push   %ebp
  80044c:	89 e5                	mov    %esp,%ebp
  80044e:	57                   	push   %edi
  80044f:	56                   	push   %esi
  800450:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800451:	bb 00 00 00 00       	mov    $0x0,%ebx
  800456:	b8 10 00 00 00       	mov    $0x10,%eax
  80045b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80045e:	8b 55 08             	mov    0x8(%ebp),%edx
  800461:	89 df                	mov    %ebx,%edi
  800463:	89 de                	mov    %ebx,%esi
  800465:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800467:	5b                   	pop    %ebx
  800468:	5e                   	pop    %esi
  800469:	5f                   	pop    %edi
  80046a:	5d                   	pop    %ebp
  80046b:	c3                   	ret    

0080046c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	57                   	push   %edi
  800470:	56                   	push   %esi
  800471:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800472:	b9 00 00 00 00       	mov    $0x0,%ecx
  800477:	b8 11 00 00 00       	mov    $0x11,%eax
  80047c:	8b 55 08             	mov    0x8(%ebp),%edx
  80047f:	89 cb                	mov    %ecx,%ebx
  800481:	89 cf                	mov    %ecx,%edi
  800483:	89 ce                	mov    %ecx,%esi
  800485:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800487:	5b                   	pop    %ebx
  800488:	5e                   	pop    %esi
  800489:	5f                   	pop    %edi
  80048a:	5d                   	pop    %ebp
  80048b:	c3                   	ret    

0080048c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  80048c:	55                   	push   %ebp
  80048d:	89 e5                	mov    %esp,%ebp
  80048f:	57                   	push   %edi
  800490:	56                   	push   %esi
  800491:	53                   	push   %ebx
  800492:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800495:	be 00 00 00 00       	mov    $0x0,%esi
  80049a:	b8 12 00 00 00       	mov    $0x12,%eax
  80049f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004a8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8004ab:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8004ad:	85 c0                	test   %eax,%eax
  8004af:	7e 28                	jle    8004d9 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  8004b1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004b5:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  8004bc:	00 
  8004bd:	c7 44 24 08 8a 26 80 	movl   $0x80268a,0x8(%esp)
  8004c4:	00 
  8004c5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004cc:	00 
  8004cd:	c7 04 24 a7 26 80 00 	movl   $0x8026a7,(%esp)
  8004d4:	e8 2d 13 00 00       	call   801806 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  8004d9:	83 c4 2c             	add    $0x2c,%esp
  8004dc:	5b                   	pop    %ebx
  8004dd:	5e                   	pop    %esi
  8004de:	5f                   	pop    %edi
  8004df:	5d                   	pop    %ebp
  8004e0:	c3                   	ret    
  8004e1:	66 90                	xchg   %ax,%ax
  8004e3:	66 90                	xchg   %ax,%ax
  8004e5:	66 90                	xchg   %ax,%ax
  8004e7:	66 90                	xchg   %ax,%ax
  8004e9:	66 90                	xchg   %ax,%ax
  8004eb:	66 90                	xchg   %ax,%ax
  8004ed:	66 90                	xchg   %ax,%ax
  8004ef:	90                   	nop

008004f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8004fb:	c1 e8 0c             	shr    $0xc,%eax
}
  8004fe:	5d                   	pop    %ebp
  8004ff:	c3                   	ret    

00800500 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800503:	8b 45 08             	mov    0x8(%ebp),%eax
  800506:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80050b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800510:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800515:	5d                   	pop    %ebp
  800516:	c3                   	ret    

00800517 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80051d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800522:	89 c2                	mov    %eax,%edx
  800524:	c1 ea 16             	shr    $0x16,%edx
  800527:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80052e:	f6 c2 01             	test   $0x1,%dl
  800531:	74 11                	je     800544 <fd_alloc+0x2d>
  800533:	89 c2                	mov    %eax,%edx
  800535:	c1 ea 0c             	shr    $0xc,%edx
  800538:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80053f:	f6 c2 01             	test   $0x1,%dl
  800542:	75 09                	jne    80054d <fd_alloc+0x36>
			*fd_store = fd;
  800544:	89 01                	mov    %eax,(%ecx)
			return 0;
  800546:	b8 00 00 00 00       	mov    $0x0,%eax
  80054b:	eb 17                	jmp    800564 <fd_alloc+0x4d>
  80054d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800552:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800557:	75 c9                	jne    800522 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800559:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80055f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800564:	5d                   	pop    %ebp
  800565:	c3                   	ret    

00800566 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80056c:	83 f8 1f             	cmp    $0x1f,%eax
  80056f:	77 36                	ja     8005a7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800571:	c1 e0 0c             	shl    $0xc,%eax
  800574:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800579:	89 c2                	mov    %eax,%edx
  80057b:	c1 ea 16             	shr    $0x16,%edx
  80057e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800585:	f6 c2 01             	test   $0x1,%dl
  800588:	74 24                	je     8005ae <fd_lookup+0x48>
  80058a:	89 c2                	mov    %eax,%edx
  80058c:	c1 ea 0c             	shr    $0xc,%edx
  80058f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800596:	f6 c2 01             	test   $0x1,%dl
  800599:	74 1a                	je     8005b5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80059b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80059e:	89 02                	mov    %eax,(%edx)
	return 0;
  8005a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a5:	eb 13                	jmp    8005ba <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8005a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8005ac:	eb 0c                	jmp    8005ba <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8005ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8005b3:	eb 05                	jmp    8005ba <fd_lookup+0x54>
  8005b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8005ba:	5d                   	pop    %ebp
  8005bb:	c3                   	ret    

008005bc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	83 ec 18             	sub    $0x18,%esp
  8005c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8005c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ca:	eb 13                	jmp    8005df <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8005cc:	39 08                	cmp    %ecx,(%eax)
  8005ce:	75 0c                	jne    8005dc <dev_lookup+0x20>
			*dev = devtab[i];
  8005d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005d3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8005d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005da:	eb 38                	jmp    800614 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8005dc:	83 c2 01             	add    $0x1,%edx
  8005df:	8b 04 95 34 27 80 00 	mov    0x802734(,%edx,4),%eax
  8005e6:	85 c0                	test   %eax,%eax
  8005e8:	75 e2                	jne    8005cc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8005ea:	a1 08 40 80 00       	mov    0x804008,%eax
  8005ef:	8b 40 48             	mov    0x48(%eax),%eax
  8005f2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005fa:	c7 04 24 b8 26 80 00 	movl   $0x8026b8,(%esp)
  800601:	e8 f9 12 00 00       	call   8018ff <cprintf>
	*dev = 0;
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80060f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800614:	c9                   	leave  
  800615:	c3                   	ret    

00800616 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	56                   	push   %esi
  80061a:	53                   	push   %ebx
  80061b:	83 ec 20             	sub    $0x20,%esp
  80061e:	8b 75 08             	mov    0x8(%ebp),%esi
  800621:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800624:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800627:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80062b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800631:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800634:	89 04 24             	mov    %eax,(%esp)
  800637:	e8 2a ff ff ff       	call   800566 <fd_lookup>
  80063c:	85 c0                	test   %eax,%eax
  80063e:	78 05                	js     800645 <fd_close+0x2f>
	    || fd != fd2)
  800640:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800643:	74 0c                	je     800651 <fd_close+0x3b>
		return (must_exist ? r : 0);
  800645:	84 db                	test   %bl,%bl
  800647:	ba 00 00 00 00       	mov    $0x0,%edx
  80064c:	0f 44 c2             	cmove  %edx,%eax
  80064f:	eb 3f                	jmp    800690 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800651:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800654:	89 44 24 04          	mov    %eax,0x4(%esp)
  800658:	8b 06                	mov    (%esi),%eax
  80065a:	89 04 24             	mov    %eax,(%esp)
  80065d:	e8 5a ff ff ff       	call   8005bc <dev_lookup>
  800662:	89 c3                	mov    %eax,%ebx
  800664:	85 c0                	test   %eax,%eax
  800666:	78 16                	js     80067e <fd_close+0x68>
		if (dev->dev_close)
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80066e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800673:	85 c0                	test   %eax,%eax
  800675:	74 07                	je     80067e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800677:	89 34 24             	mov    %esi,(%esp)
  80067a:	ff d0                	call   *%eax
  80067c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80067e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800682:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800689:	e8 bc fb ff ff       	call   80024a <sys_page_unmap>
	return r;
  80068e:	89 d8                	mov    %ebx,%eax
}
  800690:	83 c4 20             	add    $0x20,%esp
  800693:	5b                   	pop    %ebx
  800694:	5e                   	pop    %esi
  800695:	5d                   	pop    %ebp
  800696:	c3                   	ret    

00800697 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800697:	55                   	push   %ebp
  800698:	89 e5                	mov    %esp,%ebp
  80069a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80069d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	89 04 24             	mov    %eax,(%esp)
  8006aa:	e8 b7 fe ff ff       	call   800566 <fd_lookup>
  8006af:	89 c2                	mov    %eax,%edx
  8006b1:	85 d2                	test   %edx,%edx
  8006b3:	78 13                	js     8006c8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8006b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8006bc:	00 
  8006bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006c0:	89 04 24             	mov    %eax,(%esp)
  8006c3:	e8 4e ff ff ff       	call   800616 <fd_close>
}
  8006c8:	c9                   	leave  
  8006c9:	c3                   	ret    

008006ca <close_all>:

void
close_all(void)
{
  8006ca:	55                   	push   %ebp
  8006cb:	89 e5                	mov    %esp,%ebp
  8006cd:	53                   	push   %ebx
  8006ce:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8006d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8006d6:	89 1c 24             	mov    %ebx,(%esp)
  8006d9:	e8 b9 ff ff ff       	call   800697 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8006de:	83 c3 01             	add    $0x1,%ebx
  8006e1:	83 fb 20             	cmp    $0x20,%ebx
  8006e4:	75 f0                	jne    8006d6 <close_all+0xc>
		close(i);
}
  8006e6:	83 c4 14             	add    $0x14,%esp
  8006e9:	5b                   	pop    %ebx
  8006ea:	5d                   	pop    %ebp
  8006eb:	c3                   	ret    

008006ec <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8006ec:	55                   	push   %ebp
  8006ed:	89 e5                	mov    %esp,%ebp
  8006ef:	57                   	push   %edi
  8006f0:	56                   	push   %esi
  8006f1:	53                   	push   %ebx
  8006f2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8006f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8006f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	89 04 24             	mov    %eax,(%esp)
  800702:	e8 5f fe ff ff       	call   800566 <fd_lookup>
  800707:	89 c2                	mov    %eax,%edx
  800709:	85 d2                	test   %edx,%edx
  80070b:	0f 88 e1 00 00 00    	js     8007f2 <dup+0x106>
		return r;
	close(newfdnum);
  800711:	8b 45 0c             	mov    0xc(%ebp),%eax
  800714:	89 04 24             	mov    %eax,(%esp)
  800717:	e8 7b ff ff ff       	call   800697 <close>

	newfd = INDEX2FD(newfdnum);
  80071c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80071f:	c1 e3 0c             	shl    $0xc,%ebx
  800722:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80072b:	89 04 24             	mov    %eax,(%esp)
  80072e:	e8 cd fd ff ff       	call   800500 <fd2data>
  800733:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  800735:	89 1c 24             	mov    %ebx,(%esp)
  800738:	e8 c3 fd ff ff       	call   800500 <fd2data>
  80073d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80073f:	89 f0                	mov    %esi,%eax
  800741:	c1 e8 16             	shr    $0x16,%eax
  800744:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80074b:	a8 01                	test   $0x1,%al
  80074d:	74 43                	je     800792 <dup+0xa6>
  80074f:	89 f0                	mov    %esi,%eax
  800751:	c1 e8 0c             	shr    $0xc,%eax
  800754:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80075b:	f6 c2 01             	test   $0x1,%dl
  80075e:	74 32                	je     800792 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800760:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800767:	25 07 0e 00 00       	and    $0xe07,%eax
  80076c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800770:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800774:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80077b:	00 
  80077c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800780:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800787:	e8 6b fa ff ff       	call   8001f7 <sys_page_map>
  80078c:	89 c6                	mov    %eax,%esi
  80078e:	85 c0                	test   %eax,%eax
  800790:	78 3e                	js     8007d0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800792:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800795:	89 c2                	mov    %eax,%edx
  800797:	c1 ea 0c             	shr    $0xc,%edx
  80079a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8007a1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8007a7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8007af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8007b6:	00 
  8007b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007c2:	e8 30 fa ff ff       	call   8001f7 <sys_page_map>
  8007c7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8007c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8007cc:	85 f6                	test   %esi,%esi
  8007ce:	79 22                	jns    8007f2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8007d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007db:	e8 6a fa ff ff       	call   80024a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8007e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007eb:	e8 5a fa ff ff       	call   80024a <sys_page_unmap>
	return r;
  8007f0:	89 f0                	mov    %esi,%eax
}
  8007f2:	83 c4 3c             	add    $0x3c,%esp
  8007f5:	5b                   	pop    %ebx
  8007f6:	5e                   	pop    %esi
  8007f7:	5f                   	pop    %edi
  8007f8:	5d                   	pop    %ebp
  8007f9:	c3                   	ret    

008007fa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	53                   	push   %ebx
  8007fe:	83 ec 24             	sub    $0x24,%esp
  800801:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800804:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800807:	89 44 24 04          	mov    %eax,0x4(%esp)
  80080b:	89 1c 24             	mov    %ebx,(%esp)
  80080e:	e8 53 fd ff ff       	call   800566 <fd_lookup>
  800813:	89 c2                	mov    %eax,%edx
  800815:	85 d2                	test   %edx,%edx
  800817:	78 6d                	js     800886 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800819:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80081c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800823:	8b 00                	mov    (%eax),%eax
  800825:	89 04 24             	mov    %eax,(%esp)
  800828:	e8 8f fd ff ff       	call   8005bc <dev_lookup>
  80082d:	85 c0                	test   %eax,%eax
  80082f:	78 55                	js     800886 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800834:	8b 50 08             	mov    0x8(%eax),%edx
  800837:	83 e2 03             	and    $0x3,%edx
  80083a:	83 fa 01             	cmp    $0x1,%edx
  80083d:	75 23                	jne    800862 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80083f:	a1 08 40 80 00       	mov    0x804008,%eax
  800844:	8b 40 48             	mov    0x48(%eax),%eax
  800847:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80084b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084f:	c7 04 24 f9 26 80 00 	movl   $0x8026f9,(%esp)
  800856:	e8 a4 10 00 00       	call   8018ff <cprintf>
		return -E_INVAL;
  80085b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800860:	eb 24                	jmp    800886 <read+0x8c>
	}
	if (!dev->dev_read)
  800862:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800865:	8b 52 08             	mov    0x8(%edx),%edx
  800868:	85 d2                	test   %edx,%edx
  80086a:	74 15                	je     800881 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80086c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80086f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800873:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800876:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80087a:	89 04 24             	mov    %eax,(%esp)
  80087d:	ff d2                	call   *%edx
  80087f:	eb 05                	jmp    800886 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800881:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800886:	83 c4 24             	add    $0x24,%esp
  800889:	5b                   	pop    %ebx
  80088a:	5d                   	pop    %ebp
  80088b:	c3                   	ret    

0080088c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	57                   	push   %edi
  800890:	56                   	push   %esi
  800891:	53                   	push   %ebx
  800892:	83 ec 1c             	sub    $0x1c,%esp
  800895:	8b 7d 08             	mov    0x8(%ebp),%edi
  800898:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80089b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008a0:	eb 23                	jmp    8008c5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8008a2:	89 f0                	mov    %esi,%eax
  8008a4:	29 d8                	sub    %ebx,%eax
  8008a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008aa:	89 d8                	mov    %ebx,%eax
  8008ac:	03 45 0c             	add    0xc(%ebp),%eax
  8008af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b3:	89 3c 24             	mov    %edi,(%esp)
  8008b6:	e8 3f ff ff ff       	call   8007fa <read>
		if (m < 0)
  8008bb:	85 c0                	test   %eax,%eax
  8008bd:	78 10                	js     8008cf <readn+0x43>
			return m;
		if (m == 0)
  8008bf:	85 c0                	test   %eax,%eax
  8008c1:	74 0a                	je     8008cd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8008c3:	01 c3                	add    %eax,%ebx
  8008c5:	39 f3                	cmp    %esi,%ebx
  8008c7:	72 d9                	jb     8008a2 <readn+0x16>
  8008c9:	89 d8                	mov    %ebx,%eax
  8008cb:	eb 02                	jmp    8008cf <readn+0x43>
  8008cd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8008cf:	83 c4 1c             	add    $0x1c,%esp
  8008d2:	5b                   	pop    %ebx
  8008d3:	5e                   	pop    %esi
  8008d4:	5f                   	pop    %edi
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	53                   	push   %ebx
  8008db:	83 ec 24             	sub    $0x24,%esp
  8008de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008e8:	89 1c 24             	mov    %ebx,(%esp)
  8008eb:	e8 76 fc ff ff       	call   800566 <fd_lookup>
  8008f0:	89 c2                	mov    %eax,%edx
  8008f2:	85 d2                	test   %edx,%edx
  8008f4:	78 68                	js     80095e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800900:	8b 00                	mov    (%eax),%eax
  800902:	89 04 24             	mov    %eax,(%esp)
  800905:	e8 b2 fc ff ff       	call   8005bc <dev_lookup>
  80090a:	85 c0                	test   %eax,%eax
  80090c:	78 50                	js     80095e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80090e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800911:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800915:	75 23                	jne    80093a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800917:	a1 08 40 80 00       	mov    0x804008,%eax
  80091c:	8b 40 48             	mov    0x48(%eax),%eax
  80091f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800923:	89 44 24 04          	mov    %eax,0x4(%esp)
  800927:	c7 04 24 15 27 80 00 	movl   $0x802715,(%esp)
  80092e:	e8 cc 0f 00 00       	call   8018ff <cprintf>
		return -E_INVAL;
  800933:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800938:	eb 24                	jmp    80095e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80093a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80093d:	8b 52 0c             	mov    0xc(%edx),%edx
  800940:	85 d2                	test   %edx,%edx
  800942:	74 15                	je     800959 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800944:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800947:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80094b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80094e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800952:	89 04 24             	mov    %eax,(%esp)
  800955:	ff d2                	call   *%edx
  800957:	eb 05                	jmp    80095e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800959:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80095e:	83 c4 24             	add    $0x24,%esp
  800961:	5b                   	pop    %ebx
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <seek>:

int
seek(int fdnum, off_t offset)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80096a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	89 04 24             	mov    %eax,(%esp)
  800977:	e8 ea fb ff ff       	call   800566 <fd_lookup>
  80097c:	85 c0                	test   %eax,%eax
  80097e:	78 0e                	js     80098e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800980:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800983:	8b 55 0c             	mov    0xc(%ebp),%edx
  800986:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800989:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80098e:	c9                   	leave  
  80098f:	c3                   	ret    

00800990 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	53                   	push   %ebx
  800994:	83 ec 24             	sub    $0x24,%esp
  800997:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80099a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80099d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a1:	89 1c 24             	mov    %ebx,(%esp)
  8009a4:	e8 bd fb ff ff       	call   800566 <fd_lookup>
  8009a9:	89 c2                	mov    %eax,%edx
  8009ab:	85 d2                	test   %edx,%edx
  8009ad:	78 61                	js     800a10 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	89 04 24             	mov    %eax,(%esp)
  8009be:	e8 f9 fb ff ff       	call   8005bc <dev_lookup>
  8009c3:	85 c0                	test   %eax,%eax
  8009c5:	78 49                	js     800a10 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8009c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8009ce:	75 23                	jne    8009f3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8009d0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8009d5:	8b 40 48             	mov    0x48(%eax),%eax
  8009d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8009dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e0:	c7 04 24 d8 26 80 00 	movl   $0x8026d8,(%esp)
  8009e7:	e8 13 0f 00 00       	call   8018ff <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8009ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009f1:	eb 1d                	jmp    800a10 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8009f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009f6:	8b 52 18             	mov    0x18(%edx),%edx
  8009f9:	85 d2                	test   %edx,%edx
  8009fb:	74 0e                	je     800a0b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8009fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a00:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a04:	89 04 24             	mov    %eax,(%esp)
  800a07:	ff d2                	call   *%edx
  800a09:	eb 05                	jmp    800a10 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800a0b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800a10:	83 c4 24             	add    $0x24,%esp
  800a13:	5b                   	pop    %ebx
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	53                   	push   %ebx
  800a1a:	83 ec 24             	sub    $0x24,%esp
  800a1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a20:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a23:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	89 04 24             	mov    %eax,(%esp)
  800a2d:	e8 34 fb ff ff       	call   800566 <fd_lookup>
  800a32:	89 c2                	mov    %eax,%edx
  800a34:	85 d2                	test   %edx,%edx
  800a36:	78 52                	js     800a8a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a42:	8b 00                	mov    (%eax),%eax
  800a44:	89 04 24             	mov    %eax,(%esp)
  800a47:	e8 70 fb ff ff       	call   8005bc <dev_lookup>
  800a4c:	85 c0                	test   %eax,%eax
  800a4e:	78 3a                	js     800a8a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a53:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800a57:	74 2c                	je     800a85 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800a59:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800a5c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800a63:	00 00 00 
	stat->st_isdir = 0;
  800a66:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800a6d:	00 00 00 
	stat->st_dev = dev;
  800a70:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800a76:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a7d:	89 14 24             	mov    %edx,(%esp)
  800a80:	ff 50 14             	call   *0x14(%eax)
  800a83:	eb 05                	jmp    800a8a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800a85:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800a8a:	83 c4 24             	add    $0x24,%esp
  800a8d:	5b                   	pop    %ebx
  800a8e:	5d                   	pop    %ebp
  800a8f:	c3                   	ret    

00800a90 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	56                   	push   %esi
  800a94:	53                   	push   %ebx
  800a95:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800a98:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800a9f:	00 
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	89 04 24             	mov    %eax,(%esp)
  800aa6:	e8 84 02 00 00       	call   800d2f <open>
  800aab:	89 c3                	mov    %eax,%ebx
  800aad:	85 db                	test   %ebx,%ebx
  800aaf:	78 1b                	js     800acc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ab8:	89 1c 24             	mov    %ebx,(%esp)
  800abb:	e8 56 ff ff ff       	call   800a16 <fstat>
  800ac0:	89 c6                	mov    %eax,%esi
	close(fd);
  800ac2:	89 1c 24             	mov    %ebx,(%esp)
  800ac5:	e8 cd fb ff ff       	call   800697 <close>
	return r;
  800aca:	89 f0                	mov    %esi,%eax
}
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	5b                   	pop    %ebx
  800ad0:	5e                   	pop    %esi
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	56                   	push   %esi
  800ad7:	53                   	push   %ebx
  800ad8:	83 ec 10             	sub    $0x10,%esp
  800adb:	89 c6                	mov    %eax,%esi
  800add:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800adf:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800ae6:	75 11                	jne    800af9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ae8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800aef:	e8 81 18 00 00       	call   802375 <ipc_find_env>
  800af4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800af9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800b00:	00 
  800b01:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800b08:	00 
  800b09:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b0d:	a1 00 40 80 00       	mov    0x804000,%eax
  800b12:	89 04 24             	mov    %eax,(%esp)
  800b15:	e8 ce 17 00 00       	call   8022e8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800b1a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800b21:	00 
  800b22:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b2d:	e8 4e 17 00 00       	call   802280 <ipc_recv>
}
  800b32:	83 c4 10             	add    $0x10,%esp
  800b35:	5b                   	pop    %ebx
  800b36:	5e                   	pop    %esi
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    

00800b39 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	8b 40 0c             	mov    0xc(%eax),%eax
  800b45:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800b52:	ba 00 00 00 00       	mov    $0x0,%edx
  800b57:	b8 02 00 00 00       	mov    $0x2,%eax
  800b5c:	e8 72 ff ff ff       	call   800ad3 <fsipc>
}
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8b 40 0c             	mov    0xc(%eax),%eax
  800b6f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800b74:	ba 00 00 00 00       	mov    $0x0,%edx
  800b79:	b8 06 00 00 00       	mov    $0x6,%eax
  800b7e:	e8 50 ff ff ff       	call   800ad3 <fsipc>
}
  800b83:	c9                   	leave  
  800b84:	c3                   	ret    

00800b85 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	53                   	push   %ebx
  800b89:	83 ec 14             	sub    $0x14,%esp
  800b8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8b 40 0c             	mov    0xc(%eax),%eax
  800b95:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800b9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9f:	b8 05 00 00 00       	mov    $0x5,%eax
  800ba4:	e8 2a ff ff ff       	call   800ad3 <fsipc>
  800ba9:	89 c2                	mov    %eax,%edx
  800bab:	85 d2                	test   %edx,%edx
  800bad:	78 2b                	js     800bda <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800baf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800bb6:	00 
  800bb7:	89 1c 24             	mov    %ebx,(%esp)
  800bba:	e8 68 13 00 00       	call   801f27 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800bbf:	a1 80 50 80 00       	mov    0x805080,%eax
  800bc4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800bca:	a1 84 50 80 00       	mov    0x805084,%eax
  800bcf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800bd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bda:	83 c4 14             	add    $0x14,%esp
  800bdd:	5b                   	pop    %ebx
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    

00800be0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	53                   	push   %ebx
  800be4:	83 ec 14             	sub    $0x14,%esp
  800be7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	8b 40 0c             	mov    0xc(%eax),%eax
  800bf0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  800bf5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800bfb:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  800c00:	0f 46 c3             	cmovbe %ebx,%eax
  800c03:	a3 04 50 80 00       	mov    %eax,0x805004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  800c08:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c13:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  800c1a:	e8 a5 14 00 00       	call   8020c4 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800c1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800c24:	b8 04 00 00 00       	mov    $0x4,%eax
  800c29:	e8 a5 fe ff ff       	call   800ad3 <fsipc>
  800c2e:	85 c0                	test   %eax,%eax
  800c30:	78 53                	js     800c85 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  800c32:	39 c3                	cmp    %eax,%ebx
  800c34:	73 24                	jae    800c5a <devfile_write+0x7a>
  800c36:	c7 44 24 0c 48 27 80 	movl   $0x802748,0xc(%esp)
  800c3d:	00 
  800c3e:	c7 44 24 08 4f 27 80 	movl   $0x80274f,0x8(%esp)
  800c45:	00 
  800c46:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  800c4d:	00 
  800c4e:	c7 04 24 64 27 80 00 	movl   $0x802764,(%esp)
  800c55:	e8 ac 0b 00 00       	call   801806 <_panic>
	assert(r <= PGSIZE);
  800c5a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800c5f:	7e 24                	jle    800c85 <devfile_write+0xa5>
  800c61:	c7 44 24 0c 6f 27 80 	movl   $0x80276f,0xc(%esp)
  800c68:	00 
  800c69:	c7 44 24 08 4f 27 80 	movl   $0x80274f,0x8(%esp)
  800c70:	00 
  800c71:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  800c78:	00 
  800c79:	c7 04 24 64 27 80 00 	movl   $0x802764,(%esp)
  800c80:	e8 81 0b 00 00       	call   801806 <_panic>
	return r;
}
  800c85:	83 c4 14             	add    $0x14,%esp
  800c88:	5b                   	pop    %ebx
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    

00800c8b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
  800c90:	83 ec 10             	sub    $0x10,%esp
  800c93:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8b 40 0c             	mov    0xc(%eax),%eax
  800c9c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800ca1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800ca7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cac:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb1:	e8 1d fe ff ff       	call   800ad3 <fsipc>
  800cb6:	89 c3                	mov    %eax,%ebx
  800cb8:	85 c0                	test   %eax,%eax
  800cba:	78 6a                	js     800d26 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800cbc:	39 c6                	cmp    %eax,%esi
  800cbe:	73 24                	jae    800ce4 <devfile_read+0x59>
  800cc0:	c7 44 24 0c 48 27 80 	movl   $0x802748,0xc(%esp)
  800cc7:	00 
  800cc8:	c7 44 24 08 4f 27 80 	movl   $0x80274f,0x8(%esp)
  800ccf:	00 
  800cd0:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  800cd7:	00 
  800cd8:	c7 04 24 64 27 80 00 	movl   $0x802764,(%esp)
  800cdf:	e8 22 0b 00 00       	call   801806 <_panic>
	assert(r <= PGSIZE);
  800ce4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ce9:	7e 24                	jle    800d0f <devfile_read+0x84>
  800ceb:	c7 44 24 0c 6f 27 80 	movl   $0x80276f,0xc(%esp)
  800cf2:	00 
  800cf3:	c7 44 24 08 4f 27 80 	movl   $0x80274f,0x8(%esp)
  800cfa:	00 
  800cfb:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  800d02:	00 
  800d03:	c7 04 24 64 27 80 00 	movl   $0x802764,(%esp)
  800d0a:	e8 f7 0a 00 00       	call   801806 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800d0f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d13:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800d1a:	00 
  800d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1e:	89 04 24             	mov    %eax,(%esp)
  800d21:	e8 9e 13 00 00       	call   8020c4 <memmove>
	return r;
}
  800d26:	89 d8                	mov    %ebx,%eax
  800d28:	83 c4 10             	add    $0x10,%esp
  800d2b:	5b                   	pop    %ebx
  800d2c:	5e                   	pop    %esi
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    

00800d2f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	53                   	push   %ebx
  800d33:	83 ec 24             	sub    $0x24,%esp
  800d36:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800d39:	89 1c 24             	mov    %ebx,(%esp)
  800d3c:	e8 af 11 00 00       	call   801ef0 <strlen>
  800d41:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800d46:	7f 60                	jg     800da8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800d48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d4b:	89 04 24             	mov    %eax,(%esp)
  800d4e:	e8 c4 f7 ff ff       	call   800517 <fd_alloc>
  800d53:	89 c2                	mov    %eax,%edx
  800d55:	85 d2                	test   %edx,%edx
  800d57:	78 54                	js     800dad <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800d59:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d5d:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800d64:	e8 be 11 00 00       	call   801f27 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6c:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800d71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d74:	b8 01 00 00 00       	mov    $0x1,%eax
  800d79:	e8 55 fd ff ff       	call   800ad3 <fsipc>
  800d7e:	89 c3                	mov    %eax,%ebx
  800d80:	85 c0                	test   %eax,%eax
  800d82:	79 17                	jns    800d9b <open+0x6c>
		fd_close(fd, 0);
  800d84:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800d8b:	00 
  800d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d8f:	89 04 24             	mov    %eax,(%esp)
  800d92:	e8 7f f8 ff ff       	call   800616 <fd_close>
		return r;
  800d97:	89 d8                	mov    %ebx,%eax
  800d99:	eb 12                	jmp    800dad <open+0x7e>
	}

	return fd2num(fd);
  800d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d9e:	89 04 24             	mov    %eax,(%esp)
  800da1:	e8 4a f7 ff ff       	call   8004f0 <fd2num>
  800da6:	eb 05                	jmp    800dad <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800da8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800dad:	83 c4 24             	add    $0x24,%esp
  800db0:	5b                   	pop    %ebx
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800db9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dbe:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc3:	e8 0b fd ff ff       	call   800ad3 <fsipc>
}
  800dc8:	c9                   	leave  
  800dc9:	c3                   	ret    
  800dca:	66 90                	xchg   %ax,%ax
  800dcc:	66 90                	xchg   %ax,%ax
  800dce:	66 90                	xchg   %ax,%ax

00800dd0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  800dd6:	c7 44 24 04 7b 27 80 	movl   $0x80277b,0x4(%esp)
  800ddd:	00 
  800dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de1:	89 04 24             	mov    %eax,(%esp)
  800de4:	e8 3e 11 00 00       	call   801f27 <strcpy>
	return 0;
}
  800de9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dee:	c9                   	leave  
  800def:	c3                   	ret    

00800df0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	53                   	push   %ebx
  800df4:	83 ec 14             	sub    $0x14,%esp
  800df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800dfa:	89 1c 24             	mov    %ebx,(%esp)
  800dfd:	e8 ad 15 00 00       	call   8023af <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  800e02:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  800e07:	83 f8 01             	cmp    $0x1,%eax
  800e0a:	75 0d                	jne    800e19 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  800e0c:	8b 43 0c             	mov    0xc(%ebx),%eax
  800e0f:	89 04 24             	mov    %eax,(%esp)
  800e12:	e8 29 03 00 00       	call   801140 <nsipc_close>
  800e17:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  800e19:	89 d0                	mov    %edx,%eax
  800e1b:	83 c4 14             	add    $0x14,%esp
  800e1e:	5b                   	pop    %ebx
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    

00800e21 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800e27:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800e2e:	00 
  800e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e32:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e39:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8b 40 0c             	mov    0xc(%eax),%eax
  800e43:	89 04 24             	mov    %eax,(%esp)
  800e46:	e8 f0 03 00 00       	call   80123b <nsipc_send>
}
  800e4b:	c9                   	leave  
  800e4c:	c3                   	ret    

00800e4d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800e53:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800e5a:	00 
  800e5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e65:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8b 40 0c             	mov    0xc(%eax),%eax
  800e6f:	89 04 24             	mov    %eax,(%esp)
  800e72:	e8 44 03 00 00       	call   8011bb <nsipc_recv>
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    

00800e79 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  800e7f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800e82:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e86:	89 04 24             	mov    %eax,(%esp)
  800e89:	e8 d8 f6 ff ff       	call   800566 <fd_lookup>
  800e8e:	85 c0                	test   %eax,%eax
  800e90:	78 17                	js     800ea9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  800e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e95:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800e9b:	39 08                	cmp    %ecx,(%eax)
  800e9d:	75 05                	jne    800ea4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  800e9f:	8b 40 0c             	mov    0xc(%eax),%eax
  800ea2:	eb 05                	jmp    800ea9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  800ea4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  800ea9:	c9                   	leave  
  800eaa:	c3                   	ret    

00800eab <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	56                   	push   %esi
  800eaf:	53                   	push   %ebx
  800eb0:	83 ec 20             	sub    $0x20,%esp
  800eb3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800eb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800eb8:	89 04 24             	mov    %eax,(%esp)
  800ebb:	e8 57 f6 ff ff       	call   800517 <fd_alloc>
  800ec0:	89 c3                	mov    %eax,%ebx
  800ec2:	85 c0                	test   %eax,%eax
  800ec4:	78 21                	js     800ee7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800ec6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800ecd:	00 
  800ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ed5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800edc:	e8 c2 f2 ff ff       	call   8001a3 <sys_page_alloc>
  800ee1:	89 c3                	mov    %eax,%ebx
  800ee3:	85 c0                	test   %eax,%eax
  800ee5:	79 0c                	jns    800ef3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  800ee7:	89 34 24             	mov    %esi,(%esp)
  800eea:	e8 51 02 00 00       	call   801140 <nsipc_close>
		return r;
  800eef:	89 d8                	mov    %ebx,%eax
  800ef1:	eb 20                	jmp    800f13 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  800ef3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800efc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800efe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f01:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  800f08:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  800f0b:	89 14 24             	mov    %edx,(%esp)
  800f0e:	e8 dd f5 ff ff       	call   8004f0 <fd2num>
}
  800f13:	83 c4 20             	add    $0x20,%esp
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5d                   	pop    %ebp
  800f19:	c3                   	ret    

00800f1a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	e8 51 ff ff ff       	call   800e79 <fd2sockid>
		return r;
  800f28:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f2a:	85 c0                	test   %eax,%eax
  800f2c:	78 23                	js     800f51 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800f2e:	8b 55 10             	mov    0x10(%ebp),%edx
  800f31:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f38:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f3c:	89 04 24             	mov    %eax,(%esp)
  800f3f:	e8 45 01 00 00       	call   801089 <nsipc_accept>
		return r;
  800f44:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800f46:	85 c0                	test   %eax,%eax
  800f48:	78 07                	js     800f51 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  800f4a:	e8 5c ff ff ff       	call   800eab <alloc_sockfd>
  800f4f:	89 c1                	mov    %eax,%ecx
}
  800f51:	89 c8                	mov    %ecx,%eax
  800f53:	c9                   	leave  
  800f54:	c3                   	ret    

00800f55 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	e8 16 ff ff ff       	call   800e79 <fd2sockid>
  800f63:	89 c2                	mov    %eax,%edx
  800f65:	85 d2                	test   %edx,%edx
  800f67:	78 16                	js     800f7f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  800f69:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f73:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f77:	89 14 24             	mov    %edx,(%esp)
  800f7a:	e8 60 01 00 00       	call   8010df <nsipc_bind>
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <shutdown>:

int
shutdown(int s, int how)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	e8 ea fe ff ff       	call   800e79 <fd2sockid>
  800f8f:	89 c2                	mov    %eax,%edx
  800f91:	85 d2                	test   %edx,%edx
  800f93:	78 0f                	js     800fa4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  800f95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f98:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f9c:	89 14 24             	mov    %edx,(%esp)
  800f9f:	e8 7a 01 00 00       	call   80111e <nsipc_shutdown>
}
  800fa4:	c9                   	leave  
  800fa5:	c3                   	ret    

00800fa6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	e8 c5 fe ff ff       	call   800e79 <fd2sockid>
  800fb4:	89 c2                	mov    %eax,%edx
  800fb6:	85 d2                	test   %edx,%edx
  800fb8:	78 16                	js     800fd0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  800fba:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbd:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fc8:	89 14 24             	mov    %edx,(%esp)
  800fcb:	e8 8a 01 00 00       	call   80115a <nsipc_connect>
}
  800fd0:	c9                   	leave  
  800fd1:	c3                   	ret    

00800fd2 <listen>:

int
listen(int s, int backlog)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	e8 99 fe ff ff       	call   800e79 <fd2sockid>
  800fe0:	89 c2                	mov    %eax,%edx
  800fe2:	85 d2                	test   %edx,%edx
  800fe4:	78 0f                	js     800ff5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fed:	89 14 24             	mov    %edx,(%esp)
  800ff0:	e8 a4 01 00 00       	call   801199 <nsipc_listen>
}
  800ff5:	c9                   	leave  
  800ff6:	c3                   	ret    

00800ff7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800ffd:	8b 45 10             	mov    0x10(%ebp),%eax
  801000:	89 44 24 08          	mov    %eax,0x8(%esp)
  801004:	8b 45 0c             	mov    0xc(%ebp),%eax
  801007:	89 44 24 04          	mov    %eax,0x4(%esp)
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	89 04 24             	mov    %eax,(%esp)
  801011:	e8 98 02 00 00       	call   8012ae <nsipc_socket>
  801016:	89 c2                	mov    %eax,%edx
  801018:	85 d2                	test   %edx,%edx
  80101a:	78 05                	js     801021 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80101c:	e8 8a fe ff ff       	call   800eab <alloc_sockfd>
}
  801021:	c9                   	leave  
  801022:	c3                   	ret    

00801023 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
  801026:	53                   	push   %ebx
  801027:	83 ec 14             	sub    $0x14,%esp
  80102a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80102c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801033:	75 11                	jne    801046 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801035:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80103c:	e8 34 13 00 00       	call   802375 <ipc_find_env>
  801041:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801046:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80104d:	00 
  80104e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801055:	00 
  801056:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80105a:	a1 04 40 80 00       	mov    0x804004,%eax
  80105f:	89 04 24             	mov    %eax,(%esp)
  801062:	e8 81 12 00 00       	call   8022e8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801067:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80106e:	00 
  80106f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801076:	00 
  801077:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80107e:	e8 fd 11 00 00       	call   802280 <ipc_recv>
}
  801083:	83 c4 14             	add    $0x14,%esp
  801086:	5b                   	pop    %ebx
  801087:	5d                   	pop    %ebp
  801088:	c3                   	ret    

00801089 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
  80108c:	56                   	push   %esi
  80108d:	53                   	push   %ebx
  80108e:	83 ec 10             	sub    $0x10,%esp
  801091:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80109c:	8b 06                	mov    (%esi),%eax
  80109e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8010a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8010a8:	e8 76 ff ff ff       	call   801023 <nsipc>
  8010ad:	89 c3                	mov    %eax,%ebx
  8010af:	85 c0                	test   %eax,%eax
  8010b1:	78 23                	js     8010d6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8010b3:	a1 10 60 80 00       	mov    0x806010,%eax
  8010b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010bc:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8010c3:	00 
  8010c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c7:	89 04 24             	mov    %eax,(%esp)
  8010ca:	e8 f5 0f 00 00       	call   8020c4 <memmove>
		*addrlen = ret->ret_addrlen;
  8010cf:	a1 10 60 80 00       	mov    0x806010,%eax
  8010d4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8010d6:	89 d8                	mov    %ebx,%eax
  8010d8:	83 c4 10             	add    $0x10,%esp
  8010db:	5b                   	pop    %ebx
  8010dc:	5e                   	pop    %esi
  8010dd:	5d                   	pop    %ebp
  8010de:	c3                   	ret    

008010df <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	53                   	push   %ebx
  8010e3:	83 ec 14             	sub    $0x14,%esp
  8010e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8010f1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010fc:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801103:	e8 bc 0f 00 00       	call   8020c4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801108:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80110e:	b8 02 00 00 00       	mov    $0x2,%eax
  801113:	e8 0b ff ff ff       	call   801023 <nsipc>
}
  801118:	83 c4 14             	add    $0x14,%esp
  80111b:	5b                   	pop    %ebx
  80111c:	5d                   	pop    %ebp
  80111d:	c3                   	ret    

0080111e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80111e:	55                   	push   %ebp
  80111f:	89 e5                	mov    %esp,%ebp
  801121:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801134:	b8 03 00 00 00       	mov    $0x3,%eax
  801139:	e8 e5 fe ff ff       	call   801023 <nsipc>
}
  80113e:	c9                   	leave  
  80113f:	c3                   	ret    

00801140 <nsipc_close>:

int
nsipc_close(int s)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
  801143:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80114e:	b8 04 00 00 00       	mov    $0x4,%eax
  801153:	e8 cb fe ff ff       	call   801023 <nsipc>
}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	53                   	push   %ebx
  80115e:	83 ec 14             	sub    $0x14,%esp
  801161:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80116c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801170:	8b 45 0c             	mov    0xc(%ebp),%eax
  801173:	89 44 24 04          	mov    %eax,0x4(%esp)
  801177:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  80117e:	e8 41 0f 00 00       	call   8020c4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801183:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801189:	b8 05 00 00 00       	mov    $0x5,%eax
  80118e:	e8 90 fe ff ff       	call   801023 <nsipc>
}
  801193:	83 c4 14             	add    $0x14,%esp
  801196:	5b                   	pop    %ebx
  801197:	5d                   	pop    %ebp
  801198:	c3                   	ret    

00801199 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
  80119c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8011a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011aa:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8011af:	b8 06 00 00 00       	mov    $0x6,%eax
  8011b4:	e8 6a fe ff ff       	call   801023 <nsipc>
}
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	56                   	push   %esi
  8011bf:	53                   	push   %ebx
  8011c0:	83 ec 10             	sub    $0x10,%esp
  8011c3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8011ce:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8011d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8011dc:	b8 07 00 00 00       	mov    $0x7,%eax
  8011e1:	e8 3d fe ff ff       	call   801023 <nsipc>
  8011e6:	89 c3                	mov    %eax,%ebx
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	78 46                	js     801232 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8011ec:	39 f0                	cmp    %esi,%eax
  8011ee:	7f 07                	jg     8011f7 <nsipc_recv+0x3c>
  8011f0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8011f5:	7e 24                	jle    80121b <nsipc_recv+0x60>
  8011f7:	c7 44 24 0c 87 27 80 	movl   $0x802787,0xc(%esp)
  8011fe:	00 
  8011ff:	c7 44 24 08 4f 27 80 	movl   $0x80274f,0x8(%esp)
  801206:	00 
  801207:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80120e:	00 
  80120f:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  801216:	e8 eb 05 00 00       	call   801806 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80121b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80121f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801226:	00 
  801227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122a:	89 04 24             	mov    %eax,(%esp)
  80122d:	e8 92 0e 00 00       	call   8020c4 <memmove>
	}

	return r;
}
  801232:	89 d8                	mov    %ebx,%eax
  801234:	83 c4 10             	add    $0x10,%esp
  801237:	5b                   	pop    %ebx
  801238:	5e                   	pop    %esi
  801239:	5d                   	pop    %ebp
  80123a:	c3                   	ret    

0080123b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	53                   	push   %ebx
  80123f:	83 ec 14             	sub    $0x14,%esp
  801242:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80124d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801253:	7e 24                	jle    801279 <nsipc_send+0x3e>
  801255:	c7 44 24 0c a8 27 80 	movl   $0x8027a8,0xc(%esp)
  80125c:	00 
  80125d:	c7 44 24 08 4f 27 80 	movl   $0x80274f,0x8(%esp)
  801264:	00 
  801265:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80126c:	00 
  80126d:	c7 04 24 9c 27 80 00 	movl   $0x80279c,(%esp)
  801274:	e8 8d 05 00 00       	call   801806 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801279:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	89 44 24 04          	mov    %eax,0x4(%esp)
  801284:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80128b:	e8 34 0e 00 00       	call   8020c4 <memmove>
	nsipcbuf.send.req_size = size;
  801290:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801296:	8b 45 14             	mov    0x14(%ebp),%eax
  801299:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80129e:	b8 08 00 00 00       	mov    $0x8,%eax
  8012a3:	e8 7b fd ff ff       	call   801023 <nsipc>
}
  8012a8:	83 c4 14             	add    $0x14,%esp
  8012ab:	5b                   	pop    %ebx
  8012ac:	5d                   	pop    %ebp
  8012ad:	c3                   	ret    

008012ae <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8012bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bf:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8012c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8012cc:	b8 09 00 00 00       	mov    $0x9,%eax
  8012d1:	e8 4d fd ff ff       	call   801023 <nsipc>
}
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	56                   	push   %esi
  8012dc:	53                   	push   %ebx
  8012dd:	83 ec 10             	sub    $0x10,%esp
  8012e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	89 04 24             	mov    %eax,(%esp)
  8012e9:	e8 12 f2 ff ff       	call   800500 <fd2data>
  8012ee:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8012f0:	c7 44 24 04 b4 27 80 	movl   $0x8027b4,0x4(%esp)
  8012f7:	00 
  8012f8:	89 1c 24             	mov    %ebx,(%esp)
  8012fb:	e8 27 0c 00 00       	call   801f27 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801300:	8b 46 04             	mov    0x4(%esi),%eax
  801303:	2b 06                	sub    (%esi),%eax
  801305:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80130b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801312:	00 00 00 
	stat->st_dev = &devpipe;
  801315:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80131c:	30 80 00 
	return 0;
}
  80131f:	b8 00 00 00 00       	mov    $0x0,%eax
  801324:	83 c4 10             	add    $0x10,%esp
  801327:	5b                   	pop    %ebx
  801328:	5e                   	pop    %esi
  801329:	5d                   	pop    %ebp
  80132a:	c3                   	ret    

0080132b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	53                   	push   %ebx
  80132f:	83 ec 14             	sub    $0x14,%esp
  801332:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801335:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801339:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801340:	e8 05 ef ff ff       	call   80024a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801345:	89 1c 24             	mov    %ebx,(%esp)
  801348:	e8 b3 f1 ff ff       	call   800500 <fd2data>
  80134d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801351:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801358:	e8 ed ee ff ff       	call   80024a <sys_page_unmap>
}
  80135d:	83 c4 14             	add    $0x14,%esp
  801360:	5b                   	pop    %ebx
  801361:	5d                   	pop    %ebp
  801362:	c3                   	ret    

00801363 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
  801366:	57                   	push   %edi
  801367:	56                   	push   %esi
  801368:	53                   	push   %ebx
  801369:	83 ec 2c             	sub    $0x2c,%esp
  80136c:	89 c6                	mov    %eax,%esi
  80136e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801371:	a1 08 40 80 00       	mov    0x804008,%eax
  801376:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801379:	89 34 24             	mov    %esi,(%esp)
  80137c:	e8 2e 10 00 00       	call   8023af <pageref>
  801381:	89 c7                	mov    %eax,%edi
  801383:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801386:	89 04 24             	mov    %eax,(%esp)
  801389:	e8 21 10 00 00       	call   8023af <pageref>
  80138e:	39 c7                	cmp    %eax,%edi
  801390:	0f 94 c2             	sete   %dl
  801393:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801396:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  80139c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80139f:	39 fb                	cmp    %edi,%ebx
  8013a1:	74 21                	je     8013c4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8013a3:	84 d2                	test   %dl,%dl
  8013a5:	74 ca                	je     801371 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8013a7:	8b 51 58             	mov    0x58(%ecx),%edx
  8013aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013ae:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013b6:	c7 04 24 bb 27 80 00 	movl   $0x8027bb,(%esp)
  8013bd:	e8 3d 05 00 00       	call   8018ff <cprintf>
  8013c2:	eb ad                	jmp    801371 <_pipeisclosed+0xe>
	}
}
  8013c4:	83 c4 2c             	add    $0x2c,%esp
  8013c7:	5b                   	pop    %ebx
  8013c8:	5e                   	pop    %esi
  8013c9:	5f                   	pop    %edi
  8013ca:	5d                   	pop    %ebp
  8013cb:	c3                   	ret    

008013cc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	57                   	push   %edi
  8013d0:	56                   	push   %esi
  8013d1:	53                   	push   %ebx
  8013d2:	83 ec 1c             	sub    $0x1c,%esp
  8013d5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8013d8:	89 34 24             	mov    %esi,(%esp)
  8013db:	e8 20 f1 ff ff       	call   800500 <fd2data>
  8013e0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8013e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8013e7:	eb 45                	jmp    80142e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8013e9:	89 da                	mov    %ebx,%edx
  8013eb:	89 f0                	mov    %esi,%eax
  8013ed:	e8 71 ff ff ff       	call   801363 <_pipeisclosed>
  8013f2:	85 c0                	test   %eax,%eax
  8013f4:	75 41                	jne    801437 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8013f6:	e8 89 ed ff ff       	call   800184 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8013fb:	8b 43 04             	mov    0x4(%ebx),%eax
  8013fe:	8b 0b                	mov    (%ebx),%ecx
  801400:	8d 51 20             	lea    0x20(%ecx),%edx
  801403:	39 d0                	cmp    %edx,%eax
  801405:	73 e2                	jae    8013e9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801407:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80140a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80140e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801411:	99                   	cltd   
  801412:	c1 ea 1b             	shr    $0x1b,%edx
  801415:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801418:	83 e1 1f             	and    $0x1f,%ecx
  80141b:	29 d1                	sub    %edx,%ecx
  80141d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801421:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801425:	83 c0 01             	add    $0x1,%eax
  801428:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80142b:	83 c7 01             	add    $0x1,%edi
  80142e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801431:	75 c8                	jne    8013fb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801433:	89 f8                	mov    %edi,%eax
  801435:	eb 05                	jmp    80143c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801437:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80143c:	83 c4 1c             	add    $0x1c,%esp
  80143f:	5b                   	pop    %ebx
  801440:	5e                   	pop    %esi
  801441:	5f                   	pop    %edi
  801442:	5d                   	pop    %ebp
  801443:	c3                   	ret    

00801444 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	57                   	push   %edi
  801448:	56                   	push   %esi
  801449:	53                   	push   %ebx
  80144a:	83 ec 1c             	sub    $0x1c,%esp
  80144d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801450:	89 3c 24             	mov    %edi,(%esp)
  801453:	e8 a8 f0 ff ff       	call   800500 <fd2data>
  801458:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80145a:	be 00 00 00 00       	mov    $0x0,%esi
  80145f:	eb 3d                	jmp    80149e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801461:	85 f6                	test   %esi,%esi
  801463:	74 04                	je     801469 <devpipe_read+0x25>
				return i;
  801465:	89 f0                	mov    %esi,%eax
  801467:	eb 43                	jmp    8014ac <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801469:	89 da                	mov    %ebx,%edx
  80146b:	89 f8                	mov    %edi,%eax
  80146d:	e8 f1 fe ff ff       	call   801363 <_pipeisclosed>
  801472:	85 c0                	test   %eax,%eax
  801474:	75 31                	jne    8014a7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801476:	e8 09 ed ff ff       	call   800184 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80147b:	8b 03                	mov    (%ebx),%eax
  80147d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801480:	74 df                	je     801461 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801482:	99                   	cltd   
  801483:	c1 ea 1b             	shr    $0x1b,%edx
  801486:	01 d0                	add    %edx,%eax
  801488:	83 e0 1f             	and    $0x1f,%eax
  80148b:	29 d0                	sub    %edx,%eax
  80148d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801492:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801495:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801498:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80149b:	83 c6 01             	add    $0x1,%esi
  80149e:	3b 75 10             	cmp    0x10(%ebp),%esi
  8014a1:	75 d8                	jne    80147b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8014a3:	89 f0                	mov    %esi,%eax
  8014a5:	eb 05                	jmp    8014ac <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8014a7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8014ac:	83 c4 1c             	add    $0x1c,%esp
  8014af:	5b                   	pop    %ebx
  8014b0:	5e                   	pop    %esi
  8014b1:	5f                   	pop    %edi
  8014b2:	5d                   	pop    %ebp
  8014b3:	c3                   	ret    

008014b4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	56                   	push   %esi
  8014b8:	53                   	push   %ebx
  8014b9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8014bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014bf:	89 04 24             	mov    %eax,(%esp)
  8014c2:	e8 50 f0 ff ff       	call   800517 <fd_alloc>
  8014c7:	89 c2                	mov    %eax,%edx
  8014c9:	85 d2                	test   %edx,%edx
  8014cb:	0f 88 4d 01 00 00    	js     80161e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8014d1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8014d8:	00 
  8014d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014e7:	e8 b7 ec ff ff       	call   8001a3 <sys_page_alloc>
  8014ec:	89 c2                	mov    %eax,%edx
  8014ee:	85 d2                	test   %edx,%edx
  8014f0:	0f 88 28 01 00 00    	js     80161e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8014f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f9:	89 04 24             	mov    %eax,(%esp)
  8014fc:	e8 16 f0 ff ff       	call   800517 <fd_alloc>
  801501:	89 c3                	mov    %eax,%ebx
  801503:	85 c0                	test   %eax,%eax
  801505:	0f 88 fe 00 00 00    	js     801609 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80150b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801512:	00 
  801513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801516:	89 44 24 04          	mov    %eax,0x4(%esp)
  80151a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801521:	e8 7d ec ff ff       	call   8001a3 <sys_page_alloc>
  801526:	89 c3                	mov    %eax,%ebx
  801528:	85 c0                	test   %eax,%eax
  80152a:	0f 88 d9 00 00 00    	js     801609 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801533:	89 04 24             	mov    %eax,(%esp)
  801536:	e8 c5 ef ff ff       	call   800500 <fd2data>
  80153b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80153d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801544:	00 
  801545:	89 44 24 04          	mov    %eax,0x4(%esp)
  801549:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801550:	e8 4e ec ff ff       	call   8001a3 <sys_page_alloc>
  801555:	89 c3                	mov    %eax,%ebx
  801557:	85 c0                	test   %eax,%eax
  801559:	0f 88 97 00 00 00    	js     8015f6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80155f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801562:	89 04 24             	mov    %eax,(%esp)
  801565:	e8 96 ef ff ff       	call   800500 <fd2data>
  80156a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801571:	00 
  801572:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801576:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80157d:	00 
  80157e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801582:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801589:	e8 69 ec ff ff       	call   8001f7 <sys_page_map>
  80158e:	89 c3                	mov    %eax,%ebx
  801590:	85 c0                	test   %eax,%eax
  801592:	78 52                	js     8015e6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801594:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8015a9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8015af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8015b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8015be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c1:	89 04 24             	mov    %eax,(%esp)
  8015c4:	e8 27 ef ff ff       	call   8004f0 <fd2num>
  8015c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015cc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8015ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d1:	89 04 24             	mov    %eax,(%esp)
  8015d4:	e8 17 ef ff ff       	call   8004f0 <fd2num>
  8015d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015dc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8015df:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e4:	eb 38                	jmp    80161e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8015e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015f1:	e8 54 ec ff ff       	call   80024a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8015f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801604:	e8 41 ec ff ff       	call   80024a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801610:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801617:	e8 2e ec ff ff       	call   80024a <sys_page_unmap>
  80161c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80161e:	83 c4 30             	add    $0x30,%esp
  801621:	5b                   	pop    %ebx
  801622:	5e                   	pop    %esi
  801623:	5d                   	pop    %ebp
  801624:	c3                   	ret    

00801625 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801625:	55                   	push   %ebp
  801626:	89 e5                	mov    %esp,%ebp
  801628:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80162b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80162e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	89 04 24             	mov    %eax,(%esp)
  801638:	e8 29 ef ff ff       	call   800566 <fd_lookup>
  80163d:	89 c2                	mov    %eax,%edx
  80163f:	85 d2                	test   %edx,%edx
  801641:	78 15                	js     801658 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801646:	89 04 24             	mov    %eax,(%esp)
  801649:	e8 b2 ee ff ff       	call   800500 <fd2data>
	return _pipeisclosed(fd, p);
  80164e:	89 c2                	mov    %eax,%edx
  801650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801653:	e8 0b fd ff ff       	call   801363 <_pipeisclosed>
}
  801658:	c9                   	leave  
  801659:	c3                   	ret    
  80165a:	66 90                	xchg   %ax,%ax
  80165c:	66 90                	xchg   %ax,%ax
  80165e:	66 90                	xchg   %ax,%ax

00801660 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801663:	b8 00 00 00 00       	mov    $0x0,%eax
  801668:	5d                   	pop    %ebp
  801669:	c3                   	ret    

0080166a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801670:	c7 44 24 04 d3 27 80 	movl   $0x8027d3,0x4(%esp)
  801677:	00 
  801678:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167b:	89 04 24             	mov    %eax,(%esp)
  80167e:	e8 a4 08 00 00       	call   801f27 <strcpy>
	return 0;
}
  801683:	b8 00 00 00 00       	mov    $0x0,%eax
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	57                   	push   %edi
  80168e:	56                   	push   %esi
  80168f:	53                   	push   %ebx
  801690:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801696:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80169b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8016a1:	eb 31                	jmp    8016d4 <devcons_write+0x4a>
		m = n - tot;
  8016a3:	8b 75 10             	mov    0x10(%ebp),%esi
  8016a6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8016a8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8016ab:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8016b0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8016b3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8016b7:	03 45 0c             	add    0xc(%ebp),%eax
  8016ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016be:	89 3c 24             	mov    %edi,(%esp)
  8016c1:	e8 fe 09 00 00       	call   8020c4 <memmove>
		sys_cputs(buf, m);
  8016c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016ca:	89 3c 24             	mov    %edi,(%esp)
  8016cd:	e8 04 ea ff ff       	call   8000d6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8016d2:	01 f3                	add    %esi,%ebx
  8016d4:	89 d8                	mov    %ebx,%eax
  8016d6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8016d9:	72 c8                	jb     8016a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8016db:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8016e1:	5b                   	pop    %ebx
  8016e2:	5e                   	pop    %esi
  8016e3:	5f                   	pop    %edi
  8016e4:	5d                   	pop    %ebp
  8016e5:	c3                   	ret    

008016e6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8016ec:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8016f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016f5:	75 07                	jne    8016fe <devcons_read+0x18>
  8016f7:	eb 2a                	jmp    801723 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8016f9:	e8 86 ea ff ff       	call   800184 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8016fe:	66 90                	xchg   %ax,%ax
  801700:	e8 ef e9 ff ff       	call   8000f4 <sys_cgetc>
  801705:	85 c0                	test   %eax,%eax
  801707:	74 f0                	je     8016f9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801709:	85 c0                	test   %eax,%eax
  80170b:	78 16                	js     801723 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80170d:	83 f8 04             	cmp    $0x4,%eax
  801710:	74 0c                	je     80171e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  801712:	8b 55 0c             	mov    0xc(%ebp),%edx
  801715:	88 02                	mov    %al,(%edx)
	return 1;
  801717:	b8 01 00 00 00       	mov    $0x1,%eax
  80171c:	eb 05                	jmp    801723 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80171e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801731:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801738:	00 
  801739:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80173c:	89 04 24             	mov    %eax,(%esp)
  80173f:	e8 92 e9 ff ff       	call   8000d6 <sys_cputs>
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <getchar>:

int
getchar(void)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80174c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801753:	00 
  801754:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801757:	89 44 24 04          	mov    %eax,0x4(%esp)
  80175b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801762:	e8 93 f0 ff ff       	call   8007fa <read>
	if (r < 0)
  801767:	85 c0                	test   %eax,%eax
  801769:	78 0f                	js     80177a <getchar+0x34>
		return r;
	if (r < 1)
  80176b:	85 c0                	test   %eax,%eax
  80176d:	7e 06                	jle    801775 <getchar+0x2f>
		return -E_EOF;
	return c;
  80176f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801773:	eb 05                	jmp    80177a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801775:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    

0080177c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801782:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801785:	89 44 24 04          	mov    %eax,0x4(%esp)
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	89 04 24             	mov    %eax,(%esp)
  80178f:	e8 d2 ed ff ff       	call   800566 <fd_lookup>
  801794:	85 c0                	test   %eax,%eax
  801796:	78 11                	js     8017a9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8017a1:	39 10                	cmp    %edx,(%eax)
  8017a3:	0f 94 c0             	sete   %al
  8017a6:	0f b6 c0             	movzbl %al,%eax
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <opencons>:

int
opencons(void)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8017b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b4:	89 04 24             	mov    %eax,(%esp)
  8017b7:	e8 5b ed ff ff       	call   800517 <fd_alloc>
		return r;
  8017bc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8017be:	85 c0                	test   %eax,%eax
  8017c0:	78 40                	js     801802 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8017c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8017c9:	00 
  8017ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017d8:	e8 c6 e9 ff ff       	call   8001a3 <sys_page_alloc>
		return r;
  8017dd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	78 1f                	js     801802 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8017e3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8017e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8017ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8017f8:	89 04 24             	mov    %eax,(%esp)
  8017fb:	e8 f0 ec ff ff       	call   8004f0 <fd2num>
  801800:	89 c2                	mov    %eax,%edx
}
  801802:	89 d0                	mov    %edx,%eax
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	56                   	push   %esi
  80180a:	53                   	push   %ebx
  80180b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80180e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801811:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801817:	e8 49 e9 ff ff       	call   800165 <sys_getenvid>
  80181c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181f:	89 54 24 10          	mov    %edx,0x10(%esp)
  801823:	8b 55 08             	mov    0x8(%ebp),%edx
  801826:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80182a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80182e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801832:	c7 04 24 e0 27 80 00 	movl   $0x8027e0,(%esp)
  801839:	e8 c1 00 00 00       	call   8018ff <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80183e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801842:	8b 45 10             	mov    0x10(%ebp),%eax
  801845:	89 04 24             	mov    %eax,(%esp)
  801848:	e8 51 00 00 00       	call   80189e <vcprintf>
	cprintf("\n");
  80184d:	c7 04 24 cc 27 80 00 	movl   $0x8027cc,(%esp)
  801854:	e8 a6 00 00 00       	call   8018ff <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801859:	cc                   	int3   
  80185a:	eb fd                	jmp    801859 <_panic+0x53>

0080185c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	53                   	push   %ebx
  801860:	83 ec 14             	sub    $0x14,%esp
  801863:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801866:	8b 13                	mov    (%ebx),%edx
  801868:	8d 42 01             	lea    0x1(%edx),%eax
  80186b:	89 03                	mov    %eax,(%ebx)
  80186d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801870:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801874:	3d ff 00 00 00       	cmp    $0xff,%eax
  801879:	75 19                	jne    801894 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80187b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801882:	00 
  801883:	8d 43 08             	lea    0x8(%ebx),%eax
  801886:	89 04 24             	mov    %eax,(%esp)
  801889:	e8 48 e8 ff ff       	call   8000d6 <sys_cputs>
		b->idx = 0;
  80188e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801894:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801898:	83 c4 14             	add    $0x14,%esp
  80189b:	5b                   	pop    %ebx
  80189c:	5d                   	pop    %ebp
  80189d:	c3                   	ret    

0080189e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8018a7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8018ae:	00 00 00 
	b.cnt = 0;
  8018b1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8018b8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8018bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018c9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8018cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d3:	c7 04 24 5c 18 80 00 	movl   $0x80185c,(%esp)
  8018da:	e8 af 01 00 00       	call   801a8e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8018df:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8018e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8018ef:	89 04 24             	mov    %eax,(%esp)
  8018f2:	e8 df e7 ff ff       	call   8000d6 <sys_cputs>

	return b.cnt;
}
  8018f7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801905:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801908:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	89 04 24             	mov    %eax,(%esp)
  801912:	e8 87 ff ff ff       	call   80189e <vcprintf>
	va_end(ap);

	return cnt;
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    
  801919:	66 90                	xchg   %ax,%ax
  80191b:	66 90                	xchg   %ax,%ax
  80191d:	66 90                	xchg   %ax,%ax
  80191f:	90                   	nop

00801920 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	57                   	push   %edi
  801924:	56                   	push   %esi
  801925:	53                   	push   %ebx
  801926:	83 ec 3c             	sub    $0x3c,%esp
  801929:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80192c:	89 d7                	mov    %edx,%edi
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801934:	8b 45 0c             	mov    0xc(%ebp),%eax
  801937:	89 c3                	mov    %eax,%ebx
  801939:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80193c:	8b 45 10             	mov    0x10(%ebp),%eax
  80193f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801942:	b9 00 00 00 00       	mov    $0x0,%ecx
  801947:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80194a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80194d:	39 d9                	cmp    %ebx,%ecx
  80194f:	72 05                	jb     801956 <printnum+0x36>
  801951:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801954:	77 69                	ja     8019bf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801956:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801959:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80195d:	83 ee 01             	sub    $0x1,%esi
  801960:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801964:	89 44 24 08          	mov    %eax,0x8(%esp)
  801968:	8b 44 24 08          	mov    0x8(%esp),%eax
  80196c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801970:	89 c3                	mov    %eax,%ebx
  801972:	89 d6                	mov    %edx,%esi
  801974:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801977:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80197a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80197e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801982:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801985:	89 04 24             	mov    %eax,(%esp)
  801988:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80198b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80198f:	e8 5c 0a 00 00       	call   8023f0 <__udivdi3>
  801994:	89 d9                	mov    %ebx,%ecx
  801996:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80199a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80199e:	89 04 24             	mov    %eax,(%esp)
  8019a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019a5:	89 fa                	mov    %edi,%edx
  8019a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019aa:	e8 71 ff ff ff       	call   801920 <printnum>
  8019af:	eb 1b                	jmp    8019cc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8019b1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8019b8:	89 04 24             	mov    %eax,(%esp)
  8019bb:	ff d3                	call   *%ebx
  8019bd:	eb 03                	jmp    8019c2 <printnum+0xa2>
  8019bf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8019c2:	83 ee 01             	sub    $0x1,%esi
  8019c5:	85 f6                	test   %esi,%esi
  8019c7:	7f e8                	jg     8019b1 <printnum+0x91>
  8019c9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8019cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019d0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8019d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8019da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019de:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8019e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019e5:	89 04 24             	mov    %eax,(%esp)
  8019e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ef:	e8 2c 0b 00 00       	call   802520 <__umoddi3>
  8019f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019f8:	0f be 80 03 28 80 00 	movsbl 0x802803(%eax),%eax
  8019ff:	89 04 24             	mov    %eax,(%esp)
  801a02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a05:	ff d0                	call   *%eax
}
  801a07:	83 c4 3c             	add    $0x3c,%esp
  801a0a:	5b                   	pop    %ebx
  801a0b:	5e                   	pop    %esi
  801a0c:	5f                   	pop    %edi
  801a0d:	5d                   	pop    %ebp
  801a0e:	c3                   	ret    

00801a0f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801a12:	83 fa 01             	cmp    $0x1,%edx
  801a15:	7e 0e                	jle    801a25 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801a17:	8b 10                	mov    (%eax),%edx
  801a19:	8d 4a 08             	lea    0x8(%edx),%ecx
  801a1c:	89 08                	mov    %ecx,(%eax)
  801a1e:	8b 02                	mov    (%edx),%eax
  801a20:	8b 52 04             	mov    0x4(%edx),%edx
  801a23:	eb 22                	jmp    801a47 <getuint+0x38>
	else if (lflag)
  801a25:	85 d2                	test   %edx,%edx
  801a27:	74 10                	je     801a39 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801a29:	8b 10                	mov    (%eax),%edx
  801a2b:	8d 4a 04             	lea    0x4(%edx),%ecx
  801a2e:	89 08                	mov    %ecx,(%eax)
  801a30:	8b 02                	mov    (%edx),%eax
  801a32:	ba 00 00 00 00       	mov    $0x0,%edx
  801a37:	eb 0e                	jmp    801a47 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801a39:	8b 10                	mov    (%eax),%edx
  801a3b:	8d 4a 04             	lea    0x4(%edx),%ecx
  801a3e:	89 08                	mov    %ecx,(%eax)
  801a40:	8b 02                	mov    (%edx),%eax
  801a42:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a47:	5d                   	pop    %ebp
  801a48:	c3                   	ret    

00801a49 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801a4f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801a53:	8b 10                	mov    (%eax),%edx
  801a55:	3b 50 04             	cmp    0x4(%eax),%edx
  801a58:	73 0a                	jae    801a64 <sprintputch+0x1b>
		*b->buf++ = ch;
  801a5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a5d:	89 08                	mov    %ecx,(%eax)
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	88 02                	mov    %al,(%edx)
}
  801a64:	5d                   	pop    %ebp
  801a65:	c3                   	ret    

00801a66 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801a6c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801a6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a73:	8b 45 10             	mov    0x10(%ebp),%eax
  801a76:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	89 04 24             	mov    %eax,(%esp)
  801a87:	e8 02 00 00 00       	call   801a8e <vprintfmt>
	va_end(ap);
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	57                   	push   %edi
  801a92:	56                   	push   %esi
  801a93:	53                   	push   %ebx
  801a94:	83 ec 3c             	sub    $0x3c,%esp
  801a97:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801a9a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a9d:	eb 14                	jmp    801ab3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801a9f:	85 c0                	test   %eax,%eax
  801aa1:	0f 84 b3 03 00 00    	je     801e5a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  801aa7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801aab:	89 04 24             	mov    %eax,(%esp)
  801aae:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ab1:	89 f3                	mov    %esi,%ebx
  801ab3:	8d 73 01             	lea    0x1(%ebx),%esi
  801ab6:	0f b6 03             	movzbl (%ebx),%eax
  801ab9:	83 f8 25             	cmp    $0x25,%eax
  801abc:	75 e1                	jne    801a9f <vprintfmt+0x11>
  801abe:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  801ac2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ac9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  801ad0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  801ad7:	ba 00 00 00 00       	mov    $0x0,%edx
  801adc:	eb 1d                	jmp    801afb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ade:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  801ae0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801ae4:	eb 15                	jmp    801afb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ae6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801ae8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801aec:	eb 0d                	jmp    801afb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801aee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801af1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801af4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801afb:	8d 5e 01             	lea    0x1(%esi),%ebx
  801afe:	0f b6 0e             	movzbl (%esi),%ecx
  801b01:	0f b6 c1             	movzbl %cl,%eax
  801b04:	83 e9 23             	sub    $0x23,%ecx
  801b07:	80 f9 55             	cmp    $0x55,%cl
  801b0a:	0f 87 2a 03 00 00    	ja     801e3a <vprintfmt+0x3ac>
  801b10:	0f b6 c9             	movzbl %cl,%ecx
  801b13:	ff 24 8d 40 29 80 00 	jmp    *0x802940(,%ecx,4)
  801b1a:	89 de                	mov    %ebx,%esi
  801b1c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801b21:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801b24:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801b28:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801b2b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  801b2e:	83 fb 09             	cmp    $0x9,%ebx
  801b31:	77 36                	ja     801b69 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b33:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b36:	eb e9                	jmp    801b21 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b38:	8b 45 14             	mov    0x14(%ebp),%eax
  801b3b:	8d 48 04             	lea    0x4(%eax),%ecx
  801b3e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801b41:	8b 00                	mov    (%eax),%eax
  801b43:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b46:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801b48:	eb 22                	jmp    801b6c <vprintfmt+0xde>
  801b4a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801b4d:	85 c9                	test   %ecx,%ecx
  801b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b54:	0f 49 c1             	cmovns %ecx,%eax
  801b57:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b5a:	89 de                	mov    %ebx,%esi
  801b5c:	eb 9d                	jmp    801afb <vprintfmt+0x6d>
  801b5e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801b60:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  801b67:	eb 92                	jmp    801afb <vprintfmt+0x6d>
  801b69:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  801b6c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801b70:	79 89                	jns    801afb <vprintfmt+0x6d>
  801b72:	e9 77 ff ff ff       	jmp    801aee <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b77:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b7a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801b7c:	e9 7a ff ff ff       	jmp    801afb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b81:	8b 45 14             	mov    0x14(%ebp),%eax
  801b84:	8d 50 04             	lea    0x4(%eax),%edx
  801b87:	89 55 14             	mov    %edx,0x14(%ebp)
  801b8a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b8e:	8b 00                	mov    (%eax),%eax
  801b90:	89 04 24             	mov    %eax,(%esp)
  801b93:	ff 55 08             	call   *0x8(%ebp)
			break;
  801b96:	e9 18 ff ff ff       	jmp    801ab3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b9b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9e:	8d 50 04             	lea    0x4(%eax),%edx
  801ba1:	89 55 14             	mov    %edx,0x14(%ebp)
  801ba4:	8b 00                	mov    (%eax),%eax
  801ba6:	99                   	cltd   
  801ba7:	31 d0                	xor    %edx,%eax
  801ba9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801bab:	83 f8 11             	cmp    $0x11,%eax
  801bae:	7f 0b                	jg     801bbb <vprintfmt+0x12d>
  801bb0:	8b 14 85 a0 2a 80 00 	mov    0x802aa0(,%eax,4),%edx
  801bb7:	85 d2                	test   %edx,%edx
  801bb9:	75 20                	jne    801bdb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  801bbb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bbf:	c7 44 24 08 1b 28 80 	movl   $0x80281b,0x8(%esp)
  801bc6:	00 
  801bc7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bce:	89 04 24             	mov    %eax,(%esp)
  801bd1:	e8 90 fe ff ff       	call   801a66 <printfmt>
  801bd6:	e9 d8 fe ff ff       	jmp    801ab3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  801bdb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801bdf:	c7 44 24 08 61 27 80 	movl   $0x802761,0x8(%esp)
  801be6:	00 
  801be7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	89 04 24             	mov    %eax,(%esp)
  801bf1:	e8 70 fe ff ff       	call   801a66 <printfmt>
  801bf6:	e9 b8 fe ff ff       	jmp    801ab3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801bfb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  801bfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c01:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801c04:	8b 45 14             	mov    0x14(%ebp),%eax
  801c07:	8d 50 04             	lea    0x4(%eax),%edx
  801c0a:	89 55 14             	mov    %edx,0x14(%ebp)
  801c0d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  801c0f:	85 f6                	test   %esi,%esi
  801c11:	b8 14 28 80 00       	mov    $0x802814,%eax
  801c16:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  801c19:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  801c1d:	0f 84 97 00 00 00    	je     801cba <vprintfmt+0x22c>
  801c23:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801c27:	0f 8e 9b 00 00 00    	jle    801cc8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  801c2d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c31:	89 34 24             	mov    %esi,(%esp)
  801c34:	e8 cf 02 00 00       	call   801f08 <strnlen>
  801c39:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801c3c:	29 c2                	sub    %eax,%edx
  801c3e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  801c41:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  801c45:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c48:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801c4b:	8b 75 08             	mov    0x8(%ebp),%esi
  801c4e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801c51:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c53:	eb 0f                	jmp    801c64 <vprintfmt+0x1d6>
					putch(padc, putdat);
  801c55:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c59:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c5c:	89 04 24             	mov    %eax,(%esp)
  801c5f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c61:	83 eb 01             	sub    $0x1,%ebx
  801c64:	85 db                	test   %ebx,%ebx
  801c66:	7f ed                	jg     801c55 <vprintfmt+0x1c7>
  801c68:	8b 75 d8             	mov    -0x28(%ebp),%esi
  801c6b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801c6e:	85 d2                	test   %edx,%edx
  801c70:	b8 00 00 00 00       	mov    $0x0,%eax
  801c75:	0f 49 c2             	cmovns %edx,%eax
  801c78:	29 c2                	sub    %eax,%edx
  801c7a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801c7d:	89 d7                	mov    %edx,%edi
  801c7f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801c82:	eb 50                	jmp    801cd4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801c84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c88:	74 1e                	je     801ca8 <vprintfmt+0x21a>
  801c8a:	0f be d2             	movsbl %dl,%edx
  801c8d:	83 ea 20             	sub    $0x20,%edx
  801c90:	83 fa 5e             	cmp    $0x5e,%edx
  801c93:	76 13                	jbe    801ca8 <vprintfmt+0x21a>
					putch('?', putdat);
  801c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801ca3:	ff 55 08             	call   *0x8(%ebp)
  801ca6:	eb 0d                	jmp    801cb5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  801ca8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cab:	89 54 24 04          	mov    %edx,0x4(%esp)
  801caf:	89 04 24             	mov    %eax,(%esp)
  801cb2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801cb5:	83 ef 01             	sub    $0x1,%edi
  801cb8:	eb 1a                	jmp    801cd4 <vprintfmt+0x246>
  801cba:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801cbd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801cc0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801cc3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801cc6:	eb 0c                	jmp    801cd4 <vprintfmt+0x246>
  801cc8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801ccb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801cce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801cd1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801cd4:	83 c6 01             	add    $0x1,%esi
  801cd7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  801cdb:	0f be c2             	movsbl %dl,%eax
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	74 27                	je     801d09 <vprintfmt+0x27b>
  801ce2:	85 db                	test   %ebx,%ebx
  801ce4:	78 9e                	js     801c84 <vprintfmt+0x1f6>
  801ce6:	83 eb 01             	sub    $0x1,%ebx
  801ce9:	79 99                	jns    801c84 <vprintfmt+0x1f6>
  801ceb:	89 f8                	mov    %edi,%eax
  801ced:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801cf0:	8b 75 08             	mov    0x8(%ebp),%esi
  801cf3:	89 c3                	mov    %eax,%ebx
  801cf5:	eb 1a                	jmp    801d11 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801cf7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801cfb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801d02:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801d04:	83 eb 01             	sub    $0x1,%ebx
  801d07:	eb 08                	jmp    801d11 <vprintfmt+0x283>
  801d09:	89 fb                	mov    %edi,%ebx
  801d0b:	8b 75 08             	mov    0x8(%ebp),%esi
  801d0e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d11:	85 db                	test   %ebx,%ebx
  801d13:	7f e2                	jg     801cf7 <vprintfmt+0x269>
  801d15:	89 75 08             	mov    %esi,0x8(%ebp)
  801d18:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d1b:	e9 93 fd ff ff       	jmp    801ab3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801d20:	83 fa 01             	cmp    $0x1,%edx
  801d23:	7e 16                	jle    801d3b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  801d25:	8b 45 14             	mov    0x14(%ebp),%eax
  801d28:	8d 50 08             	lea    0x8(%eax),%edx
  801d2b:	89 55 14             	mov    %edx,0x14(%ebp)
  801d2e:	8b 50 04             	mov    0x4(%eax),%edx
  801d31:	8b 00                	mov    (%eax),%eax
  801d33:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d36:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801d39:	eb 32                	jmp    801d6d <vprintfmt+0x2df>
	else if (lflag)
  801d3b:	85 d2                	test   %edx,%edx
  801d3d:	74 18                	je     801d57 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  801d3f:	8b 45 14             	mov    0x14(%ebp),%eax
  801d42:	8d 50 04             	lea    0x4(%eax),%edx
  801d45:	89 55 14             	mov    %edx,0x14(%ebp)
  801d48:	8b 30                	mov    (%eax),%esi
  801d4a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801d4d:	89 f0                	mov    %esi,%eax
  801d4f:	c1 f8 1f             	sar    $0x1f,%eax
  801d52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d55:	eb 16                	jmp    801d6d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  801d57:	8b 45 14             	mov    0x14(%ebp),%eax
  801d5a:	8d 50 04             	lea    0x4(%eax),%edx
  801d5d:	89 55 14             	mov    %edx,0x14(%ebp)
  801d60:	8b 30                	mov    (%eax),%esi
  801d62:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801d65:	89 f0                	mov    %esi,%eax
  801d67:	c1 f8 1f             	sar    $0x1f,%eax
  801d6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801d6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801d73:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801d78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d7c:	0f 89 80 00 00 00    	jns    801e02 <vprintfmt+0x374>
				putch('-', putdat);
  801d82:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d86:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801d8d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801d90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d96:	f7 d8                	neg    %eax
  801d98:	83 d2 00             	adc    $0x0,%edx
  801d9b:	f7 da                	neg    %edx
			}
			base = 10;
  801d9d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801da2:	eb 5e                	jmp    801e02 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801da4:	8d 45 14             	lea    0x14(%ebp),%eax
  801da7:	e8 63 fc ff ff       	call   801a0f <getuint>
			base = 10;
  801dac:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801db1:	eb 4f                	jmp    801e02 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  801db3:	8d 45 14             	lea    0x14(%ebp),%eax
  801db6:	e8 54 fc ff ff       	call   801a0f <getuint>
			base = 8;
  801dbb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801dc0:	eb 40                	jmp    801e02 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  801dc2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801dc6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801dcd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801dd0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801dd4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801ddb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801dde:	8b 45 14             	mov    0x14(%ebp),%eax
  801de1:	8d 50 04             	lea    0x4(%eax),%edx
  801de4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801de7:	8b 00                	mov    (%eax),%eax
  801de9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801dee:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801df3:	eb 0d                	jmp    801e02 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801df5:	8d 45 14             	lea    0x14(%ebp),%eax
  801df8:	e8 12 fc ff ff       	call   801a0f <getuint>
			base = 16;
  801dfd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801e02:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  801e06:	89 74 24 10          	mov    %esi,0x10(%esp)
  801e0a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  801e0d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e11:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e15:	89 04 24             	mov    %eax,(%esp)
  801e18:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e1c:	89 fa                	mov    %edi,%edx
  801e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e21:	e8 fa fa ff ff       	call   801920 <printnum>
			break;
  801e26:	e9 88 fc ff ff       	jmp    801ab3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801e2b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e2f:	89 04 24             	mov    %eax,(%esp)
  801e32:	ff 55 08             	call   *0x8(%ebp)
			break;
  801e35:	e9 79 fc ff ff       	jmp    801ab3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801e3a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e3e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801e45:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e48:	89 f3                	mov    %esi,%ebx
  801e4a:	eb 03                	jmp    801e4f <vprintfmt+0x3c1>
  801e4c:	83 eb 01             	sub    $0x1,%ebx
  801e4f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801e53:	75 f7                	jne    801e4c <vprintfmt+0x3be>
  801e55:	e9 59 fc ff ff       	jmp    801ab3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  801e5a:	83 c4 3c             	add    $0x3c,%esp
  801e5d:	5b                   	pop    %ebx
  801e5e:	5e                   	pop    %esi
  801e5f:	5f                   	pop    %edi
  801e60:	5d                   	pop    %ebp
  801e61:	c3                   	ret    

00801e62 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 28             	sub    $0x28,%esp
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e71:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801e75:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801e78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801e7f:	85 c0                	test   %eax,%eax
  801e81:	74 30                	je     801eb3 <vsnprintf+0x51>
  801e83:	85 d2                	test   %edx,%edx
  801e85:	7e 2c                	jle    801eb3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801e87:	8b 45 14             	mov    0x14(%ebp),%eax
  801e8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e8e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e91:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e95:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801e98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e9c:	c7 04 24 49 1a 80 00 	movl   $0x801a49,(%esp)
  801ea3:	e8 e6 fb ff ff       	call   801a8e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eab:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb1:	eb 05                	jmp    801eb8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801eb3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801ec0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801ec3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  801eca:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed8:	89 04 24             	mov    %eax,(%esp)
  801edb:	e8 82 ff ff ff       	call   801e62 <vsnprintf>
	va_end(ap);

	return rc;
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    
  801ee2:	66 90                	xchg   %ax,%ax
  801ee4:	66 90                	xchg   %ax,%ax
  801ee6:	66 90                	xchg   %ax,%ax
  801ee8:	66 90                	xchg   %ax,%ax
  801eea:	66 90                	xchg   %ax,%ax
  801eec:	66 90                	xchg   %ax,%ax
  801eee:	66 90                	xchg   %ax,%ax

00801ef0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801ef6:	b8 00 00 00 00       	mov    $0x0,%eax
  801efb:	eb 03                	jmp    801f00 <strlen+0x10>
		n++;
  801efd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801f00:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801f04:	75 f7                	jne    801efd <strlen+0xd>
		n++;
	return n;
}
  801f06:	5d                   	pop    %ebp
  801f07:	c3                   	ret    

00801f08 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f0e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f11:	b8 00 00 00 00       	mov    $0x0,%eax
  801f16:	eb 03                	jmp    801f1b <strnlen+0x13>
		n++;
  801f18:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f1b:	39 d0                	cmp    %edx,%eax
  801f1d:	74 06                	je     801f25 <strnlen+0x1d>
  801f1f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801f23:	75 f3                	jne    801f18 <strnlen+0x10>
		n++;
	return n;
}
  801f25:	5d                   	pop    %ebp
  801f26:	c3                   	ret    

00801f27 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	53                   	push   %ebx
  801f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801f31:	89 c2                	mov    %eax,%edx
  801f33:	83 c2 01             	add    $0x1,%edx
  801f36:	83 c1 01             	add    $0x1,%ecx
  801f39:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801f3d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801f40:	84 db                	test   %bl,%bl
  801f42:	75 ef                	jne    801f33 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801f44:	5b                   	pop    %ebx
  801f45:	5d                   	pop    %ebp
  801f46:	c3                   	ret    

00801f47 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
  801f4a:	53                   	push   %ebx
  801f4b:	83 ec 08             	sub    $0x8,%esp
  801f4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801f51:	89 1c 24             	mov    %ebx,(%esp)
  801f54:	e8 97 ff ff ff       	call   801ef0 <strlen>
	strcpy(dst + len, src);
  801f59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f60:	01 d8                	add    %ebx,%eax
  801f62:	89 04 24             	mov    %eax,(%esp)
  801f65:	e8 bd ff ff ff       	call   801f27 <strcpy>
	return dst;
}
  801f6a:	89 d8                	mov    %ebx,%eax
  801f6c:	83 c4 08             	add    $0x8,%esp
  801f6f:	5b                   	pop    %ebx
  801f70:	5d                   	pop    %ebp
  801f71:	c3                   	ret    

00801f72 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	56                   	push   %esi
  801f76:	53                   	push   %ebx
  801f77:	8b 75 08             	mov    0x8(%ebp),%esi
  801f7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f7d:	89 f3                	mov    %esi,%ebx
  801f7f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801f82:	89 f2                	mov    %esi,%edx
  801f84:	eb 0f                	jmp    801f95 <strncpy+0x23>
		*dst++ = *src;
  801f86:	83 c2 01             	add    $0x1,%edx
  801f89:	0f b6 01             	movzbl (%ecx),%eax
  801f8c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801f8f:	80 39 01             	cmpb   $0x1,(%ecx)
  801f92:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801f95:	39 da                	cmp    %ebx,%edx
  801f97:	75 ed                	jne    801f86 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801f99:	89 f0                	mov    %esi,%eax
  801f9b:	5b                   	pop    %ebx
  801f9c:	5e                   	pop    %esi
  801f9d:	5d                   	pop    %ebp
  801f9e:	c3                   	ret    

00801f9f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	56                   	push   %esi
  801fa3:	53                   	push   %ebx
  801fa4:	8b 75 08             	mov    0x8(%ebp),%esi
  801fa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801faa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fad:	89 f0                	mov    %esi,%eax
  801faf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801fb3:	85 c9                	test   %ecx,%ecx
  801fb5:	75 0b                	jne    801fc2 <strlcpy+0x23>
  801fb7:	eb 1d                	jmp    801fd6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801fb9:	83 c0 01             	add    $0x1,%eax
  801fbc:	83 c2 01             	add    $0x1,%edx
  801fbf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801fc2:	39 d8                	cmp    %ebx,%eax
  801fc4:	74 0b                	je     801fd1 <strlcpy+0x32>
  801fc6:	0f b6 0a             	movzbl (%edx),%ecx
  801fc9:	84 c9                	test   %cl,%cl
  801fcb:	75 ec                	jne    801fb9 <strlcpy+0x1a>
  801fcd:	89 c2                	mov    %eax,%edx
  801fcf:	eb 02                	jmp    801fd3 <strlcpy+0x34>
  801fd1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  801fd3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  801fd6:	29 f0                	sub    %esi,%eax
}
  801fd8:	5b                   	pop    %ebx
  801fd9:	5e                   	pop    %esi
  801fda:	5d                   	pop    %ebp
  801fdb:	c3                   	ret    

00801fdc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fe2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801fe5:	eb 06                	jmp    801fed <strcmp+0x11>
		p++, q++;
  801fe7:	83 c1 01             	add    $0x1,%ecx
  801fea:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801fed:	0f b6 01             	movzbl (%ecx),%eax
  801ff0:	84 c0                	test   %al,%al
  801ff2:	74 04                	je     801ff8 <strcmp+0x1c>
  801ff4:	3a 02                	cmp    (%edx),%al
  801ff6:	74 ef                	je     801fe7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801ff8:	0f b6 c0             	movzbl %al,%eax
  801ffb:	0f b6 12             	movzbl (%edx),%edx
  801ffe:	29 d0                	sub    %edx,%eax
}
  802000:	5d                   	pop    %ebp
  802001:	c3                   	ret    

00802002 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
  802005:	53                   	push   %ebx
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200c:	89 c3                	mov    %eax,%ebx
  80200e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  802011:	eb 06                	jmp    802019 <strncmp+0x17>
		n--, p++, q++;
  802013:	83 c0 01             	add    $0x1,%eax
  802016:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  802019:	39 d8                	cmp    %ebx,%eax
  80201b:	74 15                	je     802032 <strncmp+0x30>
  80201d:	0f b6 08             	movzbl (%eax),%ecx
  802020:	84 c9                	test   %cl,%cl
  802022:	74 04                	je     802028 <strncmp+0x26>
  802024:	3a 0a                	cmp    (%edx),%cl
  802026:	74 eb                	je     802013 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802028:	0f b6 00             	movzbl (%eax),%eax
  80202b:	0f b6 12             	movzbl (%edx),%edx
  80202e:	29 d0                	sub    %edx,%eax
  802030:	eb 05                	jmp    802037 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  802032:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  802037:	5b                   	pop    %ebx
  802038:	5d                   	pop    %ebp
  802039:	c3                   	ret    

0080203a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802044:	eb 07                	jmp    80204d <strchr+0x13>
		if (*s == c)
  802046:	38 ca                	cmp    %cl,%dl
  802048:	74 0f                	je     802059 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80204a:	83 c0 01             	add    $0x1,%eax
  80204d:	0f b6 10             	movzbl (%eax),%edx
  802050:	84 d2                	test   %dl,%dl
  802052:	75 f2                	jne    802046 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  802054:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802059:	5d                   	pop    %ebp
  80205a:	c3                   	ret    

0080205b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802065:	eb 07                	jmp    80206e <strfind+0x13>
		if (*s == c)
  802067:	38 ca                	cmp    %cl,%dl
  802069:	74 0a                	je     802075 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80206b:	83 c0 01             	add    $0x1,%eax
  80206e:	0f b6 10             	movzbl (%eax),%edx
  802071:	84 d2                	test   %dl,%dl
  802073:	75 f2                	jne    802067 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  802075:	5d                   	pop    %ebp
  802076:	c3                   	ret    

00802077 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	57                   	push   %edi
  80207b:	56                   	push   %esi
  80207c:	53                   	push   %ebx
  80207d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802080:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802083:	85 c9                	test   %ecx,%ecx
  802085:	74 36                	je     8020bd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802087:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80208d:	75 28                	jne    8020b7 <memset+0x40>
  80208f:	f6 c1 03             	test   $0x3,%cl
  802092:	75 23                	jne    8020b7 <memset+0x40>
		c &= 0xFF;
  802094:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802098:	89 d3                	mov    %edx,%ebx
  80209a:	c1 e3 08             	shl    $0x8,%ebx
  80209d:	89 d6                	mov    %edx,%esi
  80209f:	c1 e6 18             	shl    $0x18,%esi
  8020a2:	89 d0                	mov    %edx,%eax
  8020a4:	c1 e0 10             	shl    $0x10,%eax
  8020a7:	09 f0                	or     %esi,%eax
  8020a9:	09 c2                	or     %eax,%edx
  8020ab:	89 d0                	mov    %edx,%eax
  8020ad:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8020af:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8020b2:	fc                   	cld    
  8020b3:	f3 ab                	rep stos %eax,%es:(%edi)
  8020b5:	eb 06                	jmp    8020bd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8020b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ba:	fc                   	cld    
  8020bb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8020bd:	89 f8                	mov    %edi,%eax
  8020bf:	5b                   	pop    %ebx
  8020c0:	5e                   	pop    %esi
  8020c1:	5f                   	pop    %edi
  8020c2:	5d                   	pop    %ebp
  8020c3:	c3                   	ret    

008020c4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	57                   	push   %edi
  8020c8:	56                   	push   %esi
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8020d2:	39 c6                	cmp    %eax,%esi
  8020d4:	73 35                	jae    80210b <memmove+0x47>
  8020d6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8020d9:	39 d0                	cmp    %edx,%eax
  8020db:	73 2e                	jae    80210b <memmove+0x47>
		s += n;
		d += n;
  8020dd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8020e0:	89 d6                	mov    %edx,%esi
  8020e2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8020e4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8020ea:	75 13                	jne    8020ff <memmove+0x3b>
  8020ec:	f6 c1 03             	test   $0x3,%cl
  8020ef:	75 0e                	jne    8020ff <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8020f1:	83 ef 04             	sub    $0x4,%edi
  8020f4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8020f7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8020fa:	fd                   	std    
  8020fb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8020fd:	eb 09                	jmp    802108 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8020ff:	83 ef 01             	sub    $0x1,%edi
  802102:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802105:	fd                   	std    
  802106:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802108:	fc                   	cld    
  802109:	eb 1d                	jmp    802128 <memmove+0x64>
  80210b:	89 f2                	mov    %esi,%edx
  80210d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80210f:	f6 c2 03             	test   $0x3,%dl
  802112:	75 0f                	jne    802123 <memmove+0x5f>
  802114:	f6 c1 03             	test   $0x3,%cl
  802117:	75 0a                	jne    802123 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802119:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80211c:	89 c7                	mov    %eax,%edi
  80211e:	fc                   	cld    
  80211f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802121:	eb 05                	jmp    802128 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802123:	89 c7                	mov    %eax,%edi
  802125:	fc                   	cld    
  802126:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802128:	5e                   	pop    %esi
  802129:	5f                   	pop    %edi
  80212a:	5d                   	pop    %ebp
  80212b:	c3                   	ret    

0080212c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
  80212f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  802132:	8b 45 10             	mov    0x10(%ebp),%eax
  802135:	89 44 24 08          	mov    %eax,0x8(%esp)
  802139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	89 04 24             	mov    %eax,(%esp)
  802146:	e8 79 ff ff ff       	call   8020c4 <memmove>
}
  80214b:	c9                   	leave  
  80214c:	c3                   	ret    

0080214d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80214d:	55                   	push   %ebp
  80214e:	89 e5                	mov    %esp,%ebp
  802150:	56                   	push   %esi
  802151:	53                   	push   %ebx
  802152:	8b 55 08             	mov    0x8(%ebp),%edx
  802155:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802158:	89 d6                	mov    %edx,%esi
  80215a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80215d:	eb 1a                	jmp    802179 <memcmp+0x2c>
		if (*s1 != *s2)
  80215f:	0f b6 02             	movzbl (%edx),%eax
  802162:	0f b6 19             	movzbl (%ecx),%ebx
  802165:	38 d8                	cmp    %bl,%al
  802167:	74 0a                	je     802173 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  802169:	0f b6 c0             	movzbl %al,%eax
  80216c:	0f b6 db             	movzbl %bl,%ebx
  80216f:	29 d8                	sub    %ebx,%eax
  802171:	eb 0f                	jmp    802182 <memcmp+0x35>
		s1++, s2++;
  802173:	83 c2 01             	add    $0x1,%edx
  802176:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802179:	39 f2                	cmp    %esi,%edx
  80217b:	75 e2                	jne    80215f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80217d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802182:	5b                   	pop    %ebx
  802183:	5e                   	pop    %esi
  802184:	5d                   	pop    %ebp
  802185:	c3                   	ret    

00802186 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80218f:	89 c2                	mov    %eax,%edx
  802191:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802194:	eb 07                	jmp    80219d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  802196:	38 08                	cmp    %cl,(%eax)
  802198:	74 07                	je     8021a1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80219a:	83 c0 01             	add    $0x1,%eax
  80219d:	39 d0                	cmp    %edx,%eax
  80219f:	72 f5                	jb     802196 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8021a1:	5d                   	pop    %ebp
  8021a2:	c3                   	ret    

008021a3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
  8021a6:	57                   	push   %edi
  8021a7:	56                   	push   %esi
  8021a8:	53                   	push   %ebx
  8021a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ac:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8021af:	eb 03                	jmp    8021b4 <strtol+0x11>
		s++;
  8021b1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8021b4:	0f b6 0a             	movzbl (%edx),%ecx
  8021b7:	80 f9 09             	cmp    $0x9,%cl
  8021ba:	74 f5                	je     8021b1 <strtol+0xe>
  8021bc:	80 f9 20             	cmp    $0x20,%cl
  8021bf:	74 f0                	je     8021b1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8021c1:	80 f9 2b             	cmp    $0x2b,%cl
  8021c4:	75 0a                	jne    8021d0 <strtol+0x2d>
		s++;
  8021c6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8021c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8021ce:	eb 11                	jmp    8021e1 <strtol+0x3e>
  8021d0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8021d5:	80 f9 2d             	cmp    $0x2d,%cl
  8021d8:	75 07                	jne    8021e1 <strtol+0x3e>
		s++, neg = 1;
  8021da:	8d 52 01             	lea    0x1(%edx),%edx
  8021dd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8021e1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  8021e6:	75 15                	jne    8021fd <strtol+0x5a>
  8021e8:	80 3a 30             	cmpb   $0x30,(%edx)
  8021eb:	75 10                	jne    8021fd <strtol+0x5a>
  8021ed:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8021f1:	75 0a                	jne    8021fd <strtol+0x5a>
		s += 2, base = 16;
  8021f3:	83 c2 02             	add    $0x2,%edx
  8021f6:	b8 10 00 00 00       	mov    $0x10,%eax
  8021fb:	eb 10                	jmp    80220d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  8021fd:	85 c0                	test   %eax,%eax
  8021ff:	75 0c                	jne    80220d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802201:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  802203:	80 3a 30             	cmpb   $0x30,(%edx)
  802206:	75 05                	jne    80220d <strtol+0x6a>
		s++, base = 8;
  802208:	83 c2 01             	add    $0x1,%edx
  80220b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80220d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802212:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802215:	0f b6 0a             	movzbl (%edx),%ecx
  802218:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80221b:	89 f0                	mov    %esi,%eax
  80221d:	3c 09                	cmp    $0x9,%al
  80221f:	77 08                	ja     802229 <strtol+0x86>
			dig = *s - '0';
  802221:	0f be c9             	movsbl %cl,%ecx
  802224:	83 e9 30             	sub    $0x30,%ecx
  802227:	eb 20                	jmp    802249 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  802229:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80222c:	89 f0                	mov    %esi,%eax
  80222e:	3c 19                	cmp    $0x19,%al
  802230:	77 08                	ja     80223a <strtol+0x97>
			dig = *s - 'a' + 10;
  802232:	0f be c9             	movsbl %cl,%ecx
  802235:	83 e9 57             	sub    $0x57,%ecx
  802238:	eb 0f                	jmp    802249 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80223a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80223d:	89 f0                	mov    %esi,%eax
  80223f:	3c 19                	cmp    $0x19,%al
  802241:	77 16                	ja     802259 <strtol+0xb6>
			dig = *s - 'A' + 10;
  802243:	0f be c9             	movsbl %cl,%ecx
  802246:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  802249:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80224c:	7d 0f                	jge    80225d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80224e:	83 c2 01             	add    $0x1,%edx
  802251:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  802255:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  802257:	eb bc                	jmp    802215 <strtol+0x72>
  802259:	89 d8                	mov    %ebx,%eax
  80225b:	eb 02                	jmp    80225f <strtol+0xbc>
  80225d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80225f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802263:	74 05                	je     80226a <strtol+0xc7>
		*endptr = (char *) s;
  802265:	8b 75 0c             	mov    0xc(%ebp),%esi
  802268:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80226a:	f7 d8                	neg    %eax
  80226c:	85 ff                	test   %edi,%edi
  80226e:	0f 44 c3             	cmove  %ebx,%eax
}
  802271:	5b                   	pop    %ebx
  802272:	5e                   	pop    %esi
  802273:	5f                   	pop    %edi
  802274:	5d                   	pop    %ebp
  802275:	c3                   	ret    
  802276:	66 90                	xchg   %ax,%ax
  802278:	66 90                	xchg   %ax,%ax
  80227a:	66 90                	xchg   %ax,%ax
  80227c:	66 90                	xchg   %ax,%ax
  80227e:	66 90                	xchg   %ax,%ax

00802280 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
  802283:	56                   	push   %esi
  802284:	53                   	push   %ebx
  802285:	83 ec 10             	sub    $0x10,%esp
  802288:	8b 75 08             	mov    0x8(%ebp),%esi
  80228b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802291:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802293:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802298:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80229b:	89 04 24             	mov    %eax,(%esp)
  80229e:	e8 16 e1 ff ff       	call   8003b9 <sys_ipc_recv>
  8022a3:	85 c0                	test   %eax,%eax
  8022a5:	74 16                	je     8022bd <ipc_recv+0x3d>
		if (from_env_store != NULL)
  8022a7:	85 f6                	test   %esi,%esi
  8022a9:	74 06                	je     8022b1 <ipc_recv+0x31>
			*from_env_store = 0;
  8022ab:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  8022b1:	85 db                	test   %ebx,%ebx
  8022b3:	74 2c                	je     8022e1 <ipc_recv+0x61>
			*perm_store = 0;
  8022b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022bb:	eb 24                	jmp    8022e1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  8022bd:	85 f6                	test   %esi,%esi
  8022bf:	74 0a                	je     8022cb <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  8022c1:	a1 08 40 80 00       	mov    0x804008,%eax
  8022c6:	8b 40 74             	mov    0x74(%eax),%eax
  8022c9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  8022cb:	85 db                	test   %ebx,%ebx
  8022cd:	74 0a                	je     8022d9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  8022cf:	a1 08 40 80 00       	mov    0x804008,%eax
  8022d4:	8b 40 78             	mov    0x78(%eax),%eax
  8022d7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8022d9:	a1 08 40 80 00       	mov    0x804008,%eax
  8022de:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022e1:	83 c4 10             	add    $0x10,%esp
  8022e4:	5b                   	pop    %ebx
  8022e5:	5e                   	pop    %esi
  8022e6:	5d                   	pop    %ebp
  8022e7:	c3                   	ret    

008022e8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	57                   	push   %edi
  8022ec:	56                   	push   %esi
  8022ed:	53                   	push   %ebx
  8022ee:	83 ec 1c             	sub    $0x1c,%esp
  8022f1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022f7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  8022fa:	85 db                	test   %ebx,%ebx
  8022fc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802301:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  802304:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802308:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80230c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802310:	8b 45 08             	mov    0x8(%ebp),%eax
  802313:	89 04 24             	mov    %eax,(%esp)
  802316:	e8 7b e0 ff ff       	call   800396 <sys_ipc_try_send>
	if (r == 0) return;
  80231b:	85 c0                	test   %eax,%eax
  80231d:	75 22                	jne    802341 <ipc_send+0x59>
  80231f:	eb 4c                	jmp    80236d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802321:	84 d2                	test   %dl,%dl
  802323:	75 48                	jne    80236d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802325:	e8 5a de ff ff       	call   800184 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80232a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80232e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802332:	89 74 24 04          	mov    %esi,0x4(%esp)
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	89 04 24             	mov    %eax,(%esp)
  80233c:	e8 55 e0 ff ff       	call   800396 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802341:	85 c0                	test   %eax,%eax
  802343:	0f 94 c2             	sete   %dl
  802346:	74 d9                	je     802321 <ipc_send+0x39>
  802348:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80234b:	74 d4                	je     802321 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80234d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802351:	c7 44 24 08 08 2b 80 	movl   $0x802b08,0x8(%esp)
  802358:	00 
  802359:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802360:	00 
  802361:	c7 04 24 16 2b 80 00 	movl   $0x802b16,(%esp)
  802368:	e8 99 f4 ff ff       	call   801806 <_panic>
}
  80236d:	83 c4 1c             	add    $0x1c,%esp
  802370:	5b                   	pop    %ebx
  802371:	5e                   	pop    %esi
  802372:	5f                   	pop    %edi
  802373:	5d                   	pop    %ebp
  802374:	c3                   	ret    

00802375 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
  802378:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80237b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802380:	89 c2                	mov    %eax,%edx
  802382:	c1 e2 07             	shl    $0x7,%edx
  802385:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80238b:	8b 52 50             	mov    0x50(%edx),%edx
  80238e:	39 ca                	cmp    %ecx,%edx
  802390:	75 0d                	jne    80239f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802392:	c1 e0 07             	shl    $0x7,%eax
  802395:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80239a:	8b 40 40             	mov    0x40(%eax),%eax
  80239d:	eb 0e                	jmp    8023ad <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80239f:	83 c0 01             	add    $0x1,%eax
  8023a2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023a7:	75 d7                	jne    802380 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8023a9:	66 b8 00 00          	mov    $0x0,%ax
}
  8023ad:	5d                   	pop    %ebp
  8023ae:	c3                   	ret    

008023af <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023af:	55                   	push   %ebp
  8023b0:	89 e5                	mov    %esp,%ebp
  8023b2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023b5:	89 d0                	mov    %edx,%eax
  8023b7:	c1 e8 16             	shr    $0x16,%eax
  8023ba:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023c1:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023c6:	f6 c1 01             	test   $0x1,%cl
  8023c9:	74 1d                	je     8023e8 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8023cb:	c1 ea 0c             	shr    $0xc,%edx
  8023ce:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023d5:	f6 c2 01             	test   $0x1,%dl
  8023d8:	74 0e                	je     8023e8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023da:	c1 ea 0c             	shr    $0xc,%edx
  8023dd:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023e4:	ef 
  8023e5:	0f b7 c0             	movzwl %ax,%eax
}
  8023e8:	5d                   	pop    %ebp
  8023e9:	c3                   	ret    
  8023ea:	66 90                	xchg   %ax,%ax
  8023ec:	66 90                	xchg   %ax,%ax
  8023ee:	66 90                	xchg   %ax,%ax

008023f0 <__udivdi3>:
  8023f0:	55                   	push   %ebp
  8023f1:	57                   	push   %edi
  8023f2:	56                   	push   %esi
  8023f3:	83 ec 0c             	sub    $0xc,%esp
  8023f6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8023fa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8023fe:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802402:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802406:	85 c0                	test   %eax,%eax
  802408:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80240c:	89 ea                	mov    %ebp,%edx
  80240e:	89 0c 24             	mov    %ecx,(%esp)
  802411:	75 2d                	jne    802440 <__udivdi3+0x50>
  802413:	39 e9                	cmp    %ebp,%ecx
  802415:	77 61                	ja     802478 <__udivdi3+0x88>
  802417:	85 c9                	test   %ecx,%ecx
  802419:	89 ce                	mov    %ecx,%esi
  80241b:	75 0b                	jne    802428 <__udivdi3+0x38>
  80241d:	b8 01 00 00 00       	mov    $0x1,%eax
  802422:	31 d2                	xor    %edx,%edx
  802424:	f7 f1                	div    %ecx
  802426:	89 c6                	mov    %eax,%esi
  802428:	31 d2                	xor    %edx,%edx
  80242a:	89 e8                	mov    %ebp,%eax
  80242c:	f7 f6                	div    %esi
  80242e:	89 c5                	mov    %eax,%ebp
  802430:	89 f8                	mov    %edi,%eax
  802432:	f7 f6                	div    %esi
  802434:	89 ea                	mov    %ebp,%edx
  802436:	83 c4 0c             	add    $0xc,%esp
  802439:	5e                   	pop    %esi
  80243a:	5f                   	pop    %edi
  80243b:	5d                   	pop    %ebp
  80243c:	c3                   	ret    
  80243d:	8d 76 00             	lea    0x0(%esi),%esi
  802440:	39 e8                	cmp    %ebp,%eax
  802442:	77 24                	ja     802468 <__udivdi3+0x78>
  802444:	0f bd e8             	bsr    %eax,%ebp
  802447:	83 f5 1f             	xor    $0x1f,%ebp
  80244a:	75 3c                	jne    802488 <__udivdi3+0x98>
  80244c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802450:	39 34 24             	cmp    %esi,(%esp)
  802453:	0f 86 9f 00 00 00    	jbe    8024f8 <__udivdi3+0x108>
  802459:	39 d0                	cmp    %edx,%eax
  80245b:	0f 82 97 00 00 00    	jb     8024f8 <__udivdi3+0x108>
  802461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802468:	31 d2                	xor    %edx,%edx
  80246a:	31 c0                	xor    %eax,%eax
  80246c:	83 c4 0c             	add    $0xc,%esp
  80246f:	5e                   	pop    %esi
  802470:	5f                   	pop    %edi
  802471:	5d                   	pop    %ebp
  802472:	c3                   	ret    
  802473:	90                   	nop
  802474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802478:	89 f8                	mov    %edi,%eax
  80247a:	f7 f1                	div    %ecx
  80247c:	31 d2                	xor    %edx,%edx
  80247e:	83 c4 0c             	add    $0xc,%esp
  802481:	5e                   	pop    %esi
  802482:	5f                   	pop    %edi
  802483:	5d                   	pop    %ebp
  802484:	c3                   	ret    
  802485:	8d 76 00             	lea    0x0(%esi),%esi
  802488:	89 e9                	mov    %ebp,%ecx
  80248a:	8b 3c 24             	mov    (%esp),%edi
  80248d:	d3 e0                	shl    %cl,%eax
  80248f:	89 c6                	mov    %eax,%esi
  802491:	b8 20 00 00 00       	mov    $0x20,%eax
  802496:	29 e8                	sub    %ebp,%eax
  802498:	89 c1                	mov    %eax,%ecx
  80249a:	d3 ef                	shr    %cl,%edi
  80249c:	89 e9                	mov    %ebp,%ecx
  80249e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024a2:	8b 3c 24             	mov    (%esp),%edi
  8024a5:	09 74 24 08          	or     %esi,0x8(%esp)
  8024a9:	89 d6                	mov    %edx,%esi
  8024ab:	d3 e7                	shl    %cl,%edi
  8024ad:	89 c1                	mov    %eax,%ecx
  8024af:	89 3c 24             	mov    %edi,(%esp)
  8024b2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024b6:	d3 ee                	shr    %cl,%esi
  8024b8:	89 e9                	mov    %ebp,%ecx
  8024ba:	d3 e2                	shl    %cl,%edx
  8024bc:	89 c1                	mov    %eax,%ecx
  8024be:	d3 ef                	shr    %cl,%edi
  8024c0:	09 d7                	or     %edx,%edi
  8024c2:	89 f2                	mov    %esi,%edx
  8024c4:	89 f8                	mov    %edi,%eax
  8024c6:	f7 74 24 08          	divl   0x8(%esp)
  8024ca:	89 d6                	mov    %edx,%esi
  8024cc:	89 c7                	mov    %eax,%edi
  8024ce:	f7 24 24             	mull   (%esp)
  8024d1:	39 d6                	cmp    %edx,%esi
  8024d3:	89 14 24             	mov    %edx,(%esp)
  8024d6:	72 30                	jb     802508 <__udivdi3+0x118>
  8024d8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024dc:	89 e9                	mov    %ebp,%ecx
  8024de:	d3 e2                	shl    %cl,%edx
  8024e0:	39 c2                	cmp    %eax,%edx
  8024e2:	73 05                	jae    8024e9 <__udivdi3+0xf9>
  8024e4:	3b 34 24             	cmp    (%esp),%esi
  8024e7:	74 1f                	je     802508 <__udivdi3+0x118>
  8024e9:	89 f8                	mov    %edi,%eax
  8024eb:	31 d2                	xor    %edx,%edx
  8024ed:	e9 7a ff ff ff       	jmp    80246c <__udivdi3+0x7c>
  8024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024f8:	31 d2                	xor    %edx,%edx
  8024fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ff:	e9 68 ff ff ff       	jmp    80246c <__udivdi3+0x7c>
  802504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802508:	8d 47 ff             	lea    -0x1(%edi),%eax
  80250b:	31 d2                	xor    %edx,%edx
  80250d:	83 c4 0c             	add    $0xc,%esp
  802510:	5e                   	pop    %esi
  802511:	5f                   	pop    %edi
  802512:	5d                   	pop    %ebp
  802513:	c3                   	ret    
  802514:	66 90                	xchg   %ax,%ax
  802516:	66 90                	xchg   %ax,%ax
  802518:	66 90                	xchg   %ax,%ax
  80251a:	66 90                	xchg   %ax,%ax
  80251c:	66 90                	xchg   %ax,%ax
  80251e:	66 90                	xchg   %ax,%ax

00802520 <__umoddi3>:
  802520:	55                   	push   %ebp
  802521:	57                   	push   %edi
  802522:	56                   	push   %esi
  802523:	83 ec 14             	sub    $0x14,%esp
  802526:	8b 44 24 28          	mov    0x28(%esp),%eax
  80252a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80252e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802532:	89 c7                	mov    %eax,%edi
  802534:	89 44 24 04          	mov    %eax,0x4(%esp)
  802538:	8b 44 24 30          	mov    0x30(%esp),%eax
  80253c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802540:	89 34 24             	mov    %esi,(%esp)
  802543:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802547:	85 c0                	test   %eax,%eax
  802549:	89 c2                	mov    %eax,%edx
  80254b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80254f:	75 17                	jne    802568 <__umoddi3+0x48>
  802551:	39 fe                	cmp    %edi,%esi
  802553:	76 4b                	jbe    8025a0 <__umoddi3+0x80>
  802555:	89 c8                	mov    %ecx,%eax
  802557:	89 fa                	mov    %edi,%edx
  802559:	f7 f6                	div    %esi
  80255b:	89 d0                	mov    %edx,%eax
  80255d:	31 d2                	xor    %edx,%edx
  80255f:	83 c4 14             	add    $0x14,%esp
  802562:	5e                   	pop    %esi
  802563:	5f                   	pop    %edi
  802564:	5d                   	pop    %ebp
  802565:	c3                   	ret    
  802566:	66 90                	xchg   %ax,%ax
  802568:	39 f8                	cmp    %edi,%eax
  80256a:	77 54                	ja     8025c0 <__umoddi3+0xa0>
  80256c:	0f bd e8             	bsr    %eax,%ebp
  80256f:	83 f5 1f             	xor    $0x1f,%ebp
  802572:	75 5c                	jne    8025d0 <__umoddi3+0xb0>
  802574:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802578:	39 3c 24             	cmp    %edi,(%esp)
  80257b:	0f 87 e7 00 00 00    	ja     802668 <__umoddi3+0x148>
  802581:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802585:	29 f1                	sub    %esi,%ecx
  802587:	19 c7                	sbb    %eax,%edi
  802589:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80258d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802591:	8b 44 24 08          	mov    0x8(%esp),%eax
  802595:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802599:	83 c4 14             	add    $0x14,%esp
  80259c:	5e                   	pop    %esi
  80259d:	5f                   	pop    %edi
  80259e:	5d                   	pop    %ebp
  80259f:	c3                   	ret    
  8025a0:	85 f6                	test   %esi,%esi
  8025a2:	89 f5                	mov    %esi,%ebp
  8025a4:	75 0b                	jne    8025b1 <__umoddi3+0x91>
  8025a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ab:	31 d2                	xor    %edx,%edx
  8025ad:	f7 f6                	div    %esi
  8025af:	89 c5                	mov    %eax,%ebp
  8025b1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025b5:	31 d2                	xor    %edx,%edx
  8025b7:	f7 f5                	div    %ebp
  8025b9:	89 c8                	mov    %ecx,%eax
  8025bb:	f7 f5                	div    %ebp
  8025bd:	eb 9c                	jmp    80255b <__umoddi3+0x3b>
  8025bf:	90                   	nop
  8025c0:	89 c8                	mov    %ecx,%eax
  8025c2:	89 fa                	mov    %edi,%edx
  8025c4:	83 c4 14             	add    $0x14,%esp
  8025c7:	5e                   	pop    %esi
  8025c8:	5f                   	pop    %edi
  8025c9:	5d                   	pop    %ebp
  8025ca:	c3                   	ret    
  8025cb:	90                   	nop
  8025cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025d0:	8b 04 24             	mov    (%esp),%eax
  8025d3:	be 20 00 00 00       	mov    $0x20,%esi
  8025d8:	89 e9                	mov    %ebp,%ecx
  8025da:	29 ee                	sub    %ebp,%esi
  8025dc:	d3 e2                	shl    %cl,%edx
  8025de:	89 f1                	mov    %esi,%ecx
  8025e0:	d3 e8                	shr    %cl,%eax
  8025e2:	89 e9                	mov    %ebp,%ecx
  8025e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e8:	8b 04 24             	mov    (%esp),%eax
  8025eb:	09 54 24 04          	or     %edx,0x4(%esp)
  8025ef:	89 fa                	mov    %edi,%edx
  8025f1:	d3 e0                	shl    %cl,%eax
  8025f3:	89 f1                	mov    %esi,%ecx
  8025f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025f9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8025fd:	d3 ea                	shr    %cl,%edx
  8025ff:	89 e9                	mov    %ebp,%ecx
  802601:	d3 e7                	shl    %cl,%edi
  802603:	89 f1                	mov    %esi,%ecx
  802605:	d3 e8                	shr    %cl,%eax
  802607:	89 e9                	mov    %ebp,%ecx
  802609:	09 f8                	or     %edi,%eax
  80260b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80260f:	f7 74 24 04          	divl   0x4(%esp)
  802613:	d3 e7                	shl    %cl,%edi
  802615:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802619:	89 d7                	mov    %edx,%edi
  80261b:	f7 64 24 08          	mull   0x8(%esp)
  80261f:	39 d7                	cmp    %edx,%edi
  802621:	89 c1                	mov    %eax,%ecx
  802623:	89 14 24             	mov    %edx,(%esp)
  802626:	72 2c                	jb     802654 <__umoddi3+0x134>
  802628:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80262c:	72 22                	jb     802650 <__umoddi3+0x130>
  80262e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802632:	29 c8                	sub    %ecx,%eax
  802634:	19 d7                	sbb    %edx,%edi
  802636:	89 e9                	mov    %ebp,%ecx
  802638:	89 fa                	mov    %edi,%edx
  80263a:	d3 e8                	shr    %cl,%eax
  80263c:	89 f1                	mov    %esi,%ecx
  80263e:	d3 e2                	shl    %cl,%edx
  802640:	89 e9                	mov    %ebp,%ecx
  802642:	d3 ef                	shr    %cl,%edi
  802644:	09 d0                	or     %edx,%eax
  802646:	89 fa                	mov    %edi,%edx
  802648:	83 c4 14             	add    $0x14,%esp
  80264b:	5e                   	pop    %esi
  80264c:	5f                   	pop    %edi
  80264d:	5d                   	pop    %ebp
  80264e:	c3                   	ret    
  80264f:	90                   	nop
  802650:	39 d7                	cmp    %edx,%edi
  802652:	75 da                	jne    80262e <__umoddi3+0x10e>
  802654:	8b 14 24             	mov    (%esp),%edx
  802657:	89 c1                	mov    %eax,%ecx
  802659:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80265d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802661:	eb cb                	jmp    80262e <__umoddi3+0x10e>
  802663:	90                   	nop
  802664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802668:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80266c:	0f 82 0f ff ff ff    	jb     802581 <__umoddi3+0x61>
  802672:	e9 1a ff ff ff       	jmp    802591 <__umoddi3+0x71>
