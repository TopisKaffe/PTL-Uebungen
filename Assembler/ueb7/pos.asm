global _start

SECTION .stack

SECTION .data

ANZAHL equ 200
Eingabe_aufforderung db "Bitte einen String Eingeben:",0x0a,0x0
Zweite_aufforderung db "und jetzt den subsstring:",0x0a,0x0
STRI times ANZAHL db "."
SUB_STR times ANZAHL db "."
POSE dq 0x0

SECTION .text



str_stdout:
;parameter:
;push: Adresse des auszugebenen Textes
	push r15
	mov r15,[rsp+16]
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
		cmp byte[r15+r14],0
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
	pop r15
ret 8

int_stdout_dez:
;gibt eine Dezimalzahl auf StdOut aus
;parameter: push auszugebende Zahl (in)

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
ret 8 


pos:
;parameter: first push String (8byte zeiger)
;parameter: second push Substring (8byte zeiger)
;parameter: third push return value (1 byte wert)
	
	push rbx
	mov rbx,rsp
	push rdi
	push rcx 
	push rax
	push rdx
	push rsi
	push r14
	push r15
	push r8
	push r9
		xor r8,r8

		mov rsi,[rbx+24] ;subsstring
		xor r15,r15
		.laenge:
		cmp byte[rsi+r15],0x0
		je .fert
		inc r15
		jmp .laenge
		.fert:
	
	xor r14,r14

	.GEHKACKEN:
		mov rsi,[rbx+24] ;subsstring
		mov rdi,[rbx+32] ;String
		add rdi,r14
		xor r14,r14		
		.laengeermittel:
		inc r14
		cmp byte[rdi+r14],0x0
		je .ferti
		jmp .laengeermittel
		.ferti:
		


		
	cld
	mov rcx,r14 ;stringlaenge
	mov al,byte[rsi]
	repne scasb
	jz .ERFOLG
	;MISSERFOLG
	jmp .ENDE
	.ERFOLG:
	sub r14,rcx ;pos erstes zeichen
	add r8,r14
	mov rcx,r15 ;laenge substring
	sub rdi,1 
	repe cmpsb
	jz .SERFOLG
	jmp .GEHKACKEN
	.SERFOLG:
	mov r9,[rbx+16]
	mov [r9],r8

	
	.ENDE:

	push r9
	push r8
	pop r15
	pop r14
	pop rsi	
	pop rdx
	pop rax
	pop rcx
	pop rdi
	mov rsp,rbx
	pop rbx
ret 24

str_stdin:
;parameter:
;first push: max. Laenge des Textes
;second push: Adresse des von der Tastatur einzulesenden Textes
	push r15
	mov r15,[rsp+16]
	push r14
	mov  r14,[rsp+32]
	push rax
	push rdi
	push rsi
	push rdx
	push r11
	push rcx

		mov rax,0
		mov rdi,0
		mov rsi,r15
		mov rdx,r14
		syscall
		mov byte[r15+rax-1],0

	pop rcx
	pop r11
	pop rdx
	pop rsi
	pop rdi
	pop rax
	pop r14
	pop r15
ret 16
;hauptprogramm...
_start:

	push Eingabe_aufforderung
	call str_stdout

	push ANZAHL
	push STRI
	call str_stdin

	push Zweite_aufforderung
	call str_stdout

	push ANZAHL
	push SUB_STR
	call str_stdin


	push STRI
	push SUB_STR
	push POSE
	call pos

	push POSE
	call int_stdout_dez

mov rdi,0
mov rax,60
syscall