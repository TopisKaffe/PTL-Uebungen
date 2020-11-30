global formatarray 


formatarray:
	;rdi zeiger aufs uebergebenes array
	;rsi (byte) wert mit dem das array gefuellt werden soll
	;rdx wie viele stellen sollen gefuellt werden.
	push rax
	push r8
	push rcx
	
	mov r8,rdx
	and r8,7
	mov rax,rsi
	mov rcx,rdx
	cmp r8,0
	je nice
		cld 
		rep stosb
	jmp ende
	nice:

		shl rax,8
		or rax,rsi
		shl rax,8
		or rax,rsi
		shl rax,8
		or rax,rsi
		shl rax,8
		or rax,rsi
		shl rax,8
		or rax,rsi
		shl rax,8
		or rax,rsi
		shl rax,8
		or rax,rsi
		
		shr rcx,3
		cld 
		rep stosq
	ende:

	pop rcx
	pop r8
	pop rax
ret	