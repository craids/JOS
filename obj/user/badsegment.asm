
obj/user/badsegment.debug:     file format elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800036:	66 b8 28 00          	mov    $0x28,%ax
  80003a:	8e d8                	mov    %eax,%ds
}
  80003c:	5d                   	pop    %ebp
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	56                   	push   %esi
  800042:	53                   	push   %ebx
  800043:	83 ec 10             	sub    $0x10,%esp
  800046:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800049:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80004c:	e8 dd 00 00 00       	call   80012e <sys_getenvid>
  800051:	25 ff 03 00 00       	and    $0x3ff,%eax
  800056:	c1 e0 07             	shl    $0x7,%eax
  800059:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80005e:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800063:	85 db                	test   %ebx,%ebx
  800065:	7e 07                	jle    80006e <libmain+0x30>
		binaryname = argv[0];
  800067:	8b 06                	mov    (%esi),%eax
  800069:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800072:	89 1c 24             	mov    %ebx,(%esp)
  800075:	e8 b9 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80007a:	e8 07 00 00 00       	call   800086 <exit>
}
  80007f:	83 c4 10             	add    $0x10,%esp
  800082:	5b                   	pop    %ebx
  800083:	5e                   	pop    %esi
  800084:	5d                   	pop    %ebp
  800085:	c3                   	ret    

00800086 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800086:	55                   	push   %ebp
  800087:	89 e5                	mov    %esp,%ebp
  800089:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80008c:	e8 f9 05 00 00       	call   80068a <close_all>
	sys_env_destroy(0);
  800091:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800098:	e8 3f 00 00 00       	call   8000dc <sys_env_destroy>
}
  80009d:	c9                   	leave  
  80009e:	c3                   	ret    

0080009f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80009f:	55                   	push   %ebp
  8000a0:	89 e5                	mov    %esp,%ebp
  8000a2:	57                   	push   %edi
  8000a3:	56                   	push   %esi
  8000a4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b0:	89 c3                	mov    %eax,%ebx
  8000b2:	89 c7                	mov    %eax,%edi
  8000b4:	89 c6                	mov    %eax,%esi
  8000b6:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b8:	5b                   	pop    %ebx
  8000b9:	5e                   	pop    %esi
  8000ba:	5f                   	pop    %edi
  8000bb:	5d                   	pop    %ebp
  8000bc:	c3                   	ret    

008000bd <sys_cgetc>:

int
sys_cgetc(void)
{
  8000bd:	55                   	push   %ebp
  8000be:	89 e5                	mov    %esp,%ebp
  8000c0:	57                   	push   %edi
  8000c1:	56                   	push   %esi
  8000c2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8000cd:	89 d1                	mov    %edx,%ecx
  8000cf:	89 d3                	mov    %edx,%ebx
  8000d1:	89 d7                	mov    %edx,%edi
  8000d3:	89 d6                	mov    %edx,%esi
  8000d5:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d7:	5b                   	pop    %ebx
  8000d8:	5e                   	pop    %esi
  8000d9:	5f                   	pop    %edi
  8000da:	5d                   	pop    %ebp
  8000db:	c3                   	ret    

008000dc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	57                   	push   %edi
  8000e0:	56                   	push   %esi
  8000e1:	53                   	push   %ebx
  8000e2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ea:	b8 03 00 00 00       	mov    $0x3,%eax
  8000ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f2:	89 cb                	mov    %ecx,%ebx
  8000f4:	89 cf                	mov    %ecx,%edi
  8000f6:	89 ce                	mov    %ecx,%esi
  8000f8:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	7e 28                	jle    800126 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8000fe:	89 44 24 10          	mov    %eax,0x10(%esp)
  800102:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800109:	00 
  80010a:	c7 44 24 08 4a 26 80 	movl   $0x80264a,0x8(%esp)
  800111:	00 
  800112:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800119:	00 
  80011a:	c7 04 24 67 26 80 00 	movl   $0x802667,(%esp)
  800121:	e8 a0 16 00 00       	call   8017c6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800126:	83 c4 2c             	add    $0x2c,%esp
  800129:	5b                   	pop    %ebx
  80012a:	5e                   	pop    %esi
  80012b:	5f                   	pop    %edi
  80012c:	5d                   	pop    %ebp
  80012d:	c3                   	ret    

0080012e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80012e:	55                   	push   %ebp
  80012f:	89 e5                	mov    %esp,%ebp
  800131:	57                   	push   %edi
  800132:	56                   	push   %esi
  800133:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800134:	ba 00 00 00 00       	mov    $0x0,%edx
  800139:	b8 02 00 00 00       	mov    $0x2,%eax
  80013e:	89 d1                	mov    %edx,%ecx
  800140:	89 d3                	mov    %edx,%ebx
  800142:	89 d7                	mov    %edx,%edi
  800144:	89 d6                	mov    %edx,%esi
  800146:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800148:	5b                   	pop    %ebx
  800149:	5e                   	pop    %esi
  80014a:	5f                   	pop    %edi
  80014b:	5d                   	pop    %ebp
  80014c:	c3                   	ret    

0080014d <sys_yield>:

void
sys_yield(void)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	57                   	push   %edi
  800151:	56                   	push   %esi
  800152:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800153:	ba 00 00 00 00       	mov    $0x0,%edx
  800158:	b8 0b 00 00 00       	mov    $0xb,%eax
  80015d:	89 d1                	mov    %edx,%ecx
  80015f:	89 d3                	mov    %edx,%ebx
  800161:	89 d7                	mov    %edx,%edi
  800163:	89 d6                	mov    %edx,%esi
  800165:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800167:	5b                   	pop    %ebx
  800168:	5e                   	pop    %esi
  800169:	5f                   	pop    %edi
  80016a:	5d                   	pop    %ebp
  80016b:	c3                   	ret    

0080016c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	57                   	push   %edi
  800170:	56                   	push   %esi
  800171:	53                   	push   %ebx
  800172:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800175:	be 00 00 00 00       	mov    $0x0,%esi
  80017a:	b8 04 00 00 00       	mov    $0x4,%eax
  80017f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800182:	8b 55 08             	mov    0x8(%ebp),%edx
  800185:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800188:	89 f7                	mov    %esi,%edi
  80018a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80018c:	85 c0                	test   %eax,%eax
  80018e:	7e 28                	jle    8001b8 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800190:	89 44 24 10          	mov    %eax,0x10(%esp)
  800194:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80019b:	00 
  80019c:	c7 44 24 08 4a 26 80 	movl   $0x80264a,0x8(%esp)
  8001a3:	00 
  8001a4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001ab:	00 
  8001ac:	c7 04 24 67 26 80 00 	movl   $0x802667,(%esp)
  8001b3:	e8 0e 16 00 00       	call   8017c6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001b8:	83 c4 2c             	add    $0x2c,%esp
  8001bb:	5b                   	pop    %ebx
  8001bc:	5e                   	pop    %esi
  8001bd:	5f                   	pop    %edi
  8001be:	5d                   	pop    %ebp
  8001bf:	c3                   	ret    

008001c0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	57                   	push   %edi
  8001c4:	56                   	push   %esi
  8001c5:	53                   	push   %ebx
  8001c6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001c9:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001d7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001da:	8b 75 18             	mov    0x18(%ebp),%esi
  8001dd:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8001df:	85 c0                	test   %eax,%eax
  8001e1:	7e 28                	jle    80020b <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001e3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001e7:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8001ee:	00 
  8001ef:	c7 44 24 08 4a 26 80 	movl   $0x80264a,0x8(%esp)
  8001f6:	00 
  8001f7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001fe:	00 
  8001ff:	c7 04 24 67 26 80 00 	movl   $0x802667,(%esp)
  800206:	e8 bb 15 00 00       	call   8017c6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80020b:	83 c4 2c             	add    $0x2c,%esp
  80020e:	5b                   	pop    %ebx
  80020f:	5e                   	pop    %esi
  800210:	5f                   	pop    %edi
  800211:	5d                   	pop    %ebp
  800212:	c3                   	ret    

00800213 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800213:	55                   	push   %ebp
  800214:	89 e5                	mov    %esp,%ebp
  800216:	57                   	push   %edi
  800217:	56                   	push   %esi
  800218:	53                   	push   %ebx
  800219:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80021c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800221:	b8 06 00 00 00       	mov    $0x6,%eax
  800226:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800229:	8b 55 08             	mov    0x8(%ebp),%edx
  80022c:	89 df                	mov    %ebx,%edi
  80022e:	89 de                	mov    %ebx,%esi
  800230:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800232:	85 c0                	test   %eax,%eax
  800234:	7e 28                	jle    80025e <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800236:	89 44 24 10          	mov    %eax,0x10(%esp)
  80023a:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800241:	00 
  800242:	c7 44 24 08 4a 26 80 	movl   $0x80264a,0x8(%esp)
  800249:	00 
  80024a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800251:	00 
  800252:	c7 04 24 67 26 80 00 	movl   $0x802667,(%esp)
  800259:	e8 68 15 00 00       	call   8017c6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80025e:	83 c4 2c             	add    $0x2c,%esp
  800261:	5b                   	pop    %ebx
  800262:	5e                   	pop    %esi
  800263:	5f                   	pop    %edi
  800264:	5d                   	pop    %ebp
  800265:	c3                   	ret    

00800266 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	57                   	push   %edi
  80026a:	56                   	push   %esi
  80026b:	53                   	push   %ebx
  80026c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80026f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800274:	b8 08 00 00 00       	mov    $0x8,%eax
  800279:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80027c:	8b 55 08             	mov    0x8(%ebp),%edx
  80027f:	89 df                	mov    %ebx,%edi
  800281:	89 de                	mov    %ebx,%esi
  800283:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800285:	85 c0                	test   %eax,%eax
  800287:	7e 28                	jle    8002b1 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800289:	89 44 24 10          	mov    %eax,0x10(%esp)
  80028d:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800294:	00 
  800295:	c7 44 24 08 4a 26 80 	movl   $0x80264a,0x8(%esp)
  80029c:	00 
  80029d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002a4:	00 
  8002a5:	c7 04 24 67 26 80 00 	movl   $0x802667,(%esp)
  8002ac:	e8 15 15 00 00       	call   8017c6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002b1:	83 c4 2c             	add    $0x2c,%esp
  8002b4:	5b                   	pop    %ebx
  8002b5:	5e                   	pop    %esi
  8002b6:	5f                   	pop    %edi
  8002b7:	5d                   	pop    %ebp
  8002b8:	c3                   	ret    

008002b9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	57                   	push   %edi
  8002bd:	56                   	push   %esi
  8002be:	53                   	push   %ebx
  8002bf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c7:	b8 09 00 00 00       	mov    $0x9,%eax
  8002cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d2:	89 df                	mov    %ebx,%edi
  8002d4:	89 de                	mov    %ebx,%esi
  8002d6:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8002d8:	85 c0                	test   %eax,%eax
  8002da:	7e 28                	jle    800304 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002e0:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8002e7:	00 
  8002e8:	c7 44 24 08 4a 26 80 	movl   $0x80264a,0x8(%esp)
  8002ef:	00 
  8002f0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002f7:	00 
  8002f8:	c7 04 24 67 26 80 00 	movl   $0x802667,(%esp)
  8002ff:	e8 c2 14 00 00       	call   8017c6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800304:	83 c4 2c             	add    $0x2c,%esp
  800307:	5b                   	pop    %ebx
  800308:	5e                   	pop    %esi
  800309:	5f                   	pop    %edi
  80030a:	5d                   	pop    %ebp
  80030b:	c3                   	ret    

0080030c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80030c:	55                   	push   %ebp
  80030d:	89 e5                	mov    %esp,%ebp
  80030f:	57                   	push   %edi
  800310:	56                   	push   %esi
  800311:	53                   	push   %ebx
  800312:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800315:	bb 00 00 00 00       	mov    $0x0,%ebx
  80031a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80031f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800322:	8b 55 08             	mov    0x8(%ebp),%edx
  800325:	89 df                	mov    %ebx,%edi
  800327:	89 de                	mov    %ebx,%esi
  800329:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80032b:	85 c0                	test   %eax,%eax
  80032d:	7e 28                	jle    800357 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80032f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800333:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  80033a:	00 
  80033b:	c7 44 24 08 4a 26 80 	movl   $0x80264a,0x8(%esp)
  800342:	00 
  800343:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80034a:	00 
  80034b:	c7 04 24 67 26 80 00 	movl   $0x802667,(%esp)
  800352:	e8 6f 14 00 00       	call   8017c6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800357:	83 c4 2c             	add    $0x2c,%esp
  80035a:	5b                   	pop    %ebx
  80035b:	5e                   	pop    %esi
  80035c:	5f                   	pop    %edi
  80035d:	5d                   	pop    %ebp
  80035e:	c3                   	ret    

0080035f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
  800362:	57                   	push   %edi
  800363:	56                   	push   %esi
  800364:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800365:	be 00 00 00 00       	mov    $0x0,%esi
  80036a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80036f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800372:	8b 55 08             	mov    0x8(%ebp),%edx
  800375:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800378:	8b 7d 14             	mov    0x14(%ebp),%edi
  80037b:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80037d:	5b                   	pop    %ebx
  80037e:	5e                   	pop    %esi
  80037f:	5f                   	pop    %edi
  800380:	5d                   	pop    %ebp
  800381:	c3                   	ret    

00800382 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	57                   	push   %edi
  800386:	56                   	push   %esi
  800387:	53                   	push   %ebx
  800388:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80038b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800390:	b8 0d 00 00 00       	mov    $0xd,%eax
  800395:	8b 55 08             	mov    0x8(%ebp),%edx
  800398:	89 cb                	mov    %ecx,%ebx
  80039a:	89 cf                	mov    %ecx,%edi
  80039c:	89 ce                	mov    %ecx,%esi
  80039e:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8003a0:	85 c0                	test   %eax,%eax
  8003a2:	7e 28                	jle    8003cc <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003a4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003a8:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8003af:	00 
  8003b0:	c7 44 24 08 4a 26 80 	movl   $0x80264a,0x8(%esp)
  8003b7:	00 
  8003b8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003bf:	00 
  8003c0:	c7 04 24 67 26 80 00 	movl   $0x802667,(%esp)
  8003c7:	e8 fa 13 00 00       	call   8017c6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8003cc:	83 c4 2c             	add    $0x2c,%esp
  8003cf:	5b                   	pop    %ebx
  8003d0:	5e                   	pop    %esi
  8003d1:	5f                   	pop    %edi
  8003d2:	5d                   	pop    %ebp
  8003d3:	c3                   	ret    

008003d4 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	57                   	push   %edi
  8003d8:	56                   	push   %esi
  8003d9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003da:	ba 00 00 00 00       	mov    $0x0,%edx
  8003df:	b8 0e 00 00 00       	mov    $0xe,%eax
  8003e4:	89 d1                	mov    %edx,%ecx
  8003e6:	89 d3                	mov    %edx,%ebx
  8003e8:	89 d7                	mov    %edx,%edi
  8003ea:	89 d6                	mov    %edx,%esi
  8003ec:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8003ee:	5b                   	pop    %ebx
  8003ef:	5e                   	pop    %esi
  8003f0:	5f                   	pop    %edi
  8003f1:	5d                   	pop    %ebp
  8003f2:	c3                   	ret    

008003f3 <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  8003f3:	55                   	push   %ebp
  8003f4:	89 e5                	mov    %esp,%ebp
  8003f6:	57                   	push   %edi
  8003f7:	56                   	push   %esi
  8003f8:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003fe:	b8 0f 00 00 00       	mov    $0xf,%eax
  800403:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800406:	8b 55 08             	mov    0x8(%ebp),%edx
  800409:	89 df                	mov    %ebx,%edi
  80040b:	89 de                	mov    %ebx,%esi
  80040d:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  80040f:	5b                   	pop    %ebx
  800410:	5e                   	pop    %esi
  800411:	5f                   	pop    %edi
  800412:	5d                   	pop    %ebp
  800413:	c3                   	ret    

00800414 <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  800414:	55                   	push   %ebp
  800415:	89 e5                	mov    %esp,%ebp
  800417:	57                   	push   %edi
  800418:	56                   	push   %esi
  800419:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80041a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80041f:	b8 10 00 00 00       	mov    $0x10,%eax
  800424:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800427:	8b 55 08             	mov    0x8(%ebp),%edx
  80042a:	89 df                	mov    %ebx,%edi
  80042c:	89 de                	mov    %ebx,%esi
  80042e:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800430:	5b                   	pop    %ebx
  800431:	5e                   	pop    %esi
  800432:	5f                   	pop    %edi
  800433:	5d                   	pop    %ebp
  800434:	c3                   	ret    

00800435 <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800435:	55                   	push   %ebp
  800436:	89 e5                	mov    %esp,%ebp
  800438:	57                   	push   %edi
  800439:	56                   	push   %esi
  80043a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80043b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800440:	b8 11 00 00 00       	mov    $0x11,%eax
  800445:	8b 55 08             	mov    0x8(%ebp),%edx
  800448:	89 cb                	mov    %ecx,%ebx
  80044a:	89 cf                	mov    %ecx,%edi
  80044c:	89 ce                	mov    %ecx,%esi
  80044e:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800450:	5b                   	pop    %ebx
  800451:	5e                   	pop    %esi
  800452:	5f                   	pop    %edi
  800453:	5d                   	pop    %ebp
  800454:	c3                   	ret    

00800455 <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800455:	55                   	push   %ebp
  800456:	89 e5                	mov    %esp,%ebp
  800458:	57                   	push   %edi
  800459:	56                   	push   %esi
  80045a:	53                   	push   %ebx
  80045b:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80045e:	be 00 00 00 00       	mov    $0x0,%esi
  800463:	b8 12 00 00 00       	mov    $0x12,%eax
  800468:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80046b:	8b 55 08             	mov    0x8(%ebp),%edx
  80046e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800471:	8b 7d 14             	mov    0x14(%ebp),%edi
  800474:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800476:	85 c0                	test   %eax,%eax
  800478:	7e 28                	jle    8004a2 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  80047a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80047e:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800485:	00 
  800486:	c7 44 24 08 4a 26 80 	movl   $0x80264a,0x8(%esp)
  80048d:	00 
  80048e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800495:	00 
  800496:	c7 04 24 67 26 80 00 	movl   $0x802667,(%esp)
  80049d:	e8 24 13 00 00       	call   8017c6 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  8004a2:	83 c4 2c             	add    $0x2c,%esp
  8004a5:	5b                   	pop    %ebx
  8004a6:	5e                   	pop    %esi
  8004a7:	5f                   	pop    %edi
  8004a8:	5d                   	pop    %ebp
  8004a9:	c3                   	ret    
  8004aa:	66 90                	xchg   %ax,%ax
  8004ac:	66 90                	xchg   %ax,%ax
  8004ae:	66 90                	xchg   %ax,%ax

008004b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b6:	05 00 00 00 30       	add    $0x30000000,%eax
  8004bb:	c1 e8 0c             	shr    $0xc,%eax
}
  8004be:	5d                   	pop    %ebp
  8004bf:	c3                   	ret    

