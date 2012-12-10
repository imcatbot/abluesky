MY_PACKAGE_LIST=${CURRENT_DIR}/fish.list
XINITRC=${CURRENT_DIR}/openbox/xinitrc
OPENBOX_START=${CURRENT_DIR}/openbox/autostart.sh

cp ${MY_PACKAGE_LIST} config/package-lists

# Create user skel
mkdir -p config/chroot_local-includes/etc/skel
mkdir -p config/chroot_local-includes/etc/skel/.config/openbox

cp ${XINITRC} config/chroot_local-includes/etc/skel/.xinitrc
cp ${OPENBOX_START} config/chroot_local-includes/etc/skel/.config/openbox/autostart.sh
