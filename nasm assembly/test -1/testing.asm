section .data
	
	msg1 : db 'debug here --',10
	l1 : equ $-msg1

	msg2 : db 'enter the size of array 1 (n1): '
	l2 : equ $-msg2

	msg3 : db 'enter the sorted array 1 (ascending) : ',10
	l3 : equ $-msg3

	msg4 : db 'enter the size of array 2 (n2): '
	l4: equ $-msg4

	msg5 : db 'enter the sorted array 2 (decending) : ',10
	l5: equ $-msg5

	msg6 : db 'the merged array is (ascending) =>',10
	l6: equ $-msg6


	space:db ' '
	newline:db '',10


section .bss

	num: resd 1

	counter: resd 1
	
	n: resd 10
	array: resd 50

	n1: resd 10
	n2: resd 10

	array1: resd 50

	array2: resd 50

	merged: resd 100
	
	merge_count: resd 1

	
	
section .text
	global _start
	_start:

	mov eax, 4
	mov ebx, 1
	mov ecx, msg2
	mov edx, l2
	int 80h


	call read_num

	mov ax,word[num]
	mov [n1],ax

	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, l3
	int 80h

	mov ebx, array1
	mov ax,word[n1]
	mov [n],ax

	call read_array

	mov eax, 4
	mov ebx, 1
	mov ecx, msg4
	mov edx, l4
	int 80h

	call read_num

	mov ax,word[num]
	mov [n2],ax


	mov eax, 4
	mov ebx, 1
	mov ecx, msg5
	mov edx, l5
	int 80h

	mov ebx, array2
	mov ax,word[n2]
	mov [n],ax

	call read_array


	call merge_array
	
	;; array have been merged .. now print the array
	mov eax, 4
	mov ebx, 1
	mov ecx, msg6
	mov edx, l6
	int 80h


	mov ebx,merged
	mov eax,[merge_count]
	mov [n],eax
	mov eax , 0
	call print_array

	exit:
	mov eax,1
	mov ebx,0
	int 80h




; section for procedures
;----------------------------




merge_array:
	


	section .bss

		cond1: resb 1
		cond2: resb 1

		num1: resd 1
		num2: resd 1

		counterFirst: resd 1
	
		counterSecond: resd 1

	section .text
		push rax
		push rbx
		push rcx

			mov ebx, array1
			mov eax,0

			mov word[counterFirst],0
			mov ax, word[n2]
			mov word[counterSecond],ax
			mov word[merge_count],0

			mov eax,0


			loop1:
			

				mov eax,[counterFirst]
				cmp eax,dword[n1]
				setb cl
				mov byte[cond1], cl

				mov eax,[counterSecond]
				cmp eax, 1
				setae cl
				mov byte[cond2], cl

				mov bl, [cond1]
				mov cl,[cond2]
				and bl,cl

				cmp bl,1
				jne exit_loop1

				
				; call debugger

				mov ebx, array1  ;; taking num1 = array1[i]
				mov eax, [counterFirst]

				mov cx,word[ebx+2*eax]

				mov word[num1],cx
				
				
				
				dec word[counterSecond]
				
				mov ebx, array2
				
				mov eax, [counterSecond] ;; taking  num2 = array2[j]
				mov cx,word[ebx+2*eax]
				mov word[num2],cx

				inc word[counterSecond]
				

				; mov bx,word[num1]
				; mov word[num], bx
				; call print_num

				; mov word[num], cx
				; call print_num
				

					cmp word[num1],cx
					jbe selec_num1

				
								mov cx,word[num2]
								mov ebx,merged
								mov eax,[merge_count]
								; call debugger
								mov word[ebx+2*eax],cx

								inc word[merge_count]
								

						dec word[counterSecond]

						jmp exit_check_cond
					selec_num1:	
						
					
								mov cx,word[num1]

								mov ebx,merged
								
								mov eax,[merge_count]
								
								; call debugger2
								mov word[ebx+2*eax],cx
								
							
								inc word[merge_count]
								
						
						inc word[counterFirst]

				exit_check_cond:
				

				jmp loop1


			exit_loop1:

			loop2:

				mov eax,[counterFirst]
				cmp eax,dword[n1]
				jae exit_loop2


				mov ebx, array1  ;; taking num1 = array1[i]
				mov eax, [counterFirst]
				mov cx,word[ebx+2*eax]
				mov word[num1],cx
				mov cx,word[num1]


				; putting residue values to merge array
				mov ebx,merged
				mov eax,[merge_count]
				mov word[ebx+2*eax],cx
				inc word[merge_count]
				inc word[counterFirst]


				jmp loop2

			exit_loop2:



			loop3:

				mov eax,[counterSecond]
				cmp eax,1
				jb exit_loop3

				dec word[counterSecond]

				mov ebx, array2  ;; taking num2 = array2[i]
				mov eax, [counterSecond]
				mov cx,word[ebx+2*eax]
				mov word[num2],cx
				mov cx,word[num2]

				inc word[counterSecond]

				; putting residue values to merge array
				mov ebx,merged
				mov eax,[merge_count]
				mov word[ebx+2*eax],cx
				inc word[merge_count]
				dec word[counterSecond]


				jmp loop3

			exit_loop3:


		pop rcx
		pop rbx
		pop rax

		ret






debugger2:

	section .data

		msg_debugger2 : db 'execution stops here',10
		msg_debugger_l2 : equ $-msg_debugger2

	section .text

		push rax
		push rbx
		push rcx
		; debug----
				mov eax, 4
				mov ebx, 1
				mov ecx, msg_debugger2
				mov edx, msg_debugger_l2
				int 80h
				;debug ---

		pop rcx
		pop rbx
		pop rax

		; action

	ret



debugger:

	section .data

		msg_debugger : db 'debug here --',10
		msg_debugger_l : equ $-msg_debugger

	section .text

		push rax
		push rbx
		push rcx
		; debug----
				mov eax, 4
				mov ebx, 1
				mov ecx, msg_debugger
				mov edx, msg_debugger_l
				int 80h
				;debug ---

		pop rcx
		pop rbx
		pop rax

		; action

	ret


print_array:

	; usage
	;-------
	; 1: base address of array in ebx  mov ebx,array
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


