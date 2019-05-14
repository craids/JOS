
obj/user/buggyhello2.debug:     file format elf32-i386


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
  80002c:	e8 1f 00 00 00       	call   800050 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	sys_cputs(hello, 1024*1024);
  800039:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  800040:	00 
  800041:	a1 00 30 80 00       	mov    0x803000,%eax
  800046:	89 04 24             	mov    %eax,(%esp)
  800049:	e8 63 00 00 00       	call   8000b1 <sys_cputs>
}
  80004e:	c9                   	leave  
  80004f:	c3                   	ret    

00800050 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800050:	55                   	push   %ebp
  800051:	89 e5                	mov    %esp,%ebp
  800053:	56                   	push   %esi
  800054:	53                   	push   %ebx
  800055:	83 ec 10             	sub    $0x10,%esp
  800058:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80005e:	e8 dd 00 00 00       	call   800140 <sys_getenvid>
  800063:	25 ff 03 00 00       	and    $0x3ff,%eax
  800068:	c1 e0 07             	shl    $0x7,%eax
  80006b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800070:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800075:	85 db                	test   %ebx,%ebx
  800077:	7e 07                	jle    800080 <libmain+0x30>
		binaryname = argv[0];
  800079:	8b 06                	mov    (%esi),%eax
  80007b:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800080:	89 74 24 04          	mov    %esi,0x4(%esp)
  800084:	89 1c 24             	mov    %ebx,(%esp)
  800087:	e8 a7 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008c:	e8 07 00 00 00       	call   800098 <exit>
}
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	5b                   	pop    %ebx
  800095:	5e                   	pop    %esi
  800096:	5d                   	pop    %ebp
  800097:	c3                   	ret    

00800098 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800098:	55                   	push   %ebp
  800099:	89 e5                	mov    %esp,%ebp
  80009b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80009e:	e8 f7 05 00 00       	call   80069a <close_all>
	sys_env_destroy(0);
  8000a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000aa:	e8 3f 00 00 00       	call   8000ee <sys_env_destroy>
}
  8000af:	c9                   	leave  
  8000b0:	c3                   	ret    

008000b1 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000b1:	55                   	push   %ebp
  8000b2:	89 e5                	mov    %esp,%ebp
  8000b4:	57                   	push   %edi
  8000b5:	56                   	push   %esi
  8000b6:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c2:	89 c3                	mov    %eax,%ebx
  8000c4:	89 c7                	mov    %eax,%edi
  8000c6:	89 c6                	mov    %eax,%esi
  8000c8:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000ca:	5b                   	pop    %ebx
  8000cb:	5e                   	pop    %esi
  8000cc:	5f                   	pop    %edi
  8000cd:	5d                   	pop    %ebp
  8000ce:	c3                   	ret    

008000cf <sys_cgetc>:

int
sys_cgetc(void)
{
  8000cf:	55                   	push   %ebp
  8000d0:	89 e5                	mov    %esp,%ebp
  8000d2:	57                   	push   %edi
  8000d3:	56                   	push   %esi
  8000d4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8000da:	b8 01 00 00 00       	mov    $0x1,%eax
  8000df:	89 d1                	mov    %edx,%ecx
  8000e1:	89 d3                	mov    %edx,%ebx
  8000e3:	89 d7                	mov    %edx,%edi
  8000e5:	89 d6                	mov    %edx,%esi
  8000e7:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e9:	5b                   	pop    %ebx
  8000ea:	5e                   	pop    %esi
  8000eb:	5f                   	pop    %edi
  8000ec:	5d                   	pop    %ebp
  8000ed:	c3                   	ret    

008000ee <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000ee:	55                   	push   %ebp
  8000ef:	89 e5                	mov    %esp,%ebp
  8000f1:	57                   	push   %edi
  8000f2:	56                   	push   %esi
  8000f3:	53                   	push   %ebx
  8000f4:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000f7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000fc:	b8 03 00 00 00       	mov    $0x3,%eax
  800101:	8b 55 08             	mov    0x8(%ebp),%edx
  800104:	89 cb                	mov    %ecx,%ebx
  800106:	89 cf                	mov    %ecx,%edi
  800108:	89 ce                	mov    %ecx,%esi
  80010a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80010c:	85 c0                	test   %eax,%eax
  80010e:	7e 28                	jle    800138 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800110:	89 44 24 10          	mov    %eax,0x10(%esp)
  800114:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  80011b:	00 
  80011c:	c7 44 24 08 78 26 80 	movl   $0x802678,0x8(%esp)
  800123:	00 
  800124:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80012b:	00 
  80012c:	c7 04 24 95 26 80 00 	movl   $0x802695,(%esp)
  800133:	e8 9e 16 00 00       	call   8017d6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800138:	83 c4 2c             	add    $0x2c,%esp
  80013b:	5b                   	pop    %ebx
  80013c:	5e                   	pop    %esi
  80013d:	5f                   	pop    %edi
  80013e:	5d                   	pop    %ebp
  80013f:	c3                   	ret    

00800140 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800140:	55                   	push   %ebp
  800141:	89 e5                	mov    %esp,%ebp
  800143:	57                   	push   %edi
  800144:	56                   	push   %esi
  800145:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800146:	ba 00 00 00 00       	mov    $0x0,%edx
  80014b:	b8 02 00 00 00       	mov    $0x2,%eax
  800150:	89 d1                	mov    %edx,%ecx
  800152:	89 d3                	mov    %edx,%ebx
  800154:	89 d7                	mov    %edx,%edi
  800156:	89 d6                	mov    %edx,%esi
  800158:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80015a:	5b                   	pop    %ebx
  80015b:	5e                   	pop    %esi
  80015c:	5f                   	pop    %edi
  80015d:	5d                   	pop    %ebp
  80015e:	c3                   	ret    

0080015f <sys_yield>:

void
sys_yield(void)
{
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	57                   	push   %edi
  800163:	56                   	push   %esi
  800164:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800165:	ba 00 00 00 00       	mov    $0x0,%edx
  80016a:	b8 0b 00 00 00       	mov    $0xb,%eax
  80016f:	89 d1                	mov    %edx,%ecx
  800171:	89 d3                	mov    %edx,%ebx
  800173:	89 d7                	mov    %edx,%edi
  800175:	89 d6                	mov    %edx,%esi
  800177:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800179:	5b                   	pop    %ebx
  80017a:	5e                   	pop    %esi
  80017b:	5f                   	pop    %edi
  80017c:	5d                   	pop    %ebp
  80017d:	c3                   	ret    

0080017e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	57                   	push   %edi
  800182:	56                   	push   %esi
  800183:	53                   	push   %ebx
  800184:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800187:	be 00 00 00 00       	mov    $0x0,%esi
  80018c:	b8 04 00 00 00       	mov    $0x4,%eax
  800191:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800194:	8b 55 08             	mov    0x8(%ebp),%edx
  800197:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80019a:	89 f7                	mov    %esi,%edi
  80019c:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80019e:	85 c0                	test   %eax,%eax
  8001a0:	7e 28                	jle    8001ca <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001a2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001a6:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8001ad:	00 
  8001ae:	c7 44 24 08 78 26 80 	movl   $0x802678,0x8(%esp)
  8001b5:	00 
  8001b6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001bd:	00 
  8001be:	c7 04 24 95 26 80 00 	movl   $0x802695,(%esp)
  8001c5:	e8 0c 16 00 00       	call   8017d6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001ca:	83 c4 2c             	add    $0x2c,%esp
  8001cd:	5b                   	pop    %ebx
  8001ce:	5e                   	pop    %esi
  8001cf:	5f                   	pop    %edi
  8001d0:	5d                   	pop    %ebp
  8001d1:	c3                   	ret    

008001d2 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	57                   	push   %edi
  8001d6:	56                   	push   %esi
  8001d7:	53                   	push   %ebx
  8001d8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001db:	b8 05 00 00 00       	mov    $0x5,%eax
  8001e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001e9:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001ec:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ef:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	7e 28                	jle    80021d <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001f5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001f9:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800200:	00 
  800201:	c7 44 24 08 78 26 80 	movl   $0x802678,0x8(%esp)
  800208:	00 
  800209:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800210:	00 
  800211:	c7 04 24 95 26 80 00 	movl   $0x802695,(%esp)
  800218:	e8 b9 15 00 00       	call   8017d6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80021d:	83 c4 2c             	add    $0x2c,%esp
  800220:	5b                   	pop    %ebx
  800221:	5e                   	pop    %esi
  800222:	5f                   	pop    %edi
  800223:	5d                   	pop    %ebp
  800224:	c3                   	ret    

00800225 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	57                   	push   %edi
  800229:	56                   	push   %esi
  80022a:	53                   	push   %ebx
  80022b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80022e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800233:	b8 06 00 00 00       	mov    $0x6,%eax
  800238:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80023b:	8b 55 08             	mov    0x8(%ebp),%edx
  80023e:	89 df                	mov    %ebx,%edi
  800240:	89 de                	mov    %ebx,%esi
  800242:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800244:	85 c0                	test   %eax,%eax
  800246:	7e 28                	jle    800270 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800248:	89 44 24 10          	mov    %eax,0x10(%esp)
  80024c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800253:	00 
  800254:	c7 44 24 08 78 26 80 	movl   $0x802678,0x8(%esp)
  80025b:	00 
  80025c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800263:	00 
  800264:	c7 04 24 95 26 80 00 	movl   $0x802695,(%esp)
  80026b:	e8 66 15 00 00       	call   8017d6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800270:	83 c4 2c             	add    $0x2c,%esp
  800273:	5b                   	pop    %ebx
  800274:	5e                   	pop    %esi
  800275:	5f                   	pop    %edi
  800276:	5d                   	pop    %ebp
  800277:	c3                   	ret    

00800278 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	57                   	push   %edi
  80027c:	56                   	push   %esi
  80027d:	53                   	push   %ebx
  80027e:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800281:	bb 00 00 00 00       	mov    $0x0,%ebx
  800286:	b8 08 00 00 00       	mov    $0x8,%eax
  80028b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80028e:	8b 55 08             	mov    0x8(%ebp),%edx
  800291:	89 df                	mov    %ebx,%edi
  800293:	89 de                	mov    %ebx,%esi
  800295:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800297:	85 c0                	test   %eax,%eax
  800299:	7e 28                	jle    8002c3 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80029b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80029f:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8002a6:	00 
  8002a7:	c7 44 24 08 78 26 80 	movl   $0x802678,0x8(%esp)
  8002ae:	00 
  8002af:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002b6:	00 
  8002b7:	c7 04 24 95 26 80 00 	movl   $0x802695,(%esp)
  8002be:	e8 13 15 00 00       	call   8017d6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002c3:	83 c4 2c             	add    $0x2c,%esp
  8002c6:	5b                   	pop    %ebx
  8002c7:	5e                   	pop    %esi
  8002c8:	5f                   	pop    %edi
  8002c9:	5d                   	pop    %ebp
  8002ca:	c3                   	ret    

008002cb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002cb:	55                   	push   %ebp
  8002cc:	89 e5                	mov    %esp,%ebp
  8002ce:	57                   	push   %edi
  8002cf:	56                   	push   %esi
  8002d0:	53                   	push   %ebx
  8002d1:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002d9:	b8 09 00 00 00       	mov    $0x9,%eax
  8002de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e4:	89 df                	mov    %ebx,%edi
  8002e6:	89 de                	mov    %ebx,%esi
  8002e8:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8002ea:	85 c0                	test   %eax,%eax
  8002ec:	7e 28                	jle    800316 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ee:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002f2:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8002f9:	00 
  8002fa:	c7 44 24 08 78 26 80 	movl   $0x802678,0x8(%esp)
  800301:	00 
  800302:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800309:	00 
  80030a:	c7 04 24 95 26 80 00 	movl   $0x802695,(%esp)
  800311:	e8 c0 14 00 00       	call   8017d6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800316:	83 c4 2c             	add    $0x2c,%esp
  800319:	5b                   	pop    %ebx
  80031a:	5e                   	pop    %esi
  80031b:	5f                   	pop    %edi
  80031c:	5d                   	pop    %ebp
  80031d:	c3                   	ret    

0080031e <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	57                   	push   %edi
  800322:	56                   	push   %esi
  800323:	53                   	push   %ebx
  800324:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800327:	bb 00 00 00 00       	mov    $0x0,%ebx
  80032c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800331:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800334:	8b 55 08             	mov    0x8(%ebp),%edx
  800337:	89 df                	mov    %ebx,%edi
  800339:	89 de                	mov    %ebx,%esi
  80033b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80033d:	85 c0                	test   %eax,%eax
  80033f:	7e 28                	jle    800369 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800341:	89 44 24 10          	mov    %eax,0x10(%esp)
  800345:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  80034c:	00 
  80034d:	c7 44 24 08 78 26 80 	movl   $0x802678,0x8(%esp)
  800354:	00 
  800355:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80035c:	00 
  80035d:	c7 04 24 95 26 80 00 	movl   $0x802695,(%esp)
  800364:	e8 6d 14 00 00       	call   8017d6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800369:	83 c4 2c             	add    $0x2c,%esp
  80036c:	5b                   	pop    %ebx
  80036d:	5e                   	pop    %esi
  80036e:	5f                   	pop    %edi
  80036f:	5d                   	pop    %ebp
  800370:	c3                   	ret    

00800371 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800371:	55                   	push   %ebp
  800372:	89 e5                	mov    %esp,%ebp
  800374:	57                   	push   %edi
  800375:	56                   	push   %esi
  800376:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800377:	be 00 00 00 00       	mov    $0x0,%esi
  80037c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800381:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800384:	8b 55 08             	mov    0x8(%ebp),%edx
  800387:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80038a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80038d:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80038f:	5b                   	pop    %ebx
  800390:	5e                   	pop    %esi
  800391:	5f                   	pop    %edi
  800392:	5d                   	pop    %ebp
  800393:	c3                   	ret    

00800394 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
  800397:	57                   	push   %edi
  800398:	56                   	push   %esi
  800399:	53                   	push   %ebx
  80039a:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80039d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003a2:	b8 0d 00 00 00       	mov    $0xd,%eax
  8003a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8003aa:	89 cb                	mov    %ecx,%ebx
  8003ac:	89 cf                	mov    %ecx,%edi
  8003ae:	89 ce                	mov    %ecx,%esi
  8003b0:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8003b2:	85 c0                	test   %eax,%eax
  8003b4:	7e 28                	jle    8003de <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003b6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003ba:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8003c1:	00 
  8003c2:	c7 44 24 08 78 26 80 	movl   $0x802678,0x8(%esp)
  8003c9:	00 
  8003ca:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003d1:	00 
  8003d2:	c7 04 24 95 26 80 00 	movl   $0x802695,(%esp)
  8003d9:	e8 f8 13 00 00       	call   8017d6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8003de:	83 c4 2c             	add    $0x2c,%esp
  8003e1:	5b                   	pop    %ebx
  8003e2:	5e                   	pop    %esi
  8003e3:	5f                   	pop    %edi
  8003e4:	5d                   	pop    %ebp
  8003e5:	c3                   	ret    

008003e6 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	57                   	push   %edi
  8003ea:	56                   	push   %esi
  8003eb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f1:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003f6:	89 d1                	mov    %edx,%ecx
  8003f8:	89 d3                	mov    %edx,%ebx
  8003fa:	89 d7                	mov    %edx,%edi
  8003fc:	89 d6                	mov    %edx,%esi
  8003fe:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800400:	5b                   	pop    %ebx
  800401:	5e                   	pop    %esi
  800402:	5f                   	pop    %edi
  800403:	5d                   	pop    %ebp
  800404:	c3                   	ret    

00800405 <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800405:	55                   	push   %ebp
  800406:	89 e5                	mov    %esp,%ebp
  800408:	57                   	push   %edi
  800409:	56                   	push   %esi
  80040a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80040b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800410:	b8 0f 00 00 00       	mov    $0xf,%eax
  800415:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800418:	8b 55 08             	mov    0x8(%ebp),%edx
  80041b:	89 df                	mov    %ebx,%edi
  80041d:	89 de                	mov    %ebx,%esi
  80041f:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800421:	5b                   	pop    %ebx
  800422:	5e                   	pop    %esi
  800423:	5f                   	pop    %edi
  800424:	5d                   	pop    %ebp
  800425:	c3                   	ret    

00800426 <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
  800429:	57                   	push   %edi
  80042a:	56                   	push   %esi
  80042b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80042c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800431:	b8 10 00 00 00       	mov    $0x10,%eax
  800436:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800439:	8b 55 08             	mov    0x8(%ebp),%edx
  80043c:	89 df                	mov    %ebx,%edi
  80043e:	89 de                	mov    %ebx,%esi
  800440:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800442:	5b                   	pop    %ebx
  800443:	5e                   	pop    %esi
  800444:	5f                   	pop    %edi
  800445:	5d                   	pop    %ebp
  800446:	c3                   	ret    

00800447 <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800447:	55                   	push   %ebp
  800448:	89 e5                	mov    %esp,%ebp
  80044a:	57                   	push   %edi
  80044b:	56                   	push   %esi
  80044c:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80044d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800452:	b8 11 00 00 00       	mov    $0x11,%eax
  800457:	8b 55 08             	mov    0x8(%ebp),%edx
  80045a:	89 cb                	mov    %ecx,%ebx
  80045c:	89 cf                	mov    %ecx,%edi
  80045e:	89 ce                	mov    %ecx,%esi
  800460:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800462:	5b                   	pop    %ebx
  800463:	5e                   	pop    %esi
  800464:	5f                   	pop    %edi
  800465:	5d                   	pop    %ebp
  800466:	c3                   	ret    

00800467 <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800467:	55                   	push   %ebp
  800468:	89 e5                	mov    %esp,%ebp
  80046a:	57                   	push   %edi
  80046b:	56                   	push   %esi
  80046c:	53                   	push   %ebx
  80046d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800470:	be 00 00 00 00       	mov    $0x0,%esi
  800475:	b8 12 00 00 00       	mov    $0x12,%eax
  80047a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80047d:	8b 55 08             	mov    0x8(%ebp),%edx
  800480:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800483:	8b 7d 14             	mov    0x14(%ebp),%edi
  800486:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800488:	85 c0                	test   %eax,%eax
  80048a:	7e 28                	jle    8004b4 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  80048c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800490:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800497:	00 
  800498:	c7 44 24 08 78 26 80 	movl   $0x802678,0x8(%esp)
  80049f:	00 
  8004a0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004a7:	00 
  8004a8:	c7 04 24 95 26 80 00 	movl   $0x802695,(%esp)
  8004af:	e8 22 13 00 00       	call   8017d6 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  8004b4:	83 c4 2c             	add    $0x2c,%esp
  8004b7:	5b                   	pop    %ebx
  8004b8:	5e                   	pop    %esi
  8004b9:	5f                   	pop    %edi
  8004ba:	5d                   	pop    %ebp
  8004bb:	c3                   	ret    
  8004bc:	66 90                	xchg   %ax,%ax
  8004be:	66 90                	xchg   %ax,%ax

008004c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	05 00 00 00 30       	add    $0x30000000,%eax
  8004cb:	c1 e8 0c             	shr    $0xc,%eax
}
  8004ce:	5d                   	pop    %ebp
  8004cf:	c3                   	ret    

008004d0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8004db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004e0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8004e5:	5d                   	pop    %ebp
  8004e6:	c3                   	ret    

008004e7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8004e7:	55                   	push   %ebp
  8004e8:	89 e5                	mov    %esp,%ebp
  8004ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004ed:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8004f2:	89 c2                	mov    %eax,%edx
  8004f4:	c1 ea 16             	shr    $0x16,%edx
  8004f7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8004fe:	f6 c2 01             	test   $0x1,%dl
  800501:	74 11                	je     800514 <fd_alloc+0x2d>
  800503:	89 c2                	mov    %eax,%edx
  800505:	c1 ea 0c             	shr    $0xc,%edx
  800508:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80050f:	f6 c2 01             	test   $0x1,%dl
  800512:	75 09                	jne    80051d <fd_alloc+0x36>
			*fd_store = fd;
  800514:	89 01                	mov    %eax,(%ecx)
			return 0;
  800516:	b8 00 00 00 00       	mov    $0x0,%eax
  80051b:	eb 17                	jmp    800534 <fd_alloc+0x4d>
  80051d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800522:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800527:	75 c9                	jne    8004f2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800529:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80052f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800534:	5d                   	pop    %ebp
  800535:	c3                   	ret    

00800536 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80053c:	83 f8 1f             	cmp    $0x1f,%eax
  80053f:	77 36                	ja     800577 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800541:	c1 e0 0c             	shl    $0xc,%eax
  800544:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800549:	89 c2                	mov    %eax,%edx
  80054b:	c1 ea 16             	shr    $0x16,%edx
  80054e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800555:	f6 c2 01             	test   $0x1,%dl
  800558:	74 24                	je     80057e <fd_lookup+0x48>
  80055a:	89 c2                	mov    %eax,%edx
  80055c:	c1 ea 0c             	shr    $0xc,%edx
  80055f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800566:	f6 c2 01             	test   $0x1,%dl
  800569:	74 1a                	je     800585 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80056b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80056e:	89 02                	mov    %eax,(%edx)
	return 0;
  800570:	b8 00 00 00 00       	mov    $0x0,%eax
  800575:	eb 13                	jmp    80058a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800577:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80057c:	eb 0c                	jmp    80058a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80057e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800583:	eb 05                	jmp    80058a <fd_lookup+0x54>
  800585:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80058a:	5d                   	pop    %ebp
  80058b:	c3                   	ret    

0080058c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80058c:	55                   	push   %ebp
  80058d:	89 e5                	mov    %esp,%ebp
  80058f:	83 ec 18             	sub    $0x18,%esp
  800592:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800595:	ba 00 00 00 00       	mov    $0x0,%edx
  80059a:	eb 13                	jmp    8005af <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80059c:	39 08                	cmp    %ecx,(%eax)
  80059e:	75 0c                	jne    8005ac <dev_lookup+0x20>
			*dev = devtab[i];
  8005a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8005a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005aa:	eb 38                	jmp    8005e4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8005ac:	83 c2 01             	add    $0x1,%edx
  8005af:	8b 04 95 20 27 80 00 	mov    0x802720(,%edx,4),%eax
  8005b6:	85 c0                	test   %eax,%eax
  8005b8:	75 e2                	jne    80059c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8005ba:	a1 08 40 80 00       	mov    0x804008,%eax
  8005bf:	8b 40 48             	mov    0x48(%eax),%eax
  8005c2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ca:	c7 04 24 a4 26 80 00 	movl   $0x8026a4,(%esp)
  8005d1:	e8 f9 12 00 00       	call   8018cf <cprintf>
	*dev = 0;
  8005d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8005df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8005e4:	c9                   	leave  
  8005e5:	c3                   	ret    

008005e6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	56                   	push   %esi
  8005ea:	53                   	push   %ebx
  8005eb:	83 ec 20             	sub    $0x20,%esp
  8005ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8005f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8005f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005f7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8005fb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800601:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800604:	89 04 24             	mov    %eax,(%esp)
  800607:	e8 2a ff ff ff       	call   800536 <fd_lookup>
  80060c:	85 c0                	test   %eax,%eax
  80060e:	78 05                	js     800615 <fd_close+0x2f>
	    || fd != fd2)
  800610:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800613:	74 0c                	je     800621 <fd_close+0x3b>
		return (must_exist ? r : 0);
  800615:	84 db                	test   %bl,%bl
  800617:	ba 00 00 00 00       	mov    $0x0,%edx
  80061c:	0f 44 c2             	cmove  %edx,%eax
  80061f:	eb 3f                	jmp    800660 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800621:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800624:	89 44 24 04          	mov    %eax,0x4(%esp)
  800628:	8b 06                	mov    (%esi),%eax
  80062a:	89 04 24             	mov    %eax,(%esp)
  80062d:	e8 5a ff ff ff       	call   80058c <dev_lookup>
  800632:	89 c3                	mov    %eax,%ebx
  800634:	85 c0                	test   %eax,%eax
  800636:	78 16                	js     80064e <fd_close+0x68>
		if (dev->dev_close)
  800638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80063b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80063e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800643:	85 c0                	test   %eax,%eax
  800645:	74 07                	je     80064e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800647:	89 34 24             	mov    %esi,(%esp)
  80064a:	ff d0                	call   *%eax
  80064c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80064e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800652:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800659:	e8 c7 fb ff ff       	call   800225 <sys_page_unmap>
	return r;
  80065e:	89 d8                	mov    %ebx,%eax
}
  800660:	83 c4 20             	add    $0x20,%esp
  800663:	5b                   	pop    %ebx
  800664:	5e                   	pop    %esi
  800665:	5d                   	pop    %ebp
  800666:	c3                   	ret    

