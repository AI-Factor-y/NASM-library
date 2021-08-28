section .data
	
	msg1 : db 'debug here --',10
	l1 : equ $-msg1

	msg2 : db 'Enter your string : '
	l2 : equ $-msg2

	msg3 : db 'The string is changed to : '
	l3 : equ $-msg3

	msg4 : db 'Enter word to find : '
	l4: equ $-msg4

	msg5 : db 'enter word to replace : ',
	l5: equ $-msg5


	space:db ' '
	newline:db '',10


section .bss

	num: resd 1

	counter: resd 1
	
	n: resd 10
	
	string_matrix: resb 1000
	find_str: resb 100
	replace_str: resb 100
section .text
	global _start
	_start:

	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, l2
	int 80h

	mov ebx, string_matrix
	call read_string_as_matrix

	mov eax, 4
	mov ebx, 1
	mov ecx, msg4
	mov edx, l4
	int 80h

	mov ebx , find_str
	call read_array_string

	mov eax, 4
	mov ebx, 1
	mov ecx, msg5
	mov edx, l5
	int 80h

	mov ebx , replace_str
	call read_array_string

	mov ebx, string_matrix
	call find_and_replace ;; procedure to sort the string

	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, l3
	int 80h

	mov ebx , string_matrix
	call print_string_in_matrix

	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 80h

	exit:
	mov eax,1
	mov ebx,0
	int 80h




; section for procedures
;----------------------------



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




find_and_replace:


	section .bss
		
		sort_i: resd 1
		sort_j: resd 1

		str_1_pos : resd 1
		str_2_pos: resd 1

	section .text

		push rax  ; push all 
		push rbx
		push rcx

		mov dword[sort_i],0


		sort_mat_loop1:

			mov eax, [sort_i]
			

			cmp eax, [no_of_words]
			je exit_sort_mat_loop1
			inc eax	

				push rbx
				push rcx
					push rbx
					mov ax, word[sort_i]
					mov bx, word[row_size]
					mul bx
					mov word[str_1_pos],ax

					pop rbx

					mov ecx, find_str
					
					add ebx, [str_1_pos]

					call compare_strings

					cmp word[compare_flag],0
					jne skip_swapping
					
					mov ecx, replace_str
					call swap_strings

					skip_swapping:

				pop rcx
				pop rbx

			inc dword[sort_i]


			jmp sort_mat_loop1

		exit_sort_mat_loop1:

		pop rcx
		pop rbx
		pop rax  ; pop all

	ret



swap_strings:

	section .bss

		swap_temp_str: resb 50
		s_temp_counter: resd 1
		
	section .text

		push rax
		push rbx
		push rcx
		push rdx

		
		mov dword[s_temp_counter],0
		push rbx
			swap_loop_create_temp: ; temp=s[i]

				mov dl,byte[ebx]
				
				push rbx
					mov ebx, swap_temp_str
					mov eax, [s_temp_counter]
					mov byte[ebx+eax],dl
					inc dword[s_temp_counter]
					

				pop rbx


				cmp dl,0
				je exit_swap_loop_create_temp

				inc ebx
				jmp swap_loop_create_temp

			exit_swap_loop_create_temp:
		pop rbx
			

		push rbx 
		push rcx
			swap_loop_1:
				mov dl,byte[ecx]
				mov byte[ebx],dl

				cmp dl,0
				je exit_swap_loop_1

				inc ebx
				inc ecx

				jmp swap_loop_1

			exit_swap_loop_1:
		pop rcx
		pop rbx

	
		mov ebx, swap_temp_str
		
		swap_loop_2:
			
			mov dl,byte[ebx]
			
			mov byte[ecx],dl

			cmp dl,0
			je exit_swap_loop_2

			inc ebx
			inc ecx

			jmp swap_loop_2

		exit_swap_loop_2:



		pop rdx
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




