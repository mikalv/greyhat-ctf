#!/bin/bash
# cd $(dirname "$0"); . ./common.sh; cd -
script_dir=$(dirname "$0")


function setup_jail_etc() {
  cd /var/jail/etc
  cp /etc/ld.so.cache .
  cp /etc/ld.so.conf .
  cp /etc/nsswitch.conf .
  cp /etc/hosts .
  cd -
}

function install_executable() {
  arg1=$1
  arg2=$(dirname $1)
  libfix="$script_dir/l2chroot"
  cp $arg1 /var/jail/$arg2/
  $libfix $arg1
  echo "[+] Installed $arg1 with dependencies in /var/jail/$arg2/"
}

function setup_jail_rootfs() {
  group=sshusers
  echo "[+] Creating root structure"
  mkdir -p /var/jail/{dev,etc,lib,usr,bin,lib64}
  mkdir -p /var/jail/usr/{bin,lib,lib64,local,share}
  echo "[+] Installing user friendly manuals..."
  mkdir -p /var/jail/usr/share/man
  cp -r /usr/share/man/man{0,1,2,3,4,5,6,7,8} /var/jail/usr/share/man/
  chown root.root /var/jail
  mknod -m 666 /var/jail/dev/null c 1 3
  if grep -q $group /etc/group
    then
      echo "[+] Skipping groupadd, $group already exists :)"
    else
      groupadd $group
      echo "[+] Added group $group to system!"
    fi
}

setup_jail_rootfs
setup_jail_etc
install_executable /bin/sh
install_executable /usr/bin/bash
install_executable /usr/bin/zsh
install_executable /usr/bin/ls
install_executable /usr/bin/sl
install_executable /usr/bin/vim
install_executable /usr/bin/nano
install_executable /usr/bin/vi
install_executable /usr/bin/curl
install_executable /usr/bin/wget
install_executable /usr/bin/gdb
install_executable /usr/bin/radare2
install_executable /usr/bin/ping
install_executable /usr/bin/id
install_executable /usr/bin/man