00800667 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
  80066a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80066d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800670:	89 44 24 04          	mov    %eax,0x4(%esp)
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	89 04 24             	mov    %eax,(%esp)
  80067a:	e8 b7 fe ff ff       	call   800536 <fd_lookup>
  80067f:	89 c2                	mov    %eax,%edx
  800681:	85 d2                	test   %edx,%edx
  800683:	78 13                	js     800698 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  800685:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80068c:	00 
  80068d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800690:	89 04 24             	mov    %eax,(%esp)
  800693:	e8 4e ff ff ff       	call   8005e6 <fd_close>
}
  800698:	c9                   	leave  
  800699:	c3                   	ret    

0080069a <close_all>:

void
close_all(void)
{
  80069a:	55                   	push   %ebp
  80069b:	89 e5                	mov    %esp,%ebp
  80069d:	53                   	push   %ebx
  80069e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8006a1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8006a6:	89 1c 24             	mov    %ebx,(%esp)
  8006a9:	e8 b9 ff ff ff       	call   800667 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8006ae:	83 c3 01             	add    $0x1,%ebx
  8006b1:	83 fb 20             	cmp    $0x20,%ebx
  8006b4:	75 f0                	jne    8006a6 <close_all+0xc>
		close(i);
}
  8006b6:	83 c4 14             	add    $0x14,%esp
  8006b9:	5b                   	pop    %ebx
  8006ba:	5d                   	pop    %ebp
  8006bb:	c3                   	ret    

008006bc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8006bc:	55                   	push   %ebp
  8006bd:	89 e5                	mov    %esp,%ebp
  8006bf:	57                   	push   %edi
  8006c0:	56                   	push   %esi
  8006c1:	53                   	push   %ebx
  8006c2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8006c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8006c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	89 04 24             	mov    %eax,(%esp)
  8006d2:	e8 5f fe ff ff       	call   800536 <fd_lookup>
  8006d7:	89 c2                	mov    %eax,%edx
  8006d9:	85 d2                	test   %edx,%edx
  8006db:	0f 88 e1 00 00 00    	js     8007c2 <dup+0x106>
		return r;
	close(newfdnum);
  8006e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e4:	89 04 24             	mov    %eax,(%esp)
  8006e7:	e8 7b ff ff ff       	call   800667 <close>

	newfd = INDEX2FD(newfdnum);
  8006ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006ef:	c1 e3 0c             	shl    $0xc,%ebx
  8006f2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8006f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006fb:	89 04 24             	mov    %eax,(%esp)
  8006fe:	e8 cd fd ff ff       	call   8004d0 <fd2data>
  800703:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  800705:	89 1c 24             	mov    %ebx,(%esp)
  800708:	e8 c3 fd ff ff       	call   8004d0 <fd2data>
  80070d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80070f:	89 f0                	mov    %esi,%eax
  800711:	c1 e8 16             	shr    $0x16,%eax
  800714:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80071b:	a8 01                	test   $0x1,%al
  80071d:	74 43                	je     800762 <dup+0xa6>
  80071f:	89 f0                	mov    %esi,%eax
  800721:	c1 e8 0c             	shr    $0xc,%eax
  800724:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80072b:	f6 c2 01             	test   $0x1,%dl
  80072e:	74 32                	je     800762 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800730:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800737:	25 07 0e 00 00       	and    $0xe07,%eax
  80073c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800740:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800744:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80074b:	00 
  80074c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800750:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800757:	e8 76 fa ff ff       	call   8001d2 <sys_page_map>
  80075c:	89 c6                	mov    %eax,%esi
  80075e:	85 c0                	test   %eax,%eax
  800760:	78 3e                	js     8007a0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800762:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800765:	89 c2                	mov    %eax,%edx
  800767:	c1 ea 0c             	shr    $0xc,%edx
  80076a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800771:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800777:	89 54 24 10          	mov    %edx,0x10(%esp)
  80077b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80077f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800786:	00 
  800787:	89 44 24 04          	mov    %eax,0x4(%esp)
  80078b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800792:	e8 3b fa ff ff       	call   8001d2 <sys_page_map>
  800797:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  800799:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80079c:	85 f6                	test   %esi,%esi
  80079e:	79 22                	jns    8007c2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8007a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007ab:	e8 75 fa ff ff       	call   800225 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8007b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007bb:	e8 65 fa ff ff       	call   800225 <sys_page_unmap>
	return r;
  8007c0:	89 f0                	mov    %esi,%eax
}
  8007c2:	83 c4 3c             	add    $0x3c,%esp
  8007c5:	5b                   	pop    %ebx
  8007c6:	5e                   	pop    %esi
  8007c7:	5f                   	pop    %edi
  8007c8:	5d                   	pop    %ebp
  8007c9:	c3                   	ret    

008007ca <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8007ca:	55                   	push   %ebp
  8007cb:	89 e5                	mov    %esp,%ebp
  8007cd:	53                   	push   %ebx
  8007ce:	83 ec 24             	sub    $0x24,%esp
  8007d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007db:	89 1c 24             	mov    %ebx,(%esp)
  8007de:	e8 53 fd ff ff       	call   800536 <fd_lookup>
  8007e3:	89 c2                	mov    %eax,%edx
  8007e5:	85 d2                	test   %edx,%edx
  8007e7:	78 6d                	js     800856 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	89 04 24             	mov    %eax,(%esp)
  8007f8:	e8 8f fd ff ff       	call   80058c <dev_lookup>
  8007fd:	85 c0                	test   %eax,%eax
  8007ff:	78 55                	js     800856 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800804:	8b 50 08             	mov    0x8(%eax),%edx
  800807:	83 e2 03             	and    $0x3,%edx
  80080a:	83 fa 01             	cmp    $0x1,%edx
  80080d:	75 23                	jne    800832 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80080f:	a1 08 40 80 00       	mov    0x804008,%eax
  800814:	8b 40 48             	mov    0x48(%eax),%eax
  800817:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80081b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80081f:	c7 04 24 e5 26 80 00 	movl   $0x8026e5,(%esp)
  800826:	e8 a4 10 00 00       	call   8018cf <cprintf>
		return -E_INVAL;
  80082b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800830:	eb 24                	jmp    800856 <read+0x8c>
	}
	if (!dev->dev_read)
  800832:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800835:	8b 52 08             	mov    0x8(%edx),%edx
  800838:	85 d2                	test   %edx,%edx
  80083a:	74 15                	je     800851 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80083c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80083f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800843:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800846:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80084a:	89 04 24             	mov    %eax,(%esp)
  80084d:	ff d2                	call   *%edx
  80084f:	eb 05                	jmp    800856 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800851:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800856:	83 c4 24             	add    $0x24,%esp
  800859:	5b                   	pop    %ebx
  80085a:	5d                   	pop    %ebp
  80085b:	c3                   	ret    

0080085c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
  80085f:	57                   	push   %edi
  800860:	56                   	push   %esi
  800861:	53                   	push   %ebx
  800862:	83 ec 1c             	sub    $0x1c,%esp
  800865:	8b 7d 08             	mov    0x8(%ebp),%edi
  800868:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80086b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800870:	eb 23                	jmp    800895 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800872:	89 f0                	mov    %esi,%eax
  800874:	29 d8                	sub    %ebx,%eax
  800876:	89 44 24 08          	mov    %eax,0x8(%esp)
  80087a:	89 d8                	mov    %ebx,%eax
  80087c:	03 45 0c             	add    0xc(%ebp),%eax
  80087f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800883:	89 3c 24             	mov    %edi,(%esp)
  800886:	e8 3f ff ff ff       	call   8007ca <read>
		if (m < 0)
  80088b:	85 c0                	test   %eax,%eax
  80088d:	78 10                	js     80089f <readn+0x43>
			return m;
		if (m == 0)
  80088f:	85 c0                	test   %eax,%eax
  800891:	74 0a                	je     80089d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800893:	01 c3                	add    %eax,%ebx
  800895:	39 f3                	cmp    %esi,%ebx
  800897:	72 d9                	jb     800872 <readn+0x16>
  800899:	89 d8                	mov    %ebx,%eax
  80089b:	eb 02                	jmp    80089f <readn+0x43>
  80089d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80089f:	83 c4 1c             	add    $0x1c,%esp
  8008a2:	5b                   	pop    %ebx
  8008a3:	5e                   	pop    %esi
  8008a4:	5f                   	pop    %edi
  8008a5:	5d                   	pop    %ebp
  8008a6:	c3                   	ret    

008008a7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	53                   	push   %ebx
  8008ab:	83 ec 24             	sub    $0x24,%esp
  8008ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b8:	89 1c 24             	mov    %ebx,(%esp)
  8008bb:	e8 76 fc ff ff       	call   800536 <fd_lookup>
  8008c0:	89 c2                	mov    %eax,%edx
  8008c2:	85 d2                	test   %edx,%edx
  8008c4:	78 68                	js     80092e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	89 04 24             	mov    %eax,(%esp)
  8008d5:	e8 b2 fc ff ff       	call   80058c <dev_lookup>
  8008da:	85 c0                	test   %eax,%eax
  8008dc:	78 50                	js     80092e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8008de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8008e5:	75 23                	jne    80090a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8008e7:	a1 08 40 80 00       	mov    0x804008,%eax
  8008ec:	8b 40 48             	mov    0x48(%eax),%eax
  8008ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8008f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f7:	c7 04 24 01 27 80 00 	movl   $0x802701,(%esp)
  8008fe:	e8 cc 0f 00 00       	call   8018cf <cprintf>
		return -E_INVAL;
  800903:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800908:	eb 24                	jmp    80092e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80090a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80090d:	8b 52 0c             	mov    0xc(%edx),%edx
  800910:	85 d2                	test   %edx,%edx
  800912:	74 15                	je     800929 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800914:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800917:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80091b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80091e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800922:	89 04 24             	mov    %eax,(%esp)
  800925:	ff d2                	call   *%edx
  800927:	eb 05                	jmp    80092e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800929:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80092e:	83 c4 24             	add    $0x24,%esp
  800931:	5b                   	pop    %ebx
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <seek>:

