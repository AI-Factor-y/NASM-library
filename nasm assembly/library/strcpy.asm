
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