008004c0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8004cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004d0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8004d5:	5d                   	pop    %ebp
  8004d6:	c3                   	ret    

008004d7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8004d7:	55                   	push   %ebp
  8004d8:	89 e5                	mov    %esp,%ebp
  8004da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004dd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8004e2:	89 c2                	mov    %eax,%edx
  8004e4:	c1 ea 16             	shr    $0x16,%edx
  8004e7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8004ee:	f6 c2 01             	test   $0x1,%dl
  8004f1:	74 11                	je     800504 <fd_alloc+0x2d>
  8004f3:	89 c2                	mov    %eax,%edx
  8004f5:	c1 ea 0c             	shr    $0xc,%edx
  8004f8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004ff:	f6 c2 01             	test   $0x1,%dl
  800502:	75 09                	jne    80050d <fd_alloc+0x36>
			*fd_store = fd;
  800504:	89 01                	mov    %eax,(%ecx)
			return 0;
  800506:	b8 00 00 00 00       	mov    $0x0,%eax
  80050b:	eb 17                	jmp    800524 <fd_alloc+0x4d>
  80050d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800512:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800517:	75 c9                	jne    8004e2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800519:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80051f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800524:	5d                   	pop    %ebp
  800525:	c3                   	ret    

00800526 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800526:	55                   	push   %ebp
  800527:	89 e5                	mov    %esp,%ebp
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80052c:	83 f8 1f             	cmp    $0x1f,%eax
  80052f:	77 36                	ja     800567 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800531:	c1 e0 0c             	shl    $0xc,%eax
  800534:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800539:	89 c2                	mov    %eax,%edx
  80053b:	c1 ea 16             	shr    $0x16,%edx
  80053e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800545:	f6 c2 01             	test   $0x1,%dl
  800548:	74 24                	je     80056e <fd_lookup+0x48>
  80054a:	89 c2                	mov    %eax,%edx
  80054c:	c1 ea 0c             	shr    $0xc,%edx
  80054f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800556:	f6 c2 01             	test   $0x1,%dl
  800559:	74 1a                	je     800575 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80055b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055e:	89 02                	mov    %eax,(%edx)
	return 0;
  800560:	b8 00 00 00 00       	mov    $0x0,%eax
  800565:	eb 13                	jmp    80057a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800567:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80056c:	eb 0c                	jmp    80057a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80056e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800573:	eb 05                	jmp    80057a <fd_lookup+0x54>
  800575:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80057a:	5d                   	pop    %ebp
  80057b:	c3                   	ret    

0080057c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80057c:	55                   	push   %ebp
  80057d:	89 e5                	mov    %esp,%ebp
  80057f:	83 ec 18             	sub    $0x18,%esp
  800582:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800585:	ba 00 00 00 00       	mov    $0x0,%edx
  80058a:	eb 13                	jmp    80059f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80058c:	39 08                	cmp    %ecx,(%eax)
  80058e:	75 0c                	jne    80059c <dev_lookup+0x20>
			*dev = devtab[i];
  800590:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800593:	89 01                	mov    %eax,(%ecx)
			return 0;
  800595:	b8 00 00 00 00       	mov    $0x0,%eax
  80059a:	eb 38                	jmp    8005d4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80059c:	83 c2 01             	add    $0x1,%edx
  80059f:	8b 04 95 f4 26 80 00 	mov    0x8026f4(,%edx,4),%eax
  8005a6:	85 c0                	test   %eax,%eax
  8005a8:	75 e2                	jne    80058c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8005aa:	a1 08 40 80 00       	mov    0x804008,%eax
  8005af:	8b 40 48             	mov    0x48(%eax),%eax
  8005b2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ba:	c7 04 24 78 26 80 00 	movl   $0x802678,(%esp)
  8005c1:	e8 f9 12 00 00       	call   8018bf <cprintf>
	*dev = 0;
  8005c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8005cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8005d4:	c9                   	leave  
  8005d5:	c3                   	ret    

008005d6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8005d6:	55                   	push   %ebp
  8005d7:	89 e5                	mov    %esp,%ebp
  8005d9:	56                   	push   %esi
  8005da:	53                   	push   %ebx
  8005db:	83 ec 20             	sub    $0x20,%esp
  8005de:	8b 75 08             	mov    0x8(%ebp),%esi
  8005e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8005e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8005eb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8005f1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8005f4:	89 04 24             	mov    %eax,(%esp)
  8005f7:	e8 2a ff ff ff       	call   800526 <fd_lookup>
  8005fc:	85 c0                	test   %eax,%eax
  8005fe:	78 05                	js     800605 <fd_close+0x2f>
	    || fd != fd2)
  800600:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800603:	74 0c                	je     800611 <fd_close+0x3b>
		return (must_exist ? r : 0);
  800605:	84 db                	test   %bl,%bl
  800607:	ba 00 00 00 00       	mov    $0x0,%edx
  80060c:	0f 44 c2             	cmove  %edx,%eax
  80060f:	eb 3f                	jmp    800650 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800611:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800614:	89 44 24 04          	mov    %eax,0x4(%esp)
  800618:	8b 06                	mov    (%esi),%eax
  80061a:	89 04 24             	mov    %eax,(%esp)
  80061d:	e8 5a ff ff ff       	call   80057c <dev_lookup>
  800622:	89 c3                	mov    %eax,%ebx
  800624:	85 c0                	test   %eax,%eax
  800626:	78 16                	js     80063e <fd_close+0x68>
		if (dev->dev_close)
  800628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80062e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800633:	85 c0                	test   %eax,%eax
  800635:	74 07                	je     80063e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800637:	89 34 24             	mov    %esi,(%esp)
  80063a:	ff d0                	call   *%eax
  80063c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80063e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800642:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800649:	e8 c5 fb ff ff       	call   800213 <sys_page_unmap>
	return r;
  80064e:	89 d8                	mov    %ebx,%eax
}
  800650:	83 c4 20             	add    $0x20,%esp
  800653:	5b                   	pop    %ebx
  800654:	5e                   	pop    %esi
  800655:	5d                   	pop    %ebp
  800656:	c3                   	ret    

00800657 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800657:	55                   	push   %ebp
  800658:	89 e5                	mov    %esp,%ebp
  80065a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80065d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800660:	89 44 24 04          	mov    %eax,0x4(%esp)
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	89 04 24             	mov    %eax,(%esp)
  80066a:	e8 b7 fe ff ff       	call   800526 <fd_lookup>
  80066f:	89 c2                	mov    %eax,%edx
  800671:	85 d2                	test   %edx,%edx
  800673:	78 13                	js     800688 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  800675:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80067c:	00 
  80067d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800680:	89 04 24             	mov    %eax,(%esp)
  800683:	e8 4e ff ff ff       	call   8005d6 <fd_close>
}
  800688:	c9                   	leave  
  800689:	c3                   	ret    

0080068a <close_all>:

void
close_all(void)
{
  80068a:	55                   	push   %ebp
  80068b:	89 e5                	mov    %esp,%ebp
  80068d:	53                   	push   %ebx
  80068e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800691:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800696:	89 1c 24             	mov    %ebx,(%esp)
  800699:	e8 b9 ff ff ff       	call   800657 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80069e:	83 c3 01             	add    $0x1,%ebx
  8006a1:	83 fb 20             	cmp    $0x20,%ebx
  8006a4:	75 f0                	jne    800696 <close_all+0xc>
		close(i);
}
  8006a6:	83 c4 14             	add    $0x14,%esp
  8006a9:	5b                   	pop    %ebx
  8006aa:	5d                   	pop    %ebp
  8006ab:	c3                   	ret    

008006ac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8006ac:	55                   	push   %ebp
  8006ad:	89 e5                	mov    %esp,%ebp
  8006af:	57                   	push   %edi
  8006b0:	56                   	push   %esi
  8006b1:	53                   	push   %ebx
  8006b2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8006b5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8006b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	89 04 24             	mov    %eax,(%esp)
  8006c2:	e8 5f fe ff ff       	call   800526 <fd_lookup>
  8006c7:	89 c2                	mov    %eax,%edx
  8006c9:	85 d2                	test   %edx,%edx
  8006cb:	0f 88 e1 00 00 00    	js     8007b2 <dup+0x106>
		return r;
	close(newfdnum);
  8006d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d4:	89 04 24             	mov    %eax,(%esp)
  8006d7:	e8 7b ff ff ff       	call   800657 <close>

	newfd = INDEX2FD(newfdnum);
  8006dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006df:	c1 e3 0c             	shl    $0xc,%ebx
  8006e2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8006e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006eb:	89 04 24             	mov    %eax,(%esp)
  8006ee:	e8 cd fd ff ff       	call   8004c0 <fd2data>
  8006f3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8006f5:	89 1c 24             	mov    %ebx,(%esp)
  8006f8:	e8 c3 fd ff ff       	call   8004c0 <fd2data>
  8006fd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8006ff:	89 f0                	mov    %esi,%eax
  800701:	c1 e8 16             	shr    $0x16,%eax
  800704:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80070b:	a8 01                	test   $0x1,%al
  80070d:	74 43                	je     800752 <dup+0xa6>
  80070f:	89 f0                	mov    %esi,%eax
  800711:	c1 e8 0c             	shr    $0xc,%eax
  800714:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80071b:	f6 c2 01             	test   $0x1,%dl
  80071e:	74 32                	je     800752 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800720:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800727:	25 07 0e 00 00       	and    $0xe07,%eax
  80072c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800730:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800734:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80073b:	00 
  80073c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800740:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800747:	e8 74 fa ff ff       	call   8001c0 <sys_page_map>
  80074c:	89 c6                	mov    %eax,%esi
  80074e:	85 c0                	test   %eax,%eax
  800750:	78 3e                	js     800790 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800752:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800755:	89 c2                	mov    %eax,%edx
  800757:	c1 ea 0c             	shr    $0xc,%edx
  80075a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800761:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800767:	89 54 24 10          	mov    %edx,0x10(%esp)
  80076b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80076f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800776:	00 
  800777:	89 44 24 04          	mov    %eax,0x4(%esp)
  80077b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800782:	e8 39 fa ff ff       	call   8001c0 <sys_page_map>
  800787:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  800789:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80078c:	85 f6                	test   %esi,%esi
  80078e:	79 22                	jns    8007b2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800790:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800794:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80079b:	e8 73 fa ff ff       	call   800213 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8007a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007ab:	e8 63 fa ff ff       	call   800213 <sys_page_unmap>
	return r;
  8007b0:	89 f0                	mov    %esi,%eax
}
  8007b2:	83 c4 3c             	add    $0x3c,%esp
  8007b5:	5b                   	pop    %ebx
  8007b6:	5e                   	pop    %esi
  8007b7:	5f                   	pop    %edi
  8007b8:	5d                   	pop    %ebp
  8007b9:	c3                   	ret    

008007ba <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	53                   	push   %ebx
  8007be:	83 ec 24             	sub    $0x24,%esp
  8007c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007cb:	89 1c 24             	mov    %ebx,(%esp)
  8007ce:	e8 53 fd ff ff       	call   800526 <fd_lookup>
  8007d3:	89 c2                	mov    %eax,%edx
  8007d5:	85 d2                	test   %edx,%edx
  8007d7:	78 6d                	js     800846 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	89 04 24             	mov    %eax,(%esp)
  8007e8:	e8 8f fd ff ff       	call   80057c <dev_lookup>
  8007ed:	85 c0                	test   %eax,%eax
  8007ef:	78 55                	js     800846 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8007f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f4:	8b 50 08             	mov    0x8(%eax),%edx
  8007f7:	83 e2 03             	and    $0x3,%edx
  8007fa:	83 fa 01             	cmp    $0x1,%edx
  8007fd:	75 23                	jne    800822 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8007ff:	a1 08 40 80 00       	mov    0x804008,%eax
  800804:	8b 40 48             	mov    0x48(%eax),%eax
  800807:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80080b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80080f:	c7 04 24 b9 26 80 00 	movl   $0x8026b9,(%esp)
  800816:	e8 a4 10 00 00       	call   8018bf <cprintf>
		return -E_INVAL;
  80081b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800820:	eb 24                	jmp    800846 <read+0x8c>
	}
	if (!dev->dev_read)
  800822:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800825:	8b 52 08             	mov    0x8(%edx),%edx
  800828:	85 d2                	test   %edx,%edx
  80082a:	74 15                	je     800841 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80082c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80082f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800833:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800836:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80083a:	89 04 24             	mov    %eax,(%esp)
  80083d:	ff d2                	call   *%edx
  80083f:	eb 05                	jmp    800846 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800841:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800846:	83 c4 24             	add    $0x24,%esp
  800849:	5b                   	pop    %ebx
  80084a:	5d                   	pop    %ebp
  80084b:	c3                   	ret    

0080084c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	57                   	push   %edi
  800850:	56                   	push   %esi
  800851:	53                   	push   %ebx
  800852:	83 ec 1c             	sub    $0x1c,%esp
  800855:	8b 7d 08             	mov    0x8(%ebp),%edi
  800858:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80085b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800860:	eb 23                	jmp    800885 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800862:	89 f0                	mov    %esi,%eax
  800864:	29 d8                	sub    %ebx,%eax
  800866:	89 44 24 08          	mov    %eax,0x8(%esp)
  80086a:	89 d8                	mov    %ebx,%eax
  80086c:	03 45 0c             	add    0xc(%ebp),%eax
  80086f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800873:	89 3c 24             	mov    %edi,(%esp)
  800876:	e8 3f ff ff ff       	call   8007ba <read>
		if (m < 0)
  80087b:	85 c0                	test   %eax,%eax
  80087d:	78 10                	js     80088f <readn+0x43>
			return m;
		if (m == 0)
  80087f:	85 c0                	test   %eax,%eax
  800881:	74 0a                	je     80088d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800883:	01 c3                	add    %eax,%ebx
  800885:	39 f3                	cmp    %esi,%ebx
  800887:	72 d9                	jb     800862 <readn+0x16>
  800889:	89 d8                	mov    %ebx,%eax
  80088b:	eb 02                	jmp    80088f <readn+0x43>
  80088d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80088f:	83 c4 1c             	add    $0x1c,%esp
  800892:	5b                   	pop    %ebx
  800893:	5e                   	pop    %esi
  800894:	5f                   	pop    %edi
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	53                   	push   %ebx
  80089b:	83 ec 24             	sub    $0x24,%esp
  80089e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a8:	89 1c 24             	mov    %ebx,(%esp)
  8008ab:	e8 76 fc ff ff       	call   800526 <fd_lookup>
  8008b0:	89 c2                	mov    %eax,%edx
  8008b2:	85 d2                	test   %edx,%edx
  8008b4:	78 68                	js     80091e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	89 04 24             	mov    %eax,(%esp)
  8008c5:	e8 b2 fc ff ff       	call   80057c <dev_lookup>
  8008ca:	85 c0                	test   %eax,%eax
  8008cc:	78 50                	js     80091e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8008ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8008d5:	75 23                	jne    8008fa <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8008d7:	a1 08 40 80 00       	mov    0x804008,%eax
  8008dc:	8b 40 48             	mov    0x48(%eax),%eax
  8008df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8008e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008e7:	c7 04 24 d5 26 80 00 	movl   $0x8026d5,(%esp)
  8008ee:	e8 cc 0f 00 00       	call   8018bf <cprintf>
		return -E_INVAL;
  8008f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f8:	eb 24                	jmp    80091e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8008fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008fd:	8b 52 0c             	mov    0xc(%edx),%edx
  800900:	85 d2                	test   %edx,%edx
  800902:	74 15                	je     800919 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800904:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800907:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80090b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80090e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800912:	89 04 24             	mov    %eax,(%esp)
  800915:	ff d2                	call   *%edx
  800917:	eb 05                	jmp    80091e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800919:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80091e:	83 c4 24             	add    $0x24,%esp
  800921:	5b                   	pop    %ebx
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <seek>:

int
seek(int fdnum, off_t offset)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80092a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80092d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	89 04 24             	mov    %eax,(%esp)
  800937:	e8 ea fb ff ff       	call   800526 <fd_lookup>
  80093c:	85 c0                	test   %eax,%eax
  80093e:	78 0e                	js     80094e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800940:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800943:	8b 55 0c             	mov    0xc(%ebp),%edx
  800946:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800949:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80094e:	c9                   	leave  
  80094f:	c3                   	ret    

00800950 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	53                   	push   %ebx
  800954:	83 ec 24             	sub    $0x24,%esp
  800957:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80095a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80095d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800961:	89 1c 24             	mov    %ebx,(%esp)
  800964:	e8 bd fb ff ff       	call   800526 <fd_lookup>
  800969:	89 c2                	mov    %eax,%edx
  80096b:	85 d2                	test   %edx,%edx
  80096d:	78 61                	js     8009d0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80096f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800972:	89 44 24 04          	mov    %eax,0x4(%esp)
  800976:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800979:	8b 00                	mov    (%eax),%eax
  80097b:	89 04 24             	mov    %eax,(%esp)
  80097e:	e8 f9 fb ff ff       	call   80057c <dev_lookup>
  800983:	85 c0                	test   %eax,%eax
  800985:	78 49                	js     8009d0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80098e:	75 23                	jne    8009b3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800990:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800995:	8b 40 48             	mov    0x48(%eax),%eax
  800998:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80099c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a0:	c7 04 24 98 26 80 00 	movl   $0x802698,(%esp)
  8009a7:	e8 13 0f 00 00       	call   8018bf <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8009ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009b1:	eb 1d                	jmp    8009d0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8009b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b6:	8b 52 18             	mov    0x18(%edx),%edx
  8009b9:	85 d2                	test   %edx,%edx
  8009bb:	74 0e                	je     8009cb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8009bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009c4:	89 04 24             	mov    %eax,(%esp)
  8009c7:	ff d2                	call   *%edx
  8009c9:	eb 05                	jmp    8009d0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8009cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8009d0:	83 c4 24             	add    $0x24,%esp
  8009d3:	5b                   	pop    %ebx
  8009d4:	5d                   	pop    %ebp
  8009d5:	c3                   	ret    

008009d6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	53                   	push   %ebx
  8009da:	83 ec 24             	sub    $0x24,%esp
  8009dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8009e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8009e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	89 04 24             	mov    %eax,(%esp)
  8009ed:	e8 34 fb ff ff       	call   800526 <fd_lookup>
  8009f2:	89 c2                	mov    %eax,%edx
  8009f4:	85 d2                	test   %edx,%edx
  8009f6:	78 52                	js     800a4a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a02:	8b 00                	mov    (%eax),%eax
  800a04:	89 04 24             	mov    %eax,(%esp)
  800a07:	e8 70 fb ff ff       	call   80057c <dev_lookup>
  800a0c:	85 c0                	test   %eax,%eax
  800a0e:	78 3a                	js     800a4a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a13:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800a17:	74 2c                	je     800a45 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800a19:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800a1c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800a23:	00 00 00 
	stat->st_isdir = 0;
  800a26:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800a2d:	00 00 00 
	stat->st_dev = dev;
  800a30:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800a36:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a3d:	89 14 24             	mov    %edx,(%esp)
  800a40:	ff 50 14             	call   *0x14(%eax)
  800a43:	eb 05                	jmp    800a4a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800a45:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800a4a:	83 c4 24             	add    $0x24,%esp
  800a4d:	5b                   	pop    %ebx
  800a4e:	5d                   	pop    %ebp
  800a4f:	c3                   	ret    

00800a50 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	56                   	push   %esi
  800a54:	53                   	push   %ebx
  800a55:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800a58:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800a5f:	00 
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	89 04 24             	mov    %eax,(%esp)
  800a66:	e8 84 02 00 00       	call   800cef <open>
  800a6b:	89 c3                	mov    %eax,%ebx
  800a6d:	85 db                	test   %ebx,%ebx
  800a6f:	78 1b                	js     800a8c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a74:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a78:	89 1c 24             	mov    %ebx,(%esp)
  800a7b:	e8 56 ff ff ff       	call   8009d6 <fstat>
  800a80:	89 c6                	mov    %eax,%esi
	close(fd);
  800a82:	89 1c 24             	mov    %ebx,(%esp)
  800a85:	e8 cd fb ff ff       	call   800657 <close>
	return r;
  800a8a:	89 f0                	mov    %esi,%eax
}
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	5b                   	pop    %ebx
  800a90:	5e                   	pop    %esi
  800a91:	5d                   	pop    %ebp
  800a92:	c3                   	ret    

00800a93 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	56                   	push   %esi
  800a97:	53                   	push   %ebx
  800a98:	83 ec 10             	sub    $0x10,%esp
  800a9b:	89 c6                	mov    %eax,%esi
  800a9d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800a9f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800aa6:	75 11                	jne    800ab9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800aa8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800aaf:	e8 81 18 00 00       	call   802335 <ipc_find_env>
  800ab4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800ab9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800ac0:	00 
  800ac1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800ac8:	00 
  800ac9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800acd:	a1 00 40 80 00       	mov    0x804000,%eax
  800ad2:	89 04 24             	mov    %eax,(%esp)
  800ad5:	e8 ce 17 00 00       	call   8022a8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800ada:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800ae1:	00 
  800ae2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ae6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800aed:	e8 4e 17 00 00       	call   802240 <ipc_recv>
}
  800af2:	83 c4 10             	add    $0x10,%esp
  800af5:	5b                   	pop    %ebx
  800af6:	5e                   	pop    %esi
  800af7:	5d                   	pop    %ebp
  800af8:	c3                   	ret    

00800af9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 40 0c             	mov    0xc(%eax),%eax
  800b05:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800b12:	ba 00 00 00 00       	mov    $0x0,%edx
  800b17:	b8 02 00 00 00       	mov    $0x2,%eax
  800b1c:	e8 72 ff ff ff       	call   800a93 <fsipc>
}
  800b21:	c9                   	leave  
  800b22:	c3                   	ret    

00800b23 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 40 0c             	mov    0xc(%eax),%eax
  800b2f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800b34:	ba 00 00 00 00       	mov    $0x0,%edx
  800b39:	b8 06 00 00 00       	mov    $0x6,%eax
  800b3e:	e8 50 ff ff ff       	call   800a93 <fsipc>
}
  800b43:	c9                   	leave  
  800b44:	c3                   	ret    

00800b45 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	53                   	push   %ebx
  800b49:	83 ec 14             	sub    $0x14,%esp
  800b4c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	8b 40 0c             	mov    0xc(%eax),%eax
  800b55:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800b5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5f:	b8 05 00 00 00       	mov    $0x5,%eax
  800b64:	e8 2a ff ff ff       	call   800a93 <fsipc>
  800b69:	89 c2                	mov    %eax,%edx
  800b6b:	85 d2                	test   %edx,%edx
  800b6d:	78 2b                	js     800b9a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800b6f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800b76:	00 
  800b77:	89 1c 24             	mov    %ebx,(%esp)
  800b7a:	e8 68 13 00 00       	call   801ee7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800b7f:	a1 80 50 80 00       	mov    0x805080,%eax
  800b84:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800b8a:	a1 84 50 80 00       	mov    0x805084,%eax
  800b8f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800b95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b9a:	83 c4 14             	add    $0x14,%esp
  800b9d:	5b                   	pop    %ebx
  800b9e:	5d                   	pop    %ebp
  800b9f:	c3                   	ret    

00800ba0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	53                   	push   %ebx
  800ba4:	83 ec 14             	sub    $0x14,%esp
  800ba7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	8b 40 0c             	mov    0xc(%eax),%eax
  800bb0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  800bb5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  800bbb:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  800bc0:	0f 46 c3             	cmovbe %ebx,%eax
  800bc3:	a3 04 50 80 00       	mov    %eax,0x805004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  800bc8:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcf:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bd3:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  800bda:	e8 a5 14 00 00       	call   802084 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  800bdf:	ba 00 00 00 00       	mov    $0x0,%edx
  800be4:	b8 04 00 00 00       	mov    $0x4,%eax
  800be9:	e8 a5 fe ff ff       	call   800a93 <fsipc>
  800bee:	85 c0                	test   %eax,%eax
  800bf0:	78 53                	js     800c45 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  800bf2:	39 c3                	cmp    %eax,%ebx
  800bf4:	73 24                	jae    800c1a <devfile_write+0x7a>
  800bf6:	c7 44 24 0c 08 27 80 	movl   $0x802708,0xc(%esp)
  800bfd:	00 
  800bfe:	c7 44 24 08 0f 27 80 	movl   $0x80270f,0x8(%esp)
  800c05:	00 
  800c06:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  800c0d:	00 
  800c0e:	c7 04 24 24 27 80 00 	movl   $0x802724,(%esp)
  800c15:	e8 ac 0b 00 00       	call   8017c6 <_panic>
	assert(r <= PGSIZE);
  800c1a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800c1f:	7e 24                	jle    800c45 <devfile_write+0xa5>
  800c21:	c7 44 24 0c 2f 27 80 	movl   $0x80272f,0xc(%esp)
  800c28:	00 
  800c29:	c7 44 24 08 0f 27 80 	movl   $0x80270f,0x8(%esp)
  800c30:	00 
  800c31:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  800c38:	00 
  800c39:	c7 04 24 24 27 80 00 	movl   $0x802724,(%esp)
  800c40:	e8 81 0b 00 00       	call   8017c6 <_panic>
	return r;
}
  800c45:	83 c4 14             	add    $0x14,%esp
  800c48:	5b                   	pop    %ebx
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	56                   	push   %esi
  800c4f:	53                   	push   %ebx
  800c50:	83 ec 10             	sub    $0x10,%esp
  800c53:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	8b 40 0c             	mov    0xc(%eax),%eax
  800c5c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800c61:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800c67:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6c:	b8 03 00 00 00       	mov    $0x3,%eax
  800c71:	e8 1d fe ff ff       	call   800a93 <fsipc>
  800c76:	89 c3                	mov    %eax,%ebx
  800c78:	85 c0                	test   %eax,%eax
  800c7a:	78 6a                	js     800ce6 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800c7c:	39 c6                	cmp    %eax,%esi
  800c7e:	73 24                	jae    800ca4 <devfile_read+0x59>
  800c80:	c7 44 24 0c 08 27 80 	movl   $0x802708,0xc(%esp)
  800c87:	00 
  800c88:	c7 44 24 08 0f 27 80 	movl   $0x80270f,0x8(%esp)
  800c8f:	00 
  800c90:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  800c97:	00 
  800c98:	c7 04 24 24 27 80 00 	movl   $0x802724,(%esp)
  800c9f:	e8 22 0b 00 00       	call   8017c6 <_panic>
	assert(r <= PGSIZE);
  800ca4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ca9:	7e 24                	jle    800ccf <devfile_read+0x84>
  800cab:	c7 44 24 0c 2f 27 80 	movl   $0x80272f,0xc(%esp)
  800cb2:	00 
  800cb3:	c7 44 24 08 0f 27 80 	movl   $0x80270f,0x8(%esp)
  800cba:	00 
  800cbb:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  800cc2:	00 
  800cc3:	c7 04 24 24 27 80 00 	movl   $0x802724,(%esp)
  800cca:	e8 f7 0a 00 00       	call   8017c6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800ccf:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cd3:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800cda:	00 
  800cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cde:	89 04 24             	mov    %eax,(%esp)
  800ce1:	e8 9e 13 00 00       	call   802084 <memmove>
	return r;
}
  800ce6:	89 d8                	mov    %ebx,%eax
  800ce8:	83 c4 10             	add    $0x10,%esp
  800ceb:	5b                   	pop    %ebx
  800cec:	5e                   	pop    %esi
  800ced:	5d                   	pop    %ebp
  800cee:	c3                   	ret    

00800cef <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	53                   	push   %ebx
  800cf3:	83 ec 24             	sub    $0x24,%esp
  800cf6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800cf9:	89 1c 24             	mov    %ebx,(%esp)
  800cfc:	e8 af 11 00 00       	call   801eb0 <strlen>
  800d01:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800d06:	7f 60                	jg     800d68 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800d08:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d0b:	89 04 24             	mov    %eax,(%esp)
  800d0e:	e8 c4 f7 ff ff       	call   8004d7 <fd_alloc>
  800d13:	89 c2                	mov    %eax,%edx
  800d15:	85 d2                	test   %edx,%edx
  800d17:	78 54                	js     800d6d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800d19:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d1d:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800d24:	e8 be 11 00 00       	call   801ee7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800d31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d34:	b8 01 00 00 00       	mov    $0x1,%eax
  800d39:	e8 55 fd ff ff       	call   800a93 <fsipc>
  800d3e:	89 c3                	mov    %eax,%ebx
  800d40:	85 c0                	test   %eax,%eax
  800d42:	79 17                	jns    800d5b <open+0x6c>
		fd_close(fd, 0);
  800d44:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800d4b:	00 
  800d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d4f:	89 04 24             	mov    %eax,(%esp)
  800d52:	e8 7f f8 ff ff       	call   8005d6 <fd_close>
		return r;
  800d57:	89 d8                	mov    %ebx,%eax
  800d59:	eb 12                	jmp    800d6d <open+0x7e>
	}

	return fd2num(fd);
  800d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d5e:	89 04 24             	mov    %eax,(%esp)
  800d61:	e8 4a f7 ff ff       	call   8004b0 <fd2num>
  800d66:	eb 05                	jmp    800d6d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800d68:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800d6d:	83 c4 24             	add    $0x24,%esp
  800d70:	5b                   	pop    %ebx
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    

00800d73 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800d79:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7e:	b8 08 00 00 00       	mov    $0x8,%eax
  800d83:	e8 0b fd ff ff       	call   800a93 <fsipc>
}
  800d88:	c9                   	leave  
  800d89:	c3                   	ret    
  800d8a:	66 90                	xchg   %ax,%ax
  800d8c:	66 90                	xchg   %ax,%ax
  800d8e:	66 90                	xchg   %ax,%ax

00800d90 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  800d96:	c7 44 24 04 3b 27 80 	movl   $0x80273b,0x4(%esp)
  800d9d:	00 
  800d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da1:	89 04 24             	mov    %eax,(%esp)
  800da4:	e8 3e 11 00 00       	call   801ee7 <strcpy>
	return 0;
}
  800da9:	b8 00 00 00 00       	mov    $0x0,%eax
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	53                   	push   %ebx
  800db4:	83 ec 14             	sub    $0x14,%esp
  800db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800dba:	89 1c 24             	mov    %ebx,(%esp)
  800dbd:	e8 ad 15 00 00       	call   80236f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  800dc2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  800dc7:	83 f8 01             	cmp    $0x1,%eax
  800dca:	75 0d                	jne    800dd9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  800dcc:	8b 43 0c             	mov    0xc(%ebx),%eax
  800dcf:	89 04 24             	mov    %eax,(%esp)
  800dd2:	e8 29 03 00 00       	call   801100 <nsipc_close>
  800dd7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  800dd9:	89 d0                	mov    %edx,%eax
  800ddb:	83 c4 14             	add    $0x14,%esp
  800dde:	5b                   	pop    %ebx
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    

00800de1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800de7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800dee:	00 
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	89 44 24 08          	mov    %eax,0x8(%esp)
  800df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8b 40 0c             	mov    0xc(%eax),%eax
  800e03:	89 04 24             	mov    %eax,(%esp)
  800e06:	e8 f0 03 00 00       	call   8011fb <nsipc_send>
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800e13:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800e1a:	00 
  800e1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e25:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8b 40 0c             	mov    0xc(%eax),%eax
  800e2f:	89 04 24             	mov    %eax,(%esp)
  800e32:	e8 44 03 00 00       	call   80117b <nsipc_recv>
}
  800e37:	c9                   	leave  
  800e38:	c3                   	ret    

00800e39 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  800e3f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800e42:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e46:	89 04 24             	mov    %eax,(%esp)
  800e49:	e8 d8 f6 ff ff       	call   800526 <fd_lookup>
  800e4e:	85 c0                	test   %eax,%eax
  800e50:	78 17                	js     800e69 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  800e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e55:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800e5b:	39 08                	cmp    %ecx,(%eax)
  800e5d:	75 05                	jne    800e64 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  800e5f:	8b 40 0c             	mov    0xc(%eax),%eax
  800e62:	eb 05                	jmp    800e69 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  800e64:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  800e69:	c9                   	leave  
  800e6a:	c3                   	ret    