int
seek(int fdnum, off_t offset)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80093a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80093d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	89 04 24             	mov    %eax,(%esp)
  800947:	e8 ea fb ff ff       	call   800536 <fd_lookup>
  80094c:	85 c0                	test   %eax,%eax
  80094e:	78 0e                	js     80095e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800950:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800953:	8b 55 0c             	mov    0xc(%ebp),%edx
  800956:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800959:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80095e:	c9                   	leave  
  80095f:	c3                   	ret    

00800960 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	53                   	push   %ebx
  800964:	83 ec 24             	sub    $0x24,%esp
  800967:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80096a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800971:	89 1c 24             	mov    %ebx,(%esp)
  800974:	e8 bd fb ff ff       	call   800536 <fd_lookup>
  800979:	89 c2                	mov    %eax,%edx
  80097b:	85 d2                	test   %edx,%edx
  80097d:	78 61                	js     8009e0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80097f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800982:	89 44 24 04          	mov    %eax,0x4(%esp)
  800986:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800989:	8b 00                	mov    (%eax),%eax
  80098b:	89 04 24             	mov    %eax,(%esp)
  80098e:	e8 f9 fb ff ff       	call   80058c <dev_lookup>
  800993:	85 c0                	test   %eax,%eax
  800995:	78 49                	js     8009e0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800997:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80099e:	75 23                	jne    8009c3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8009a0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8009a5:	8b 40 48             	mov    0x48(%eax),%eax
  8009a8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8009ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b0:	c7 04 24 c4 26 80 00 	movl   $0x8026c4,(%esp)
  8009b7:	e8 13 0f 00 00       	call   8018cf <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8009bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009c1:	eb 1d                	jmp    8009e0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8009c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009c6:	8b 52 18             	mov    0x18(%edx),%edx
  8009c9:	85 d2                	test   %edx,%edx
  8009cb:	74 0e                	je     8009db <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8009cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009d4:	89 04 24             	mov    %eax,(%esp)
  8009d7:	ff d2                	call   *%edx
  8009d9:	eb 05                	jmp    8009e0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8009db:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8009e0:	83 c4 24             	add    $0x24,%esp
  8009e3:	5b                   	pop    %ebx
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	53                   	push   %ebx
  8009ea:	83 ec 24             	sub    $0x24,%esp
  8009ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8009f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8009f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	89 04 24             	mov    %eax,(%esp)
  8009fd:	e8 34 fb ff ff       	call   800536 <fd_lookup>
  800a02:	89 c2                	mov    %eax,%edx
  800a04:	85 d2                	test   %edx,%edx
  800a06:	78 52                	js     800a5a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a08:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a12:	8b 00                	mov    (%eax),%eax
  800a14:	89 04 24             	mov    %eax,(%esp)
  800a17:	e8 70 fb ff ff       	call   80058c <dev_lookup>
  800a1c:	85 c0                	test   %eax,%eax
  800a1e:	78 3a                	js     800a5a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a23:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800a27:	74 2c                	je     800a55 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800a29:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800a2c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800a33:	00 00 00 
	stat->st_isdir = 0;
  800a36:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800a3d:	00 00 00 
	stat->st_dev = dev;
  800a40:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800a46:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a4d:	89 14 24             	mov    %edx,(%esp)
  800a50:	ff 50 14             	call   *0x14(%eax)
  800a53:	eb 05                	jmp    800a5a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800a55:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800a5a:	83 c4 24             	add    $0x24,%esp
  800a5d:	5b                   	pop    %ebx
  800a5e:	5d                   	pop    %ebp
  800a5f:	c3                   	ret    

00800a60 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	56                   	push   %esi
  800a64:	53                   	push   %ebx
  800a65:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800a68:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800a6f:	00 
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	89 04 24             	mov    %eax,(%esp)
  800a76:	e8 84 02 00 00       	call   800cff <open>
  800a7b:	89 c3                	mov    %eax,%ebx
  800a7d:	85 db                	test   %ebx,%ebx
  800a7f:	78 1b                	js     800a9c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a84:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a88:	89 1c 24             	mov    %ebx,(%esp)
  800a8b:	e8 56 ff ff ff       	call   8009e6 <fstat>
  800a90:	89 c6                	mov    %eax,%esi
	close(fd);
  800a92:	89 1c 24             	mov    %ebx,(%esp)
  800a95:	e8 cd fb ff ff       	call   800667 <close>
	return r;
  800a9a:	89 f0                	mov    %esi,%eax
}
  800a9c:	83 c4 10             	add    $0x10,%esp
  800a9f:	5b                   	pop    %ebx
  800aa0:	5e                   	pop    %esi
  800aa1:	5d                   	pop    %ebp
  800aa2:	c3                   	ret    

00800aa3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	56                   	push   %esi
  800aa7:	53                   	push   %ebx
  800aa8:	83 ec 10             	sub    $0x10,%esp
  800aab:	89 c6                	mov    %eax,%esi
  800aad:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800aaf:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800ab6:	75 11                	jne    800ac9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ab8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800abf:	e8 81 18 00 00       	call   802345 <ipc_find_env>
  800ac4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800ac9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800ad0:	00 
  800ad1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800ad8:	00 
  800ad9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800add:	a1 00 40 80 00       	mov    0x804000,%eax
  800ae2:	89 04 24             	mov    %eax,(%esp)
  800ae5:	e8 ce 17 00 00       	call   8022b8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800aea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800af1:	00 
  800af2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800af6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800afd:	e8 4e 17 00 00       	call   802250 <ipc_recv>
}
  800b02:	83 c4 10             	add    $0x10,%esp
  800b05:	5b                   	pop    %ebx
  800b06:	5e                   	pop    %esi
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	8b 40 0c             	mov    0xc(%eax),%eax
  800b15:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800b22:	ba 00 00 00 00       	mov    $0x0,%edx
  800b27:	b8 02 00 00 00       	mov    $0x2,%eax
  800b2c:	e8 72 ff ff ff       	call   800aa3 <fsipc>
}
  800b31:	c9                   	leave  
  800b32:	c3                   	ret    

00800b33 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8b 40 0c             	mov    0xc(%eax),%eax
  800b3f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800b44:	ba 00 00 00 00       	mov    $0x0,%edx
  800b49:	b8 06 00 00 00       	mov    $0x6,%eax
  800b4e:	e8 50 ff ff ff       	call   800aa3 <fsipc>
}
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	53                   	push   %ebx
  800b59:	83 ec 14             	sub    $0x14,%esp
  800b5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	8b 40 0c             	mov    0xc(%eax),%eax
  800b65:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800b6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6f:	b8 05 00 00 00       	mov    $0x5,%eax
  800b74:	e8 2a ff ff ff       	call   800aa3 <fsipc>
  800b79:	89 c2                	mov    %eax,%edx
  800b7b:	85 d2                	test   %edx,%edx
  800b7d:	78 2b                	js     800baa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800b7f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800b86:	00 
  800b87:	89 1c 24             	mov    %ebx,(%esp)
  800b8a:	e8 68 13 00 00       	call   801ef7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800b8f:	a1 80 50 80 00       	mov    0x805080,%eax
  800b94:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800b9a:	a1 84 50 80 00       	mov    0x805084,%eax
  800b9f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800ba5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800baa:	83 c4 14             	add    $0x14,%esp
  800bad:	5b                   	pop    %ebx
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    

00800bb0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	53                   	push   %ebx
  800bb4:	83 ec 14             	sub    $0x14,%esp
  800bb7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	8b 40 0c             	mov    0xc(%eax),%eax
  800bc0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  800bc5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800bcb:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  800bd0:	0f 46 c3             	cmovbe %ebx,%eax
  800bd3:	a3 04 50 80 00       	mov    %eax,0x805004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  800bd8:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  800be3:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  800bea:	e8 a5 14 00 00       	call   802094 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800bef:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf4:	b8 04 00 00 00       	mov    $0x4,%eax
  800bf9:	e8 a5 fe ff ff       	call   800aa3 <fsipc>
  800bfe:	85 c0                	test   %eax,%eax
  800c00:	78 53                	js     800c55 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  800c02:	39 c3                	cmp    %eax,%ebx
  800c04:	73 24                	jae    800c2a <devfile_write+0x7a>
  800c06:	c7 44 24 0c 34 27 80 	movl   $0x802734,0xc(%esp)
  800c0d:	00 
  800c0e:	c7 44 24 08 3b 27 80 	movl   $0x80273b,0x8(%esp)
  800c15:	00 
  800c16:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  800c1d:	00 
  800c1e:	c7 04 24 50 27 80 00 	movl   $0x802750,(%esp)
  800c25:	e8 ac 0b 00 00       	call   8017d6 <_panic>
	assert(r <= PGSIZE);
  800c2a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800c2f:	7e 24                	jle    800c55 <devfile_write+0xa5>
  800c31:	c7 44 24 0c 5b 27 80 	movl   $0x80275b,0xc(%esp)
  800c38:	00 
  800c39:	c7 44 24 08 3b 27 80 	movl   $0x80273b,0x8(%esp)
  800c40:	00 
  800c41:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  800c48:	00 
  800c49:	c7 04 24 50 27 80 00 	movl   $0x802750,(%esp)
  800c50:	e8 81 0b 00 00       	call   8017d6 <_panic>
	return r;
}
  800c55:	83 c4 14             	add    $0x14,%esp
  800c58:	5b                   	pop    %ebx
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    

00800c5b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	56                   	push   %esi
  800c5f:	53                   	push   %ebx
  800c60:	83 ec 10             	sub    $0x10,%esp
  800c63:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	8b 40 0c             	mov    0xc(%eax),%eax
  800c6c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800c71:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800c77:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7c:	b8 03 00 00 00       	mov    $0x3,%eax
  800c81:	e8 1d fe ff ff       	call   800aa3 <fsipc>
  800c86:	89 c3                	mov    %eax,%ebx
  800c88:	85 c0                	test   %eax,%eax
  800c8a:	78 6a                	js     800cf6 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800c8c:	39 c6                	cmp    %eax,%esi
  800c8e:	73 24                	jae    800cb4 <devfile_read+0x59>
  800c90:	c7 44 24 0c 34 27 80 	movl   $0x802734,0xc(%esp)
  800c97:	00 
  800c98:	c7 44 24 08 3b 27 80 	movl   $0x80273b,0x8(%esp)
  800c9f:	00 
  800ca0:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  800ca7:	00 
  800ca8:	c7 04 24 50 27 80 00 	movl   $0x802750,(%esp)
  800caf:	e8 22 0b 00 00       	call   8017d6 <_panic>
	assert(r <= PGSIZE);
  800cb4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800cb9:	7e 24                	jle    800cdf <devfile_read+0x84>
  800cbb:	c7 44 24 0c 5b 27 80 	movl   $0x80275b,0xc(%esp)
  800cc2:	00 
  800cc3:	c7 44 24 08 3b 27 80 	movl   $0x80273b,0x8(%esp)
  800cca:	00 
  800ccb:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  800cd2:	00 
  800cd3:	c7 04 24 50 27 80 00 	movl   $0x802750,(%esp)
  800cda:	e8 f7 0a 00 00       	call   8017d6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800cdf:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ce3:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800cea:	00 
  800ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cee:	89 04 24             	mov    %eax,(%esp)
  800cf1:	e8 9e 13 00 00       	call   802094 <memmove>
	return r;
}
  800cf6:	89 d8                	mov    %ebx,%eax
  800cf8:	83 c4 10             	add    $0x10,%esp
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5d                   	pop    %ebp
  800cfe:	c3                   	ret    

00800cff <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	53                   	push   %ebx
  800d03:	83 ec 24             	sub    $0x24,%esp
  800d06:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800d09:	89 1c 24             	mov    %ebx,(%esp)
  800d0c:	e8 af 11 00 00       	call   801ec0 <strlen>
  800d11:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800d16:	7f 60                	jg     800d78 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800d18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d1b:	89 04 24             	mov    %eax,(%esp)
  800d1e:	e8 c4 f7 ff ff       	call   8004e7 <fd_alloc>
  800d23:	89 c2                	mov    %eax,%edx
  800d25:	85 d2                	test   %edx,%edx
  800d27:	78 54                	js     800d7d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800d29:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d2d:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800d34:	e8 be 11 00 00       	call   801ef7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800d41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d44:	b8 01 00 00 00       	mov    $0x1,%eax
  800d49:	e8 55 fd ff ff       	call   800aa3 <fsipc>
  800d4e:	89 c3                	mov    %eax,%ebx
  800d50:	85 c0                	test   %eax,%eax
  800d52:	79 17                	jns    800d6b <open+0x6c>
		fd_close(fd, 0);
  800d54:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800d5b:	00 
  800d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d5f:	89 04 24             	mov    %eax,(%esp)
  800d62:	e8 7f f8 ff ff       	call   8005e6 <fd_close>
		return r;
  800d67:	89 d8                	mov    %ebx,%eax
  800d69:	eb 12                	jmp    800d7d <open+0x7e>
	}

	return fd2num(fd);
  800d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d6e:	89 04 24             	mov    %eax,(%esp)
  800d71:	e8 4a f7 ff ff       	call   8004c0 <fd2num>
  800d76:	eb 05                	jmp    800d7d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800d78:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800d7d:	83 c4 24             	add    $0x24,%esp
  800d80:	5b                   	pop    %ebx
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800d89:	ba 00 00 00 00       	mov    $0x0,%edx
  800d8e:	b8 08 00 00 00       	mov    $0x8,%eax
  800d93:	e8 0b fd ff ff       	call   800aa3 <fsipc>
}
  800d98:	c9                   	leave  
  800d99:	c3                   	ret    
  800d9a:	66 90                	xchg   %ax,%ax
  800d9c:	66 90                	xchg   %ax,%ax
  800d9e:	66 90                	xchg   %ax,%ax

00800da0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  800da6:	c7 44 24 04 67 27 80 	movl   $0x802767,0x4(%esp)
  800dad:	00 
  800dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db1:	89 04 24             	mov    %eax,(%esp)
  800db4:	e8 3e 11 00 00       	call   801ef7 <strcpy>
	return 0;
}
  800db9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dbe:	c9                   	leave  
  800dbf:	c3                   	ret    

00800dc0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	53                   	push   %ebx
  800dc4:	83 ec 14             	sub    $0x14,%esp
  800dc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800dca:	89 1c 24             	mov    %ebx,(%esp)
  800dcd:	e8 ad 15 00 00       	call   80237f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  800dd2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  800dd7:	83 f8 01             	cmp    $0x1,%eax
  800dda:	75 0d                	jne    800de9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  800ddc:	8b 43 0c             	mov    0xc(%ebx),%eax
  800ddf:	89 04 24             	mov    %eax,(%esp)
  800de2:	e8 29 03 00 00       	call   801110 <nsipc_close>
  800de7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  800de9:	89 d0                	mov    %edx,%eax
  800deb:	83 c4 14             	add    $0x14,%esp
  800dee:	5b                   	pop    %ebx
  800def:	5d                   	pop    %ebp
  800df0:	c3                   	ret    

00800df1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800df7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800dfe:	00 
  800dff:	8b 45 10             	mov    0x10(%ebp),%eax
  800e02:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e09:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	8b 40 0c             	mov    0xc(%eax),%eax
  800e13:	89 04 24             	mov    %eax,(%esp)
  800e16:	e8 f0 03 00 00       	call   80120b <nsipc_send>
}
  800e1b:	c9                   	leave  
  800e1c:	c3                   	ret    

00800e1d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  800e1d:	55                   	push   %ebp
  800e1e:	89 e5                	mov    %esp,%ebp
  800e20:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800e23:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800e2a:	00 
  800e2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e35:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8b 40 0c             	mov    0xc(%eax),%eax
  800e3f:	89 04 24             	mov    %eax,(%esp)
  800e42:	e8 44 03 00 00       	call   80118b <nsipc_recv>
}
  800e47:	c9                   	leave  
  800e48:	c3                   	ret    

00800e49 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  800e4f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800e52:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e56:	89 04 24             	mov    %eax,(%esp)
  800e59:	e8 d8 f6 ff ff       	call   800536 <fd_lookup>
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	78 17                	js     800e79 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  800e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e65:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  800e6b:	39 08                	cmp    %ecx,(%eax)
  800e6d:	75 05                	jne    800e74 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  800e6f:	8b 40 0c             	mov    0xc(%eax),%eax
  800e72:	eb 05                	jmp    800e79 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  800e74:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  800e79:	c9                   	leave  
  800e7a:	c3                   	ret    

00800e7b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	56                   	push   %esi
  800e7f:	53                   	push   %ebx
  800e80:	83 ec 20             	sub    $0x20,%esp
  800e83:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800e85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e88:	89 04 24             	mov    %eax,(%esp)
  800e8b:	e8 57 f6 ff ff       	call   8004e7 <fd_alloc>
  800e90:	89 c3                	mov    %eax,%ebx
  800e92:	85 c0                	test   %eax,%eax
  800e94:	78 21                	js     800eb7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800e96:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800e9d:	00 
  800e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ea1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ea5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800eac:	e8 cd f2 ff ff       	call   80017e <sys_page_alloc>
  800eb1:	89 c3                	mov    %eax,%ebx
  800eb3:	85 c0                	test   %eax,%eax
  800eb5:	79 0c                	jns    800ec3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  800eb7:	89 34 24             	mov    %esi,(%esp)
  800eba:	e8 51 02 00 00       	call   801110 <nsipc_close>
		return r;
  800ebf:	89 d8                	mov    %ebx,%eax
  800ec1:	eb 20                	jmp    800ee3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  800ec3:	8b 15 24 30 80 00    	mov    0x803024,%edx
  800ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ecc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800ece:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  800ed8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  800edb:	89 14 24             	mov    %edx,(%esp)
  800ede:	e8 dd f5 ff ff       	call   8004c0 <fd2num>
}
  800ee3:	83 c4 20             	add    $0x20,%esp
  800ee6:	5b                   	pop    %ebx
  800ee7:	5e                   	pop    %esi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    

