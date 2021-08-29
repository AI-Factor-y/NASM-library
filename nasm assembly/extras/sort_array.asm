section .data
	
	msg1 : db 'debug here --',10
	l1 : equ $-msg1

	msg2 : db 'the value of arr[j] : '
	l2 : equ $-msg2

	msg3 : db 'number of odd : '
	l3 : equ $-msg3

	msg4 : db 'enter number of elements : '
	l4: equ $-msg4

	msg5 : db 'enter the elements : ',10
	l5: equ $-msg5



	space:db ' '
	newline:db '',10


section .bss
	nod: resb 1
	num: resw 1

	counter: resw 1
	num1: resw 1
	num2: resw 1
	n: resd 10
	array: resw 50


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


	mov ebx,array
	
	call sort_array

	mov eax,4
	mov ebx,1
	mov ecx,newline
	mov edx,1
	int 80h

	
	mov ebx,array
	mov eax,0

	call print_array
	


	
	
	exit:
	mov eax,1
	mov ebx,0
	int 80h



; function to sort an array

sort_array:
		
	; usage
	;-------
	; 1: store the base address of array in ebx
	; 2: store the size of the array in n (word)

	section .bss
		counter_i: resw 1 
		dummy_idk : resw 1
		cur_num : resw 1

	section .text
  
		push rax  ; push all 
		push rbx
		push rcx

		mov eax,0

		mov dx,0
		mov word[counter_i],0  


		loop1:
			mov cx,word[ebx+2*eax]
			
			mov [counter_i],eax ; storing i, counter_i=i

			inc eax  ; i++


			push rax
			push rbx
			push rcx


			mov dx,0
			cmp eax,dword[n]
			jae skip_loop2  ; if i==n ie for the last element no need to excecute the second loop

			loop2:
				mov cx,word[ebx+2*eax]  ; extract arr[j] and cx=arr[j]
				
				
				push rax
				push rbx
				push rcx

					push rax
					mov eax, [counter_i]
					mov eax, [ebx+2*eax]
					mov [cur_num], eax    ; store curr_num = arr[i] where i is from counter_i
					pop rax

					cmp cx,word[cur_num] ; if arr[j]<arr[i] condition here
					jae no_change

					; swap									
					
						push rax 
							mov eax, [counter_i]   ; eax= counter_i and extract arr[i]
							mov word[ebx+2*eax],cx	; assign arr[i]=arr[j] where arr[j] is in cx
						pop rax


						push rcx

							mov cx,word[cur_num] ; put cx = arr[i]
							mov word[ebx+2*eax],cx	; arr[j]=arr[i] 
						pop rcx

					; swap complete

					no_change:
				
				pop rcx
				pop rbx
				pop rax
				
				inc eax

				cmp eax,dword[n]
				jb loop2

			skip_loop2:
				
			pop rcx
			pop rbx
			pop rax
			
			cmp eax,dword[n]
			jb loop1

			pop rcx
			pop rbx
			pop rax  ; pop all

	ret


	debugger:
		push rax
		push rbx
		push rcx
		; debug----
				mov eax, 4
				mov ebx, 1
				mov ecx, msg2
				mov edx, l2
				int 80h
				;debug ---

		pop rcx
		pop rbx
		pop rax

		push rax
			mov eax,[ebx+2*eax]
			mov [num],eax
			call print_num
		pop rax

		ret


	read_array:

		; usage
		;-------
		; 1: base address of array in ebx
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


	print_array:

		; usage
		;-------
		; 1: base address of array in ebx
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