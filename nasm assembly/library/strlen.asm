

strlen:
	;; base address in ebx 
	;; strlen value will be in ecx 

	section .bss
		strlen_i: resd 1

	section .text

		push rax 
		push rbx  
		push rdx 


			mov eax,0	

			strlen_loop:
				mov cl, byte[ebx+eax]
				cmp cl,0
				je exit_strlen_loop

				inc eax 

				jmp strlen_loop 
			exit_strlen_loop:

			mov ecx, eax

		pop rdx 
		pop rbx 
		pop rax 

	ret

