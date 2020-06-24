echo "umounting"
umount /mnt/sdcard1 
umount /mnt/sdcard2
losetup -d /dev/loop1
sleep 1 
losetup -d /dev/loop2

file="./sdcard.img"
echo "mounting"

p1_offect=`fdisk -lu  $file | grep img1 | tr -s " " | cut -d " " -f2`
p2_offect=`fdisk -lu  $file | grep img2 | tr -s " " | cut -d " " -f2`

p1_sector=`fdisk -lu  $file | grep img1 | tr -s " " | cut -d " " -f4`
p2_sector=`fdisk -lu  $file | grep img2 | tr -s " " | cut -d " " -f4`

p_Sector_Size=`fdisk -lu ../sdcard.img | grep "Sector size" | cut -d ":" -f2 | cut -d " " -f2`

echo $p1_offect , $p1_sector , $p2_offect , $p2_sector , $p_Sector_Size
losetup -o `expr $p1_offect \* $p_Sector_Size` /dev/loop1 $file
losetup -o `expr $p2_offect \* $p_Sector_Size` /dev/loop2 $file


mount /dev/loop1 /mnt/sdcard1
mount /dev/loop2 /mnt/sdcard2