00800eea <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	e8 51 ff ff ff       	call   800e49 <fd2sockid>
		return r;
  800ef8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  800efa:	85 c0                	test   %eax,%eax
  800efc:	78 23                	js     800f21 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800efe:	8b 55 10             	mov    0x10(%ebp),%edx
  800f01:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f08:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f0c:	89 04 24             	mov    %eax,(%esp)
  800f0f:	e8 45 01 00 00       	call   801059 <nsipc_accept>
		return r;
  800f14:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800f16:	85 c0                	test   %eax,%eax
  800f18:	78 07                	js     800f21 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  800f1a:	e8 5c ff ff ff       	call   800e7b <alloc_sockfd>
  800f1f:	89 c1                	mov    %eax,%ecx
}
  800f21:	89 c8                	mov    %ecx,%eax
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	e8 16 ff ff ff       	call   800e49 <fd2sockid>
  800f33:	89 c2                	mov    %eax,%edx
  800f35:	85 d2                	test   %edx,%edx
  800f37:	78 16                	js     800f4f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  800f39:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f43:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f47:	89 14 24             	mov    %edx,(%esp)
  800f4a:	e8 60 01 00 00       	call   8010af <nsipc_bind>
}
  800f4f:	c9                   	leave  
  800f50:	c3                   	ret    

00800f51 <shutdown>:

int
shutdown(int s, int how)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	e8 ea fe ff ff       	call   800e49 <fd2sockid>
  800f5f:	89 c2                	mov    %eax,%edx
  800f61:	85 d2                	test   %edx,%edx
  800f63:	78 0f                	js     800f74 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  800f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f68:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f6c:	89 14 24             	mov    %edx,(%esp)
  800f6f:	e8 7a 01 00 00       	call   8010ee <nsipc_shutdown>
}
  800f74:	c9                   	leave  
  800f75:	c3                   	ret    

00800f76 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	e8 c5 fe ff ff       	call   800e49 <fd2sockid>
  800f84:	89 c2                	mov    %eax,%edx
  800f86:	85 d2                	test   %edx,%edx
  800f88:	78 16                	js     800fa0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  800f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f94:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f98:	89 14 24             	mov    %edx,(%esp)
  800f9b:	e8 8a 01 00 00       	call   80112a <nsipc_connect>
}
  800fa0:	c9                   	leave  
  800fa1:	c3                   	ret    

00800fa2 <listen>:

int
listen(int s, int backlog)
{
  800fa2:	55                   	push   %ebp
  800fa3:	89 e5                	mov    %esp,%ebp
  800fa5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	e8 99 fe ff ff       	call   800e49 <fd2sockid>
  800fb0:	89 c2                	mov    %eax,%edx
  800fb2:	85 d2                	test   %edx,%edx
  800fb4:	78 0f                	js     800fc5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fbd:	89 14 24             	mov    %edx,(%esp)
  800fc0:	e8 a4 01 00 00       	call   801169 <nsipc_listen>
}
  800fc5:	c9                   	leave  
  800fc6:	c3                   	ret    

00800fc7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800fcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd0:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	89 04 24             	mov    %eax,(%esp)
  800fe1:	e8 98 02 00 00       	call   80127e <nsipc_socket>
  800fe6:	89 c2                	mov    %eax,%edx
  800fe8:	85 d2                	test   %edx,%edx
  800fea:	78 05                	js     800ff1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  800fec:	e8 8a fe ff ff       	call   800e7b <alloc_sockfd>
}
  800ff1:	c9                   	leave  
  800ff2:	c3                   	ret    

00800ff3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	53                   	push   %ebx
  800ff7:	83 ec 14             	sub    $0x14,%esp
  800ffa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800ffc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801003:	75 11                	jne    801016 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801005:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80100c:	e8 34 13 00 00       	call   802345 <ipc_find_env>
  801011:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801016:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80101d:	00 
  80101e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801025:	00 
  801026:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80102a:	a1 04 40 80 00       	mov    0x804004,%eax
  80102f:	89 04 24             	mov    %eax,(%esp)
  801032:	e8 81 12 00 00       	call   8022b8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801037:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80103e:	00 
  80103f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801046:	00 
  801047:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80104e:	e8 fd 11 00 00       	call   802250 <ipc_recv>
}
  801053:	83 c4 14             	add    $0x14,%esp
  801056:	5b                   	pop    %ebx
  801057:	5d                   	pop    %ebp
  801058:	c3                   	ret    

00801059 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	56                   	push   %esi
  80105d:	53                   	push   %ebx
  80105e:	83 ec 10             	sub    $0x10,%esp
  801061:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80106c:	8b 06                	mov    (%esi),%eax
  80106e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801073:	b8 01 00 00 00       	mov    $0x1,%eax
  801078:	e8 76 ff ff ff       	call   800ff3 <nsipc>
  80107d:	89 c3                	mov    %eax,%ebx
  80107f:	85 c0                	test   %eax,%eax
  801081:	78 23                	js     8010a6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801083:	a1 10 60 80 00       	mov    0x806010,%eax
  801088:	89 44 24 08          	mov    %eax,0x8(%esp)
  80108c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801093:	00 
  801094:	8b 45 0c             	mov    0xc(%ebp),%eax
  801097:	89 04 24             	mov    %eax,(%esp)
  80109a:	e8 f5 0f 00 00       	call   802094 <memmove>
		*addrlen = ret->ret_addrlen;
  80109f:	a1 10 60 80 00       	mov    0x806010,%eax
  8010a4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8010a6:	89 d8                	mov    %ebx,%eax
  8010a8:	83 c4 10             	add    $0x10,%esp
  8010ab:	5b                   	pop    %ebx
  8010ac:	5e                   	pop    %esi
  8010ad:	5d                   	pop    %ebp
  8010ae:	c3                   	ret    

008010af <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	53                   	push   %ebx
  8010b3:	83 ec 14             	sub    $0x14,%esp
  8010b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8010c1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8010c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010cc:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8010d3:	e8 bc 0f 00 00       	call   802094 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8010d8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8010de:	b8 02 00 00 00       	mov    $0x2,%eax
  8010e3:	e8 0b ff ff ff       	call   800ff3 <nsipc>
}
  8010e8:	83 c4 14             	add    $0x14,%esp
  8010eb:	5b                   	pop    %ebx
  8010ec:	5d                   	pop    %ebp
  8010ed:	c3                   	ret    

008010ee <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8010ee:	55                   	push   %ebp
  8010ef:	89 e5                	mov    %esp,%ebp
  8010f1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8010fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ff:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801104:	b8 03 00 00 00       	mov    $0x3,%eax
  801109:	e8 e5 fe ff ff       	call   800ff3 <nsipc>
}
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <nsipc_close>:

int
nsipc_close(int s)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80111e:	b8 04 00 00 00       	mov    $0x4,%eax
  801123:	e8 cb fe ff ff       	call   800ff3 <nsipc>
}
  801128:	c9                   	leave  
  801129:	c3                   	ret    

0080112a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	53                   	push   %ebx
  80112e:	83 ec 14             	sub    $0x14,%esp
  801131:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80113c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	89 44 24 04          	mov    %eax,0x4(%esp)
  801147:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  80114e:	e8 41 0f 00 00       	call   802094 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801153:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801159:	b8 05 00 00 00       	mov    $0x5,%eax
  80115e:	e8 90 fe ff ff       	call   800ff3 <nsipc>
}
  801163:	83 c4 14             	add    $0x14,%esp
  801166:	5b                   	pop    %ebx
  801167:	5d                   	pop    %ebp
  801168:	c3                   	ret    

00801169 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801177:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80117f:	b8 06 00 00 00       	mov    $0x6,%eax
  801184:	e8 6a fe ff ff       	call   800ff3 <nsipc>
}
  801189:	c9                   	leave  
  80118a:	c3                   	ret    

0080118b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	56                   	push   %esi
  80118f:	53                   	push   %ebx
  801190:	83 ec 10             	sub    $0x10,%esp
  801193:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801196:	8b 45 08             	mov    0x8(%ebp),%eax
  801199:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80119e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8011a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8011ac:	b8 07 00 00 00       	mov    $0x7,%eax
  8011b1:	e8 3d fe ff ff       	call   800ff3 <nsipc>
  8011b6:	89 c3                	mov    %eax,%ebx
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	78 46                	js     801202 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8011bc:	39 f0                	cmp    %esi,%eax
  8011be:	7f 07                	jg     8011c7 <nsipc_recv+0x3c>
  8011c0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8011c5:	7e 24                	jle    8011eb <nsipc_recv+0x60>
  8011c7:	c7 44 24 0c 73 27 80 	movl   $0x802773,0xc(%esp)
  8011ce:	00 
  8011cf:	c7 44 24 08 3b 27 80 	movl   $0x80273b,0x8(%esp)
  8011d6:	00 
  8011d7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8011de:	00 
  8011df:	c7 04 24 88 27 80 00 	movl   $0x802788,(%esp)
  8011e6:	e8 eb 05 00 00       	call   8017d6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8011eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011ef:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8011f6:	00 
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	89 04 24             	mov    %eax,(%esp)
  8011fd:	e8 92 0e 00 00       	call   802094 <memmove>
	}

	return r;
}
  801202:	89 d8                	mov    %ebx,%eax
  801204:	83 c4 10             	add    $0x10,%esp
  801207:	5b                   	pop    %ebx
  801208:	5e                   	pop    %esi
  801209:	5d                   	pop    %ebp
  80120a:	c3                   	ret    

0080120b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	53                   	push   %ebx
  80120f:	83 ec 14             	sub    $0x14,%esp
  801212:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80121d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801223:	7e 24                	jle    801249 <nsipc_send+0x3e>
  801225:	c7 44 24 0c 94 27 80 	movl   $0x802794,0xc(%esp)
  80122c:	00 
  80122d:	c7 44 24 08 3b 27 80 	movl   $0x80273b,0x8(%esp)
  801234:	00 
  801235:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80123c:	00 
  80123d:	c7 04 24 88 27 80 00 	movl   $0x802788,(%esp)
  801244:	e8 8d 05 00 00       	call   8017d6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801249:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80124d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801250:	89 44 24 04          	mov    %eax,0x4(%esp)
  801254:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80125b:	e8 34 0e 00 00       	call   802094 <memmove>
	nsipcbuf.send.req_size = size;
  801260:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801266:	8b 45 14             	mov    0x14(%ebp),%eax
  801269:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80126e:	b8 08 00 00 00       	mov    $0x8,%eax
  801273:	e8 7b fd ff ff       	call   800ff3 <nsipc>
}
  801278:	83 c4 14             	add    $0x14,%esp
  80127b:	5b                   	pop    %ebx
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    

0080127e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80128c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801294:	8b 45 10             	mov    0x10(%ebp),%eax
  801297:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80129c:	b8 09 00 00 00       	mov    $0x9,%eax
  8012a1:	e8 4d fd ff ff       	call   800ff3 <nsipc>
}
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    

008012a8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	56                   	push   %esi
  8012ac:	53                   	push   %ebx
  8012ad:	83 ec 10             	sub    $0x10,%esp
  8012b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	89 04 24             	mov    %eax,(%esp)
  8012b9:	e8 12 f2 ff ff       	call   8004d0 <fd2data>
  8012be:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8012c0:	c7 44 24 04 a0 27 80 	movl   $0x8027a0,0x4(%esp)
  8012c7:	00 
  8012c8:	89 1c 24             	mov    %ebx,(%esp)
  8012cb:	e8 27 0c 00 00       	call   801ef7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8012d0:	8b 46 04             	mov    0x4(%esi),%eax
  8012d3:	2b 06                	sub    (%esi),%eax
  8012d5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8012db:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012e2:	00 00 00 
	stat->st_dev = &devpipe;
  8012e5:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  8012ec:	30 80 00 
	return 0;
}
  8012ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8012f4:	83 c4 10             	add    $0x10,%esp
  8012f7:	5b                   	pop    %ebx
  8012f8:	5e                   	pop    %esi
  8012f9:	5d                   	pop    %ebp
  8012fa:	c3                   	ret    

008012fb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	53                   	push   %ebx
  8012ff:	83 ec 14             	sub    $0x14,%esp
  801302:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801305:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801309:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801310:	e8 10 ef ff ff       	call   800225 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801315:	89 1c 24             	mov    %ebx,(%esp)
  801318:	e8 b3 f1 ff ff       	call   8004d0 <fd2data>
  80131d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801321:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801328:	e8 f8 ee ff ff       	call   800225 <sys_page_unmap>
}
  80132d:	83 c4 14             	add    $0x14,%esp
  801330:	5b                   	pop    %ebx
  801331:	5d                   	pop    %ebp
  801332:	c3                   	ret    

00801333 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	57                   	push   %edi
  801337:	56                   	push   %esi
  801338:	53                   	push   %ebx
  801339:	83 ec 2c             	sub    $0x2c,%esp
  80133c:	89 c6                	mov    %eax,%esi
  80133e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801341:	a1 08 40 80 00       	mov    0x804008,%eax
  801346:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801349:	89 34 24             	mov    %esi,(%esp)
  80134c:	e8 2e 10 00 00       	call   80237f <pageref>
  801351:	89 c7                	mov    %eax,%edi
  801353:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801356:	89 04 24             	mov    %eax,(%esp)
  801359:	e8 21 10 00 00       	call   80237f <pageref>
  80135e:	39 c7                	cmp    %eax,%edi
  801360:	0f 94 c2             	sete   %dl
  801363:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801366:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  80136c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80136f:	39 fb                	cmp    %edi,%ebx
  801371:	74 21                	je     801394 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801373:	84 d2                	test   %dl,%dl
  801375:	74 ca                	je     801341 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801377:	8b 51 58             	mov    0x58(%ecx),%edx
  80137a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80137e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801382:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801386:	c7 04 24 a7 27 80 00 	movl   $0x8027a7,(%esp)
  80138d:	e8 3d 05 00 00       	call   8018cf <cprintf>
  801392:	eb ad                	jmp    801341 <_pipeisclosed+0xe>
	}
}
  801394:	83 c4 2c             	add    $0x2c,%esp
  801397:	5b                   	pop    %ebx
  801398:	5e                   	pop    %esi
  801399:	5f                   	pop    %edi
  80139a:	5d                   	pop    %ebp
  80139b:	c3                   	ret    

0080139c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	57                   	push   %edi
  8013a0:	56                   	push   %esi
  8013a1:	53                   	push   %ebx
  8013a2:	83 ec 1c             	sub    $0x1c,%esp
  8013a5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8013a8:	89 34 24             	mov    %esi,(%esp)
  8013ab:	e8 20 f1 ff ff       	call   8004d0 <fd2data>
  8013b0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8013b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8013b7:	eb 45                	jmp    8013fe <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8013b9:	89 da                	mov    %ebx,%edx
  8013bb:	89 f0                	mov    %esi,%eax
  8013bd:	e8 71 ff ff ff       	call   801333 <_pipeisclosed>
  8013c2:	85 c0                	test   %eax,%eax
  8013c4:	75 41                	jne    801407 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8013c6:	e8 94 ed ff ff       	call   80015f <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8013cb:	8b 43 04             	mov    0x4(%ebx),%eax
  8013ce:	8b 0b                	mov    (%ebx),%ecx
  8013d0:	8d 51 20             	lea    0x20(%ecx),%edx
  8013d3:	39 d0                	cmp    %edx,%eax
  8013d5:	73 e2                	jae    8013b9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8013d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013da:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8013de:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8013e1:	99                   	cltd   
  8013e2:	c1 ea 1b             	shr    $0x1b,%edx
  8013e5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8013e8:	83 e1 1f             	and    $0x1f,%ecx
  8013eb:	29 d1                	sub    %edx,%ecx
  8013ed:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8013f1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8013f5:	83 c0 01             	add    $0x1,%eax
  8013f8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8013fb:	83 c7 01             	add    $0x1,%edi
  8013fe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801401:	75 c8                	jne    8013cb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801403:	89 f8                	mov    %edi,%eax
  801405:	eb 05                	jmp    80140c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801407:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80140c:	83 c4 1c             	add    $0x1c,%esp
  80140f:	5b                   	pop    %ebx
  801410:	5e                   	pop    %esi
  801411:	5f                   	pop    %edi
  801412:	5d                   	pop    %ebp
  801413:	c3                   	ret    

