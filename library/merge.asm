


merge_array:
	
	;;merge two array
	;-------------------
	; 1: array1 to be stored in variable array1, and its size in n1
	; 2: array2 to be stored in variable array2, and its size in n2
	; 3: merged array stored in variable merged, and its size in merge_count

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
			mov word[counterSecond],0
			mov word[merge_count],0

			mov eax,0


			loop1:
			

				mov eax,[counterFirst]
				cmp eax,dword[n1]
				setb cl
				mov byte[cond1], cl

				mov eax,[counterSecond]
				cmp eax, dword[n2]
				setb cl
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
				
				
				

				mov ebx, array2
				mov eax, [counterSecond] ;; taking  num2 = array2[j]
				mov cx,word[ebx+2*eax]
				mov word[num2],cx

				

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
								

						inc word[counterSecond]

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
				cmp eax,dword[n2]
				jae exit_loop3


				mov ebx, array2  ;; taking num2 = array2[i]
				mov eax, [counterSecond]
				mov cx,word[ebx+2*eax]
				mov word[num2],cx
				mov cx,word[num2]


				; putting residue values to merge array
				mov ebx,merged
				mov eax,[merge_count]
				mov word[ebx+2*eax],cx
				inc word[merge_count]
				inc word[counterSecond]


				jmp loop3

			exit_loop3:


		pop rcx
		pop rbx
		pop rax

		ret

