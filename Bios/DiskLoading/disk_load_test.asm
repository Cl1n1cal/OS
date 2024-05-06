; Disk load example using our disk_read function
[org 0x7c00]

; Jump to start of boot test
jmp boot_test_start

; Disk load
disk_load:
    push dx         ; Store dx on stack so we can check later how many sectors
                    ; we wanted to read vs how many was actually read

    mov ah, 0x02    ; BIOS read sector function (combined with int 0x13)
    mov al, dh      ; Read DH sectors
    mov ch, 0x00    ; Select cylinder 0
    mov dh, 0x00    ; Select head 0
    mov cl, 0x02    ; Start reading from the second sector (i.e. after the boot sector)
    int 0x13        ; BIOS interrupt for low level disk services

    jc disk_error   ; Jump if error (i.e. carry flag set)

    pop dx          ; Restore dx from the stack
    cmp dh, al      ; If AL (sectors read) != DH (sectors expected)
    jne disk_error1  ; Display error message
    ret

disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $

disk_error1:
    mov bx, DISK_ERROR_MSG1
    call print_string
    jmp $


; Variables
DISK_ERROR_MSG:
    db "Disk read Error!", 0

DISK_ERROR_MSG1:
    db "Not all disk read", 0

; Print Hex
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


; Variables
HEX_OUT:
    db '0x0000', 0


; Print String
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


boot_test_start:
    mov [BOOT_DRIVE], dl    ; BIOS stores our boot drive in DL, so it's
                        ; best to remember this for later

    mov bp, 0x8000          ; Setting stack safely out of the way at 0x8000
    mov sp, bp

    mov bx, 0x9000          ; Load 2 sectors to 0x0000 (ES):0x9000(BX)
    mov dh, 2               ; Set dh to 2 sectors, otherwise error.

    mov dl, [BOOT_DRIVE]    
    call disk_load

    mov dx, [0x9000]        ; Print out the first loaded word, which we expect
    call print_hex          ; to be 0xdada, stored at address 0x9000

    mov dx, [0x9000 + 512]  ; Also, print the first word from the 2nd loaded
    call print_hex          ; sector. Should be 0xface

    jmp $


; Global variables
BOOT_DRIVE:
    db 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55

times 256 dw 0xdada
times 256 dw 0xface
; We know that BIOS will only load the first 512-byte sector from the disk
; so we need to add some sectors with familiar numbers so we can convince
; ourselves that we did indeed load 2 extra sectors from the disk we booted from