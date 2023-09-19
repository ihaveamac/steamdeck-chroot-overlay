#!/bin/bash
if [[ "$(id -u)" -ne 0 ]]; then
    echo "$(basename $0) needs to be run as root"
    sudo bash "$0" "$*"
    exit
fi

mkdir ./fs-root-base
for f in dev etc proc run sys tmp usr var home; do
	mkdir ./fs-root-base/$f
done

mkdir ./upper-dirs ./work-dirs
for f in usr etc var; do
	mkdir ./upper-dirs/$f
	mkdir ./work-dirs/$f
done

ln -s usr/bin ./fs-root-base/bin
ln -s usr/lib ./fs-root-base/lib
ln -s usr/lib ./fs-root-base/lib64
ln -s usr/bin ./fs-root-base/sbin
ln -s var/mnt ./fs-root-base/mnt
mkdir ./fs-root-base/home/deck
chown deck:deck ./fs-root-base/home/deck
