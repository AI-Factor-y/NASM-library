section .data
	msg : db 'Enter an character :'
	l : equ $-msg
	ans1 : db 'caps key is on',10
	l1 : equ $-ans1
	ans2 :db 'caps key is off',10
	
	
section .bss
	d1 : resb 1

section .text

	global _start:
	_start:
