; This program prints Null terminated strings to the screen
; Example: 'Hello world', 0
[org 0x7c00]

    extern init_GDT         ; Notify Assembler about external function init_GDT()

    mov bx, HELLO_MSG
    call print_string


print_string:
    mov ah, 0x0e            ; Get ready for printing
    print_loop:
        mov al, [bx]        ; Get the value at the address of bx
        cmp al, 0           ; Check if we are at the end of the string
        je done_printing    ; Exit if we are done
        int 0x10            ; Print interrupt combination ah = 0x0e and int 0x10
        inc bx              ; Increment address of bx so we move to next character
        jmp print_loop 

    done_printing:
        jmp initialize_GDT 

; Initialize GDT
initialize_GDT:
    call init_GDT
    jmp $


; Data
HELLO_MSG:
    db 'Booting OS', 0 ; <- null termination

; Padding, to be removed
times 510-($-$$) db 0
dw 0xaa55