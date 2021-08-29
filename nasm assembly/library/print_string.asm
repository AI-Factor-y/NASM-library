
print_array_string:
	
	;; usage
	;-----------
	; 1: base address of string to print is stored in ebx
	section .bss
		
		temp_print_str :  resb 1

	section .text
		push rax
		push rbx
		push rcx

		printing:
		mov al, byte[ebx]
		mov byte[temp_print_str], al
		cmp byte[temp_print_str], 0 ;; checks if the character is NULL character
		je end_printing
		push rbx
		mov eax, 4
		mov ebx, 1
		mov ecx, temp_print_str
		mov edx, 1
		int 80h
		pop rbx
		inc ebx
		jmp printing
		end_printing:
		
		pop rcx
		pop rbx
		pop rax
	ret

