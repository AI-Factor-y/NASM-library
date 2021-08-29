section .data
	
	msg1 : db 'debug here --',10
	l1 : equ $-msg1

	msg2 : db 'enter the number : '
	l2 : equ $-msg2

	msg3 : db 'sum of digits is : '
	l3 : equ $-msg3

	msg4 : db 'msg 4 here'
	l4: equ $-msg4

	msg5 : db 'msg 5 here',10
	l5: equ $-msg5


	space:db ' '
	newline:db '',10


section .bss

	num: resd 1

	counter: resd 1
	
	n: resd 10
	array: resd 50
	sum: resd 0
	
section .text
	global _start
	_start:

	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, l2
	int 80h

	call read_num

	mov cx,word[num]
	mov word[n],cx
	mov word[sum],0
	loop1:

		cmp word[n],0
		je exit_loop1

		mov ax,word[n]
		mov bx,10
		mov dx,0
		div bx


		add word[sum],dx
		mov word[n],ax

		jmp loop1

	exit_loop1:

	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, l3
	int 80h

	mov ax,word[sum]
	mov word[num],ax
	call print_num


	exit:
	mov eax,1
	mov ebx,0
	int 80h




; section for procedures
;----------------------------



print_num:
	;usage
	;------
	; 1: create a variable num(word)
	; 2: move number to print to num (word)

	section .data
		nwl_for_printnum :db ' ',10
		nwl_l_printnum : equ $-nwl_for_printnum

	section .bss
		count_printnum :  resb 10
		temp_printnum : resb 1

	section .text
		push rax ; push all
		push rbx
		push rcx

		mov byte[count_printnum],0
		;call push_reg
		extract_no:
			cmp word[num], 0
			je print_no
			inc byte[count_printnum]
			mov dx, 0
			mov ax, word[num]
			mov bx, 10
			div bx
			push dx ; recursion here
			mov word[num], ax
			jmp extract_no
		print_no:
		cmp byte[count_printnum], 0
		je end_print
		dec byte[count_printnum]
		pop dx
		mov byte[temp_printnum], dl  ; dx is further divided into dh and dl
		add byte[temp_printnum], 30h
		mov eax, 4
		mov ebx, 1
		mov ecx, temp_printnum
		mov edx, 1
		int 80h
		jmp print_no
		end_print:

		mov eax,4
		mov ebx,1
		mov ecx,nwl_for_printnum
		mov edx,nwl_l_printnum
		int 80h
		;;The memory location ’newline’ should be declared with the ASCII key for new popa
		;call pop_reg
		pop rcx
		pop rbx
		pop rax ; pop all

	ret




read_num:

	;usage
	;------
	; 1: create a variable num(word)
	; 2: the input number is stored into num(word)

	section .bss

		temp_for_read: resb 1

	section .text

	
	push rax ; push all
	push rbx
	push rcx

	mov word[num], 0
	loop_read:
	;; read a digit
	mov eax, 3
	mov ebx, 0
	mov ecx, temp_for_read
	mov edx, 1
	int 80h
	;;check if the read digit is the end of number, i.e, the enter-key whose ASCII cmp byte[temp], 10

	cmp byte[temp_for_read], 10
	je end_read

	mov ax, word[num]
	mov bx, 10
	mul bx
	mov bl, byte[temp_for_read]
	sub bl, 30h
	mov bh, 0
	add ax, bx
	mov word[num], ax
	jmp loop_read
	end_read:
	;;pop all the used registers from the stack using popa
	;call pop_reg

	pop rcx
	pop rbx
	pop rax

	ret


