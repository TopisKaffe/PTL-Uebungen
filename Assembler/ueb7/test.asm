global _start

section .stack

section .data

ANZAHL equ 26
T db "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

section .text

_start:
	mov rdi,T
	mov rcx,ANZAHL
	cld
	mov al,'Y'
	repne scasb
	jz ERFOLG

	MISSERFORLG:
	jmp ENDE

	ERFOLG:
	sub rdi,T
	mov rdx,rdi

	mov rax,1
	mov rdi,1
	mov rsi,T
	syscall

	ENDE:

	mov rax,60
	mov rdi,0
	syscall