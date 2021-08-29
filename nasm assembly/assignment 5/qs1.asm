section .data
	
	msg1 : db 'debug here --',10
	l1 : equ $-msg1

	msg2 : db 'Enter your string  : '
	l2 : equ $-msg2

	msg3 : db 'Reversed string is : '
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
	string: resb 500
	
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

	call reverse_sentence ; funtion to reverse a sentence

	call debugger  ; add new line

	mov eax, 4
	mov ebx, 1
	mov ecx, msg3
	mov edx, l3
	int 80h
		
	mov ebx, reversed_sentence_val
	call print_array_string


	call debugger ; add new line
	call debugger  ; add new line

	exit:
	mov eax,1
	mov ebx,0
	int 80h




; section for procedures
;----------------------------


reverse_sentence:

	;; usage
	;--------
	;; 1: the input string should be in ebx , length of the string in string_len
	;; 2: reversed sentence string in "reversed_sentence_val"
	;; 3: length of the reversed sentence in "reversed_sent_count"
	;; 4: subprocedures used are "reverse_string_modified_for_sent"

	section .bss

		sent_word : resb 200
		rev_s_counter: resd 1
		temp_rev_sent: resb 1
		sent_word_counter: resd 1

		reversed_sentence_val: resb 500
		reversed_sent_count: resd 1
	section .text

		push rax
		push rbx
		push rcx
		push rdx


		mov ax, word[string_len]

		mov word[rev_s_counter],ax	  ; rev_s_counter=len(str)

		mov dword[sent_word_counter],0
		mov dword[reversed_sent_count],0

		reverse_sent_loop:

			mov ax,word[rev_s_counter]  ; if rev_s_counter==0 exit
			cmp ax,0
			je exit_reverse_sent_loop

			; call debugger

			mov eax,[rev_s_counter]
			dec eax
			mov cl, byte[ebx+eax]

			mov byte[temp_rev_sent],cl ; extract the character 

			dec dword[rev_s_counter]


 
			cmp cl,' '    ; if the characted is a space then reverse the stored word and add it 
			jne add_to_word  ; to the reversed sentence

				push rbx
				push rax
					mov ebx, sent_word
					mov eax, [sent_word_counter]

					mov byte[ebx+eax],0

					mov [string_len],eax ; string_len=len(word)

					call reverse_string_modified_for_sent  ; reverse the word and add to sentence
				
					mov dword[sent_word_counter],0 ; reset the word_counter and clear the word

				pop rax
				pop rbx

				jmp continue_reverse

			add_to_word:
				push rbx  ; if character is not ' ' add it to the word
				push rax
					mov ebx, sent_word
					mov eax, [sent_word_counter]

					mov byte[ebx+eax],cl

					inc dword[sent_word_counter]

				pop rax
				pop rbx

			continue_reverse:

			
			jmp reverse_sent_loop

		exit_reverse_sent_loop:

		push rbx
		push rax
			mov ebx, sent_word
			mov eax, [sent_word_counter]

			mov byte[ebx+eax],0  ; take the first word in the string
								 ; this word is not captured in the loop 
			mov [string_len],eax

			call reverse_string_modified_for_sent
	
			mov dword[sent_word_counter],0

		pop rax
		pop rbx


		push rbx

			mov ebx,reversed_sentence_val
			mov eax, [reversed_sent_count] ; rev_string[j]=reg(cl)
			dec eax
			mov byte[ebx+eax], 0  ; add the 0 to the end of reversed sentance

		pop rbx




		pop rdx
		pop rcx
		pop rbx
		pop rax


	ret




reverse_string_modified_for_sent:
		
	;; usage
	;-------
	; base address should be in ebx, length in "string_len"
	; the reversed string is added to another string variable "reversed_sent_count"
	

	section .bss
			
	
		counter_i : resd 1


	section .text

	push rax
	push rbx
	push rcx

		mov eax,[string_len]
		mov [counter_i],eax ;i=n
		

		rev_loop:

			mov ax,word[counter_i]  ; if i<1 : break
			cmp ax,1
			jb exit_rev_loop

			mov eax, [counter_i] 
			dec eax 
			mov cl,byte[ebx+eax]  ; reg(cl) = string[i-1]
			inc eax
			mov [counter_i],eax

			push rbx
				mov ebx,reversed_sentence_val
				mov eax, [reversed_sent_count] ; rev_string[j]=reg(cl)
				mov byte[ebx+eax], cl

			pop rbx

			inc dword[reversed_sent_count] ;j++
			dec dword[counter_i]  ;i--


			jmp rev_loop
			
		exit_rev_loop:
		; call debugger
		mov ebx,reversed_sentence_val
		mov eax, [reversed_sent_count] ; rev_string[j]=reg(cl)
		mov byte[ebx+eax], ' '
		
		inc dword[reversed_sent_count] ;j++

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


