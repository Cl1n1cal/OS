; Flush GDT

global GDT_flush

GDT_flush:
   MOV eax, [esp+4]
   LGDT [eax]

   MOV eax, 0x10
   MOV ds, ax
   MOV es, ax
   MOV fs, ax
   MOV gs, ax
   MOV ss, ax
   JMP 0x08:.flush
.flush
   RET

global TSS_flush
TSS_flush:
   MOV ax, 0x2B
   LTR ax
   RET