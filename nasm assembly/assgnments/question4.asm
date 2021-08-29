section .data
	msg1 : db 'Enter first digit of first number :'
	l1 : equ $-msg1
	msg2 : db 'Enter second digit of first number :'
	l2 : equ $-msg2

	msg3 : db ' ',10
	l3 : equ $-msg3




section .bss
	num11 : resb 1
	num12 : resb 1

	

	n1 : resb 1
	n2 : resb 1
	n3 : resb 1
	
	junk : resb 1
	junk1 : resb 1
	junk2 : resb 1

	ans1 : resb 1
	ans2 : resb 1
	ans3 : resb 1
	ans4 : resw 1
	ans0 : resw 1
	sum : resw 1
	counter : resw 1

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

	
	mov word[counter],0
	mov word[sum],0

	for:
		mov bx, word[counter]
		mov ax, word[n1]

		cmp ax,bx
		jb exit_for

		; sum= sum+counter
		
		mov ax, word[sum]
		add ax, bx
		mov word[sum], ax

		add bx,2
		mov word[counter],bx





		jmp for

	exit_for:

		mov dx, 0
		mov ax,word[sum]
		mov bx, 1000
		div bx

		mov ax,dx

		mov bl, 100
		mov ah, 0
		div bl
		add al, 30h
		mov [ans4], ah
		mov [ans1], al
		mov ax, word[ans4]
		mov bl, 10
		mov ah, 0
		div bl
		add al, 30h
		add ah, 30h
		mov [ans2], al
		mov [ans3], ah


		
		mov eax, 4
		mov ebx, 1
		mov ecx, ans1
		mov edx, 1
		int 80h

		mov eax, 4
		mov ebx, 1
		mov ecx, ans2
		mov edx, 1
		int 80h

		mov eax, 4
		mov ebx, 1
		mov ecx, ans3
		mov edx, 1
		int 80h


		mov eax, 1
		mov ebx, 0
		int 80h


