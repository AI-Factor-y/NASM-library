section .data
len : db 0
num : db 0
msg1: db "Enter a string : "
l1: equ $-msg1
msg2: db 10
l2: equ $-msg2
msg3: db "Output string : "
l3: equ $-msg3
msg4: db "DEBUG"
l4: equ $-msg4
msg5: db 10
l5: equ $-msg5


section .bss
s : resb 50
s1 : resb 50
s2 : resb 50
a1 : resb 50
a2 : resb 50
temp : resb 1


ans : resb 1
ans2 : resb 1
t : resb 1
t2 : resb 1
count : resb 1
string2: resb 100

section .text
global _start
_start:


  mov eax, 4
	mov ebx, 1
	mov ecx, msg1
	mov edx, l1
	int 80h

    

    mov ebx, s
    

    Read:
        push ebx
        mov eax, 3
        mov ebx, 0
        mov ecx, temp
        mov edx, 1
        int 80h

        pop ebx
        cmp byte[temp], 10
        je end_Read
        inc byte[len]
        mov al, byte[temp]
        mov byte[ebx], al
        inc ebx
        jmp Read

        end_Read:
        mov byte[ebx], 0
        mov ebx, s


;---------------------------------------

;TRANSFER THE ALPHABETS------------



strcpy:
        
    ;; copies contents of string ebx to string ecx
    ;; strcpy(ecx,ebx)
    ;; string 1 is ebx string 2 is ecx 
    ;; ecx string changes and becomes same as ebx
    
    section .text

        push eax 
        push ebx
        push edx

            strcpy_loop_1:
                mov dl,byte[ebx]
                mov byte[ecx],dl

                cmp dl,0
                je exit_strcpy_loop_1

                inc ebx
                inc ecx

                jmp strcpy_loop_1

            exit_strcpy_loop_1:

        pop edx
        pop ecx
        pop eax

    ret 




Transfer :
    ;mov ecx ,s
    mov al, byte[len]
    mov byte[t], al
    

    movzx ecx, al

    dec ecx
    ; mov edx,s

    call strcpy

    mov edx,ecx


    add edx, ecx
    
    mov ebx ,s
    mov al, byte[ebx]
    mov byte[t2], al

    outer_loop:
        push ebx
        mov al,byte[ebx]
        mov byte[a1], al

        cmp byte[ebx],'A'
        jb cont
        cmp byte[ebx], 'z'
        ja cont
        cmp byte[ebx], 'Z'
        ja Func
        jmp then
            Func :
                cmp byte[ebx], 'a'
                jb cont
                jmp then

        then :
            push edx
            mov al, byte[edx]

            cmp byte[edx],'A'
            jb cont2
            cmp byte[edx], 'z'
            ja cont2
            cmp byte[edx], 'Z'
            ja Func2
            jmp then2
                Func2 :
                    cmp byte[edx], 'a'
                    jb cont2
                    jmp then2

            then2 :
                ;dec byte[t]
                
                mov al, byte[edx]
                mov byte[ebx],al
          
                jmp next

            cont2 :
                pop edx
                dec edx
                dec byte[t]
                cmp byte[t],0
                jne then
                jmp print

            
        cont :
            pop ebx
            inc ebx
            cmp byte[ebx],0
            jne outer_loop
            jmp print
        
        next :
            pop edx
            pop ebx
            dec edx
            inc ebx
            dec byte[t]
            cmp byte[ebx],0
            jne outer_loop

            ;--------------

            jmp print

        
    print:

        mov eax, 4
        mov ebx, 1
        mov ecx, msg3
        mov edx, l3
        int 80h

     mov ebx, s
         p_1:
            push ebx
            mov al,byte[ebx]
            mov byte[ans], al
            
            mov eax, 4
            mov ebx, 1
            mov ecx, ans
            mov edx, 1
            int 80h


            pop ebx
            inc ebx
            

            cmp byte[ebx],0
            jg p_1


    exit:

    
    mov eax, 4
    mov ebx, 1
    mov ecx, msg5
    mov edx, l5
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h