00800e6b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	56                   	push   %esi
  800e6f:	53                   	push   %ebx
  800e70:	83 ec 20             	sub    $0x20,%esp
  800e73:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800e75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e78:	89 04 24             	mov    %eax,(%esp)
  800e7b:	e8 57 f6 ff ff       	call   8004d7 <fd_alloc>
  800e80:	89 c3                	mov    %eax,%ebx
  800e82:	85 c0                	test   %eax,%eax
  800e84:	78 21                	js     800ea7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800e86:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800e8d:	00 
  800e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e91:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800e9c:	e8 cb f2 ff ff       	call   80016c <sys_page_alloc>
  800ea1:	89 c3                	mov    %eax,%ebx
  800ea3:	85 c0                	test   %eax,%eax
  800ea5:	79 0c                	jns    800eb3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  800ea7:	89 34 24             	mov    %esi,(%esp)
  800eaa:	e8 51 02 00 00       	call   801100 <nsipc_close>
		return r;
  800eaf:	89 d8                	mov    %ebx,%eax
  800eb1:	eb 20                	jmp    800ed3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  800eb3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800ebe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  800ec8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  800ecb:	89 14 24             	mov    %edx,(%esp)
  800ece:	e8 dd f5 ff ff       	call   8004b0 <fd2num>
}
  800ed3:	83 c4 20             	add    $0x20,%esp
  800ed6:	5b                   	pop    %ebx
  800ed7:	5e                   	pop    %esi
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    

00800eda <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	e8 51 ff ff ff       	call   800e39 <fd2sockid>
		return r;
  800ee8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  800eea:	85 c0                	test   %eax,%eax
  800eec:	78 23                	js     800f11 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800eee:	8b 55 10             	mov    0x10(%ebp),%edx
  800ef1:	89 54 24 08          	mov    %edx,0x8(%esp)
  800ef5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef8:	89 54 24 04          	mov    %edx,0x4(%esp)
  800efc:	89 04 24             	mov    %eax,(%esp)
  800eff:	e8 45 01 00 00       	call   801049 <nsipc_accept>
		return r;
  800f04:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800f06:	85 c0                	test   %eax,%eax
  800f08:	78 07                	js     800f11 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  800f0a:	e8 5c ff ff ff       	call   800e6b <alloc_sockfd>
  800f0f:	89 c1                	mov    %eax,%ecx
}
  800f11:	89 c8                	mov    %ecx,%eax
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	e8 16 ff ff ff       	call   800e39 <fd2sockid>
  800f23:	89 c2                	mov    %eax,%edx
  800f25:	85 d2                	test   %edx,%edx
  800f27:	78 16                	js     800f3f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  800f29:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f33:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f37:	89 14 24             	mov    %edx,(%esp)
  800f3a:	e8 60 01 00 00       	call   80109f <nsipc_bind>
}
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <shutdown>:

int
shutdown(int s, int how)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	e8 ea fe ff ff       	call   800e39 <fd2sockid>
  800f4f:	89 c2                	mov    %eax,%edx
  800f51:	85 d2                	test   %edx,%edx
  800f53:	78 0f                	js     800f64 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f5c:	89 14 24             	mov    %edx,(%esp)
  800f5f:	e8 7a 01 00 00       	call   8010de <nsipc_shutdown>
}
  800f64:	c9                   	leave  
  800f65:	c3                   	ret    

00800f66 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	e8 c5 fe ff ff       	call   800e39 <fd2sockid>
  800f74:	89 c2                	mov    %eax,%edx
  800f76:	85 d2                	test   %edx,%edx
  800f78:	78 16                	js     800f90 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  800f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f84:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f88:	89 14 24             	mov    %edx,(%esp)
  800f8b:	e8 8a 01 00 00       	call   80111a <nsipc_connect>
}
  800f90:	c9                   	leave  
  800f91:	c3                   	ret    

00800f92 <listen>:

int
listen(int s, int backlog)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	e8 99 fe ff ff       	call   800e39 <fd2sockid>
  800fa0:	89 c2                	mov    %eax,%edx
  800fa2:	85 d2                	test   %edx,%edx
  800fa4:	78 0f                	js     800fb5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  800fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fad:	89 14 24             	mov    %edx,(%esp)
  800fb0:	e8 a4 01 00 00       	call   801159 <nsipc_listen>
}
  800fb5:	c9                   	leave  
  800fb6:	c3                   	ret    

00800fb7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800fbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc0:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	89 04 24             	mov    %eax,(%esp)
  800fd1:	e8 98 02 00 00       	call   80126e <nsipc_socket>
  800fd6:	89 c2                	mov    %eax,%edx
  800fd8:	85 d2                	test   %edx,%edx
  800fda:	78 05                	js     800fe1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  800fdc:	e8 8a fe ff ff       	call   800e6b <alloc_sockfd>
}
  800fe1:	c9                   	leave  
  800fe2:	c3                   	ret    

00800fe3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800fe3:	55                   	push   %ebp
  800fe4:	89 e5                	mov    %esp,%ebp
  800fe6:	53                   	push   %ebx
  800fe7:	83 ec 14             	sub    $0x14,%esp
  800fea:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800fec:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800ff3:	75 11                	jne    801006 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800ff5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800ffc:	e8 34 13 00 00       	call   802335 <ipc_find_env>
  801001:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801006:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80100d:	00 
  80100e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801015:	00 
  801016:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80101a:	a1 04 40 80 00       	mov    0x804004,%eax
  80101f:	89 04 24             	mov    %eax,(%esp)
  801022:	e8 81 12 00 00       	call   8022a8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801027:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80102e:	00 
  80102f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801036:	00 
  801037:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80103e:	e8 fd 11 00 00       	call   802240 <ipc_recv>
}
  801043:	83 c4 14             	add    $0x14,%esp
  801046:	5b                   	pop    %ebx
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    

00801049 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	56                   	push   %esi
  80104d:	53                   	push   %ebx
  80104e:	83 ec 10             	sub    $0x10,%esp
  801051:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80105c:	8b 06                	mov    (%esi),%eax
  80105e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801063:	b8 01 00 00 00       	mov    $0x1,%eax
  801068:	e8 76 ff ff ff       	call   800fe3 <nsipc>
  80106d:	89 c3                	mov    %eax,%ebx
  80106f:	85 c0                	test   %eax,%eax
  801071:	78 23                	js     801096 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801073:	a1 10 60 80 00       	mov    0x806010,%eax
  801078:	89 44 24 08          	mov    %eax,0x8(%esp)
  80107c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801083:	00 
  801084:	8b 45 0c             	mov    0xc(%ebp),%eax
  801087:	89 04 24             	mov    %eax,(%esp)
  80108a:	e8 f5 0f 00 00       	call   802084 <memmove>
		*addrlen = ret->ret_addrlen;
  80108f:	a1 10 60 80 00       	mov    0x806010,%eax
  801094:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801096:	89 d8                	mov    %ebx,%eax
  801098:	83 c4 10             	add    $0x10,%esp
  80109b:	5b                   	pop    %ebx
  80109c:	5e                   	pop    %esi
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    

0080109f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	53                   	push   %ebx
  8010a3:	83 ec 14             	sub    $0x14,%esp
  8010a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8010b1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8010b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010bc:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8010c3:	e8 bc 0f 00 00       	call   802084 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8010c8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8010ce:	b8 02 00 00 00       	mov    $0x2,%eax
  8010d3:	e8 0b ff ff ff       	call   800fe3 <nsipc>
}
  8010d8:	83 c4 14             	add    $0x14,%esp
  8010db:	5b                   	pop    %ebx
  8010dc:	5d                   	pop    %ebp
  8010dd:	c3                   	ret    

008010de <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8010ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ef:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8010f4:	b8 03 00 00 00       	mov    $0x3,%eax
  8010f9:	e8 e5 fe ff ff       	call   800fe3 <nsipc>
}
  8010fe:	c9                   	leave  
  8010ff:	c3                   	ret    

00801100 <nsipc_close>:

int
nsipc_close(int s)
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80110e:	b8 04 00 00 00       	mov    $0x4,%eax
  801113:	e8 cb fe ff ff       	call   800fe3 <nsipc>
}
  801118:	c9                   	leave  
  801119:	c3                   	ret    

0080111a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	53                   	push   %ebx
  80111e:	83 ec 14             	sub    $0x14,%esp
  801121:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80112c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	89 44 24 04          	mov    %eax,0x4(%esp)
  801137:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  80113e:	e8 41 0f 00 00       	call   802084 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801143:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801149:	b8 05 00 00 00       	mov    $0x5,%eax
  80114e:	e8 90 fe ff ff       	call   800fe3 <nsipc>
}
  801153:	83 c4 14             	add    $0x14,%esp
  801156:	5b                   	pop    %ebx
  801157:	5d                   	pop    %ebp
  801158:	c3                   	ret    

00801159 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
  80115c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80116f:	b8 06 00 00 00       	mov    $0x6,%eax
  801174:	e8 6a fe ff ff       	call   800fe3 <nsipc>
}
  801179:	c9                   	leave  
  80117a:	c3                   	ret    

0080117b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	56                   	push   %esi
  80117f:	53                   	push   %ebx
  801180:	83 ec 10             	sub    $0x10,%esp
  801183:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80118e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801194:	8b 45 14             	mov    0x14(%ebp),%eax
  801197:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80119c:	b8 07 00 00 00       	mov    $0x7,%eax
  8011a1:	e8 3d fe ff ff       	call   800fe3 <nsipc>
  8011a6:	89 c3                	mov    %eax,%ebx
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	78 46                	js     8011f2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8011ac:	39 f0                	cmp    %esi,%eax
  8011ae:	7f 07                	jg     8011b7 <nsipc_recv+0x3c>
  8011b0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8011b5:	7e 24                	jle    8011db <nsipc_recv+0x60>
  8011b7:	c7 44 24 0c 47 27 80 	movl   $0x802747,0xc(%esp)
  8011be:	00 
  8011bf:	c7 44 24 08 0f 27 80 	movl   $0x80270f,0x8(%esp)
  8011c6:	00 
  8011c7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8011ce:	00 
  8011cf:	c7 04 24 5c 27 80 00 	movl   $0x80275c,(%esp)
  8011d6:	e8 eb 05 00 00       	call   8017c6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8011db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011df:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8011e6:	00 
  8011e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ea:	89 04 24             	mov    %eax,(%esp)
  8011ed:	e8 92 0e 00 00       	call   802084 <memmove>
	}

	return r;
}
  8011f2:	89 d8                	mov    %ebx,%eax
  8011f4:	83 c4 10             	add    $0x10,%esp
  8011f7:	5b                   	pop    %ebx
  8011f8:	5e                   	pop    %esi
  8011f9:	5d                   	pop    %ebp
  8011fa:	c3                   	ret    

008011fb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	53                   	push   %ebx
  8011ff:	83 ec 14             	sub    $0x14,%esp
  801202:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80120d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801213:	7e 24                	jle    801239 <nsipc_send+0x3e>
  801215:	c7 44 24 0c 68 27 80 	movl   $0x802768,0xc(%esp)
  80121c:	00 
  80121d:	c7 44 24 08 0f 27 80 	movl   $0x80270f,0x8(%esp)
  801224:	00 
  801225:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80122c:	00 
  80122d:	c7 04 24 5c 27 80 00 	movl   $0x80275c,(%esp)
  801234:	e8 8d 05 00 00       	call   8017c6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801239:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80123d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801240:	89 44 24 04          	mov    %eax,0x4(%esp)
  801244:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80124b:	e8 34 0e 00 00       	call   802084 <memmove>
	nsipcbuf.send.req_size = size;
  801250:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801256:	8b 45 14             	mov    0x14(%ebp),%eax
  801259:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80125e:	b8 08 00 00 00       	mov    $0x8,%eax
  801263:	e8 7b fd ff ff       	call   800fe3 <nsipc>
}
  801268:	83 c4 14             	add    $0x14,%esp
  80126b:	5b                   	pop    %ebx
  80126c:	5d                   	pop    %ebp
  80126d:	c3                   	ret    

0080126e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80127c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801284:	8b 45 10             	mov    0x10(%ebp),%eax
  801287:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80128c:	b8 09 00 00 00       	mov    $0x9,%eax
  801291:	e8 4d fd ff ff       	call   800fe3 <nsipc>
}
  801296:	c9                   	leave  
  801297:	c3                   	ret    

00801298 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
  80129b:	56                   	push   %esi
  80129c:	53                   	push   %ebx
  80129d:	83 ec 10             	sub    $0x10,%esp
  8012a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	89 04 24             	mov    %eax,(%esp)
  8012a9:	e8 12 f2 ff ff       	call   8004c0 <fd2data>
  8012ae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8012b0:	c7 44 24 04 74 27 80 	movl   $0x802774,0x4(%esp)
  8012b7:	00 
  8012b8:	89 1c 24             	mov    %ebx,(%esp)
  8012bb:	e8 27 0c 00 00       	call   801ee7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8012c0:	8b 46 04             	mov    0x4(%esi),%eax
  8012c3:	2b 06                	sub    (%esi),%eax
  8012c5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8012cb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012d2:	00 00 00 
	stat->st_dev = &devpipe;
  8012d5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  8012dc:	30 80 00 
	return 0;
}
  8012df:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e4:	83 c4 10             	add    $0x10,%esp
  8012e7:	5b                   	pop    %ebx
  8012e8:	5e                   	pop    %esi
  8012e9:	5d                   	pop    %ebp
  8012ea:	c3                   	ret    

008012eb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	53                   	push   %ebx
  8012ef:	83 ec 14             	sub    $0x14,%esp
  8012f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8012f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801300:	e8 0e ef ff ff       	call   800213 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801305:	89 1c 24             	mov    %ebx,(%esp)
  801308:	e8 b3 f1 ff ff       	call   8004c0 <fd2data>
  80130d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801311:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801318:	e8 f6 ee ff ff       	call   800213 <sys_page_unmap>
}
  80131d:	83 c4 14             	add    $0x14,%esp
  801320:	5b                   	pop    %ebx
  801321:	5d                   	pop    %ebp
  801322:	c3                   	ret    

00801323 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
  801326:	57                   	push   %edi
  801327:	56                   	push   %esi
  801328:	53                   	push   %ebx
  801329:	83 ec 2c             	sub    $0x2c,%esp
  80132c:	89 c6                	mov    %eax,%esi
  80132e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801331:	a1 08 40 80 00       	mov    0x804008,%eax
  801336:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801339:	89 34 24             	mov    %esi,(%esp)
  80133c:	e8 2e 10 00 00       	call   80236f <pageref>
  801341:	89 c7                	mov    %eax,%edi
  801343:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801346:	89 04 24             	mov    %eax,(%esp)
  801349:	e8 21 10 00 00       	call   80236f <pageref>
  80134e:	39 c7                	cmp    %eax,%edi
  801350:	0f 94 c2             	sete   %dl
  801353:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801356:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  80135c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80135f:	39 fb                	cmp    %edi,%ebx
  801361:	74 21                	je     801384 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801363:	84 d2                	test   %dl,%dl
  801365:	74 ca                	je     801331 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801367:	8b 51 58             	mov    0x58(%ecx),%edx
  80136a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80136e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801372:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801376:	c7 04 24 7b 27 80 00 	movl   $0x80277b,(%esp)
  80137d:	e8 3d 05 00 00       	call   8018bf <cprintf>
  801382:	eb ad                	jmp    801331 <_pipeisclosed+0xe>
	}
}
  801384:	83 c4 2c             	add    $0x2c,%esp
  801387:	5b                   	pop    %ebx
  801388:	5e                   	pop    %esi
  801389:	5f                   	pop    %edi
  80138a:	5d                   	pop    %ebp
  80138b:	c3                   	ret    

0080138c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	57                   	push   %edi
  801390:	56                   	push   %esi
  801391:	53                   	push   %ebx
  801392:	83 ec 1c             	sub    $0x1c,%esp
  801395:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801398:	89 34 24             	mov    %esi,(%esp)
  80139b:	e8 20 f1 ff ff       	call   8004c0 <fd2data>
  8013a0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8013a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8013a7:	eb 45                	jmp    8013ee <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8013a9:	89 da                	mov    %ebx,%edx
  8013ab:	89 f0                	mov    %esi,%eax
  8013ad:	e8 71 ff ff ff       	call   801323 <_pipeisclosed>
  8013b2:	85 c0                	test   %eax,%eax
  8013b4:	75 41                	jne    8013f7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8013b6:	e8 92 ed ff ff       	call   80014d <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8013bb:	8b 43 04             	mov    0x4(%ebx),%eax
  8013be:	8b 0b                	mov    (%ebx),%ecx
  8013c0:	8d 51 20             	lea    0x20(%ecx),%edx
  8013c3:	39 d0                	cmp    %edx,%eax
  8013c5:	73 e2                	jae    8013a9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8013c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ca:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8013ce:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8013d1:	99                   	cltd   
  8013d2:	c1 ea 1b             	shr    $0x1b,%edx
  8013d5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8013d8:	83 e1 1f             	and    $0x1f,%ecx
  8013db:	29 d1                	sub    %edx,%ecx
  8013dd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8013e1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8013e5:	83 c0 01             	add    $0x1,%eax
  8013e8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8013eb:	83 c7 01             	add    $0x1,%edi
  8013ee:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8013f1:	75 c8                	jne    8013bb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8013f3:	89 f8                	mov    %edi,%eax
  8013f5:	eb 05                	jmp    8013fc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8013f7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8013fc:	83 c4 1c             	add    $0x1c,%esp
  8013ff:	5b                   	pop    %ebx
  801400:	5e                   	pop    %esi
  801401:	5f                   	pop    %edi
  801402:	5d                   	pop    %ebp
  801403:	c3                   	ret    

