
set_mat_to_zero:
		
	section .bss

		set_mat_i: resd 1
		set_mat_j: resd 1

	section .text
		push rax
		push rbx
		push rcx
		push rdx 

		mov dword[set_mat_i],0
		mov dword[set_mat_j],0

		set_zero_loop_i:	

			mov ax,word[set_mat_i]

			cmp ax,word[col_size]
			je exit_set_zero_loop_i

			set_zero_loop_j:
				mov ax, word[set_mat_j]
				cmp ax, word[row_size]
				je exit_set_zero_loop_j

				mov eax,[set_mat_i]
				mov ecx,[set_mat_j]
				mov dx, 0
				call put_elem

				inc dword[set_mat_j]

				jmp set_zero_loop_j 

			exit_set_zero_loop_j:

			inc dword[set_mat_i]

		exit_set_zero_loop_i:

		pop rdx 
		pop rcx
		pop rbx
		pop rax 

	ret 



put_elem:

	;; i in eax, j in ecx , array address in ebx  ; value in dx register
	section .bss
		
		put_elem_pos: resd 1

		
	section .text

		push rax 
		push rbx
		push rcx
		push rdx


			push rbx
			push rdx
					mov ebx, [row_size]
					mul ebx
					add eax,ecx
					mov [put_elem_pos],eax
					
					; call debugger
			pop rdx
			pop rbx


			mov eax, [put_elem_pos]
			mov  word[ebx+2*eax], dx

		pop rdx 
		pop rcx
		pop rbx
		pop rax 


	ret 



get_elem:

	;; i in eax, j in ecx , array address in ebx  ; value in cx register
	section .bss
		
		get_elem_pos: resd 1

		
	section .text

		push rax 
		push rbx
		
		push rdx


			push rbx
					
					mov ebx, [row_size]
					mul ebx
					add eax,ecx
					mov [get_elem_pos],eax
					
					; call debugger

			pop rbx


			mov eax, [get_elem_pos]
			mov cx , word[ebx+2*eax]

		pop rdx 
		
		pop rbx
		pop rax 


	ret 


read_matrix:

	section .bss
		
		mat_rs_i: resd 1
		mat_rs_j: resd 1
		mat_rs_pos: resd 1
		mat_rs_temp: resd 1
		
	section .text

		push rax 
		push rbx
		push rcx
		push rdx

		mov dword[mat_rs_i],0
		mov dword[mat_rs_j],0
		
		
		rs_loop_i:

			mov ax, word[col_size]
			cmp word[mat_rs_i], ax
			je exit_rs_loop_i 

			mov dword[mat_rs_j],0

			rs_loop_j:

				mov ax, word[row_size]

				cmp word[mat_rs_j], ax ;; check if the input is ’Enter’
				je exit_rs_loop_j


				call read_num
				mov eax, [num]
				mov [mat_rs_temp], eax

		
				push rbx
					mov ax,word[mat_rs_i]
					mov bx,word[row_size]
					mul bx
					add ax,word[mat_rs_j]
					mov word[mat_rs_pos],ax
						
					; call debugger

				pop rbx

				mov cx,word[mat_rs_temp]
				mov eax, [mat_rs_pos]
				mov word[ebx+2*eax], cx
				
				inc dword[mat_rs_j]

				jmp rs_loop_j

			exit_rs_loop_j:

			
			inc dword[mat_rs_i]

			jmp rs_loop_i

		exit_rs_loop_i:

		
		pop rdx
		pop rcx
		pop rbx
		pop rax 

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

	cmp byte[temp_for_read], ' '
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



print_matrix:
		
	section .bss
		
		mat_ps_i: resd 1
		mat_ps_j: resd 1
		mat_ps_pos: resd 1
		mat_ps_temp: resd 1
	section .text

		push rax 
		push rbx
		push rcx
		push rdx

		mov dword[mat_ps_i],0
		mov dword[mat_ps_j],0
		
		ps_loop_i:

			mov ax, word[mat_ps_i]

			cmp ax, word[col_size]
			je exit_ps_loop_i

			mov dword[mat_ps_j],0
			ps_loop_j:
					
				mov ax, word[row_size]
				cmp ax, word[mat_ps_j]
				je exit_ps_loop_j 

				push rbx

					mov ax, word[mat_ps_i]
					mov bx, word[row_size]
					mul bx
					add ax,word[mat_ps_j]
					mov word[mat_ps_pos],ax

				pop rbx

				mov eax, [mat_ps_pos]
				mov ax, word[ebx+2*eax]
				mov word[num], ax	

				call print_num
				

				inc dword[mat_ps_j]

				jmp ps_loop_j

			exit_ps_loop_j:

			inc dword[mat_ps_i]
			call add_new_line
			jmp ps_loop_i

		exit_ps_loop_i:

		pop rdx
		pop rcx
		pop rbx
		pop rax 

	ret


add_new_line:

	section .data

		msg_debugger_nl : db '',10
		msg_debugger_l_nl : equ $-msg_debugger_nl

	section .text

		push rax
		push rbx
		push rcx
		push rdx
		; debug----
				mov eax, 4
				mov ebx, 1
				mov ecx, msg_debugger_nl
				mov edx, msg_debugger_l_nl
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
		nwl_for_printnum :db ' '
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

