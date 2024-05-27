; This program prints Null terminated strings to the screen
; Example: 'Hello world', 0

; Takes 1 parameter into bx register
; Example:  mov bx HELLO_MSG
;           call print_string


global print_string     ; Define with global keyword to reference in other files


print_string:
    mov ah, 0x0e        ; Get ready for printing
    print_loop:
        mov al, [bx]        ; Get the value at the address of bx
        cmp al, 0           ; Check if we are at the end of the string
        je done_printing    ; Exit if we are done
        int 0x10            ; Print interrupt combination ah = 0x0e and int 0x10
        inc bx              ; Increment address of bx so we move to next character
        jmp print_loop 

    done_printing:
        ret