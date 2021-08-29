section .data
	msg1 : db 'Enter first number :'
	l1 : equ $-msg1
	msg2 : db 'Enter second number :'
	l2 : equ $-msg2

	msg3 : db 'first number is multiple of second number'
	l3 : equ $-msg3
	msg4 : db 'first number is not a multiple of second number'
	l4 : equ $-msg4

section .bss
	num1 : resb 1

	num2 : resb 1

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


	; check if second number divides first number 
	
	mov ax, word[num1]
	mov bl, byte[num2]
	sub ax ,30h
	sub bl ,30h
	mov ah, 0
	div bl

	cmp ah,0
	je if
	jmp else

	if:

		mov eax, 4
		mov ebx, 1
		mov ecx, msg3
		mov edx, l3
		int 80h

		jmp exit

	else:
		mov eax, 4
		mov ebx, 1
		mov ecx, msg4
		mov edx, l4
		int 80h	

	exit:
		mov eax, 1
		mov ebx, 0
		int 80h

	mov eax, 1
	mov ebx, 0
	int 80h