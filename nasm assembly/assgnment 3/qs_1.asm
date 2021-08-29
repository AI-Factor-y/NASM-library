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
	string_len : resd 1
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

	mov ebx, string
	call read_array


	mov ebx,string


	call check_palindrome


	exit:
	mov eax, 1
	mov ebx, 0
	int 80h





;; section for procedures
;;--------------------------


check_palindrome:
	
	; base address should be in ebx
	; length in strlen 	

	section .data
		palin_msg : db 'string is a palindrome ',10
		palin_msg_len : equ $-palin_msg

		not_palin_msg : db 'string is not a palindrome ',10
		not_palin_msg_len : equ $-not_palin_msg

	section .bss
		mid_val : resd 1
		counter_palin_i: resq 1
		counter_palin_j: resq 1

		character_one: resb 1
		character_two: resb 1
		palin_flag: resd 1
		palin_string: resb 50
	section .text

	push rax
	push rbx
	push rcx


		mov dword[palin_string],ebx ; store the string in ebx to a seperate area

		mov ax, word[string_len]
		mov cx, 2
		mov dx,0
		div cx
		mov word[mid_val],ax  ; mid val=n/2

		mov dword[counter_palin_i],0
		mov eax,[string_len]  

		dec eax

		mov [counter_palin_j], eax  ; initialising pointers

		mov word[palin_flag], 1

		loop_palin:
			; call debugger

			mov ax,word[counter_palin_i]  ; if i>=n/2 then break
			mov cx,word[mid_val]
			cmp ax,cx
			jae exit_loop_palin


			mov eax,[counter_palin_i]

			mov cl, byte[ebx+eax]
			

			mov byte[character_one], cl  ; char_1 = str[i]

			mov eax, [counter_palin_j]
			mov cl , byte[ebx+eax]
			mov byte[character_two], cl  ; char_2= str[j]
		
			mov al, byte[character_one]	

			cmp al,cl                     ; if char_1!=char_2 then break
			je equal_characters

				mov word[palin_flag],0
				jmp exit_loop_palin

			equal_characters:

				inc word[counter_palin_i]
				dec word[counter_palin_j]

				jmp loop_palin


		
		exit_loop_palin:

		mov ax,word[palin_flag] 
		cmp ax,1
		jne is_not_palin
			mov eax, 4
			mov ebx, 1
			mov ecx, palin_msg
			mov edx, palin_msg_len
			int 80h

			jmp cont_palin_fun

		is_not_palin:
			mov eax, 4
			mov ebx, 1
			mov ecx, not_palin_msg
			mov edx, not_palin_msg_len
			int 80h

		cont_palin_fun:


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
						
				mov eax,[mid_val]
				mov [num],eax

				call print_num


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




read_array:
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
	mov ebx, string
	
	pop rcx
	pop rbx
	pop rax

	ret


print_array:
	push rax
	push rbx
	push rcx

	mov ebx, string
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
