

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

