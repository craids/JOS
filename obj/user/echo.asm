
obj/user/echo.debug:     file format elf32-i386


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
  80002c:	e8 c3 00 00 00       	call   8000f4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
  800042:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800049:	83 ff 01             	cmp    $0x1,%edi
  80004c:	7e 2b                	jle    800079 <umain+0x46>
  80004e:	c7 44 24 04 00 27 80 	movl   $0x802700,0x4(%esp)
  800055:	00 
  800056:	8b 46 04             	mov    0x4(%esi),%eax
  800059:	89 04 24             	mov    %eax,(%esp)
  80005c:	e8 eb 01 00 00       	call   80024c <strcmp>
void
umain(int argc, char **argv)
{
	int i, nflag;

	nflag = 0;
  800061:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800068:	85 c0                	test   %eax,%eax
  80006a:	75 0d                	jne    800079 <umain+0x46>
		nflag = 1;
		argc--;
  80006c:	83 ef 01             	sub    $0x1,%edi
		argv++;
  80006f:	83 c6 04             	add    $0x4,%esi
{
	int i, nflag;

	nflag = 0;
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
  800072:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  800079:	bb 01 00 00 00       	mov    $0x1,%ebx
  80007e:	eb 46                	jmp    8000c6 <umain+0x93>
		if (i > 1)
  800080:	83 fb 01             	cmp    $0x1,%ebx
  800083:	7e 1c                	jle    8000a1 <umain+0x6e>
			write(1, " ", 1);
  800085:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80008c:	00 
  80008d:	c7 44 24 04 03 27 80 	movl   $0x802703,0x4(%esp)
  800094:	00 
  800095:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80009c:	e8 46 0c 00 00       	call   800ce7 <write>
		write(1, argv[i], strlen(argv[i]));
  8000a1:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8000a4:	89 04 24             	mov    %eax,(%esp)
  8000a7:	e8 b4 00 00 00       	call   800160 <strlen>
  8000ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000b0:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8000b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000be:	e8 24 0c 00 00       	call   800ce7 <write>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  8000c3:	83 c3 01             	add    $0x1,%ebx
  8000c6:	39 df                	cmp    %ebx,%edi
  8000c8:	7f b6                	jg     800080 <umain+0x4d>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  8000ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000ce:	75 1c                	jne    8000ec <umain+0xb9>
		write(1, "\n", 1);
  8000d0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000d7:	00 
  8000d8:	c7 44 24 04 50 28 80 	movl   $0x802850,0x4(%esp)
  8000df:	00 
  8000e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000e7:	e8 fb 0b 00 00       	call   800ce7 <write>
}
  8000ec:	83 c4 1c             	add    $0x1c,%esp
  8000ef:	5b                   	pop    %ebx
  8000f0:	5e                   	pop    %esi
  8000f1:	5f                   	pop    %edi
  8000f2:	5d                   	pop    %ebp
  8000f3:	c3                   	ret    

008000f4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 10             	sub    $0x10,%esp
  8000fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ff:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800102:	e8 6e 04 00 00       	call   800575 <sys_getenvid>
  800107:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010c:	c1 e0 07             	shl    $0x7,%eax
  80010f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800114:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800119:	85 db                	test   %ebx,%ebx
  80011b:	7e 07                	jle    800124 <libmain+0x30>
		binaryname = argv[0];
  80011d:	8b 06                	mov    (%esi),%eax
  80011f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800124:	89 74 24 04          	mov    %esi,0x4(%esp)
  800128:	89 1c 24             	mov    %ebx,(%esp)
  80012b:	e8 03 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800130:	e8 07 00 00 00       	call   80013c <exit>
}
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	5b                   	pop    %ebx
  800139:	5e                   	pop    %esi
  80013a:	5d                   	pop    %ebp
  80013b:	c3                   	ret    

0080013c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800142:	e8 93 09 00 00       	call   800ada <close_all>
	sys_env_destroy(0);
  800147:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014e:	e8 d0 03 00 00       	call   800523 <sys_env_destroy>
}
  800153:	c9                   	leave  
  800154:	c3                   	ret    
  800155:	66 90                	xchg   %ax,%ax
  800157:	66 90                	xchg   %ax,%ax
  800159:	66 90                	xchg   %ax,%ax
  80015b:	66 90                	xchg   %ax,%ax
  80015d:	66 90                	xchg   %ax,%ax
  80015f:	90                   	nop

00800160 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800166:	b8 00 00 00 00       	mov    $0x0,%eax
  80016b:	eb 03                	jmp    800170 <strlen+0x10>
		n++;
  80016d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800170:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800174:	75 f7                	jne    80016d <strlen+0xd>
		n++;
	return n;
}
  800176:	5d                   	pop    %ebp
  800177:	c3                   	ret    

00800178 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800178:	55                   	push   %ebp
  800179:	89 e5                	mov    %esp,%ebp
  80017b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80017e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800181:	b8 00 00 00 00       	mov    $0x0,%eax
  800186:	eb 03                	jmp    80018b <strnlen+0x13>
		n++;
  800188:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80018b:	39 d0                	cmp    %edx,%eax
  80018d:	74 06                	je     800195 <strnlen+0x1d>
  80018f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800193:	75 f3                	jne    800188 <strnlen+0x10>
		n++;
	return n;
}
  800195:	5d                   	pop    %ebp
  800196:	c3                   	ret    

00800197 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	53                   	push   %ebx
  80019b:	8b 45 08             	mov    0x8(%ebp),%eax
  80019e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8001a1:	89 c2                	mov    %eax,%edx
  8001a3:	83 c2 01             	add    $0x1,%edx
  8001a6:	83 c1 01             	add    $0x1,%ecx
  8001a9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8001ad:	88 5a ff             	mov    %bl,-0x1(%edx)
  8001b0:	84 db                	test   %bl,%bl
  8001b2:	75 ef                	jne    8001a3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8001b4:	5b                   	pop    %ebx
  8001b5:	5d                   	pop    %ebp
  8001b6:	c3                   	ret    

008001b7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	53                   	push   %ebx
  8001bb:	83 ec 08             	sub    $0x8,%esp
  8001be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8001c1:	89 1c 24             	mov    %ebx,(%esp)
  8001c4:	e8 97 ff ff ff       	call   800160 <strlen>
	strcpy(dst + len, src);
  8001c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8001d0:	01 d8                	add    %ebx,%eax
  8001d2:	89 04 24             	mov    %eax,(%esp)
  8001d5:	e8 bd ff ff ff       	call   800197 <strcpy>
	return dst;
}
  8001da:	89 d8                	mov    %ebx,%eax
  8001dc:	83 c4 08             	add    $0x8,%esp
  8001df:	5b                   	pop    %ebx
  8001e0:	5d                   	pop    %ebp
  8001e1:	c3                   	ret    

008001e2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001e2:	55                   	push   %ebp
  8001e3:	89 e5                	mov    %esp,%ebp
  8001e5:	56                   	push   %esi
  8001e6:	53                   	push   %ebx
  8001e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8001ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ed:	89 f3                	mov    %esi,%ebx
  8001ef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001f2:	89 f2                	mov    %esi,%edx
  8001f4:	eb 0f                	jmp    800205 <strncpy+0x23>
		*dst++ = *src;
  8001f6:	83 c2 01             	add    $0x1,%edx
  8001f9:	0f b6 01             	movzbl (%ecx),%eax
  8001fc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8001ff:	80 39 01             	cmpb   $0x1,(%ecx)
  800202:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800205:	39 da                	cmp    %ebx,%edx
  800207:	75 ed                	jne    8001f6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800209:	89 f0                	mov    %esi,%eax
  80020b:	5b                   	pop    %ebx
  80020c:	5e                   	pop    %esi
  80020d:	5d                   	pop    %ebp
  80020e:	c3                   	ret    

0080020f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	56                   	push   %esi
  800213:	53                   	push   %ebx
  800214:	8b 75 08             	mov    0x8(%ebp),%esi
  800217:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80021d:	89 f0                	mov    %esi,%eax
  80021f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800223:	85 c9                	test   %ecx,%ecx
  800225:	75 0b                	jne    800232 <strlcpy+0x23>
  800227:	eb 1d                	jmp    800246 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800229:	83 c0 01             	add    $0x1,%eax
  80022c:	83 c2 01             	add    $0x1,%edx
  80022f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800232:	39 d8                	cmp    %ebx,%eax
  800234:	74 0b                	je     800241 <strlcpy+0x32>
  800236:	0f b6 0a             	movzbl (%edx),%ecx
  800239:	84 c9                	test   %cl,%cl
  80023b:	75 ec                	jne    800229 <strlcpy+0x1a>
  80023d:	89 c2                	mov    %eax,%edx
  80023f:	eb 02                	jmp    800243 <strlcpy+0x34>
  800241:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800243:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800246:	29 f0                	sub    %esi,%eax
}
  800248:	5b                   	pop    %ebx
  800249:	5e                   	pop    %esi
  80024a:	5d                   	pop    %ebp
  80024b:	c3                   	ret    

0080024c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80024c:	55                   	push   %ebp
  80024d:	89 e5                	mov    %esp,%ebp
  80024f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800252:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800255:	eb 06                	jmp    80025d <strcmp+0x11>
		p++, q++;
  800257:	83 c1 01             	add    $0x1,%ecx
  80025a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80025d:	0f b6 01             	movzbl (%ecx),%eax
  800260:	84 c0                	test   %al,%al
  800262:	74 04                	je     800268 <strcmp+0x1c>
  800264:	3a 02                	cmp    (%edx),%al
  800266:	74 ef                	je     800257 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800268:	0f b6 c0             	movzbl %al,%eax
  80026b:	0f b6 12             	movzbl (%edx),%edx
  80026e:	29 d0                	sub    %edx,%eax
}
  800270:	5d                   	pop    %ebp
  800271:	c3                   	ret    

00800272 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800272:	55                   	push   %ebp
  800273:	89 e5                	mov    %esp,%ebp
  800275:	53                   	push   %ebx
  800276:	8b 45 08             	mov    0x8(%ebp),%eax
  800279:	8b 55 0c             	mov    0xc(%ebp),%edx
  80027c:	89 c3                	mov    %eax,%ebx
  80027e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800281:	eb 06                	jmp    800289 <strncmp+0x17>
		n--, p++, q++;
  800283:	83 c0 01             	add    $0x1,%eax
  800286:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800289:	39 d8                	cmp    %ebx,%eax
  80028b:	74 15                	je     8002a2 <strncmp+0x30>
  80028d:	0f b6 08             	movzbl (%eax),%ecx
  800290:	84 c9                	test   %cl,%cl
  800292:	74 04                	je     800298 <strncmp+0x26>
  800294:	3a 0a                	cmp    (%edx),%cl
  800296:	74 eb                	je     800283 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800298:	0f b6 00             	movzbl (%eax),%eax
  80029b:	0f b6 12             	movzbl (%edx),%edx
  80029e:	29 d0                	sub    %edx,%eax
  8002a0:	eb 05                	jmp    8002a7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8002a2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8002a7:	5b                   	pop    %ebx
  8002a8:	5d                   	pop    %ebp
  8002a9:	c3                   	ret    

008002aa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002b4:	eb 07                	jmp    8002bd <strchr+0x13>
		if (*s == c)
  8002b6:	38 ca                	cmp    %cl,%dl
  8002b8:	74 0f                	je     8002c9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8002ba:	83 c0 01             	add    $0x1,%eax
  8002bd:	0f b6 10             	movzbl (%eax),%edx
  8002c0:	84 d2                	test   %dl,%dl
  8002c2:	75 f2                	jne    8002b6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8002c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8002c9:	5d                   	pop    %ebp
  8002ca:	c3                   	ret    

008002cb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8002cb:	55                   	push   %ebp
  8002cc:	89 e5                	mov    %esp,%ebp
  8002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002d5:	eb 07                	jmp    8002de <strfind+0x13>
		if (*s == c)
  8002d7:	38 ca                	cmp    %cl,%dl
  8002d9:	74 0a                	je     8002e5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8002db:	83 c0 01             	add    $0x1,%eax
  8002de:	0f b6 10             	movzbl (%eax),%edx
  8002e1:	84 d2                	test   %dl,%dl
  8002e3:	75 f2                	jne    8002d7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8002e5:	5d                   	pop    %ebp
  8002e6:	c3                   	ret    

008002e7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	57                   	push   %edi
  8002eb:	56                   	push   %esi
  8002ec:	53                   	push   %ebx
  8002ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8002f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8002f3:	85 c9                	test   %ecx,%ecx
  8002f5:	74 36                	je     80032d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8002f7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8002fd:	75 28                	jne    800327 <memset+0x40>
  8002ff:	f6 c1 03             	test   $0x3,%cl
  800302:	75 23                	jne    800327 <memset+0x40>
		c &= 0xFF;
  800304:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800308:	89 d3                	mov    %edx,%ebx
  80030a:	c1 e3 08             	shl    $0x8,%ebx
  80030d:	89 d6                	mov    %edx,%esi
  80030f:	c1 e6 18             	shl    $0x18,%esi
  800312:	89 d0                	mov    %edx,%eax
  800314:	c1 e0 10             	shl    $0x10,%eax
  800317:	09 f0                	or     %esi,%eax
  800319:	09 c2                	or     %eax,%edx
  80031b:	89 d0                	mov    %edx,%eax
  80031d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80031f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800322:	fc                   	cld    
  800323:	f3 ab                	rep stos %eax,%es:(%edi)
  800325:	eb 06                	jmp    80032d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032a:	fc                   	cld    
  80032b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80032d:	89 f8                	mov    %edi,%eax
  80032f:	5b                   	pop    %ebx
  800330:	5e                   	pop    %esi
  800331:	5f                   	pop    %edi
  800332:	5d                   	pop    %ebp
  800333:	c3                   	ret    

00800334 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800334:	55                   	push   %ebp
  800335:	89 e5                	mov    %esp,%ebp
  800337:	57                   	push   %edi
  800338:	56                   	push   %esi
  800339:	8b 45 08             	mov    0x8(%ebp),%eax
  80033c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80033f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800342:	39 c6                	cmp    %eax,%esi
  800344:	73 35                	jae    80037b <memmove+0x47>
  800346:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800349:	39 d0                	cmp    %edx,%eax
  80034b:	73 2e                	jae    80037b <memmove+0x47>
		s += n;
		d += n;
  80034d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800350:	89 d6                	mov    %edx,%esi
  800352:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800354:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80035a:	75 13                	jne    80036f <memmove+0x3b>
  80035c:	f6 c1 03             	test   $0x3,%cl
  80035f:	75 0e                	jne    80036f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800361:	83 ef 04             	sub    $0x4,%edi
  800364:	8d 72 fc             	lea    -0x4(%edx),%esi
  800367:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80036a:	fd                   	std    
  80036b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80036d:	eb 09                	jmp    800378 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80036f:	83 ef 01             	sub    $0x1,%edi
  800372:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800375:	fd                   	std    
  800376:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800378:	fc                   	cld    
  800379:	eb 1d                	jmp    800398 <memmove+0x64>
  80037b:	89 f2                	mov    %esi,%edx
  80037d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80037f:	f6 c2 03             	test   $0x3,%dl
  800382:	75 0f                	jne    800393 <memmove+0x5f>
  800384:	f6 c1 03             	test   $0x3,%cl
  800387:	75 0a                	jne    800393 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800389:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80038c:	89 c7                	mov    %eax,%edi
  80038e:	fc                   	cld    
  80038f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800391:	eb 05                	jmp    800398 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800393:	89 c7                	mov    %eax,%edi
  800395:	fc                   	cld    
  800396:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800398:	5e                   	pop    %esi
  800399:	5f                   	pop    %edi
  80039a:	5d                   	pop    %ebp
  80039b:	c3                   	ret    

0080039c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8003a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b3:	89 04 24             	mov    %eax,(%esp)
  8003b6:	e8 79 ff ff ff       	call   800334 <memmove>
}
  8003bb:	c9                   	leave  
  8003bc:	c3                   	ret    

008003bd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	56                   	push   %esi
  8003c1:	53                   	push   %ebx
  8003c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003c8:	89 d6                	mov    %edx,%esi
  8003ca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8003cd:	eb 1a                	jmp    8003e9 <memcmp+0x2c>
		if (*s1 != *s2)
  8003cf:	0f b6 02             	movzbl (%edx),%eax
  8003d2:	0f b6 19             	movzbl (%ecx),%ebx
  8003d5:	38 d8                	cmp    %bl,%al
  8003d7:	74 0a                	je     8003e3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8003d9:	0f b6 c0             	movzbl %al,%eax
  8003dc:	0f b6 db             	movzbl %bl,%ebx
  8003df:	29 d8                	sub    %ebx,%eax
  8003e1:	eb 0f                	jmp    8003f2 <memcmp+0x35>
		s1++, s2++;
  8003e3:	83 c2 01             	add    $0x1,%edx
  8003e6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8003e9:	39 f2                	cmp    %esi,%edx
  8003eb:	75 e2                	jne    8003cf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8003ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8003f2:	5b                   	pop    %ebx
  8003f3:	5e                   	pop    %esi
  8003f4:	5d                   	pop    %ebp
  8003f5:	c3                   	ret    

008003f6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8003f6:	55                   	push   %ebp
  8003f7:	89 e5                	mov    %esp,%ebp
  8003f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8003ff:	89 c2                	mov    %eax,%edx
  800401:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800404:	eb 07                	jmp    80040d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800406:	38 08                	cmp    %cl,(%eax)
  800408:	74 07                	je     800411 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80040a:	83 c0 01             	add    $0x1,%eax
  80040d:	39 d0                	cmp    %edx,%eax
  80040f:	72 f5                	jb     800406 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800411:	5d                   	pop    %ebp
  800412:	c3                   	ret    

