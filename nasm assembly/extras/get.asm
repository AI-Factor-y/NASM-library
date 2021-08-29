

section .data
	
	msg1 : db 'debug here --',10
	l1 : equ $-msg1

	msg2 : db 'Enter your matrix : ',10
	l2 : equ $-msg2

	msg3 : db 'your matrix is : ',10
	l3 : equ $-msg3

	msg4 : db 'elem at [2,1] is : '
	l4: equ $-msg4

	msg5 : db 'msg 5 here',10
	l5: equ $-msg5


	space:db ' '
	newline:db '',10


section .bss

	num: resd 1

	counter: resd 1
	
	n: resd 10
	
	string_matrix: resd 1000

	row_size: resd 1
	col_size: resd 1
	
section .text
	global _start
	_start:

	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, l2
	int 80h	

	mov dword[row_size],2
	mov dword[col_size],3

	mov ebx, string_matrix
	call read_matrix

	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, l3
	int 80h	

	mov ebx, string_matrix
	call print_matrix
	
	mov eax, 4
	mov ebx, 1
	mov ecx, msg4
	mov edx, l4
	int 80h	
	
	mov eax,2
	mov ebx,string_matrix
	mov ecx,1
	mov dx,11
	call put_elem
	


	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, l3
	int 80h	

	mov ebx, string_matrix
	call print_matrix

	mov eax, 4
	mov ebx, 1
	mov ecx, newline
	mov edx, 1
	int 80h

	exit:
	mov eax,1
	mov ebx,0
	int 80h












;; procedures
;-------------

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
		
		rs_i: resd 1
		rs_j: resd 1
		rs_pos: resd 1
		rs_temp: resd 1
		
	section .text

		push rax 
		push rbx
		push rcx
		push rdx

		mov dword[rs_i],0
		mov dword[rs_j],0
		
		
		rs_loop_i:

			mov ax, word[col_size]
			cmp word[rs_i], ax
			je exit_rs_loop_i 

			mov dword[rs_j],0

			rs_loop_j:

				mov ax, word[row_size]

				cmp word[rs_j], ax ;; check if the input is ’Enter’
				je exit_rs_loop_j


				call read_num
				mov eax, [num]
				mov [rs_temp], eax

		
				push rbx
					mov ax,word[rs_i]
					mov bx,word[row_size]
					mul bx
					add ax,word[rs_j]
					mov word[rs_pos],ax
						
					; call debugger

				pop rbx

				mov cx,word[rs_temp]
				mov eax, [rs_pos]
				mov word[ebx+2*eax], cx
				
				inc dword[rs_j]

				jmp rs_loop_j

			exit_rs_loop_j:

			
			inc dword[rs_i]

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
		
		ps_i: resd 1
		ps_j: resd 1
		ps_pos: resd 1
		ps_temp: resd 1
	section .text

		push rax 
		push rbx
		push rcx
		push rdx

		mov dword[ps_i],0
		mov dword[ps_j],0
		
		ps_loop_i:

			mov ax, word[ps_i]

			cmp ax, word[col_size]
			je exit_ps_loop_i

			mov dword[ps_j],0
			ps_loop_j:
					
				mov ax, word[row_size]
				cmp ax, word[ps_j]
				je exit_ps_loop_j 

				push rbx

					mov ax, word[ps_i]
					mov bx, word[row_size]
					mul bx
					add ax,word[ps_j]
					mov word[ps_pos],ax

				pop rbx

				mov eax, [ps_pos]
				mov ax, word[ebx+2*eax]
				mov word[num], ax	

				call print_num
				

				inc dword[ps_j]

				jmp ps_loop_j

			exit_ps_loop_j:

			inc dword[ps_i]
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
