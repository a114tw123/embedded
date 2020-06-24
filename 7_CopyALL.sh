ROOTFS_DIR=./rootfs
rsync -av $ROOTFS_DIR/ /mnt/sdcard2 --delete

KerneVer=linux-3.18.131
workDir=/usr/src
#cp $workDir/$KerneVer/arch/arm/boot/uImage /mnt/sdcard1
#cp $workDir/$KerneVer/arch/arm/boot/zImage /mnt/sdcard1
#rsync -av $workDir/$KerneVer/Cmodules/lib/modules /mnt/sdcard2/lib

