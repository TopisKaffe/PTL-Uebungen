global formatarray 


formatarray:
	;rdi zeiger aufs uebergebenes array
	;rsi (byte) wert mit dem das array gefuellt werden soll
	;rdx wie viele stellen sollen gefuellt werden.
	
	mov rcx,rdx
	mov rax,rsi
	
;	shl rax,8
;	or rax,rsi
;	shl rax,8
;	or rax,rsi
;	shl rax,8
;	or rax,rsi

	cld 
	rep stosb
ret	