#!/bin/bash

[ -e bootstrap/boot.img ] && rm bootstrap/boot.img
[ -e update.zip ] && rm update.zip

pushd bootstrap/ramdisk/
find . | cpio -o -H newc | gzip > ../device/ramdisk.cpio.gz
popd

pushd bootstrap/recovery/
find . | cpio -o -H newc | gzip > ../device/ramdisk-recovery.cpio.gz
popd

pushd bootstrap/device
find . | cpio -o -H newc | gzip > ../bootstrap.cpio.gz
popd

tools/mkbootimg --kernel bootstrap/zImage --ramdisk bootstrap/bootstrap.cpio.gz --cmdline "console=ttySAC2,115200 consoleblank=0" --base 0x10000000 --pagesize 4096 --output bootstrap/boot.img

pushd bootstrap
zip -r ../update.zip boot.img META-INF/
popd
exit 0
