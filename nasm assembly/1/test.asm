%assign SYS_EXIT        1
%assign SYS_WRITE       4
%assign STDOUT          1
        
global  _printDec
global  _printString
global  _println
global  _getInput


_printDec:
;;; saves all the registers so that they are not changed by the function

                section         .bss
.decstr         resb            10
.ct1            resd            1  ; to keep track of the size of the string

                section .text
                ; pushad                          ; save all registers

                mov             dword[.ct1],0   ; assume initially 0
                mov             edi,.decstr     ; edi points to decstring
                add             edi,9           ; moved to the last element of string
                xor             edx,edx         ; clear edx for 64-bit division
.whileNotZero:
                mov             ebx,10          ; get ready to divide by 10
                div             ebx             ; divide by 10
                add             edx,'0'         ; converts to ascii char
                mov             byte[edi],dl    ; put it in sring
                dec             edi             ; mov to next char in string
                inc             dword[.ct1]     ; increment char counter
                xor             edx,edx         ; clear edx
                cmp             eax,0           ; is remainder of division 0?
                jne             .whileNotZero   ; no, keep on looping

                inc             edi             ; conversion, finish, bring edi
                mov             ecx, edi        ; back to beg of string. make ecx
                mov             edx, [.ct1]     ; point to it, and edx gets # chars
                mov             eax, SYS_WRITE  ; and print!
                mov             ebx, STDOUT
                int             0x80

                ; popad                           ; restore all registers

                ret
        





section .data
	msg : db ' ',10
	l : equ $-msg
	num :dd 1
section .bss
	ans : resb 1
	

section .text

	global _start:
	_start:

	; first

	mov eax, 1234

	mov ecx ,10

	mov edx, 0

	div ecx

	mov [num],eax

	; print last digit
	add edx , 30h

	mov [ans],edx

	mov eax, 4
	mov ebx, 1
	mov ecx, ans
	mov edx, 1
	int 80h

	; second

	mov eax, [num]

	mov ecx ,10

	mov edx, 0

	div ecx

	mov [num],eax

	; print second last digit
	add edx , 30h

	mov [ans],edx

	mov eax, 4
	mov ebx, 1
	mov ecx, ans
	mov edx, 1
	int 80h
	

	; third


	mov eax, [num]

	mov ecx ,10

	mov edx, 0

	div ecx

	mov [num],eax

	; print third last digit
	add edx , 30h

	mov [ans],edx

	mov eax, 4
	mov ebx, 1
	mov ecx, ans
	mov edx, 1
	int 80h
	

	;fourth

	mov eax, [num]

	mov ecx ,10

	mov edx, 0

	div ecx

	mov [num],eax

	; print fourth last digit
	add edx , 30h

	mov [ans],edx

	mov eax, 4
	mov ebx, 1
	mov ecx, ans
	mov edx, 1
	int 80h





	; new line
	mov eax, 4
	mov ebx, 1
	mov ecx, msg
	mov edx, l
	int 80h

	




	mov eax, 1
	mov ebx, 0
	int 80h