; External function call to print_string subroutine

[org 0x7c00]        ; Notify CPU about boot sector start

mov bx, HELLO_MSG
call print_string

mov bx, GOODBYE_MSG
call print_string

jmp $               ; Hang

; The below line will simply be replaces by the contents of print_string.asm
%include "print_string.asm"

; Data
HELLO_MSG:
    db 'Hello World!', 0    ; Remember null termination, so our routine knows when to stop

GOODBYE_MSG:
    db 'Goodbye!', 0

; Padding and magic number
times 510-($-$$) db 0
dw 0xaa55