00801404 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	57                   	push   %edi
  801408:	56                   	push   %esi
  801409:	53                   	push   %ebx
  80140a:	83 ec 1c             	sub    $0x1c,%esp
  80140d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801410:	89 3c 24             	mov    %edi,(%esp)
  801413:	e8 a8 f0 ff ff       	call   8004c0 <fd2data>
  801418:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80141a:	be 00 00 00 00       	mov    $0x0,%esi
  80141f:	eb 3d                	jmp    80145e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801421:	85 f6                	test   %esi,%esi
  801423:	74 04                	je     801429 <devpipe_read+0x25>
				return i;
  801425:	89 f0                	mov    %esi,%eax
  801427:	eb 43                	jmp    80146c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801429:	89 da                	mov    %ebx,%edx
  80142b:	89 f8                	mov    %edi,%eax
  80142d:	e8 f1 fe ff ff       	call   801323 <_pipeisclosed>
  801432:	85 c0                	test   %eax,%eax
  801434:	75 31                	jne    801467 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801436:	e8 12 ed ff ff       	call   80014d <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80143b:	8b 03                	mov    (%ebx),%eax
  80143d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801440:	74 df                	je     801421 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801442:	99                   	cltd   
  801443:	c1 ea 1b             	shr    $0x1b,%edx
  801446:	01 d0                	add    %edx,%eax
  801448:	83 e0 1f             	and    $0x1f,%eax
  80144b:	29 d0                	sub    %edx,%eax
  80144d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801452:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801455:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801458:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80145b:	83 c6 01             	add    $0x1,%esi
  80145e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801461:	75 d8                	jne    80143b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801463:	89 f0                	mov    %esi,%eax
  801465:	eb 05                	jmp    80146c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801467:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80146c:	83 c4 1c             	add    $0x1c,%esp
  80146f:	5b                   	pop    %ebx
  801470:	5e                   	pop    %esi
  801471:	5f                   	pop    %edi
  801472:	5d                   	pop    %ebp
  801473:	c3                   	ret    

00801474 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	56                   	push   %esi
  801478:	53                   	push   %ebx
  801479:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80147c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147f:	89 04 24             	mov    %eax,(%esp)
  801482:	e8 50 f0 ff ff       	call   8004d7 <fd_alloc>
  801487:	89 c2                	mov    %eax,%edx
  801489:	85 d2                	test   %edx,%edx
  80148b:	0f 88 4d 01 00 00    	js     8015de <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801491:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801498:	00 
  801499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014a7:	e8 c0 ec ff ff       	call   80016c <sys_page_alloc>
  8014ac:	89 c2                	mov    %eax,%edx
  8014ae:	85 d2                	test   %edx,%edx
  8014b0:	0f 88 28 01 00 00    	js     8015de <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8014b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014b9:	89 04 24             	mov    %eax,(%esp)
  8014bc:	e8 16 f0 ff ff       	call   8004d7 <fd_alloc>
  8014c1:	89 c3                	mov    %eax,%ebx
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	0f 88 fe 00 00 00    	js     8015c9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8014cb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8014d2:	00 
  8014d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014e1:	e8 86 ec ff ff       	call   80016c <sys_page_alloc>
  8014e6:	89 c3                	mov    %eax,%ebx
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	0f 88 d9 00 00 00    	js     8015c9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8014f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f3:	89 04 24             	mov    %eax,(%esp)
  8014f6:	e8 c5 ef ff ff       	call   8004c0 <fd2data>
  8014fb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8014fd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801504:	00 
  801505:	89 44 24 04          	mov    %eax,0x4(%esp)
  801509:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801510:	e8 57 ec ff ff       	call   80016c <sys_page_alloc>
  801515:	89 c3                	mov    %eax,%ebx
  801517:	85 c0                	test   %eax,%eax
  801519:	0f 88 97 00 00 00    	js     8015b6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80151f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801522:	89 04 24             	mov    %eax,(%esp)
  801525:	e8 96 ef ff ff       	call   8004c0 <fd2data>
  80152a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801531:	00 
  801532:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801536:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80153d:	00 
  80153e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801542:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801549:	e8 72 ec ff ff       	call   8001c0 <sys_page_map>
  80154e:	89 c3                	mov    %eax,%ebx
  801550:	85 c0                	test   %eax,%eax
  801552:	78 52                	js     8015a6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801554:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80155a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80155f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801562:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801569:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80156f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801572:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801577:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80157e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801581:	89 04 24             	mov    %eax,(%esp)
  801584:	e8 27 ef ff ff       	call   8004b0 <fd2num>
  801589:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80158c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80158e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801591:	89 04 24             	mov    %eax,(%esp)
  801594:	e8 17 ef ff ff       	call   8004b0 <fd2num>
  801599:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80159c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80159f:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a4:	eb 38                	jmp    8015de <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8015a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015b1:	e8 5d ec ff ff       	call   800213 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8015b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015c4:	e8 4a ec ff ff       	call   800213 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8015c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015d7:	e8 37 ec ff ff       	call   800213 <sys_page_unmap>
  8015dc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8015de:	83 c4 30             	add    $0x30,%esp
  8015e1:	5b                   	pop    %ebx
  8015e2:	5e                   	pop    %esi
  8015e3:	5d                   	pop    %ebp
  8015e4:	c3                   	ret    

008015e5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	89 04 24             	mov    %eax,(%esp)
  8015f8:	e8 29 ef ff ff       	call   800526 <fd_lookup>
  8015fd:	89 c2                	mov    %eax,%edx
  8015ff:	85 d2                	test   %edx,%edx
  801601:	78 15                	js     801618 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801606:	89 04 24             	mov    %eax,(%esp)
  801609:	e8 b2 ee ff ff       	call   8004c0 <fd2data>
	return _pipeisclosed(fd, p);
  80160e:	89 c2                	mov    %eax,%edx
  801610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801613:	e8 0b fd ff ff       	call   801323 <_pipeisclosed>
}
  801618:	c9                   	leave  
  801619:	c3                   	ret    
  80161a:	66 90                	xchg   %ax,%ax
  80161c:	66 90                	xchg   %ax,%ax
  80161e:	66 90                	xchg   %ax,%ax

00801620 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801623:	b8 00 00 00 00       	mov    $0x0,%eax
  801628:	5d                   	pop    %ebp
  801629:	c3                   	ret    

0080162a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801630:	c7 44 24 04 93 27 80 	movl   $0x802793,0x4(%esp)
  801637:	00 
  801638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163b:	89 04 24             	mov    %eax,(%esp)
  80163e:	e8 a4 08 00 00       	call   801ee7 <strcpy>
	return 0;
}
  801643:	b8 00 00 00 00       	mov    $0x0,%eax
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	57                   	push   %edi
  80164e:	56                   	push   %esi
  80164f:	53                   	push   %ebx
  801650:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801656:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80165b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801661:	eb 31                	jmp    801694 <devcons_write+0x4a>
		m = n - tot;
  801663:	8b 75 10             	mov    0x10(%ebp),%esi
  801666:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  801668:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80166b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801670:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801673:	89 74 24 08          	mov    %esi,0x8(%esp)
  801677:	03 45 0c             	add    0xc(%ebp),%eax
  80167a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80167e:	89 3c 24             	mov    %edi,(%esp)
  801681:	e8 fe 09 00 00       	call   802084 <memmove>
		sys_cputs(buf, m);
  801686:	89 74 24 04          	mov    %esi,0x4(%esp)
  80168a:	89 3c 24             	mov    %edi,(%esp)
  80168d:	e8 0d ea ff ff       	call   80009f <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801692:	01 f3                	add    %esi,%ebx
  801694:	89 d8                	mov    %ebx,%eax
  801696:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801699:	72 c8                	jb     801663 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80169b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8016a1:	5b                   	pop    %ebx
  8016a2:	5e                   	pop    %esi
  8016a3:	5f                   	pop    %edi
  8016a4:	5d                   	pop    %ebp
  8016a5:	c3                   	ret    

008016a6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8016ac:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8016b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016b5:	75 07                	jne    8016be <devcons_read+0x18>
  8016b7:	eb 2a                	jmp    8016e3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8016b9:	e8 8f ea ff ff       	call   80014d <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8016be:	66 90                	xchg   %ax,%ax
  8016c0:	e8 f8 e9 ff ff       	call   8000bd <sys_cgetc>
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	74 f0                	je     8016b9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	78 16                	js     8016e3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8016cd:	83 f8 04             	cmp    $0x4,%eax
  8016d0:	74 0c                	je     8016de <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8016d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d5:	88 02                	mov    %al,(%edx)
	return 1;
  8016d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8016dc:	eb 05                	jmp    8016e3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8016de:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    

008016e5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
  8016e8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8016f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016f8:	00 
  8016f9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8016fc:	89 04 24             	mov    %eax,(%esp)
  8016ff:	e8 9b e9 ff ff       	call   80009f <sys_cputs>
}
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <getchar>:

int
getchar(void)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
  801709:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80170c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801713:	00 
  801714:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801717:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801722:	e8 93 f0 ff ff       	call   8007ba <read>
	if (r < 0)
  801727:	85 c0                	test   %eax,%eax
  801729:	78 0f                	js     80173a <getchar+0x34>
		return r;
	if (r < 1)
  80172b:	85 c0                	test   %eax,%eax
  80172d:	7e 06                	jle    801735 <getchar+0x2f>
		return -E_EOF;
	return c;
  80172f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801733:	eb 05                	jmp    80173a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801735:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801742:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801745:	89 44 24 04          	mov    %eax,0x4(%esp)
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	89 04 24             	mov    %eax,(%esp)
  80174f:	e8 d2 ed ff ff       	call   800526 <fd_lookup>
  801754:	85 c0                	test   %eax,%eax
  801756:	78 11                	js     801769 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801761:	39 10                	cmp    %edx,(%eax)
  801763:	0f 94 c0             	sete   %al
  801766:	0f b6 c0             	movzbl %al,%eax
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <opencons>:

int
opencons(void)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801771:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801774:	89 04 24             	mov    %eax,(%esp)
  801777:	e8 5b ed ff ff       	call   8004d7 <fd_alloc>
		return r;
  80177c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80177e:	85 c0                	test   %eax,%eax
  801780:	78 40                	js     8017c2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801782:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801789:	00 
  80178a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801791:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801798:	e8 cf e9 ff ff       	call   80016c <sys_page_alloc>
		return r;
  80179d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80179f:	85 c0                	test   %eax,%eax
  8017a1:	78 1f                	js     8017c2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8017a3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8017a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8017ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8017b8:	89 04 24             	mov    %eax,(%esp)
  8017bb:	e8 f0 ec ff ff       	call   8004b0 <fd2num>
  8017c0:	89 c2                	mov    %eax,%edx
}
  8017c2:	89 d0                	mov    %edx,%eax
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	56                   	push   %esi
  8017ca:	53                   	push   %ebx
  8017cb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8017ce:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8017d1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8017d7:	e8 52 e9 ff ff       	call   80012e <sys_getenvid>
  8017dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017df:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8017e6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8017ea:	89 74 24 08          	mov    %esi,0x8(%esp)
  8017ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f2:	c7 04 24 a0 27 80 00 	movl   $0x8027a0,(%esp)
  8017f9:	e8 c1 00 00 00       	call   8018bf <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8017fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801802:	8b 45 10             	mov    0x10(%ebp),%eax
  801805:	89 04 24             	mov    %eax,(%esp)
  801808:	e8 51 00 00 00       	call   80185e <vcprintf>
	cprintf("\n");
  80180d:	c7 04 24 8c 27 80 00 	movl   $0x80278c,(%esp)
  801814:	e8 a6 00 00 00       	call   8018bf <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801819:	cc                   	int3   
  80181a:	eb fd                	jmp    801819 <_panic+0x53>

0080181c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	53                   	push   %ebx
  801820:	83 ec 14             	sub    $0x14,%esp
  801823:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801826:	8b 13                	mov    (%ebx),%edx
  801828:	8d 42 01             	lea    0x1(%edx),%eax
  80182b:	89 03                	mov    %eax,(%ebx)
  80182d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801830:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801834:	3d ff 00 00 00       	cmp    $0xff,%eax
  801839:	75 19                	jne    801854 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80183b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801842:	00 
  801843:	8d 43 08             	lea    0x8(%ebx),%eax
  801846:	89 04 24             	mov    %eax,(%esp)
  801849:	e8 51 e8 ff ff       	call   80009f <sys_cputs>
		b->idx = 0;
  80184e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801854:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801858:	83 c4 14             	add    $0x14,%esp
  80185b:	5b                   	pop    %ebx
  80185c:	5d                   	pop    %ebp
  80185d:	c3                   	ret    

0080185e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801867:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80186e:	00 00 00 
	b.cnt = 0;
  801871:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801878:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80187b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	89 44 24 08          	mov    %eax,0x8(%esp)
  801889:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80188f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801893:	c7 04 24 1c 18 80 00 	movl   $0x80181c,(%esp)
  80189a:	e8 af 01 00 00       	call   801a4e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80189f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8018a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8018af:	89 04 24             	mov    %eax,(%esp)
  8018b2:	e8 e8 e7 ff ff       	call   80009f <sys_cputs>

	return b.cnt;
}
  8018b7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8018c5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8018c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	89 04 24             	mov    %eax,(%esp)
  8018d2:	e8 87 ff ff ff       	call   80185e <vcprintf>
	va_end(ap);

	return cnt;
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    
  8018d9:	66 90                	xchg   %ax,%ax
  8018db:	66 90                	xchg   %ax,%ax
  8018dd:	66 90                	xchg   %ax,%ax
  8018df:	90                   	nop

008018e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	57                   	push   %edi
  8018e4:	56                   	push   %esi
  8018e5:	53                   	push   %ebx
  8018e6:	83 ec 3c             	sub    $0x3c,%esp
  8018e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018ec:	89 d7                	mov    %edx,%edi
  8018ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f7:	89 c3                	mov    %eax,%ebx
  8018f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8018fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ff:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801902:	b9 00 00 00 00       	mov    $0x0,%ecx
  801907:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80190a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80190d:	39 d9                	cmp    %ebx,%ecx
  80190f:	72 05                	jb     801916 <printnum+0x36>
  801911:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801914:	77 69                	ja     80197f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801916:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801919:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80191d:	83 ee 01             	sub    $0x1,%esi
  801920:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801924:	89 44 24 08          	mov    %eax,0x8(%esp)
  801928:	8b 44 24 08          	mov    0x8(%esp),%eax
  80192c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801930:	89 c3                	mov    %eax,%ebx
  801932:	89 d6                	mov    %edx,%esi
  801934:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801937:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80193a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80193e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801942:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801945:	89 04 24             	mov    %eax,(%esp)
  801948:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80194b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194f:	e8 5c 0a 00 00       	call   8023b0 <__udivdi3>
  801954:	89 d9                	mov    %ebx,%ecx
  801956:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80195a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80195e:	89 04 24             	mov    %eax,(%esp)
  801961:	89 54 24 04          	mov    %edx,0x4(%esp)
  801965:	89 fa                	mov    %edi,%edx
  801967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80196a:	e8 71 ff ff ff       	call   8018e0 <printnum>
  80196f:	eb 1b                	jmp    80198c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801971:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801975:	8b 45 18             	mov    0x18(%ebp),%eax
  801978:	89 04 24             	mov    %eax,(%esp)
  80197b:	ff d3                	call   *%ebx
  80197d:	eb 03                	jmp    801982 <printnum+0xa2>
  80197f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801982:	83 ee 01             	sub    $0x1,%esi
  801985:	85 f6                	test   %esi,%esi
  801987:	7f e8                	jg     801971 <printnum+0x91>
  801989:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80198c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801990:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801994:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801997:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80199a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80199e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8019a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019a5:	89 04 24             	mov    %eax,(%esp)
  8019a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019af:	e8 2c 0b 00 00       	call   8024e0 <__umoddi3>
  8019b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019b8:	0f be 80 c3 27 80 00 	movsbl 0x8027c3(%eax),%eax
  8019bf:	89 04 24             	mov    %eax,(%esp)
  8019c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019c5:	ff d0                	call   *%eax
}
  8019c7:	83 c4 3c             	add    $0x3c,%esp
  8019ca:	5b                   	pop    %ebx
  8019cb:	5e                   	pop    %esi
  8019cc:	5f                   	pop    %edi
  8019cd:	5d                   	pop    %ebp
  8019ce:	c3                   	ret    

008019cf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019d2:	83 fa 01             	cmp    $0x1,%edx
  8019d5:	7e 0e                	jle    8019e5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8019d7:	8b 10                	mov    (%eax),%edx
  8019d9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8019dc:	89 08                	mov    %ecx,(%eax)
  8019de:	8b 02                	mov    (%edx),%eax
  8019e0:	8b 52 04             	mov    0x4(%edx),%edx
  8019e3:	eb 22                	jmp    801a07 <getuint+0x38>
	else if (lflag)
  8019e5:	85 d2                	test   %edx,%edx
  8019e7:	74 10                	je     8019f9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8019e9:	8b 10                	mov    (%eax),%edx
  8019eb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8019ee:	89 08                	mov    %ecx,(%eax)
  8019f0:	8b 02                	mov    (%edx),%eax
  8019f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f7:	eb 0e                	jmp    801a07 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8019f9:	8b 10                	mov    (%eax),%edx
  8019fb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8019fe:	89 08                	mov    %ecx,(%eax)
  801a00:	8b 02                	mov    (%edx),%eax
  801a02:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a07:	5d                   	pop    %ebp
  801a08:	c3                   	ret    