00801414 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
  801417:	57                   	push   %edi
  801418:	56                   	push   %esi
  801419:	53                   	push   %ebx
  80141a:	83 ec 1c             	sub    $0x1c,%esp
  80141d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801420:	89 3c 24             	mov    %edi,(%esp)
  801423:	e8 a8 f0 ff ff       	call   8004d0 <fd2data>
  801428:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80142a:	be 00 00 00 00       	mov    $0x0,%esi
  80142f:	eb 3d                	jmp    80146e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801431:	85 f6                	test   %esi,%esi
  801433:	74 04                	je     801439 <devpipe_read+0x25>
				return i;
  801435:	89 f0                	mov    %esi,%eax
  801437:	eb 43                	jmp    80147c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801439:	89 da                	mov    %ebx,%edx
  80143b:	89 f8                	mov    %edi,%eax
  80143d:	e8 f1 fe ff ff       	call   801333 <_pipeisclosed>
  801442:	85 c0                	test   %eax,%eax
  801444:	75 31                	jne    801477 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801446:	e8 14 ed ff ff       	call   80015f <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80144b:	8b 03                	mov    (%ebx),%eax
  80144d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801450:	74 df                	je     801431 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801452:	99                   	cltd   
  801453:	c1 ea 1b             	shr    $0x1b,%edx
  801456:	01 d0                	add    %edx,%eax
  801458:	83 e0 1f             	and    $0x1f,%eax
  80145b:	29 d0                	sub    %edx,%eax
  80145d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801462:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801465:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801468:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80146b:	83 c6 01             	add    $0x1,%esi
  80146e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801471:	75 d8                	jne    80144b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801473:	89 f0                	mov    %esi,%eax
  801475:	eb 05                	jmp    80147c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801477:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80147c:	83 c4 1c             	add    $0x1c,%esp
  80147f:	5b                   	pop    %ebx
  801480:	5e                   	pop    %esi
  801481:	5f                   	pop    %edi
  801482:	5d                   	pop    %ebp
  801483:	c3                   	ret    

00801484 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	56                   	push   %esi
  801488:	53                   	push   %ebx
  801489:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80148c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80148f:	89 04 24             	mov    %eax,(%esp)
  801492:	e8 50 f0 ff ff       	call   8004e7 <fd_alloc>
  801497:	89 c2                	mov    %eax,%edx
  801499:	85 d2                	test   %edx,%edx
  80149b:	0f 88 4d 01 00 00    	js     8015ee <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8014a1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8014a8:	00 
  8014a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014b7:	e8 c2 ec ff ff       	call   80017e <sys_page_alloc>
  8014bc:	89 c2                	mov    %eax,%edx
  8014be:	85 d2                	test   %edx,%edx
  8014c0:	0f 88 28 01 00 00    	js     8015ee <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8014c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c9:	89 04 24             	mov    %eax,(%esp)
  8014cc:	e8 16 f0 ff ff       	call   8004e7 <fd_alloc>
  8014d1:	89 c3                	mov    %eax,%ebx
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	0f 88 fe 00 00 00    	js     8015d9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8014db:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8014e2:	00 
  8014e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014f1:	e8 88 ec ff ff       	call   80017e <sys_page_alloc>
  8014f6:	89 c3                	mov    %eax,%ebx
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	0f 88 d9 00 00 00    	js     8015d9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801503:	89 04 24             	mov    %eax,(%esp)
  801506:	e8 c5 ef ff ff       	call   8004d0 <fd2data>
  80150b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80150d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801514:	00 
  801515:	89 44 24 04          	mov    %eax,0x4(%esp)
  801519:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801520:	e8 59 ec ff ff       	call   80017e <sys_page_alloc>
  801525:	89 c3                	mov    %eax,%ebx
  801527:	85 c0                	test   %eax,%eax
  801529:	0f 88 97 00 00 00    	js     8015c6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80152f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801532:	89 04 24             	mov    %eax,(%esp)
  801535:	e8 96 ef ff ff       	call   8004d0 <fd2data>
  80153a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801541:	00 
  801542:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801546:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80154d:	00 
  80154e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801552:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801559:	e8 74 ec ff ff       	call   8001d2 <sys_page_map>
  80155e:	89 c3                	mov    %eax,%ebx
  801560:	85 c0                	test   %eax,%eax
  801562:	78 52                	js     8015b6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801564:	8b 15 40 30 80 00    	mov    0x803040,%edx
  80156a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80156f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801572:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801579:	8b 15 40 30 80 00    	mov    0x803040,%edx
  80157f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801582:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801587:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80158e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801591:	89 04 24             	mov    %eax,(%esp)
  801594:	e8 27 ef ff ff       	call   8004c0 <fd2num>
  801599:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80159c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80159e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a1:	89 04 24             	mov    %eax,(%esp)
  8015a4:	e8 17 ef ff ff       	call   8004c0 <fd2num>
  8015a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015ac:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8015af:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b4:	eb 38                	jmp    8015ee <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8015b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015c1:	e8 5f ec ff ff       	call   800225 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8015c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015d4:	e8 4c ec ff ff       	call   800225 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8015d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015e7:	e8 39 ec ff ff       	call   800225 <sys_page_unmap>
  8015ec:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8015ee:	83 c4 30             	add    $0x30,%esp
  8015f1:	5b                   	pop    %ebx
  8015f2:	5e                   	pop    %esi
  8015f3:	5d                   	pop    %ebp
  8015f4:	c3                   	ret    

008015f5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801602:	8b 45 08             	mov    0x8(%ebp),%eax
  801605:	89 04 24             	mov    %eax,(%esp)
  801608:	e8 29 ef ff ff       	call   800536 <fd_lookup>
  80160d:	89 c2                	mov    %eax,%edx
  80160f:	85 d2                	test   %edx,%edx
  801611:	78 15                	js     801628 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801616:	89 04 24             	mov    %eax,(%esp)
  801619:	e8 b2 ee ff ff       	call   8004d0 <fd2data>
	return _pipeisclosed(fd, p);
  80161e:	89 c2                	mov    %eax,%edx
  801620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801623:	e8 0b fd ff ff       	call   801333 <_pipeisclosed>
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    
  80162a:	66 90                	xchg   %ax,%ax
  80162c:	66 90                	xchg   %ax,%ax
  80162e:	66 90                	xchg   %ax,%ax

00801630 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801633:	b8 00 00 00 00       	mov    $0x0,%eax
  801638:	5d                   	pop    %ebp
  801639:	c3                   	ret    

0080163a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801640:	c7 44 24 04 bf 27 80 	movl   $0x8027bf,0x4(%esp)
  801647:	00 
  801648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164b:	89 04 24             	mov    %eax,(%esp)
  80164e:	e8 a4 08 00 00       	call   801ef7 <strcpy>
	return 0;
}
  801653:	b8 00 00 00 00       	mov    $0x0,%eax
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	57                   	push   %edi
  80165e:	56                   	push   %esi
  80165f:	53                   	push   %ebx
  801660:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801666:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80166b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801671:	eb 31                	jmp    8016a4 <devcons_write+0x4a>
		m = n - tot;
  801673:	8b 75 10             	mov    0x10(%ebp),%esi
  801676:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  801678:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80167b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801680:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801683:	89 74 24 08          	mov    %esi,0x8(%esp)
  801687:	03 45 0c             	add    0xc(%ebp),%eax
  80168a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80168e:	89 3c 24             	mov    %edi,(%esp)
  801691:	e8 fe 09 00 00       	call   802094 <memmove>
		sys_cputs(buf, m);
  801696:	89 74 24 04          	mov    %esi,0x4(%esp)
  80169a:	89 3c 24             	mov    %edi,(%esp)
  80169d:	e8 0f ea ff ff       	call   8000b1 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8016a2:	01 f3                	add    %esi,%ebx
  8016a4:	89 d8                	mov    %ebx,%eax
  8016a6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8016a9:	72 c8                	jb     801673 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8016ab:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8016b1:	5b                   	pop    %ebx
  8016b2:	5e                   	pop    %esi
  8016b3:	5f                   	pop    %edi
  8016b4:	5d                   	pop    %ebp
  8016b5:	c3                   	ret    

008016b6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8016bc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8016c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016c5:	75 07                	jne    8016ce <devcons_read+0x18>
  8016c7:	eb 2a                	jmp    8016f3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8016c9:	e8 91 ea ff ff       	call   80015f <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8016ce:	66 90                	xchg   %ax,%ax
  8016d0:	e8 fa e9 ff ff       	call   8000cf <sys_cgetc>
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	74 f0                	je     8016c9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8016d9:	85 c0                	test   %eax,%eax
  8016db:	78 16                	js     8016f3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8016dd:	83 f8 04             	cmp    $0x4,%eax
  8016e0:	74 0c                	je     8016ee <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8016e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e5:	88 02                	mov    %al,(%edx)
	return 1;
  8016e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ec:	eb 05                	jmp    8016f3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8016ee:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801701:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801708:	00 
  801709:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80170c:	89 04 24             	mov    %eax,(%esp)
  80170f:	e8 9d e9 ff ff       	call   8000b1 <sys_cputs>
}
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <getchar>:

int
getchar(void)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80171c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801723:	00 
  801724:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801727:	89 44 24 04          	mov    %eax,0x4(%esp)
  80172b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801732:	e8 93 f0 ff ff       	call   8007ca <read>
	if (r < 0)
  801737:	85 c0                	test   %eax,%eax
  801739:	78 0f                	js     80174a <getchar+0x34>
		return r;
	if (r < 1)
  80173b:	85 c0                	test   %eax,%eax
  80173d:	7e 06                	jle    801745 <getchar+0x2f>
		return -E_EOF;
	return c;
  80173f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801743:	eb 05                	jmp    80174a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801745:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801752:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801755:	89 44 24 04          	mov    %eax,0x4(%esp)
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	89 04 24             	mov    %eax,(%esp)
  80175f:	e8 d2 ed ff ff       	call   800536 <fd_lookup>
  801764:	85 c0                	test   %eax,%eax
  801766:	78 11                	js     801779 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176b:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  801771:	39 10                	cmp    %edx,(%eax)
  801773:	0f 94 c0             	sete   %al
  801776:	0f b6 c0             	movzbl %al,%eax
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <opencons>:

int
opencons(void)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801781:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801784:	89 04 24             	mov    %eax,(%esp)
  801787:	e8 5b ed ff ff       	call   8004e7 <fd_alloc>
		return r;
  80178c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80178e:	85 c0                	test   %eax,%eax
  801790:	78 40                	js     8017d2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801792:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801799:	00 
  80179a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017a8:	e8 d1 e9 ff ff       	call   80017e <sys_page_alloc>
		return r;
  8017ad:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	78 1f                	js     8017d2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8017b3:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8017b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8017be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8017c8:	89 04 24             	mov    %eax,(%esp)
  8017cb:	e8 f0 ec ff ff       	call   8004c0 <fd2num>
  8017d0:	89 c2                	mov    %eax,%edx
}
  8017d2:	89 d0                	mov    %edx,%eax
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	56                   	push   %esi
  8017da:	53                   	push   %ebx
  8017db:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8017de:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8017e1:	8b 35 04 30 80 00    	mov    0x803004,%esi
  8017e7:	e8 54 e9 ff ff       	call   800140 <sys_getenvid>
  8017ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ef:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8017f6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8017fa:	89 74 24 08          	mov    %esi,0x8(%esp)
  8017fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801802:	c7 04 24 cc 27 80 00 	movl   $0x8027cc,(%esp)
  801809:	e8 c1 00 00 00       	call   8018cf <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80180e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801812:	8b 45 10             	mov    0x10(%ebp),%eax
  801815:	89 04 24             	mov    %eax,(%esp)
  801818:	e8 51 00 00 00       	call   80186e <vcprintf>
	cprintf("\n");
  80181d:	c7 04 24 b8 27 80 00 	movl   $0x8027b8,(%esp)
  801824:	e8 a6 00 00 00       	call   8018cf <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801829:	cc                   	int3   
  80182a:	eb fd                	jmp    801829 <_panic+0x53>

0080182c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	53                   	push   %ebx
  801830:	83 ec 14             	sub    $0x14,%esp
  801833:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801836:	8b 13                	mov    (%ebx),%edx
  801838:	8d 42 01             	lea    0x1(%edx),%eax
  80183b:	89 03                	mov    %eax,(%ebx)
  80183d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801840:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801844:	3d ff 00 00 00       	cmp    $0xff,%eax
  801849:	75 19                	jne    801864 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80184b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801852:	00 
  801853:	8d 43 08             	lea    0x8(%ebx),%eax
  801856:	89 04 24             	mov    %eax,(%esp)
  801859:	e8 53 e8 ff ff       	call   8000b1 <sys_cputs>
		b->idx = 0;
  80185e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801864:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801868:	83 c4 14             	add    $0x14,%esp
  80186b:	5b                   	pop    %ebx
  80186c:	5d                   	pop    %ebp
  80186d:	c3                   	ret    

0080186e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801877:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80187e:	00 00 00 
	b.cnt = 0;
  801881:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801888:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80188b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	89 44 24 08          	mov    %eax,0x8(%esp)
  801899:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80189f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a3:	c7 04 24 2c 18 80 00 	movl   $0x80182c,(%esp)
  8018aa:	e8 af 01 00 00       	call   801a5e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8018af:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8018b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8018bf:	89 04 24             	mov    %eax,(%esp)
  8018c2:	e8 ea e7 ff ff       	call   8000b1 <sys_cputs>

	return b.cnt;
}
  8018c7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
  8018d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8018d5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8018d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018df:	89 04 24             	mov    %eax,(%esp)
  8018e2:	e8 87 ff ff ff       	call   80186e <vcprintf>
	va_end(ap);

	return cnt;
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    
  8018e9:	66 90                	xchg   %ax,%ax
  8018eb:	66 90                	xchg   %ax,%ax
  8018ed:	66 90                	xchg   %ax,%ax
  8018ef:	90                   	nop

008018f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	57                   	push   %edi
  8018f4:	56                   	push   %esi
  8018f5:	53                   	push   %ebx
  8018f6:	83 ec 3c             	sub    $0x3c,%esp
  8018f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018fc:	89 d7                	mov    %edx,%edi
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801904:	8b 45 0c             	mov    0xc(%ebp),%eax
  801907:	89 c3                	mov    %eax,%ebx
  801909:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80190c:	8b 45 10             	mov    0x10(%ebp),%eax
  80190f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801912:	b9 00 00 00 00       	mov    $0x0,%ecx
  801917:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80191a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80191d:	39 d9                	cmp    %ebx,%ecx
  80191f:	72 05                	jb     801926 <printnum+0x36>
  801921:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801924:	77 69                	ja     80198f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801926:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801929:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80192d:	83 ee 01             	sub    $0x1,%esi
  801930:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801934:	89 44 24 08          	mov    %eax,0x8(%esp)
  801938:	8b 44 24 08          	mov    0x8(%esp),%eax
  80193c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801940:	89 c3                	mov    %eax,%ebx
  801942:	89 d6                	mov    %edx,%esi
  801944:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801947:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80194a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80194e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801952:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801955:	89 04 24             	mov    %eax,(%esp)
  801958:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80195b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195f:	e8 5c 0a 00 00       	call   8023c0 <__udivdi3>
  801964:	89 d9                	mov    %ebx,%ecx
  801966:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80196a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80196e:	89 04 24             	mov    %eax,(%esp)
  801971:	89 54 24 04          	mov    %edx,0x4(%esp)
  801975:	89 fa                	mov    %edi,%edx
  801977:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80197a:	e8 71 ff ff ff       	call   8018f0 <printnum>
  80197f:	eb 1b                	jmp    80199c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801981:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801985:	8b 45 18             	mov    0x18(%ebp),%eax
  801988:	89 04 24             	mov    %eax,(%esp)
  80198b:	ff d3                	call   *%ebx
  80198d:	eb 03                	jmp    801992 <printnum+0xa2>
  80198f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801992:	83 ee 01             	sub    $0x1,%esi
  801995:	85 f6                	test   %esi,%esi
  801997:	7f e8                	jg     801981 <printnum+0x91>
  801999:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80199c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019a0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8019a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8019aa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019ae:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8019b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019b5:	89 04 24             	mov    %eax,(%esp)
  8019b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019bf:	e8 2c 0b 00 00       	call   8024f0 <__umoddi3>
  8019c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019c8:	0f be 80 ef 27 80 00 	movsbl 0x8027ef(%eax),%eax
  8019cf:	89 04 24             	mov    %eax,(%esp)
  8019d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019d5:	ff d0                	call   *%eax
}
  8019d7:	83 c4 3c             	add    $0x3c,%esp
  8019da:	5b                   	pop    %ebx
  8019db:	5e                   	pop    %esi
  8019dc:	5f                   	pop    %edi
  8019dd:	5d                   	pop    %ebp
  8019de:	c3                   	ret    

008019df <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019e2:	83 fa 01             	cmp    $0x1,%edx
  8019e5:	7e 0e                	jle    8019f5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8019e7:	8b 10                	mov    (%eax),%edx
  8019e9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8019ec:	89 08                	mov    %ecx,(%eax)
  8019ee:	8b 02                	mov    (%edx),%eax
  8019f0:	8b 52 04             	mov    0x4(%edx),%edx
  8019f3:	eb 22                	jmp    801a17 <getuint+0x38>
	else if (lflag)
  8019f5:	85 d2                	test   %edx,%edx
  8019f7:	74 10                	je     801a09 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8019f9:	8b 10                	mov    (%eax),%edx
  8019fb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8019fe:	89 08                	mov    %ecx,(%eax)
  801a00:	8b 02                	mov    (%edx),%eax
  801a02:	ba 00 00 00 00       	mov    $0x0,%edx
  801a07:	eb 0e                	jmp    801a17 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801a09:	8b 10                	mov    (%eax),%edx
  801a0b:	8d 4a 04             	lea    0x4(%edx),%ecx
  801a0e:	89 08                	mov    %ecx,(%eax)
  801a10:	8b 02                	mov    (%edx),%eax
  801a12:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a17:	5d                   	pop    %ebp
  801a18:	c3                   	ret    

