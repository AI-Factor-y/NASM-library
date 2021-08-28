check_palindrome:
	
	; base address should be in ebx
	; length in strlen 	
	; if it is palin then is_palin is 1 else 0
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

		is_palin: resd 1
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
			; mov eax, 4
			; mov ebx, 1
			; mov ecx, palin_msg
			; mov edx, palin_msg_len
			; int 80h

			mov dword[is_palin],1

			jmp cont_palin_fun

		is_not_palin:
			; mov eax, 4
			; mov ebx, 1
			; mov ecx, not_palin_msg
			; mov edx, not_palin_msg_len
			; int 80h
			mov dword[is_palin],0

		cont_palin_fun:


	pop rcx
	pop rbx
	pop rax


	ret


