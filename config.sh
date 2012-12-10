#! /bin/bash
#
# Coded by Jiang Wei
#

LINUX_FLAVOURS="686"
WINDOW_MANAGE="openbox"

CURRENT_DIR=`pwd`

if [ `uname -m` == 'x86_64' ]
then
    LINUX_FLAVOURS="amd64"
fi

mkdir build
pushd build

lb config --apt-recommends false --bootappend-live "locales=zh_CN.GBK" \
    --cache-indices true --linux-flavours ${LINUX_FLAVOURS} \
    --memtest none --force true

if [ ${WINDOW_MANAGE} == 'openbox' ]
then
    source ${CURRENT_DIR}/${WINDOW_MANAGE}/settings.part  
fi

# Common files
mkdir -p config/chroot_local-includes/usr/share/wallpagers/
cp ${CURRENT_DIR}/images/default-bg.jpg config/chroot_local-includes/usr/share/wallpagers/

popd

echo 
echo "Environment is ready now, run lb build to your live cd!"
echo