00801a19 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801a1f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801a23:	8b 10                	mov    (%eax),%edx
  801a25:	3b 50 04             	cmp    0x4(%eax),%edx
  801a28:	73 0a                	jae    801a34 <sprintputch+0x1b>
		*b->buf++ = ch;
  801a2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a2d:	89 08                	mov    %ecx,(%eax)
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	88 02                	mov    %al,(%edx)
}
  801a34:	5d                   	pop    %ebp
  801a35:	c3                   	ret    

00801a36 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801a3c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801a3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a43:	8b 45 10             	mov    0x10(%ebp),%eax
  801a46:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a51:	8b 45 08             	mov    0x8(%ebp),%eax
  801a54:	89 04 24             	mov    %eax,(%esp)
  801a57:	e8 02 00 00 00       	call   801a5e <vprintfmt>
	va_end(ap);
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	57                   	push   %edi
  801a62:	56                   	push   %esi
  801a63:	53                   	push   %ebx
  801a64:	83 ec 3c             	sub    $0x3c,%esp
  801a67:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801a6a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a6d:	eb 14                	jmp    801a83 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	0f 84 b3 03 00 00    	je     801e2a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  801a77:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a7b:	89 04 24             	mov    %eax,(%esp)
  801a7e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a81:	89 f3                	mov    %esi,%ebx
  801a83:	8d 73 01             	lea    0x1(%ebx),%esi
  801a86:	0f b6 03             	movzbl (%ebx),%eax
  801a89:	83 f8 25             	cmp    $0x25,%eax
  801a8c:	75 e1                	jne    801a6f <vprintfmt+0x11>
  801a8e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  801a92:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a99:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  801aa0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  801aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  801aac:	eb 1d                	jmp    801acb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801aae:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  801ab0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801ab4:	eb 15                	jmp    801acb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ab6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801ab8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801abc:	eb 0d                	jmp    801acb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801abe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ac1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ac4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801acb:	8d 5e 01             	lea    0x1(%esi),%ebx
  801ace:	0f b6 0e             	movzbl (%esi),%ecx
  801ad1:	0f b6 c1             	movzbl %cl,%eax
  801ad4:	83 e9 23             	sub    $0x23,%ecx
  801ad7:	80 f9 55             	cmp    $0x55,%cl
  801ada:	0f 87 2a 03 00 00    	ja     801e0a <vprintfmt+0x3ac>
  801ae0:	0f b6 c9             	movzbl %cl,%ecx
  801ae3:	ff 24 8d 40 29 80 00 	jmp    *0x802940(,%ecx,4)
  801aea:	89 de                	mov    %ebx,%esi
  801aec:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801af1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801af4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801af8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801afb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  801afe:	83 fb 09             	cmp    $0x9,%ebx
  801b01:	77 36                	ja     801b39 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801b03:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801b06:	eb e9                	jmp    801af1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801b08:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0b:	8d 48 04             	lea    0x4(%eax),%ecx
  801b0e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801b11:	8b 00                	mov    (%eax),%eax
  801b13:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b16:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801b18:	eb 22                	jmp    801b3c <vprintfmt+0xde>
  801b1a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801b1d:	85 c9                	test   %ecx,%ecx
  801b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b24:	0f 49 c1             	cmovns %ecx,%eax
  801b27:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b2a:	89 de                	mov    %ebx,%esi
  801b2c:	eb 9d                	jmp    801acb <vprintfmt+0x6d>
  801b2e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801b30:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  801b37:	eb 92                	jmp    801acb <vprintfmt+0x6d>
  801b39:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  801b3c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801b40:	79 89                	jns    801acb <vprintfmt+0x6d>
  801b42:	e9 77 ff ff ff       	jmp    801abe <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b47:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b4a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801b4c:	e9 7a ff ff ff       	jmp    801acb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b51:	8b 45 14             	mov    0x14(%ebp),%eax
  801b54:	8d 50 04             	lea    0x4(%eax),%edx
  801b57:	89 55 14             	mov    %edx,0x14(%ebp)
  801b5a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b5e:	8b 00                	mov    (%eax),%eax
  801b60:	89 04 24             	mov    %eax,(%esp)
  801b63:	ff 55 08             	call   *0x8(%ebp)
			break;
  801b66:	e9 18 ff ff ff       	jmp    801a83 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b6b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b6e:	8d 50 04             	lea    0x4(%eax),%edx
  801b71:	89 55 14             	mov    %edx,0x14(%ebp)
  801b74:	8b 00                	mov    (%eax),%eax
  801b76:	99                   	cltd   
  801b77:	31 d0                	xor    %edx,%eax
  801b79:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801b7b:	83 f8 11             	cmp    $0x11,%eax
  801b7e:	7f 0b                	jg     801b8b <vprintfmt+0x12d>
  801b80:	8b 14 85 a0 2a 80 00 	mov    0x802aa0(,%eax,4),%edx
  801b87:	85 d2                	test   %edx,%edx
  801b89:	75 20                	jne    801bab <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  801b8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b8f:	c7 44 24 08 07 28 80 	movl   $0x802807,0x8(%esp)
  801b96:	00 
  801b97:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	89 04 24             	mov    %eax,(%esp)
  801ba1:	e8 90 fe ff ff       	call   801a36 <printfmt>
  801ba6:	e9 d8 fe ff ff       	jmp    801a83 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  801bab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801baf:	c7 44 24 08 4d 27 80 	movl   $0x80274d,0x8(%esp)
  801bb6:	00 
  801bb7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	89 04 24             	mov    %eax,(%esp)
  801bc1:	e8 70 fe ff ff       	call   801a36 <printfmt>
  801bc6:	e9 b8 fe ff ff       	jmp    801a83 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801bcb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  801bce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bd1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801bd4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd7:	8d 50 04             	lea    0x4(%eax),%edx
  801bda:	89 55 14             	mov    %edx,0x14(%ebp)
  801bdd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  801bdf:	85 f6                	test   %esi,%esi
  801be1:	b8 00 28 80 00       	mov    $0x802800,%eax
  801be6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  801be9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  801bed:	0f 84 97 00 00 00    	je     801c8a <vprintfmt+0x22c>
  801bf3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801bf7:	0f 8e 9b 00 00 00    	jle    801c98 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  801bfd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c01:	89 34 24             	mov    %esi,(%esp)
  801c04:	e8 cf 02 00 00       	call   801ed8 <strnlen>
  801c09:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801c0c:	29 c2                	sub    %eax,%edx
  801c0e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  801c11:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  801c15:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c18:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801c1b:	8b 75 08             	mov    0x8(%ebp),%esi
  801c1e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801c21:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c23:	eb 0f                	jmp    801c34 <vprintfmt+0x1d6>
					putch(padc, putdat);
  801c25:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c29:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c2c:	89 04 24             	mov    %eax,(%esp)
  801c2f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c31:	83 eb 01             	sub    $0x1,%ebx
  801c34:	85 db                	test   %ebx,%ebx
  801c36:	7f ed                	jg     801c25 <vprintfmt+0x1c7>
  801c38:	8b 75 d8             	mov    -0x28(%ebp),%esi
  801c3b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801c3e:	85 d2                	test   %edx,%edx
  801c40:	b8 00 00 00 00       	mov    $0x0,%eax
  801c45:	0f 49 c2             	cmovns %edx,%eax
  801c48:	29 c2                	sub    %eax,%edx
  801c4a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801c4d:	89 d7                	mov    %edx,%edi
  801c4f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801c52:	eb 50                	jmp    801ca4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801c54:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c58:	74 1e                	je     801c78 <vprintfmt+0x21a>
  801c5a:	0f be d2             	movsbl %dl,%edx
  801c5d:	83 ea 20             	sub    $0x20,%edx
  801c60:	83 fa 5e             	cmp    $0x5e,%edx
  801c63:	76 13                	jbe    801c78 <vprintfmt+0x21a>
					putch('?', putdat);
  801c65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c6c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801c73:	ff 55 08             	call   *0x8(%ebp)
  801c76:	eb 0d                	jmp    801c85 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  801c78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7b:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c7f:	89 04 24             	mov    %eax,(%esp)
  801c82:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c85:	83 ef 01             	sub    $0x1,%edi
  801c88:	eb 1a                	jmp    801ca4 <vprintfmt+0x246>
  801c8a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801c8d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801c90:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801c93:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801c96:	eb 0c                	jmp    801ca4 <vprintfmt+0x246>
  801c98:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801c9b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801c9e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801ca1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801ca4:	83 c6 01             	add    $0x1,%esi
  801ca7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  801cab:	0f be c2             	movsbl %dl,%eax
  801cae:	85 c0                	test   %eax,%eax
  801cb0:	74 27                	je     801cd9 <vprintfmt+0x27b>
  801cb2:	85 db                	test   %ebx,%ebx
  801cb4:	78 9e                	js     801c54 <vprintfmt+0x1f6>
  801cb6:	83 eb 01             	sub    $0x1,%ebx
  801cb9:	79 99                	jns    801c54 <vprintfmt+0x1f6>
  801cbb:	89 f8                	mov    %edi,%eax
  801cbd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801cc0:	8b 75 08             	mov    0x8(%ebp),%esi
  801cc3:	89 c3                	mov    %eax,%ebx
  801cc5:	eb 1a                	jmp    801ce1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801cc7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ccb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801cd2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801cd4:	83 eb 01             	sub    $0x1,%ebx
  801cd7:	eb 08                	jmp    801ce1 <vprintfmt+0x283>
  801cd9:	89 fb                	mov    %edi,%ebx
  801cdb:	8b 75 08             	mov    0x8(%ebp),%esi
  801cde:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801ce1:	85 db                	test   %ebx,%ebx
  801ce3:	7f e2                	jg     801cc7 <vprintfmt+0x269>
  801ce5:	89 75 08             	mov    %esi,0x8(%ebp)
  801ce8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ceb:	e9 93 fd ff ff       	jmp    801a83 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801cf0:	83 fa 01             	cmp    $0x1,%edx
  801cf3:	7e 16                	jle    801d0b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  801cf5:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf8:	8d 50 08             	lea    0x8(%eax),%edx
  801cfb:	89 55 14             	mov    %edx,0x14(%ebp)
  801cfe:	8b 50 04             	mov    0x4(%eax),%edx
  801d01:	8b 00                	mov    (%eax),%eax
  801d03:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d06:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801d09:	eb 32                	jmp    801d3d <vprintfmt+0x2df>
	else if (lflag)
  801d0b:	85 d2                	test   %edx,%edx
  801d0d:	74 18                	je     801d27 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  801d0f:	8b 45 14             	mov    0x14(%ebp),%eax
  801d12:	8d 50 04             	lea    0x4(%eax),%edx
  801d15:	89 55 14             	mov    %edx,0x14(%ebp)
  801d18:	8b 30                	mov    (%eax),%esi
  801d1a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801d1d:	89 f0                	mov    %esi,%eax
  801d1f:	c1 f8 1f             	sar    $0x1f,%eax
  801d22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d25:	eb 16                	jmp    801d3d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  801d27:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2a:	8d 50 04             	lea    0x4(%eax),%edx
  801d2d:	89 55 14             	mov    %edx,0x14(%ebp)
  801d30:	8b 30                	mov    (%eax),%esi
  801d32:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801d35:	89 f0                	mov    %esi,%eax
  801d37:	c1 f8 1f             	sar    $0x1f,%eax
  801d3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801d3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801d43:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801d48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d4c:	0f 89 80 00 00 00    	jns    801dd2 <vprintfmt+0x374>
				putch('-', putdat);
  801d52:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d56:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801d5d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801d60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d63:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d66:	f7 d8                	neg    %eax
  801d68:	83 d2 00             	adc    $0x0,%edx
  801d6b:	f7 da                	neg    %edx
			}
			base = 10;
  801d6d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d72:	eb 5e                	jmp    801dd2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801d74:	8d 45 14             	lea    0x14(%ebp),%eax
  801d77:	e8 63 fc ff ff       	call   8019df <getuint>
			base = 10;
  801d7c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801d81:	eb 4f                	jmp    801dd2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  801d83:	8d 45 14             	lea    0x14(%ebp),%eax
  801d86:	e8 54 fc ff ff       	call   8019df <getuint>
			base = 8;
  801d8b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801d90:	eb 40                	jmp    801dd2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  801d92:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d96:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801d9d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801da0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801da4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801dab:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801dae:	8b 45 14             	mov    0x14(%ebp),%eax
  801db1:	8d 50 04             	lea    0x4(%eax),%edx
  801db4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801db7:	8b 00                	mov    (%eax),%eax
  801db9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801dbe:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801dc3:	eb 0d                	jmp    801dd2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801dc5:	8d 45 14             	lea    0x14(%ebp),%eax
  801dc8:	e8 12 fc ff ff       	call   8019df <getuint>
			base = 16;
  801dcd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801dd2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  801dd6:	89 74 24 10          	mov    %esi,0x10(%esp)
  801dda:	8b 75 dc             	mov    -0x24(%ebp),%esi
  801ddd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801de1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801de5:	89 04 24             	mov    %eax,(%esp)
  801de8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dec:	89 fa                	mov    %edi,%edx
  801dee:	8b 45 08             	mov    0x8(%ebp),%eax
  801df1:	e8 fa fa ff ff       	call   8018f0 <printnum>
			break;
  801df6:	e9 88 fc ff ff       	jmp    801a83 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801dfb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801dff:	89 04 24             	mov    %eax,(%esp)
  801e02:	ff 55 08             	call   *0x8(%ebp)
			break;
  801e05:	e9 79 fc ff ff       	jmp    801a83 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801e0a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e0e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801e15:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e18:	89 f3                	mov    %esi,%ebx
  801e1a:	eb 03                	jmp    801e1f <vprintfmt+0x3c1>
  801e1c:	83 eb 01             	sub    $0x1,%ebx
  801e1f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801e23:	75 f7                	jne    801e1c <vprintfmt+0x3be>
  801e25:	e9 59 fc ff ff       	jmp    801a83 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  801e2a:	83 c4 3c             	add    $0x3c,%esp
  801e2d:	5b                   	pop    %ebx
  801e2e:	5e                   	pop    %esi
  801e2f:	5f                   	pop    %edi
  801e30:	5d                   	pop    %ebp
  801e31:	c3                   	ret    

00801e32 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 28             	sub    $0x28,%esp
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e41:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801e45:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801e48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	74 30                	je     801e83 <vsnprintf+0x51>
  801e53:	85 d2                	test   %edx,%edx
  801e55:	7e 2c                	jle    801e83 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801e57:	8b 45 14             	mov    0x14(%ebp),%eax
  801e5a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e5e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e61:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e65:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801e68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e6c:	c7 04 24 19 1a 80 00 	movl   $0x801a19,(%esp)
  801e73:	e8 e6 fb ff ff       	call   801a5e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801e78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e7b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e81:	eb 05                	jmp    801e88 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801e83:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    

00801e8a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801e90:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801e93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e97:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea8:	89 04 24             	mov    %eax,(%esp)
  801eab:	e8 82 ff ff ff       	call   801e32 <vsnprintf>
	va_end(ap);

	return rc;
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    
  801eb2:	66 90                	xchg   %ax,%ax
  801eb4:	66 90                	xchg   %ax,%ax
  801eb6:	66 90                	xchg   %ax,%ax
  801eb8:	66 90                	xchg   %ax,%ax
  801eba:	66 90                	xchg   %ax,%ax
  801ebc:	66 90                	xchg   %ax,%ax
  801ebe:	66 90                	xchg   %ax,%ax

00801ec0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801ec6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecb:	eb 03                	jmp    801ed0 <strlen+0x10>
		n++;
  801ecd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801ed0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801ed4:	75 f7                	jne    801ecd <strlen+0xd>
		n++;
	return n;
}
  801ed6:	5d                   	pop    %ebp
  801ed7:	c3                   	ret    

00801ed8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ede:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801ee1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee6:	eb 03                	jmp    801eeb <strnlen+0x13>
		n++;
  801ee8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801eeb:	39 d0                	cmp    %edx,%eax
  801eed:	74 06                	je     801ef5 <strnlen+0x1d>
  801eef:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801ef3:	75 f3                	jne    801ee8 <strnlen+0x10>
		n++;
	return n;
}
  801ef5:	5d                   	pop    %ebp
  801ef6:	c3                   	ret    

00801ef7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	53                   	push   %ebx
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801f01:	89 c2                	mov    %eax,%edx
  801f03:	83 c2 01             	add    $0x1,%edx
  801f06:	83 c1 01             	add    $0x1,%ecx
  801f09:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801f0d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801f10:	84 db                	test   %bl,%bl
  801f12:	75 ef                	jne    801f03 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801f14:	5b                   	pop    %ebx
  801f15:	5d                   	pop    %ebp
  801f16:	c3                   	ret    

