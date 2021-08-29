section .data
	


	msg2 : db 'enter a string : '
	l2 : equ $-msg2

	msg3 : db 'number of spaces is : '
	l3 : equ $-msg3



	space:db ' '
	newline:db '',10

	nwl :db ' ',10
	nwl_l : equ $-nwl
section .bss
	

	string_len : resd 1
	string_1: resb 50

	num: resd 1
	strlen: resd 1
	temp :  resb 1

section .text
	global _start
	_start:

	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, l2
	int 80h

	mov ebx, string_1
	call read_array_string


	mov ebx, string_1
	mov ecx, string_2
	call 

	mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, l1
	int 80h

	
	mov ebx,result_concat_string
	call print_array_string

	mov eax, 4
	mov ebx, 1
	mov ecx, nwl
	mov edx, nwl_l
	int 80h



	exit:
	mov eax, 1
	mov ebx, 0
	int 80h





;; section for procedures
;;--------------------------


count_spaces:
	
	; the two strings should be in ebx and ecx
	; the resut of concatenation is stored in result_concat_string

	section .bss
			
		count_val : resd 1

		counter_i : resd 1


	section .text

	push rax
	push rbx
	push rcx
		
		mov word[counter_i],0

		mov dword[count_val],0

		space_loop:

			mov eax,[counter_i]
			mov cl, byte[ebx+eax]

			cmp cl, 0
			je exit_space_loop

			cmp cl,' '
			jne not_space

				inc dword[count_val]

			not_space:

			jmp space_loop
		
		exit_space_loop:

		mov ax,word[count_val]
		mov word[num],ax
		call print_num

	pop rcx
	pop rbx
	pop rax


	ret


debugger:

	section .data

		msg_debugger : db 'debug here --',10
		msg_debugger_l : equ $-msg_debugger

	section .bss
		num: resd 1
		
	section .text

		push rax
		push rbx
		push rcx
		; debug----
				mov eax, 4
				mov ebx, 1
				mov ecx, msg_debugger
				mov edx, msg_debugger_l
				int 80h
				;debug ---
						
				

		pop rcx
		pop rbx
		pop rax

		; action

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




read_array_string:
	
	;; usage
	;--------
	; 1: string is read and stored in string variable
	; 2: string length is stored in string_len

	push rax
	push rbx
	push rcx

	mov word[string_len],0

	reading:
	push rbx
	mov eax, 3
	mov ebx, 0
	mov ecx, temp
	mov edx, 1
	int 80h
	pop rbx
	cmp byte[temp], 10 ;; check if the input is ’Enter’
	je end_reading
	inc byte[string_len]
	mov al,byte[temp]
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

	push rax
	push rbx
	push rcx

	printing:
	mov al, byte[ebx]
	mov byte[temp], al
	cmp byte[temp], 0 ;; checks if the character is NULL character
	je end_printing
	push rbx
	mov eax, 4
	mov ebx, 1
	mov ecx, temp
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
