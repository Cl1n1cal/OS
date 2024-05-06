
; Boot sector program for finding the memory address of a secret
; Account for where your code is loaded into memory by using [org 0x7c00] at the top of your code
[org 0x7c00]

mov ah, 0x0e ; 0x0e Write character in TTY mode using interrupt vector 0x10

; First Attempt
;mov al, the_secret
;int 0x10                ; Does this print an X?

; Second Attempt
mov al, [the_secret]     ; Works if we put [org 0x7c00] because the CPU then knows where the code
int 0x10                 ; is loaded into memory

; Third Attempt
;mov bx, the_secret
;add bx, 0x7c00          ; 0x7c00 is the starting address of the loaded boot sector
;mov al, [bx]
;int 0x10

; Fourth attempt
;mov al, [0x7c14]        ; 0x7c1e = 0x7c00 + 14 (20 deci) and the X is at offet 20 decimal from boot sector start
;int 0x10

jmp $

the_secret:
    db "X"

; Padding and magic BIOS number

times 510-($-$$) db 0
dw 0xaa55