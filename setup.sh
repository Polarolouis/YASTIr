#!/bin/sh
# Script from https://layereight.de/raspberry-pi/2016/08/25/raspbian-rtl8812au.html , I added the installation of flex and bison because they are necessary for rpi-source to work properly
# install necessary software
sudo apt-get update
sudo apt-get install bc git flex bison

# download raspbian kernel sources, takes some minutes
sudo wget "https://raw.githubusercontent.com/notro/rpi-source/master/rpi-source" -O /usr/bin/rpi-source
sudo chmod 755 /usr/bin/rpi-source
rpi-source

# download the rtl8812au kernel driver and compile it, takes some minutes
git clone "https://github.com/gnab/rtl8812au"
cd rtl8812au
sed -i 's/CONFIG_PLATFORM_I386_PC = y/CONFIG_PLATFORM_I386_PC = n/g' Makefile
sed -i 's/CONFIG_PLATFORM_ARM_RPI = n/CONFIG_PLATFORM_ARM_RPI = y/g' Makefile
make

# copy the driver and use it
sudo cp 8812au.ko /lib/modules/`uname -r`/kernel/drivers/net/wireless
sudo depmod -a
sudo modprobe 8812au
echo Driver installed
