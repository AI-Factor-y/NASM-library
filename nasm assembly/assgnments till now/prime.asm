section .data
	msg1 : db 'Enter first digit of first number :'
	l1 : equ $-msg1
	msg2 : db 'Enter second digit of first number :'
	l2 : equ $-msg2
	msg3 : db 'its is not prime'
	l3 : equ $-msg3
	msg4 : db 'it is prime '
	l4 : equ $-msg4


section .bss
	num11 : resb 1
	num12 : resb 1
	num21 : resb 1
	num22 :resb 1
	num31 : resb 1
	num32 : resb 1

	n1 : resb 1
	n2 : resb 1
	n3 : resb 1
	ans1 : resb 1
	ans2 : resb 1
	ans3 : resb 1
	ans4 : resw 1
	junk : resb 1
	junk1 : resb 1
	junk2 : resb 1
	junk3 : resb 1
	junk4 : resb 1
	junk5 : resb 1

	check_var1 : resb 1
	check_var2 : resb 1
	counter : resb 1

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
	mov ecx, num11
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
	mov edx, l1
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, num12
	mov edx, 1
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, junk1
	mov edx, 1
	int 80h


	; calculating first number 
	mov al, byte[num11]
	sub al, 30h
	mov bl, 10
	mov ah, 0
	mul bl
	mov bx, word[num12]
	sub bx, 30h
	add ax, bx
	mov [n1], ax

	cmp byte[n1],1
	je onecase
		
	mov byte[counter],2

	for:

		mov ax,word[n1]
		mov bl,byte[counter]
		mov ah,0
		div bl

		cmp ah,0
		je exit_full


		add byte[counter],1

		mov bl,byte[n1]
		cmp byte[counter],bl
		je exit_yes	

		jmp for

	exit_full:
		mov eax, 4
		mov ebx, 1
		mov ecx, msg3
		mov edx, l3
		int 80h

		mov eax, 1
		mov ebx, 0
		int 80h

	exit_yes:
		mov eax, 4
		mov ebx, 1
		mov ecx, msg4
		mov edx, l4
		int 80h

		mov eax, 1
		mov ebx, 0
		int 80h


	onecase:

		mov eax, 4
		mov ebx, 1
		mov ecx, msg3
		mov edx, l3
		int 80h

		mov eax, 1
		mov ebx, 0
		int 80h