00800413 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800413:	55                   	push   %ebp
  800414:	89 e5                	mov    %esp,%ebp
  800416:	57                   	push   %edi
  800417:	56                   	push   %esi
  800418:	53                   	push   %ebx
  800419:	8b 55 08             	mov    0x8(%ebp),%edx
  80041c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80041f:	eb 03                	jmp    800424 <strtol+0x11>
		s++;
  800421:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800424:	0f b6 0a             	movzbl (%edx),%ecx
  800427:	80 f9 09             	cmp    $0x9,%cl
  80042a:	74 f5                	je     800421 <strtol+0xe>
  80042c:	80 f9 20             	cmp    $0x20,%cl
  80042f:	74 f0                	je     800421 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800431:	80 f9 2b             	cmp    $0x2b,%cl
  800434:	75 0a                	jne    800440 <strtol+0x2d>
		s++;
  800436:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800439:	bf 00 00 00 00       	mov    $0x0,%edi
  80043e:	eb 11                	jmp    800451 <strtol+0x3e>
  800440:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800445:	80 f9 2d             	cmp    $0x2d,%cl
  800448:	75 07                	jne    800451 <strtol+0x3e>
		s++, neg = 1;
  80044a:	8d 52 01             	lea    0x1(%edx),%edx
  80044d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800451:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800456:	75 15                	jne    80046d <strtol+0x5a>
  800458:	80 3a 30             	cmpb   $0x30,(%edx)
  80045b:	75 10                	jne    80046d <strtol+0x5a>
  80045d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800461:	75 0a                	jne    80046d <strtol+0x5a>
		s += 2, base = 16;
  800463:	83 c2 02             	add    $0x2,%edx
  800466:	b8 10 00 00 00       	mov    $0x10,%eax
  80046b:	eb 10                	jmp    80047d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80046d:	85 c0                	test   %eax,%eax
  80046f:	75 0c                	jne    80047d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800471:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800473:	80 3a 30             	cmpb   $0x30,(%edx)
  800476:	75 05                	jne    80047d <strtol+0x6a>
		s++, base = 8;
  800478:	83 c2 01             	add    $0x1,%edx
  80047b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80047d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800482:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800485:	0f b6 0a             	movzbl (%edx),%ecx
  800488:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80048b:	89 f0                	mov    %esi,%eax
  80048d:	3c 09                	cmp    $0x9,%al
  80048f:	77 08                	ja     800499 <strtol+0x86>
			dig = *s - '0';
  800491:	0f be c9             	movsbl %cl,%ecx
  800494:	83 e9 30             	sub    $0x30,%ecx
  800497:	eb 20                	jmp    8004b9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800499:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80049c:	89 f0                	mov    %esi,%eax
  80049e:	3c 19                	cmp    $0x19,%al
  8004a0:	77 08                	ja     8004aa <strtol+0x97>
			dig = *s - 'a' + 10;
  8004a2:	0f be c9             	movsbl %cl,%ecx
  8004a5:	83 e9 57             	sub    $0x57,%ecx
  8004a8:	eb 0f                	jmp    8004b9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  8004aa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8004ad:	89 f0                	mov    %esi,%eax
  8004af:	3c 19                	cmp    $0x19,%al
  8004b1:	77 16                	ja     8004c9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  8004b3:	0f be c9             	movsbl %cl,%ecx
  8004b6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8004b9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8004bc:	7d 0f                	jge    8004cd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  8004be:	83 c2 01             	add    $0x1,%edx
  8004c1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8004c5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8004c7:	eb bc                	jmp    800485 <strtol+0x72>
  8004c9:	89 d8                	mov    %ebx,%eax
  8004cb:	eb 02                	jmp    8004cf <strtol+0xbc>
  8004cd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  8004cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004d3:	74 05                	je     8004da <strtol+0xc7>
		*endptr = (char *) s;
  8004d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004d8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  8004da:	f7 d8                	neg    %eax
  8004dc:	85 ff                	test   %edi,%edi
  8004de:	0f 44 c3             	cmove  %ebx,%eax
}
  8004e1:	5b                   	pop    %ebx
  8004e2:	5e                   	pop    %esi
  8004e3:	5f                   	pop    %edi
  8004e4:	5d                   	pop    %ebp
  8004e5:	c3                   	ret    

008004e6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8004e6:	55                   	push   %ebp
  8004e7:	89 e5                	mov    %esp,%ebp
  8004e9:	57                   	push   %edi
  8004ea:	56                   	push   %esi
  8004eb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004f7:	89 c3                	mov    %eax,%ebx
  8004f9:	89 c7                	mov    %eax,%edi
  8004fb:	89 c6                	mov    %eax,%esi
  8004fd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8004ff:	5b                   	pop    %ebx
  800500:	5e                   	pop    %esi
  800501:	5f                   	pop    %edi
  800502:	5d                   	pop    %ebp
  800503:	c3                   	ret    

00800504 <sys_cgetc>:

int
sys_cgetc(void)
{
  800504:	55                   	push   %ebp
  800505:	89 e5                	mov    %esp,%ebp
  800507:	57                   	push   %edi
  800508:	56                   	push   %esi
  800509:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80050a:	ba 00 00 00 00       	mov    $0x0,%edx
  80050f:	b8 01 00 00 00       	mov    $0x1,%eax
  800514:	89 d1                	mov    %edx,%ecx
  800516:	89 d3                	mov    %edx,%ebx
  800518:	89 d7                	mov    %edx,%edi
  80051a:	89 d6                	mov    %edx,%esi
  80051c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80051e:	5b                   	pop    %ebx
  80051f:	5e                   	pop    %esi
  800520:	5f                   	pop    %edi
  800521:	5d                   	pop    %ebp
  800522:	c3                   	ret    

00800523 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800523:	55                   	push   %ebp
  800524:	89 e5                	mov    %esp,%ebp
  800526:	57                   	push   %edi
  800527:	56                   	push   %esi
  800528:	53                   	push   %ebx
  800529:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80052c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800531:	b8 03 00 00 00       	mov    $0x3,%eax
  800536:	8b 55 08             	mov    0x8(%ebp),%edx
  800539:	89 cb                	mov    %ecx,%ebx
  80053b:	89 cf                	mov    %ecx,%edi
  80053d:	89 ce                	mov    %ecx,%esi
  80053f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800541:	85 c0                	test   %eax,%eax
  800543:	7e 28                	jle    80056d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800545:	89 44 24 10          	mov    %eax,0x10(%esp)
  800549:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800550:	00 
  800551:	c7 44 24 08 0f 27 80 	movl   $0x80270f,0x8(%esp)
  800558:	00 
  800559:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800560:	00 
  800561:	c7 04 24 2c 27 80 00 	movl   $0x80272c,(%esp)
  800568:	e8 a9 16 00 00       	call   801c16 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80056d:	83 c4 2c             	add    $0x2c,%esp
  800570:	5b                   	pop    %ebx
  800571:	5e                   	pop    %esi
  800572:	5f                   	pop    %edi
  800573:	5d                   	pop    %ebp
  800574:	c3                   	ret    

00800575 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800575:	55                   	push   %ebp
  800576:	89 e5                	mov    %esp,%ebp
  800578:	57                   	push   %edi
  800579:	56                   	push   %esi
  80057a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80057b:	ba 00 00 00 00       	mov    $0x0,%edx
  800580:	b8 02 00 00 00       	mov    $0x2,%eax
  800585:	89 d1                	mov    %edx,%ecx
  800587:	89 d3                	mov    %edx,%ebx
  800589:	89 d7                	mov    %edx,%edi
  80058b:	89 d6                	mov    %edx,%esi
  80058d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80058f:	5b                   	pop    %ebx
  800590:	5e                   	pop    %esi
  800591:	5f                   	pop    %edi
  800592:	5d                   	pop    %ebp
  800593:	c3                   	ret    

00800594 <sys_yield>:

void
sys_yield(void)
{
  800594:	55                   	push   %ebp
  800595:	89 e5                	mov    %esp,%ebp
  800597:	57                   	push   %edi
  800598:	56                   	push   %esi
  800599:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80059a:	ba 00 00 00 00       	mov    $0x0,%edx
  80059f:	b8 0b 00 00 00       	mov    $0xb,%eax
  8005a4:	89 d1                	mov    %edx,%ecx
  8005a6:	89 d3                	mov    %edx,%ebx
  8005a8:	89 d7                	mov    %edx,%edi
  8005aa:	89 d6                	mov    %edx,%esi
  8005ac:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8005ae:	5b                   	pop    %ebx
  8005af:	5e                   	pop    %esi
  8005b0:	5f                   	pop    %edi
  8005b1:	5d                   	pop    %ebp
  8005b2:	c3                   	ret    

008005b3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8005b3:	55                   	push   %ebp
  8005b4:	89 e5                	mov    %esp,%ebp
  8005b6:	57                   	push   %edi
  8005b7:	56                   	push   %esi
  8005b8:	53                   	push   %ebx
  8005b9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8005bc:	be 00 00 00 00       	mov    $0x0,%esi
  8005c1:	b8 04 00 00 00       	mov    $0x4,%eax
  8005c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8005cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005cf:	89 f7                	mov    %esi,%edi
  8005d1:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8005d3:	85 c0                	test   %eax,%eax
  8005d5:	7e 28                	jle    8005ff <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8005d7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8005db:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8005e2:	00 
  8005e3:	c7 44 24 08 0f 27 80 	movl   $0x80270f,0x8(%esp)
  8005ea:	00 
  8005eb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8005f2:	00 
  8005f3:	c7 04 24 2c 27 80 00 	movl   $0x80272c,(%esp)
  8005fa:	e8 17 16 00 00       	call   801c16 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8005ff:	83 c4 2c             	add    $0x2c,%esp
  800602:	5b                   	pop    %ebx
  800603:	5e                   	pop    %esi
  800604:	5f                   	pop    %edi
  800605:	5d                   	pop    %ebp
  800606:	c3                   	ret    

00800607 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800607:	55                   	push   %ebp
  800608:	89 e5                	mov    %esp,%ebp
  80060a:	57                   	push   %edi
  80060b:	56                   	push   %esi
  80060c:	53                   	push   %ebx
  80060d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800610:	b8 05 00 00 00       	mov    $0x5,%eax
  800615:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800618:	8b 55 08             	mov    0x8(%ebp),%edx
  80061b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80061e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800621:	8b 75 18             	mov    0x18(%ebp),%esi
  800624:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800626:	85 c0                	test   %eax,%eax
  800628:	7e 28                	jle    800652 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80062a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80062e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800635:	00 
  800636:	c7 44 24 08 0f 27 80 	movl   $0x80270f,0x8(%esp)
  80063d:	00 
  80063e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800645:	00 
  800646:	c7 04 24 2c 27 80 00 	movl   $0x80272c,(%esp)
  80064d:	e8 c4 15 00 00       	call   801c16 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800652:	83 c4 2c             	add    $0x2c,%esp
  800655:	5b                   	pop    %ebx
  800656:	5e                   	pop    %esi
  800657:	5f                   	pop    %edi
  800658:	5d                   	pop    %ebp
  800659:	c3                   	ret    

0080065a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80065a:	55                   	push   %ebp
  80065b:	89 e5                	mov    %esp,%ebp
  80065d:	57                   	push   %edi
  80065e:	56                   	push   %esi
  80065f:	53                   	push   %ebx
  800660:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800663:	bb 00 00 00 00       	mov    $0x0,%ebx
  800668:	b8 06 00 00 00       	mov    $0x6,%eax
  80066d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800670:	8b 55 08             	mov    0x8(%ebp),%edx
  800673:	89 df                	mov    %ebx,%edi
  800675:	89 de                	mov    %ebx,%esi
  800677:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800679:	85 c0                	test   %eax,%eax
  80067b:	7e 28                	jle    8006a5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80067d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800681:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800688:	00 
  800689:	c7 44 24 08 0f 27 80 	movl   $0x80270f,0x8(%esp)
  800690:	00 
  800691:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800698:	00 
  800699:	c7 04 24 2c 27 80 00 	movl   $0x80272c,(%esp)
  8006a0:	e8 71 15 00 00       	call   801c16 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8006a5:	83 c4 2c             	add    $0x2c,%esp
  8006a8:	5b                   	pop    %ebx
  8006a9:	5e                   	pop    %esi
  8006aa:	5f                   	pop    %edi
  8006ab:	5d                   	pop    %ebp
  8006ac:	c3                   	ret    

008006ad <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8006ad:	55                   	push   %ebp
  8006ae:	89 e5                	mov    %esp,%ebp
  8006b0:	57                   	push   %edi
  8006b1:	56                   	push   %esi
  8006b2:	53                   	push   %ebx
  8006b3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8006b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006bb:	b8 08 00 00 00       	mov    $0x8,%eax
  8006c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8006c6:	89 df                	mov    %ebx,%edi
  8006c8:	89 de                	mov    %ebx,%esi
  8006ca:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8006cc:	85 c0                	test   %eax,%eax
  8006ce:	7e 28                	jle    8006f8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8006d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006d4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8006db:	00 
  8006dc:	c7 44 24 08 0f 27 80 	movl   $0x80270f,0x8(%esp)
  8006e3:	00 
  8006e4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8006eb:	00 
  8006ec:	c7 04 24 2c 27 80 00 	movl   $0x80272c,(%esp)
  8006f3:	e8 1e 15 00 00       	call   801c16 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8006f8:	83 c4 2c             	add    $0x2c,%esp
  8006fb:	5b                   	pop    %ebx
  8006fc:	5e                   	pop    %esi
  8006fd:	5f                   	pop    %edi
  8006fe:	5d                   	pop    %ebp
  8006ff:	c3                   	ret    

00800700 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800700:	55                   	push   %ebp
  800701:	89 e5                	mov    %esp,%ebp
  800703:	57                   	push   %edi
  800704:	56                   	push   %esi
  800705:	53                   	push   %ebx
  800706:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800709:	bb 00 00 00 00       	mov    $0x0,%ebx
  80070e:	b8 09 00 00 00       	mov    $0x9,%eax
  800713:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800716:	8b 55 08             	mov    0x8(%ebp),%edx
  800719:	89 df                	mov    %ebx,%edi
  80071b:	89 de                	mov    %ebx,%esi
  80071d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80071f:	85 c0                	test   %eax,%eax
  800721:	7e 28                	jle    80074b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800723:	89 44 24 10          	mov    %eax,0x10(%esp)
  800727:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80072e:	00 
  80072f:	c7 44 24 08 0f 27 80 	movl   $0x80270f,0x8(%esp)
  800736:	00 
  800737:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80073e:	00 
  80073f:	c7 04 24 2c 27 80 00 	movl   $0x80272c,(%esp)
  800746:	e8 cb 14 00 00       	call   801c16 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80074b:	83 c4 2c             	add    $0x2c,%esp
  80074e:	5b                   	pop    %ebx
  80074f:	5e                   	pop    %esi
  800750:	5f                   	pop    %edi
  800751:	5d                   	pop    %ebp
  800752:	c3                   	ret    

00800753 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
  800756:	57                   	push   %edi
  800757:	56                   	push   %esi
  800758:	53                   	push   %ebx
  800759:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80075c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800761:	b8 0a 00 00 00       	mov    $0xa,%eax
  800766:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800769:	8b 55 08             	mov    0x8(%ebp),%edx
  80076c:	89 df                	mov    %ebx,%edi
  80076e:	89 de                	mov    %ebx,%esi
  800770:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800772:	85 c0                	test   %eax,%eax
  800774:	7e 28                	jle    80079e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800776:	89 44 24 10          	mov    %eax,0x10(%esp)
  80077a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800781:	00 
  800782:	c7 44 24 08 0f 27 80 	movl   $0x80270f,0x8(%esp)
  800789:	00 
  80078a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800791:	00 
  800792:	c7 04 24 2c 27 80 00 	movl   $0x80272c,(%esp)
  800799:	e8 78 14 00 00       	call   801c16 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80079e:	83 c4 2c             	add    $0x2c,%esp
  8007a1:	5b                   	pop    %ebx
  8007a2:	5e                   	pop    %esi
  8007a3:	5f                   	pop    %edi
  8007a4:	5d                   	pop    %ebp
  8007a5:	c3                   	ret    

008007a6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	57                   	push   %edi
  8007aa:	56                   	push   %esi
  8007ab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8007ac:	be 00 00 00 00       	mov    $0x0,%esi
  8007b1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8007b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8007bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007bf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8007c2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8007c4:	5b                   	pop    %ebx
  8007c5:	5e                   	pop    %esi
  8007c6:	5f                   	pop    %edi
  8007c7:	5d                   	pop    %ebp
  8007c8:	c3                   	ret    

008007c9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	57                   	push   %edi
  8007cd:	56                   	push   %esi
  8007ce:	53                   	push   %ebx
  8007cf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8007d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007d7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8007dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8007df:	89 cb                	mov    %ecx,%ebx
  8007e1:	89 cf                	mov    %ecx,%edi
  8007e3:	89 ce                	mov    %ecx,%esi
  8007e5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8007e7:	85 c0                	test   %eax,%eax
  8007e9:	7e 28                	jle    800813 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8007eb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8007ef:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8007f6:	00 
  8007f7:	c7 44 24 08 0f 27 80 	movl   $0x80270f,0x8(%esp)
  8007fe:	00 
  8007ff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800806:	00 
  800807:	c7 04 24 2c 27 80 00 	movl   $0x80272c,(%esp)
  80080e:	e8 03 14 00 00       	call   801c16 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800813:	83 c4 2c             	add    $0x2c,%esp
  800816:	5b                   	pop    %ebx
  800817:	5e                   	pop    %esi
  800818:	5f                   	pop    %edi
  800819:	5d                   	pop    %ebp
  80081a:	c3                   	ret    

0080081b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80081b:	55                   	push   %ebp
  80081c:	89 e5                	mov    %esp,%ebp
  80081e:	57                   	push   %edi
  80081f:	56                   	push   %esi
  800820:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800821:	ba 00 00 00 00       	mov    $0x0,%edx
  800826:	b8 0e 00 00 00       	mov    $0xe,%eax
  80082b:	89 d1                	mov    %edx,%ecx
  80082d:	89 d3                	mov    %edx,%ebx
  80082f:	89 d7                	mov    %edx,%edi
  800831:	89 d6                	mov    %edx,%esi
  800833:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800835:	5b                   	pop    %ebx
  800836:	5e                   	pop    %esi
  800837:	5f                   	pop    %edi
  800838:	5d                   	pop    %ebp
  800839:	c3                   	ret    

0080083a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	57                   	push   %edi
  80083e:	56                   	push   %esi
  80083f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800840:	bb 00 00 00 00       	mov    $0x0,%ebx
  800845:	b8 0f 00 00 00       	mov    $0xf,%eax
  80084a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80084d:	8b 55 08             	mov    0x8(%ebp),%edx
  800850:	89 df                	mov    %ebx,%edi
  800852:	89 de                	mov    %ebx,%esi
  800854:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800856:	5b                   	pop    %ebx
  800857:	5e                   	pop    %esi
  800858:	5f                   	pop    %edi
  800859:	5d                   	pop    %ebp
  80085a:	c3                   	ret    

0080085b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	57                   	push   %edi
  80085f:	56                   	push   %esi
  800860:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800861:	bb 00 00 00 00       	mov    $0x0,%ebx
  800866:	b8 10 00 00 00       	mov    $0x10,%eax
  80086b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80086e:	8b 55 08             	mov    0x8(%ebp),%edx
  800871:	89 df                	mov    %ebx,%edi
  800873:	89 de                	mov    %ebx,%esi
  800875:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800877:	5b                   	pop    %ebx
  800878:	5e                   	pop    %esi
  800879:	5f                   	pop    %edi
  80087a:	5d                   	pop    %ebp
  80087b:	c3                   	ret    

0080087c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	57                   	push   %edi
  800880:	56                   	push   %esi
  800881:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800882:	b9 00 00 00 00       	mov    $0x0,%ecx
  800887:	b8 11 00 00 00       	mov    $0x11,%eax
  80088c:	8b 55 08             	mov    0x8(%ebp),%edx
  80088f:	89 cb                	mov    %ecx,%ebx
  800891:	89 cf                	mov    %ecx,%edi
  800893:	89 ce                	mov    %ecx,%esi
  800895:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800897:	5b                   	pop    %ebx
  800898:	5e                   	pop    %esi
  800899:	5f                   	pop    %edi
  80089a:	5d                   	pop    %ebp
  80089b:	c3                   	ret    

0080089c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	57                   	push   %edi
  8008a0:	56                   	push   %esi
  8008a1:	53                   	push   %ebx
  8008a2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8008a5:	be 00 00 00 00       	mov    $0x0,%esi
  8008aa:	b8 12 00 00 00       	mov    $0x12,%eax
  8008af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8008b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008b8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8008bb:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8008bd:	85 c0                	test   %eax,%eax
  8008bf:	7e 28                	jle    8008e9 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  8008c1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8008c5:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  8008cc:	00 
  8008cd:	c7 44 24 08 0f 27 80 	movl   $0x80270f,0x8(%esp)
  8008d4:	00 
  8008d5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8008dc:	00 
  8008dd:	c7 04 24 2c 27 80 00 	movl   $0x80272c,(%esp)
  8008e4:	e8 2d 13 00 00       	call   801c16 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  8008e9:	83 c4 2c             	add    $0x2c,%esp
  8008ec:	5b                   	pop    %ebx
  8008ed:	5e                   	pop    %esi
  8008ee:	5f                   	pop    %edi
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    
  8008f1:	66 90                	xchg   %ax,%ax
  8008f3:	66 90                	xchg   %ax,%ax
  8008f5:	66 90                	xchg   %ax,%ax
  8008f7:	66 90                	xchg   %ax,%ax
  8008f9:	66 90                	xchg   %ax,%ax
  8008fb:	66 90                	xchg   %ax,%ax
  8008fd:	66 90                	xchg   %ax,%ax
  8008ff:	90                   	nop

00800900 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	05 00 00 00 30       	add    $0x30000000,%eax
  80090b:	c1 e8 0c             	shr    $0xc,%eax
}
  80090e:	5d                   	pop    %ebp
  80090f:	c3                   	ret    

00800910 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80091b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800920:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80092d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800932:	89 c2                	mov    %eax,%edx
  800934:	c1 ea 16             	shr    $0x16,%edx
  800937:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80093e:	f6 c2 01             	test   $0x1,%dl
  800941:	74 11                	je     800954 <fd_alloc+0x2d>
  800943:	89 c2                	mov    %eax,%edx
  800945:	c1 ea 0c             	shr    $0xc,%edx
  800948:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80094f:	f6 c2 01             	test   $0x1,%dl
  800952:	75 09                	jne    80095d <fd_alloc+0x36>
			*fd_store = fd;
  800954:	89 01                	mov    %eax,(%ecx)
			return 0;
  800956:	b8 00 00 00 00       	mov    $0x0,%eax
  80095b:	eb 17                	jmp    800974 <fd_alloc+0x4d>
  80095d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800962:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800967:	75 c9                	jne    800932 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800969:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80096f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80097c:	83 f8 1f             	cmp    $0x1f,%eax
  80097f:	77 36                	ja     8009b7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800981:	c1 e0 0c             	shl    $0xc,%eax
  800984:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800989:	89 c2                	mov    %eax,%edx
  80098b:	c1 ea 16             	shr    $0x16,%edx
  80098e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800995:	f6 c2 01             	test   $0x1,%dl
  800998:	74 24                	je     8009be <fd_lookup+0x48>
  80099a:	89 c2                	mov    %eax,%edx
  80099c:	c1 ea 0c             	shr    $0xc,%edx
  80099f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8009a6:	f6 c2 01             	test   $0x1,%dl
  8009a9:	74 1a                	je     8009c5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ae:	89 02                	mov    %eax,(%edx)
	return 0;
  8009b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b5:	eb 13                	jmp    8009ca <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8009b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009bc:	eb 0c                	jmp    8009ca <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8009be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009c3:	eb 05                	jmp    8009ca <fd_lookup+0x54>
  8009c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	83 ec 18             	sub    $0x18,%esp
  8009d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8009d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009da:	eb 13                	jmp    8009ef <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8009dc:	39 08                	cmp    %ecx,(%eax)
  8009de:	75 0c                	jne    8009ec <dev_lookup+0x20>
			*dev = devtab[i];
  8009e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8009e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ea:	eb 38                	jmp    800a24 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8009ec:	83 c2 01             	add    $0x1,%edx
  8009ef:	8b 04 95 b8 27 80 00 	mov    0x8027b8(,%edx,4),%eax
  8009f6:	85 c0                	test   %eax,%eax
  8009f8:	75 e2                	jne    8009dc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8009fa:	a1 08 40 80 00       	mov    0x804008,%eax
  8009ff:	8b 40 48             	mov    0x48(%eax),%eax
  800a02:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800a06:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a0a:	c7 04 24 3c 27 80 00 	movl   $0x80273c,(%esp)
  800a11:	e8 f9 12 00 00       	call   801d0f <cprintf>
	*dev = 0;
  800a16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800a1f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800a24:	c9                   	leave  
  800a25:	c3                   	ret    

00800a26 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	56                   	push   %esi
  800a2a:	53                   	push   %ebx
  800a2b:	83 ec 20             	sub    $0x20,%esp
  800a2e:	8b 75 08             	mov    0x8(%ebp),%esi
  800a31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800a34:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a37:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800a3b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800a41:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800a44:	89 04 24             	mov    %eax,(%esp)
  800a47:	e8 2a ff ff ff       	call   800976 <fd_lookup>
  800a4c:	85 c0                	test   %eax,%eax
  800a4e:	78 05                	js     800a55 <fd_close+0x2f>
	    || fd != fd2)
  800a50:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800a53:	74 0c                	je     800a61 <fd_close+0x3b>
		return (must_exist ? r : 0);
  800a55:	84 db                	test   %bl,%bl
  800a57:	ba 00 00 00 00       	mov    $0x0,%edx
  800a5c:	0f 44 c2             	cmove  %edx,%eax
  800a5f:	eb 3f                	jmp    800aa0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800a61:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a64:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a68:	8b 06                	mov    (%esi),%eax
  800a6a:	89 04 24             	mov    %eax,(%esp)
  800a6d:	e8 5a ff ff ff       	call   8009cc <dev_lookup>
  800a72:	89 c3                	mov    %eax,%ebx
  800a74:	85 c0                	test   %eax,%eax
  800a76:	78 16                	js     800a8e <fd_close+0x68>
		if (dev->dev_close)
  800a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800a7e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800a83:	85 c0                	test   %eax,%eax
  800a85:	74 07                	je     800a8e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800a87:	89 34 24             	mov    %esi,(%esp)
  800a8a:	ff d0                	call   *%eax
  800a8c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800a8e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a99:	e8 bc fb ff ff       	call   80065a <sys_page_unmap>
	return r;
  800a9e:	89 d8                	mov    %ebx,%eax
}
  800aa0:	83 c4 20             	add    $0x20,%esp
  800aa3:	5b                   	pop    %ebx
  800aa4:	5e                   	pop    %esi
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    

