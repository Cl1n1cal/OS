#include "util.h"

void memset_value(void *dest, char val, uint32_t count) {
    char *temp = (char*) dest;
    for(; count != 0; count--) {
        *temp++ = val;
    }
}