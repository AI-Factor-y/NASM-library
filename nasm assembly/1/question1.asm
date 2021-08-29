
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
section .bss
	num11 : resb 1
	num12 : resb 1
	num21 : resb 1
	num22 :resb 1
	num31 : resb 1
	num32 : resb 1

	n1 : resb 1
	n2 : resb 1
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


	mov eax, 1
	mov ebx, 0
	int 80h