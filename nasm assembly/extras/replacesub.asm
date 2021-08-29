section .data
	
	msg1 : db 'debug here --',10
	l1 : equ $-msg1

	msg2 : db 'enter a string : '
	l2 : equ $-msg2

	msg3 : db 'msg 3 here'
	l3 : equ $-msg3

	msg4 : db 'msg 4 here'
	l4: equ $-msg4

	msg5 : db 'msg 5 here',10
	l5: equ $-msg5


	space:db ' '
	newline:db '',10


section .bss

	num: resd 1

	counter: resd 1
	
	n: resd 10
	string: resb 100

	
section .text
	global _start
	_start:

	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, l2
	int 80h

	mov ebx, string
	call read_array_string

	mov ebx, rsst_find  
	call read_array_string

	mov ebx, rsst_replace
	call read_array_string

	mov ebx, string 
	call replace_sub_str

	mov ebx,rsst_string
	call print_array_string

	exit:
	mov eax,1
	mov ebx,0
	int 80h




; section for procedures
;----------------------------

replace_sub_str:

	;; usage
	;-----------
	; replaces every substring of the string which is equal to rsst_find
	; string in ebx , string to find in rsst_find 
	; string to replace in rsst_replace
	; new string in rsst_string
	
	section .bss

		rsst_string: resb 100
		rsst_find: resb 100
		rsst_replace: resb 100

		rsst_i: resd 1
		rsst_j: resd 1
		rsst_k: resd 1
		rsst_flag: resd 1
		rsst_x: resd 1

	section .text

		push rax
		push rbx
		push rcx
		push rdx

			mov dword[rsst_i],0
			mov dword[rsst_j],0
			mov dword[rsst_k],0
			mov dword[rsst_x],0
			mov dword[rsst_flag],0

			rsst_loop1:
				mov eax, [rsst_i]
				mov cl,byte[ebx+eax]
				cmp cl,0
				je exit_rsst_loop1

				;; check for first occurence
				mov dword[rsst_j],0
				mov eax, [rsst_i]
				mov dword[rsst_k],eax

				
				rsst_loop2:

					mov eax, [rsst_i]
					mov cl,byte[ebx+eax]

					push rbx
						mov ebx, rsst_find
						
						mov eax,[rsst_j]
						mov dl, byte[ebx+eax]
					pop rbx

					cmp cl,dl
					jne rsst_exit_loop2

					cmp cl,0
					je rsst_exit_loop2


					mov eax, [rsst_j]
					mov dword[num],eax 


					inc dword[rsst_i]
					inc dword[rsst_j]

					jmp rsst_loop2

				rsst_exit_loop2:
				

				push rbx
					mov ebx, rsst_find
					
					mov eax,[rsst_j]
					mov dl, byte[ebx+eax]
				pop rbx

				cmp dl,0
				jne rsst_else_case

					
					;; replace the string 
					mov dword[rsst_j],0

					rsst_loop_3:

						mov eax, [rsst_j]
						push rbx 

							mov ebx, rsst_replace 
							mov cl, byte[ebx+eax]
						pop rbx

						cmp cl,0
						je exit_rsst_loop3

						mov eax, [rsst_x]	
						push rbx
							mov ebx, rsst_string 
							mov byte[ebx+eax],cl

						pop rbx 

						inc dword[rsst_x]
						inc dword[rsst_j]

						jmp rsst_loop_3

					exit_rsst_loop3:

					jmp rsst_cont_loop_1

				rsst_else_case:

					mov eax, [rsst_k]
							
					mov [rsst_i],eax 

					mov cl, byte[ebx+eax]
					
					push rbx 
						mov eax, [rsst_x]
						mov ebx, rsst_string 
						mov byte[ebx+eax],cl
					pop rbx 
						

					inc dword[rsst_i]
					inc dword[rsst_x]

				rsst_cont_loop_1:

				

				jmp rsst_loop1

			exit_rsst_loop1:

				

		

		pop rdx
		pop rcx
		pop rbx 
		pop rax

	ret




debugger:

	section .data

		msg_debugger : db 'debug here --',10
		msg_debugger_l : equ $-msg_debugger

	section .text

		push rax
		push rbx
		push rcx
		push rdx
		; debug----
				mov eax, 4
				mov ebx, 1
				mov ecx, msg_debugger
				mov edx, msg_debugger_l
				int 80h
				;debug ---

		pop rdx
		pop rcx	
		pop rbx
		pop rax

		; action

	ret


