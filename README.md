JOS-Course notes
=========
[TOC]
- [Lab1 05/05/2014](#lab1/05/05/2014)
- [Lab1 05/11/2014](#lab1/05/11/2014)
- [Lab1 05/14/2014](#lab1/05/14/2014)

<a name="lab1/05/05/2014" />
## Lab 1 /05/05/2014 updated /07/18/2014

Reviewed the Part 1: PC Bootstrap and Part 2: The Boot Loader. This, answer the following questions:

1. What is real mode and what is protected mode?
	- Real mode: In 8086's 16-bit registers design, memory limited to 1 MB(2^20 bytes) valide address from 0x00000 to 0xFFFFF. they require 20-bit to address. Intel take two 16-bit values to determin a address. address 047c:0048 is given by 0x04808. It has two disadvantage: 1) single selector value can only refer to 64K memory, If a program is greater then 64K, during the execution, the selecter value has to be changed. 2) each byte in memeory do not have a unique segmented address.
	- protected mode(80386): Intruduce the paging and also have larget offset, segments can have size up to 4 gigabytes. Only part of the segment (page) may be in memory at any one time.
	- 16-bit Protected mode(80286): Segment value is a paragraph number of physical memory, where the first part of the address is stored as entries in a discriptor table. virtual memory is introduced in this design. sigments are not always in memory. 
2. How gdb connect to make-qemu?
3. Where the BIOS start executing? 
	- at 0xf000:0xfff0, 16 bytes to the top of the memory) 
4. Where the Bootloader loaded into memory? (
	- __0x7c00__, it is kinds of convention.
5. At what point does the processor start executing 32-bit code? 
	- `[0:7c2d] => 0x7c2d: ljmp $0x8,$0x7c32` long jump to next instruction(32-bit)
	- From this instruction, it start the 32-bit instruction execution.
	```
	The target architecture is assumed to be i386
	=> 0x7c32:      mov    $0x10,%ax```
6. What exactly causes the switch from 16- to 32-bit mode? 
	- Answer:`lgdt gdtdesc` or `orl $CR0_PE_ON %eax` instruction?
7. What is the last instruction of the boot loader executed, and what is the first instruction of the kernel it just loaded?
	- Answer: The __last__ instruction of boot is at address `0x7d63: call *0x10018`, it is a call to the entry point of the loaded kernel. The __first__ instruction of kernel is `0x10000c: movw $0x1234,0x472`
8. Where is the first instruction of the kernel?
	- Answer: see the `/kern/entry.S` and `/obj/kern/kernel.asm`
9. How does the boot loader decide how many sectors it must read in order to fetch the entire kernel from disk? Where does it find this information? 
	- Answer: It read the header file, because the ELF header has the size, laod address, etc..
10. Load Address and Link Address
	- Load Address: where the program should be load in physical address. (in ELF  `ph->p_pa`)
	- Link Address: where the program should be executed, it is a virtual address.
11. gdb command
  x/Nx ADDR dump content of N words start at va ADDR
  x/Ni ADDR disassembly N instruction start at ADDR, $eip ==> ADDR current instruction at eip

<a name="lab1/05/11/2014" />
## Lab 1 Part 3 kernel /05/11/2014 update 07/19/2014
1. __Exercise 5,__ Trace through the first few instructions of the boot loader again and identify the first instruction that would "break" or otherwise do the wrong thing if you were to get the boot loader's link address wrong.
	- It trapped in the instruction `ljmp`, because the boot loader is linked statically. The BIOS is use a jmp instruction to transfer control to boot loader, and it always jump to the CS:IP 0000:7c00. the link address (0000:7c00) will be used to access the global variable or combine with a relative address to get a address value to operate on by the `jmp` instruction.
	- 
2. __Exercise 6,__ Examine the 8 words of memory at 0x00100000 at the point the BIOS enters the boot loader, and then again at the point the boot loader enters the kernel. Why are they different? What is there at the second breakpoint?
	- This is hight address, BIOS executed from 0xffff0. 0x00100000 is 16 bytes higher. It is nothing there, before kernel loaded.
	```c
//when BIOS enter the boot loader.
Breakpoint 1, 0x00007c00 in ?? ()
(gdb) x/8x 0x00100000
0x100000:       0x00000000      0x00000000      0x00000000      0x00000000
0x100010:       0x00000000      0x00000000      0x00000000      0x00000000
(gdb)
//when boot loader enters the kernel.
The target architecture is assumed to be i386
=> 0x7d63:      call   *0x10018
Breakpoint 2, 0x00007d63 in ?? ()
(gdb) x/8x 0x00100000
0x100000:       0x1badb002      0x00000000      0xe4524ffe      0x7205c766
0x100010:       0x34000004      0x0000b812      0x220f0011      0xc0200fd8
(gdb) si
=> 0x10000c:    movw   $0x1234,0x472
0x0010000c in ?? ()
(gdb) x/8x 0x100000
0x100000:       0x1badb002      0x00000000      0xe4524ffe      0x7205c766
0x100010:       0x34000004      0x0000b812      0x220f0011      0xc0200fd8
```
2. __Exercise 7,__ whUse QEMU and GDB to trace into the JOS kernel and stop at the `movl %eax, %cr0`. Examine memory at `0x00100000` and at `0xf0100000`. Now, single step over that instruction using the stepi GDB command. Again, examine memory at `0x00100000` and at `0xf0100000`.
	- After the `movl %eax, %cr0` instruction, the virtual memory is started. Mapping the address `0x00100000` to `0xf0100000` by hard ware memory management.
    ```c
The target architecture is assumed to be i8086
[f000:fff0]    0xffff0: ljmp   $0xf000,$0xe05b
0x0000fff0 in ?? ()
 + symbol-file obj/kern/kernel
(gdb) b *0x7d63
Breakpoint 1 at 0x7d63
(gdb) c
Continuing.
The target architecture is assumed to be i386
=> 0x7d63:      call   *0x10018
Breakpoint 1, 0x00007d63 in ?? ()
(gdb) si
=> 0x10000c:    movw   $0x1234,0x472
0x0010000c in ?? ()
(gdb) si
=> 0x100015:    mov    $0x110000,%eax
0x00100015 in ?? ()
(gdb) si
=> 0x10001a:    mov    %eax,%cr3
0x0010001a in ?? ()
(gdb) si
=> 0x10001d:    mov    %cr0,%eax
0x0010001d in ?? ()
(gdb) si
=> 0x100020:    or     $0x80010001,%eax
0x00100020 in ?? ()
(gdb) si
=> 0x100025:    mov    %eax,%cr0
0x00100025 in ?? ()
(gdb) x/1x 0x00100000
0x100000:       0x1badb002
(gdb) x/1x 0xf0100000
0xf0100000:     0xffffffff   <<------
(gdb) si
=> 0x100028:    mov    $0xf010002f,%eax
0x00100028 in ?? ()
(gdb) x/1x 0x00100000
0x100000:       0x1badb002
(gdb) x/1x 0xf0100000
0xf0100000:     0x1badb002
```
3. __Exercise 8,__ in Lab1, why following code works
```
	num = getuint(&ap, lflag);
    base = 8;
    goto number;
    break;
```
4. __Exerceis 9,__ Determine where the kernel initializes its stack, and exactly where in memory its stack is located. How does the kernel reserve space for its stack? And at which "end" of this reserved area is the stack pointer initialized to point to?
	- 
5. __Exerceis 10,__ Find the address of the test_backtrace function in obj/kern/kernel.asm, set a breakpoint there, and examine what happens each time it gets called after the kernel starts.

<a name="lab1/05/14/2014" />
## Lab 1 Part 3 Kernel (2) /05/14/2014

hard to implement without understand the code structures, next time read through the whole code base of this lab. Try to understand the comments and making notes of the kernel. Then can goback to solve the previous sections.

Reference:
---

1. [The "stabs" debug format](http://www.cs.utah.edu/dept/old/texinfo/gdb/stabs.html)f
