section .data
	
	msg1 : db 'the concatenated string is : '
	l1 : equ $-msg1

	msg2 : db 'enter a string 1 : '
	l2 : equ $-msg2

	msg3 : db 'enter a string 2 : '
	l3 : equ $-msg3



	space:db ' '
	newline:db '',10

	nwl :db ' ',10
	nwl_l : equ $-nwl
section .bss
	
	string :resb 50
	string_len : resd 1
	string_1: resb 50
	string_2: resb 50

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



	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, l3
	int 80h

	mov ebx, string_2
	call read_array_string
	
	call concatinate_strings

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


concatinate_strings:
	
	; the two strings should be in string_1 and string_2
	; the resut of concatenation is stored in result_concat_string
	; use rev_string to access the reversed string

	section .bss
			
		result_concat_string : resb 100

		counter_i : resd 1
		counter_res: resd 1

	section .text

	push rax
	push rbx
	push rcx
		mov ebx,string_1
		mov word[counter_i],0
		mov word[counter_res],0

		concat_str_1:

			mov eax,[counter_i]
			mov cl, byte[ebx+eax]

			cmp cl,0
			je exit_concat_str_1

			push rbx

				mov ebx, result_concat_string
				mov eax, [counter_res]
				mov byte[ebx+eax],cl

			pop rbx

			inc dword[counter_i]
			inc dword[counter_res]

			jmp concat_str_1

		exit_concat_str_1:


		mov word[counter_i],0
		mov ebx,string_2

		concat_str_2:

			mov eax,[counter_i]
			mov cl, byte[ebx+eax]

			cmp cl,0
			je exit_concat_str_2

			push rbx

				mov ebx, result_concat_string
				mov eax, [counter_res]
				mov byte[ebx+eax],cl

			pop rbx

			inc dword[counter_i]
			inc dword[counter_res]

			jmp concat_str_2

		exit_concat_str_2:

		mov ebx, result_concat_string
		mov eax, [counter_res]
		mov byte[ebx+eax],0


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
