section .data
	
	msg1 : db 'debug here --',10
	l1 : equ $-msg1

	msg2 : db 'enter your string 1 : '
	l2 : equ $-msg2

	msg3 : db 'enter your string 2 : '
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

	stom_string: resd 1000
	string: resd 1000

	
section .text
	global _start
	_start:

	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, l2
	int 80h


	mov ebx, stom_string
	call read_array_string


	mov ebx, string
	call string_to_matrix




	call del_duplicates


	exit:
	mov eax,1
	mov ebx,0
	int 80h




; section for procedures
;----------------------------


del_duplicates:
	
	;; usage
	;;------
	;; ebx register should have a string matrix.
	;; row_size, no_of_words required
	;; the no duplicate string will be printed in the console

	section .bss
		del_index: resd 1000
		del_i: resd 1
		del_j: resd 1
		del_pos_i: resd 1
		del_pos_j: resd 1
	section .text

		push rax 
		push rbx
		push rcx
		push rdx
				
			mov eax,0

			del_zero_loop:
				cmp eax,500
				je exit_zero_loop

				push rbx

					mov ebx, del_index
					mov word[ebx+2*eax],0

				pop rbx
				inc eax
			exit_zero_loop:


			mov dword[del_i],0	
			mov dword[del_j],0

			del_loop_1:
				mov eax, [del_i]
				cmp eax, dword[no_of_words]
				je exit_del_loop_1

				mov dword[del_j],eax

				inc dword[del_j]

				del_loop_2:
					mov eax,[del_j]
					cmp eax, dword[no_of_words]
					je exit_del_loop_2

					push rbx
						mov bx, word[row_size]
						mov dx,0
						mov ax, word[del_i]
						mul bx
						mov word[del_pos_i],ax

						mov dx,0
						mov ax, word[del_j]
						mul bx
						mov word[del_pos_j],ax

					pop rbx

					push rbx
					push rcx

						mov ecx, ebx
						add ebx, dword[del_pos_i]
						add ecx, dword[del_pos_j]

						call compare_strings

					pop rcx
					pop rbx

					mov ax,word[compare_flag]
					cmp ax,0
					jne continue_del_loop_2

					push rbx

						mov ebx, del_index
						mov eax, [del_j]

						mov word[ebx+2*eax],1

					pop rbx
					continue_del_loop_2:

					inc dword[del_j]

					jmp del_loop_2
				exit_del_loop_2:

				inc dword[del_i]

				jmp del_loop_1 
			exit_del_loop_1:



			mov dword[del_i],0

			del_loop_3:
				mov eax, [del_i]
				cmp eax, dword[no_of_words]
				je exit_del_loop_3

				push rbx

					mov ebx, del_index
					mov eax, [del_i]
					mov cx, word[ebx+2*eax]

				pop rbx

				cmp cx, 0
				jne continue_del_loop_3


				push rbx 

					mov bx, word[row_size]
					mov dx,0
					mov ax, word[del_i]
					mul bx
					mov word[del_pos_i],ax

				pop rbx

				push rbx 

					add ebx, dword[del_pos_i]
					call print_array_string
					call debugger_space_gen
				pop rbx

				continue_del_loop_3:

				inc dword[del_i]

				jmp del_loop_3


			exit_del_loop_3:


		pop rdx
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




string_to_matrix:
	
	;; converts a 1d string to a 2d string matrix seperated by words
	;; usage
	;;----------
	;; the 1 d string should be in stom_string variable 
	;; the output 2d string will be in the ebx register
	;; map the ebx register to a string variable before calling this function


	section .bss
		row_size: resd 1
		stom_i: resd 1
		stom_j: resd 1
		stom_pos: resd 1
		stom_temp: resb 1
		no_of_words: resd 1
		
		stom_x: resd 1

	section .text

		push rax 
		push rbx
		push rcx
		push rdx

		mov dword[row_size],50
		mov dword[stom_i],0
		mov dword[stom_j],0
		mov dword[stom_x],0
		mov dword[no_of_words],1
		
		rs_loop_i:
			mov dword[stom_j],0
			rs_loop_j:
				
				push rbx 
				push rcx
					;;-------------
					mov ebx, stom_string
					;;-------------
					mov eax, [stom_x]
					mov cl, byte[ebx+eax]

					mov byte[stom_temp], cl
					inc dword[stom_x]
				pop rcx
				pop rbx

				cmp byte[stom_temp], 0 ;; check if the input is ’Enter’
				je exit_rs_loop_i

				cmp byte[stom_temp],' '
				je exit_rs_loop_j

				
				push rbx
					mov ax,word[stom_i]
					mov bx,word[row_size]
					mul bx
					add ax,word[stom_j]
					mov word[stom_pos],ax
						
					; call debugger

				pop rbx

				mov cl,byte[stom_temp]
				mov eax, [stom_pos]
				mov byte[ebx+eax], cl
				
				inc dword[stom_j]

				jmp rs_loop_j

			exit_rs_loop_j:

			push rbx
					mov ax,word[stom_i]
					mov bx,word[row_size]
					mul bx
					add ax,word[stom_j]
					mov word[stom_pos],ax

			pop rbx
			mov eax, [stom_pos]
			mov byte[ebx+eax], 0

			inc dword[no_of_words]  ;; finds the total no of words
			inc dword[stom_i]

			jmp rs_loop_i

		exit_rs_loop_i:

		push rbx
			mov ax,word[stom_i]
			mov bx,word[row_size]
			mul bx
			add ax,word[stom_j]
			mov word[stom_pos],ax

		pop rbx
		mov eax, [stom_pos]
		mov byte[ebx+eax], 0

		pop rdx
		pop rcx
		pop rbx
		pop rax 

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



print_string_in_matrix:
		
	;; base address of string in ebx
	;; no_of_words is required
	;; row_size if required

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


