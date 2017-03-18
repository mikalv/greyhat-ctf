#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>

// gcc level07.c -fno-stack-protector -z execstack -m32 -o level07

void spawn_shell() {
    printf("Welcome to Arjia City!\n");
    gid_t gid;
    uid_t uid;
    gid = getegid();
    uid = geteuid();
    setresgid(gid, gid, gid);
    setresuid(uid, uid, uid);
    system("/bin/sh");
}

void gates_of_arjia(char *input) {
    char buffer[32];
    strcpy(buffer, input);
    printf("Return to: %p\n", __builtin_return_address(0));
}

int main(int argc, char **argv)
{
    if(argc!=2) {
        printf("usage: %s <input>\n", argv[0]);
        exit(1);
    }
    printf("Hello, I'm the MCP (Master Control Program). I'm here to protect the TRON system.\n");
    printf("What are you doing here? Are you a user or a program?\n");
    printf("Where did you come from? Proof your identity:\n");
    gates_of_arjia(argv[1]);
    exit(0);
}
