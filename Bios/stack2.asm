; Playing with the stack

mov ah, 0x0e        ; Using interrupt 0x10 with ah set to 0x0e will print to screen

mov bp, 0x8000      ; Set base of stack above where BIOS is loaded so we don't overwrite it
                    ; BIOS loaded at 0x7c00

mov sp, bp          ; Set the stack pointer to the same value as the base pointer

push 'A'            ; Push the letter A onto the stack. Since we are in 16-bit mode, the stack
push 'B'            ; Works only on 16-bit boundaries. Assembler will add 0x00 to the A to fill out
push 'C'            ; The padding so we hit 16-bit.

mov al, [0x7ffa]    ; 0x8000 - 0x2 : 'C'
int 0x10

mov al, [0x7ffc]    ; 0x8000 - 0x4 : 'B'
int 0x10

mov al, [0x7ffe]    ; 0x8000 - 0x6 : 'A'
int 0x10

jmp $               ; Jump forever

; Padding and mahic BIOS number

times 510-($-$$) db 0
dw 0xaa55