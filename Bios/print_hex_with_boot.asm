; Print hex routine
[org 0x7c00]


; Use dx as our parameter for hex to be printed
mov dx, 0x1fb6
call print_hex
jmp $           ; hang

%include "print_string.asm"


print_hex:
    pusha           ; Save registers on the stack

    mov cx, 4       ; Counter, we want to print 4 characters

char_loop:
    dec cx          ; Decrement the counter

    mov ax, dx 
    and ax, 0xf     ; Get the last 4 bits of ah. 0xf = 1111 (binary)
    shr dx, 4       ; Shift dx 4 bits to the right

    mov bx, HEX_OUT ; Set bx to the memory address of our string
    add bx, 0x2     ; Skip the '0x'
    add bx, cx      ; Add the counter to the current address.

    cmp ax, 0xa     ; Check to see if it is a letter or number
    jl set_letter   ; If number, jump straight to setting the letter
    add al, 0x27    ; If letter, add 0x27 and plus 0x30 down below
    jl set_letter   ; ASCII letters start at 0x61 for 'a'. Characters
                    ; Come after decimal numbers.


set_letter:
    add al, 0x30        ; To convert to ASCII
    mov byte [bx], al   ; Add the value of the byte to the char at bx

    cmp cx, 0           ; Check the counter
    je print_hex_done   ; Jump if we are done
    jmp char_loop       ; Else run char_loop again

print_hex_done:
    mov bx, HEX_OUT
    call print_string

    popa
    ret


HEX_OUT:
    db '0x0000', 0

; Padding to be removed
times 510-($-$$) db 0
dw 0xaa55