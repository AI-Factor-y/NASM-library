section .data
	
	msg1 : db 'debug here --',10
	l1 : equ $-msg1

	msg2 : db 'Enter your string : '
	l2 : equ $-msg2

	msg3 : db 'length of longest : '
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
	string : resb 100

	
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

	mov ebx, string 
	call long_rep_sseq


	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, l3
	int 80h

	mov cx,word[long_rep_len]
	mov word[num],cx

	call print_num

	exit:
	mov eax,1
	mov ebx,0
	int 80h




; section for procedures
;----------------------------

long_rep_sseq:
	
	;; longest repeating subsequence
	;; string base address in ebx
	;; result in long_rep_len 
	;; string length in string_len

	section .bss

		dp: resd 10000

		row_size: resd 1
		col_size: resd 1

		sseq_i: resd 1
		sseq_j: resd 1

		long_rep_len: resd 1

	section .text

		push rax 
		push rbx 
		push rcx
		push rdx 

			mov eax, [string_len]
			inc eax
			mov [row_size], eax
			mov [col_size], eax

			push rbx

				mov ebx, dp 
				call set_mat_to_zero

			pop rbx

			mov dword[sseq_i],1
			


			sseq_loop_1:
				mov ax, word[sseq_i]
				cmp ax, word[string_len]
				ja exit_sseq_loop_1

				mov dword[sseq_j],1
				sseq_loop_2:

					
					; push rbx
					; 	mov ebx, dp 
					; 	call print_matrix

					; pop rbx
	
					mov ax, word[sseq_j]
					cmp ax, word[string_len]
					ja exit_sseq_loop_2


					mov eax, [sseq_i]
					dec eax
					mov cl, byte[ebx+eax]

					mov eax, [sseq_j]
					dec eax
					mov dl, byte[ebx+eax]
					cmp cl, dl
					jne sseq_else

					mov eax, [sseq_i]
					mov ecx, [sseq_j]
					cmp eax, ecx 
					je sseq_else


					; if case
					
					push rbx
						mov ebx, dp

						mov eax, [sseq_i]
						dec eax 
						mov ecx, [sseq_j]
						dec ecx

						call get_elem

						mov word[num],cx

						inc cx
						mov dx,cx
						mov eax, [sseq_i]
						mov ecx, [sseq_j]
						
						call put_elem

					pop rbx

					jmp exit_sseq_if_else

					sseq_else:  ; else case
						
					push rbx
						mov ebx, dp 
						mov eax, [sseq_i]
						mov ecx, [sseq_j]
						dec ecx

						call get_elem
						mov word[find_max_1],cx 

						
						mov eax, [sseq_i]
						dec eax
						mov ecx, [sseq_j]

						call get_elem
						mov word[find_max_2],cx 

						call find_max

						mov dx , word[find_max_max]
						mov eax, [sseq_i]
						mov ecx, [sseq_j]
						call put_elem


					pop rbx

					exit_sseq_if_else:

					inc dword[sseq_j]

					jmp sseq_loop_2

				exit_sseq_loop_2:



				inc dword[sseq_i]
				jmp sseq_loop_1

			exit_sseq_loop_1:

			push rbx
				mov ebx, dp
				mov eax, [string_len]
				mov ecx, [string_len]
				call get_elem

				mov word[long_rep_len], cx

 			pop rbx
		pop rdx
		pop rcx
		pop rbx
		pop rax

	ret






debugger:

	section .data

		msg_debugger : db 'debug here if--',10
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

		msg_debugger2 : db 'debug here else--',10
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



find_max:
		
	;; value 1 in find_max_1 
	;; value 2 in find_max_2
	;; maximum of the two in find_max_max

	section .bss
		find_max_1: resd 1
		find_max_2: resd 1
		find_max_max: resd 1

	section .text

		push rax
		push rbx
		push rcx
		push rdx

			mov ax, word[find_max_1]
			mov cx, word[find_max_2]

			cmp ax, cx
			jb find_max_else_case

				mov word[find_max_max], ax
				jmp exit_find_max_if
			find_max_else_case:

				mov word[find_max_max], cx

			exit_find_max_if:

		pop rdx
		pop rcx
		pop rbx
		pop rax


	ret




find_min:
		
	;; value 1 in find_min_1 
	;; value 2 in find_min_2
	;; minimum of the two in find_min_min

	section .bss
		find_min_1: resd 1
		find_min_2: resd 1
		find_min_min: resd 1

	section .text

		push rax
		push rbx
		push rcx
		push rdx

			mov ax, word[find_min_1]
			mov cx, word[find_min_2]

			cmp ax, cx
			jb find_min_else_case

				mov word[find_min_min], cx
				jmp exit_find_min_if
			find_min_else_case:

				mov word[find_min_min], ax

			exit_find_min_if:
			
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



;------------------

set_mat_to_zero:
		
	;; array address in ebx 
	; row and col size in row_size, col_size

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

;---------------------------


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

