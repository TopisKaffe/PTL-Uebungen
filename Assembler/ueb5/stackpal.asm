GLOBAL _start
SECTION .stack
SECTION .data

Text db "Test palindrom eingeben",10,0 
KeinPalin db "Nö hast verkackt",10,0
EinPalin db	"Ok gut geraten",10,0
laenge equ 200 	  ;max laenge des strings 	
buffer times laenge db 'A' 

SECTION .text 

str_stdin:
;parameter:
;r15: Adresse des von der Tastatur einzulesenden Textes
;r14: max. Laenge des Textes
	
	mov r15,[rsp+8]
	mov  r14,[rsp+16]
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
		mov byte[r15+rax-1],10
		mov byte[r15+rax],0

	pop rcx
	pop r11
	pop rdx
	pop rsi
	pop rdi
	pop rax
ret 16


str_stdout:
;parameter:
;r15: Adresse des auszugebenen Textes
	mov r15,[rsp+8]
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
ret 8

dolowcase: ;addiert 'a'-'A' auf alles was kleiner als 'a'
	mov r15,[rsp+8]
	push rcx
	push r14
		xor r14,r14
		.laengeermitteln:
		inc r14
		cmp byte[r15+r14],0
		je .fertig	
		jmp .laengeermitteln
		.fertig:
		mov rcx,r14
		.lowcase:							;lowcase erzwingen
			cmp byte[r15 + rcx-1],'a'
			jae .kleinbuchstabe
			add byte[r15 + rcx-1],('a'-'A')
			.kleinbuchstabe:
		loop .lowcase
	pop r14
	pop rcx
ret	8	

nichtbuchstabewech:
	mov r15,[rsp+8]
	push rcx
	push rsi
	push r14
	push r10
	push r8

	xor r14,r14
		.laengeermitteln:
		inc r14
		cmp byte[r15+r14],0
		je .fertig
		jmp .laengeermitteln
	.fertig:
	mov rcx,r14
	.buchstabe:			
		mov rsi,r14				; buchstaben test
		cmp byte[r15 + rcx-1],96 
		ja .nichunter					; wenn groesser als 'z'
		sub r14,1
		mov r8,rcx
		.istkeiner:
			mov r10b,byte[r15 + rcx]
			mov byte[r15 + rcx-1],r10b
			cmp rcx,rsi
			ja .raus
			add rcx,2
		loop .istkeiner
		.raus:
		mov rcx,r8
		.nichunter:
		cmp byte[r15 + rcx-1],123
		jb .nichtueber
		sub r14,1
		mov r8,rcx
		.keiner:
			mov r10b,byte[r15 + rcx]
			mov byte[r15 + rcx-1],r10b
			cmp rcx,rsi
			ja .raushupf
			add rcx,2
		loop .keiner
		.raushupf:
		mov rcx,r8
		.nichtueber:
	loop .buchstabe

	pop r8
	pop r10
	pop r14
	pop rsi
	pop rcx
ret 8

palindromTest:
	mov r15,[rsp+8]
	push r10
	push rsi
	push rcx
	push rax
	push r14

	xor r14,r14
	.laengeermitteln:
	inc r14
	cmp byte[r15+r14],0
	je .fertig
	jmp .laengeermitteln
	.fertig:

	mov rcx,r14
	xor rsi,rsi
	.palitest:						; palindrom test 
		mov r10b,[r15 + rcx -1]
		cmp r10b,[r15 + rsi]
		jne .keinpalin
		add rsi,1
		cmp rcx,rsi
		jbe .ispalin 
	loop .palitest
	.keinpalin:
	mov rax,r14
	mov byte[r15+rax],10
	mov byte[r15+rax+1],0

;	mov r15,KeinPalin
	push KeinPalin
	call str_stdout
	jmp .ende
	.ispalin:
	mov rax,r14
	mov byte[r15+rax],10
	mov byte[r15+rax+1],0
	;mov r15,EinPalin
	push EinPalin
	call str_stdout
	.ende:

	pop r14
	pop rax
	pop rcx
	pop rsi
	pop r10
ret 8

_start:

;mov r15,Text
push Text
call str_stdout

;mov r14,laenge
;mov r15,buffer
push laenge
push buffer

call str_stdin

push buffer
call dolowcase

push buffer
call nichtbuchstabewech

push buffer
call palindromTest

mov rdi,0
mov rax,60
syscall