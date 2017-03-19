#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>

// gcc level7.c -fno-stack-protector -z execstack -m32 -o level7

char shellcode[128];

int main(int argc, char **argv) {
    if(argc!=2) {
        printf("usage: %s <input>\n", argv[0]);
        exit(1);
    }
    printf("Hello user.\nYou can create a new program in the TRON system that will live in Arjia City:\n");
    // read 128 byte from stdin into `shellcode`
    strcpy(shellcode, argv[1]);
    // looks crazy, but it just jumps to the data inside shellcode and executes it. Look at it with `gdb`
    (*(void(*)()) shellcode)();
}
