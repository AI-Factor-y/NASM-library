

print_array_string:
	
	;; usage
	;-----------
	; 1: base address of string to print is stored in ebx

	push rax
	push rbx
	push rcx

	printing:
	mov al, byte[ebx]
	mov byte[temp], al
	cmp byte[temp], 0 ;; checks if the character is NULL character
	je end_printing
	push rbx
	mov eax, 4
	mov ebx, 1
	mov ecx, temp
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
