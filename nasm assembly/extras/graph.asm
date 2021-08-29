
section .data
	
	msg1 : db 'debug here --',10
	l1 : equ $-msg1

	msg2 : db 'enter a string : '
	l2 : equ $-msg2



	space:db ' '
	newline:db '',10

	nwl :db ' ',10
	nwl_l : equ $-nwl
section .bss
	
	string :resb 50
	string_len : resw 1
	temp :  resb 1

section .text
	global _start
	_start:

	
	mov AX, 0013h
	int 13h

	mov AX, 0C07h
xor BX, BX
mov CX, 00C8h ; 200 in hex
mov DX, 0064h ; 100 in hex
int 13h

mov AX, 0C07h
xor BX, BX
mov CX, 0032h ; 50 in hex
mov DX, 0064h ; 100 in hex
lineloop:
int 13h
dec CX
JNS lineloop ; If CX isn't negative,
; draw another pixel.

	exit:
	mov eax, 1
	mov ebx, 0
	int 80h
