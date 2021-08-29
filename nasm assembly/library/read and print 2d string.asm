
read_string_as_matrix:
		
	;; base address in ebx

	section .bss
		row_size: resd 1
		rs_i: resd 1
		rs_j: resd 1
		rs_pos: resd 1
		rs_temp: resb 1
		no_of_words: resd 1
	section .text

		push rax 
		push rbx
		push rcx
		push rdx

		mov dword[row_size],50
		mov dword[rs_i],0
		mov dword[rs_j],0
		mov dword[no_of_words],1
		
		rs_loop_i:
			mov dword[rs_j],0
			rs_loop_j:
				push rbx
					mov eax, 3
					mov ebx, 0
					mov ecx, rs_temp
					mov edx, 1
					int 80h
				pop rbx

				cmp byte[rs_temp], 10 ;; check if the input is ’Enter’
				je exit_rs_loop_i

				cmp byte[rs_temp],' '
				je exit_rs_loop_j

				
				push rbx
					mov ax,word[rs_i]
					mov bx,word[row_size]
					mul bx
					add ax,word[rs_j]
					mov word[rs_pos],ax
						
					; call debugger

				pop rbx

				mov cl,byte[rs_temp]
				mov eax, [rs_pos]
				mov byte[ebx+eax], cl
				
				inc dword[rs_j]

				jmp rs_loop_j

			exit_rs_loop_j:

			push rbx
					mov ax,word[rs_i]
					mov bx,word[row_size]
					mul bx
					add ax,word[rs_j]
					mov word[rs_pos],ax

			pop rbx
			mov eax, [rs_pos]
			mov byte[ebx+eax], 0

			inc dword[no_of_words]  ;; finds the total no of words
			inc dword[rs_i]

			jmp rs_loop_i

		exit_rs_loop_i:

		push rbx
			mov ax,word[rs_i]
			mov bx,word[row_size]
			mul bx
			add ax,word[rs_j]
			mov word[rs_pos],ax

		pop rbx
		mov eax, [rs_pos]
		mov byte[ebx+eax], 0

		pop rdx
		pop rcx
		pop rbx
		pop rax 

	ret


print_string_in_matrix:
		
	;; base address of string in ebx
	;; no_of_words is required 
	;; row_size is required
	
	section .bss
		
		ps_i: resd 1
		ps_j: resd 1
		ps_pos: resd 1
		ps_temp: resb 1
	section .text

		push rax 
		push rbx
		push rcx
		push rdx

		mov dword[ps_i],0
		mov dword[ps_j],0
		
		ps_loop_i:

			mov ax, word[ps_i]

			cmp ax, word[no_of_words]
			je exit_ps_loop_i

			mov dword[ps_j],0
			ps_loop_j:
					
				push rbx

					mov ax, word[ps_i]
					mov bx, word[row_size]
					mul bx
					add ax,word[ps_j]
					mov word[ps_pos],ax

				pop rbx

				mov eax, [ps_pos]
				mov al, byte[ebx+eax]
				mov byte[ps_temp], al	

				cmp byte[ps_temp],0
				je exit_ps_loop_j

				push rbx
					mov eax, 4
					mov ebx, 1
					mov ecx, ps_temp
					mov edx, 1
					int 80h
				pop rbx

				inc dword[ps_j]

				jmp ps_loop_j

			exit_ps_loop_j:

			inc dword[ps_i]
			call debugger_space_gen
			jmp ps_loop_i

		exit_ps_loop_i:

		pop rdx
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

