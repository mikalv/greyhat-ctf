#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>

char secret_password[] = "A_Sup3r_s3cr37_P4ssw0rd_Kn0w17";

int main (int argc, char *argv[]) {
    gid_t gid;
    uid_t uid;
    char password_input[32];
    char *pos;

    gid = getegid();
    uid = geteuid();

    setresgid(gid, gid, gid);
    setresuid(uid, uid, uid);

    printf(" _____\n| _ _ |\n|| | || Hidden\n||_|_||   Backdoor\n| _ _ o  by \n|| | ||     ~Zero Cool\n||_|_||  \n|_____|\n\nEnter Secret Password:\n");

    read(STDIN_FILENO, password_input, 32);
    password_input[31]='\0';

    if ((pos=strchr(password_input, '\n')) != NULL) *pos = '\0';

    if(strcmp(password_input,secret_password)==0) {
        printf("Correct! Here is the level02 shell.\nRead the level02 password in /home/level02/.passwd to login with `ssh level02@hackme.knowit.no`\n");
        system("/bin/sh");
    } else{
        printf("wrong!");
    }

    return 0;
}
