#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

void main() {
    gid_t gid;
    uid_t uid;
    gid = getegid();
    uid = geteuid();
    setresgid(gid, gid, gid);
    setresuid(uid, uid, uid);

    printf("Zero Cool - Linux Information Gathering Tool v1.2\n");
    printf("\n[*] Get system information:\n");
    system("uname -a");

    printf("\n[*] Find users available on this system:\n");
    system("cut -d: -f1,3,4 /etc/passwd");

    printf("\n[*] Search for setuid binaries:\n");
    system("find / -perm -4000 -exec ls -la {} \\; 2>/dev/null");
}
