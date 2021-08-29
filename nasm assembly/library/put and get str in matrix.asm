

put_string_in_loc:
	;; i in eax ( loc of string in 2d matrix)
	;; base address of matric in ecx
	;; base address of string to be put in matrix  is : ebx
	;; string to put in ebx be in ecx reg 

	section .text

		push rax 
		push rbx 
		push rdx 

			push rcx 

				mov cx, word[row_size]
				mul cx

			pop rcx	

			add ecx,eax
			call strcpy

		pop rdx 
		pop rbx 
		pop rax 

	ret



string_at_location:
	
	;; i in eax ( loc of string in 2d matrix)
	;; string will be in str_at_loc variable 
	;; use strcpy to copy string from str_at_loc variable 

	section .bss

		str_at_loc: resb 100

	section .text

		push rax 
		push rbx 
		push rcx
		push rdx 

			push rbx 

				mov bx, word[row_size]
				mul bx

			pop rbx	

			add ebx,eax
			mov ecx,str_at_loc
			call strcpy

		pop rdx 
		pop rcx
		pop rbx 
		pop rax 

	ret


strcpy:
		
	;; copies contents of string ebx to string ecx
	;; strcpy(ecx,ebx)
	;; string 1 is ebx string 2 is ecx 
	;; ecx string changes and becomes same as ebx
	
	section .text

		push rax 
		push rbx
		push rdx

			strcpy_loop_1:
				mov dl,byte[ebx]
				mov byte[ecx],dl

				cmp dl,0
				je exit_strcpy_loop_1

				inc ebx
				inc ecx

				jmp strcpy_loop_1

			exit_strcpy_loop_1:

		pop rdx
		pop rcx
		pop rax

	ret 