00801a09 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801a0f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801a13:	8b 10                	mov    (%eax),%edx
  801a15:	3b 50 04             	cmp    0x4(%eax),%edx
  801a18:	73 0a                	jae    801a24 <sprintputch+0x1b>
		*b->buf++ = ch;
  801a1a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a1d:	89 08                	mov    %ecx,(%eax)
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	88 02                	mov    %al,(%edx)
}
  801a24:	5d                   	pop    %ebp
  801a25:	c3                   	ret    

00801a26 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801a2c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801a2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a33:	8b 45 10             	mov    0x10(%ebp),%eax
  801a36:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	89 04 24             	mov    %eax,(%esp)
  801a47:	e8 02 00 00 00       	call   801a4e <vprintfmt>
	va_end(ap);
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	57                   	push   %edi
  801a52:	56                   	push   %esi
  801a53:	53                   	push   %ebx
  801a54:	83 ec 3c             	sub    $0x3c,%esp
  801a57:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801a5a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a5d:	eb 14                	jmp    801a73 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801a5f:	85 c0                	test   %eax,%eax
  801a61:	0f 84 b3 03 00 00    	je     801e1a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  801a67:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a6b:	89 04 24             	mov    %eax,(%esp)
  801a6e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a71:	89 f3                	mov    %esi,%ebx
  801a73:	8d 73 01             	lea    0x1(%ebx),%esi
  801a76:	0f b6 03             	movzbl (%ebx),%eax
  801a79:	83 f8 25             	cmp    $0x25,%eax
  801a7c:	75 e1                	jne    801a5f <vprintfmt+0x11>
  801a7e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  801a82:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a89:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  801a90:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  801a97:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9c:	eb 1d                	jmp    801abb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a9e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  801aa0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801aa4:	eb 15                	jmp    801abb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801aa6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801aa8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801aac:	eb 0d                	jmp    801abb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801aae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ab1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801ab4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801abb:	8d 5e 01             	lea    0x1(%esi),%ebx
  801abe:	0f b6 0e             	movzbl (%esi),%ecx
  801ac1:	0f b6 c1             	movzbl %cl,%eax
  801ac4:	83 e9 23             	sub    $0x23,%ecx
  801ac7:	80 f9 55             	cmp    $0x55,%cl
  801aca:	0f 87 2a 03 00 00    	ja     801dfa <vprintfmt+0x3ac>
  801ad0:	0f b6 c9             	movzbl %cl,%ecx
  801ad3:	ff 24 8d 00 29 80 00 	jmp    *0x802900(,%ecx,4)
  801ada:	89 de                	mov    %ebx,%esi
  801adc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801ae1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801ae4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801ae8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801aeb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  801aee:	83 fb 09             	cmp    $0x9,%ebx
  801af1:	77 36                	ja     801b29 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801af3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801af6:	eb e9                	jmp    801ae1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801af8:	8b 45 14             	mov    0x14(%ebp),%eax
  801afb:	8d 48 04             	lea    0x4(%eax),%ecx
  801afe:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801b01:	8b 00                	mov    (%eax),%eax
  801b03:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b06:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801b08:	eb 22                	jmp    801b2c <vprintfmt+0xde>
  801b0a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801b0d:	85 c9                	test   %ecx,%ecx
  801b0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b14:	0f 49 c1             	cmovns %ecx,%eax
  801b17:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b1a:	89 de                	mov    %ebx,%esi
  801b1c:	eb 9d                	jmp    801abb <vprintfmt+0x6d>
  801b1e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801b20:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  801b27:	eb 92                	jmp    801abb <vprintfmt+0x6d>
  801b29:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  801b2c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801b30:	79 89                	jns    801abb <vprintfmt+0x6d>
  801b32:	e9 77 ff ff ff       	jmp    801aae <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b37:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b3a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801b3c:	e9 7a ff ff ff       	jmp    801abb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b41:	8b 45 14             	mov    0x14(%ebp),%eax
  801b44:	8d 50 04             	lea    0x4(%eax),%edx
  801b47:	89 55 14             	mov    %edx,0x14(%ebp)
  801b4a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b4e:	8b 00                	mov    (%eax),%eax
  801b50:	89 04 24             	mov    %eax,(%esp)
  801b53:	ff 55 08             	call   *0x8(%ebp)
			break;
  801b56:	e9 18 ff ff ff       	jmp    801a73 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b5b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5e:	8d 50 04             	lea    0x4(%eax),%edx
  801b61:	89 55 14             	mov    %edx,0x14(%ebp)
  801b64:	8b 00                	mov    (%eax),%eax
  801b66:	99                   	cltd   
  801b67:	31 d0                	xor    %edx,%eax
  801b69:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801b6b:	83 f8 11             	cmp    $0x11,%eax
  801b6e:	7f 0b                	jg     801b7b <vprintfmt+0x12d>
  801b70:	8b 14 85 60 2a 80 00 	mov    0x802a60(,%eax,4),%edx
  801b77:	85 d2                	test   %edx,%edx
  801b79:	75 20                	jne    801b9b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  801b7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b7f:	c7 44 24 08 db 27 80 	movl   $0x8027db,0x8(%esp)
  801b86:	00 
  801b87:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	89 04 24             	mov    %eax,(%esp)
  801b91:	e8 90 fe ff ff       	call   801a26 <printfmt>
  801b96:	e9 d8 fe ff ff       	jmp    801a73 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  801b9b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801b9f:	c7 44 24 08 21 27 80 	movl   $0x802721,0x8(%esp)
  801ba6:	00 
  801ba7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	89 04 24             	mov    %eax,(%esp)
  801bb1:	e8 70 fe ff ff       	call   801a26 <printfmt>
  801bb6:	e9 b8 fe ff ff       	jmp    801a73 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801bbb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  801bbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bc1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801bc4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc7:	8d 50 04             	lea    0x4(%eax),%edx
  801bca:	89 55 14             	mov    %edx,0x14(%ebp)
  801bcd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  801bcf:	85 f6                	test   %esi,%esi
  801bd1:	b8 d4 27 80 00       	mov    $0x8027d4,%eax
  801bd6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  801bd9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  801bdd:	0f 84 97 00 00 00    	je     801c7a <vprintfmt+0x22c>
  801be3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801be7:	0f 8e 9b 00 00 00    	jle    801c88 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  801bed:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bf1:	89 34 24             	mov    %esi,(%esp)
  801bf4:	e8 cf 02 00 00       	call   801ec8 <strnlen>
  801bf9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801bfc:	29 c2                	sub    %eax,%edx
  801bfe:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  801c01:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  801c05:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c08:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801c0b:	8b 75 08             	mov    0x8(%ebp),%esi
  801c0e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801c11:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c13:	eb 0f                	jmp    801c24 <vprintfmt+0x1d6>
					putch(padc, putdat);
  801c15:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c19:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c1c:	89 04 24             	mov    %eax,(%esp)
  801c1f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c21:	83 eb 01             	sub    $0x1,%ebx
  801c24:	85 db                	test   %ebx,%ebx
  801c26:	7f ed                	jg     801c15 <vprintfmt+0x1c7>
  801c28:	8b 75 d8             	mov    -0x28(%ebp),%esi
  801c2b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801c2e:	85 d2                	test   %edx,%edx
  801c30:	b8 00 00 00 00       	mov    $0x0,%eax
  801c35:	0f 49 c2             	cmovns %edx,%eax
  801c38:	29 c2                	sub    %eax,%edx
  801c3a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801c3d:	89 d7                	mov    %edx,%edi
  801c3f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801c42:	eb 50                	jmp    801c94 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801c44:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c48:	74 1e                	je     801c68 <vprintfmt+0x21a>
  801c4a:	0f be d2             	movsbl %dl,%edx
  801c4d:	83 ea 20             	sub    $0x20,%edx
  801c50:	83 fa 5e             	cmp    $0x5e,%edx
  801c53:	76 13                	jbe    801c68 <vprintfmt+0x21a>
					putch('?', putdat);
  801c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c58:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c5c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801c63:	ff 55 08             	call   *0x8(%ebp)
  801c66:	eb 0d                	jmp    801c75 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  801c68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6b:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c6f:	89 04 24             	mov    %eax,(%esp)
  801c72:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c75:	83 ef 01             	sub    $0x1,%edi
  801c78:	eb 1a                	jmp    801c94 <vprintfmt+0x246>
  801c7a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801c7d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801c80:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801c83:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801c86:	eb 0c                	jmp    801c94 <vprintfmt+0x246>
  801c88:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801c8b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801c8e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801c91:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801c94:	83 c6 01             	add    $0x1,%esi
  801c97:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  801c9b:	0f be c2             	movsbl %dl,%eax
  801c9e:	85 c0                	test   %eax,%eax
  801ca0:	74 27                	je     801cc9 <vprintfmt+0x27b>
  801ca2:	85 db                	test   %ebx,%ebx
  801ca4:	78 9e                	js     801c44 <vprintfmt+0x1f6>
  801ca6:	83 eb 01             	sub    $0x1,%ebx
  801ca9:	79 99                	jns    801c44 <vprintfmt+0x1f6>
  801cab:	89 f8                	mov    %edi,%eax
  801cad:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801cb0:	8b 75 08             	mov    0x8(%ebp),%esi
  801cb3:	89 c3                	mov    %eax,%ebx
  801cb5:	eb 1a                	jmp    801cd1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801cb7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801cbb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801cc2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801cc4:	83 eb 01             	sub    $0x1,%ebx
  801cc7:	eb 08                	jmp    801cd1 <vprintfmt+0x283>
  801cc9:	89 fb                	mov    %edi,%ebx
  801ccb:	8b 75 08             	mov    0x8(%ebp),%esi
  801cce:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801cd1:	85 db                	test   %ebx,%ebx
  801cd3:	7f e2                	jg     801cb7 <vprintfmt+0x269>
  801cd5:	89 75 08             	mov    %esi,0x8(%ebp)
  801cd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801cdb:	e9 93 fd ff ff       	jmp    801a73 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801ce0:	83 fa 01             	cmp    $0x1,%edx
  801ce3:	7e 16                	jle    801cfb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  801ce5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ce8:	8d 50 08             	lea    0x8(%eax),%edx
  801ceb:	89 55 14             	mov    %edx,0x14(%ebp)
  801cee:	8b 50 04             	mov    0x4(%eax),%edx
  801cf1:	8b 00                	mov    (%eax),%eax
  801cf3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801cf6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801cf9:	eb 32                	jmp    801d2d <vprintfmt+0x2df>
	else if (lflag)
  801cfb:	85 d2                	test   %edx,%edx
  801cfd:	74 18                	je     801d17 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  801cff:	8b 45 14             	mov    0x14(%ebp),%eax
  801d02:	8d 50 04             	lea    0x4(%eax),%edx
  801d05:	89 55 14             	mov    %edx,0x14(%ebp)
  801d08:	8b 30                	mov    (%eax),%esi
  801d0a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801d0d:	89 f0                	mov    %esi,%eax
  801d0f:	c1 f8 1f             	sar    $0x1f,%eax
  801d12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d15:	eb 16                	jmp    801d2d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  801d17:	8b 45 14             	mov    0x14(%ebp),%eax
  801d1a:	8d 50 04             	lea    0x4(%eax),%edx
  801d1d:	89 55 14             	mov    %edx,0x14(%ebp)
  801d20:	8b 30                	mov    (%eax),%esi
  801d22:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801d25:	89 f0                	mov    %esi,%eax
  801d27:	c1 f8 1f             	sar    $0x1f,%eax
  801d2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801d2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801d33:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801d38:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d3c:	0f 89 80 00 00 00    	jns    801dc2 <vprintfmt+0x374>
				putch('-', putdat);
  801d42:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d46:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801d4d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801d50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d56:	f7 d8                	neg    %eax
  801d58:	83 d2 00             	adc    $0x0,%edx
  801d5b:	f7 da                	neg    %edx
			}
			base = 10;
  801d5d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d62:	eb 5e                	jmp    801dc2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801d64:	8d 45 14             	lea    0x14(%ebp),%eax
  801d67:	e8 63 fc ff ff       	call   8019cf <getuint>
			base = 10;
  801d6c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801d71:	eb 4f                	jmp    801dc2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  801d73:	8d 45 14             	lea    0x14(%ebp),%eax
  801d76:	e8 54 fc ff ff       	call   8019cf <getuint>
			base = 8;
  801d7b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801d80:	eb 40                	jmp    801dc2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  801d82:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d86:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801d8d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801d90:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d94:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801d9b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801d9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801da1:	8d 50 04             	lea    0x4(%eax),%edx
  801da4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801da7:	8b 00                	mov    (%eax),%eax
  801da9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801dae:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801db3:	eb 0d                	jmp    801dc2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801db5:	8d 45 14             	lea    0x14(%ebp),%eax
  801db8:	e8 12 fc ff ff       	call   8019cf <getuint>
			base = 16;
  801dbd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801dc2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  801dc6:	89 74 24 10          	mov    %esi,0x10(%esp)
  801dca:	8b 75 dc             	mov    -0x24(%ebp),%esi
  801dcd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801dd1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dd5:	89 04 24             	mov    %eax,(%esp)
  801dd8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ddc:	89 fa                	mov    %edi,%edx
  801dde:	8b 45 08             	mov    0x8(%ebp),%eax
  801de1:	e8 fa fa ff ff       	call   8018e0 <printnum>
			break;
  801de6:	e9 88 fc ff ff       	jmp    801a73 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801deb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801def:	89 04 24             	mov    %eax,(%esp)
  801df2:	ff 55 08             	call   *0x8(%ebp)
			break;
  801df5:	e9 79 fc ff ff       	jmp    801a73 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801dfa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801dfe:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801e05:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e08:	89 f3                	mov    %esi,%ebx
  801e0a:	eb 03                	jmp    801e0f <vprintfmt+0x3c1>
  801e0c:	83 eb 01             	sub    $0x1,%ebx
  801e0f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801e13:	75 f7                	jne    801e0c <vprintfmt+0x3be>
  801e15:	e9 59 fc ff ff       	jmp    801a73 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  801e1a:	83 c4 3c             	add    $0x3c,%esp
  801e1d:	5b                   	pop    %ebx
  801e1e:	5e                   	pop    %esi
  801e1f:	5f                   	pop    %edi
  801e20:	5d                   	pop    %ebp
  801e21:	c3                   	ret    

00801e22 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 28             	sub    $0x28,%esp
  801e28:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e31:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801e35:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801e38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801e3f:	85 c0                	test   %eax,%eax
  801e41:	74 30                	je     801e73 <vsnprintf+0x51>
  801e43:	85 d2                	test   %edx,%edx
  801e45:	7e 2c                	jle    801e73 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801e47:	8b 45 14             	mov    0x14(%ebp),%eax
  801e4a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e4e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e51:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e55:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801e58:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e5c:	c7 04 24 09 1a 80 00 	movl   $0x801a09,(%esp)
  801e63:	e8 e6 fb ff ff       	call   801a4e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e6b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e71:	eb 05                	jmp    801e78 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801e73:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801e80:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801e83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e87:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e91:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	89 04 24             	mov    %eax,(%esp)
  801e9b:	e8 82 ff ff ff       	call   801e22 <vsnprintf>
	va_end(ap);

	return rc;
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    
  801ea2:	66 90                	xchg   %ax,%ax
  801ea4:	66 90                	xchg   %ax,%ax
  801ea6:	66 90                	xchg   %ax,%ax
  801ea8:	66 90                	xchg   %ax,%ax
  801eaa:	66 90                	xchg   %ax,%ax
  801eac:	66 90                	xchg   %ax,%ax
  801eae:	66 90                	xchg   %ax,%ax

00801eb0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801eb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebb:	eb 03                	jmp    801ec0 <strlen+0x10>
		n++;
  801ebd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801ec0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801ec4:	75 f7                	jne    801ebd <strlen+0xd>
		n++;
	return n;
}
  801ec6:	5d                   	pop    %ebp
  801ec7:	c3                   	ret    

00801ec8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
  801ecb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ece:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801ed1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed6:	eb 03                	jmp    801edb <strnlen+0x13>
		n++;
  801ed8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801edb:	39 d0                	cmp    %edx,%eax
  801edd:	74 06                	je     801ee5 <strnlen+0x1d>
  801edf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801ee3:	75 f3                	jne    801ed8 <strnlen+0x10>
		n++;
	return n;
}
  801ee5:	5d                   	pop    %ebp
  801ee6:	c3                   	ret    

00801ee7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	53                   	push   %ebx
  801eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801eee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801ef1:	89 c2                	mov    %eax,%edx
  801ef3:	83 c2 01             	add    $0x1,%edx
  801ef6:	83 c1 01             	add    $0x1,%ecx
  801ef9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801efd:	88 5a ff             	mov    %bl,-0x1(%edx)
  801f00:	84 db                	test   %bl,%bl
  801f02:	75 ef                	jne    801ef3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801f04:	5b                   	pop    %ebx
  801f05:	5d                   	pop    %ebp
  801f06:	c3                   	ret    