00800aa7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800aad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	89 04 24             	mov    %eax,(%esp)
  800aba:	e8 b7 fe ff ff       	call   800976 <fd_lookup>
  800abf:	89 c2                	mov    %eax,%edx
  800ac1:	85 d2                	test   %edx,%edx
  800ac3:	78 13                	js     800ad8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  800ac5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800acc:	00 
  800acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ad0:	89 04 24             	mov    %eax,(%esp)
  800ad3:	e8 4e ff ff ff       	call   800a26 <fd_close>
}
  800ad8:	c9                   	leave  
  800ad9:	c3                   	ret    

00800ada <close_all>:

void
close_all(void)
{
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	53                   	push   %ebx
  800ade:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800ae1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800ae6:	89 1c 24             	mov    %ebx,(%esp)
  800ae9:	e8 b9 ff ff ff       	call   800aa7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800aee:	83 c3 01             	add    $0x1,%ebx
  800af1:	83 fb 20             	cmp    $0x20,%ebx
  800af4:	75 f0                	jne    800ae6 <close_all+0xc>
		close(i);
}
  800af6:	83 c4 14             	add    $0x14,%esp
  800af9:	5b                   	pop    %ebx
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    

00800afc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	57                   	push   %edi
  800b00:	56                   	push   %esi
  800b01:	53                   	push   %ebx
  800b02:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800b05:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800b08:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	89 04 24             	mov    %eax,(%esp)
  800b12:	e8 5f fe ff ff       	call   800976 <fd_lookup>
  800b17:	89 c2                	mov    %eax,%edx
  800b19:	85 d2                	test   %edx,%edx
  800b1b:	0f 88 e1 00 00 00    	js     800c02 <dup+0x106>
		return r;
	close(newfdnum);
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	89 04 24             	mov    %eax,(%esp)
  800b27:	e8 7b ff ff ff       	call   800aa7 <close>

	newfd = INDEX2FD(newfdnum);
  800b2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b2f:	c1 e3 0c             	shl    $0xc,%ebx
  800b32:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800b38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b3b:	89 04 24             	mov    %eax,(%esp)
  800b3e:	e8 cd fd ff ff       	call   800910 <fd2data>
  800b43:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  800b45:	89 1c 24             	mov    %ebx,(%esp)
  800b48:	e8 c3 fd ff ff       	call   800910 <fd2data>
  800b4d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800b4f:	89 f0                	mov    %esi,%eax
  800b51:	c1 e8 16             	shr    $0x16,%eax
  800b54:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800b5b:	a8 01                	test   $0x1,%al
  800b5d:	74 43                	je     800ba2 <dup+0xa6>
  800b5f:	89 f0                	mov    %esi,%eax
  800b61:	c1 e8 0c             	shr    $0xc,%eax
  800b64:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800b6b:	f6 c2 01             	test   $0x1,%dl
  800b6e:	74 32                	je     800ba2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800b70:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800b77:	25 07 0e 00 00       	and    $0xe07,%eax
  800b7c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b80:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800b84:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800b8b:	00 
  800b8c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b97:	e8 6b fa ff ff       	call   800607 <sys_page_map>
  800b9c:	89 c6                	mov    %eax,%esi
  800b9e:	85 c0                	test   %eax,%eax
  800ba0:	78 3e                	js     800be0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800ba2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ba5:	89 c2                	mov    %eax,%edx
  800ba7:	c1 ea 0c             	shr    $0xc,%edx
  800baa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800bb1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800bb7:	89 54 24 10          	mov    %edx,0x10(%esp)
  800bbb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800bbf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800bc6:	00 
  800bc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bcb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800bd2:	e8 30 fa ff ff       	call   800607 <sys_page_map>
  800bd7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  800bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800bdc:	85 f6                	test   %esi,%esi
  800bde:	79 22                	jns    800c02 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800be0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800be4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800beb:	e8 6a fa ff ff       	call   80065a <sys_page_unmap>
	sys_page_unmap(0, nva);
  800bf0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bf4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800bfb:	e8 5a fa ff ff       	call   80065a <sys_page_unmap>
	return r;
  800c00:	89 f0                	mov    %esi,%eax
}
  800c02:	83 c4 3c             	add    $0x3c,%esp
  800c05:	5b                   	pop    %ebx
  800c06:	5e                   	pop    %esi
  800c07:	5f                   	pop    %edi
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	53                   	push   %ebx
  800c0e:	83 ec 24             	sub    $0x24,%esp
  800c11:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c14:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c17:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c1b:	89 1c 24             	mov    %ebx,(%esp)
  800c1e:	e8 53 fd ff ff       	call   800976 <fd_lookup>
  800c23:	89 c2                	mov    %eax,%edx
  800c25:	85 d2                	test   %edx,%edx
  800c27:	78 6d                	js     800c96 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c29:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	89 04 24             	mov    %eax,(%esp)
  800c38:	e8 8f fd ff ff       	call   8009cc <dev_lookup>
  800c3d:	85 c0                	test   %eax,%eax
  800c3f:	78 55                	js     800c96 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c44:	8b 50 08             	mov    0x8(%eax),%edx
  800c47:	83 e2 03             	and    $0x3,%edx
  800c4a:	83 fa 01             	cmp    $0x1,%edx
  800c4d:	75 23                	jne    800c72 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800c4f:	a1 08 40 80 00       	mov    0x804008,%eax
  800c54:	8b 40 48             	mov    0x48(%eax),%eax
  800c57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800c5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c5f:	c7 04 24 7d 27 80 00 	movl   $0x80277d,(%esp)
  800c66:	e8 a4 10 00 00       	call   801d0f <cprintf>
		return -E_INVAL;
  800c6b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800c70:	eb 24                	jmp    800c96 <read+0x8c>
	}
	if (!dev->dev_read)
  800c72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c75:	8b 52 08             	mov    0x8(%edx),%edx
  800c78:	85 d2                	test   %edx,%edx
  800c7a:	74 15                	je     800c91 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800c7c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c7f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800c83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800c8a:	89 04 24             	mov    %eax,(%esp)
  800c8d:	ff d2                	call   *%edx
  800c8f:	eb 05                	jmp    800c96 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800c91:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800c96:	83 c4 24             	add    $0x24,%esp
  800c99:	5b                   	pop    %ebx
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    

00800c9c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	57                   	push   %edi
  800ca0:	56                   	push   %esi
  800ca1:	53                   	push   %ebx
  800ca2:	83 ec 1c             	sub    $0x1c,%esp
  800ca5:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ca8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800cab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb0:	eb 23                	jmp    800cd5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800cb2:	89 f0                	mov    %esi,%eax
  800cb4:	29 d8                	sub    %ebx,%eax
  800cb6:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cba:	89 d8                	mov    %ebx,%eax
  800cbc:	03 45 0c             	add    0xc(%ebp),%eax
  800cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cc3:	89 3c 24             	mov    %edi,(%esp)
  800cc6:	e8 3f ff ff ff       	call   800c0a <read>
		if (m < 0)
  800ccb:	85 c0                	test   %eax,%eax
  800ccd:	78 10                	js     800cdf <readn+0x43>
			return m;
		if (m == 0)
  800ccf:	85 c0                	test   %eax,%eax
  800cd1:	74 0a                	je     800cdd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800cd3:	01 c3                	add    %eax,%ebx
  800cd5:	39 f3                	cmp    %esi,%ebx
  800cd7:	72 d9                	jb     800cb2 <readn+0x16>
  800cd9:	89 d8                	mov    %ebx,%eax
  800cdb:	eb 02                	jmp    800cdf <readn+0x43>
  800cdd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  800cdf:	83 c4 1c             	add    $0x1c,%esp
  800ce2:	5b                   	pop    %ebx
  800ce3:	5e                   	pop    %esi
  800ce4:	5f                   	pop    %edi
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	53                   	push   %ebx
  800ceb:	83 ec 24             	sub    $0x24,%esp
  800cee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cf1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cf8:	89 1c 24             	mov    %ebx,(%esp)
  800cfb:	e8 76 fc ff ff       	call   800976 <fd_lookup>
  800d00:	89 c2                	mov    %eax,%edx
  800d02:	85 d2                	test   %edx,%edx
  800d04:	78 68                	js     800d6e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d09:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d10:	8b 00                	mov    (%eax),%eax
  800d12:	89 04 24             	mov    %eax,(%esp)
  800d15:	e8 b2 fc ff ff       	call   8009cc <dev_lookup>
  800d1a:	85 c0                	test   %eax,%eax
  800d1c:	78 50                	js     800d6e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d21:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800d25:	75 23                	jne    800d4a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800d27:	a1 08 40 80 00       	mov    0x804008,%eax
  800d2c:	8b 40 48             	mov    0x48(%eax),%eax
  800d2f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800d33:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d37:	c7 04 24 99 27 80 00 	movl   $0x802799,(%esp)
  800d3e:	e8 cc 0f 00 00       	call   801d0f <cprintf>
		return -E_INVAL;
  800d43:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d48:	eb 24                	jmp    800d6e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800d4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d4d:	8b 52 0c             	mov    0xc(%edx),%edx
  800d50:	85 d2                	test   %edx,%edx
  800d52:	74 15                	je     800d69 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800d54:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d57:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800d5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800d62:	89 04 24             	mov    %eax,(%esp)
  800d65:	ff d2                	call   *%edx
  800d67:	eb 05                	jmp    800d6e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800d69:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  800d6e:	83 c4 24             	add    $0x24,%esp
  800d71:	5b                   	pop    %ebx
  800d72:	5d                   	pop    %ebp
  800d73:	c3                   	ret    

