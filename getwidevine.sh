#!/usr/bin/bash
# download and unzip recovery for acer r13 (ARMv8)
curl -s https://dl.google.com/dl/edgedl/chromeos/recovery/recovery.conf | grep -A 12 'Acer Chromebook R13' | grep -o 'https.*' | xargs curl | zcat > /tmp/image.bin

mkdir /tmp/chromeos

# mount the third partition of the image file
MOUNTCMD=$(fdisk -l /tmp/image.bin 2> /dev/null | grep 'bin3 ' | awk '{print "mount -o loop,ro,offset="$2*512" /tmp/image.bin /tmp/chromeos"}')
echo $MOUNTCMD
$(sudo $MOUNTCMD)

# get what we came for
cp /tmp/chromeos/opt/google/chrome/libwidevinecdm*.so .
cp /tmp/chromeos/opt/google/chrome/pepper/* .
# get libwidevine version
strings /tmp/chromeos/opt/google/chrome/chrome | grep -P '^\d\.\d\.\d\.\d\d\d$' > widevine.version

# clean up
sudo umount /tmp/chromeos
rmdir /tmp/chromeos
rm /tmp/image.bin
