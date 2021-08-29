section .data
	
	msg1 : db 'debug here --',10
	l1 : equ $-msg1

	msg2 : db 'enter a number : '
	l2 : equ $-msg2

	msg3 : db 'number is : '
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
	
	string_rev_palin: resb 1000

section .text
	global _start
	_start:

	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, l2
	int 80h


	mov ebx, string_rev_palin

	call read_string_as_matrix

	call swap_palin_pos

	call print_string_in_matrix

	exit:
	mov eax,1
	mov ebx,0
	int 80h




; section for procedures
;----------------------------


swap_palin_pos:
	
	;; input string in string_rev_palin
	;; output string in string_rev_palin, ebx 

	section .bss

		sp_i: resd 1

		palin_arr: resb 1000
		palin_arr_i: resd 1
		string_len: resd 1

	section .text


		push rax 
		push rcx 
		push rdx 	

		mov ebx, string_rev_palin

		mov dword[sp_i],0
		mov dword[palin_arr_i],0

		sp_loop_1:

			mov ax, word[sp_i]
			cmp ax, word[no_of_words]
			je exit_sp_loop_1

			mov eax, [sp_i]
			call string_at_location

			push rbx

				mov ebx, str_at_loc
				call strlen 
				mov dword[string_len],ecx
				
				call check_palindrome

				cmp word[is_palin],1
				jne sp_not_palin

				mov ecx, palin_arr
				mov ebx, str_at_loc
				mov eax, [palin_arr_i]	
				call put_string_in_loc

				inc dword[palin_arr_i]

				sp_not_palin:

			pop rbx

			inc dword[sp_i]
			jmp sp_loop_1

		exit_sp_loop_1:

		mov dword[sp_i],0

		dec dword[palin_arr_i]



		sp_loop_2:

			mov ax, word[sp_i]
			cmp ax, word[no_of_words]
			je exit_sp_loop_2

			mov eax, [sp_i]
			call string_at_location
			
			push rbx

				mov ebx, str_at_loc
				call strlen 
				mov dword[string_len],ecx
				
				call check_palindrome


				cmp word[is_palin],1
				jne sp_not_palin2

			
				mov ebx, palin_arr

				mov eax, [palin_arr_i]
				call string_at_location

				mov ebx, str_at_loc
				mov eax, [sp_i]
				mov ecx, string_rev_palin  
				call put_string_in_loc

				dec dword[palin_arr_i]

				sp_not_palin2:

			pop rbx

				inc dword[sp_i]


				jmp sp_loop_2

		exit_sp_loop_2:



		pop rdx 
		pop rcx 
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


strlen:
	;; base address in ebx 
	;; strlen value will be in ecx 

	section .bss
		strlen_i: resd 1

	section .text

		push rax 
		push rbx  
		push rdx 


			mov eax,0	

			strlen_loop:
				mov cl, byte[ebx+eax]
				cmp cl,0
				je exit_strlen_loop

				inc eax 

				jmp strlen_loop 
			exit_strlen_loop:

			mov ecx, eax

		pop rdx 
		pop rbx 
		pop rax 

	ret



