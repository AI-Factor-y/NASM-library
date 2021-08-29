
replace_sub_str:

	;; usage
	;-----------
	; replaces every substring of the string which is equal to rsst_find
	; string in ebx , string to find in rsst_find 
	; string to replace in rsst_replace
	; new string in rsst_string
	
	section .bss

		rsst_string: resb 100
		rsst_find: resb 100
		rsst_replace: resb 100

		rsst_i: resd 1
		rsst_j: resd 1
		rsst_k: resd 1
		rsst_flag: resd 1
		rsst_x: resd 1

	section .text

		push rax
		push rbx
		push rcx
		push rdx

			mov dword[rsst_i],0
			mov dword[rsst_j],0
			mov dword[rsst_k],0
			mov dword[rsst_x],0
			mov dword[rsst_flag],0

			rsst_loop1:
				mov eax, [rsst_i]
				mov cl,byte[ebx+eax]
				cmp cl,0
				je exit_rsst_loop1

				;; check for first occurence
				mov dword[rsst_j],0
				mov eax, [rsst_i]
				mov dword[rsst_k],eax

				
				rsst_loop2:

					mov eax, [rsst_i]
					mov cl,byte[ebx+eax]

					push rbx
						mov ebx, rsst_find
						
						mov eax,[rsst_j]
						mov dl, byte[ebx+eax]
					pop rbx

					cmp cl,dl
					jne rsst_exit_loop2

					cmp cl,0
					je rsst_exit_loop2


					mov eax, [rsst_j]
					mov dword[num],eax 


					inc dword[rsst_i]
					inc dword[rsst_j]

					jmp rsst_loop2

				rsst_exit_loop2:
				

				push rbx
					mov ebx, rsst_find
					
					mov eax,[rsst_j]
					mov dl, byte[ebx+eax]
				pop rbx

				cmp dl,0
				jne rsst_else_case

					
					;; replace the string 
					mov dword[rsst_j],0

					rsst_loop_3:

						mov eax, [rsst_j]
						push rbx 

							mov ebx, rsst_replace 
							mov cl, byte[ebx+eax]
						pop rbx

						cmp cl,0
						je exit_rsst_loop3

						mov eax, [rsst_x]	
						push rbx
							mov ebx, rsst_string 
							mov byte[ebx+eax],cl

						pop rbx 

						inc dword[rsst_x]
						inc dword[rsst_j]

						jmp rsst_loop_3

					exit_rsst_loop3:

					jmp rsst_cont_loop_1

				rsst_else_case:

					mov eax, [rsst_k]
							
					mov [rsst_i],eax 

					mov cl, byte[ebx+eax]
					
					push rbx 
						mov eax, [rsst_x]
						mov ebx, rsst_string 
						mov byte[ebx+eax],cl
					pop rbx 
						

					inc dword[rsst_i]
					inc dword[rsst_x]

				rsst_cont_loop_1:

				

				jmp rsst_loop1

			exit_rsst_loop1:

	
		

		pop rdx
		pop rcx
		pop rbx 
		pop rax

	ret


