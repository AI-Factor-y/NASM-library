find_max:
		
	;; value 1 in find_max_1 
	;; value 2 in find_max_2
	;; maximum of the two in find_max_max

	section .bss
		find_max_1: resd 1
		find_max_2: resd 1
		find_max_max: resd 1

	section .text

		push rax
		push rbx
		push rcx
		push rdx

			mov ax, word[find_max_1]
			mov cx, word[find_max_2]

			cmp ax, cx
			jb find_max_else_case

				mov word[find_max_max], ax
				jmp exit_find_max_if
			find_max_else_case:

				mov word[find_max_max], cx

			exit_find_max_if:

		pop rdx
		pop rcx
		pop rbx
		pop rax


	ret




find_min:
		
	;; value 1 in find_min_1 
	;; value 2 in find_min_2
	;; minimum of the two in find_min_min

	section .bss
		find_min_1: resd 1
		find_min_2: resd 1
		find_min_min: resd 1

	section .text

		push rax
		push rbx
		push rcx
		push rdx

			mov ax, word[find_min_1]
			mov cx, word[find_min_2]

			cmp ax, cx
			jb find_min_else_case

				mov word[find_min_min], cx
				jmp exit_find_min_if
			find_min_else_case:

				mov word[find_min_min], ax

			exit_find_min_if:
			
		pop rdx
		pop rcx
		pop rbx
		pop rax


	ret


