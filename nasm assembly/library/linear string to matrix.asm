
string_to_matrix:
	
	;; converts a 1d string to a 2d string matrix seperated by words
	;; usage
	;;----------
	;; the 1 d string should be in stom_string variable 
	;; the output 2d string will be in the ebx register
	;; map the ebx register to a string variable before calling this function


	section .bss
		row_size: resd 1
		stom_i: resd 1
		stom_j: resd 1
		stom_pos: resd 1
		stom_temp: resb 1
		no_of_words: resd 1
		
		stom_x: resd 1

	section .text

		push rax 
		push rbx
		push rcx
		push rdx

		mov dword[row_size],50
		mov dword[stom_i],0
		mov dword[stom_j],0
		mov dword[stom_x],0
		mov dword[no_of_words],1
		
		rs_loop_i:
			mov dword[stom_j],0
			rs_loop_j:
				
				push rbx 
				push rcx
					;;-------------
					mov ebx, stom_string
					;;-------------
					mov eax, [stom_x]
					mov cl, byte[ebx+eax]

					mov byte[stom_temp], cl
					inc dword[stom_x]
				pop rcx
				pop rbx

				cmp byte[stom_temp], 0 ;; check if the input is ’Enter’
				je exit_rs_loop_i

				cmp byte[stom_temp],' '
				je exit_rs_loop_j

				
				push rbx
					mov ax,word[stom_i]
					mov bx,word[row_size]
					mul bx
					add ax,word[stom_j]
					mov word[stom_pos],ax
						
					; call debugger

				pop rbx

				mov cl,byte[stom_temp]
				mov eax, [stom_pos]
				mov byte[ebx+eax], cl
				
				inc dword[stom_j]

				jmp rs_loop_j

			exit_rs_loop_j:

			push rbx
					mov ax,word[stom_i]
					mov bx,word[row_size]
					mul bx
					add ax,word[stom_j]
					mov word[stom_pos],ax

			pop rbx
			mov eax, [stom_pos]
			mov byte[ebx+eax], 0

			inc dword[no_of_words]  ;; finds the total no of words
			inc dword[stom_i]

			jmp rs_loop_i

		exit_rs_loop_i:

		push rbx
			mov ax,word[stom_i]
			mov bx,word[row_size]
			mul bx
			add ax,word[stom_j]
			mov word[stom_pos],ax

		pop rbx
		mov eax, [stom_pos]
		mov byte[ebx+eax], 0

		pop rdx
		pop rcx
		pop rbx
		pop rax 

	ret



