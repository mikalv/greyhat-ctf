#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdint.h>
#include <sys/types.h>

char secret_password[] =  "\x2f\x71\x23\x71\x25\x38\x1e\x26\x34\x72\x32\x32\x24\x32\x1e\x35\x29\x28\x74\x1e\x31\x20\x32\x32\x36\x71\x33\x25";
uint8_t XORkey = 0x41;

int main (int argc, char *argv[]) {

    char password_input[32];
    char *pos;
    int i;

    printf("~Zero Cool Simple Backdoor password generator~\nEnter Password:\n");
    read(STDIN_FILENO, password_input, 32);
    password_input[31]='\0';

    if ((pos=strchr(password_input, '\n')) != NULL) *pos = '\0';

    for(i=0; i<strlen(password_input); i++) {
        password_input[i] = password_input[i] ^ XORkey;
        printf("\\x%x",password_input[i]);
    }

    printf("");

    return 0;
}