00800d74 <seek>:

int
seek(int fdnum, off_t offset)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800d7a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800d7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	89 04 24             	mov    %eax,(%esp)
  800d87:	e8 ea fb ff ff       	call   800976 <fd_lookup>
  800d8c:	85 c0                	test   %eax,%eax
  800d8e:	78 0e                	js     800d9e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800d90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d96:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800d99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d9e:	c9                   	leave  
  800d9f:	c3                   	ret    

00800da0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	53                   	push   %ebx
  800da4:	83 ec 24             	sub    $0x24,%esp
  800da7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800daa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dad:	89 44 24 04          	mov    %eax,0x4(%esp)
  800db1:	89 1c 24             	mov    %ebx,(%esp)
  800db4:	e8 bd fb ff ff       	call   800976 <fd_lookup>
  800db9:	89 c2                	mov    %eax,%edx
  800dbb:	85 d2                	test   %edx,%edx
  800dbd:	78 61                	js     800e20 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800dbf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dc9:	8b 00                	mov    (%eax),%eax
  800dcb:	89 04 24             	mov    %eax,(%esp)
  800dce:	e8 f9 fb ff ff       	call   8009cc <dev_lookup>
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	78 49                	js     800e20 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dda:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800dde:	75 23                	jne    800e03 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800de0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800de5:	8b 40 48             	mov    0x48(%eax),%eax
  800de8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800dec:	89 44 24 04          	mov    %eax,0x4(%esp)
  800df0:	c7 04 24 5c 27 80 00 	movl   $0x80275c,(%esp)
  800df7:	e8 13 0f 00 00       	call   801d0f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800dfc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e01:	eb 1d                	jmp    800e20 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  800e03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e06:	8b 52 18             	mov    0x18(%edx),%edx
  800e09:	85 d2                	test   %edx,%edx
  800e0b:	74 0e                	je     800e1b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e10:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800e14:	89 04 24             	mov    %eax,(%esp)
  800e17:	ff d2                	call   *%edx
  800e19:	eb 05                	jmp    800e20 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800e1b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800e20:	83 c4 24             	add    $0x24,%esp
  800e23:	5b                   	pop    %ebx
  800e24:	5d                   	pop    %ebp
  800e25:	c3                   	ret    

00800e26 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	53                   	push   %ebx
  800e2a:	83 ec 24             	sub    $0x24,%esp
  800e2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e30:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e33:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	89 04 24             	mov    %eax,(%esp)
  800e3d:	e8 34 fb ff ff       	call   800976 <fd_lookup>
  800e42:	89 c2                	mov    %eax,%edx
  800e44:	85 d2                	test   %edx,%edx
  800e46:	78 52                	js     800e9a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e52:	8b 00                	mov    (%eax),%eax
  800e54:	89 04 24             	mov    %eax,(%esp)
  800e57:	e8 70 fb ff ff       	call   8009cc <dev_lookup>
  800e5c:	85 c0                	test   %eax,%eax
  800e5e:	78 3a                	js     800e9a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e63:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800e67:	74 2c                	je     800e95 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800e69:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800e6c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800e73:	00 00 00 
	stat->st_isdir = 0;
  800e76:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800e7d:	00 00 00 
	stat->st_dev = dev;
  800e80:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800e86:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800e8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e8d:	89 14 24             	mov    %edx,(%esp)
  800e90:	ff 50 14             	call   *0x14(%eax)
  800e93:	eb 05                	jmp    800e9a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800e95:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800e9a:	83 c4 24             	add    $0x24,%esp
  800e9d:	5b                   	pop    %ebx
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    

00800ea0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
  800ea5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800ea8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800eaf:	00 
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	89 04 24             	mov    %eax,(%esp)
  800eb6:	e8 84 02 00 00       	call   80113f <open>
  800ebb:	89 c3                	mov    %eax,%ebx
  800ebd:	85 db                	test   %ebx,%ebx
  800ebf:	78 1b                	js     800edc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ec8:	89 1c 24             	mov    %ebx,(%esp)
  800ecb:	e8 56 ff ff ff       	call   800e26 <fstat>
  800ed0:	89 c6                	mov    %eax,%esi
	close(fd);
  800ed2:	89 1c 24             	mov    %ebx,(%esp)
  800ed5:	e8 cd fb ff ff       	call   800aa7 <close>
	return r;
  800eda:	89 f0                	mov    %esi,%eax
}
  800edc:	83 c4 10             	add    $0x10,%esp
  800edf:	5b                   	pop    %ebx
  800ee0:	5e                   	pop    %esi
  800ee1:	5d                   	pop    %ebp
  800ee2:	c3                   	ret    

00800ee3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	56                   	push   %esi
  800ee7:	53                   	push   %ebx
  800ee8:	83 ec 10             	sub    $0x10,%esp
  800eeb:	89 c6                	mov    %eax,%esi
  800eed:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800eef:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800ef6:	75 11                	jne    800f09 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ef8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800eff:	e8 f1 14 00 00       	call   8023f5 <ipc_find_env>
  800f04:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800f09:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800f10:	00 
  800f11:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800f18:	00 
  800f19:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f1d:	a1 00 40 80 00       	mov    0x804000,%eax
  800f22:	89 04 24             	mov    %eax,(%esp)
  800f25:	e8 3e 14 00 00       	call   802368 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800f2a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800f31:	00 
  800f32:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800f36:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f3d:	e8 be 13 00 00       	call   802300 <ipc_recv>
}
  800f42:	83 c4 10             	add    $0x10,%esp
  800f45:	5b                   	pop    %ebx
  800f46:	5e                   	pop    %esi
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    

00800f49 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800f49:	55                   	push   %ebp
  800f4a:	89 e5                	mov    %esp,%ebp
  800f4c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8b 40 0c             	mov    0xc(%eax),%eax
  800f55:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800f62:	ba 00 00 00 00       	mov    $0x0,%edx
  800f67:	b8 02 00 00 00       	mov    $0x2,%eax
  800f6c:	e8 72 ff ff ff       	call   800ee3 <fsipc>
}
  800f71:	c9                   	leave  
  800f72:	c3                   	ret    

00800f73 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	8b 40 0c             	mov    0xc(%eax),%eax
  800f7f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800f84:	ba 00 00 00 00       	mov    $0x0,%edx
  800f89:	b8 06 00 00 00       	mov    $0x6,%eax
  800f8e:	e8 50 ff ff ff       	call   800ee3 <fsipc>
}
  800f93:	c9                   	leave  
  800f94:	c3                   	ret    

00800f95 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	53                   	push   %ebx
  800f99:	83 ec 14             	sub    $0x14,%esp
  800f9c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8b 40 0c             	mov    0xc(%eax),%eax
  800fa5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800faa:	ba 00 00 00 00       	mov    $0x0,%edx
  800faf:	b8 05 00 00 00       	mov    $0x5,%eax
  800fb4:	e8 2a ff ff ff       	call   800ee3 <fsipc>
  800fb9:	89 c2                	mov    %eax,%edx
  800fbb:	85 d2                	test   %edx,%edx
  800fbd:	78 2b                	js     800fea <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800fbf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800fc6:	00 
  800fc7:	89 1c 24             	mov    %ebx,(%esp)
  800fca:	e8 c8 f1 ff ff       	call   800197 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800fcf:	a1 80 50 80 00       	mov    0x805080,%eax
  800fd4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800fda:	a1 84 50 80 00       	mov    0x805084,%eax
  800fdf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800fe5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fea:	83 c4 14             	add    $0x14,%esp
  800fed:	5b                   	pop    %ebx
  800fee:	5d                   	pop    %ebp
  800fef:	c3                   	ret    

00800ff0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
  800ff3:	53                   	push   %ebx
  800ff4:	83 ec 14             	sub    $0x14,%esp
  800ff7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8b 40 0c             	mov    0xc(%eax),%eax
  801000:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801005:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80100b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801010:	0f 46 c3             	cmovbe %ebx,%eax
  801013:	a3 04 50 80 00       	mov    %eax,0x805004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801018:	89 44 24 08          	mov    %eax,0x8(%esp)
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801023:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80102a:	e8 05 f3 ff ff       	call   800334 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80102f:	ba 00 00 00 00       	mov    $0x0,%edx
  801034:	b8 04 00 00 00       	mov    $0x4,%eax
  801039:	e8 a5 fe ff ff       	call   800ee3 <fsipc>
  80103e:	85 c0                	test   %eax,%eax
  801040:	78 53                	js     801095 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801042:	39 c3                	cmp    %eax,%ebx
  801044:	73 24                	jae    80106a <devfile_write+0x7a>
  801046:	c7 44 24 0c cc 27 80 	movl   $0x8027cc,0xc(%esp)
  80104d:	00 
  80104e:	c7 44 24 08 d3 27 80 	movl   $0x8027d3,0x8(%esp)
  801055:	00 
  801056:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  80105d:	00 
  80105e:	c7 04 24 e8 27 80 00 	movl   $0x8027e8,(%esp)
  801065:	e8 ac 0b 00 00       	call   801c16 <_panic>
	assert(r <= PGSIZE);
  80106a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80106f:	7e 24                	jle    801095 <devfile_write+0xa5>
  801071:	c7 44 24 0c f3 27 80 	movl   $0x8027f3,0xc(%esp)
  801078:	00 
  801079:	c7 44 24 08 d3 27 80 	movl   $0x8027d3,0x8(%esp)
  801080:	00 
  801081:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801088:	00 
  801089:	c7 04 24 e8 27 80 00 	movl   $0x8027e8,(%esp)
  801090:	e8 81 0b 00 00       	call   801c16 <_panic>
	return r;
}
  801095:	83 c4 14             	add    $0x14,%esp
  801098:	5b                   	pop    %ebx
  801099:	5d                   	pop    %ebp
  80109a:	c3                   	ret    

0080109b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	56                   	push   %esi
  80109f:	53                   	push   %ebx
  8010a0:	83 ec 10             	sub    $0x10,%esp
  8010a3:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8010ac:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8010b1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8010b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8010bc:	b8 03 00 00 00       	mov    $0x3,%eax
  8010c1:	e8 1d fe ff ff       	call   800ee3 <fsipc>
  8010c6:	89 c3                	mov    %eax,%ebx
  8010c8:	85 c0                	test   %eax,%eax
  8010ca:	78 6a                	js     801136 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8010cc:	39 c6                	cmp    %eax,%esi
  8010ce:	73 24                	jae    8010f4 <devfile_read+0x59>
  8010d0:	c7 44 24 0c cc 27 80 	movl   $0x8027cc,0xc(%esp)
  8010d7:	00 
  8010d8:	c7 44 24 08 d3 27 80 	movl   $0x8027d3,0x8(%esp)
  8010df:	00 
  8010e0:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8010e7:	00 
  8010e8:	c7 04 24 e8 27 80 00 	movl   $0x8027e8,(%esp)
  8010ef:	e8 22 0b 00 00       	call   801c16 <_panic>
	assert(r <= PGSIZE);
  8010f4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8010f9:	7e 24                	jle    80111f <devfile_read+0x84>
  8010fb:	c7 44 24 0c f3 27 80 	movl   $0x8027f3,0xc(%esp)
  801102:	00 
  801103:	c7 44 24 08 d3 27 80 	movl   $0x8027d3,0x8(%esp)
  80110a:	00 
  80110b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801112:	00 
  801113:	c7 04 24 e8 27 80 00 	movl   $0x8027e8,(%esp)
  80111a:	e8 f7 0a 00 00       	call   801c16 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80111f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801123:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80112a:	00 
  80112b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112e:	89 04 24             	mov    %eax,(%esp)
  801131:	e8 fe f1 ff ff       	call   800334 <memmove>
	return r;
}
  801136:	89 d8                	mov    %ebx,%eax
  801138:	83 c4 10             	add    $0x10,%esp
  80113b:	5b                   	pop    %ebx
  80113c:	5e                   	pop    %esi
  80113d:	5d                   	pop    %ebp
  80113e:	c3                   	ret    

0080113f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	53                   	push   %ebx
  801143:	83 ec 24             	sub    $0x24,%esp
  801146:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801149:	89 1c 24             	mov    %ebx,(%esp)
  80114c:	e8 0f f0 ff ff       	call   800160 <strlen>
  801151:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801156:	7f 60                	jg     8011b8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801158:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80115b:	89 04 24             	mov    %eax,(%esp)
  80115e:	e8 c4 f7 ff ff       	call   800927 <fd_alloc>
  801163:	89 c2                	mov    %eax,%edx
  801165:	85 d2                	test   %edx,%edx
  801167:	78 54                	js     8011bd <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801169:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80116d:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801174:	e8 1e f0 ff ff       	call   800197 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801181:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801184:	b8 01 00 00 00       	mov    $0x1,%eax
  801189:	e8 55 fd ff ff       	call   800ee3 <fsipc>
  80118e:	89 c3                	mov    %eax,%ebx
  801190:	85 c0                	test   %eax,%eax
  801192:	79 17                	jns    8011ab <open+0x6c>
		fd_close(fd, 0);
  801194:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80119b:	00 
  80119c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80119f:	89 04 24             	mov    %eax,(%esp)
  8011a2:	e8 7f f8 ff ff       	call   800a26 <fd_close>
		return r;
  8011a7:	89 d8                	mov    %ebx,%eax
  8011a9:	eb 12                	jmp    8011bd <open+0x7e>
	}

	return fd2num(fd);
  8011ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ae:	89 04 24             	mov    %eax,(%esp)
  8011b1:	e8 4a f7 ff ff       	call   800900 <fd2num>
  8011b6:	eb 05                	jmp    8011bd <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8011b8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8011bd:	83 c4 24             	add    $0x24,%esp
  8011c0:	5b                   	pop    %ebx
  8011c1:	5d                   	pop    %ebp
  8011c2:	c3                   	ret    

008011c3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8011c3:	55                   	push   %ebp
  8011c4:	89 e5                	mov    %esp,%ebp
  8011c6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8011c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8011d3:	e8 0b fd ff ff       	call   800ee3 <fsipc>
}
  8011d8:	c9                   	leave  
  8011d9:	c3                   	ret    
  8011da:	66 90                	xchg   %ax,%ax
  8011dc:	66 90                	xchg   %ax,%ax
  8011de:	66 90                	xchg   %ax,%ax

008011e0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8011e6:	c7 44 24 04 ff 27 80 	movl   $0x8027ff,0x4(%esp)
  8011ed:	00 
  8011ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f1:	89 04 24             	mov    %eax,(%esp)
  8011f4:	e8 9e ef ff ff       	call   800197 <strcpy>
	return 0;
}
  8011f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fe:	c9                   	leave  
  8011ff:	c3                   	ret    

00801200 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	53                   	push   %ebx
  801204:	83 ec 14             	sub    $0x14,%esp
  801207:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80120a:	89 1c 24             	mov    %ebx,(%esp)
  80120d:	e8 1d 12 00 00       	call   80242f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801212:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801217:	83 f8 01             	cmp    $0x1,%eax
  80121a:	75 0d                	jne    801229 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80121c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80121f:	89 04 24             	mov    %eax,(%esp)
  801222:	e8 29 03 00 00       	call   801550 <nsipc_close>
  801227:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801229:	89 d0                	mov    %edx,%eax
  80122b:	83 c4 14             	add    $0x14,%esp
  80122e:	5b                   	pop    %ebx
  80122f:	5d                   	pop    %ebp
  801230:	c3                   	ret    

00801231 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
  801234:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801237:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80123e:	00 
  80123f:	8b 45 10             	mov    0x10(%ebp),%eax
  801242:	89 44 24 08          	mov    %eax,0x8(%esp)
  801246:	8b 45 0c             	mov    0xc(%ebp),%eax
  801249:	89 44 24 04          	mov    %eax,0x4(%esp)
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8b 40 0c             	mov    0xc(%eax),%eax
  801253:	89 04 24             	mov    %eax,(%esp)
  801256:	e8 f0 03 00 00       	call   80164b <nsipc_send>
}
  80125b:	c9                   	leave  
  80125c:	c3                   	ret    

0080125d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80125d:	55                   	push   %ebp
  80125e:	89 e5                	mov    %esp,%ebp
  801260:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801263:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80126a:	00 
  80126b:	8b 45 10             	mov    0x10(%ebp),%eax
  80126e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801272:	8b 45 0c             	mov    0xc(%ebp),%eax
  801275:	89 44 24 04          	mov    %eax,0x4(%esp)
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8b 40 0c             	mov    0xc(%eax),%eax
  80127f:	89 04 24             	mov    %eax,(%esp)
  801282:	e8 44 03 00 00       	call   8015cb <nsipc_recv>
}
  801287:	c9                   	leave  
  801288:	c3                   	ret    

