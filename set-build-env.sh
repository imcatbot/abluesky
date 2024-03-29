#! /bin/bash

# Coded by Jiang Wei
# Build a Live CD against stander Debian Live CD


CURRENT_DIR=`pwd`
BUILD_DIR=build

# Check ISO in cache directory, download from website of debian if not exist
isos=`find cache -maxdepth 1 -iname "debian*.iso"`
ORIG_ISO=

for iso in ${isos}
do
    if [ -e "${iso}" ]
    then
	ORIG_ISO=${CURRENT_DIR}/${iso}
	break
    fi
done

echo $ORIG_ISO

# Create build directory 
mkdir -p $BUILD_DIR
mkdir -p $BUILD_DIR/mnt
mkdir -p $BUILD_DIR/mnt_fs
mkdir -p $BUILD_DIR/chroot
mkdir -p $BUILD_DIR/orig_cd

mount -o loop $ORIG_ISO $BUILD_DIR/mnt
ORIG_FILESYSTEM=$BUILD_DIR/mnt/live/filesystem.squashfs
mount -o loop $ORIG_FILESYSTEM $BUILD_DIR/mnt_fs

# Copy all files from CD beside filesystem
(cd $BUILD_DIR/mnt && tar -cf - --exclude=live/filesystem.squashfs . )| tar -x -C $BUILD_DIR/orig_cd

# Copy filesystem to chroot for building
(cd $BUILD_DIR/mnt_fs && tar -cf - . )| tar -x -C $BUILD_DIR/chroot

#umount iso
umount $BUILD_DIR/mnt_fs
umount $BUILD_DIR/mnt

echo "Build directory is created in build"
echo 
