# SteamOS chroot overlay

This creates a chroot environment based on the root filesystem, with overlays for some directories. This is useful in some cases like creating a systemd-sysext extension with packages that are installed properly.

This could probably work on standard Arch Linux but I didn't test it, plus this is only really useful on SteamOS with its read-only partition.

Super not tested and probably buggy!!!

## Usage

./makefsroot.sh

./makebinds.sh

sudo arch-chroot ./bindmount

(do your stuff)

./unmakebinds.sh

now use upper-dirs as the basis for your extension
