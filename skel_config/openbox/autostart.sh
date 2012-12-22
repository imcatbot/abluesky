#!/bin/sh

# 调节键盘速度
xset r rate 280 30

#启动任务栏
lxpanel &

#启动浏览器
(sleep 2 && iceweasel) &

#启动网络管理器
(sleep 2 && wicd-gtk) &

#设置一张壁纸
feh --bg-scale /usr/share/wallpagers/default-bg.jpg

rox -S &

xcompmgr -Ss -n -Cc -fF -I-10 -O-10 -D1 -t-3 -l-4 -r4 &
