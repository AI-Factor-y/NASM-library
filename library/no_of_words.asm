
get_no_of_words:
	
	;; usage
	;--------
	;; the 2d string matrix in ebx
	;; no_of_words wil be in the variable-> result_no_of_words
	
	section .bss
		get_word_i: resd 1	
		get_word_pos: resd 1
		result_no_of_words: resd 1

	section .text

		push rax 
		push rbx
		push rcx
		push rdx

			mov dword[get_word_i],0
			mov dword[result_no_of_words],0

			get_now_loop1:

				push rbx 

					mov bx, word[row_size]
					mov dx,0
					mov ax, word[get_word_i]
					mul bx

					mov word[get_word_pos],ax

				pop rbx

				mov eax, [get_word_pos]
				mov cl, byte[ebx+eax]

				cmp cl,0
				je exit_get_now_loop_1

				inc dword[get_word_i]
				inc dword[result_no_of_words]

				jmp get_now_loop1

			exit_get_now_loop_1:

		pop rdx 
		pop rcx 
		pop rbx 
		pop rax 

	ret

