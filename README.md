# SteamOS chroot overlay

This creates a chroot environment based on the root filesystem, with overlays for some directories. This is useful in some cases like creating a systemd-sysext extension with packages that are installed properly.

This could probably work on standard Arch Linux but I didn't test it, plus this is only really useful on SteamOS with its read-only partition.

Super not tested and probably buggy!!!

## Usage

Before chrooting, if you are using systemd-sysext, you might want to do `systemd-sysext unmerge` first, or the chroot will not see the real root fs.

* ./makefsroot.sh
* ./chroot.sh

now use upper-dirs as the basis for your extension

## Extensions

To make an extension use `./makeextension.sh <ext-name>`; this will check for file dupes compared to the root fs, so the extension will only include new or different files.
