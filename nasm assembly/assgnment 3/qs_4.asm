section .data
	

	msg2 : db 'enter a string 1 : '
	l2 : equ $-msg2

	msg3 : db 'enter a string 2 : '
	l3 : equ $-msg3


	msg4 : db 'string 1 is greater  ',10
	l4 : equ $-msg4


	msg5 : db 'string 2 is greater ',10
	l5 : equ $-msg5

	msg6 : db 'both strings are equal ',10
	l6 : equ $-msg6

	msg7 : db 'mismatch position is : ',
	l7 : equ $-msg7

	space:db ' '
	newline:db '',10

	nwl :db ' ',10
	nwl_l : equ $-nwl
section .bss
	
	string :resb 50
	string_len : resd 1
	string_1: resb 50
	string_2: resb 50

	strlen: resd 1
	temp :  resb 1

section .text
	global _start
	_start:

	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, l2
	int 80h

	mov ebx, string_1
	call read_array_string



	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, l3
	int 80h

	mov ebx, string_2
	call read_array_string
	
	
	mov ebx,string_1
	mov ecx, string_2

	call compare_strings

	cmp dword[compare_flag],0
	je both_equal_case

		cmp dword[compare_flag],2
		je second_greater_case

			mov eax, 4
			mov ebx, 1
			mov ecx, msg4
			mov edx, l4
			int 80h

			mov eax, 4
			mov ebx, 1
			mov ecx, msg7
			mov edx, l7
			int 80h

			mov ax,word[mismatch_pos]
			mov word[num],ax
			call print_num

			jmp exit

		second_greater_case:
			mov eax, 4
			mov ebx, 1
			mov ecx, msg5
			mov edx, l5
			int 80h

			mov eax, 4
			mov ebx, 1
			mov ecx, msg7
			mov edx, l7
			int 80h

			mov ax,word[mismatch_pos]
			mov word[num],ax
			call print_num

			jmp exit

	both_equal_case:
			mov eax, 4
			mov ebx, 1
			mov ecx, msg6
			mov edx, l6
			int 80h

	
	exit:
	mov eax, 1
	mov ebx, 0
	int 80h





;; section for procedures
;;--------------------------


compare_strings:
	
	;; usage
	;-----------
	; 1 : string 1 should be in ebx string 2 should be in ecx 
	; 2 : if string 1> string 2 : compare_flag=1
	; 3 : if string 2> string 1 : compare_flag=2
	; 4 : if string 1==string 2 : compare_flag=0

	section .bss
			
		counter_i : resd 1

		mismatch_pos: resd 1
		compare_flag: resd 1
			

	section .text

	push rax
	push rbx
	push rcx
		
		 
		mov word[counter_i],0
		mov dword[compare_flag],0

		compare_str_loop:

			mov eax,[counter_i]
			mov al,byte[ebx+eax]   ;; extraxt string1[i]

			cmp al,0  
			je check_is_str_2_ended ;; if string1[i]==null then check if string 2 is ended too
									;; if not ended then string 2 is greater than string_1
			push rax
			mov eax, [counter_i]
			mov dl,byte[ecx+eax]	;; check string 2 is ended then string 1 is greater since string 1 is 
									;; not ended .. (if its ended control should not reach here)
			pop rax

			cmp dl,0				;; compare the two characters
			je str_1_greater


			cmp al,dl
			je continue_compare_str

				cmp al,dl
				ja str_1_greater
					
					mov dword[compare_flag],2  ; string 2 is greater

					mov eax,[counter_i]
					mov [mismatch_pos],eax

					jmp exit_compare_str_loop

				str_1_greater:

					mov dword[compare_flag],1  ; string 1 is greater	

					mov eax,[counter_i]
					mov [mismatch_pos],eax	

					jmp exit_compare_str_loop
			continue_compare_str:

			inc dword[counter_i]

			jmp compare_str_loop
					
		check_is_str_2_ended:

			push rax
			mov eax, [counter_i]    ;; check whether string2 is ended 
			mov dl,byte[ecx+eax]	;; if ended then strings are equal else string 2 is greater
			pop rax

			cmp dl,0
			je exit_compare_str_loop

			mov eax,[counter_i]
			mov [mismatch_pos],eax

			mov dword[compare_flag],2

		exit_compare_str_loop:
		

	pop rcx
	pop rbx
	pop rax


	ret




debugger:

	section .data

		msg_debugger : db '',10
		msg_debugger_l : equ $-msg_debugger

	section .bss
		num: resd 1
		
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



print_num:
	;usage
	;------
	; 1: create a variable num(word)
	; 2: move number to print to num (word)

	section .data
		nwl_for_printnum :db ' ',10
		nwl_l_printnum : equ $-nwl_for_printnum

	section .bss
		count_printnum :  resb 10
		temp_printnum : resb 1

	section .text
		push rax ; push all
		push rbx
		push rcx

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
		pop rcx
		pop rbx
		pop rax ; pop all

	ret




read_array_string:
	
	;; usage
	;--------
	; 1: string is read and stored in string variable
	; 2: string length is stored in string_len

	push rax
	push rbx
	push rcx

	mov word[string_len],0

	reading:
	push rbx
	mov eax, 3
	mov ebx, 0
	mov ecx, temp
	mov edx, 1
	int 80h
	pop rbx
	cmp byte[temp], 10 ;; check if the input is ’Enter’
	je end_reading
	inc byte[string_len]
	mov al,byte[temp]
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
