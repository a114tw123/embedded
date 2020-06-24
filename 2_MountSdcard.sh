#!/bin/bash
file="./sdcard.img"
p1_sector=0
p2_sector=0
p1_offect=0
p2_offect=0
p_Sector_Size=0
# fdisk $file < /tmp/fdisk.parm > /dev/null

p1_offect=`fdisk -lu  $file | grep img1 | tr -s " " | cut -d " " -f2`
p2_offect=`fdisk -lu  $file | grep img2 | tr -s " " | cut -d " " -f2`

p1_sector=`fdisk -lu  $file | grep img1 | tr -s " " | cut -d " " -f4`
p2_sector=`fdisk -lu  $file | grep img2 | tr -s " " | cut -d " " -f4`

p_Sector_Size=`fdisk -lu $file | grep "Sector size" | cut -d ":" -f2 | cut -d " " -f2`

[ $Debug == 1 ] && echo $p1_offect , $p1_sector , $p2_offect , $p2_sector , $p_Sector_Size

[ ! -d /mnt/sdcard1 ] && mkdir /mnt/sdcard1
[ ! -d /mnt/sdcard2 ] && mkdir /mnt/sdcard2

umount /mnt/sdcard1 /mnt/sdcard2 > /dev/null

losetup -d /dev/loop1 > /dev/null
sleep 1
losetup -d /dev/loop2 > /dev/null

losetup -o `expr $p1_offect \* $p_Sector_Size` /dev/loop1 $file
losetup -o `expr $p2_offect \* $p_Sector_Size` /dev/loop2 $file

mount /dev/loop1 /mnt/sdcard1
mount /dev/loop2 /mnt/sdcard2
df -h