read_array_string:
	
	;; usage
	;--------
	; 1: string is read and stored in string variable
	; 2: string length is stored in string_len

	section .bss

		string_len : resd 1
		
		temp_read_str :  resb 1

	section .text

		push rax
		push rbx
		push rcx

		mov word[string_len],0

		reading:
		push rbx
		mov eax, 3
		mov ebx, 0
		mov ecx, temp_read_str
		mov edx, 1
		int 80h
		pop rbx
		cmp byte[temp_read_str], 10 ;; check if the input is ’Enter’
		je end_reading
		inc byte[string_len]
		mov al,byte[temp_read_str]
		mov byte[ebx], al
		inc ebx
		jmp reading
		end_reading:
		;; Similar to putting a null character at the end of a string
		mov byte[ebx], 0

		
		pop rcx
		pop rbx
		pop rax

	ret


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







print_array:

	; usage
	;-------
	; 1: base address of array in ebx mov ebx,array
	; 2: size of array in n
	
	push rax ; push all
	push rbx
	push rcx	

	mov eax,0

	print_loop:
	cmp eax,dword[n]
	je end_print1
	mov cx,word[ebx+2*eax]
	mov word[num],cx
	;;The number to be printed is copied to ’num’
	; before calling print num function
	push rax
	push rbx

	call print_num

	pop rbx
	pop rax

	inc eax
	jmp print_loop
	end_print1:
	; popa
	pop rcx
	pop rbx
	pop rax	; pop all

	ret




read_array:

	; usage
	;-------
	; 1: base address of array in ebx mov ebx, array
	; 2: size of array in n

	push rax ; push all
	push rbx
	push rcx

	mov eax ,0
	read_loop:

		cmp eax,dword[n]
		je end_read_1

		push rax
		push rbx

		call read_num

		pop rbx
		pop rax

		;;read num stores the input in ’num’
		mov cx,word[num]

		

		mov word[ebx+2*eax],cx
		
		inc eax

		;;Here, each word consists of two bytes, so the counter should be
		; incremented by multiples of two. If the array is declared in bytes do mov word[ebx+eax],cx

		jmp read_loop

		end_read_1:

	pop rcx
	pop rbx
	pop rax ; pop all

	ret




print_num:
	;usage
	;------
	; 1: create a variable num(word)
	; 2: move number to print to num (word)

	section .data
		nwl_for_printnum :db ' '
		nwl_l_printnum : equ $-nwl_for_printnum

		show_zero :db '0 ' 
		show_zero_l : equ $-show_zero

	section .bss
		count_printnum :  resb 10
		temp_printnum : resb 1

	section .text
		push rax ; push all
		push rbx
		push rcx

		cmp word[num],0
		je print_zero

		mov byte[count_printnum],0
		;call push_reg
		extract_no:
			cmp word[num], 0
			je print_no
			inc byte[count_printnum]
			mov dx, 0
			mov ax, word[num]
			mov bx, 10
			div bx
			push dx ; recursion here
			mov word[num], ax
			jmp extract_no
		print_no:
		cmp byte[count_printnum], 0
		je end_print
		dec byte[count_printnum]
		pop dx
		mov byte[temp_printnum], dl  ; dx is further divided into dh and dl
		add byte[temp_printnum], 30h
		mov eax, 4
		mov ebx, 1
		mov ecx, temp_printnum
		mov edx, 1
		int 80h
		jmp print_no
		end_print:

		mov eax,4
		mov ebx,1
		mov ecx,nwl_for_printnum
		mov edx,nwl_l_printnum
		int 80h
		;;The memory location ’newline’ should be declared with the ASCII key for new popa
		;call pop_reg

		jmp exit_printing

		print_zero:
			mov eax,4
			mov ebx,1
			mov ecx,show_zero
			mov edx,show_zero_l
			int 80h
		exit_printing:
		pop rcx
		pop rbx
		pop rax ; pop all

	ret


read_num:

	;usage
	;------
	; 1: create a variable num(word)
	; 2: the input number is stored into num(word)

	section .bss

		temp_for_read: resb 1

	section .text

	
	push rax ; push all
	push rbx
	push rcx

	mov word[num], 0
	loop_read:
	;; read a digit
	mov eax, 3
	mov ebx, 0
	mov ecx, temp_for_read
	mov edx, 1
	int 80h
	;;check if the read digit is the end of number, i.e, the enter-key whose ASCII cmp byte[temp], 10

	cmp byte[temp_for_read], 10
	je end_read

	mov ax, word[num]
	mov bx, 10
	mul bx
	mov bl, byte[temp_for_read]
	sub bl, 30h
	mov bh, 0
	add ax, bx
	mov word[num], ax
	jmp loop_read
	end_read:
	;;pop all the used registers from the stack using popa
	;call pop_reg

	pop rcx
	pop rbx
	pop rax

	ret


