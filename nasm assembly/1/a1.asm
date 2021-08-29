section .data
	name : db 'Abhinav p',10
	l : equ $-name

	address : db 'Panayampurath house , rammallur',0ah
	l1 : equ $-address

	district : db 'Kozhikode',0ah
	l2 : equ $-district

section .text

	global _start:
	_start:
		mov eax, 4
		mov ebx, 1
		mov ecx, name
		mov edx, l
		int 80h

		mov eax, 4
		mov ebx, 1
		mov ecx, address
		mov edx, l1
		int 80h

		mov eax, 4
		mov ebx, 1
		mov ecx, district
		mov edx, l2
		int 80h

		mov eax, 1
		mov ebx, 0
		int 80h
