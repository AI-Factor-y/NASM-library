section .data
	
	msg1 : db 'debug here --',10
	l1 : equ $-msg1

	msg2 : db 'Enter your string : '
	l2 : equ $-msg2

	msg3 : db 'smallest words : '
	l3 : equ $-msg3

	msg4 : db 'largest words : '
	l4: equ $-msg4

	msg5 : db 'msg 5 here',10
	l5: equ $-msg5


	space:db ' '
	newline:db '',10


section .bss

	num: resd 1

	counter: resd 1
	
	n: resd 10
	
	string_matrix: resb 1000
	
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

	call find_min_max

	

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

find_min_max:

	section .bss
		size_array: resd 200
		size_array_counter: resd 1
		min_size: resd 1
		max_size: resd 1
		min_max_i: resd 1
		selected_case_min_max: resd 1

	section .text
		push rax
		push rbx
		push rcx
		push rdx


		call create_size_array	

		mov ebx, size_array
		mov dword[min_size],1000
		mov dword[max_size],0

		min_max_loop1:

			mov eax,[min_max_i]

			cmp eax,[size_array_counter]
			je exit_min_max_loop1

			mov cx, word[ebx+2*eax]

			cmp cx, word[min_size]
			jae continue_min_search

			mov word[min_size],cx

			continue_min_search:

			cmp cx, word[max_size]
			jbe continue_max_search

			mov word[max_size],cx

			continue_max_search:

			inc dword[min_max_i]
			jmp min_max_loop1
		exit_min_max_loop1:

		mov eax, 4
		mov ebx, 1
		mov ecx, msg3
		mov edx, l3
		int 80h

		mov eax, [min_size]
		mov ebx, string_matrix
		mov [selected_case_min_max], eax
		call print_string_in_matrix

		call debugger

		mov eax, 4
		mov ebx, 1
		mov ecx, msg4
		mov edx, l4
		int 80h

		mov eax, [max_size]
		mov ebx, string_matrix
		mov [selected_case_min_max], eax
		call print_string_in_matrix



		pop rdx
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

			push rbx
			push rax 

				mov eax,[ps_i]
				mov ebx, size_array

				mov cx, word[ebx+2*eax]

			pop rax
			pop rbx

			cmp cx,word[selected_case_min_max]
			jne exit_ps_loop_j2

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
				call debugger2
			exit_ps_loop_j2:
			inc dword[ps_i]
			
			jmp ps_loop_i

		exit_ps_loop_i:

		pop rdx
		pop rcx
		pop rbx
		pop rax 

	ret


create_size_array:
		
	section .bss
		
		csa_i: resd 1
		csa_j: resd 1
		csa_pos: resd 1
		csa_temp: resb 1
		size_count: resd 1
	section .text

		push rax 
		push rbx
		push rcx
		push rdx

		mov dword[csa_i],0
		mov dword[csa_j],0
		
		csa_loop_i:
			mov dword[size_count],0

			mov ax, word[csa_i]

			cmp ax, word[no_of_words]
			je exit_csa_loop_i

			mov dword[csa_j],0
			csa_loop_j:
					
				push rbx

					mov ax, word[csa_i]
					mov bx, word[row_size]
					mul bx
					add ax,word[csa_j]
					mov word[csa_pos],ax

				pop rbx

				mov eax, [csa_pos]
				mov al, byte[ebx+eax]
				mov byte[csa_temp], al	

				cmp byte[csa_temp],0
				je exit_csa_loop_j


				inc dword[csa_j]
				inc dword[size_count]

				jmp csa_loop_j

			exit_csa_loop_j:

			inc dword[csa_i]

			push rcx
			push rbx	
			push rax

				mov ebx, size_array
				mov eax, [size_array_counter]
				mov cx, word[size_count]
				mov word[ebx+2*eax], cx
				inc dword[size_array_counter]
			pop rax
			pop rbx
			pop rcx

			
			jmp csa_loop_i

		exit_csa_loop_i:

		pop rdx
		pop rcx
		pop rbx
		pop rax 

	ret



debugger:

	section .data

		msg_debugger : db '',10
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



debugger2:

	section .data

		msg_debugger2 : db ' ',
		msg_debugger_l2 : equ $-msg_debugger2

	section .text

		push rax
		push rbx
		push rcx
		push rdx
		; debug----
				mov eax, 4
				mov ebx, 1
				mov ecx, msg_debugger2
				mov edx, msg_debugger_l2
				int 80h
				;debug ---

		pop rdx
		pop rcx	
		pop rbx
		pop rax

		; action

	ret