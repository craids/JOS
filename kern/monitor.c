// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>

#include <kern/env.h>
#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/kdebug.h>
#include <kern/trap.h>
#include <kern/pmap.h>
#include <kern/spinlock.h>


#define CMDBUF_SIZE	80	// enough for one VGA text line


struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "backtrace", "Stack Trace", mon_backtrace },
        { "showmappings", "Display information about physical page mappings", mon_showmappings },
        { "setperms", "Set/clear/change Permissions", mon_setperms },
        { "dump", "Dump memory range", mon_dump },
	{ "step", "Break at the next instruction", single_step },
	{ "continue", "Continue execution at the regular rate", continue_exec }
};
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))

/***** Implementations of basic kernel monitor commands *****/
int
continue_exec(int argc, char **argv, struct Trapframe *tf)
{
  tf->tf_eflags &= ~FL_TF;
  return -1;
}

int
single_step(int argc, char **argv, struct Trapframe *tf)
{
  tf->tf_eflags |= FL_TF;
  return -1;
}

void hexdump (void *addr, int len)
{
    int i;
    unsigned char buff[17];
    unsigned char *pc = (unsigned char*)addr;

    if (len == 0) {
        cprintf("  ZERO LENGTH\n");
        return;
    }
    if (len < 0) {
        cprintf("  NEGATIVE LENGTH: %i\n",len);
        return;
    }

    // Process every byte in the data.
    for (i = 0; i < len; i++) {
        // Multiple of 16 means new line (with line offset).

        if ((i % 16) == 0) {
            // Just don't print ASCII for the zeroth line.
            if (i != 0)
                cprintf ("  %s\n", buff);

            // Output the offset.
            cprintf ("  0x%08x <+%08x>:", (addr+i), i);
        }

        // Now the hex code for the specific character.
        cprintf (" %02x", pc[i]);

        // And store a printable ASCII character for later.
        if ((pc[i] < 0x20) || (pc[i] > 0x7e))
            buff[i % 16] = '.';
        else
            buff[i % 16] = pc[i];
        buff[(i % 16) + 1] = '\0';
    }

    // Pad out last line if not exactly 16 characters.
    while ((i % 16) != 0) {
        cprintf ("   ");
        i++;
    }

    // And print the final ASCII bit.
    cprintf ("  %s\n", buff);
}

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	uintptr_t *ebp = (uintptr_t *)read_ebp();
    	uintptr_t eip = ebp[1];
    	struct Eipdebuginfo dbgInfo;
	cprintf("Stack backtrace:\n");
	while(ebp != NULL)
	{
		cprintf("  ebp %08x eip %08x args %08x %08x %08x %08x %08x\n", ebp, eip, ebp[2], ebp[3], ebp[4], ebp[5], ebp[6]);
		debuginfo_eip((uintptr_t) eip, &dbgInfo);
        	cprintf("\t  %s:%u: %s+%u\n", dbgInfo.eip_file, dbgInfo.eip_line, dbgInfo.eip_fn_name, eip - dbgInfo.eip_fn_addr);

        	ebp = (uintptr_t *)ebp[0];
        	eip = ebp[1];
	}
	return 0;
}

int
mon_showmappings(int argc, char **argv, struct Trapframe *tf)
{
	if(argc == 1)
	{
		cprintf("Usage: showmappings <start_addr> <end_addr>\n\n");
		return -1;
	}

	int i;
        extern pde_t *kern_pgdir;
        cprintf("Virtual Address\tPhysical Page Mappings\tPermissions\n");
        uintptr_t start = strtol(argv[1], NULL, 16);
	uintptr_t end = strtol(argv[2], NULL, 16);


        for (i = 0; i <= end - start; i+=0x1000) {

                uintptr_t va = start + i;
                pte_t * pteP = pgdir_walk(kern_pgdir,(void*) va, false);


                if(pteP == NULL)
                        cprintf("0x%08x\tNone\t\t\tNULL\n", va);

                else {
                        char perm[9];

                        if(*pteP & PTE_P)
                                perm[0] = 'P';
                        else{perm[0] = '_';};

                        if(*pteP & PTE_W)
                                 perm[1] = 'W';
                        else{perm[1] = '_';};

                        if(*pteP & PTE_U)
                                perm[2] = 'U';
                        else{perm[2] = '_';};

                        if(*pteP & PTE_PWT)
                                perm[3] = 'T';
                        else{perm[3] = '_';};

                        if(*pteP & PTE_PCD)
                                 perm[4] = 'C';
                        else{perm[4] = '_';};

                        if(*pteP & PTE_A)
                                perm[5] = 'A';
                        else{perm[5] = '_';};

                        if(*pteP & PTE_D)
                                 perm[6] = 'D';
                        else{perm[6] = '_';};

                        if(*pteP & PTE_PS)
                                perm[7] = 'S';
                        else{perm[7] = '_';};

                        if(*pteP & PTE_G)
                                 perm[8] = 'G';
			else{perm[8] = '_';};
			
			cprintf("0x%08x\t0x%08x\t\t\t%c%c%c%c%c%c%c%c%c\n", va, *pteP, perm[8], perm[7], perm[6], perm[5], perm[4], perm[3], perm[2], perm[1], perm[0]);
                }
        }

        return 0;
}
int
mon_dump(int argc, char **argv, struct Trapframe *tf)
{
	if(argc == 1)
	{
		cprintf("Usage: dump <start_virtaddr> <end_virtaddr>\n\n");
		return -1;
	}

	int i;
        extern pde_t *kern_pgdir;
        //cprintf("Virtual Address\tPhysical Page Mappings\tPermissions\n");
        uintptr_t start = strtol(argv[1], NULL, 16);
	uintptr_t end = strtol(argv[2], NULL, 16);
	int len = end - start;
	
	hexdump((void *)start, len);
        return 0;
}

int
mon_setperms(int argc, char **argv, struct Trapframe *tf)
{
	// set address new

        extern pde_t *kern_pgdir;
        uintptr_t va = strtol(argv[1], NULL, 16);
        int perm = *argv[2];

        pte_t * pteP = pgdir_walk(kern_pgdir,(void*) va, false);

        if (perm < 0x00000FFF){
                *pteP |= perm;
                cprintf("The page table entry pointer is now at 0x%08x\n", *pteP);
        }
        else{cprintf("Invalid permission bit\n");};

        return 0;
}
/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}

void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");

	if (tf != NULL)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
