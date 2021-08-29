
section .data
	msg1 : db 'Enter first digit of first number :'
	l1 : equ $-msg1
	msg2 : db 'Enter second digit of first number :'
	l2 : equ $-msg2
	msg3 : db 'Enter first digit of second number :'
	l3 : equ $-msg3
	msg4 : db 'Enter second digit of second number :'
	l4 : equ $-msg4

	msg5 : db 'Enter first digit of third number :'
	l5 : equ $-msg4
	msg6 : db 'Enter second digit of third number :'
	l6 : equ $-msg4


	msg7 : db ' ', 10
	l7 : equ $-msg5

	msg8 : db ' second one is middle => number is : '
	l8 : equ $-msg8

	msg9 : db ' first one is middle => number is : '
	l9 : equ $-msg9

	msg10 : db ' third one is middle => number is : ' 
	l10 : equ $-msg10

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

	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, l1
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, num21
	mov edx, 1
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, junk2
	mov edx, 1
	int 80h


	mov eax, 4
	mov ebx, 1
	mov ecx, msg4
	mov edx, l1
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, num22
	mov edx, 1
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, junk3
	mov edx, 1
	int 80h

	; calculating second number 
	mov al, byte[num21]
	sub al, 30h
	mov bl, 10
	mov ah, 0
	mul bl
	mov bx, word[num22]
	sub bx, 30h
	add ax, bx
	mov [n2], ax

	mov eax, 4
	mov ebx, 1
	mov ecx, msg5
	mov edx, l1
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, num31
	mov edx, 1
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, junk4
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, msg6
	mov edx, l1
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, num32
	mov edx, 1
	int 80h

	mov eax, 3
	mov ebx, 0
	mov ecx, junk5
	mov edx, 1
	int 80h

	; calculating third number 
	mov al, byte[num31]
	sub al, 30h
	mov bl, 10
	mov ah, 0
	mul bl
	mov bx, word[num32]
	sub bx, 30h
	add ax, bx
	mov [n3], ax

	; checking if second number is middle and order is n1 , n2 , n3
	mov al, [n2]
	mov bl, [n1]

	cmp al,bl
	setnc al
	mov byte[check_var1],al

	mov al, [n3]
	mov bl, [n2]

	cmp al,bl
	setnc al
	mov byte[check_var2],al

	mov al,byte[check_var1]
	mov bl,byte[check_var2]

	and al,bl

	cmp al,1
	je if
		jmp else

	if:
		mov eax, 4
		mov ebx, 1
		mov ecx, msg8
		mov edx, l8
		int 80h


		jmp ans_n2


	else:
	; checking if second number is middle order n3, n2 ,n1
	mov al, [n2]
	mov bl, [n3]

	cmp al,bl
	setnc al
	mov byte[check_var1],al

	mov al, [n1]
	mov bl, [n2]

	cmp al,bl
	setnc al
	mov byte[check_var2],al

	mov al,byte[check_var1]
	mov bl,byte[check_var2]

	and al,bl

	cmp al,1
	je if2
		jmp else2

	if2:
		mov eax, 4
		mov ebx, 1
		mov ecx, msg8
		mov edx, l8
		int 80h

		jmp ans_n2

	else2:
	; checking if first number is middle order n2, n1,n3
	;checking first >= second
	mov al, [n1]
	mov bl, [n2]

	cmp al,bl
	setnc al
	mov byte[check_var1],al

	; checking first>= second
	mov al, [n3]
	mov bl, [n1]

	cmp al,bl
	setnc al
	mov byte[check_var2],al

	mov al,byte[check_var1]
	mov bl,byte[check_var2]

	and al,bl

	cmp al,1
	je if3
		jmp else3

	if3:
		mov eax, 4
		mov ebx, 1
		mov ecx, msg9
		mov edx, l9
		int 80h

		jmp ans_n1

	else3:
	; checking if first number is middle order n3 , n1 ,n2
	;checking first >= second
	mov al, [n1]
	mov bl, [n3]

	cmp al,bl
	setnc al
	mov byte[check_var1],al

	; checking first>= second
	mov al, [n2]
	mov bl, [n1]

	cmp al,bl
	setnc al
	mov byte[check_var2],al

	mov al,byte[check_var1]
	mov bl,byte[check_var2]

	and al,bl

	cmp al,1
	je if4
		jmp else4

	if4:
		mov eax, 4
		mov ebx, 1
		mov ecx, msg9
		mov edx, l9
		int 80h

		jmp ans_n1

	else4:

	; checking if third number is middle order n1 , n3, n2
	;checking first >= second
	mov al, [n3]
	mov bl, [n1]

	cmp al,bl
	setnc al
	mov byte[check_var1],al

	; checking first>= second
	mov al, [n2]
	mov bl, [n3]

	cmp al,bl
	setnc al
	mov byte[check_var2],al

	mov al,byte[check_var1]
	mov bl,byte[check_var2]

	and al,bl

	cmp al,1
	je if5
		jmp else5

	if5:
		mov eax, 4
		mov ebx, 1
		mov ecx, msg10
		mov edx, l10
		int 80h

		jmp ans_n3

	else5:
	; checking if third number is middle order n2, n3 ,n1
	;checking first >= second
	mov al, [n3]
	mov bl, [n2]

	cmp al,bl
	setnc al
	mov byte[check_var1],al

	; checking first>= second
	mov al, [n1]
	mov bl, [n3]

	cmp al,bl
	setnc al
	mov byte[check_var2],al

	mov al,byte[check_var1]
	mov bl,byte[check_var2]

	and al,bl

	cmp al,1
	je if6
		jmp exit

	if6:
		mov eax, 4
		mov ebx, 1
		mov ecx, msg10
		mov edx, l10
		int 80h

		jmp ans_n3

	

	ans_n2:
		
		mov ax, word[n2]

		mov bl, 10
		mov ah, 0
		div bl

		mov byte[ans1], al
		mov byte[ans2], ah
		add byte[ans1], 30h
		add byte[ans2], 30h

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

		mov eax, 1
		mov ebx, 0
		int 80h

	ans_n1:
		mov ax, word[n1]

		mov bl, 10
		mov ah, 0
		div bl

		mov byte[ans1], al
		mov byte[ans2], ah
		add byte[ans1], 30h
		add byte[ans2], 30h

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

		mov eax, 1
		mov ebx, 0
		int 80h

	ans_n3:
		mov ax, word[n3]

		mov bl, 10
		mov ah, 0
		div bl

		mov byte[ans1], al
		mov byte[ans2], ah
		add byte[ans1], 30h
		add byte[ans2], 30h

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

		mov eax, 1
		mov ebx, 0
		int 80h



	exit:
		mov eax, 1
		mov ebx, 0
		int 80h