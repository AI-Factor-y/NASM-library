;Write a program to read a number and find whether it is prime or not
section .data
msg : db 'Enter number : ',
l1 : equ $-msg
nwl : db ' ',10
nwl_l : equ $-nwl
section .bss
num resw 2
num1 resw 2
count resb 1
temp resb 1
section .text
	global _start:
	_start:
    mov word[num],0
    mov eax, 4
	mov ebx, 1
	mov ecx, msg
	mov edx, l1
	int 80h
    call read_num
    mov ax,word[num]
    mov word[num1],ax
    mov word[num],0
    mov eax, 4
	mov ebx, 1
	mov ecx, msg
	mov edx, l1
	int 80h
    call read_num
    mov ax,word[num]
    mov word[num],ax
    add ax,word[num1]
    mov word[num],ax
    call print_num

    mov eax, 1
	mov ebx, 0
	int 80h
    
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
push dx
mov word[num], ax
jmp extract_no
print_no:
cmp byte[count], 0
je end_print
dec byte[count]
pop dx
mov byte[temp], dl
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