00801289 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
  80128c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80128f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801292:	89 54 24 04          	mov    %edx,0x4(%esp)
  801296:	89 04 24             	mov    %eax,(%esp)
  801299:	e8 d8 f6 ff ff       	call   800976 <fd_lookup>
  80129e:	85 c0                	test   %eax,%eax
  8012a0:	78 17                	js     8012b9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8012a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8012ab:	39 08                	cmp    %ecx,(%eax)
  8012ad:	75 05                	jne    8012b4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8012af:	8b 40 0c             	mov    0xc(%eax),%eax
  8012b2:	eb 05                	jmp    8012b9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8012b4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8012b9:	c9                   	leave  
  8012ba:	c3                   	ret    

008012bb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8012bb:	55                   	push   %ebp
  8012bc:	89 e5                	mov    %esp,%ebp
  8012be:	56                   	push   %esi
  8012bf:	53                   	push   %ebx
  8012c0:	83 ec 20             	sub    $0x20,%esp
  8012c3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8012c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c8:	89 04 24             	mov    %eax,(%esp)
  8012cb:	e8 57 f6 ff ff       	call   800927 <fd_alloc>
  8012d0:	89 c3                	mov    %eax,%ebx
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	78 21                	js     8012f7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8012d6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8012dd:	00 
  8012de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012ec:	e8 c2 f2 ff ff       	call   8005b3 <sys_page_alloc>
  8012f1:	89 c3                	mov    %eax,%ebx
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	79 0c                	jns    801303 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8012f7:	89 34 24             	mov    %esi,(%esp)
  8012fa:	e8 51 02 00 00       	call   801550 <nsipc_close>
		return r;
  8012ff:	89 d8                	mov    %ebx,%eax
  801301:	eb 20                	jmp    801323 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801303:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80130c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80130e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801311:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801318:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80131b:	89 14 24             	mov    %edx,(%esp)
  80131e:	e8 dd f5 ff ff       	call   800900 <fd2num>
}
  801323:	83 c4 20             	add    $0x20,%esp
  801326:	5b                   	pop    %ebx
  801327:	5e                   	pop    %esi
  801328:	5d                   	pop    %ebp
  801329:	c3                   	ret    

0080132a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	e8 51 ff ff ff       	call   801289 <fd2sockid>
		return r;
  801338:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80133a:	85 c0                	test   %eax,%eax
  80133c:	78 23                	js     801361 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80133e:	8b 55 10             	mov    0x10(%ebp),%edx
  801341:	89 54 24 08          	mov    %edx,0x8(%esp)
  801345:	8b 55 0c             	mov    0xc(%ebp),%edx
  801348:	89 54 24 04          	mov    %edx,0x4(%esp)
  80134c:	89 04 24             	mov    %eax,(%esp)
  80134f:	e8 45 01 00 00       	call   801499 <nsipc_accept>
		return r;
  801354:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801356:	85 c0                	test   %eax,%eax
  801358:	78 07                	js     801361 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80135a:	e8 5c ff ff ff       	call   8012bb <alloc_sockfd>
  80135f:	89 c1                	mov    %eax,%ecx
}
  801361:	89 c8                	mov    %ecx,%eax
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	e8 16 ff ff ff       	call   801289 <fd2sockid>
  801373:	89 c2                	mov    %eax,%edx
  801375:	85 d2                	test   %edx,%edx
  801377:	78 16                	js     80138f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801379:	8b 45 10             	mov    0x10(%ebp),%eax
  80137c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801380:	8b 45 0c             	mov    0xc(%ebp),%eax
  801383:	89 44 24 04          	mov    %eax,0x4(%esp)
  801387:	89 14 24             	mov    %edx,(%esp)
  80138a:	e8 60 01 00 00       	call   8014ef <nsipc_bind>
}
  80138f:	c9                   	leave  
  801390:	c3                   	ret    

00801391 <shutdown>:

int
shutdown(int s, int how)
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
  801394:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	e8 ea fe ff ff       	call   801289 <fd2sockid>
  80139f:	89 c2                	mov    %eax,%edx
  8013a1:	85 d2                	test   %edx,%edx
  8013a3:	78 0f                	js     8013b4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8013a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ac:	89 14 24             	mov    %edx,(%esp)
  8013af:	e8 7a 01 00 00       	call   80152e <nsipc_shutdown>
}
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
  8013b9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	e8 c5 fe ff ff       	call   801289 <fd2sockid>
  8013c4:	89 c2                	mov    %eax,%edx
  8013c6:	85 d2                	test   %edx,%edx
  8013c8:	78 16                	js     8013e0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8013ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d8:	89 14 24             	mov    %edx,(%esp)
  8013db:	e8 8a 01 00 00       	call   80156a <nsipc_connect>
}
  8013e0:	c9                   	leave  
  8013e1:	c3                   	ret    

008013e2 <listen>:

int
listen(int s, int backlog)
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
  8013e5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	e8 99 fe ff ff       	call   801289 <fd2sockid>
  8013f0:	89 c2                	mov    %eax,%edx
  8013f2:	85 d2                	test   %edx,%edx
  8013f4:	78 0f                	js     801405 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8013f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013fd:	89 14 24             	mov    %edx,(%esp)
  801400:	e8 a4 01 00 00       	call   8015a9 <nsipc_listen>
}
  801405:	c9                   	leave  
  801406:	c3                   	ret    

00801407 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
  80140a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80140d:	8b 45 10             	mov    0x10(%ebp),%eax
  801410:	89 44 24 08          	mov    %eax,0x8(%esp)
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	89 44 24 04          	mov    %eax,0x4(%esp)
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	89 04 24             	mov    %eax,(%esp)
  801421:	e8 98 02 00 00       	call   8016be <nsipc_socket>
  801426:	89 c2                	mov    %eax,%edx
  801428:	85 d2                	test   %edx,%edx
  80142a:	78 05                	js     801431 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80142c:	e8 8a fe ff ff       	call   8012bb <alloc_sockfd>
}
  801431:	c9                   	leave  
  801432:	c3                   	ret    

00801433 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	53                   	push   %ebx
  801437:	83 ec 14             	sub    $0x14,%esp
  80143a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80143c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801443:	75 11                	jne    801456 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801445:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80144c:	e8 a4 0f 00 00       	call   8023f5 <ipc_find_env>
  801451:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801456:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80145d:	00 
  80145e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801465:	00 
  801466:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80146a:	a1 04 40 80 00       	mov    0x804004,%eax
  80146f:	89 04 24             	mov    %eax,(%esp)
  801472:	e8 f1 0e 00 00       	call   802368 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801477:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80147e:	00 
  80147f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801486:	00 
  801487:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80148e:	e8 6d 0e 00 00       	call   802300 <ipc_recv>
}
  801493:	83 c4 14             	add    $0x14,%esp
  801496:	5b                   	pop    %ebx
  801497:	5d                   	pop    %ebp
  801498:	c3                   	ret    

00801499 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	56                   	push   %esi
  80149d:	53                   	push   %ebx
  80149e:	83 ec 10             	sub    $0x10,%esp
  8014a1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8014ac:	8b 06                	mov    (%esi),%eax
  8014ae:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8014b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8014b8:	e8 76 ff ff ff       	call   801433 <nsipc>
  8014bd:	89 c3                	mov    %eax,%ebx
  8014bf:	85 c0                	test   %eax,%eax
  8014c1:	78 23                	js     8014e6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8014c3:	a1 10 60 80 00       	mov    0x806010,%eax
  8014c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014cc:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8014d3:	00 
  8014d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d7:	89 04 24             	mov    %eax,(%esp)
  8014da:	e8 55 ee ff ff       	call   800334 <memmove>
		*addrlen = ret->ret_addrlen;
  8014df:	a1 10 60 80 00       	mov    0x806010,%eax
  8014e4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8014e6:	89 d8                	mov    %ebx,%eax
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	5b                   	pop    %ebx
  8014ec:	5e                   	pop    %esi
  8014ed:	5d                   	pop    %ebp
  8014ee:	c3                   	ret    

008014ef <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	53                   	push   %ebx
  8014f3:	83 ec 14             	sub    $0x14,%esp
  8014f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801501:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801505:	8b 45 0c             	mov    0xc(%ebp),%eax
  801508:	89 44 24 04          	mov    %eax,0x4(%esp)
  80150c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801513:	e8 1c ee ff ff       	call   800334 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801518:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80151e:	b8 02 00 00 00       	mov    $0x2,%eax
  801523:	e8 0b ff ff ff       	call   801433 <nsipc>
}
  801528:	83 c4 14             	add    $0x14,%esp
  80152b:	5b                   	pop    %ebx
  80152c:	5d                   	pop    %ebp
  80152d:	c3                   	ret    

0080152e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80153c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801544:	b8 03 00 00 00       	mov    $0x3,%eax
  801549:	e8 e5 fe ff ff       	call   801433 <nsipc>
}
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <nsipc_close>:

int
nsipc_close(int s)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
  801553:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80155e:	b8 04 00 00 00       	mov    $0x4,%eax
  801563:	e8 cb fe ff ff       	call   801433 <nsipc>
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	53                   	push   %ebx
  80156e:	83 ec 14             	sub    $0x14,%esp
  801571:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80157c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801580:	8b 45 0c             	mov    0xc(%ebp),%eax
  801583:	89 44 24 04          	mov    %eax,0x4(%esp)
  801587:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  80158e:	e8 a1 ed ff ff       	call   800334 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801593:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801599:	b8 05 00 00 00       	mov    $0x5,%eax
  80159e:	e8 90 fe ff ff       	call   801433 <nsipc>
}
  8015a3:	83 c4 14             	add    $0x14,%esp
  8015a6:	5b                   	pop    %ebx
  8015a7:	5d                   	pop    %ebp
  8015a8:	c3                   	ret    

008015a9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8015b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ba:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8015bf:	b8 06 00 00 00       	mov    $0x6,%eax
  8015c4:	e8 6a fe ff ff       	call   801433 <nsipc>
}
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
  8015ce:	56                   	push   %esi
  8015cf:	53                   	push   %ebx
  8015d0:	83 ec 10             	sub    $0x10,%esp
  8015d3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8015de:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8015e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8015ec:	b8 07 00 00 00       	mov    $0x7,%eax
  8015f1:	e8 3d fe ff ff       	call   801433 <nsipc>
  8015f6:	89 c3                	mov    %eax,%ebx
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	78 46                	js     801642 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8015fc:	39 f0                	cmp    %esi,%eax
  8015fe:	7f 07                	jg     801607 <nsipc_recv+0x3c>
  801600:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801605:	7e 24                	jle    80162b <nsipc_recv+0x60>
  801607:	c7 44 24 0c 0b 28 80 	movl   $0x80280b,0xc(%esp)
  80160e:	00 
  80160f:	c7 44 24 08 d3 27 80 	movl   $0x8027d3,0x8(%esp)
  801616:	00 
  801617:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80161e:	00 
  80161f:	c7 04 24 20 28 80 00 	movl   $0x802820,(%esp)
  801626:	e8 eb 05 00 00       	call   801c16 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80162b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80162f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801636:	00 
  801637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163a:	89 04 24             	mov    %eax,(%esp)
  80163d:	e8 f2 ec ff ff       	call   800334 <memmove>
	}

	return r;
}
  801642:	89 d8                	mov    %ebx,%eax
  801644:	83 c4 10             	add    $0x10,%esp
  801647:	5b                   	pop    %ebx
  801648:	5e                   	pop    %esi
  801649:	5d                   	pop    %ebp
  80164a:	c3                   	ret    

0080164b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	53                   	push   %ebx
  80164f:	83 ec 14             	sub    $0x14,%esp
  801652:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80165d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801663:	7e 24                	jle    801689 <nsipc_send+0x3e>
  801665:	c7 44 24 0c 2c 28 80 	movl   $0x80282c,0xc(%esp)
  80166c:	00 
  80166d:	c7 44 24 08 d3 27 80 	movl   $0x8027d3,0x8(%esp)
  801674:	00 
  801675:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80167c:	00 
  80167d:	c7 04 24 20 28 80 00 	movl   $0x802820,(%esp)
  801684:	e8 8d 05 00 00       	call   801c16 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801689:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80168d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801690:	89 44 24 04          	mov    %eax,0x4(%esp)
  801694:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80169b:	e8 94 ec ff ff       	call   800334 <memmove>
	nsipcbuf.send.req_size = size;
  8016a0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8016a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8016ae:	b8 08 00 00 00       	mov    $0x8,%eax
  8016b3:	e8 7b fd ff ff       	call   801433 <nsipc>
}
  8016b8:	83 c4 14             	add    $0x14,%esp
  8016bb:	5b                   	pop    %ebx
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8016cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cf:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8016d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8016dc:	b8 09 00 00 00       	mov    $0x9,%eax
  8016e1:	e8 4d fd ff ff       	call   801433 <nsipc>
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	56                   	push   %esi
  8016ec:	53                   	push   %ebx
  8016ed:	83 ec 10             	sub    $0x10,%esp
  8016f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	89 04 24             	mov    %eax,(%esp)
  8016f9:	e8 12 f2 ff ff       	call   800910 <fd2data>
  8016fe:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801700:	c7 44 24 04 38 28 80 	movl   $0x802838,0x4(%esp)
  801707:	00 
  801708:	89 1c 24             	mov    %ebx,(%esp)
  80170b:	e8 87 ea ff ff       	call   800197 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801710:	8b 46 04             	mov    0x4(%esi),%eax
  801713:	2b 06                	sub    (%esi),%eax
  801715:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80171b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801722:	00 00 00 
	stat->st_dev = &devpipe;
  801725:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80172c:	30 80 00 
	return 0;
}
  80172f:	b8 00 00 00 00       	mov    $0x0,%eax
  801734:	83 c4 10             	add    $0x10,%esp
  801737:	5b                   	pop    %ebx
  801738:	5e                   	pop    %esi
  801739:	5d                   	pop    %ebp
  80173a:	c3                   	ret    

0080173b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	53                   	push   %ebx
  80173f:	83 ec 14             	sub    $0x14,%esp
  801742:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801745:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801749:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801750:	e8 05 ef ff ff       	call   80065a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801755:	89 1c 24             	mov    %ebx,(%esp)
  801758:	e8 b3 f1 ff ff       	call   800910 <fd2data>
  80175d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801761:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801768:	e8 ed ee ff ff       	call   80065a <sys_page_unmap>
}
  80176d:	83 c4 14             	add    $0x14,%esp
  801770:	5b                   	pop    %ebx
  801771:	5d                   	pop    %ebp
  801772:	c3                   	ret    

00801773 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	57                   	push   %edi
  801777:	56                   	push   %esi
  801778:	53                   	push   %ebx
  801779:	83 ec 2c             	sub    $0x2c,%esp
  80177c:	89 c6                	mov    %eax,%esi
  80177e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801781:	a1 08 40 80 00       	mov    0x804008,%eax
  801786:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801789:	89 34 24             	mov    %esi,(%esp)
  80178c:	e8 9e 0c 00 00       	call   80242f <pageref>
  801791:	89 c7                	mov    %eax,%edi
  801793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801796:	89 04 24             	mov    %eax,(%esp)
  801799:	e8 91 0c 00 00       	call   80242f <pageref>
  80179e:	39 c7                	cmp    %eax,%edi
  8017a0:	0f 94 c2             	sete   %dl
  8017a3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8017a6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  8017ac:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8017af:	39 fb                	cmp    %edi,%ebx
  8017b1:	74 21                	je     8017d4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8017b3:	84 d2                	test   %dl,%dl
  8017b5:	74 ca                	je     801781 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8017b7:	8b 51 58             	mov    0x58(%ecx),%edx
  8017ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017be:	89 54 24 08          	mov    %edx,0x8(%esp)
  8017c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017c6:	c7 04 24 3f 28 80 00 	movl   $0x80283f,(%esp)
  8017cd:	e8 3d 05 00 00       	call   801d0f <cprintf>
  8017d2:	eb ad                	jmp    801781 <_pipeisclosed+0xe>
	}
}
  8017d4:	83 c4 2c             	add    $0x2c,%esp
  8017d7:	5b                   	pop    %ebx
  8017d8:	5e                   	pop    %esi
  8017d9:	5f                   	pop    %edi
  8017da:	5d                   	pop    %ebp
  8017db:	c3                   	ret    

008017dc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	57                   	push   %edi
  8017e0:	56                   	push   %esi
  8017e1:	53                   	push   %ebx
  8017e2:	83 ec 1c             	sub    $0x1c,%esp
  8017e5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8017e8:	89 34 24             	mov    %esi,(%esp)
  8017eb:	e8 20 f1 ff ff       	call   800910 <fd2data>
  8017f0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8017f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8017f7:	eb 45                	jmp    80183e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8017f9:	89 da                	mov    %ebx,%edx
  8017fb:	89 f0                	mov    %esi,%eax
  8017fd:	e8 71 ff ff ff       	call   801773 <_pipeisclosed>
  801802:	85 c0                	test   %eax,%eax
  801804:	75 41                	jne    801847 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801806:	e8 89 ed ff ff       	call   800594 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80180b:	8b 43 04             	mov    0x4(%ebx),%eax
  80180e:	8b 0b                	mov    (%ebx),%ecx
  801810:	8d 51 20             	lea    0x20(%ecx),%edx
  801813:	39 d0                	cmp    %edx,%eax
  801815:	73 e2                	jae    8017f9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801817:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80181a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80181e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801821:	99                   	cltd   
  801822:	c1 ea 1b             	shr    $0x1b,%edx
  801825:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801828:	83 e1 1f             	and    $0x1f,%ecx
  80182b:	29 d1                	sub    %edx,%ecx
  80182d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801831:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801835:	83 c0 01             	add    $0x1,%eax
  801838:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80183b:	83 c7 01             	add    $0x1,%edi
  80183e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801841:	75 c8                	jne    80180b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801843:	89 f8                	mov    %edi,%eax
  801845:	eb 05                	jmp    80184c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801847:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80184c:	83 c4 1c             	add    $0x1c,%esp
  80184f:	5b                   	pop    %ebx
  801850:	5e                   	pop    %esi
  801851:	5f                   	pop    %edi
  801852:	5d                   	pop    %ebp
  801853:	c3                   	ret    

