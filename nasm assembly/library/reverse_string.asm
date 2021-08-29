
reverse_string:
	
	; base address should be in ebx length of string in string_len
	; the reversed string is stored in a variable called rev_string
	; use rev_string to access the reversed string

	section .bss
			
		rev_string: resb 50

		counter_i : resd 1

		counter_rev: resd 1


	section .text

	push rax
	push rbx
	push rcx

		mov eax,[string_len]
		mov [counter_i],eax ;i=n
		mov dword[counter_rev],0 ; j=0

		rev_loop:

			mov ax,word[counter_i]  ; if i<1 : break
			cmp ax,1
			jb exit_rev_loop

			mov eax, [counter_i] 
			dec eax 
			mov cl,byte[ebx+eax]  ; reg(cl) = string[i-1]
			inc eax
			mov [counter_i],eax

			push rbx
				mov ebx,rev_string
				mov eax, [counter_rev] ; rev_string[j]=reg(cl)
				mov byte[ebx+eax], cl

			pop rbx

			inc dword[counter_rev] ;j++
			dec dword[counter_i]  ;i--


			jmp rev_loop
			
		exit_rev_loop:
		; call debugger
		mov ebx, rev_string
		mov eax,[counter_rev] ; rev_string[j]='\0'
		mov byte[ebx+eax], 0


	pop rcx
	pop rbx
	pop rax


	ret
