sort_string_matrix:
	
	;; usage
	;-------
	; string base address in ebx
	
	section .bss
		
		sort_i: resd 1
		sort_j: resd 1

		str_1_pos : resd 1
		str_2_pos: resd 1

	section .text

		push rax  ; push all 
		push rbx
		push rcx

		mov dword[sort_i],0
		mov dword[sort_j],0

		sort_mat_loop1:

			mov eax, [sort_i]
			inc eax	

			cmp eax, [no_of_words]
			je exit_sort_mat_loop1

						
			mov [sort_j],eax

			sort_mat_loop2:
			

				push rbx
				push rcx
					push rbx
					mov ax, word[sort_i]
					mov bx, word[row_size]
					mul bx
					mov word[str_1_pos],ax

					mov ax, word[sort_j]
					mul bx
					mov word[str_2_pos],ax

					pop rbx

					mov ecx, ebx
					add ecx, [str_2_pos]

					add ebx, [str_1_pos]

					

					call compare_strings

					cmp word[compare_flag],1
					jne skip_swapping
				

					call swap_strings

					skip_swapping:

				pop rcx
				pop rbx

				inc dword[sort_j]
				mov eax,[sort_j]
				cmp eax,[no_of_words]
				je exit_sort_mat_loop2

				jmp sort_mat_loop2

			exit_sort_mat_loop2:

			inc dword[sort_i]


			jmp sort_mat_loop1

		exit_sort_mat_loop1:

		pop rcx
		pop rbx
		pop rax  ; pop all

	ret



swap_strings:
	;;usage :
	;---------
	;; string 1 in ebx and string 2 in ecx

	section .bss

		swap_temp_str: resb 50
		s_temp_counter: resd 1
		
	section .text

		push rax
		push rbx
		push rcx
		push rdx

		
		mov dword[s_temp_counter],0
		push rbx
			swap_loop_create_temp: ; temp=s[i]

				mov dl,byte[ebx]
				
				push rbx
					mov ebx, swap_temp_str
					mov eax, [s_temp_counter]
					mov byte[ebx+eax],dl
					inc dword[s_temp_counter]
					

				pop rbx


				cmp dl,0
				je exit_swap_loop_create_temp

				inc ebx
				jmp swap_loop_create_temp

			exit_swap_loop_create_temp:
		pop rbx
			

		push rbx 
		push rcx
			swap_loop_1:
				mov dl,byte[ecx]
				mov byte[ebx],dl

				cmp dl,0
				je exit_swap_loop_1

				inc ebx
				inc ecx

				jmp swap_loop_1

			exit_swap_loop_1:
		pop rcx
		pop rbx

	
		mov ebx, swap_temp_str
		
		swap_loop_2:
			
			mov dl,byte[ebx]
			
			mov byte[ecx],dl

			cmp dl,0
			je exit_swap_loop_2

			inc ebx
			inc ecx

			jmp swap_loop_2

		exit_swap_loop_2:



		pop rdx
		pop rcx
		pop rbx
		pop rax

	ret

