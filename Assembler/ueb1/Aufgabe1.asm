; Assemblieren


GLOBAL _start
SECTION .text


_start:
xor rbx,rbx


mov rcx,5  ;5 widerhohlungen

weiter:

add rbx,rcx

loop weiter 

mov rax,60
mov rdi,0

SYSCALL