00801f17 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	53                   	push   %ebx
  801f1b:	83 ec 08             	sub    $0x8,%esp
  801f1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801f21:	89 1c 24             	mov    %ebx,(%esp)
  801f24:	e8 97 ff ff ff       	call   801ec0 <strlen>
	strcpy(dst + len, src);
  801f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f30:	01 d8                	add    %ebx,%eax
  801f32:	89 04 24             	mov    %eax,(%esp)
  801f35:	e8 bd ff ff ff       	call   801ef7 <strcpy>
	return dst;
}
  801f3a:	89 d8                	mov    %ebx,%eax
  801f3c:	83 c4 08             	add    $0x8,%esp
  801f3f:	5b                   	pop    %ebx
  801f40:	5d                   	pop    %ebp
  801f41:	c3                   	ret    

00801f42 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	56                   	push   %esi
  801f46:	53                   	push   %ebx
  801f47:	8b 75 08             	mov    0x8(%ebp),%esi
  801f4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f4d:	89 f3                	mov    %esi,%ebx
  801f4f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801f52:	89 f2                	mov    %esi,%edx
  801f54:	eb 0f                	jmp    801f65 <strncpy+0x23>
		*dst++ = *src;
  801f56:	83 c2 01             	add    $0x1,%edx
  801f59:	0f b6 01             	movzbl (%ecx),%eax
  801f5c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801f5f:	80 39 01             	cmpb   $0x1,(%ecx)
  801f62:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801f65:	39 da                	cmp    %ebx,%edx
  801f67:	75 ed                	jne    801f56 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801f69:	89 f0                	mov    %esi,%eax
  801f6b:	5b                   	pop    %ebx
  801f6c:	5e                   	pop    %esi
  801f6d:	5d                   	pop    %ebp
  801f6e:	c3                   	ret    

00801f6f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	56                   	push   %esi
  801f73:	53                   	push   %ebx
  801f74:	8b 75 08             	mov    0x8(%ebp),%esi
  801f77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f7d:	89 f0                	mov    %esi,%eax
  801f7f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801f83:	85 c9                	test   %ecx,%ecx
  801f85:	75 0b                	jne    801f92 <strlcpy+0x23>
  801f87:	eb 1d                	jmp    801fa6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801f89:	83 c0 01             	add    $0x1,%eax
  801f8c:	83 c2 01             	add    $0x1,%edx
  801f8f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801f92:	39 d8                	cmp    %ebx,%eax
  801f94:	74 0b                	je     801fa1 <strlcpy+0x32>
  801f96:	0f b6 0a             	movzbl (%edx),%ecx
  801f99:	84 c9                	test   %cl,%cl
  801f9b:	75 ec                	jne    801f89 <strlcpy+0x1a>
  801f9d:	89 c2                	mov    %eax,%edx
  801f9f:	eb 02                	jmp    801fa3 <strlcpy+0x34>
  801fa1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  801fa3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  801fa6:	29 f0                	sub    %esi,%eax
}
  801fa8:	5b                   	pop    %ebx
  801fa9:	5e                   	pop    %esi
  801faa:	5d                   	pop    %ebp
  801fab:	c3                   	ret    

00801fac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fb2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801fb5:	eb 06                	jmp    801fbd <strcmp+0x11>
		p++, q++;
  801fb7:	83 c1 01             	add    $0x1,%ecx
  801fba:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801fbd:	0f b6 01             	movzbl (%ecx),%eax
  801fc0:	84 c0                	test   %al,%al
  801fc2:	74 04                	je     801fc8 <strcmp+0x1c>
  801fc4:	3a 02                	cmp    (%edx),%al
  801fc6:	74 ef                	je     801fb7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801fc8:	0f b6 c0             	movzbl %al,%eax
  801fcb:	0f b6 12             	movzbl (%edx),%edx
  801fce:	29 d0                	sub    %edx,%eax
}
  801fd0:	5d                   	pop    %ebp
  801fd1:	c3                   	ret    

00801fd2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	53                   	push   %ebx
  801fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdc:	89 c3                	mov    %eax,%ebx
  801fde:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801fe1:	eb 06                	jmp    801fe9 <strncmp+0x17>
		n--, p++, q++;
  801fe3:	83 c0 01             	add    $0x1,%eax
  801fe6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801fe9:	39 d8                	cmp    %ebx,%eax
  801feb:	74 15                	je     802002 <strncmp+0x30>
  801fed:	0f b6 08             	movzbl (%eax),%ecx
  801ff0:	84 c9                	test   %cl,%cl
  801ff2:	74 04                	je     801ff8 <strncmp+0x26>
  801ff4:	3a 0a                	cmp    (%edx),%cl
  801ff6:	74 eb                	je     801fe3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801ff8:	0f b6 00             	movzbl (%eax),%eax
  801ffb:	0f b6 12             	movzbl (%edx),%edx
  801ffe:	29 d0                	sub    %edx,%eax
  802000:	eb 05                	jmp    802007 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  802002:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  802007:	5b                   	pop    %ebx
  802008:	5d                   	pop    %ebp
  802009:	c3                   	ret    

0080200a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80200a:	55                   	push   %ebp
  80200b:	89 e5                	mov    %esp,%ebp
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802014:	eb 07                	jmp    80201d <strchr+0x13>
		if (*s == c)
  802016:	38 ca                	cmp    %cl,%dl
  802018:	74 0f                	je     802029 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80201a:	83 c0 01             	add    $0x1,%eax
  80201d:	0f b6 10             	movzbl (%eax),%edx
  802020:	84 d2                	test   %dl,%dl
  802022:	75 f2                	jne    802016 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  802024:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802029:	5d                   	pop    %ebp
  80202a:	c3                   	ret    

0080202b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802035:	eb 07                	jmp    80203e <strfind+0x13>
		if (*s == c)
  802037:	38 ca                	cmp    %cl,%dl
  802039:	74 0a                	je     802045 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80203b:	83 c0 01             	add    $0x1,%eax
  80203e:	0f b6 10             	movzbl (%eax),%edx
  802041:	84 d2                	test   %dl,%dl
  802043:	75 f2                	jne    802037 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  802045:	5d                   	pop    %ebp
  802046:	c3                   	ret    

00802047 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
  80204a:	57                   	push   %edi
  80204b:	56                   	push   %esi
  80204c:	53                   	push   %ebx
  80204d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802050:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802053:	85 c9                	test   %ecx,%ecx
  802055:	74 36                	je     80208d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802057:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80205d:	75 28                	jne    802087 <memset+0x40>
  80205f:	f6 c1 03             	test   $0x3,%cl
  802062:	75 23                	jne    802087 <memset+0x40>
		c &= 0xFF;
  802064:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802068:	89 d3                	mov    %edx,%ebx
  80206a:	c1 e3 08             	shl    $0x8,%ebx
  80206d:	89 d6                	mov    %edx,%esi
  80206f:	c1 e6 18             	shl    $0x18,%esi
  802072:	89 d0                	mov    %edx,%eax
  802074:	c1 e0 10             	shl    $0x10,%eax
  802077:	09 f0                	or     %esi,%eax
  802079:	09 c2                	or     %eax,%edx
  80207b:	89 d0                	mov    %edx,%eax
  80207d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80207f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802082:	fc                   	cld    
  802083:	f3 ab                	rep stos %eax,%es:(%edi)
  802085:	eb 06                	jmp    80208d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208a:	fc                   	cld    
  80208b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80208d:	89 f8                	mov    %edi,%eax
  80208f:	5b                   	pop    %ebx
  802090:	5e                   	pop    %esi
  802091:	5f                   	pop    %edi
  802092:	5d                   	pop    %ebp
  802093:	c3                   	ret    

00802094 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	57                   	push   %edi
  802098:	56                   	push   %esi
  802099:	8b 45 08             	mov    0x8(%ebp),%eax
  80209c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80209f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8020a2:	39 c6                	cmp    %eax,%esi
  8020a4:	73 35                	jae    8020db <memmove+0x47>
  8020a6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8020a9:	39 d0                	cmp    %edx,%eax
  8020ab:	73 2e                	jae    8020db <memmove+0x47>
		s += n;
		d += n;
  8020ad:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8020b0:	89 d6                	mov    %edx,%esi
  8020b2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8020b4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8020ba:	75 13                	jne    8020cf <memmove+0x3b>
  8020bc:	f6 c1 03             	test   $0x3,%cl
  8020bf:	75 0e                	jne    8020cf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8020c1:	83 ef 04             	sub    $0x4,%edi
  8020c4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8020c7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8020ca:	fd                   	std    
  8020cb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8020cd:	eb 09                	jmp    8020d8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8020cf:	83 ef 01             	sub    $0x1,%edi
  8020d2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8020d5:	fd                   	std    
  8020d6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8020d8:	fc                   	cld    
  8020d9:	eb 1d                	jmp    8020f8 <memmove+0x64>
  8020db:	89 f2                	mov    %esi,%edx
  8020dd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8020df:	f6 c2 03             	test   $0x3,%dl
  8020e2:	75 0f                	jne    8020f3 <memmove+0x5f>
  8020e4:	f6 c1 03             	test   $0x3,%cl
  8020e7:	75 0a                	jne    8020f3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8020e9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8020ec:	89 c7                	mov    %eax,%edi
  8020ee:	fc                   	cld    
  8020ef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8020f1:	eb 05                	jmp    8020f8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8020f3:	89 c7                	mov    %eax,%edi
  8020f5:	fc                   	cld    
  8020f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8020f8:	5e                   	pop    %esi
  8020f9:	5f                   	pop    %edi
  8020fa:	5d                   	pop    %ebp
  8020fb:	c3                   	ret    

008020fc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
  8020ff:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  802102:	8b 45 10             	mov    0x10(%ebp),%eax
  802105:	89 44 24 08          	mov    %eax,0x8(%esp)
  802109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	89 04 24             	mov    %eax,(%esp)
  802116:	e8 79 ff ff ff       	call   802094 <memmove>
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
  802120:	56                   	push   %esi
  802121:	53                   	push   %ebx
  802122:	8b 55 08             	mov    0x8(%ebp),%edx
  802125:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802128:	89 d6                	mov    %edx,%esi
  80212a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80212d:	eb 1a                	jmp    802149 <memcmp+0x2c>
		if (*s1 != *s2)
  80212f:	0f b6 02             	movzbl (%edx),%eax
  802132:	0f b6 19             	movzbl (%ecx),%ebx
  802135:	38 d8                	cmp    %bl,%al
  802137:	74 0a                	je     802143 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  802139:	0f b6 c0             	movzbl %al,%eax
  80213c:	0f b6 db             	movzbl %bl,%ebx
  80213f:	29 d8                	sub    %ebx,%eax
  802141:	eb 0f                	jmp    802152 <memcmp+0x35>
		s1++, s2++;
  802143:	83 c2 01             	add    $0x1,%edx
  802146:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802149:	39 f2                	cmp    %esi,%edx
  80214b:	75 e2                	jne    80212f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80214d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802152:	5b                   	pop    %ebx
  802153:	5e                   	pop    %esi
  802154:	5d                   	pop    %ebp
  802155:	c3                   	ret    

00802156 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80215f:	89 c2                	mov    %eax,%edx
  802161:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802164:	eb 07                	jmp    80216d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  802166:	38 08                	cmp    %cl,(%eax)
  802168:	74 07                	je     802171 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80216a:	83 c0 01             	add    $0x1,%eax
  80216d:	39 d0                	cmp    %edx,%eax
  80216f:	72 f5                	jb     802166 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802171:	5d                   	pop    %ebp
  802172:	c3                   	ret    

00802173 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
  802176:	57                   	push   %edi
  802177:	56                   	push   %esi
  802178:	53                   	push   %ebx
  802179:	8b 55 08             	mov    0x8(%ebp),%edx
  80217c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80217f:	eb 03                	jmp    802184 <strtol+0x11>
		s++;
  802181:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802184:	0f b6 0a             	movzbl (%edx),%ecx
  802187:	80 f9 09             	cmp    $0x9,%cl
  80218a:	74 f5                	je     802181 <strtol+0xe>
  80218c:	80 f9 20             	cmp    $0x20,%cl
  80218f:	74 f0                	je     802181 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  802191:	80 f9 2b             	cmp    $0x2b,%cl
  802194:	75 0a                	jne    8021a0 <strtol+0x2d>
		s++;
  802196:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  802199:	bf 00 00 00 00       	mov    $0x0,%edi
  80219e:	eb 11                	jmp    8021b1 <strtol+0x3e>
  8021a0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8021a5:	80 f9 2d             	cmp    $0x2d,%cl
  8021a8:	75 07                	jne    8021b1 <strtol+0x3e>
		s++, neg = 1;
  8021aa:	8d 52 01             	lea    0x1(%edx),%edx
  8021ad:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8021b1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  8021b6:	75 15                	jne    8021cd <strtol+0x5a>
  8021b8:	80 3a 30             	cmpb   $0x30,(%edx)
  8021bb:	75 10                	jne    8021cd <strtol+0x5a>
  8021bd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8021c1:	75 0a                	jne    8021cd <strtol+0x5a>
		s += 2, base = 16;
  8021c3:	83 c2 02             	add    $0x2,%edx
  8021c6:	b8 10 00 00 00       	mov    $0x10,%eax
  8021cb:	eb 10                	jmp    8021dd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	75 0c                	jne    8021dd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8021d1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8021d3:	80 3a 30             	cmpb   $0x30,(%edx)
  8021d6:	75 05                	jne    8021dd <strtol+0x6a>
		s++, base = 8;
  8021d8:	83 c2 01             	add    $0x1,%edx
  8021db:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8021dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021e2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8021e5:	0f b6 0a             	movzbl (%edx),%ecx
  8021e8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8021eb:	89 f0                	mov    %esi,%eax
  8021ed:	3c 09                	cmp    $0x9,%al
  8021ef:	77 08                	ja     8021f9 <strtol+0x86>
			dig = *s - '0';
  8021f1:	0f be c9             	movsbl %cl,%ecx
  8021f4:	83 e9 30             	sub    $0x30,%ecx
  8021f7:	eb 20                	jmp    802219 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  8021f9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  8021fc:	89 f0                	mov    %esi,%eax
  8021fe:	3c 19                	cmp    $0x19,%al
  802200:	77 08                	ja     80220a <strtol+0x97>
			dig = *s - 'a' + 10;
  802202:	0f be c9             	movsbl %cl,%ecx
  802205:	83 e9 57             	sub    $0x57,%ecx
  802208:	eb 0f                	jmp    802219 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80220a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80220d:	89 f0                	mov    %esi,%eax
  80220f:	3c 19                	cmp    $0x19,%al
  802211:	77 16                	ja     802229 <strtol+0xb6>
			dig = *s - 'A' + 10;
  802213:	0f be c9             	movsbl %cl,%ecx
  802216:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  802219:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80221c:	7d 0f                	jge    80222d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80221e:	83 c2 01             	add    $0x1,%edx
  802221:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  802225:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  802227:	eb bc                	jmp    8021e5 <strtol+0x72>
  802229:	89 d8                	mov    %ebx,%eax
  80222b:	eb 02                	jmp    80222f <strtol+0xbc>
  80222d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80222f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802233:	74 05                	je     80223a <strtol+0xc7>
		*endptr = (char *) s;
  802235:	8b 75 0c             	mov    0xc(%ebp),%esi
  802238:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80223a:	f7 d8                	neg    %eax
  80223c:	85 ff                	test   %edi,%edi
  80223e:	0f 44 c3             	cmove  %ebx,%eax
}
  802241:	5b                   	pop    %ebx
  802242:	5e                   	pop    %esi
  802243:	5f                   	pop    %edi
  802244:	5d                   	pop    %ebp
  802245:	c3                   	ret    
  802246:	66 90                	xchg   %ax,%ax
  802248:	66 90                	xchg   %ax,%ax
  80224a:	66 90                	xchg   %ax,%ax
  80224c:	66 90                	xchg   %ax,%ax
  80224e:	66 90                	xchg   %ax,%ax

00802250 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	56                   	push   %esi
  802254:	53                   	push   %ebx
  802255:	83 ec 10             	sub    $0x10,%esp
  802258:	8b 75 08             	mov    0x8(%ebp),%esi
  80225b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802261:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802263:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802268:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80226b:	89 04 24             	mov    %eax,(%esp)
  80226e:	e8 21 e1 ff ff       	call   800394 <sys_ipc_recv>
  802273:	85 c0                	test   %eax,%eax
  802275:	74 16                	je     80228d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802277:	85 f6                	test   %esi,%esi
  802279:	74 06                	je     802281 <ipc_recv+0x31>
			*from_env_store = 0;
  80227b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802281:	85 db                	test   %ebx,%ebx
  802283:	74 2c                	je     8022b1 <ipc_recv+0x61>
			*perm_store = 0;
  802285:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80228b:	eb 24                	jmp    8022b1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  80228d:	85 f6                	test   %esi,%esi
  80228f:	74 0a                	je     80229b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802291:	a1 08 40 80 00       	mov    0x804008,%eax
  802296:	8b 40 74             	mov    0x74(%eax),%eax
  802299:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80229b:	85 db                	test   %ebx,%ebx
  80229d:	74 0a                	je     8022a9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80229f:	a1 08 40 80 00       	mov    0x804008,%eax
  8022a4:	8b 40 78             	mov    0x78(%eax),%eax
  8022a7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8022a9:	a1 08 40 80 00       	mov    0x804008,%eax
  8022ae:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022b1:	83 c4 10             	add    $0x10,%esp
  8022b4:	5b                   	pop    %ebx
  8022b5:	5e                   	pop    %esi
  8022b6:	5d                   	pop    %ebp
  8022b7:	c3                   	ret    

