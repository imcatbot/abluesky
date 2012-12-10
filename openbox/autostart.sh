#!/bin/sh

#启动输入法
fcitx &

#启动任务栏
lxpanel &

#启动浏览器
(sleep 2 && iceweasel) &

#启动网络管理器
(sleep 2 && wicd-gtk) &

#设置一张壁纸
feh --bg-scale /usr/share/wallpagers/default-bg.jpg
