#!/bin/bash

# Extra security (Make sure no one tries to override commands with missing fullpath)
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

shopt -s extglob

# generated from util-linux source: libmount/src/utils.c
declare -A pseudofs_types=([anon_inodefs]=1
                           [autofs]=1
                           [bdev]=1
                           [binfmt_misc]=1
                           [cgroup]=1
                           [configfs]=1
                           [cpuset]=1
                           [debugfs]=1
                           [devfs]=1
                           [devpts]=1
                           [devtmpfs]=1
                           [dlmfs]=1
                           [fuse.gvfs-fuse-daemon]=1
                           [fusectl]=1
                           [hugetlbfs]=1
                           [mqueue]=1
                           [nfsd]=1
                           [none]=1
                           [pipefs]=1
                           [proc]=1
                           [pstore]=1
                           [ramfs]=1
                           [rootfs]=1
                           [rpc_pipefs]=1
                           [securityfs]=1
                           [sockfs]=1
                           [spufs]=1
                           [sysfs]=1
                           [tmpfs]=1)

# generated from: pkgfile -vbr '/fsck\..+' | awk -F. '{ print $NF }' | sort
declare -A fsck_types=([cramfs]=1
                       [exfat]=1
                       [ext2]=1
                       [ext3]=1
                       [ext4]=1
                       [ext4dev]=1
                       [jfs]=1
                       [minix]=1
                       [msdos]=1
                       [reiserfs]=1
                       [vfat]=1
                       [xfs]=1)

out() { printf "$1 $2\n" "${@:3}"; }
error() { out "==> ERROR:" "$@"; } >&2
msg() { out "==>" "$@"; }
msg2() { out "  ->" "$@";}
die() { error "$@"; exit 1; }

ignore_error() {
  "$@" 2>/dev/null
  return 0
}

in_array() {
  local i
  for i in "${@:2}"; do
    [[ $1 = "$i" ]] && return 0
  done
  return 1
}

chroot_add_mount() {
  sudo mount "$@" && CHROOT_ACTIVE_MOUNTS=("$2" "${CHROOT_ACTIVE_MOUNTS[@]}")
}

chroot_maybe_add_mount() {
  local cond=$1; shift
  if eval "$cond"; then
    chroot_add_mount "$@"
  fi
}

chroot_setup() {
  CHROOT_ACTIVE_MOUNTS=()
  [[ $(trap -p EXIT) ]] && die '(BUG): attempting to overwrite existing EXIT trap'
  trap 'chroot_teardown' EXIT

  chroot_maybe_add_mount "! mountpoint -q '$1'" "$1" "$1" --bind &&
  chroot_add_mount proc "$1/proc" -t proc -o nosuid,noexec,nodev &&
  chroot_add_mount sys "$1/sys" -t sysfs -o nosuid,noexec,nodev,ro &&
  ignore_error chroot_maybe_add_mount "[[ -d '$1/sys/firmware/efi/efivars' ]]" \
      efivarfs "$1/sys/firmware/efi/efivars" -t efivarfs -o nosuid,noexec,nodev &&
  chroot_add_mount udev "$1/dev" -t devtmpfs -o mode=0755,nosuid &&
  chroot_add_mount devpts "$1/dev/pts" -t devpts -o mode=0620,gid=5,nosuid,noexec &&
  chroot_add_mount shm "$1/dev/shm" -t tmpfs -o mode=1777,nosuid,nodev &&
  chroot_add_mount run "$1/run" -t tmpfs -o nosuid,nodev,mode=0755 &&
  chroot_add_mount tmp "$1/tmp" -t tmpfs -o mode=1777,strictatime,nodev,nosuid
}

chroot_teardown() {
  sudo umount "${CHROOT_ACTIVE_MOUNTS[@]}"
  unset CHROOT_ACTIVE_MOUNTS
}

