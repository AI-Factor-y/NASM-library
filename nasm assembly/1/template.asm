
how to run
---------------
nasm -f elf64 -o question_1.o question_1.asm

ld question_1.o -o question_1_ex



;=========debug=========

	; new line
	mov eax, 4
	mov ebx, 1
	mov ecx, msg
	mov edx, l
	int 80h


	mov eax, [num]

	call _printDec

	; new line
	mov eax, 4
	mov ebx, 1
	mov ecx, msg
	mov edx, l
	int 80h

;=======================

printing
-----------------

mov eax, 4
mov ebx, 1
mov ecx, msg1
mov edx, l1
int 80h

scaning
-------------------
mov eax, 3
mov ebx, 0
mov ecx, d1
mov edx, 1
int 80h

mov eax, 3
mov ebx, 0
mov ecx, junk
mov edx, 1
int 80h


exit
--------
mov eax, 1
mov ebx, 0
int 80h

division
---------
mov bl, 100
mov ah, 0
div bl


9. DIV - Division
Synatx : div src

Used to divide the value of EDX:EAX or DX:AX or AX register with registers/memory variables in src. 
DIV works according to the following rules.

• If src is 1 byte then AX will be divide by src, remainder will go to AH
and quotient will go to AL.

• If src is 1 word (2 bytes) then DX:AX will be divided by src, remainder
will go to DX and quotient will go to AX.

• If src is 2 words long(32 bit) then EDX:EAX will be divide by src,
remainder will go to EDX and quotient will go to EAX.


; ah remainder, al quotient ax/bl = al

multiplication
-------------
mov bl, 10
mov ah, 0
mul bl

;ah remainder result in ax


7. MUL - Multiplication

Syntax : mul src

Used to multiply the value of a registers/memory variables with the EAX/AX/AL

reg. MUL works according to the following rules.

• If src is 1 byte then AX = AL * src.

• If src is 1 word (2 bytes) then DX:AX = AX * src (ie. Upper 16 bits of
the result (AX*src) will go to DX and the lower 16 bits will go to AX).

• If src is 2 words long(32 bit) then EDX:EAX = EAX * src (ie. Upper
32 bits of the result will go to EDX and the lower 32 bits will go to
EAX).



push operation
---------------
pop dx
mov byte[temp], dl  ; dx is further divided into dh and dl

mov ax, [n2]


		mov bl, 10
		mov ah, 0
		div bl

		mov byte[ans1], al
		mov byte[ans2], ah
		add byte[ans1], 30h
		add byte[ans2], 30h

		mov eax, 4
		mov ebx, 1
		mov ecx, ans1
		mov edx, 1
		int 80h

		mov eax, 4
		mov ebx, 1
		mov ecx, ans2
		mov edx, 1
		int 80h


		
		mov bl, 1000
		mov ah, 0
		div bl
		add al, 30h
		mov [ans5], ah
		mov [ans1], al
		mov ax, word[ans4]

		mov bl, 100
		;mov ah, 0
		div bl
		add al, 30h
		add ah, 30h
		mov [ans2], al
		mov [ans4], ah

		mov bl, 10
		;mov ah, 0
		div bl
		add al, 30h
		add ah, 30h
		mov [ans3], al
		mov [ans4], ah
		


;===========================================
; print debug function

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
        





debugger:
		push rax
		push rbx
		push rcx
		; debug----
				mov eax, 4
				mov ebx, 1
				mov ecx, debug  ; debug message
				mov edx, debug_l
				int 80h
				;debug ---

		pop rcx
		pop rbx
		pop rax

		; operation to perform in debug mode
		; push rax
		; 	mov eax,[ebx+2*eax]
		; 	mov [num],eax
		; 	call print_num
		; pop rax

		ret
