
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


