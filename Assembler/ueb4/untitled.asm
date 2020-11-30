GLOBAL _start
SECTION .data

pali db 'Ein lagebrregal? nie',10 ;zu testender string 
laenge equ ($ - pali) 	  ;laenge des strings 	
tmplaenge db (laenge)

SECTION .text
_start:

sub byte[tmplaenge],1
xor rcx,rcx
mov cl,[tmplaenge]
 

lowcase:							;lowcase erzwingen
	cmp byte[pali + rcx-1],'a'
	jae kleinbuchstabe
	add byte[pali + rcx-1],('a'-'A')
	kleinbuchstabe:
loop lowcase

mov cl,[tmplaenge]

buchstabe:			
	mov sil,[tmplaenge]				; buchstaben test
	cmp byte[pali + rcx-1],96 
	ja nichunter					; wenn groesser als 'z'
	sub byte[tmplaenge],1
	mov r8b,cl
	istkeiner:
		mov r10b,byte[pali + rcx ]
		mov byte[pali + rcx-1],r10b
		cmp cl,sil
		ja raus
		add rcx,2
	loop istkeiner
	raus:
	mov cl,r8b
	nichunter:
	cmp byte[pali + rcx-1],123
	jb nichtueber
	sub byte[tmplaenge],1
	mov r8b,cl
	keiner:
		mov r10b,byte[pali + rcx]
		mov byte[pali + rcx-1],r10b
		cmp cl,sil
		ja raushupf
		add rcx,2
	loop keiner
	raushupf:
	mov cl,r8b
	nichtueber:
	
loop buchstabe

mov cl,[tmplaenge] 
xor rsi,rsi

palitest:						; palindrom test 
	mov r10b,[pali + rcx -1]
	cmp r10b,[pali + rsi]
	jne keinpalin
	add rsi,1
	cmp rcx,rsi
	jbe ispalin 
loop palitest
keinpalin:
mov rdi,0
cmp rdi,0
je ende
ispalin:
mov rdi,1
ende:

mov rax,60
syscall