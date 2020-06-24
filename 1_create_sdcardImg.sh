#!/bin/bash
file="./sdcard.img"
OldFile="./sdcard.img.OLD"
sdSize=150M
p1Size=10M
p2Size=120M
Debug=0

p1_sector=0
p2_sector=0
p3_sector=0
p1_offect=0
p2_offect=0
p3_offect=0
p_Sector_Size=0

[ -f $OldFile ] && rm -rf $OldFile
[ -f $file  ] && mv $file $OldFile

fallocate  $file  -l $sdSize
chmod 777 $file
cat > /tmp/fdisk.parm << EOF
n
p
1

+$p1Size
n
p
2

+$p2Size
n
p
3


t
1
b
t
3
82
w
EOF

[ $Debug == 0 ] && fdisk $file < /tmp/fdisk.parm > /dev/null || fdisk $file < /tmp/fdisk.parm 

# fdisk $file < /tmp/fdisk.parm > /dev/null

p1_offect=`fdisk -lu  $file | grep img1 | tr -s " " | cut -d " " -f2`
p2_offect=`fdisk -lu  $file | grep img2 | tr -s " " | cut -d " " -f2`
p3_offect=`fdisk -lu  $file | grep img3 | tr -s " " | cut -d " " -f2`

p1_sector=`fdisk -lu  $file | grep img1 | tr -s " " | cut -d " " -f4`
p2_sector=`fdisk -lu  $file | grep img2 | tr -s " " | cut -d " " -f4`
p3_sector=`fdisk -lu  $file | grep img3 | tr -s " " | cut -d " " -f4`

p_Sector_Size=`fdisk -lu $file | grep "Sector size" | cut -d ":" -f2 | cut -d " " -f2`

[ $Debug == 1 ] && echo $p1_offect , $p1_sector , $p2_offect , $p2_sector , $p_Sector_Size

[ ! -d /mnt/sdcard1 ] && mkdir /mnt/sdcard1
[ ! -d /mnt/sdcard2 ] && mkdir /mnt/sdcard2

umount /mnt/sdcard1 /mnt/sdcard2 > /dev/null

losetup -d /dev/loop1 > /dev/null
sleep 1
losetup -d /dev/loop2 > /dev/null
sleep 1
losetup -d /dev/loop3 > /dev/null

losetup -o `expr $p1_offect \* $p_Sector_Size` /dev/loop1 $file
losetup -o `expr $p2_offect \* $p_Sector_Size` /dev/loop2 $file
losetup -o `expr $p3_offect \* $p_Sector_Size` /dev/loop3 $file

mkfs.msdos -F 32 /dev/loop1 `expr $p1_sector / 2`
#mkfs.ext4 /dev/loop2
mkfs.ext4 /dev/loop2 `expr $p2_sector / 2`
mkswap /dev/loop3

losetup -d /dev/loop3

mount /dev/loop1 /mnt/sdcard1
mount /dev/loop2 /mnt/sdcard2
df -h
