
long_rep_sseq:
	
	;; longest repeating subsequence
	;; string base address in ebx
	;; result in long_rep_len 
	;; string length in string_len

	section .bss

		dp: resd 10000

		row_size: resd 1
		col_size: resd 1

		sseq_i: resd 1
		sseq_j: resd 1

		long_rep_len: resd 1

	section .text

		push rax 
		push rbx 
		push rcx
		push rdx 

			mov eax, [string_len]
			inc eax
			mov [row_size], eax
			mov [col_size], eax

			push rbx

				mov ebx, dp 
				call set_mat_to_zero

			pop rbx

			mov dword[sseq_i],1
			


			sseq_loop_1:
				mov ax, word[sseq_i]
				cmp ax, word[string_len]
				ja exit_sseq_loop_1

				mov dword[sseq_j],1
				sseq_loop_2:

					
					; push rbx
					; 	mov ebx, dp 
					; 	call print_matrix

					; pop rbx
	
					mov ax, word[sseq_j]
					cmp ax, word[string_len]
					ja exit_sseq_loop_2


					mov eax, [sseq_i]
					dec eax
					mov cl, byte[ebx+eax]

					mov eax, [sseq_j]
					dec eax
					mov dl, byte[ebx+eax]
					cmp cl, dl
					jne sseq_else

					mov eax, [sseq_i]
					mov ecx, [sseq_j]
					cmp eax, ecx 
					je sseq_else


					; if case
					
					push rbx
						mov ebx, dp

						mov eax, [sseq_i]
						dec eax 
						mov ecx, [sseq_j]
						dec ecx

						call get_elem

						mov word[num],cx

						inc cx
						mov dx,cx
						mov eax, [sseq_i]
						mov ecx, [sseq_j]
						
						call put_elem

					pop rbx

					jmp exit_sseq_if_else

					sseq_else:  ; else case
						
					push rbx
						mov ebx, dp 
						mov eax, [sseq_i]
						mov ecx, [sseq_j]
						dec ecx

						call get_elem
						mov word[find_max_1],cx 

						
						mov eax, [sseq_i]
						dec eax
						mov ecx, [sseq_j]

						call get_elem
						mov word[find_max_2],cx 

						call find_max

						mov dx , word[find_max_max]
						mov eax, [sseq_i]
						mov ecx, [sseq_j]
						call put_elem


					pop rbx

					exit_sseq_if_else:

					inc dword[sseq_j]

					jmp sseq_loop_2

				exit_sseq_loop_2:



				inc dword[sseq_i]
				jmp sseq_loop_1

			exit_sseq_loop_1:

			push rbx
				mov ebx, dp
				mov eax, [string_len]
				mov ecx, [string_len]
				call get_elem

				mov word[long_rep_len], cx

 			pop rbx
		pop rdx
		pop rcx
		pop rbx
		pop rax

	ret



