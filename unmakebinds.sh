#!/bin/bash
if [ ! -e bindmount ]; then
        echo "bindmount doesn't exist!"
        exit
fi


if [[ "$(id -u)" -ne 0 ]]; then
	echo "$(basename $0) needs to be run as root"
	sudo bash "$0" "$*"
	exit
fi

set -x

#echo "Bind unmount: /home/.steamos/offload/var/cache/pacman -> ./bindmount/var/cache/pacman"
umount ./bindmount/var/cache/pacman
for f in etc usr var; do
	#echo "Overlay unmount: $f -> ./bindmount/$f"
	umount ./bindmount/$f
done
#echo "Bind unmount: ./bindmount"
umount ./bindmount
rmdir bindmount
