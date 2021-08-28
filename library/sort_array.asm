; function to sort an array

sort_array:
		
	; usage
	;-------
	; 1: store the base address of array in ebx
	; 2: store the size of the array in n (word)

	section .bss
		counter_i: resw 1 
		dummy_idk : resw 1
		cur_num_sortarray : resw 1

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
					mov [cur_num_sortarray], eax    ; store curr_num = arr[i] where i is from counter_i
					pop rax

					cmp cx,word[cur_num_sortarray] ; if arr[j]<arr[i] condition here
					jae no_change

					; swap									
					
						push rax 
							mov eax, [counter_i]   ; eax= counter_i and extract arr[i]
							mov word[ebx+2*eax],cx	; assign arr[i]=arr[j] where arr[j] is in cx
						pop rax


						push rcx

							mov cx,word[cur_num_sortarray] ; put cx = arr[i]
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
