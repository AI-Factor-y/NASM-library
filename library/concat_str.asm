

concatinate_strings:
	
	; the two strings should be in ebx and ecx
	; the resut of concatenation is stored in result_concat_string

	section .bss
			
		result_concat_string : resb 100

		counter_i : resd 1
		counter_res: resd 1

	section .text

	push rax
	push rbx
	push rcx
		
		mov word[counter_i],0
		mov word[counter_res],0

		push rcx
		concat_str_1:

			mov eax,[counter_i]
			mov cl, byte[ebx+eax]

			cmp cl,0
			je exit_concat_str_1

			push rbx

				mov ebx, result_concat_string
				mov eax, [counter_res]
				mov byte[ebx+eax],cl

			pop rbx

			inc dword[counter_i]
			inc dword[counter_res]

			jmp concat_str_1

		exit_concat_str_1:

		pop rcx

		mov word[counter_i],0
		
		concat_str_2:

			mov eax,[counter_i]
			mov dl, byte[ecx+eax]

			cmp dl,0
			je exit_concat_str_2

			push rbx

				mov ebx, result_concat_string
				mov eax, [counter_res]
				mov byte[ebx+eax],dl

			pop rbx

			inc dword[counter_i]
			inc dword[counter_res]

			jmp concat_str_2

		exit_concat_str_2:

		mov ebx, result_concat_string
		mov eax, [counter_res]
		mov byte[ebx+eax],0


	pop rcx
	pop rbx
	pop rax


	ret