try_cast() (
  _=$(( $1#$2 ))
) 2>/dev/null

valid_number_of_base() {
  local base=$1 len=${#2} i=

  for (( i = 0; i < len; i++ )); do
    try_cast "$base" "${2:i:1}" || return 1
  done

  return 0
}

mangle() {
  local i= chr= out=

  unset {a..f} {A..F}

  for (( i = 0; i < ${#1}; i++ )); do
    chr=${1:i:1}
    case $chr in
      [[:space:]\\])
        printf -v chr '%03o' "'$chr"
        out+=\\
        ;;
    esac
    out+=$chr
  done

  printf '%s' "$out"
}

unmangle() {
  local i= chr= out= len=$(( ${#1} - 4 ))

  unset {a..f} {A..F}

  for (( i = 0; i < len; i++ )); do
    chr=${1:i:1}
    case $chr in
      \\)
        if valid_number_of_base 8 "${1:i+1:3}" ||
            valid_number_of_base 16 "${1:i+1:3}"; then
          printf -v chr '%b' "${1:i:4}"
          (( i += 3 ))
        fi
        ;;
    esac
    out+=$chr
  done

  printf '%s' "$out${1:i}"
}

optstring_match_option() {
  local candidate pat patterns

  IFS=, read -ra patterns <<<"$1"
  for pat in "${patterns[@]}"; do
    if [[ $pat = *=* ]]; then
      # "key=val" will only ever match "key=val"
      candidate=$2
    else
      # "key" will match "key", but also "key=anyval"
      candidate=${2%%=*}
    fi

    [[ $pat = "$candidate" ]] && return 0
  done

  return 1
}

optstring_remove_option() {
  local o options_ remove=$2 IFS=,

  read -ra options_ <<<"${!1}"

  for o in "${!options_[@]}"; do
    optstring_match_option "$remove" "${options_[o]}" && unset 'options_[o]'
  done

  declare -g "$1=${options_[*]}"
}

optstring_normalize() {
  local o options_ norm IFS=,

  read -ra options_ <<<"${!1}"

  # remove empty fields
  for o in "${options_[@]}"; do
    [[ $o ]] && norm+=("$o")
  done

  # avoid empty strings, reset to "defaults"
  declare -g "$1=${norm[*]:-defaults}"
}

optstring_append_option() {
  if ! optstring_has_option "$1" "$2"; then
    declare -g "$1=${!1},$2"
  fi

  optstring_normalize "$1"
}

optstring_prepend_option() {
  local options_=$1

  if ! optstring_has_option "$1" "$2"; then
    declare -g "$1=$2,${!1}"
  fi

  optstring_normalize "$1"
}

optstring_get_option() {
  local opts o

  IFS=, read -ra opts <<<"${!1}"
  for o in "${opts[@]}"; do
    if optstring_match_option "$2" "$o"; then
      declare -g "$o"
      return 0
    fi
  done

  return 1
}

optstring_has_option() {
  local "${2%%=*}"

  optstring_get_option "$1" "$2"
}

dm_name_for_devnode() {
  read dm_name <"/sys/class/block/${1#/dev/}/dm/name"
  if [[ $dm_name ]]; then
    printf '/dev/mapper/%s' "$dm_name"
  else
    # don't leave the caller hanging, just print the original name
    # along with the failure.
    print '%s' "$1"
    error 'Failed to resolve device mapper name for: %s' "$1"
  fi
}

fstype_is_pseudofs() {
  (( pseudofs_types["$1"] ))
}

fstype_has_fsck() {
  (( fsck_types["$1"] ))
}


usage() {
  cat <<EOF
usage: ${0##*/} chroot-dir [command]

    -h                  Print this help message
    -u <user>[:group]   Specify non-root user and optional group to use

If 'command' is unspecified, ${0##*/} will launch /bin/bash.

EOF
}

chroot_add_resolv_conf() {
  local chrootdir=$1 resolv_conf=$1/etc/resolv.conf

  # Handle resolv.conf as a symlink to somewhere else.
  if [[ -L $chrootdir/etc/resolv.conf ]]; then
    # readlink(1) should always give us *something* since we know at this point
    # it's a symlink. For simplicity, ignore the case of nested symlinks.
    resolv_conf=$(readlink "$chrootdir/etc/resolv.conf")
    if [[ $resolv_conf = /* ]]; then
      resolv_conf=$chrootdir$resolv_conf
    else
      resolv_conf=$chrootdir/etc/$resolv_conf
    fi

    # ensure file exists to bind mount over
    if [[ ! -f $resolv_conf ]]; then
      install -Dm644 /dev/null "$resolv_conf" || return 1
    fi
  elif [[ ! -e $chrootdir/etc/resolv.conf ]]; then
    # The chroot might not have a resolv.conf.
    return 0
  fi

  chroot_add_mount /etc/resolv.conf "$resolv_conf" --bind
}

while getopts ':hu:' flag; do
  case $flag in
    h)
      usage
      exit 0
      ;;
    u)
      userspec=$OPTARG
      ;;
    :)
      die '%s: option requires an argument -- '\''%s'\' "${0##*/}" "$OPTARG"
      ;;
    ?)
      die '%s: invalid option -- '\''%s'\' "${0##*/}" "$OPTARG"
      ;;
  esac
done
shift $(( OPTIND - 1 ))

(( EUID == 0 )) || die 'This script must be run with root privileges'
(( $# )) || die 'No chroot directory specified'
chrootdir=$1
shift

[[ -d $chrootdir ]] || die "Can't create chroot on non-directory %s" "$chrootdir"

chroot_setup "$chrootdir" || die "failed to setup chroot %s" "$chrootdir"
chroot_add_resolv_conf "$chrootdir" || die "failed to setup resolv.conf"

chroot_args=()
[[ $userspec ]] && chroot_args+=(--userspec "$userspec")
chroot_args+=("$chrootdir" "$@")

export HOME=/home/$SUDO_USER
SHELL=/usr/bin/bash unshare --fork --pid chroot --userspec $SUDO_USER:$SUDO_USER "${chroot_args[@]}"