00801854 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	57                   	push   %edi
  801858:	56                   	push   %esi
  801859:	53                   	push   %ebx
  80185a:	83 ec 1c             	sub    $0x1c,%esp
  80185d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801860:	89 3c 24             	mov    %edi,(%esp)
  801863:	e8 a8 f0 ff ff       	call   800910 <fd2data>
  801868:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80186a:	be 00 00 00 00       	mov    $0x0,%esi
  80186f:	eb 3d                	jmp    8018ae <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801871:	85 f6                	test   %esi,%esi
  801873:	74 04                	je     801879 <devpipe_read+0x25>
				return i;
  801875:	89 f0                	mov    %esi,%eax
  801877:	eb 43                	jmp    8018bc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801879:	89 da                	mov    %ebx,%edx
  80187b:	89 f8                	mov    %edi,%eax
  80187d:	e8 f1 fe ff ff       	call   801773 <_pipeisclosed>
  801882:	85 c0                	test   %eax,%eax
  801884:	75 31                	jne    8018b7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801886:	e8 09 ed ff ff       	call   800594 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80188b:	8b 03                	mov    (%ebx),%eax
  80188d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801890:	74 df                	je     801871 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801892:	99                   	cltd   
  801893:	c1 ea 1b             	shr    $0x1b,%edx
  801896:	01 d0                	add    %edx,%eax
  801898:	83 e0 1f             	and    $0x1f,%eax
  80189b:	29 d0                	sub    %edx,%eax
  80189d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8018a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018a5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8018a8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8018ab:	83 c6 01             	add    $0x1,%esi
  8018ae:	3b 75 10             	cmp    0x10(%ebp),%esi
  8018b1:	75 d8                	jne    80188b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8018b3:	89 f0                	mov    %esi,%eax
  8018b5:	eb 05                	jmp    8018bc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8018b7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8018bc:	83 c4 1c             	add    $0x1c,%esp
  8018bf:	5b                   	pop    %ebx
  8018c0:	5e                   	pop    %esi
  8018c1:	5f                   	pop    %edi
  8018c2:	5d                   	pop    %ebp
  8018c3:	c3                   	ret    

008018c4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	56                   	push   %esi
  8018c8:	53                   	push   %ebx
  8018c9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8018cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cf:	89 04 24             	mov    %eax,(%esp)
  8018d2:	e8 50 f0 ff ff       	call   800927 <fd_alloc>
  8018d7:	89 c2                	mov    %eax,%edx
  8018d9:	85 d2                	test   %edx,%edx
  8018db:	0f 88 4d 01 00 00    	js     801a2e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018e1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8018e8:	00 
  8018e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018f7:	e8 b7 ec ff ff       	call   8005b3 <sys_page_alloc>
  8018fc:	89 c2                	mov    %eax,%edx
  8018fe:	85 d2                	test   %edx,%edx
  801900:	0f 88 28 01 00 00    	js     801a2e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801906:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801909:	89 04 24             	mov    %eax,(%esp)
  80190c:	e8 16 f0 ff ff       	call   800927 <fd_alloc>
  801911:	89 c3                	mov    %eax,%ebx
  801913:	85 c0                	test   %eax,%eax
  801915:	0f 88 fe 00 00 00    	js     801a19 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80191b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801922:	00 
  801923:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801926:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801931:	e8 7d ec ff ff       	call   8005b3 <sys_page_alloc>
  801936:	89 c3                	mov    %eax,%ebx
  801938:	85 c0                	test   %eax,%eax
  80193a:	0f 88 d9 00 00 00    	js     801a19 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801943:	89 04 24             	mov    %eax,(%esp)
  801946:	e8 c5 ef ff ff       	call   800910 <fd2data>
  80194b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80194d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801954:	00 
  801955:	89 44 24 04          	mov    %eax,0x4(%esp)
  801959:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801960:	e8 4e ec ff ff       	call   8005b3 <sys_page_alloc>
  801965:	89 c3                	mov    %eax,%ebx
  801967:	85 c0                	test   %eax,%eax
  801969:	0f 88 97 00 00 00    	js     801a06 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80196f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801972:	89 04 24             	mov    %eax,(%esp)
  801975:	e8 96 ef ff ff       	call   800910 <fd2data>
  80197a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801981:	00 
  801982:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801986:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80198d:	00 
  80198e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801992:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801999:	e8 69 ec ff ff       	call   800607 <sys_page_map>
  80199e:	89 c3                	mov    %eax,%ebx
  8019a0:	85 c0                	test   %eax,%eax
  8019a2:	78 52                	js     8019f6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8019a4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8019aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ad:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8019af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8019b9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8019bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8019c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8019ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d1:	89 04 24             	mov    %eax,(%esp)
  8019d4:	e8 27 ef ff ff       	call   800900 <fd2num>
  8019d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019dc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8019de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e1:	89 04 24             	mov    %eax,(%esp)
  8019e4:	e8 17 ef ff ff       	call   800900 <fd2num>
  8019e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ec:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8019ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f4:	eb 38                	jmp    801a2e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8019f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a01:	e8 54 ec ff ff       	call   80065a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a09:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a14:	e8 41 ec ff ff       	call   80065a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a20:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a27:	e8 2e ec ff ff       	call   80065a <sys_page_unmap>
  801a2c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801a2e:	83 c4 30             	add    $0x30,%esp
  801a31:	5b                   	pop    %ebx
  801a32:	5e                   	pop    %esi
  801a33:	5d                   	pop    %ebp
  801a34:	c3                   	ret    

00801a35 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	89 04 24             	mov    %eax,(%esp)
  801a48:	e8 29 ef ff ff       	call   800976 <fd_lookup>
  801a4d:	89 c2                	mov    %eax,%edx
  801a4f:	85 d2                	test   %edx,%edx
  801a51:	78 15                	js     801a68 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a56:	89 04 24             	mov    %eax,(%esp)
  801a59:	e8 b2 ee ff ff       	call   800910 <fd2data>
	return _pipeisclosed(fd, p);
  801a5e:	89 c2                	mov    %eax,%edx
  801a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a63:	e8 0b fd ff ff       	call   801773 <_pipeisclosed>
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    
  801a6a:	66 90                	xchg   %ax,%ax
  801a6c:	66 90                	xchg   %ax,%ax
  801a6e:	66 90                	xchg   %ax,%ax

00801a70 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801a73:	b8 00 00 00 00       	mov    $0x0,%eax
  801a78:	5d                   	pop    %ebp
  801a79:	c3                   	ret    

00801a7a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801a80:	c7 44 24 04 57 28 80 	movl   $0x802857,0x4(%esp)
  801a87:	00 
  801a88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8b:	89 04 24             	mov    %eax,(%esp)
  801a8e:	e8 04 e7 ff ff       	call   800197 <strcpy>
	return 0;
}
  801a93:	b8 00 00 00 00       	mov    $0x0,%eax
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	57                   	push   %edi
  801a9e:	56                   	push   %esi
  801a9f:	53                   	push   %ebx
  801aa0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801aa6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801aab:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801ab1:	eb 31                	jmp    801ae4 <devcons_write+0x4a>
		m = n - tot;
  801ab3:	8b 75 10             	mov    0x10(%ebp),%esi
  801ab6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  801ab8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801abb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801ac0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801ac3:	89 74 24 08          	mov    %esi,0x8(%esp)
  801ac7:	03 45 0c             	add    0xc(%ebp),%eax
  801aca:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ace:	89 3c 24             	mov    %edi,(%esp)
  801ad1:	e8 5e e8 ff ff       	call   800334 <memmove>
		sys_cputs(buf, m);
  801ad6:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ada:	89 3c 24             	mov    %edi,(%esp)
  801add:	e8 04 ea ff ff       	call   8004e6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801ae2:	01 f3                	add    %esi,%ebx
  801ae4:	89 d8                	mov    %ebx,%eax
  801ae6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801ae9:	72 c8                	jb     801ab3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801aeb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801af1:	5b                   	pop    %ebx
  801af2:	5e                   	pop    %esi
  801af3:	5f                   	pop    %edi
  801af4:	5d                   	pop    %ebp
  801af5:	c3                   	ret    

00801af6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  801afc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801b01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b05:	75 07                	jne    801b0e <devcons_read+0x18>
  801b07:	eb 2a                	jmp    801b33 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801b09:	e8 86 ea ff ff       	call   800594 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801b0e:	66 90                	xchg   %ax,%ax
  801b10:	e8 ef e9 ff ff       	call   800504 <sys_cgetc>
  801b15:	85 c0                	test   %eax,%eax
  801b17:	74 f0                	je     801b09 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801b19:	85 c0                	test   %eax,%eax
  801b1b:	78 16                	js     801b33 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801b1d:	83 f8 04             	cmp    $0x4,%eax
  801b20:	74 0c                	je     801b2e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  801b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b25:	88 02                	mov    %al,(%edx)
	return 1;
  801b27:	b8 01 00 00 00       	mov    $0x1,%eax
  801b2c:	eb 05                	jmp    801b33 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801b2e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801b41:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801b48:	00 
  801b49:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b4c:	89 04 24             	mov    %eax,(%esp)
  801b4f:	e8 92 e9 ff ff       	call   8004e6 <sys_cputs>
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <getchar>:

int
getchar(void)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801b5c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801b63:	00 
  801b64:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b6b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b72:	e8 93 f0 ff ff       	call   800c0a <read>
	if (r < 0)
  801b77:	85 c0                	test   %eax,%eax
  801b79:	78 0f                	js     801b8a <getchar+0x34>
		return r;
	if (r < 1)
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	7e 06                	jle    801b85 <getchar+0x2f>
		return -E_EOF;
	return c;
  801b7f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801b83:	eb 05                	jmp    801b8a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801b85:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b92:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b95:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b99:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9c:	89 04 24             	mov    %eax,(%esp)
  801b9f:	e8 d2 ed ff ff       	call   800976 <fd_lookup>
  801ba4:	85 c0                	test   %eax,%eax
  801ba6:	78 11                	js     801bb9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bab:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801bb1:	39 10                	cmp    %edx,(%eax)
  801bb3:	0f 94 c0             	sete   %al
  801bb6:	0f b6 c0             	movzbl %al,%eax
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <opencons>:

int
opencons(void)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801bc1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bc4:	89 04 24             	mov    %eax,(%esp)
  801bc7:	e8 5b ed ff ff       	call   800927 <fd_alloc>
		return r;
  801bcc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801bce:	85 c0                	test   %eax,%eax
  801bd0:	78 40                	js     801c12 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801bd2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801bd9:	00 
  801bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801be8:	e8 c6 e9 ff ff       	call   8005b3 <sys_page_alloc>
		return r;
  801bed:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	78 1f                	js     801c12 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801bf3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c01:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c08:	89 04 24             	mov    %eax,(%esp)
  801c0b:	e8 f0 ec ff ff       	call   800900 <fd2num>
  801c10:	89 c2                	mov    %eax,%edx
}
  801c12:	89 d0                	mov    %edx,%eax
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	56                   	push   %esi
  801c1a:	53                   	push   %ebx
  801c1b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801c1e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801c21:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801c27:	e8 49 e9 ff ff       	call   800575 <sys_getenvid>
  801c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2f:	89 54 24 10          	mov    %edx,0x10(%esp)
  801c33:	8b 55 08             	mov    0x8(%ebp),%edx
  801c36:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c3a:	89 74 24 08          	mov    %esi,0x8(%esp)
  801c3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c42:	c7 04 24 64 28 80 00 	movl   $0x802864,(%esp)
  801c49:	e8 c1 00 00 00       	call   801d0f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801c4e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c52:	8b 45 10             	mov    0x10(%ebp),%eax
  801c55:	89 04 24             	mov    %eax,(%esp)
  801c58:	e8 51 00 00 00       	call   801cae <vcprintf>
	cprintf("\n");
  801c5d:	c7 04 24 50 28 80 00 	movl   $0x802850,(%esp)
  801c64:	e8 a6 00 00 00       	call   801d0f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801c69:	cc                   	int3   
  801c6a:	eb fd                	jmp    801c69 <_panic+0x53>

00801c6c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	53                   	push   %ebx
  801c70:	83 ec 14             	sub    $0x14,%esp
  801c73:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801c76:	8b 13                	mov    (%ebx),%edx
  801c78:	8d 42 01             	lea    0x1(%edx),%eax
  801c7b:	89 03                	mov    %eax,(%ebx)
  801c7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c80:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801c84:	3d ff 00 00 00       	cmp    $0xff,%eax
  801c89:	75 19                	jne    801ca4 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  801c8b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801c92:	00 
  801c93:	8d 43 08             	lea    0x8(%ebx),%eax
  801c96:	89 04 24             	mov    %eax,(%esp)
  801c99:	e8 48 e8 ff ff       	call   8004e6 <sys_cputs>
		b->idx = 0;
  801c9e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801ca4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801ca8:	83 c4 14             	add    $0x14,%esp
  801cab:	5b                   	pop    %ebx
  801cac:	5d                   	pop    %ebp
  801cad:	c3                   	ret    

00801cae <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801cb7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801cbe:	00 00 00 
	b.cnt = 0;
  801cc1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801cc8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cce:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd5:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cd9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801cdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce3:	c7 04 24 6c 1c 80 00 	movl   $0x801c6c,(%esp)
  801cea:	e8 af 01 00 00       	call   801e9e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801cef:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801cff:	89 04 24             	mov    %eax,(%esp)
  801d02:	e8 df e7 ff ff       	call   8004e6 <sys_cputs>

	return b.cnt;
}
  801d07:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d15:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801d18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1f:	89 04 24             	mov    %eax,(%esp)
  801d22:	e8 87 ff ff ff       	call   801cae <vcprintf>
	va_end(ap);

	return cnt;
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    
  801d29:	66 90                	xchg   %ax,%ax
  801d2b:	66 90                	xchg   %ax,%ax
  801d2d:	66 90                	xchg   %ax,%ax
  801d2f:	90                   	nop

00801d30 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	57                   	push   %edi
  801d34:	56                   	push   %esi
  801d35:	53                   	push   %ebx
  801d36:	83 ec 3c             	sub    $0x3c,%esp
  801d39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d3c:	89 d7                	mov    %edx,%edi
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d47:	89 c3                	mov    %eax,%ebx
  801d49:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801d4c:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801d52:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d57:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801d5a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801d5d:	39 d9                	cmp    %ebx,%ecx
  801d5f:	72 05                	jb     801d66 <printnum+0x36>
  801d61:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801d64:	77 69                	ja     801dcf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801d66:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801d69:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801d6d:	83 ee 01             	sub    $0x1,%esi
  801d70:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801d74:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d78:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d7c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801d80:	89 c3                	mov    %eax,%ebx
  801d82:	89 d6                	mov    %edx,%esi
  801d84:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d87:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801d8a:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d8e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801d92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d95:	89 04 24             	mov    %eax,(%esp)
  801d98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d9f:	e8 cc 06 00 00       	call   802470 <__udivdi3>
  801da4:	89 d9                	mov    %ebx,%ecx
  801da6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801daa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801dae:	89 04 24             	mov    %eax,(%esp)
  801db1:	89 54 24 04          	mov    %edx,0x4(%esp)
  801db5:	89 fa                	mov    %edi,%edx
  801db7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dba:	e8 71 ff ff ff       	call   801d30 <printnum>
  801dbf:	eb 1b                	jmp    801ddc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801dc1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801dc5:	8b 45 18             	mov    0x18(%ebp),%eax
  801dc8:	89 04 24             	mov    %eax,(%esp)
  801dcb:	ff d3                	call   *%ebx
  801dcd:	eb 03                	jmp    801dd2 <printnum+0xa2>
  801dcf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801dd2:	83 ee 01             	sub    $0x1,%esi
  801dd5:	85 f6                	test   %esi,%esi
  801dd7:	7f e8                	jg     801dc1 <printnum+0x91>
  801dd9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801ddc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801de0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801de4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801de7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801dea:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dee:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801df2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801df5:	89 04 24             	mov    %eax,(%esp)
  801df8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801dfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dff:	e8 9c 07 00 00       	call   8025a0 <__umoddi3>
  801e04:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e08:	0f be 80 87 28 80 00 	movsbl 0x802887(%eax),%eax
  801e0f:	89 04 24             	mov    %eax,(%esp)
  801e12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e15:	ff d0                	call   *%eax
}
  801e17:	83 c4 3c             	add    $0x3c,%esp
  801e1a:	5b                   	pop    %ebx
  801e1b:	5e                   	pop    %esi
  801e1c:	5f                   	pop    %edi
  801e1d:	5d                   	pop    %ebp
  801e1e:	c3                   	ret    

00801e1f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801e22:	83 fa 01             	cmp    $0x1,%edx
  801e25:	7e 0e                	jle    801e35 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801e27:	8b 10                	mov    (%eax),%edx
  801e29:	8d 4a 08             	lea    0x8(%edx),%ecx
  801e2c:	89 08                	mov    %ecx,(%eax)
  801e2e:	8b 02                	mov    (%edx),%eax
  801e30:	8b 52 04             	mov    0x4(%edx),%edx
  801e33:	eb 22                	jmp    801e57 <getuint+0x38>
	else if (lflag)
  801e35:	85 d2                	test   %edx,%edx
  801e37:	74 10                	je     801e49 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801e39:	8b 10                	mov    (%eax),%edx
  801e3b:	8d 4a 04             	lea    0x4(%edx),%ecx
  801e3e:	89 08                	mov    %ecx,(%eax)
  801e40:	8b 02                	mov    (%edx),%eax
  801e42:	ba 00 00 00 00       	mov    $0x0,%edx
  801e47:	eb 0e                	jmp    801e57 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801e49:	8b 10                	mov    (%eax),%edx
  801e4b:	8d 4a 04             	lea    0x4(%edx),%ecx
  801e4e:	89 08                	mov    %ecx,(%eax)
  801e50:	8b 02                	mov    (%edx),%eax
  801e52:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801e57:	5d                   	pop    %ebp
  801e58:	c3                   	ret    

