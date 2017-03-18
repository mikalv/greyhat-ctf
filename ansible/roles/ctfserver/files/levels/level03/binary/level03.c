#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdint.h>
#include <sys/types.h>

// h0w_is_th1s_h4ck3r_f0ll0wing_m3
char secret_password[] =  "\x29\x71\x36\x1e\x28\x32\x1e\x35\x29\x70\x32\x1e\x29\x75\x22\x2a\x72\x33\x1e\x27\x71\x2d\x2d\x71\x36\x28\x2f\x26\x1e\x2c\x72";
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

    printf("~Zero Cool Simple Backdoor v3~\nEnter Password:\n");
    read(STDIN_FILENO, password_input, 32);
    password_input[31]='\0';

    if ((pos=strchr(password_input, '\n')) != NULL) *pos = '\0';

    for(i=0; i<strlen(password_input); i++) {
        password_input[i] = password_input[i] ^ XORkey;
    }

    if(strcmp(password_input,secret_password)==0) {
        printf("Correct! Here is the level04 shell.\nRead the level04 password in /home/level04/.pass to login with `ssh level04@greyhat.no`\n");
        spawn_shell();
    } else{
        printf("wrong!");
    }

    return 0;
}