00801f07 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	53                   	push   %ebx
  801f0b:	83 ec 08             	sub    $0x8,%esp
  801f0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801f11:	89 1c 24             	mov    %ebx,(%esp)
  801f14:	e8 97 ff ff ff       	call   801eb0 <strlen>
	strcpy(dst + len, src);
  801f19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f20:	01 d8                	add    %ebx,%eax
  801f22:	89 04 24             	mov    %eax,(%esp)
  801f25:	e8 bd ff ff ff       	call   801ee7 <strcpy>
	return dst;
}
  801f2a:	89 d8                	mov    %ebx,%eax
  801f2c:	83 c4 08             	add    $0x8,%esp
  801f2f:	5b                   	pop    %ebx
  801f30:	5d                   	pop    %ebp
  801f31:	c3                   	ret    

00801f32 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	56                   	push   %esi
  801f36:	53                   	push   %ebx
  801f37:	8b 75 08             	mov    0x8(%ebp),%esi
  801f3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f3d:	89 f3                	mov    %esi,%ebx
  801f3f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801f42:	89 f2                	mov    %esi,%edx
  801f44:	eb 0f                	jmp    801f55 <strncpy+0x23>
		*dst++ = *src;
  801f46:	83 c2 01             	add    $0x1,%edx
  801f49:	0f b6 01             	movzbl (%ecx),%eax
  801f4c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801f4f:	80 39 01             	cmpb   $0x1,(%ecx)
  801f52:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801f55:	39 da                	cmp    %ebx,%edx
  801f57:	75 ed                	jne    801f46 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801f59:	89 f0                	mov    %esi,%eax
  801f5b:	5b                   	pop    %ebx
  801f5c:	5e                   	pop    %esi
  801f5d:	5d                   	pop    %ebp
  801f5e:	c3                   	ret    

00801f5f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	56                   	push   %esi
  801f63:	53                   	push   %ebx
  801f64:	8b 75 08             	mov    0x8(%ebp),%esi
  801f67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f6d:	89 f0                	mov    %esi,%eax
  801f6f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801f73:	85 c9                	test   %ecx,%ecx
  801f75:	75 0b                	jne    801f82 <strlcpy+0x23>
  801f77:	eb 1d                	jmp    801f96 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801f79:	83 c0 01             	add    $0x1,%eax
  801f7c:	83 c2 01             	add    $0x1,%edx
  801f7f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801f82:	39 d8                	cmp    %ebx,%eax
  801f84:	74 0b                	je     801f91 <strlcpy+0x32>
  801f86:	0f b6 0a             	movzbl (%edx),%ecx
  801f89:	84 c9                	test   %cl,%cl
  801f8b:	75 ec                	jne    801f79 <strlcpy+0x1a>
  801f8d:	89 c2                	mov    %eax,%edx
  801f8f:	eb 02                	jmp    801f93 <strlcpy+0x34>
  801f91:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  801f93:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  801f96:	29 f0                	sub    %esi,%eax
}
  801f98:	5b                   	pop    %ebx
  801f99:	5e                   	pop    %esi
  801f9a:	5d                   	pop    %ebp
  801f9b:	c3                   	ret    

00801f9c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fa2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801fa5:	eb 06                	jmp    801fad <strcmp+0x11>
		p++, q++;
  801fa7:	83 c1 01             	add    $0x1,%ecx
  801faa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801fad:	0f b6 01             	movzbl (%ecx),%eax
  801fb0:	84 c0                	test   %al,%al
  801fb2:	74 04                	je     801fb8 <strcmp+0x1c>
  801fb4:	3a 02                	cmp    (%edx),%al
  801fb6:	74 ef                	je     801fa7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801fb8:	0f b6 c0             	movzbl %al,%eax
  801fbb:	0f b6 12             	movzbl (%edx),%edx
  801fbe:	29 d0                	sub    %edx,%eax
}
  801fc0:	5d                   	pop    %ebp
  801fc1:	c3                   	ret    

00801fc2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
  801fc5:	53                   	push   %ebx
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcc:	89 c3                	mov    %eax,%ebx
  801fce:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801fd1:	eb 06                	jmp    801fd9 <strncmp+0x17>
		n--, p++, q++;
  801fd3:	83 c0 01             	add    $0x1,%eax
  801fd6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801fd9:	39 d8                	cmp    %ebx,%eax
  801fdb:	74 15                	je     801ff2 <strncmp+0x30>
  801fdd:	0f b6 08             	movzbl (%eax),%ecx
  801fe0:	84 c9                	test   %cl,%cl
  801fe2:	74 04                	je     801fe8 <strncmp+0x26>
  801fe4:	3a 0a                	cmp    (%edx),%cl
  801fe6:	74 eb                	je     801fd3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801fe8:	0f b6 00             	movzbl (%eax),%eax
  801feb:	0f b6 12             	movzbl (%edx),%edx
  801fee:	29 d0                	sub    %edx,%eax
  801ff0:	eb 05                	jmp    801ff7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801ff2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801ff7:	5b                   	pop    %ebx
  801ff8:	5d                   	pop    %ebp
  801ff9:	c3                   	ret    

00801ffa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802004:	eb 07                	jmp    80200d <strchr+0x13>
		if (*s == c)
  802006:	38 ca                	cmp    %cl,%dl
  802008:	74 0f                	je     802019 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80200a:	83 c0 01             	add    $0x1,%eax
  80200d:	0f b6 10             	movzbl (%eax),%edx
  802010:	84 d2                	test   %dl,%dl
  802012:	75 f2                	jne    802006 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  802014:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802019:	5d                   	pop    %ebp
  80201a:	c3                   	ret    

0080201b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802025:	eb 07                	jmp    80202e <strfind+0x13>
		if (*s == c)
  802027:	38 ca                	cmp    %cl,%dl
  802029:	74 0a                	je     802035 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80202b:	83 c0 01             	add    $0x1,%eax
  80202e:	0f b6 10             	movzbl (%eax),%edx
  802031:	84 d2                	test   %dl,%dl
  802033:	75 f2                	jne    802027 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  802035:	5d                   	pop    %ebp
  802036:	c3                   	ret    

00802037 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	57                   	push   %edi
  80203b:	56                   	push   %esi
  80203c:	53                   	push   %ebx
  80203d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802040:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802043:	85 c9                	test   %ecx,%ecx
  802045:	74 36                	je     80207d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802047:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80204d:	75 28                	jne    802077 <memset+0x40>
  80204f:	f6 c1 03             	test   $0x3,%cl
  802052:	75 23                	jne    802077 <memset+0x40>
		c &= 0xFF;
  802054:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802058:	89 d3                	mov    %edx,%ebx
  80205a:	c1 e3 08             	shl    $0x8,%ebx
  80205d:	89 d6                	mov    %edx,%esi
  80205f:	c1 e6 18             	shl    $0x18,%esi
  802062:	89 d0                	mov    %edx,%eax
  802064:	c1 e0 10             	shl    $0x10,%eax
  802067:	09 f0                	or     %esi,%eax
  802069:	09 c2                	or     %eax,%edx
  80206b:	89 d0                	mov    %edx,%eax
  80206d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80206f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802072:	fc                   	cld    
  802073:	f3 ab                	rep stos %eax,%es:(%edi)
  802075:	eb 06                	jmp    80207d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207a:	fc                   	cld    
  80207b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80207d:	89 f8                	mov    %edi,%eax
  80207f:	5b                   	pop    %ebx
  802080:	5e                   	pop    %esi
  802081:	5f                   	pop    %edi
  802082:	5d                   	pop    %ebp
  802083:	c3                   	ret    

00802084 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	57                   	push   %edi
  802088:	56                   	push   %esi
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80208f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802092:	39 c6                	cmp    %eax,%esi
  802094:	73 35                	jae    8020cb <memmove+0x47>
  802096:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802099:	39 d0                	cmp    %edx,%eax
  80209b:	73 2e                	jae    8020cb <memmove+0x47>
		s += n;
		d += n;
  80209d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8020a0:	89 d6                	mov    %edx,%esi
  8020a2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8020a4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8020aa:	75 13                	jne    8020bf <memmove+0x3b>
  8020ac:	f6 c1 03             	test   $0x3,%cl
  8020af:	75 0e                	jne    8020bf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8020b1:	83 ef 04             	sub    $0x4,%edi
  8020b4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8020b7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8020ba:	fd                   	std    
  8020bb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8020bd:	eb 09                	jmp    8020c8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8020bf:	83 ef 01             	sub    $0x1,%edi
  8020c2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8020c5:	fd                   	std    
  8020c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8020c8:	fc                   	cld    
  8020c9:	eb 1d                	jmp    8020e8 <memmove+0x64>
  8020cb:	89 f2                	mov    %esi,%edx
  8020cd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8020cf:	f6 c2 03             	test   $0x3,%dl
  8020d2:	75 0f                	jne    8020e3 <memmove+0x5f>
  8020d4:	f6 c1 03             	test   $0x3,%cl
  8020d7:	75 0a                	jne    8020e3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8020d9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8020dc:	89 c7                	mov    %eax,%edi
  8020de:	fc                   	cld    
  8020df:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8020e1:	eb 05                	jmp    8020e8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8020e3:	89 c7                	mov    %eax,%edi
  8020e5:	fc                   	cld    
  8020e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8020e8:	5e                   	pop    %esi
  8020e9:	5f                   	pop    %edi
  8020ea:	5d                   	pop    %ebp
  8020eb:	c3                   	ret    

008020ec <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8020f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	89 04 24             	mov    %eax,(%esp)
  802106:	e8 79 ff ff ff       	call   802084 <memmove>
}
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
  802110:	56                   	push   %esi
  802111:	53                   	push   %ebx
  802112:	8b 55 08             	mov    0x8(%ebp),%edx
  802115:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802118:	89 d6                	mov    %edx,%esi
  80211a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80211d:	eb 1a                	jmp    802139 <memcmp+0x2c>
		if (*s1 != *s2)
  80211f:	0f b6 02             	movzbl (%edx),%eax
  802122:	0f b6 19             	movzbl (%ecx),%ebx
  802125:	38 d8                	cmp    %bl,%al
  802127:	74 0a                	je     802133 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  802129:	0f b6 c0             	movzbl %al,%eax
  80212c:	0f b6 db             	movzbl %bl,%ebx
  80212f:	29 d8                	sub    %ebx,%eax
  802131:	eb 0f                	jmp    802142 <memcmp+0x35>
		s1++, s2++;
  802133:	83 c2 01             	add    $0x1,%edx
  802136:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802139:	39 f2                	cmp    %esi,%edx
  80213b:	75 e2                	jne    80211f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80213d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802142:	5b                   	pop    %ebx
  802143:	5e                   	pop    %esi
  802144:	5d                   	pop    %ebp
  802145:	c3                   	ret    

00802146 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80214f:	89 c2                	mov    %eax,%edx
  802151:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802154:	eb 07                	jmp    80215d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  802156:	38 08                	cmp    %cl,(%eax)
  802158:	74 07                	je     802161 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80215a:	83 c0 01             	add    $0x1,%eax
  80215d:	39 d0                	cmp    %edx,%eax
  80215f:	72 f5                	jb     802156 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802161:	5d                   	pop    %ebp
  802162:	c3                   	ret    

00802163 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
  802166:	57                   	push   %edi
  802167:	56                   	push   %esi
  802168:	53                   	push   %ebx
  802169:	8b 55 08             	mov    0x8(%ebp),%edx
  80216c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80216f:	eb 03                	jmp    802174 <strtol+0x11>
		s++;
  802171:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802174:	0f b6 0a             	movzbl (%edx),%ecx
  802177:	80 f9 09             	cmp    $0x9,%cl
  80217a:	74 f5                	je     802171 <strtol+0xe>
  80217c:	80 f9 20             	cmp    $0x20,%cl
  80217f:	74 f0                	je     802171 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  802181:	80 f9 2b             	cmp    $0x2b,%cl
  802184:	75 0a                	jne    802190 <strtol+0x2d>
		s++;
  802186:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  802189:	bf 00 00 00 00       	mov    $0x0,%edi
  80218e:	eb 11                	jmp    8021a1 <strtol+0x3e>
  802190:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  802195:	80 f9 2d             	cmp    $0x2d,%cl
  802198:	75 07                	jne    8021a1 <strtol+0x3e>
		s++, neg = 1;
  80219a:	8d 52 01             	lea    0x1(%edx),%edx
  80219d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8021a1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  8021a6:	75 15                	jne    8021bd <strtol+0x5a>
  8021a8:	80 3a 30             	cmpb   $0x30,(%edx)
  8021ab:	75 10                	jne    8021bd <strtol+0x5a>
  8021ad:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8021b1:	75 0a                	jne    8021bd <strtol+0x5a>
		s += 2, base = 16;
  8021b3:	83 c2 02             	add    $0x2,%edx
  8021b6:	b8 10 00 00 00       	mov    $0x10,%eax
  8021bb:	eb 10                	jmp    8021cd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  8021bd:	85 c0                	test   %eax,%eax
  8021bf:	75 0c                	jne    8021cd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8021c1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8021c3:	80 3a 30             	cmpb   $0x30,(%edx)
  8021c6:	75 05                	jne    8021cd <strtol+0x6a>
		s++, base = 8;
  8021c8:	83 c2 01             	add    $0x1,%edx
  8021cb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8021cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021d2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8021d5:	0f b6 0a             	movzbl (%edx),%ecx
  8021d8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8021db:	89 f0                	mov    %esi,%eax
  8021dd:	3c 09                	cmp    $0x9,%al
  8021df:	77 08                	ja     8021e9 <strtol+0x86>
			dig = *s - '0';
  8021e1:	0f be c9             	movsbl %cl,%ecx
  8021e4:	83 e9 30             	sub    $0x30,%ecx
  8021e7:	eb 20                	jmp    802209 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  8021e9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  8021ec:	89 f0                	mov    %esi,%eax
  8021ee:	3c 19                	cmp    $0x19,%al
  8021f0:	77 08                	ja     8021fa <strtol+0x97>
			dig = *s - 'a' + 10;
  8021f2:	0f be c9             	movsbl %cl,%ecx
  8021f5:	83 e9 57             	sub    $0x57,%ecx
  8021f8:	eb 0f                	jmp    802209 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  8021fa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8021fd:	89 f0                	mov    %esi,%eax
  8021ff:	3c 19                	cmp    $0x19,%al
  802201:	77 16                	ja     802219 <strtol+0xb6>
			dig = *s - 'A' + 10;
  802203:	0f be c9             	movsbl %cl,%ecx
  802206:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  802209:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80220c:	7d 0f                	jge    80221d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80220e:	83 c2 01             	add    $0x1,%edx
  802211:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  802215:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  802217:	eb bc                	jmp    8021d5 <strtol+0x72>
  802219:	89 d8                	mov    %ebx,%eax
  80221b:	eb 02                	jmp    80221f <strtol+0xbc>
  80221d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80221f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802223:	74 05                	je     80222a <strtol+0xc7>
		*endptr = (char *) s;
  802225:	8b 75 0c             	mov    0xc(%ebp),%esi
  802228:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80222a:	f7 d8                	neg    %eax
  80222c:	85 ff                	test   %edi,%edi
  80222e:	0f 44 c3             	cmove  %ebx,%eax
}
  802231:	5b                   	pop    %ebx
  802232:	5e                   	pop    %esi
  802233:	5f                   	pop    %edi
  802234:	5d                   	pop    %ebp
  802235:	c3                   	ret    
  802236:	66 90                	xchg   %ax,%ax
  802238:	66 90                	xchg   %ax,%ax
  80223a:	66 90                	xchg   %ax,%ax
  80223c:	66 90                	xchg   %ax,%ax
  80223e:	66 90                	xchg   %ax,%ax

00802240 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
  802243:	56                   	push   %esi
  802244:	53                   	push   %ebx
  802245:	83 ec 10             	sub    $0x10,%esp
  802248:	8b 75 08             	mov    0x8(%ebp),%esi
  80224b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802251:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802253:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802258:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80225b:	89 04 24             	mov    %eax,(%esp)
  80225e:	e8 1f e1 ff ff       	call   800382 <sys_ipc_recv>
  802263:	85 c0                	test   %eax,%eax
  802265:	74 16                	je     80227d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802267:	85 f6                	test   %esi,%esi
  802269:	74 06                	je     802271 <ipc_recv+0x31>
			*from_env_store = 0;
  80226b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802271:	85 db                	test   %ebx,%ebx
  802273:	74 2c                	je     8022a1 <ipc_recv+0x61>
			*perm_store = 0;
  802275:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80227b:	eb 24                	jmp    8022a1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  80227d:	85 f6                	test   %esi,%esi
  80227f:	74 0a                	je     80228b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802281:	a1 08 40 80 00       	mov    0x804008,%eax
  802286:	8b 40 74             	mov    0x74(%eax),%eax
  802289:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80228b:	85 db                	test   %ebx,%ebx
  80228d:	74 0a                	je     802299 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80228f:	a1 08 40 80 00       	mov    0x804008,%eax
  802294:	8b 40 78             	mov    0x78(%eax),%eax
  802297:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802299:	a1 08 40 80 00       	mov    0x804008,%eax
  80229e:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022a1:	83 c4 10             	add    $0x10,%esp
  8022a4:	5b                   	pop    %ebx
  8022a5:	5e                   	pop    %esi
  8022a6:	5d                   	pop    %ebp
  8022a7:	c3                   	ret    