00801e59 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
  801e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801e5f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801e63:	8b 10                	mov    (%eax),%edx
  801e65:	3b 50 04             	cmp    0x4(%eax),%edx
  801e68:	73 0a                	jae    801e74 <sprintputch+0x1b>
		*b->buf++ = ch;
  801e6a:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e6d:	89 08                	mov    %ecx,(%eax)
  801e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e72:	88 02                	mov    %al,(%edx)
}
  801e74:	5d                   	pop    %ebp
  801e75:	c3                   	ret    

00801e76 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801e7c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801e7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e83:	8b 45 10             	mov    0x10(%ebp),%eax
  801e86:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e91:	8b 45 08             	mov    0x8(%ebp),%eax
  801e94:	89 04 24             	mov    %eax,(%esp)
  801e97:	e8 02 00 00 00       	call   801e9e <vprintfmt>
	va_end(ap);
}
  801e9c:	c9                   	leave  
  801e9d:	c3                   	ret    

00801e9e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	57                   	push   %edi
  801ea2:	56                   	push   %esi
  801ea3:	53                   	push   %ebx
  801ea4:	83 ec 3c             	sub    $0x3c,%esp
  801ea7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801eaa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ead:	eb 14                	jmp    801ec3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	0f 84 b3 03 00 00    	je     80226a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  801eb7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ebb:	89 04 24             	mov    %eax,(%esp)
  801ebe:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ec1:	89 f3                	mov    %esi,%ebx
  801ec3:	8d 73 01             	lea    0x1(%ebx),%esi
  801ec6:	0f b6 03             	movzbl (%ebx),%eax
  801ec9:	83 f8 25             	cmp    $0x25,%eax
  801ecc:	75 e1                	jne    801eaf <vprintfmt+0x11>
  801ece:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  801ed2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801ed9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  801ee0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  801ee7:	ba 00 00 00 00       	mov    $0x0,%edx
  801eec:	eb 1d                	jmp    801f0b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801eee:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  801ef0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801ef4:	eb 15                	jmp    801f0b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ef6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801ef8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801efc:	eb 0d                	jmp    801f0b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801efe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f01:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801f04:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f0b:	8d 5e 01             	lea    0x1(%esi),%ebx
  801f0e:	0f b6 0e             	movzbl (%esi),%ecx
  801f11:	0f b6 c1             	movzbl %cl,%eax
  801f14:	83 e9 23             	sub    $0x23,%ecx
  801f17:	80 f9 55             	cmp    $0x55,%cl
  801f1a:	0f 87 2a 03 00 00    	ja     80224a <vprintfmt+0x3ac>
  801f20:	0f b6 c9             	movzbl %cl,%ecx
  801f23:	ff 24 8d c0 29 80 00 	jmp    *0x8029c0(,%ecx,4)
  801f2a:	89 de                	mov    %ebx,%esi
  801f2c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801f31:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801f34:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801f38:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801f3b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  801f3e:	83 fb 09             	cmp    $0x9,%ebx
  801f41:	77 36                	ja     801f79 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801f43:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801f46:	eb e9                	jmp    801f31 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801f48:	8b 45 14             	mov    0x14(%ebp),%eax
  801f4b:	8d 48 04             	lea    0x4(%eax),%ecx
  801f4e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801f51:	8b 00                	mov    (%eax),%eax
  801f53:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f56:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801f58:	eb 22                	jmp    801f7c <vprintfmt+0xde>
  801f5a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801f5d:	85 c9                	test   %ecx,%ecx
  801f5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f64:	0f 49 c1             	cmovns %ecx,%eax
  801f67:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f6a:	89 de                	mov    %ebx,%esi
  801f6c:	eb 9d                	jmp    801f0b <vprintfmt+0x6d>
  801f6e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801f70:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  801f77:	eb 92                	jmp    801f0b <vprintfmt+0x6d>
  801f79:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  801f7c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801f80:	79 89                	jns    801f0b <vprintfmt+0x6d>
  801f82:	e9 77 ff ff ff       	jmp    801efe <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801f87:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801f8a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801f8c:	e9 7a ff ff ff       	jmp    801f0b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801f91:	8b 45 14             	mov    0x14(%ebp),%eax
  801f94:	8d 50 04             	lea    0x4(%eax),%edx
  801f97:	89 55 14             	mov    %edx,0x14(%ebp)
  801f9a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801f9e:	8b 00                	mov    (%eax),%eax
  801fa0:	89 04 24             	mov    %eax,(%esp)
  801fa3:	ff 55 08             	call   *0x8(%ebp)
			break;
  801fa6:	e9 18 ff ff ff       	jmp    801ec3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801fab:	8b 45 14             	mov    0x14(%ebp),%eax
  801fae:	8d 50 04             	lea    0x4(%eax),%edx
  801fb1:	89 55 14             	mov    %edx,0x14(%ebp)
  801fb4:	8b 00                	mov    (%eax),%eax
  801fb6:	99                   	cltd   
  801fb7:	31 d0                	xor    %edx,%eax
  801fb9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801fbb:	83 f8 11             	cmp    $0x11,%eax
  801fbe:	7f 0b                	jg     801fcb <vprintfmt+0x12d>
  801fc0:	8b 14 85 20 2b 80 00 	mov    0x802b20(,%eax,4),%edx
  801fc7:	85 d2                	test   %edx,%edx
  801fc9:	75 20                	jne    801feb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  801fcb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fcf:	c7 44 24 08 9f 28 80 	movl   $0x80289f,0x8(%esp)
  801fd6:	00 
  801fd7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fde:	89 04 24             	mov    %eax,(%esp)
  801fe1:	e8 90 fe ff ff       	call   801e76 <printfmt>
  801fe6:	e9 d8 fe ff ff       	jmp    801ec3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  801feb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fef:	c7 44 24 08 e5 27 80 	movl   $0x8027e5,0x8(%esp)
  801ff6:	00 
  801ff7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	89 04 24             	mov    %eax,(%esp)
  802001:	e8 70 fe ff ff       	call   801e76 <printfmt>
  802006:	e9 b8 fe ff ff       	jmp    801ec3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80200b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80200e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802011:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  802014:	8b 45 14             	mov    0x14(%ebp),%eax
  802017:	8d 50 04             	lea    0x4(%eax),%edx
  80201a:	89 55 14             	mov    %edx,0x14(%ebp)
  80201d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80201f:	85 f6                	test   %esi,%esi
  802021:	b8 98 28 80 00       	mov    $0x802898,%eax
  802026:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  802029:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80202d:	0f 84 97 00 00 00    	je     8020ca <vprintfmt+0x22c>
  802033:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802037:	0f 8e 9b 00 00 00    	jle    8020d8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80203d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802041:	89 34 24             	mov    %esi,(%esp)
  802044:	e8 2f e1 ff ff       	call   800178 <strnlen>
  802049:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80204c:	29 c2                	sub    %eax,%edx
  80204e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  802051:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  802055:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802058:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80205b:	8b 75 08             	mov    0x8(%ebp),%esi
  80205e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802061:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802063:	eb 0f                	jmp    802074 <vprintfmt+0x1d6>
					putch(padc, putdat);
  802065:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802069:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80206c:	89 04 24             	mov    %eax,(%esp)
  80206f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802071:	83 eb 01             	sub    $0x1,%ebx
  802074:	85 db                	test   %ebx,%ebx
  802076:	7f ed                	jg     802065 <vprintfmt+0x1c7>
  802078:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80207b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80207e:	85 d2                	test   %edx,%edx
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
  802085:	0f 49 c2             	cmovns %edx,%eax
  802088:	29 c2                	sub    %eax,%edx
  80208a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80208d:	89 d7                	mov    %edx,%edi
  80208f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802092:	eb 50                	jmp    8020e4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802094:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802098:	74 1e                	je     8020b8 <vprintfmt+0x21a>
  80209a:	0f be d2             	movsbl %dl,%edx
  80209d:	83 ea 20             	sub    $0x20,%edx
  8020a0:	83 fa 5e             	cmp    $0x5e,%edx
  8020a3:	76 13                	jbe    8020b8 <vprintfmt+0x21a>
					putch('?', putdat);
  8020a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ac:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8020b3:	ff 55 08             	call   *0x8(%ebp)
  8020b6:	eb 0d                	jmp    8020c5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8020b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020bf:	89 04 24             	mov    %eax,(%esp)
  8020c2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8020c5:	83 ef 01             	sub    $0x1,%edi
  8020c8:	eb 1a                	jmp    8020e4 <vprintfmt+0x246>
  8020ca:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8020cd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8020d0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8020d3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8020d6:	eb 0c                	jmp    8020e4 <vprintfmt+0x246>
  8020d8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8020db:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8020de:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8020e1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8020e4:	83 c6 01             	add    $0x1,%esi
  8020e7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8020eb:	0f be c2             	movsbl %dl,%eax
  8020ee:	85 c0                	test   %eax,%eax
  8020f0:	74 27                	je     802119 <vprintfmt+0x27b>
  8020f2:	85 db                	test   %ebx,%ebx
  8020f4:	78 9e                	js     802094 <vprintfmt+0x1f6>
  8020f6:	83 eb 01             	sub    $0x1,%ebx
  8020f9:	79 99                	jns    802094 <vprintfmt+0x1f6>
  8020fb:	89 f8                	mov    %edi,%eax
  8020fd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802100:	8b 75 08             	mov    0x8(%ebp),%esi
  802103:	89 c3                	mov    %eax,%ebx
  802105:	eb 1a                	jmp    802121 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  802107:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80210b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  802112:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802114:	83 eb 01             	sub    $0x1,%ebx
  802117:	eb 08                	jmp    802121 <vprintfmt+0x283>
  802119:	89 fb                	mov    %edi,%ebx
  80211b:	8b 75 08             	mov    0x8(%ebp),%esi
  80211e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802121:	85 db                	test   %ebx,%ebx
  802123:	7f e2                	jg     802107 <vprintfmt+0x269>
  802125:	89 75 08             	mov    %esi,0x8(%ebp)
  802128:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80212b:	e9 93 fd ff ff       	jmp    801ec3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  802130:	83 fa 01             	cmp    $0x1,%edx
  802133:	7e 16                	jle    80214b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  802135:	8b 45 14             	mov    0x14(%ebp),%eax
  802138:	8d 50 08             	lea    0x8(%eax),%edx
  80213b:	89 55 14             	mov    %edx,0x14(%ebp)
  80213e:	8b 50 04             	mov    0x4(%eax),%edx
  802141:	8b 00                	mov    (%eax),%eax
  802143:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802146:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802149:	eb 32                	jmp    80217d <vprintfmt+0x2df>
	else if (lflag)
  80214b:	85 d2                	test   %edx,%edx
  80214d:	74 18                	je     802167 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80214f:	8b 45 14             	mov    0x14(%ebp),%eax
  802152:	8d 50 04             	lea    0x4(%eax),%edx
  802155:	89 55 14             	mov    %edx,0x14(%ebp)
  802158:	8b 30                	mov    (%eax),%esi
  80215a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80215d:	89 f0                	mov    %esi,%eax
  80215f:	c1 f8 1f             	sar    $0x1f,%eax
  802162:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802165:	eb 16                	jmp    80217d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  802167:	8b 45 14             	mov    0x14(%ebp),%eax
  80216a:	8d 50 04             	lea    0x4(%eax),%edx
  80216d:	89 55 14             	mov    %edx,0x14(%ebp)
  802170:	8b 30                	mov    (%eax),%esi
  802172:	89 75 e0             	mov    %esi,-0x20(%ebp)
  802175:	89 f0                	mov    %esi,%eax
  802177:	c1 f8 1f             	sar    $0x1f,%eax
  80217a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80217d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802180:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  802183:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  802188:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80218c:	0f 89 80 00 00 00    	jns    802212 <vprintfmt+0x374>
				putch('-', putdat);
  802192:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802196:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80219d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8021a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8021a6:	f7 d8                	neg    %eax
  8021a8:	83 d2 00             	adc    $0x0,%edx
  8021ab:	f7 da                	neg    %edx
			}
			base = 10;
  8021ad:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8021b2:	eb 5e                	jmp    802212 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8021b4:	8d 45 14             	lea    0x14(%ebp),%eax
  8021b7:	e8 63 fc ff ff       	call   801e1f <getuint>
			base = 10;
  8021bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8021c1:	eb 4f                	jmp    802212 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8021c3:	8d 45 14             	lea    0x14(%ebp),%eax
  8021c6:	e8 54 fc ff ff       	call   801e1f <getuint>
			base = 8;
  8021cb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8021d0:	eb 40                	jmp    802212 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  8021d2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8021d6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8021dd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8021e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8021e4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8021eb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8021ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8021f1:	8d 50 04             	lea    0x4(%eax),%edx
  8021f4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8021f7:	8b 00                	mov    (%eax),%eax
  8021f9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8021fe:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  802203:	eb 0d                	jmp    802212 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  802205:	8d 45 14             	lea    0x14(%ebp),%eax
  802208:	e8 12 fc ff ff       	call   801e1f <getuint>
			base = 16;
  80220d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  802212:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  802216:	89 74 24 10          	mov    %esi,0x10(%esp)
  80221a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80221d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802221:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802225:	89 04 24             	mov    %eax,(%esp)
  802228:	89 54 24 04          	mov    %edx,0x4(%esp)
  80222c:	89 fa                	mov    %edi,%edx
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	e8 fa fa ff ff       	call   801d30 <printnum>
			break;
  802236:	e9 88 fc ff ff       	jmp    801ec3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80223b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80223f:	89 04 24             	mov    %eax,(%esp)
  802242:	ff 55 08             	call   *0x8(%ebp)
			break;
  802245:	e9 79 fc ff ff       	jmp    801ec3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80224a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80224e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  802255:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  802258:	89 f3                	mov    %esi,%ebx
  80225a:	eb 03                	jmp    80225f <vprintfmt+0x3c1>
  80225c:	83 eb 01             	sub    $0x1,%ebx
  80225f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  802263:	75 f7                	jne    80225c <vprintfmt+0x3be>
  802265:	e9 59 fc ff ff       	jmp    801ec3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80226a:	83 c4 3c             	add    $0x3c,%esp
  80226d:	5b                   	pop    %ebx
  80226e:	5e                   	pop    %esi
  80226f:	5f                   	pop    %edi
  802270:	5d                   	pop    %ebp
  802271:	c3                   	ret    

00802272 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
  802275:	83 ec 28             	sub    $0x28,%esp
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80227e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802281:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  802285:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802288:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80228f:	85 c0                	test   %eax,%eax
  802291:	74 30                	je     8022c3 <vsnprintf+0x51>
  802293:	85 d2                	test   %edx,%edx
  802295:	7e 2c                	jle    8022c3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802297:	8b 45 14             	mov    0x14(%ebp),%eax
  80229a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80229e:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022a5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8022a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ac:	c7 04 24 59 1e 80 00 	movl   $0x801e59,(%esp)
  8022b3:	e8 e6 fb ff ff       	call   801e9e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8022b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022bb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c1:	eb 05                	jmp    8022c8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8022c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8022d0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8022d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	89 04 24             	mov    %eax,(%esp)
  8022eb:	e8 82 ff ff ff       	call   802272 <vsnprintf>
	va_end(ap);

	return rc;
}
  8022f0:	c9                   	leave  
  8022f1:	c3                   	ret    
  8022f2:	66 90                	xchg   %ax,%ax
  8022f4:	66 90                	xchg   %ax,%ax
  8022f6:	66 90                	xchg   %ax,%ax
  8022f8:	66 90                	xchg   %ax,%ax
  8022fa:	66 90                	xchg   %ax,%ax
  8022fc:	66 90                	xchg   %ax,%ax
  8022fe:	66 90                	xchg   %ax,%ax

00802300 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	56                   	push   %esi
  802304:	53                   	push   %ebx
  802305:	83 ec 10             	sub    $0x10,%esp
  802308:	8b 75 08             	mov    0x8(%ebp),%esi
  80230b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802311:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802313:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802318:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80231b:	89 04 24             	mov    %eax,(%esp)
  80231e:	e8 a6 e4 ff ff       	call   8007c9 <sys_ipc_recv>
  802323:	85 c0                	test   %eax,%eax
  802325:	74 16                	je     80233d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802327:	85 f6                	test   %esi,%esi
  802329:	74 06                	je     802331 <ipc_recv+0x31>
			*from_env_store = 0;
  80232b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802331:	85 db                	test   %ebx,%ebx
  802333:	74 2c                	je     802361 <ipc_recv+0x61>
			*perm_store = 0;
  802335:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80233b:	eb 24                	jmp    802361 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  80233d:	85 f6                	test   %esi,%esi
  80233f:	74 0a                	je     80234b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802341:	a1 08 40 80 00       	mov    0x804008,%eax
  802346:	8b 40 74             	mov    0x74(%eax),%eax
  802349:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80234b:	85 db                	test   %ebx,%ebx
  80234d:	74 0a                	je     802359 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80234f:	a1 08 40 80 00       	mov    0x804008,%eax
  802354:	8b 40 78             	mov    0x78(%eax),%eax
  802357:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802359:	a1 08 40 80 00       	mov    0x804008,%eax
  80235e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802361:	83 c4 10             	add    $0x10,%esp
  802364:	5b                   	pop    %ebx
  802365:	5e                   	pop    %esi
  802366:	5d                   	pop    %ebp
  802367:	c3                   	ret    

