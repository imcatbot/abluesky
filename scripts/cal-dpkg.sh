#! /bin/bash

K=1024
M=`expr $K \* 1024`
#echo "Calculate dpkg packages ..."

packages=`dpkg -l|grep ^ii|cut -d " " -f3|cut -d":" -f1`

for p in $packages
do
    files=`dpkg -L $p`
    total_size=0
    for f in $files
    do
	if [ -f ${f} ]
	then
	    size=`ls -l $f |cut -d " " -f5`
	    total_size=`expr $size + $total_size`
	fi
    done
    echo -e "$p\t\t\t\t$total_size"
#    break
done
