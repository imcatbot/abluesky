#! /bin/bash 

# Coded by Jiang Wei
# Build a Live CD against stander Debian Live CD


CURRENT_DIR=`pwd`
BUILD_DIR=build

# Create build directory 
mkdir -p $BUILD_DIR/newchroot
mkdir -p $BUILD_DIR/newcd
mkdir -p $BUILD_DIR/newcd/live

# Copy filesystem to newchroot for building
(cd $BUILD_DIR/chroot && tar -cf - --exclude=var/cache/apt/archives/* --exclude=usr/share/doc/* . )| tar -x -C $BUILD_DIR/newchroot

# Clean up filesystem

# Re-package filesystem
mksquashfs $BUILD_DIR/newchroot $BUILD_DIR/newcd/live/filesystem.squashfs

rm -rf $BUILD_DIR/newchroot

# Copy 3rdparty
cp -a 3rdparty/isolinux $BUILD_DIR/newcd/

cp -a $BUILD_DIR/orig_cd/live/initrd* $BUILD_DIR/newcd/live
cp -a $BUILD_DIR/orig_cd/live/vmlinuz* $BUILD_DIR/newcd/live

# Build iso

genisoimage -l -o abluesky.iso  \
-b isolinux/isolinux.bin -c isolinux/boot.cat \
-no-emul-boot -boot-load-size 4 -boot-info-table \
build/newcd/

rm -rf build/newcd/

echo Done

