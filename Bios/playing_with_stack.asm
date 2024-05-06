; Playing with the stack

mov ah, 0x0e        ; Using interrupt 0x10 with ah set to 0x0e will print to screen

mov bp, 0x8000      ; Set base of stack above where BIOS is loaded so we don't overwrite it
                    ; BIOS loaded at 0x7c00

mov sp, bp          ; Set the stack pointer to the same value as the base pointer

push 'A'            ; Push the letter A onto the stack. Since we are in 16-bit mode, the stack
push 'B'            ; Works only on 16-bit boundaries. Assembler will add 0x00 to the A to fill out
push 'C'            ; The padding so we hit 16-bit.

pop bx              ; Note, we can only pop 16 bits at a time to we pop into bx and copy
mov al, bl          ; the lower 8 bits with the character value into al.
int 0x10            ; print (al).

pop bx              ; Next value on the stack.
mov al, bl
int 0x10

mov al, [0x7ffe]    ; To prove that our stack grows downwards, fetch the char at 0x8000 - 0x2
int 0x10

jmp $               ; Jump forever

; Padding and mahic BIOS number

times 510-($-$$) db 0
dw 0xaa55