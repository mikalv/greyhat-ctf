#define _GNU_SOURCE
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// gcc level06.c -fno-stack-protector -m32 -o level06

void target_function(void) {
    printf("Welcome to Arjia City!\n");
    setresgid(getegid(), getegid(), getegid());
    setresuid(geteuid(), geteuid(), geteuid());
    system("/bin/sh");
}

void bye(void) {
    printf("Access denied!\n");
}

int main(int argc, char **argv)
{
    void (*function_ptr)(void) = bye;
    char buffer[32];

    if(argc != 2) {
        printf("usage: %s <input>\n", argv[0]);
        exit(1);
    }

    strcpy(buffer, argv[1]);

    printf("Target function is at %p\n", target_function);
    printf("Calling %p\n", function_ptr);
    function_ptr();

    return 0;
}
