GLOBAL _start
SECTION .text
_start:

mov al,$41  ;inizialisierung ... zu testende zahl
sub al,$30	;zeichen in zahlen umwandeln hoffentlich

cmp	al,17	
jnc abisf	;wenn groesser als 10

cmp al,9
jbe rechnung	
ja mist		;is keine hexziffer

abisf:
	sub al,7
	cmp al,16
	jnc mist	;is keine hexziffer

rechnung:
	mov r8,10
	mul r8

;jetzt zurueck

mov r8b,al
shr r8b,4  ;erste hex stelle

mov r9b,al
shl r9b,4
shr r9b,4  ;zweite hex stelle

add r8b,48
cmp r8b,57
jb ersteabis	;umwandlung erste stelle
	add r8b,8
ersteabis:
	
add r9b,48
cmp r9b,57		;umwandlung zweite stelle
jb zweiteabis
	add r9b,8
zweiteabis:
	

mov rdi,0	;alles ok
jmp ende
mist:
mov rdi,1	;is keine hexzahl drinn		
ende:

mov rax,60
SYSCALL