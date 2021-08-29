

swap_palin_pos:
	
	;; input string in string_rev_palin
	;; output string in string_rev_palin, ebx 

	section .bss

		sp_i: resd 1

		palin_arr: resb 1000
		palin_arr_i: resd 1
		string_len: resd 1

	section .text


		push rax 
		push rcx 
		push rdx 	

		mov ebx, string_rev_palin

		mov dword[sp_i],0
		mov dword[palin_arr_i],0

		sp_loop_1:

			mov ax, word[sp_i]
			cmp ax, word[no_of_words]
			je exit_sp_loop_1

			mov eax, [sp_i]
			call string_at_location

			push rbx

				mov ebx, str_at_loc
				call strlen 
				mov dword[string_len],ecx
				
				call check_palindrome

				cmp word[is_palin],1
				jne sp_not_palin

				mov ecx, palin_arr
				mov ebx, str_at_loc
				mov eax, [palin_arr_i]	
				call put_string_in_loc

				inc dword[palin_arr_i]

				sp_not_palin:

			pop rbx

			inc dword[sp_i]
			jmp sp_loop_1

		exit_sp_loop_1:

		mov dword[sp_i],0

		dec dword[palin_arr_i]



		sp_loop_2:

			mov ax, word[sp_i]
			cmp ax, word[no_of_words]
			je exit_sp_loop_2

			mov eax, [sp_i]
			call string_at_location
			
			push rbx

				mov ebx, str_at_loc
				call strlen 
				mov dword[string_len],ecx
				
				call check_palindrome


				cmp word[is_palin],1
				jne sp_not_palin2

			
				mov ebx, palin_arr

				mov eax, [palin_arr_i]
				call string_at_location

				mov ebx, str_at_loc
				mov eax, [sp_i]
				mov ecx, string_rev_palin  
				call put_string_in_loc

				dec dword[palin_arr_i]

				sp_not_palin2:

			pop rbx

				inc dword[sp_i]


				jmp sp_loop_2

		exit_sp_loop_2:



		pop rdx 
		pop rcx 
		pop rax 


	ret


