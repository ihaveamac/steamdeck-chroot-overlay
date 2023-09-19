if [[ -z "$1" ]]; then
	echo "$0 extension-name"
	echo "would make extension-name.raw"
	exit 1
fi

set -ex

sudo python3 finddupes.py > exclude.txt

rm $1.raw || true
mksquashfs upper-dirs $1.raw \
	-noappend -no-duplicates -comp zstd \
	-p "/usr/lib/extension-release.d d 754 0 0" \
	-p "/usr/lib/extension-release.d/extension-release.$1 f 644 0 0 grep '^\(ID\|VERSION_ID\)=' /etc/os-release" \
	-ef exclude.txt -e etc -e var \
