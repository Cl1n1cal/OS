#include "gdt.h"
#include "util.h"
#include <stdio.h>


extern void GDT_flush();

struct GDT_descriptor_t gdt_entries[GDT_MAX_DESCRIPTORS];
struct GDT_ptr_t        gdt_ptr;
struct TSS_descriptor_t tss_entry;

void init_GDT(){
    gdt_ptr.limit = (sizeof(struct GDT_descriptor_t) * GDT_MAX_DESCRIPTORS) - 1;
    gdt_ptr.base = (uint32_t)&gdt_entries;                   //This is the start address of our gdt

    GDT_add_descriptor(0, 0, 0, 0, 0);             //Null Descriptor
    GDT_add_descriptor(1, 0, 0xFFFFF, 0x9A, 0xA); //Kernel Code Segment
    GDT_add_descriptor(2, 0, 0xFFFFF, 0x92, 0xC); //Kernel Data Segment, offset is 0x10
    GDT_add_descriptor(3, 0, 0xFFFFF, 0xFA, 0xA); //User Code Segment
    GDT_add_descriptor(4, 0, 0xFFFFF, 0xF2, 0xC); //User Data Segment
    write_TSS(5, 0x10, 0x0);             //Adding the TSS. 0x10 is the offset of Kernel data

    GDT_flush();

    printf("Loading GDT\n");
}

void write_TSS(uint32_t num, uint32_t SS0, uint32_t ESP0) {
    uint32_t base = (uint32_t) &tss_entry;
    uint32_t limit = base + sizeof(tss_entry);

    GDT_add_descriptor(num, base, limit, 0x89, 0x0); //0x89 : 10001001
    memset_value(&tss_entry, 0, sizeof(tss_entry));        //Set all members of the struct to 0

    tss_entry.SS0 = SS0;
    tss_entry.ESP0 = ESP0;

    tss_entry.CS = 0x08 | 0x3; //Or offset of kernel code with 3 to use TSS for switching from user mode to kernel mode
    tss_entry.SS = tss_entry.DS = tss_entry.ES = tss_entry.FS = tss_entry.GS = 0x10 | 0x3; //Same thing for the other segments
}

void GDT_add_descriptor(uint32_t num, uint32_t base, uint32_t limit, uint8_t access, uint8_t flags) {
    gdt_entries[num].base_bottom        =      (base & 0xFFFF);         //Get the first 16 bit of base. 0xFFFF = 1111*4
    gdt_entries[num].base_middle        =      (base >> 16) & 0xFF;     //Get the next 8 bits of base
    gdt_entries[num].base_top           =      (base >> 24) & 0xFF;     //Get the top most 8 bits of base
    gdt_entries[num].limit_bottom       =      (limit & 0xFFFF);       //Get the first 16 bit of limit
    gdt_entries[num].limit_top          =      (limit >> 16) & 0xF;    //Get the final 4 bit of limit
    gdt_entries[num].access_byte        =      access;                 //Set the access byte
    gdt_entries[num].flags              =      flags & 0xF;            //Get the first 4 bits containing the flag
}
