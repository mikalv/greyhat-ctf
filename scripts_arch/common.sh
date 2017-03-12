#!/bin/sh
#
# File: common.sh
# Purpose: common configuration and shell functions
#
source config.sh


test "$SUDO_USER" && as_user="sudo -u $SUDO_USER" || as_user=


msg() {
    echo '[*]' $*
}

cmd() {
    echo '[cmd]' $*
    $*
}

error() {
    echo '[E]' $*
    exit 1
}

exit_if_nonroot() {
    test $(id -u) = 0 || error this script needs to run as root
}

get_tcz() {
    $as_user mkdir -pv $tcz_dir
    for package; do
        target=$tcz_dir/$package.tcz
        if test ! -f $target; then
            msg fetching package $package ...
            $as_user curl -o $target $tcz_url/$package.tcz
        fi
        dep=$target.dep
        if test ! -f $dep; then
            msg fetching dep list of $package ...
            $as_user curl -o $dep $tcz_url/$package.tcz.dep || touch $dep
            grep -q 404 $dep && >$dep
            if test -s $dep; then
                get_tcz $(sed -e s/.tcz$// $dep)
            fi
        fi
    done
}

install_tcz() {
    get_tcz $@
    exit_if_nonroot
    for package; do
        target=$tcz_dir/$package.tcz
        tce_marker=$extract/usr/local/tce.installed/$package
        if ! test -f $tce_marker; then
            msg installing package $package ...
            unsquashfs -f -d $extract $target
            if test -s $tce_marker; then
                chroot $extract /usr/local/tce.installed/$package
            else
                touch $tce_marker
            fi
        fi
        dep=$target.dep
        if test -s $dep; then
            install_tcz $(sed -e s/.tcz$// $dep)
        fi
    done
}


for i in "$@"; do
    case "$i" in
        -h|--help) usage ; exit 1 ;;
    esac
done

# eof
