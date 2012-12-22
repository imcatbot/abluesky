#! /bin/bash 

# Coded by Jiang Wei
# Build a Live CD against stander Debian Live CD


CURRENT_DIR=`pwd`
BUILD_DIR=${CURRENT_DIR}/build

GFXBOOT_FONT_BIN=${BUILD_DIR}/gfxboot/gfxboot-font
FONT_PATH=${CURRENT_DIR}/3rdparty/fonts/
FONT_NAME=simhei

# Create build directory 
mkdir -p $BUILD_DIR/newchroot
mkdir -p $BUILD_DIR/newcd
mkdir -p $BUILD_DIR/newcd/live
mkdir -p $BUILD_DIR/tmp

# Copy filesystem to newchroot for building
(cd $BUILD_DIR/chroot && tar -cf - --exclude=var/cache/apt/archives/* --exclude=usr/share/doc/* . )| tar -x -C $BUILD_DIR/newchroot

# Set backgroud image
mkdir -p ${BUILD_DIR}/newchroot/usr/share/wallpagers/
cp ${CURRENT_DIR}/images/* ${BUILD_DIR}/newchroot/usr/share/wallpagers/
(cd ${BUILD_DIR}/newchroot/usr/share/wallpagers/ && ln -s mars.jpg default-bg.jpg)


# Create a customized skel
mkdir -p ${BUILD_DIR}/newchroot/etc/skel/.config

# Customize openbox
cp -a ${CURRENT_DIR}/skel_config/openbox/ ${BUILD_DIR}/newchroot/etc/skel/.config/

# Customize lxpanel
cp -a ${CURRENT_DIR}/skel_config/lxpanel ${BUILD_DIR}/newchroot/etc/skel/.config/

# Copy ROX config
cp -a ${CURRENT_DIR}/skel_config/rox.sourceforge.net ${BUILD_DIR}/newchroot/etc/skel/.config/

# Copy Xresource
cp -a ${CURRENT_DIR}/skel_config/dotXresources ${BUILD_DIR}/newchroot/etc/skel/.Xresources

# Re-package filesystem
mksquashfs $BUILD_DIR/newchroot $BUILD_DIR/newcd/live/filesystem.squashfs

rm -rf $BUILD_DIR/newchroot

# Copy 3rdparty
cp -a 3rdparty/isolinux $BUILD_DIR/newcd/

# Compile gfxboot binary if it is not yet
SYS_GFXBOOT_FONT_BIN=`which gfxboot-font`
if [ ${SYS_GFXBOOT_FONT_BIN} = "" ]
then
    cp -a 3rdparty/gfxboot ${BUILD_DIR}/
    (cd ${BUILD_DIR}/gfxboot && make )
else
    GFXBOOT_FONT_BIN=${SYS_GFXBOOT_FONT_BIN}
fi

# Create gfxboot message
cp -a 3rdparty/gfxboot-message/ $BUILD_DIR/
(cd $BUILD_DIR/gfxboot-message && cat addon.txt anscii.txt translations.zh_CN zh_CN.hlp zh_CN.tr > chs.txt)
(cd $BUILD_DIR/gfxboot-message && ${GFXBOOT_FONT_BIN} -v -t chs.txt -p ${FONT_PATH} -f ${FONT_NAME} 16x16.fnt >16x16.fnt.log)
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

