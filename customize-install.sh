#! /bin/bash

# Coded by Jiang Wei
# this script to install packages against *.list to user's chroot

DEBUG=true

echo "Start install packages"

DEB_SOURCE="deb http://http.us.debian.org/debian wheezy main contrib non-free"

PACKAGES=
for line in `cat *.list`
do
    if echo "$line" | grep "^#" >/dev/null 2>&1
    then
	continue
    fi
    PACKAGES="$PACKAGES $line"
done

#debug 
if "$DEBUG" = "true" ]
then
    echo $PACKAGES
    exit
fi

# Chroot
chroot build/chroot
echo "${DEB_SOURCE}" > /etc/apt/source.list
echo "nameserver 8.8.8.8" > /etc/resolve.conf

apt-get update

apt-get install ${PACKAGES} >install.log

# Exit chroot
exit

echo "Install completed"
echo 
