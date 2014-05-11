JOS-Course notes
=========

- [Lab1 05/05/2014](#Lab1/05/05/2014)
- [Lab1 05/11/2014](#Lab1/05/11/2014)

<a name="lab1/05/05/2014" />
## Lab 1

Reviewed the Part 1: PC Bootstrap and Part 2: The Boot Loader. This, answer the following questions:

1. What is real mode and what is protected mode?
2. __How gdb connect to make-qemu?__
3. Where the BIOS start executing? (at 0xf000:0xfff0, 16 bytes to the top of the memory) 
4. Where the Bootloader loaded into memory? (0x7c00)
5. At what point does the processor start executing 32-bit code? `lgdt gdtdesc` instruction
6. What exactly causes the switch from 16- to 32-bit mode? `lgdt gdtdesc` or `orl $CR0_PE_ON %eax` instruction?
7. What is the last instruction of the boot loader executed, and what is the first instruction of the kernel it just loaded?
8. Where is the first instruction of the kernel?
9. How does the boot loader decide how many sectors it must read in order to fetch the entire kernel from disk? Where does it find this information? It read the header file, because the ELF header has the size, laod address, etc..
10. Load Address and Link Address
11. gdb command
  x/Nx ADDR dump content of N words start at va ADDR
  x/Ni ADDR disassembly N instruction start at ADDR, $eip ==> ADDR current instruction at eip

<a name="lab1/05/11/2014" />
## Lab 1 Part 3 kernel

TODO: 

1. Exercise 7, what special about the address 0x00100000? 
2. Exercise 8 in Lab1, why following code works
```
	num = getuint(&ap, lflag);
    base = 8;
    goto number;
    break;
```
3. Write the backtrack function
4. Write the advanced backtrack function (stabs)

Reference:
---

1. [The "stabs" debug format](http://www.cs.utah.edu/dept/old/texinfo/gdb/stabs.html)
