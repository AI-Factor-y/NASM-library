section .data
	
	msg1 : db 'debug here --',10
	l1 : equ $-msg1

	msg2 : db 'enter your sting : '
	l2 : equ $-msg2

	msg3 : db 'the reversed string is : '
	l3 : equ $-msg3

	msg4 : db '',10
	l4: equ $-msg4

	msg5 : db 'msg 5 here',10
	l5: equ $-msg5


	space:db ' '
	newline:db '',10


section .bss

	num: resd 1

	counter: resd 1
	
	n: resd 10
	string: resb 1000
	
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

	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, l3
	int 80h

	call reverse_string

	mov eax, 4
	mov ebx, 1
	mov ecx, msg4
	mov edx, l4
	int 80h



	exit:
	mov eax,1
	mov ebx,0
	int 80h




; section for procedures
;----------------------------


reverse_string:
	
	section .bss

		str_i: resd 1

		char_str: resb 1000
		char_str_i: resd 1
	section .text
		push rax 
		push rbx 
		push rcx 
		push rdx 

			mov dword[str_i],0
			mov dword[char_str_i],0

			mov ebx , string;

			reverse_loop1:
				mov ax, word[str_i]
				cmp ax,word[string_len]
				je exit_reverse_loop1

				mov eax,[str_i]	

				mov cl, byte[ebx+eax]

				call check_not_speacial

				cmp word[not_sp_flag],0
				je continue_loop1

				mov eax,[str_i]
				mov cl,byte[ebx+eax]

				push rbx

					mov ebx, char_str
					mov eax, [char_str_i]
					mov byte[ebx+eax],cl
					inc dword[char_str_i]

				pop rbx


				continue_loop1:

				inc dword[str_i]

				jmp reverse_loop1

			exit_reverse_loop1:


			mov dword[str_i],0
			dec dword[char_str_i]

			reverse_loop2:
				mov ax, word[str_i]
				cmp ax,word[string_len]
				je exit_reverse_loop2
				mov ebx, string
				mov eax,[str_i]	

				mov cl, byte[ebx+eax]

				call check_not_speacial

				cmp word[not_sp_flag],0
				je continue_loop2

					push rbx

						mov ebx,char_str
						mov eax,[char_str_i]

						mov cl,byte[ebx+eax]

					pop rbx
					mov eax,[str_i]
					mov ebx,string
					mov byte[ebx+eax],cl

					dec dword[char_str_i]

				continue_loop2:	
					inc dword[str_i]

					jmp reverse_loop2
			exit_reverse_loop2:


			mov ebx, string 
			call print_array_string


		pop rdx 
		pop rcx 
		pop rbx 
		pop rax


	ret


check_not_speacial:
	;; char in cl
	section .bss
		not_sp_flag: resd 1
		cap_alpha: resd 1
		small_alpha: resd 1
		is_num: resd 1
	section .text
		push rax 
		push rbx 
		push rcx 
		push rdx 


		mov dword[not_sp_flag],0
		mov dword[cap_alpha],0	
		mov dword[small_alpha],0
		mov dword[is_num],0

		cmp cl,'A'
		jb isnot_cap_A

		cmp cl ,'Z'
		ja isnot_cap_A
			
		mov dword[cap_alpha],1

		isnot_cap_A:

		cmp cl,'0'
		jb isnot_num

		cmp cl ,'9'
		ja isnot_num
			
		mov dword[is_num],1

		isnot_num:

		cmp cl,'a'
		jb isnot_small

		cmp cl ,'z'
		ja isnot_small
			
		mov dword[small_alpha],1

		isnot_small:

		mov dl,0

		cmp dword[cap_alpha],1
		sete al

		or dl, al

		cmp dword[small_alpha],1
		sete al

		or dl, al

		cmp dword[is_num],1
		sete al

		or dl, al

		mov byte[not_sp_flag],dl

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
		cmp byte[temp_read_str], 10 ;; check if the input is ???Enter???
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
	;;The number to be printed is copied to ???num???
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

		;;read num stores the input in ???num???
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
		;;The memory location ???newline??? should be declared with the ASCII key for new popa
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


