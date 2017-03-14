#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdint.h>
#include <sys/types.h>

// n0b0dy_gu3sses_thi5_passw0rd
char secret_password[] =  "\x2f\x71\x23\x71\x25\x38\x1e\x26\x34\x72\x32\x32\x24\x32\x1e\x35\x29\x28\x74\x1e\x31\x20\x32\x32\x36\x71\x33\x25";
uint8_t XORkey = 0x41;

void spawn_shell() {
    gid_t gid;
    uid_t uid;
    gid = getegid();
    uid = geteuid();
    setresgid(gid, gid, gid);
    setresuid(uid, uid, uid);
    system("/bin/sh");
}

int main (int argc, char *argv[]) {

    char password_input[32];
    char *pos;
    int i;

    printf("~Zero Cool Simple Backdoor v2~\nEnter Password:\n");
    read(STDIN_FILENO, password_input, 32);
    password_input[31]='\0';

    if ((pos=strchr(password_input, '\n')) != NULL) *pos = '\0';

    for(i=0; i<strlen(secret_password); i++) {
        secret_password[i] = secret_password[i] ^ XORkey;
    }

    printf("");

    if(strcmp(password_input,secret_password)==0) {
        printf("Correct! Here is the level02 shell.\nRead the level02 password in /home/level02/.pass to login with `ssh level02@greyhat.no`\n");
        spawn_shell();
    } else{
        printf("wrong!");
    }

    return 0;
}
