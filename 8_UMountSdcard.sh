echo "umounting"
umount /mnt/sdcard1 
umount /mnt/sdcard2
umount /mnt/sdcard3
losetup -d /dev/loop1 
losetup -d /dev/loop2
losetup -d /dev/loop3
df -h