008022b8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	57                   	push   %edi
  8022bc:	56                   	push   %esi
  8022bd:	53                   	push   %ebx
  8022be:	83 ec 1c             	sub    $0x1c,%esp
  8022c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022c4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022c7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  8022ca:	85 db                	test   %ebx,%ebx
  8022cc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8022d1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  8022d4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	89 04 24             	mov    %eax,(%esp)
  8022e6:	e8 86 e0 ff ff       	call   800371 <sys_ipc_try_send>
	if (r == 0) return;
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	75 22                	jne    802311 <ipc_send+0x59>
  8022ef:	eb 4c                	jmp    80233d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  8022f1:	84 d2                	test   %dl,%dl
  8022f3:	75 48                	jne    80233d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  8022f5:	e8 65 de ff ff       	call   80015f <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  8022fa:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022fe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802302:	89 74 24 04          	mov    %esi,0x4(%esp)
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	89 04 24             	mov    %eax,(%esp)
  80230c:	e8 60 e0 ff ff       	call   800371 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802311:	85 c0                	test   %eax,%eax
  802313:	0f 94 c2             	sete   %dl
  802316:	74 d9                	je     8022f1 <ipc_send+0x39>
  802318:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80231b:	74 d4                	je     8022f1 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80231d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802321:	c7 44 24 08 08 2b 80 	movl   $0x802b08,0x8(%esp)
  802328:	00 
  802329:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802330:	00 
  802331:	c7 04 24 16 2b 80 00 	movl   $0x802b16,(%esp)
  802338:	e8 99 f4 ff ff       	call   8017d6 <_panic>
}
  80233d:	83 c4 1c             	add    $0x1c,%esp
  802340:	5b                   	pop    %ebx
  802341:	5e                   	pop    %esi
  802342:	5f                   	pop    %edi
  802343:	5d                   	pop    %ebp
  802344:	c3                   	ret    

00802345 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80234b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802350:	89 c2                	mov    %eax,%edx
  802352:	c1 e2 07             	shl    $0x7,%edx
  802355:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80235b:	8b 52 50             	mov    0x50(%edx),%edx
  80235e:	39 ca                	cmp    %ecx,%edx
  802360:	75 0d                	jne    80236f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802362:	c1 e0 07             	shl    $0x7,%eax
  802365:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80236a:	8b 40 40             	mov    0x40(%eax),%eax
  80236d:	eb 0e                	jmp    80237d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80236f:	83 c0 01             	add    $0x1,%eax
  802372:	3d 00 04 00 00       	cmp    $0x400,%eax
  802377:	75 d7                	jne    802350 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802379:	66 b8 00 00          	mov    $0x0,%ax
}
  80237d:	5d                   	pop    %ebp
  80237e:	c3                   	ret    

0080237f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
  802382:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802385:	89 d0                	mov    %edx,%eax
  802387:	c1 e8 16             	shr    $0x16,%eax
  80238a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802391:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802396:	f6 c1 01             	test   $0x1,%cl
  802399:	74 1d                	je     8023b8 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80239b:	c1 ea 0c             	shr    $0xc,%edx
  80239e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023a5:	f6 c2 01             	test   $0x1,%dl
  8023a8:	74 0e                	je     8023b8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023aa:	c1 ea 0c             	shr    $0xc,%edx
  8023ad:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023b4:	ef 
  8023b5:	0f b7 c0             	movzwl %ax,%eax
}
  8023b8:	5d                   	pop    %ebp
  8023b9:	c3                   	ret    
  8023ba:	66 90                	xchg   %ax,%ax
  8023bc:	66 90                	xchg   %ax,%ax
  8023be:	66 90                	xchg   %ax,%ax

008023c0 <__udivdi3>:
  8023c0:	55                   	push   %ebp
  8023c1:	57                   	push   %edi
  8023c2:	56                   	push   %esi
  8023c3:	83 ec 0c             	sub    $0xc,%esp
  8023c6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8023ca:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8023ce:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8023d2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8023d6:	85 c0                	test   %eax,%eax
  8023d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8023dc:	89 ea                	mov    %ebp,%edx
  8023de:	89 0c 24             	mov    %ecx,(%esp)
  8023e1:	75 2d                	jne    802410 <__udivdi3+0x50>
  8023e3:	39 e9                	cmp    %ebp,%ecx
  8023e5:	77 61                	ja     802448 <__udivdi3+0x88>
  8023e7:	85 c9                	test   %ecx,%ecx
  8023e9:	89 ce                	mov    %ecx,%esi
  8023eb:	75 0b                	jne    8023f8 <__udivdi3+0x38>
  8023ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f2:	31 d2                	xor    %edx,%edx
  8023f4:	f7 f1                	div    %ecx
  8023f6:	89 c6                	mov    %eax,%esi
  8023f8:	31 d2                	xor    %edx,%edx
  8023fa:	89 e8                	mov    %ebp,%eax
  8023fc:	f7 f6                	div    %esi
  8023fe:	89 c5                	mov    %eax,%ebp
  802400:	89 f8                	mov    %edi,%eax
  802402:	f7 f6                	div    %esi
  802404:	89 ea                	mov    %ebp,%edx
  802406:	83 c4 0c             	add    $0xc,%esp
  802409:	5e                   	pop    %esi
  80240a:	5f                   	pop    %edi
  80240b:	5d                   	pop    %ebp
  80240c:	c3                   	ret    
  80240d:	8d 76 00             	lea    0x0(%esi),%esi
  802410:	39 e8                	cmp    %ebp,%eax
  802412:	77 24                	ja     802438 <__udivdi3+0x78>
  802414:	0f bd e8             	bsr    %eax,%ebp
  802417:	83 f5 1f             	xor    $0x1f,%ebp
  80241a:	75 3c                	jne    802458 <__udivdi3+0x98>
  80241c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802420:	39 34 24             	cmp    %esi,(%esp)
  802423:	0f 86 9f 00 00 00    	jbe    8024c8 <__udivdi3+0x108>
  802429:	39 d0                	cmp    %edx,%eax
  80242b:	0f 82 97 00 00 00    	jb     8024c8 <__udivdi3+0x108>
  802431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802438:	31 d2                	xor    %edx,%edx
  80243a:	31 c0                	xor    %eax,%eax
  80243c:	83 c4 0c             	add    $0xc,%esp
  80243f:	5e                   	pop    %esi
  802440:	5f                   	pop    %edi
  802441:	5d                   	pop    %ebp
  802442:	c3                   	ret    
  802443:	90                   	nop
  802444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802448:	89 f8                	mov    %edi,%eax
  80244a:	f7 f1                	div    %ecx
  80244c:	31 d2                	xor    %edx,%edx
  80244e:	83 c4 0c             	add    $0xc,%esp
  802451:	5e                   	pop    %esi
  802452:	5f                   	pop    %edi
  802453:	5d                   	pop    %ebp
  802454:	c3                   	ret    
  802455:	8d 76 00             	lea    0x0(%esi),%esi
  802458:	89 e9                	mov    %ebp,%ecx
  80245a:	8b 3c 24             	mov    (%esp),%edi
  80245d:	d3 e0                	shl    %cl,%eax
  80245f:	89 c6                	mov    %eax,%esi
  802461:	b8 20 00 00 00       	mov    $0x20,%eax
  802466:	29 e8                	sub    %ebp,%eax
  802468:	89 c1                	mov    %eax,%ecx
  80246a:	d3 ef                	shr    %cl,%edi
  80246c:	89 e9                	mov    %ebp,%ecx
  80246e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802472:	8b 3c 24             	mov    (%esp),%edi
  802475:	09 74 24 08          	or     %esi,0x8(%esp)
  802479:	89 d6                	mov    %edx,%esi
  80247b:	d3 e7                	shl    %cl,%edi
  80247d:	89 c1                	mov    %eax,%ecx
  80247f:	89 3c 24             	mov    %edi,(%esp)
  802482:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802486:	d3 ee                	shr    %cl,%esi
  802488:	89 e9                	mov    %ebp,%ecx
  80248a:	d3 e2                	shl    %cl,%edx
  80248c:	89 c1                	mov    %eax,%ecx
  80248e:	d3 ef                	shr    %cl,%edi
  802490:	09 d7                	or     %edx,%edi
  802492:	89 f2                	mov    %esi,%edx
  802494:	89 f8                	mov    %edi,%eax
  802496:	f7 74 24 08          	divl   0x8(%esp)
  80249a:	89 d6                	mov    %edx,%esi
  80249c:	89 c7                	mov    %eax,%edi
  80249e:	f7 24 24             	mull   (%esp)
  8024a1:	39 d6                	cmp    %edx,%esi
  8024a3:	89 14 24             	mov    %edx,(%esp)
  8024a6:	72 30                	jb     8024d8 <__udivdi3+0x118>
  8024a8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024ac:	89 e9                	mov    %ebp,%ecx
  8024ae:	d3 e2                	shl    %cl,%edx
  8024b0:	39 c2                	cmp    %eax,%edx
  8024b2:	73 05                	jae    8024b9 <__udivdi3+0xf9>
  8024b4:	3b 34 24             	cmp    (%esp),%esi
  8024b7:	74 1f                	je     8024d8 <__udivdi3+0x118>
  8024b9:	89 f8                	mov    %edi,%eax
  8024bb:	31 d2                	xor    %edx,%edx
  8024bd:	e9 7a ff ff ff       	jmp    80243c <__udivdi3+0x7c>
  8024c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024c8:	31 d2                	xor    %edx,%edx
  8024ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8024cf:	e9 68 ff ff ff       	jmp    80243c <__udivdi3+0x7c>
  8024d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024d8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8024db:	31 d2                	xor    %edx,%edx
  8024dd:	83 c4 0c             	add    $0xc,%esp
  8024e0:	5e                   	pop    %esi
  8024e1:	5f                   	pop    %edi
  8024e2:	5d                   	pop    %ebp
  8024e3:	c3                   	ret    
  8024e4:	66 90                	xchg   %ax,%ax
  8024e6:	66 90                	xchg   %ax,%ax
  8024e8:	66 90                	xchg   %ax,%ax
  8024ea:	66 90                	xchg   %ax,%ax
  8024ec:	66 90                	xchg   %ax,%ax
  8024ee:	66 90                	xchg   %ax,%ax

008024f0 <__umoddi3>:
  8024f0:	55                   	push   %ebp
  8024f1:	57                   	push   %edi
  8024f2:	56                   	push   %esi
  8024f3:	83 ec 14             	sub    $0x14,%esp
  8024f6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8024fa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8024fe:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802502:	89 c7                	mov    %eax,%edi
  802504:	89 44 24 04          	mov    %eax,0x4(%esp)
  802508:	8b 44 24 30          	mov    0x30(%esp),%eax
  80250c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802510:	89 34 24             	mov    %esi,(%esp)
  802513:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802517:	85 c0                	test   %eax,%eax
  802519:	89 c2                	mov    %eax,%edx
  80251b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80251f:	75 17                	jne    802538 <__umoddi3+0x48>
  802521:	39 fe                	cmp    %edi,%esi
  802523:	76 4b                	jbe    802570 <__umoddi3+0x80>
  802525:	89 c8                	mov    %ecx,%eax
  802527:	89 fa                	mov    %edi,%edx
  802529:	f7 f6                	div    %esi
  80252b:	89 d0                	mov    %edx,%eax
  80252d:	31 d2                	xor    %edx,%edx
  80252f:	83 c4 14             	add    $0x14,%esp
  802532:	5e                   	pop    %esi
  802533:	5f                   	pop    %edi
  802534:	5d                   	pop    %ebp
  802535:	c3                   	ret    
  802536:	66 90                	xchg   %ax,%ax
  802538:	39 f8                	cmp    %edi,%eax
  80253a:	77 54                	ja     802590 <__umoddi3+0xa0>
  80253c:	0f bd e8             	bsr    %eax,%ebp
  80253f:	83 f5 1f             	xor    $0x1f,%ebp
  802542:	75 5c                	jne    8025a0 <__umoddi3+0xb0>
  802544:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802548:	39 3c 24             	cmp    %edi,(%esp)
  80254b:	0f 87 e7 00 00 00    	ja     802638 <__umoddi3+0x148>
  802551:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802555:	29 f1                	sub    %esi,%ecx
  802557:	19 c7                	sbb    %eax,%edi
  802559:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80255d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802561:	8b 44 24 08          	mov    0x8(%esp),%eax
  802565:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802569:	83 c4 14             	add    $0x14,%esp
  80256c:	5e                   	pop    %esi
  80256d:	5f                   	pop    %edi
  80256e:	5d                   	pop    %ebp
  80256f:	c3                   	ret    
  802570:	85 f6                	test   %esi,%esi
  802572:	89 f5                	mov    %esi,%ebp
  802574:	75 0b                	jne    802581 <__umoddi3+0x91>
  802576:	b8 01 00 00 00       	mov    $0x1,%eax
  80257b:	31 d2                	xor    %edx,%edx
  80257d:	f7 f6                	div    %esi
  80257f:	89 c5                	mov    %eax,%ebp
  802581:	8b 44 24 04          	mov    0x4(%esp),%eax
  802585:	31 d2                	xor    %edx,%edx
  802587:	f7 f5                	div    %ebp
  802589:	89 c8                	mov    %ecx,%eax
  80258b:	f7 f5                	div    %ebp
  80258d:	eb 9c                	jmp    80252b <__umoddi3+0x3b>
  80258f:	90                   	nop
  802590:	89 c8                	mov    %ecx,%eax
  802592:	89 fa                	mov    %edi,%edx
  802594:	83 c4 14             	add    $0x14,%esp
  802597:	5e                   	pop    %esi
  802598:	5f                   	pop    %edi
  802599:	5d                   	pop    %ebp
  80259a:	c3                   	ret    
  80259b:	90                   	nop
  80259c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025a0:	8b 04 24             	mov    (%esp),%eax
  8025a3:	be 20 00 00 00       	mov    $0x20,%esi
  8025a8:	89 e9                	mov    %ebp,%ecx
  8025aa:	29 ee                	sub    %ebp,%esi
  8025ac:	d3 e2                	shl    %cl,%edx
  8025ae:	89 f1                	mov    %esi,%ecx
  8025b0:	d3 e8                	shr    %cl,%eax
  8025b2:	89 e9                	mov    %ebp,%ecx
  8025b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b8:	8b 04 24             	mov    (%esp),%eax
  8025bb:	09 54 24 04          	or     %edx,0x4(%esp)
  8025bf:	89 fa                	mov    %edi,%edx
  8025c1:	d3 e0                	shl    %cl,%eax
  8025c3:	89 f1                	mov    %esi,%ecx
  8025c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025c9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8025cd:	d3 ea                	shr    %cl,%edx
  8025cf:	89 e9                	mov    %ebp,%ecx
  8025d1:	d3 e7                	shl    %cl,%edi
  8025d3:	89 f1                	mov    %esi,%ecx
  8025d5:	d3 e8                	shr    %cl,%eax
  8025d7:	89 e9                	mov    %ebp,%ecx
  8025d9:	09 f8                	or     %edi,%eax
  8025db:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8025df:	f7 74 24 04          	divl   0x4(%esp)
  8025e3:	d3 e7                	shl    %cl,%edi
  8025e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025e9:	89 d7                	mov    %edx,%edi
  8025eb:	f7 64 24 08          	mull   0x8(%esp)
  8025ef:	39 d7                	cmp    %edx,%edi
  8025f1:	89 c1                	mov    %eax,%ecx
  8025f3:	89 14 24             	mov    %edx,(%esp)
  8025f6:	72 2c                	jb     802624 <__umoddi3+0x134>
  8025f8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8025fc:	72 22                	jb     802620 <__umoddi3+0x130>
  8025fe:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802602:	29 c8                	sub    %ecx,%eax
  802604:	19 d7                	sbb    %edx,%edi
  802606:	89 e9                	mov    %ebp,%ecx
  802608:	89 fa                	mov    %edi,%edx
  80260a:	d3 e8                	shr    %cl,%eax
  80260c:	89 f1                	mov    %esi,%ecx
  80260e:	d3 e2                	shl    %cl,%edx
  802610:	89 e9                	mov    %ebp,%ecx
  802612:	d3 ef                	shr    %cl,%edi
  802614:	09 d0                	or     %edx,%eax
  802616:	89 fa                	mov    %edi,%edx
  802618:	83 c4 14             	add    $0x14,%esp
  80261b:	5e                   	pop    %esi
  80261c:	5f                   	pop    %edi
  80261d:	5d                   	pop    %ebp
  80261e:	c3                   	ret    
  80261f:	90                   	nop
  802620:	39 d7                	cmp    %edx,%edi
  802622:	75 da                	jne    8025fe <__umoddi3+0x10e>
  802624:	8b 14 24             	mov    (%esp),%edx
  802627:	89 c1                	mov    %eax,%ecx
  802629:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80262d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802631:	eb cb                	jmp    8025fe <__umoddi3+0x10e>
  802633:	90                   	nop
  802634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802638:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80263c:	0f 82 0f ff ff ff    	jb     802551 <__umoddi3+0x61>
  802642:	e9 1a ff ff ff       	jmp    802561 <__umoddi3+0x71>
