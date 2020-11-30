GLOBAL _start
SECTION .text
_start:
mov rcx,50 ;durchlaeufe

mov r8b,4

weiter:
	mov r9b,r8b
	mov r10b,r8b

	rcl r10b,1
	xor r9b,r10b
	
	rcl r10b,2
	xor r9b,r10b
	
	rcl r10b,2
	xor r9b,r10b
	
	rcl r9b,1
	rcl r8b,1
loop weiter

mov rax,60
mov rdi,0
SYSCALL