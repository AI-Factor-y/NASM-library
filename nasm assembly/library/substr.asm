
string_substr:
	
	;; usage
	;-------------
	;; ebx ->string ecx->start edx->end 
	;; substring in ssub_str variable

	section .bss
		ssub_str: resb 1000
		ssub_i: resd 1	
		ssub_j: resd 1
	section .text

		push rax
		push rbx
		push rcx
		push rdx

			mov dword[ssub_i],ecx
			mov dword[ssub_j],0

			inc edx

			ssub_loop_1:

				mov eax, [ssub_i]	

				cmp eax, edx
				je exit_ssub_loop_1

				mov cl, byte[ebx+eax]

				cmp cl, 0
				je exit_ssub_loop_1

				push rbx

					mov ebx, ssub_str
					mov eax, [ssub_j]

					mov byte[ebx+eax],cl

					inc dword[ssub_j]

				pop rbx

				inc dword[ssub_i]
				jmp ssub_loop_1

			exit_ssub_loop_1:



		pop rdx
		pop rcx 
		pop rbx
		pop rax

	ret

