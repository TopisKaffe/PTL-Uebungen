GLOBAL _start
SECTION .stack
SECTION .data

Fehler db "IDIOT!: das ist keine Zahl",10,0
Text db "Eine Zahl bitte",10,0 
laenge equ 200 	  ;max laenge des strings 	
buffer times laenge db 'A '


SECTION .text 


str_stdin:
;parameter:
;r15: Adresse des von der Tastatur einzulesenden Textes
;r14: max. Laenge des Textes
	push rbp
	mov rbp,rsp
	mov r15,qword[rbp+16]
	push rax
	push rdi
	push rsi
	push rdx
	push r11
	push rcx

		mov rax,0
		mov rdi,0
		mov rsi,r15
		mov rdx,1
		syscall
		mov byte[r15+rax],10
		mov byte[r15+rax+1],0

	pop rcx
	pop r11
	pop rdx
	pop rsi
	pop rdi
	pop rax
	mov rsp,rbp
	pop rbp
ret 8

str_stdout:
;parameter:
;r15: Adresse des auszugebenen Textes
	push rbp
	mov rbp,rsp
	mov r15,qword[rsp+16]
	push rax
	push rdi
	push rsi
	push rdx
	push r11
	push rcx
	push r14

		xor r14,r14
		.laengeermitteln:
		inc r14
		cmp byte[r15+r14],0x0
		je .fertig
		jmp .laengeermitteln
		.fertig:

		mov rax,1
		mov rdi,1
		mov rsi,r15
		mov rdx,r14
		syscall

	pop r14
	pop rcx
	pop r11
	pop rdx
	pop rsi
	pop rdi
	pop rax
	mov rsp,rbp
	pop rbp
ret 8

str_to_int:
	;einstellige strings in Zahl wandeln wenns geht sonnst 0
	;zurueckgeben ueber r11b
	push rbp
	mov rbp,rsp
	push r8
	push r11
		mov r8,qword[rbp+16] 
		mov r11b,byte[r8]		
		sub r11b,'0'
		cmp r11b,9
		ja .keine
		mov byte[r8],r11b	
		jmp .raushier
		.keine:
		push Fehler
		call str_stdout
		.raushier:	
	pop r11	
	pop r8
	mov rsp,rbp
	pop rbp		
ret 8

multiplex:
	;parameter buffer
	;wird mit 10 multipliziert
	mov r15,[rsp+8]
	push rax
	push r8
		mov rax,[r15]
		mov r8,10
		mul r8
		mov byte[r15],al
	pop r8
	pop rax
ret 8

int_stdout_dez:
;gibt eine Dezimalzahl auf StdOut aus
;parameter: ;rax:auszugebende Zahl (in)

	push rbp
	mov rbp,rsp
	sub rsp,1 ;platz fuer 1 byte lokale Variable

	push rax
	push rbx
	push rcx
	push rdx
	push rsi
	push rdi
	push r11
	push r15

	mov rbx,10
	xor rdx,rdx
	mov rdx,qword[rbp+16]
	mov al,byte[rdx]
	xor rdx,rdx
	.push:
		xor rdx,rdx	;loeschen fuer division
		div rbx		;durch basis dividieren
		push rdx	;rest der division auf stack merken
		inc rcx		;eine ziffer weiter 
		cmp rax,0	;testen ob ende erreicht
	jne .push

	.pop:
		pop rdx		;ziffer vom stack hohlen 
		add dl,'0'	;ziffer zu zeichen

		;1 Zeichen ausgeben
		push rcx	;rcx wird durch syscall veraendert
		mov rax,1
		mov rdi,1
		mov byte[rbp-1],dl 	;lokale Variable = dl
		lea rsi,[rbp-1]		;rsi = Adresse lokale Variable
		mov rdx,1
		syscall
		pop rcx
	loop .pop

	pop r15
	pop r11
	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop rbx
	pop rax
	mov rsp,rbp
	pop rbp
ret



_start:
push Text
call str_stdout

push buffer
call str_stdin

push buffer
call str_to_int

push buffer
call multiplex

push buffer
call int_stdout_dez
  
mov rdi,0
mov rax,60
syscall