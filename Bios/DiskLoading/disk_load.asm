; Load DH sectors to ES:BX from drive DL


%include "print_string.asm"
; External functions used
extern print_string

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
    jne disk_error  ; Display error message
    ret

disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $

; Variables
DISK_ERROR_MSG:
    db "Disk read Error!", 0