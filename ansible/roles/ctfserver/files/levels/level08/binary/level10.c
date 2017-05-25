#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>

// gcc level10.c -o level10 -m32

int main() {
    char *pos;
    char buffer[512];
    char password[32];

    int fp = open("/home/level11/.passwd", O_RDONLY);

    read(fp, password, 32);
    if ((pos=strchr(password, '\n')) != NULL) *pos = '\0';
    password[31] = '\0';

    printf("What is your name?\n");
    fflush(stdout);
    fgets(buffer, sizeof(buffer), stdin);
    if ((pos=strchr(buffer, '\n')) != NULL) *pos = '\0';
    password[511] = '\0';
    printf(buffer);

    if(strcmp(buffer,password)==0) {
        printf("\ncorrect! come in.\n");
    } else{
        printf("\nYou must be an Obj-C programmer. GET OUT OF HERE!\n");
    }
}
