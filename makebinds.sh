#!/bin/bash
if [ -e bindmount ]; then
        echo "bindmount already exists!"
        exit
fi
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

set -x

#echo "Bind mount: ./overlayed-fs-tree -> ./bindmount"
mkdir bindmount
mount --bind ./fs-root-base ./bindmount
for f in etc usr var; do
	#echo "Overlay mount: $f -> ./bindmount/$f"
	mount -t overlay overlay -o lowerdir=/$f,upperdir=$PWD/upper-dirs/$f,workdir=$PWD/work-dirs/$f ./bindmount/$f
done
#echo "Bind mount: /home/.steamos/offload/var/cache/pacman -> ./bindmount/var/cache/pacman"
mount --bind /home/.steamos/offload/var/cache/pacman ./bindmount/var/cache/pacman
