section .data
	
	msg1 : db 'debug here --',10
	l1 : equ $-msg1

	msg2 : db 'enter the element to search for :'
	l2 : equ $-msg2



	msg4 : db 'enter number of elements : '
	l4: equ $-msg4

	msg5 : db 'enter the elements : ',10
	l5: equ $-msg5

	msg6 : db 'element found at position : '
	l6: equ $-msg6

	msg7: db 'element not found in array :(',10
	l7 : equ $-msg7

	space:db ' '
	newline:db '',10

	nwl :db ' ',10
	nwl_l : equ $-nwl
section .bss
	nod: resb 1
	num: resw 1
	temp: resb 1
	counter: resw 1
	num1: resw 1
	num2: resw 1
	n: resd 10
	array: resw 50
	matrix: resw 1
	elem : resw 1
	pos: resw 1
	count: resb 10

	found_flag : resb 1
	pos_counter : resb 10
section .text
	global _start
	_start:

	mov eax, 4
	mov ebx, 1
	mov ecx, msg4
	mov edx, l4
	int 80h

	call read_num

	mov eax, 4
	mov ebx, 1
	mov ecx, msg5
	mov edx, l5
	int 80h

	mov cx,word[num]
	mov word[n],cx
	mov ebx,array
	mov eax,0

	
	call read_array

	; ; debug----
	; 		mov eax, 4
	; 		mov ebx, 1
	; 		mov ecx, msg1
	; 		mov edx, l1
	; 		int 80h
	; 		;debug ---
	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, l2
	int 80h

	call read_num
	mov cx,word[num]
	mov word[elem],cx

	mov eax, 4
	mov ebx, 1
	mov ecx, msg6
	mov edx, l6
	int 80h

	mov ebx,array
	mov eax,0

	mov dx,0

	mov byte[found_flag],0

	mov word[pos_counter],1
	loop1:
		mov cx,word[ebx+2*eax]
		
		inc eax

		; mov ax,cx
		push rax
		push rbx
		
		mov ax, word[elem];
		cmp cx ,ax;
		je is_found
			
			jmp exit_div_cond

		is_found:
			mov ax,word[pos_counter]
			mov word[pos],ax
			mov byte[found_flag],1
	
		exit_div_cond:

		pop rbx
		pop rax
			
		add word[pos_counter],1

		cmp eax,dword[n]
		jb loop1


	cmp byte[found_flag],0
	je elem_not_found

	mov ax,word[pos];
	mov word[num],ax;

	call print_num

	jmp elem_found;

	elem_not_found:

	mov eax, 4
	mov ebx, 1
	mov ecx, msg7
	mov edx, l7
	int 80h

	elem_found:

	mov eax,4
	mov ebx,1
	mov ecx,newline
	mov edx,1
	int 80h
		
	
	exit:
	mov eax,1
	mov ebx,0
	int 80h


	read_array:
		; pusha
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
		; popa
		ret


	print_array:
		; pusha
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
		ret



read_num:
	;;push all the used registers into the stack using pusha
	;call push_reg
	;;store an initial value 0 to variable ’num’
	mov word[num], 0
	loop_read:
	;; read a digit
	mov eax, 3
	mov ebx, 0
	mov ecx, temp
	mov edx, 1
	int 80h
	;;check if the read digit is the end of number, i.e, the enter-key whose ASCII cmp byte[temp], 10

	cmp byte[temp], 10
	je end_read

	mov ax, word[num]
	mov bx, 10
	mul bx
	mov bl, byte[temp]
	sub bl, 30h
	mov bh, 0
	add ax, bx
	mov word[num], ax
	jmp loop_read
	end_read:
	;;pop all the used registers from the stack using popa
	;call pop_reg
	ret



print_num:
	mov byte[count],0
	;call push_reg
	extract_no:
		cmp word[num], 0
		je print_no
		inc byte[count]
		mov dx, 0
		mov ax, word[num]
		mov bx, 10
		div bx
		push dx ; recursion here
		mov word[num], ax
		jmp extract_no
	print_no:
	cmp byte[count], 0
	je end_print
	dec byte[count]
	pop dx
	mov byte[temp], dl  ; dx is further divided into dh and dl
	add byte[temp], 30h
	mov eax, 4
	mov ebx, 1
	mov ecx, temp
	mov edx, 1
	int 80h
	jmp print_no
	end_print:
	mov eax,4
	mov ebx,1
	mov ecx,nwl
	mov edx,nwl_l
	int 80h
	;;The memory location ’newline’ should be declared with the ASCII key for new popa
	;call pop_reg
	ret