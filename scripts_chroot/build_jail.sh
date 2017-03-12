#!/bin/bash
mkdir -p /var/jail/{dev,etc,lib,usr,bin}
mkdir -p /var/jail/usr/bin
chown root.root /var/jail
mknod -m 666 /var/jail/dev/null c 1 3

