


section .data
	
	msg1 : db 'debug here --',10
	l1 : equ $-msg1

	msg2 : db 'Enter your string : '
	l2 : equ $-msg2

	msg3 : db 'The largest block length : ',
	l3 : equ $-msg3

	msg4 : db 'elem at [2,1] is : '
	l4: equ $-msg4

	msg5 : db 'msg 5 here',10
	l5: equ $-msg5


	space:db ' '
	newline:db '',10


section .bss

	num: resd 1

	counter: resd 1
	
	n: resd 10
	
	string: resb 500

	
	
section .text
	global _start
	_start:

	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, l2
	int 80h	



	mov ebx, string
	call read_array_string


	call largest_block

	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, l3
	int 80h	

	mov ax, word[max_block_len]
	mov word[num],ax

	call print_num

	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 80h

	exit:
	mov eax,1
	mov ebx,0
	int 80h






;; procedures
;-------------


largest_block:
	
	section .bss

		sub_seq_i: resd 1
		sub_seq_j: resd 1

		block_counter: resd 1
		max_block_len: resd 1
	section .text
		push rax
		push rbx
		push rcx
		push rdx

		;; initiate loop
		mov dword[sub_seq_i],0
		


		sub_seq_loop_i:
			mov ax, word[sub_seq_i]

			cmp ax, word[string_len]
			je exit_sub_seq_loop_i

			inc ax
			mov word[sub_seq_j],ax

			mov dword[block_counter],1

			sub_seq_loop_j:

				mov ax, word[sub_seq_j]
				cmp ax, word[string_len]
				je exit_sub_seq_loop_j

				mov eax, [sub_seq_i]
				mov cl,byte[ebx+eax]

				mov eax, [sub_seq_j]
				mov dl, byte[ebx+eax]

				cmp cl, dl
				jne exit_sub_seq_loop_j

				inc dword[block_counter]

				inc dword[sub_seq_j]

				jmp sub_seq_loop_j

			exit_sub_seq_loop_j:

			mov ax, word[block_counter]
			cmp ax, word[max_block_len]
			jb no_update_in_max_block

			mov word[max_block_len], ax

			no_update_in_max_block:

			inc dword[sub_seq_i]

			jmp sub_seq_loop_i

		exit_sub_seq_loop_i:

		pop rdx 
		pop rcx
		pop rbx
		pop rax

	ret




read_array_string:
	
	;; usage
	;--------
	; 1: string is read and stored in string variable
	; 2: string length is stored in string_len

	section .bss

		string_len : resd 1
		
		temp_read_str :  resb 1

	section .text

		push rax
		push rbx
		push rcx

		mov word[string_len],0

		reading:
		push rbx
		mov eax, 3
		mov ebx, 0
		mov ecx, temp_read_str
		mov edx, 1
		int 80h
		pop rbx
		cmp byte[temp_read_str], 10 ;; check if the input is ’Enter’
		je end_reading
		inc byte[string_len]
		mov al,byte[temp_read_str]
		mov byte[ebx], al
		inc ebx
		jmp reading
		end_reading:
		;; Similar to putting a null character at the end of a string
		mov byte[ebx], 0

		
		pop rcx
		pop rbx
		pop rax

	ret



print_array_string:
	
	;; usage
	;-----------
	; 1: base address of string to print is stored in ebx
	section .bss
		
		temp_print_str :  resb 1

	section .text
		push rax
		push rbx
		push rcx

		printing:
		mov al, byte[ebx]
		mov byte[temp_print_str], al
		cmp byte[temp_print_str], 0 ;; checks if the character is NULL character
		je end_printing
		push rbx
		mov eax, 4
		mov ebx, 1
		mov ecx, temp_print_str
		mov edx, 1
		int 80h
		pop rbx
		inc ebx
		jmp printing
		end_printing:
		
		pop rcx
		pop rbx
		pop rax
	ret



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