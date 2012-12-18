#! /bin/bash 

# Coded by Jiang Wei
# Build a Live CD against stander Debian Live CD


CURRENT_DIR=`pwd`
BUILD_DIR=build

GFXBOOT_FONT=/home/catbot/develop/abluesky/gfxboot/gfxboot-font
FONT_PATH=/usr/share/fonts/xpfonts
FONT_NAME=simhei

# Create build directory 
mkdir -p $BUILD_DIR/newchroot
mkdir -p $BUILD_DIR/newcd
mkdir -p $BUILD_DIR/newcd/live
mkdir -p $BUILD_DIR/tmp

# Copy filesystem to newchroot for building
(cd $BUILD_DIR/chroot && tar -cf - --exclude=var/cache/apt/archives/* --exclude=usr/share/doc/* . )| tar -x -C $BUILD_DIR/newchroot

# Clean up filesystem

# Re-package filesystem
mksquashfs $BUILD_DIR/newchroot $BUILD_DIR/newcd/live/filesystem.squashfs

rm -rf $BUILD_DIR/newchroot

# Copy 3rdparty
cp -a 3rdparty/isolinux $BUILD_DIR/newcd/

# Create gfxboot message
cp -a 3rdparty/gfxboot-message/ $BUILD_DIR/
(cd $BUILD_DIR/gfxboot-message && cat addon.txt anscii.txt translations.zh_CN zh_CN.hlp > chs.txt)
(cd $BUILD_DIR/gfxboot-message && ${GFXBOOT_FONT} -v -t chs.txt -p ${FONT_PATH} -f ${FONT_NAME} 16x16.fnt >16x16.fnt.log)
(cd $BUILD_DIR/gfxboot-message && find .|cpio -o > $BUILD_DIR/newcd/isolinux/message)

# Clean gfxboot message
rm -rf $BUILD_DIR/gfxboot-message

cp -a $BUILD_DIR/orig_cd/live/initrd* $BUILD_DIR/newcd/live
cp -a $BUILD_DIR/orig_cd/live/vmlinuz* $BUILD_DIR/newcd/live

# Build iso

genisoimage -l -o abluesky.iso  \
-b isolinux/isolinux.bin -c isolinux/boot.cat \
-no-emul-boot -boot-load-size 4 -boot-info-table \
build/newcd/

rm -rf build/newcd/

echo Done

