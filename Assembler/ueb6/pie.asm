GLOBAL _start
SECTION .stack
SECTION .data

Nachkommastellen equ 15
pieergebnis dq 0x0 	  	

SECTION .text 

Piberechnen:
;Berechnet pi bis zur 15 nachkommastelle
;Parameter: rax -> zahl(in)
	push rbp
	mov rbp,rsp

	;Lokale Variablen: [rbp-2],[rbp-10],[rbp-18],[rbp-26]
	sub rsp,26
	mov word[rbp-2],0
	mov qword[rbp-10],0
	mov qword[rbp-18],1
	mov qword[rbp-26],3

	push rbx
	push rcx
	push r8

	mov rcx,[rbp+24]
	mov rax,1
	mov rbx,10
	.FacktorenBerechenen: ;fuer Nachkommastellen
	mul rbx
	loop .FacktorenBerechenen

	mov qword[rbp-10],rax

	;Initialisierung der FPU
	finit

	;rundungsart (nachkommastellen abschneiden)
	fstcw [rbp-2] ;cw-Register kopieren
	mov ax,[rbp-2]
	or ax,0000110000000000b  ;bit 10 und 11 setzen 
	mov word[rbp-2],ax
	fclex  ;exeptions vermeiden (sicherheitshalber)
	fldcw word[rbp-2] ; ins cw-register zurueckkkopieren

	mov rcx,100000
	fild qword[rbp-18]
	.PiSchleife:
		fild qword[rbp-18]
		fild qword[rbp-26]
		fdiv
		fsub
		add qword[rbp-26],2
		fild qword[rbp-18]
		fild qword[rbp-26]
		fdiv
		fadd
		add qword[rbp-26],2
	loop .PiSchleife
	mov qword[rbp-18],4
	fild qword[rbp-18]	;multipliziere das ergebnis mit 4 ende der formel
	fmul
	fild qword[rbp-10]	;alle gewuenschten nachkommastellen vors komma schieben
	fmul 
	fistp qword[rbp-10] 
	mov rax,qword[rbp-10]
	mov r8,qword[rbp+16]
	mov [r8],rax	;ergebnis in Piergebnis speichern
	;register wiederherstellen
	pop r8
	pop rcx
	pop rbx

	mov rsp,rbp
	pop rbp
ret 16


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
	mov rax,qword[rdx]
	xor rdx,rdx
	.push:
		xor rdx,rdx	;loeschen fuer division
		div rbx		;durch basis dividieren
		push rdx	;rest der division auf stack merken
		inc rcx		;eine ziffer weiter 
		cmp rax,0	;testen ob ende erreicht
	jne .push

	.pop:
		mov r15,[rbp+24]
		cmp rcx,r15
		jne .komma 
			;1 Zeichen ausgeben
			push rcx	;rcx wird durch syscall veraendert
			mov rax,1
			mov rdi,1
			mov byte[rbp-1],',' 	;lokale Variable = dl
			lea rsi,[rbp-1]		;rsi = Adresse lokale Variable
			mov rdx,1
			syscall
			pop rcx
		.komma:			
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
ret 16

_start:

push Nachkommastellen
push pieergebnis
call Piberechnen

push Nachkommastellen
push pieergebnis
call int_stdout_dez
  
mov rdi,0
mov rax,60
syscall