check_palindrome:
	
	; base address should be in ebx
	; length in strlen 	
	; if it is palin then is_palin is 1 else 0
	section .data
		palin_msg : db 'string is a palindrome ',10
		palin_msg_len : equ $-palin_msg

		not_palin_msg : db 'string is not a palindrome ',10
		not_palin_msg_len : equ $-not_palin_msg

	section .bss
		mid_val : resd 1
		counter_palin_i: resq 1
		counter_palin_j: resq 1

		character_one: resb 1
		character_two: resb 1
		palin_flag: resd 1
		palin_string: resb 50

		is_palin: resd 1
	section .text

	push rax
	push rbx
	push rcx


		mov dword[palin_string],ebx ; store the string in ebx to a seperate area

		mov ax, word[string_len]
		mov cx, 2
		mov dx,0
		div cx
		mov word[mid_val],ax  ; mid val=n/2

		mov dword[counter_palin_i],0
		mov eax,[string_len]  

		dec eax

		mov [counter_palin_j], eax  ; initialising pointers

		mov word[palin_flag], 1

		loop_palin:
			; call debugger

			mov ax,word[counter_palin_i]  ; if i>=n/2 then break
			mov cx,word[mid_val]
			cmp ax,cx
			jae exit_loop_palin


			mov eax,[counter_palin_i]

			mov cl, byte[ebx+eax]
			

			mov byte[character_one], cl  ; char_1 = str[i]

			mov eax, [counter_palin_j]
			mov cl , byte[ebx+eax]
			mov byte[character_two], cl  ; char_2= str[j]
		
			mov al, byte[character_one]	

			cmp al,cl                     ; if char_1!=char_2 then break
			je equal_characters

				mov word[palin_flag],0
				jmp exit_loop_palin

			equal_characters:

				inc word[counter_palin_i]
				dec word[counter_palin_j]

				jmp loop_palin


		
		exit_loop_palin:

		mov ax,word[palin_flag] 
		cmp ax,1
		jne is_not_palin
			; mov eax, 4
			; mov ebx, 1
			; mov ecx, palin_msg
			; mov edx, palin_msg_len
			; int 80h

			mov dword[is_palin],1

			jmp cont_palin_fun

		is_not_palin:
			; mov eax, 4
			; mov ebx, 1
			; mov ecx, not_palin_msg
			; mov edx, not_palin_msg_len
			; int 80h
			mov dword[is_palin],0

		cont_palin_fun:


	pop rcx
	pop rbx
	pop rax


	ret





put_string_in_loc:
	;; i in eax ( loc of string in 2d matrix)
	;; base address of matric in ecx
	;; base address of string to be put in matrix  is : ebx
	;; string to put in ebx be in ecx reg 

	section .text

		push rax 
		push rbx 
		push rdx 

			push rcx 

				mov cx, word[row_size]
				mul cx

			pop rcx	

			add ecx,eax
			call strcpy

		pop rdx 
		pop rbx 
		pop rax 

	ret





string_at_location:
	
	;; i in eax ( loc of string in 2d matrix)
	;; string will be in str_at_loc variable 
	;; use strcpy to copy string from str_at_loc variable 

	section .bss

		str_at_loc: resb 100

	section .text

		push rax 
		push rbx 
		push rcx
		push rdx 

			push rbx 

				mov bx, word[row_size]
				mul bx

			pop rbx	

			add ebx,eax
			mov ecx,str_at_loc
			call strcpy

		pop rdx 
		pop rcx
		pop rbx 
		pop rax 

	ret


strcpy:
		
	;; copies contents of string ebx to string ecx
	;; strcpy(ecx,ebx)
	;; string 1 is ebx string 2 is ecx 
	;; ecx string changes and becomes same as ebx
	
	section .text

		push rax 
		push rbx
		push rdx

			strcpy_loop_1:
				mov dl,byte[ebx]
				mov byte[ecx],dl

				cmp dl,0
				je exit_strcpy_loop_1

				inc ebx
				inc ecx

				jmp strcpy_loop_1

			exit_strcpy_loop_1:

		pop rdx
		pop rcx
		pop rax

	ret 






read_string_as_matrix:
		
	;; base address in ebx

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
		
	;; base address of string in ebx

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
			call debugger_space_gen
			jmp ps_loop_i

		exit_ps_loop_i:

		pop rdx
		pop rcx
		pop rbx
		pop rax 

	ret




debugger_space_gen:

	section .data

		msg_debugger_space_gen : db ' ',
		msg_debugger_l_space_gen : equ $-msg_debugger_space_gen

	section .text

		push rax
		push rbx
		push rcx
		push rdx
		; debug----
				mov eax, 4
				mov ebx, 1
				mov ecx, msg_debugger_space_gen
				mov edx, msg_debugger_l_space_gen
				int 80h
				;debug ---

		pop rdx
		pop rcx	
		pop rbx
		pop rax

		; action

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


