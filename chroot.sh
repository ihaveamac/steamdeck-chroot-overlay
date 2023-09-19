#!/bin/bash
if [ ! -e fs-root-base ]; then
        echo "fs-root-base doesn't exist!"
        echo "use makefsroot.sh first"
        exit
fi


if [[ "$(id -u)" -ne 0 ]]; then
        echo "$(basename $0) needs to be run as root"
        sudo bash "$0" "$*"
        exit
fi

set -ex

./makebinds.sh
arch-chroot ./bindmount
./unmakebinds.sh