008022a8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
  8022ab:	57                   	push   %edi
  8022ac:	56                   	push   %esi
  8022ad:	53                   	push   %ebx
  8022ae:	83 ec 1c             	sub    $0x1c,%esp
  8022b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022b7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  8022ba:	85 db                	test   %ebx,%ebx
  8022bc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8022c1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  8022c4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d3:	89 04 24             	mov    %eax,(%esp)
  8022d6:	e8 84 e0 ff ff       	call   80035f <sys_ipc_try_send>
	if (r == 0) return;
  8022db:	85 c0                	test   %eax,%eax
  8022dd:	75 22                	jne    802301 <ipc_send+0x59>
  8022df:	eb 4c                	jmp    80232d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  8022e1:	84 d2                	test   %dl,%dl
  8022e3:	75 48                	jne    80232d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  8022e5:	e8 63 de ff ff       	call   80014d <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  8022ea:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022ee:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f9:	89 04 24             	mov    %eax,(%esp)
  8022fc:	e8 5e e0 ff ff       	call   80035f <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802301:	85 c0                	test   %eax,%eax
  802303:	0f 94 c2             	sete   %dl
  802306:	74 d9                	je     8022e1 <ipc_send+0x39>
  802308:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80230b:	74 d4                	je     8022e1 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80230d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802311:	c7 44 24 08 c8 2a 80 	movl   $0x802ac8,0x8(%esp)
  802318:	00 
  802319:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802320:	00 
  802321:	c7 04 24 d6 2a 80 00 	movl   $0x802ad6,(%esp)
  802328:	e8 99 f4 ff ff       	call   8017c6 <_panic>
}
  80232d:	83 c4 1c             	add    $0x1c,%esp
  802330:	5b                   	pop    %ebx
  802331:	5e                   	pop    %esi
  802332:	5f                   	pop    %edi
  802333:	5d                   	pop    %ebp
  802334:	c3                   	ret    

00802335 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80233b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802340:	89 c2                	mov    %eax,%edx
  802342:	c1 e2 07             	shl    $0x7,%edx
  802345:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80234b:	8b 52 50             	mov    0x50(%edx),%edx
  80234e:	39 ca                	cmp    %ecx,%edx
  802350:	75 0d                	jne    80235f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802352:	c1 e0 07             	shl    $0x7,%eax
  802355:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80235a:	8b 40 40             	mov    0x40(%eax),%eax
  80235d:	eb 0e                	jmp    80236d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80235f:	83 c0 01             	add    $0x1,%eax
  802362:	3d 00 04 00 00       	cmp    $0x400,%eax
  802367:	75 d7                	jne    802340 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802369:	66 b8 00 00          	mov    $0x0,%ax
}
  80236d:	5d                   	pop    %ebp
  80236e:	c3                   	ret    

0080236f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
  802372:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802375:	89 d0                	mov    %edx,%eax
  802377:	c1 e8 16             	shr    $0x16,%eax
  80237a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802381:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802386:	f6 c1 01             	test   $0x1,%cl
  802389:	74 1d                	je     8023a8 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80238b:	c1 ea 0c             	shr    $0xc,%edx
  80238e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802395:	f6 c2 01             	test   $0x1,%dl
  802398:	74 0e                	je     8023a8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80239a:	c1 ea 0c             	shr    $0xc,%edx
  80239d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023a4:	ef 
  8023a5:	0f b7 c0             	movzwl %ax,%eax
}
  8023a8:	5d                   	pop    %ebp
  8023a9:	c3                   	ret    
  8023aa:	66 90                	xchg   %ax,%ax
  8023ac:	66 90                	xchg   %ax,%ax
  8023ae:	66 90                	xchg   %ax,%ax

008023b0 <__udivdi3>:
  8023b0:	55                   	push   %ebp
  8023b1:	57                   	push   %edi
  8023b2:	56                   	push   %esi
  8023b3:	83 ec 0c             	sub    $0xc,%esp
  8023b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8023ba:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8023be:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8023c2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8023c6:	85 c0                	test   %eax,%eax
  8023c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8023cc:	89 ea                	mov    %ebp,%edx
  8023ce:	89 0c 24             	mov    %ecx,(%esp)
  8023d1:	75 2d                	jne    802400 <__udivdi3+0x50>
  8023d3:	39 e9                	cmp    %ebp,%ecx
  8023d5:	77 61                	ja     802438 <__udivdi3+0x88>
  8023d7:	85 c9                	test   %ecx,%ecx
  8023d9:	89 ce                	mov    %ecx,%esi
  8023db:	75 0b                	jne    8023e8 <__udivdi3+0x38>
  8023dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e2:	31 d2                	xor    %edx,%edx
  8023e4:	f7 f1                	div    %ecx
  8023e6:	89 c6                	mov    %eax,%esi
  8023e8:	31 d2                	xor    %edx,%edx
  8023ea:	89 e8                	mov    %ebp,%eax
  8023ec:	f7 f6                	div    %esi
  8023ee:	89 c5                	mov    %eax,%ebp
  8023f0:	89 f8                	mov    %edi,%eax
  8023f2:	f7 f6                	div    %esi
  8023f4:	89 ea                	mov    %ebp,%edx
  8023f6:	83 c4 0c             	add    $0xc,%esp
  8023f9:	5e                   	pop    %esi
  8023fa:	5f                   	pop    %edi
  8023fb:	5d                   	pop    %ebp
  8023fc:	c3                   	ret    
  8023fd:	8d 76 00             	lea    0x0(%esi),%esi
  802400:	39 e8                	cmp    %ebp,%eax
  802402:	77 24                	ja     802428 <__udivdi3+0x78>
  802404:	0f bd e8             	bsr    %eax,%ebp
  802407:	83 f5 1f             	xor    $0x1f,%ebp
  80240a:	75 3c                	jne    802448 <__udivdi3+0x98>
  80240c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802410:	39 34 24             	cmp    %esi,(%esp)
  802413:	0f 86 9f 00 00 00    	jbe    8024b8 <__udivdi3+0x108>
  802419:	39 d0                	cmp    %edx,%eax
  80241b:	0f 82 97 00 00 00    	jb     8024b8 <__udivdi3+0x108>
  802421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802428:	31 d2                	xor    %edx,%edx
  80242a:	31 c0                	xor    %eax,%eax
  80242c:	83 c4 0c             	add    $0xc,%esp
  80242f:	5e                   	pop    %esi
  802430:	5f                   	pop    %edi
  802431:	5d                   	pop    %ebp
  802432:	c3                   	ret    
  802433:	90                   	nop
  802434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802438:	89 f8                	mov    %edi,%eax
  80243a:	f7 f1                	div    %ecx
  80243c:	31 d2                	xor    %edx,%edx
  80243e:	83 c4 0c             	add    $0xc,%esp
  802441:	5e                   	pop    %esi
  802442:	5f                   	pop    %edi
  802443:	5d                   	pop    %ebp
  802444:	c3                   	ret    
  802445:	8d 76 00             	lea    0x0(%esi),%esi
  802448:	89 e9                	mov    %ebp,%ecx
  80244a:	8b 3c 24             	mov    (%esp),%edi
  80244d:	d3 e0                	shl    %cl,%eax
  80244f:	89 c6                	mov    %eax,%esi
  802451:	b8 20 00 00 00       	mov    $0x20,%eax
  802456:	29 e8                	sub    %ebp,%eax
  802458:	89 c1                	mov    %eax,%ecx
  80245a:	d3 ef                	shr    %cl,%edi
  80245c:	89 e9                	mov    %ebp,%ecx
  80245e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802462:	8b 3c 24             	mov    (%esp),%edi
  802465:	09 74 24 08          	or     %esi,0x8(%esp)
  802469:	89 d6                	mov    %edx,%esi
  80246b:	d3 e7                	shl    %cl,%edi
  80246d:	89 c1                	mov    %eax,%ecx
  80246f:	89 3c 24             	mov    %edi,(%esp)
  802472:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802476:	d3 ee                	shr    %cl,%esi
  802478:	89 e9                	mov    %ebp,%ecx
  80247a:	d3 e2                	shl    %cl,%edx
  80247c:	89 c1                	mov    %eax,%ecx
  80247e:	d3 ef                	shr    %cl,%edi
  802480:	09 d7                	or     %edx,%edi
  802482:	89 f2                	mov    %esi,%edx
  802484:	89 f8                	mov    %edi,%eax
  802486:	f7 74 24 08          	divl   0x8(%esp)
  80248a:	89 d6                	mov    %edx,%esi
  80248c:	89 c7                	mov    %eax,%edi
  80248e:	f7 24 24             	mull   (%esp)
  802491:	39 d6                	cmp    %edx,%esi
  802493:	89 14 24             	mov    %edx,(%esp)
  802496:	72 30                	jb     8024c8 <__udivdi3+0x118>
  802498:	8b 54 24 04          	mov    0x4(%esp),%edx
  80249c:	89 e9                	mov    %ebp,%ecx
  80249e:	d3 e2                	shl    %cl,%edx
  8024a0:	39 c2                	cmp    %eax,%edx
  8024a2:	73 05                	jae    8024a9 <__udivdi3+0xf9>
  8024a4:	3b 34 24             	cmp    (%esp),%esi
  8024a7:	74 1f                	je     8024c8 <__udivdi3+0x118>
  8024a9:	89 f8                	mov    %edi,%eax
  8024ab:	31 d2                	xor    %edx,%edx
  8024ad:	e9 7a ff ff ff       	jmp    80242c <__udivdi3+0x7c>
  8024b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024b8:	31 d2                	xor    %edx,%edx
  8024ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8024bf:	e9 68 ff ff ff       	jmp    80242c <__udivdi3+0x7c>
  8024c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024c8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8024cb:	31 d2                	xor    %edx,%edx
  8024cd:	83 c4 0c             	add    $0xc,%esp
  8024d0:	5e                   	pop    %esi
  8024d1:	5f                   	pop    %edi
  8024d2:	5d                   	pop    %ebp
  8024d3:	c3                   	ret    
  8024d4:	66 90                	xchg   %ax,%ax
  8024d6:	66 90                	xchg   %ax,%ax
  8024d8:	66 90                	xchg   %ax,%ax
  8024da:	66 90                	xchg   %ax,%ax
  8024dc:	66 90                	xchg   %ax,%ax
  8024de:	66 90                	xchg   %ax,%ax

008024e0 <__umoddi3>:
  8024e0:	55                   	push   %ebp
  8024e1:	57                   	push   %edi
  8024e2:	56                   	push   %esi
  8024e3:	83 ec 14             	sub    $0x14,%esp
  8024e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8024ea:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8024ee:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8024f2:	89 c7                	mov    %eax,%edi
  8024f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8024fc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802500:	89 34 24             	mov    %esi,(%esp)
  802503:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802507:	85 c0                	test   %eax,%eax
  802509:	89 c2                	mov    %eax,%edx
  80250b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80250f:	75 17                	jne    802528 <__umoddi3+0x48>
  802511:	39 fe                	cmp    %edi,%esi
  802513:	76 4b                	jbe    802560 <__umoddi3+0x80>
  802515:	89 c8                	mov    %ecx,%eax
  802517:	89 fa                	mov    %edi,%edx
  802519:	f7 f6                	div    %esi
  80251b:	89 d0                	mov    %edx,%eax
  80251d:	31 d2                	xor    %edx,%edx
  80251f:	83 c4 14             	add    $0x14,%esp
  802522:	5e                   	pop    %esi
  802523:	5f                   	pop    %edi
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    
  802526:	66 90                	xchg   %ax,%ax
  802528:	39 f8                	cmp    %edi,%eax
  80252a:	77 54                	ja     802580 <__umoddi3+0xa0>
  80252c:	0f bd e8             	bsr    %eax,%ebp
  80252f:	83 f5 1f             	xor    $0x1f,%ebp
  802532:	75 5c                	jne    802590 <__umoddi3+0xb0>
  802534:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802538:	39 3c 24             	cmp    %edi,(%esp)
  80253b:	0f 87 e7 00 00 00    	ja     802628 <__umoddi3+0x148>
  802541:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802545:	29 f1                	sub    %esi,%ecx
  802547:	19 c7                	sbb    %eax,%edi
  802549:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80254d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802551:	8b 44 24 08          	mov    0x8(%esp),%eax
  802555:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802559:	83 c4 14             	add    $0x14,%esp
  80255c:	5e                   	pop    %esi
  80255d:	5f                   	pop    %edi
  80255e:	5d                   	pop    %ebp
  80255f:	c3                   	ret    
  802560:	85 f6                	test   %esi,%esi
  802562:	89 f5                	mov    %esi,%ebp
  802564:	75 0b                	jne    802571 <__umoddi3+0x91>
  802566:	b8 01 00 00 00       	mov    $0x1,%eax
  80256b:	31 d2                	xor    %edx,%edx
  80256d:	f7 f6                	div    %esi
  80256f:	89 c5                	mov    %eax,%ebp
  802571:	8b 44 24 04          	mov    0x4(%esp),%eax
  802575:	31 d2                	xor    %edx,%edx
  802577:	f7 f5                	div    %ebp
  802579:	89 c8                	mov    %ecx,%eax
  80257b:	f7 f5                	div    %ebp
  80257d:	eb 9c                	jmp    80251b <__umoddi3+0x3b>
  80257f:	90                   	nop
  802580:	89 c8                	mov    %ecx,%eax
  802582:	89 fa                	mov    %edi,%edx
  802584:	83 c4 14             	add    $0x14,%esp
  802587:	5e                   	pop    %esi
  802588:	5f                   	pop    %edi
  802589:	5d                   	pop    %ebp
  80258a:	c3                   	ret    
  80258b:	90                   	nop
  80258c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802590:	8b 04 24             	mov    (%esp),%eax
  802593:	be 20 00 00 00       	mov    $0x20,%esi
  802598:	89 e9                	mov    %ebp,%ecx
  80259a:	29 ee                	sub    %ebp,%esi
  80259c:	d3 e2                	shl    %cl,%edx
  80259e:	89 f1                	mov    %esi,%ecx
  8025a0:	d3 e8                	shr    %cl,%eax
  8025a2:	89 e9                	mov    %ebp,%ecx
  8025a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a8:	8b 04 24             	mov    (%esp),%eax
  8025ab:	09 54 24 04          	or     %edx,0x4(%esp)
  8025af:	89 fa                	mov    %edi,%edx
  8025b1:	d3 e0                	shl    %cl,%eax
  8025b3:	89 f1                	mov    %esi,%ecx
  8025b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025b9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8025bd:	d3 ea                	shr    %cl,%edx
  8025bf:	89 e9                	mov    %ebp,%ecx
  8025c1:	d3 e7                	shl    %cl,%edi
  8025c3:	89 f1                	mov    %esi,%ecx
  8025c5:	d3 e8                	shr    %cl,%eax
  8025c7:	89 e9                	mov    %ebp,%ecx
  8025c9:	09 f8                	or     %edi,%eax
  8025cb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8025cf:	f7 74 24 04          	divl   0x4(%esp)
  8025d3:	d3 e7                	shl    %cl,%edi
  8025d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025d9:	89 d7                	mov    %edx,%edi
  8025db:	f7 64 24 08          	mull   0x8(%esp)
  8025df:	39 d7                	cmp    %edx,%edi
  8025e1:	89 c1                	mov    %eax,%ecx
  8025e3:	89 14 24             	mov    %edx,(%esp)
  8025e6:	72 2c                	jb     802614 <__umoddi3+0x134>
  8025e8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8025ec:	72 22                	jb     802610 <__umoddi3+0x130>
  8025ee:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8025f2:	29 c8                	sub    %ecx,%eax
  8025f4:	19 d7                	sbb    %edx,%edi
  8025f6:	89 e9                	mov    %ebp,%ecx
  8025f8:	89 fa                	mov    %edi,%edx
  8025fa:	d3 e8                	shr    %cl,%eax
  8025fc:	89 f1                	mov    %esi,%ecx
  8025fe:	d3 e2                	shl    %cl,%edx
  802600:	89 e9                	mov    %ebp,%ecx
  802602:	d3 ef                	shr    %cl,%edi
  802604:	09 d0                	or     %edx,%eax
  802606:	89 fa                	mov    %edi,%edx
  802608:	83 c4 14             	add    $0x14,%esp
  80260b:	5e                   	pop    %esi
  80260c:	5f                   	pop    %edi
  80260d:	5d                   	pop    %ebp
  80260e:	c3                   	ret    
  80260f:	90                   	nop
  802610:	39 d7                	cmp    %edx,%edi
  802612:	75 da                	jne    8025ee <__umoddi3+0x10e>
  802614:	8b 14 24             	mov    (%esp),%edx
  802617:	89 c1                	mov    %eax,%ecx
  802619:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80261d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802621:	eb cb                	jmp    8025ee <__umoddi3+0x10e>
  802623:	90                   	nop
  802624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802628:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80262c:	0f 82 0f ff ff ff    	jb     802541 <__umoddi3+0x61>
  802632:	e9 1a ff ff ff       	jmp    802551 <__umoddi3+0x71>
