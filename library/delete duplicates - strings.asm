

del_duplicates:
	
	;; usage
	;;------
	;; ebx register should have a string matrix.
	;; row_size, no_of_words required
	;; the no duplicate string will be printed in the console

	section .bss
		del_index: resd 1000
		del_i: resd 1
		del_j: resd 1
		del_pos_i: resd 1
		del_pos_j: resd 1
	section .text

		push rax 
		push rbx
		push rcx
		push rdx
				
			mov eax,0

			del_zero_loop:
				cmp eax,500
				je exit_zero_loop

				push rbx

					mov ebx, del_index
					mov word[ebx+2*eax],0

				pop rbx
				inc eax
			exit_zero_loop:


			mov dword[del_i],0	
			mov dword[del_j],0

			del_loop_1:
				mov eax, [del_i]
				cmp eax, dword[no_of_words]
				je exit_del_loop_1

				mov dword[del_j],eax

				inc dword[del_j]

				del_loop_2:
					mov eax,[del_j]
					cmp eax, dword[no_of_words]
					je exit_del_loop_2

					push rbx
						mov bx, word[row_size]
						mov dx,0
						mov ax, word[del_i]
						mul bx
						mov word[del_pos_i],ax

						mov dx,0
						mov ax, word[del_j]
						mul bx
						mov word[del_pos_j],ax

					pop rbx

					push rbx
					push rcx

						mov ecx, ebx
						add ebx, dword[del_pos_i]
						add ecx, dword[del_pos_j]

						call compare_strings

					pop rcx
					pop rbx

					mov ax,word[compare_flag]
					cmp ax,0
					jne continue_del_loop_2

					push rbx

						mov ebx, del_index
						mov eax, [del_j]

						mov word[ebx+2*eax],1

					pop rbx
					continue_del_loop_2:

					inc dword[del_j]

					jmp del_loop_2
				exit_del_loop_2:

				inc dword[del_i]

				jmp del_loop_1 
			exit_del_loop_1:



			mov dword[del_i],0

			del_loop_3:
				mov eax, [del_i]
				cmp eax, dword[no_of_words]
				je exit_del_loop_3

				push rbx

					mov ebx, del_index
					mov eax, [del_i]
					mov cx, word[ebx+2*eax]

				pop rbx

				cmp cx, 0
				jne continue_del_loop_3


				push rbx 

					mov bx, word[row_size]
					mov dx,0
					mov ax, word[del_i]
					mul bx
					mov word[del_pos_i],ax

				pop rbx

				push rbx 

					add ebx, dword[del_pos_i]
					call print_array_string
					call debugger_space_gen
				pop rbx

				continue_del_loop_3:

				inc dword[del_i]

				jmp del_loop_3


			exit_del_loop_3:


		pop rdx
		pop rcx
		pop rbx
		pop rax 

	ret



compare_strings:
	
	;; usage
	;-----------
	; 1 : string 1 should be in ebx string 2 should be in ecx 
	; 2 : if string 1> string 2 : compare_flag=1
	; 3 : if string 2> string 1 : compare_flag=2
	; 4 : if string 1==string 2 : compare_flag=0

	section .bss
			
		counter_i : resd 1


		compare_flag: resd 1
			

	section .text

	push rax
	push rbx
	push rcx
		
		 
		mov word[counter_i],0
		mov dword[compare_flag],0

		compare_str_loop:

			mov eax,[counter_i]
			mov al,byte[ebx+eax]   ;; extraxt string1[i]

			cmp al,0  
			je check_is_str_2_ended ;; if string1[i]==null then check if string 2 is ended too
									;; if not ended then string 2 is greater than string_1
			push rax
			mov eax, [counter_i]
			mov dl,byte[ecx+eax]	;; check string 2 is ended then string 1 is greater since string 1 is 
									;; not ended .. (if its ended control should not reach here)
			pop rax

			cmp dl,0				;; compare the two characters
			je str_1_greater


			cmp al,dl
			je continue_compare_str

				cmp al,dl
				ja str_1_greater
					
					mov dword[compare_flag],2  ; string 2 is greater

					jmp exit_compare_str_loop

				str_1_greater:

					mov dword[compare_flag],1  ; string 1 is greater		

					jmp exit_compare_str_loop
			continue_compare_str:

			inc dword[counter_i]

			jmp compare_str_loop
					
		check_is_str_2_ended:

			push rax
			mov eax, [counter_i]    ;; check whether string2 is ended 
			mov dl,byte[ecx+eax]	;; if ended then strings are equal else string 2 is greater
			pop rax

			cmp dl,0
			je exit_compare_str_loop

			mov dword[compare_flag],2

		exit_compare_str_loop:
		

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




debugger_space_gen:

	section .data

		msg_debugger_space_gen : db ' ',
		msg_debugger_l_space_gen : equ $-msg_debugger_space_gen

	section .text

		push rax
		push rbx
		push rcx
		push rdx
		; debug----
				mov eax, 4
				mov ebx, 1
				mov ecx, msg_debugger_space_gen
				mov edx, msg_debugger_l_space_gen
				int 80h
				;debug ---

		pop rdx
		pop rcx	
		pop rbx
		pop rax

		; action

	ret