00802368 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	57                   	push   %edi
  80236c:	56                   	push   %esi
  80236d:	53                   	push   %ebx
  80236e:	83 ec 1c             	sub    $0x1c,%esp
  802371:	8b 75 0c             	mov    0xc(%ebp),%esi
  802374:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802377:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  80237a:	85 db                	test   %ebx,%ebx
  80237c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802381:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  802384:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802388:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80238c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	89 04 24             	mov    %eax,(%esp)
  802396:	e8 0b e4 ff ff       	call   8007a6 <sys_ipc_try_send>
	if (r == 0) return;
  80239b:	85 c0                	test   %eax,%eax
  80239d:	75 22                	jne    8023c1 <ipc_send+0x59>
  80239f:	eb 4c                	jmp    8023ed <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  8023a1:	84 d2                	test   %dl,%dl
  8023a3:	75 48                	jne    8023ed <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  8023a5:	e8 ea e1 ff ff       	call   800594 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  8023aa:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023ae:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	89 04 24             	mov    %eax,(%esp)
  8023bc:	e8 e5 e3 ff ff       	call   8007a6 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  8023c1:	85 c0                	test   %eax,%eax
  8023c3:	0f 94 c2             	sete   %dl
  8023c6:	74 d9                	je     8023a1 <ipc_send+0x39>
  8023c8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023cb:	74 d4                	je     8023a1 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  8023cd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023d1:	c7 44 24 08 88 2b 80 	movl   $0x802b88,0x8(%esp)
  8023d8:	00 
  8023d9:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  8023e0:	00 
  8023e1:	c7 04 24 96 2b 80 00 	movl   $0x802b96,(%esp)
  8023e8:	e8 29 f8 ff ff       	call   801c16 <_panic>
}
  8023ed:	83 c4 1c             	add    $0x1c,%esp
  8023f0:	5b                   	pop    %ebx
  8023f1:	5e                   	pop    %esi
  8023f2:	5f                   	pop    %edi
  8023f3:	5d                   	pop    %ebp
  8023f4:	c3                   	ret    

008023f5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
  8023f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023fb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802400:	89 c2                	mov    %eax,%edx
  802402:	c1 e2 07             	shl    $0x7,%edx
  802405:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80240b:	8b 52 50             	mov    0x50(%edx),%edx
  80240e:	39 ca                	cmp    %ecx,%edx
  802410:	75 0d                	jne    80241f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802412:	c1 e0 07             	shl    $0x7,%eax
  802415:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80241a:	8b 40 40             	mov    0x40(%eax),%eax
  80241d:	eb 0e                	jmp    80242d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80241f:	83 c0 01             	add    $0x1,%eax
  802422:	3d 00 04 00 00       	cmp    $0x400,%eax
  802427:	75 d7                	jne    802400 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802429:	66 b8 00 00          	mov    $0x0,%ax
}
  80242d:	5d                   	pop    %ebp
  80242e:	c3                   	ret    

0080242f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
  802432:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802435:	89 d0                	mov    %edx,%eax
  802437:	c1 e8 16             	shr    $0x16,%eax
  80243a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802441:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802446:	f6 c1 01             	test   $0x1,%cl
  802449:	74 1d                	je     802468 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80244b:	c1 ea 0c             	shr    $0xc,%edx
  80244e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802455:	f6 c2 01             	test   $0x1,%dl
  802458:	74 0e                	je     802468 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80245a:	c1 ea 0c             	shr    $0xc,%edx
  80245d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802464:	ef 
  802465:	0f b7 c0             	movzwl %ax,%eax
}
  802468:	5d                   	pop    %ebp
  802469:	c3                   	ret    
  80246a:	66 90                	xchg   %ax,%ax
  80246c:	66 90                	xchg   %ax,%ax
  80246e:	66 90                	xchg   %ax,%ax

00802470 <__udivdi3>:
  802470:	55                   	push   %ebp
  802471:	57                   	push   %edi
  802472:	56                   	push   %esi
  802473:	83 ec 0c             	sub    $0xc,%esp
  802476:	8b 44 24 28          	mov    0x28(%esp),%eax
  80247a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80247e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802482:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802486:	85 c0                	test   %eax,%eax
  802488:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80248c:	89 ea                	mov    %ebp,%edx
  80248e:	89 0c 24             	mov    %ecx,(%esp)
  802491:	75 2d                	jne    8024c0 <__udivdi3+0x50>
  802493:	39 e9                	cmp    %ebp,%ecx
  802495:	77 61                	ja     8024f8 <__udivdi3+0x88>
  802497:	85 c9                	test   %ecx,%ecx
  802499:	89 ce                	mov    %ecx,%esi
  80249b:	75 0b                	jne    8024a8 <__udivdi3+0x38>
  80249d:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a2:	31 d2                	xor    %edx,%edx
  8024a4:	f7 f1                	div    %ecx
  8024a6:	89 c6                	mov    %eax,%esi
  8024a8:	31 d2                	xor    %edx,%edx
  8024aa:	89 e8                	mov    %ebp,%eax
  8024ac:	f7 f6                	div    %esi
  8024ae:	89 c5                	mov    %eax,%ebp
  8024b0:	89 f8                	mov    %edi,%eax
  8024b2:	f7 f6                	div    %esi
  8024b4:	89 ea                	mov    %ebp,%edx
  8024b6:	83 c4 0c             	add    $0xc,%esp
  8024b9:	5e                   	pop    %esi
  8024ba:	5f                   	pop    %edi
  8024bb:	5d                   	pop    %ebp
  8024bc:	c3                   	ret    
  8024bd:	8d 76 00             	lea    0x0(%esi),%esi
  8024c0:	39 e8                	cmp    %ebp,%eax
  8024c2:	77 24                	ja     8024e8 <__udivdi3+0x78>
  8024c4:	0f bd e8             	bsr    %eax,%ebp
  8024c7:	83 f5 1f             	xor    $0x1f,%ebp
  8024ca:	75 3c                	jne    802508 <__udivdi3+0x98>
  8024cc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8024d0:	39 34 24             	cmp    %esi,(%esp)
  8024d3:	0f 86 9f 00 00 00    	jbe    802578 <__udivdi3+0x108>
  8024d9:	39 d0                	cmp    %edx,%eax
  8024db:	0f 82 97 00 00 00    	jb     802578 <__udivdi3+0x108>
  8024e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024e8:	31 d2                	xor    %edx,%edx
  8024ea:	31 c0                	xor    %eax,%eax
  8024ec:	83 c4 0c             	add    $0xc,%esp
  8024ef:	5e                   	pop    %esi
  8024f0:	5f                   	pop    %edi
  8024f1:	5d                   	pop    %ebp
  8024f2:	c3                   	ret    
  8024f3:	90                   	nop
  8024f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024f8:	89 f8                	mov    %edi,%eax
  8024fa:	f7 f1                	div    %ecx
  8024fc:	31 d2                	xor    %edx,%edx
  8024fe:	83 c4 0c             	add    $0xc,%esp
  802501:	5e                   	pop    %esi
  802502:	5f                   	pop    %edi
  802503:	5d                   	pop    %ebp
  802504:	c3                   	ret    
  802505:	8d 76 00             	lea    0x0(%esi),%esi
  802508:	89 e9                	mov    %ebp,%ecx
  80250a:	8b 3c 24             	mov    (%esp),%edi
  80250d:	d3 e0                	shl    %cl,%eax
  80250f:	89 c6                	mov    %eax,%esi
  802511:	b8 20 00 00 00       	mov    $0x20,%eax
  802516:	29 e8                	sub    %ebp,%eax
  802518:	89 c1                	mov    %eax,%ecx
  80251a:	d3 ef                	shr    %cl,%edi
  80251c:	89 e9                	mov    %ebp,%ecx
  80251e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802522:	8b 3c 24             	mov    (%esp),%edi
  802525:	09 74 24 08          	or     %esi,0x8(%esp)
  802529:	89 d6                	mov    %edx,%esi
  80252b:	d3 e7                	shl    %cl,%edi
  80252d:	89 c1                	mov    %eax,%ecx
  80252f:	89 3c 24             	mov    %edi,(%esp)
  802532:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802536:	d3 ee                	shr    %cl,%esi
  802538:	89 e9                	mov    %ebp,%ecx
  80253a:	d3 e2                	shl    %cl,%edx
  80253c:	89 c1                	mov    %eax,%ecx
  80253e:	d3 ef                	shr    %cl,%edi
  802540:	09 d7                	or     %edx,%edi
  802542:	89 f2                	mov    %esi,%edx
  802544:	89 f8                	mov    %edi,%eax
  802546:	f7 74 24 08          	divl   0x8(%esp)
  80254a:	89 d6                	mov    %edx,%esi
  80254c:	89 c7                	mov    %eax,%edi
  80254e:	f7 24 24             	mull   (%esp)
  802551:	39 d6                	cmp    %edx,%esi
  802553:	89 14 24             	mov    %edx,(%esp)
  802556:	72 30                	jb     802588 <__udivdi3+0x118>
  802558:	8b 54 24 04          	mov    0x4(%esp),%edx
  80255c:	89 e9                	mov    %ebp,%ecx
  80255e:	d3 e2                	shl    %cl,%edx
  802560:	39 c2                	cmp    %eax,%edx
  802562:	73 05                	jae    802569 <__udivdi3+0xf9>
  802564:	3b 34 24             	cmp    (%esp),%esi
  802567:	74 1f                	je     802588 <__udivdi3+0x118>
  802569:	89 f8                	mov    %edi,%eax
  80256b:	31 d2                	xor    %edx,%edx
  80256d:	e9 7a ff ff ff       	jmp    8024ec <__udivdi3+0x7c>
  802572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802578:	31 d2                	xor    %edx,%edx
  80257a:	b8 01 00 00 00       	mov    $0x1,%eax
  80257f:	e9 68 ff ff ff       	jmp    8024ec <__udivdi3+0x7c>
  802584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802588:	8d 47 ff             	lea    -0x1(%edi),%eax
  80258b:	31 d2                	xor    %edx,%edx
  80258d:	83 c4 0c             	add    $0xc,%esp
  802590:	5e                   	pop    %esi
  802591:	5f                   	pop    %edi
  802592:	5d                   	pop    %ebp
  802593:	c3                   	ret    
  802594:	66 90                	xchg   %ax,%ax
  802596:	66 90                	xchg   %ax,%ax
  802598:	66 90                	xchg   %ax,%ax
  80259a:	66 90                	xchg   %ax,%ax
  80259c:	66 90                	xchg   %ax,%ax
  80259e:	66 90                	xchg   %ax,%ax

008025a0 <__umoddi3>:
  8025a0:	55                   	push   %ebp
  8025a1:	57                   	push   %edi
  8025a2:	56                   	push   %esi
  8025a3:	83 ec 14             	sub    $0x14,%esp
  8025a6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8025aa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025ae:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8025b2:	89 c7                	mov    %eax,%edi
  8025b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8025bc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8025c0:	89 34 24             	mov    %esi,(%esp)
  8025c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	89 c2                	mov    %eax,%edx
  8025cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025cf:	75 17                	jne    8025e8 <__umoddi3+0x48>
  8025d1:	39 fe                	cmp    %edi,%esi
  8025d3:	76 4b                	jbe    802620 <__umoddi3+0x80>
  8025d5:	89 c8                	mov    %ecx,%eax
  8025d7:	89 fa                	mov    %edi,%edx
  8025d9:	f7 f6                	div    %esi
  8025db:	89 d0                	mov    %edx,%eax
  8025dd:	31 d2                	xor    %edx,%edx
  8025df:	83 c4 14             	add    $0x14,%esp
  8025e2:	5e                   	pop    %esi
  8025e3:	5f                   	pop    %edi
  8025e4:	5d                   	pop    %ebp
  8025e5:	c3                   	ret    
  8025e6:	66 90                	xchg   %ax,%ax
  8025e8:	39 f8                	cmp    %edi,%eax
  8025ea:	77 54                	ja     802640 <__umoddi3+0xa0>
  8025ec:	0f bd e8             	bsr    %eax,%ebp
  8025ef:	83 f5 1f             	xor    $0x1f,%ebp
  8025f2:	75 5c                	jne    802650 <__umoddi3+0xb0>
  8025f4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8025f8:	39 3c 24             	cmp    %edi,(%esp)
  8025fb:	0f 87 e7 00 00 00    	ja     8026e8 <__umoddi3+0x148>
  802601:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802605:	29 f1                	sub    %esi,%ecx
  802607:	19 c7                	sbb    %eax,%edi
  802609:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80260d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802611:	8b 44 24 08          	mov    0x8(%esp),%eax
  802615:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802619:	83 c4 14             	add    $0x14,%esp
  80261c:	5e                   	pop    %esi
  80261d:	5f                   	pop    %edi
  80261e:	5d                   	pop    %ebp
  80261f:	c3                   	ret    
  802620:	85 f6                	test   %esi,%esi
  802622:	89 f5                	mov    %esi,%ebp
  802624:	75 0b                	jne    802631 <__umoddi3+0x91>
  802626:	b8 01 00 00 00       	mov    $0x1,%eax
  80262b:	31 d2                	xor    %edx,%edx
  80262d:	f7 f6                	div    %esi
  80262f:	89 c5                	mov    %eax,%ebp
  802631:	8b 44 24 04          	mov    0x4(%esp),%eax
  802635:	31 d2                	xor    %edx,%edx
  802637:	f7 f5                	div    %ebp
  802639:	89 c8                	mov    %ecx,%eax
  80263b:	f7 f5                	div    %ebp
  80263d:	eb 9c                	jmp    8025db <__umoddi3+0x3b>
  80263f:	90                   	nop
  802640:	89 c8                	mov    %ecx,%eax
  802642:	89 fa                	mov    %edi,%edx
  802644:	83 c4 14             	add    $0x14,%esp
  802647:	5e                   	pop    %esi
  802648:	5f                   	pop    %edi
  802649:	5d                   	pop    %ebp
  80264a:	c3                   	ret    
  80264b:	90                   	nop
  80264c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802650:	8b 04 24             	mov    (%esp),%eax
  802653:	be 20 00 00 00       	mov    $0x20,%esi
  802658:	89 e9                	mov    %ebp,%ecx
  80265a:	29 ee                	sub    %ebp,%esi
  80265c:	d3 e2                	shl    %cl,%edx
  80265e:	89 f1                	mov    %esi,%ecx
  802660:	d3 e8                	shr    %cl,%eax
  802662:	89 e9                	mov    %ebp,%ecx
  802664:	89 44 24 04          	mov    %eax,0x4(%esp)
  802668:	8b 04 24             	mov    (%esp),%eax
  80266b:	09 54 24 04          	or     %edx,0x4(%esp)
  80266f:	89 fa                	mov    %edi,%edx
  802671:	d3 e0                	shl    %cl,%eax
  802673:	89 f1                	mov    %esi,%ecx
  802675:	89 44 24 08          	mov    %eax,0x8(%esp)
  802679:	8b 44 24 10          	mov    0x10(%esp),%eax
  80267d:	d3 ea                	shr    %cl,%edx
  80267f:	89 e9                	mov    %ebp,%ecx
  802681:	d3 e7                	shl    %cl,%edi
  802683:	89 f1                	mov    %esi,%ecx
  802685:	d3 e8                	shr    %cl,%eax
  802687:	89 e9                	mov    %ebp,%ecx
  802689:	09 f8                	or     %edi,%eax
  80268b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80268f:	f7 74 24 04          	divl   0x4(%esp)
  802693:	d3 e7                	shl    %cl,%edi
  802695:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802699:	89 d7                	mov    %edx,%edi
  80269b:	f7 64 24 08          	mull   0x8(%esp)
  80269f:	39 d7                	cmp    %edx,%edi
  8026a1:	89 c1                	mov    %eax,%ecx
  8026a3:	89 14 24             	mov    %edx,(%esp)
  8026a6:	72 2c                	jb     8026d4 <__umoddi3+0x134>
  8026a8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8026ac:	72 22                	jb     8026d0 <__umoddi3+0x130>
  8026ae:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8026b2:	29 c8                	sub    %ecx,%eax
  8026b4:	19 d7                	sbb    %edx,%edi
  8026b6:	89 e9                	mov    %ebp,%ecx
  8026b8:	89 fa                	mov    %edi,%edx
  8026ba:	d3 e8                	shr    %cl,%eax
  8026bc:	89 f1                	mov    %esi,%ecx
  8026be:	d3 e2                	shl    %cl,%edx
  8026c0:	89 e9                	mov    %ebp,%ecx
  8026c2:	d3 ef                	shr    %cl,%edi
  8026c4:	09 d0                	or     %edx,%eax
  8026c6:	89 fa                	mov    %edi,%edx
  8026c8:	83 c4 14             	add    $0x14,%esp
  8026cb:	5e                   	pop    %esi
  8026cc:	5f                   	pop    %edi
  8026cd:	5d                   	pop    %ebp
  8026ce:	c3                   	ret    
  8026cf:	90                   	nop
  8026d0:	39 d7                	cmp    %edx,%edi
  8026d2:	75 da                	jne    8026ae <__umoddi3+0x10e>
  8026d4:	8b 14 24             	mov    (%esp),%edx
  8026d7:	89 c1                	mov    %eax,%ecx
  8026d9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8026dd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8026e1:	eb cb                	jmp    8026ae <__umoddi3+0x10e>
  8026e3:	90                   	nop
  8026e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026e8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8026ec:	0f 82 0f ff ff ff    	jb     802601 <__umoddi3+0x61>
  8026f2:	e9 1a ff ff ff       	jmp    802611 <__umoddi3+0x71>
