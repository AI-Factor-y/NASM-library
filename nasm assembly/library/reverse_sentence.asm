
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

