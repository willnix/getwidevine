#!/usr/bin/bash
curl -s https://dl.google.com/dl/edgedl/chromeos/recovery/recovery.conf | grep -A 12 'Acer Chromebook R13' | grep -o 'https.*' | xargs curl | zcat > /tmp/image.bin
mkdir /tmp/chromeos
MOUNTCMD=$(fdisk -l /tmp/image.bin 2> /dev/null | grep 'bin3 ' | awk '{print "mount -o loop,ro,offset="$2*512" /tmp/image.bin /tmp/chromeos"}')
echo $MOUNTCMD
$(sudo $MOUNTCMD)
cp /tmp/chromeos/opt/google/chrome/libwidevinecdm*.so .
cp /tmp/chromeos/opt/google/chrome/pepper/* .
sudo umount /tmp/chromeos
rmdir /tmp/chromeos
rm /tmp/image.bin
