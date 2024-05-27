#include <stdint.h>

#define GDT_MAX_DESCRIPTORS         6


//Struc has to be arranged like this for the data type to be
//correct in memory
struct GDT_descriptor_t {
    uint16_t limit_bottom;     //First 16 bits of limit
    uint16_t base_bottom;      //First 16 bits of base
    uint8_t  base_middle;      //Next 8 bits of base
    uint8_t  access_byte; 
    uint8_t  limit_top;        //Final 4 bits of limit. 20 bits total
    uint8_t  flags;
    uint8_t  base_top;         //Final 8 bits of the base
}__attribute__((packed));

struct GDT_ptr_t {
    uint16_t     limit;
    unsigned int base;
}__attribute__((packed));

struct TSS_descriptor_t {
    uint16_t LINK;
    uint16_t Reserved0;
    uint32_t ESP0;
    uint16_t SS0;
    uint16_t Reserved1;
    uint32_t ESP1;
    uint16_t SS1;
    uint16_t Reserved2;
    uint32_t ESP2;
    uint16_t SS2;
    uint16_t Reserved3;
    uint32_t CR3;
    uint32_t EIP;
    uint32_t EFLAGS;
    uint32_t EAX;
    uint32_t ECX;
    uint32_t EDX;
    uint32_t EBX;
    uint32_t ESP;
    uint32_t EBP;
    uint32_t ESI;
    uint32_t EDI;
    uint16_t ES;
    uint16_t Reserved4;
    uint16_t CS;
    uint16_t Reserved5;
    uint16_t SS;
    uint16_t Reserved6;
    uint16_t DS;
    uint16_t Reserved7;
    uint16_t FS;
    uint16_t Reserved8;
    uint16_t GS;
    uint16_t Reserved9;
    uint16_t LDTR;
    uint16_t Reserved10;
    uint16_t Reserved11;
    uint16_t IOPB;
    uint32_t SSP;
}__attribute__((packed));


void init_GDT();
void GDT_add_descriptor(uint32_t num, uint32_t base, uint32_t limit, uint8_t access, uint8_t flags);
void write_TSS(uint32_t num, uint32_t SS0, uint32_t ESP0);