compare_strings:
	
	;; usage
	;-----------
	; 1 : string 1 should be in ebx string 2 should be in ecx 
	; 2 : if string 1> string 2 : compare_flag=1
	; 3 : if string 2> string 1 : compare_flag=2
	; 4 : if string 1==string 2 : compare_flag=0

	section .bss
			
		counter_i : resd 1


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

					jmp exit_compare_str_loop

				str_1_greater:

					mov dword[compare_flag],1  ; string 1 is greater		

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

			mov dword[compare_flag],2

		exit_compare_str_loop:
		

	pop rcx
	pop rbx
	pop rax


	ret



read_string_as_matrix:

	section .bss
		row_size: resd 1
		rs_i: resd 1
		rs_j: resd 1
		rs_pos: resd 1
		rs_temp: resb 1
		no_of_words: resd 1
	section .text

		push rax 
		push rbx
		push rcx
		push rdx

		mov dword[row_size],50
		mov dword[rs_i],0
		mov dword[rs_j],0
		mov dword[no_of_words],1
		
		rs_loop_i:
			mov dword[rs_j],0
			rs_loop_j:
				push rbx
					mov eax, 3
					mov ebx, 0
					mov ecx, rs_temp
					mov edx, 1
					int 80h
				pop rbx

				cmp byte[rs_temp], 10 ;; check if the input is ’Enter’
				je exit_rs_loop_i

				cmp byte[rs_temp],' '
				je exit_rs_loop_j

				
				push rbx
					mov ax,word[rs_i]
					mov bx,word[row_size]
					mul bx
					add ax,word[rs_j]
					mov word[rs_pos],ax
						
					; call debugger

				pop rbx

				mov cl,byte[rs_temp]
				mov eax, [rs_pos]
				mov byte[ebx+eax], cl
				
				inc dword[rs_j]

				jmp rs_loop_j

			exit_rs_loop_j:

			push rbx
					mov ax,word[rs_i]
					mov bx,word[row_size]
					mul bx
					add ax,word[rs_j]
					mov word[rs_pos],ax

			pop rbx
			mov eax, [rs_pos]
			mov byte[ebx+eax], 0

			inc dword[no_of_words]  ;; finds the total no of words
			inc dword[rs_i]

			jmp rs_loop_i

		exit_rs_loop_i:

		push rbx
			mov ax,word[rs_i]
			mov bx,word[row_size]
			mul bx
			add ax,word[rs_j]
			mov word[rs_pos],ax

		pop rbx
		mov eax, [rs_pos]
		mov byte[ebx+eax], 0

		pop rdx
		pop rcx
		pop rbx
		pop rax 

	ret


print_string_in_matrix:
		
	section .bss
		
		ps_i: resd 1
		ps_j: resd 1
		ps_pos: resd 1
		ps_temp: resb 1
	section .text

		push rax 
		push rbx
		push rcx
		push rdx

		mov dword[ps_i],0
		mov dword[ps_j],0
		
		ps_loop_i:

			mov ax, word[ps_i]

			cmp ax, word[no_of_words]
			je exit_ps_loop_i

			mov dword[ps_j],0
			ps_loop_j:
					
				push rbx

					mov ax, word[ps_i]
					mov bx, word[row_size]
					mul bx
					add ax,word[ps_j]
					mov word[ps_pos],ax

				pop rbx

				mov eax, [ps_pos]
				mov al, byte[ebx+eax]
				mov byte[ps_temp], al	

				cmp byte[ps_temp],0
				je exit_ps_loop_j

				push rbx
					mov eax, 4
					mov ebx, 1
					mov ecx, ps_temp
					mov edx, 1
					int 80h
				pop rbx

				inc dword[ps_j]

				jmp ps_loop_j

			exit_ps_loop_j:

			inc dword[ps_i]
			call debugger
			jmp ps_loop_i

		exit_ps_loop_i:

		pop rdx
		pop rcx
		pop rbx
		pop rax 

	ret




debugger:

	section .data

		msg_debugger : db ' '
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


