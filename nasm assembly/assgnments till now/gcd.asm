section .data
	msg1 :db "enter first number : "
	l1: equ $-msg1

	msg2 :db "enter second number : "
	l2 :equ $-msg2

	msg3 : db "the gcd of the numbers : "
	l3 :equ $-msg3

section .bss
	num1 : resb 1
	num2 : resb 1
	ans : resb 1
	junk : resb 1

section .text

	global _start:
	_start:

	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, l1
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, num1
	mov edx, 1
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, junk
	mov edx, 1
	int 80h


	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, l2
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, num2
	mov edx, 1
	int 80h

	sub byte[num1],30h
	sub byte[num2],30h

	
	while_loop:

		
		mov ax,word[num1]
		mov bl,byte[num2]
		mov ah,0
		div bl

		mov byte[num1],ah
		add bl,30h
		mov byte[ans],bl

		cmp ah,0
		je exit_loop

		mov ax,word[num2]
		mov bl, byte[num1]
		mov ah,0
		div bl

		mov byte[num2],ah
		add bl,30h
		mov byte[ans],bl


		cmp ah,0
		je exit_loop
		
		jmp while_loop

	exit_loop:


		mov eax, 4
		mov ebx, 1
		mov ecx, ans
		mov edx, 1
		int 80h

	mov eax, 1
	mov ebx, 0
	int 80h