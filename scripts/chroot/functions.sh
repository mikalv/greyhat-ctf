
script_dir=$(dirname "$0")


function setup_jail_etc() {
  cd /var/jail/etc
  cp /etc/ld.so.cache .
  cp /etc/ld.so.conf .
  cp /etc/nsswitch.conf .
  cp /etc/passwd .
  cp /etc/group .
  cp /etc/hosts .
  cp /etc/hostname .
  cp -r /etc/local* .
  cp /etc/man_db.conf .
  cp /etc/profile .
  cp -r /etc/profile.d .
  cd -
}

function install_executable() {
  arg1=$1
  arg2=$(dirname $1)
  libfix="$script_dir/l2chroot"
  cp $arg1 /var/jail/$arg2/
  $libfix $arg1
  echo "[+] Installed $arg1 with dependencies in /var/jail$arg2/"
}

function setup_jail_rootfs() {
  group=sshusers
  if [ -d /var/jail ]; then
    echo "[-] Found earlier build. Delete or skip?"
    read -p "Delete or skip? (d/s)" action
    if [[ "$action" == "s" ]]; then
        return 0
    else
        umount /var/jail/dev/pts
        rm -fr /var/jail
    fi
  fi
  echo "[+] Creating root structure"
  mkdir -p /var/jail/{dev,etc,lib,usr,bin,lib64,root,home}
  mkdir -p /var/jail/usr/{bin,lib,lib64,local,share}
  echo "[+] Making bind mounts"
  mkdir -p /var/jail/dev/pts
  mount --bind /dev/pts /var/jail/dev/pts
  echo "[+] Installing user friendly manuals..."
  mkdir -p /var/jail/usr/share/man
  # Skip man3 cause it's too huge.
  cp -r /usr/lib/man-db /var/jail/usr/lib/
  cp -r /usr/share/man/man{0,1,2,4,5,6,7,8} /var/jail/usr/share/man/
  echo "[+] Adding terminal dependencies..."
  cp -r /usr/lib/locale /var/jail/usr/lib/
  # Fix for zsh
  cp -r /usr/lib/zsh /var/jail/usr/lib/
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

