; GDT
gdt_start:

null_descriptor:   ; The mandatory null descriptor (All GDTs start with this)
    dq 0    ; 'dq' means quadword which has size 64 bits

kernel_code:
    dw 0xFFFFF  ; First 16 (0-15) bits is the limit. Has to be all 1s
    dw 0        ; Next 16 (16-31) bits is the start of base. Has to be all 0s
    db 0        ; Next 8 (32-39) bits is the next 8 bits of base. Has to be 0s
    db 10011010 ; Access byte: P=1, DPL=00, S=1, E=1, DC=0, RW=1, A=0
    db 10101111 ; Lowest 4 bits (all 1s) are limit and high 4 bits (1010) is Flags
    db 0        ; Final 8 bits are base and should be all 0s


kernel_data:
    dw 0xFFFFF  ; First 16 (0-15) bits is the limit. Has to be all 1s
    dw 0        ; Next 16 (16-31) bits is the start of base. Has to be all 0s
    db 0        ; Next 8 (32-39) bits is the next 8 bits of base. Has to be 0s
    db 10010010 ; Access byte: P=1, DPL=00, S=1, E=0, DC=0, RW=1, A=0 
    db 10101111 ; Lowest 4 bits (all 1s) are limit and high 4 bits (1010) is Flags
    db 0        ; Final 8 bits are base and should be all 0s

user_code:
    dw 0xFFFFF  ; First 16 (0-15) bits is the limit. Has to be all 1s
    dw 0        ; Next 16 (16-31) bits is the start of base. Has to be all 0s
    db 0        ; Next 8 (32-39) bits is the next 8 bits of base. Has to be 0s
    db 11111010 ; Access byte: P=1, DPL=11, S=1, E=1, DC=0, RW=1, A=0
    db 10101111 ; Lowest 4 bits (all 1s) are limit and high 4 bits (1010) is Flags
    db 0        ; Final 8 bits are base and should be all 0s

user_data:
    dw 0xFFFFF  ; First 16 (0-15) bits is the limit. Has to be all 1s
    dw 0        ; Next 16 (16-31) bits is the start of base. Has to be all 0s
    db 0        ; Next 8 (32-39) bits is the next 8 bits of base. Has to be 0s
    db 11110010 ; Access byte: P=1, DPL=11, S=1, E=0, DC=0, RW=1, A=0
    db 10101111 ; Lowest 4 bits (all 1s) are limit and high 4 bits (1010) is Flags
    db 0        ; Final 8 bits are base and should be all 0s


task_state_segment: