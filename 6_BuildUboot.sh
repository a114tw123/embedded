uBootVer=u-boot-2016.11
workDir=/usr/src
outDir=../
[ ! -f $workDir/$uBootVer.tar.bz2 ] && echo "NotFoundFile Downloading" &&  wget -P $workDir ftp://ftp.denx.de/pub/u-boot/$uBootVer.tar.bz2 
tar xfva  $workDir/$uBootVer.tar.bz2 -C /usr/src/
cp ./vexpress_common.h $workDir/$uBootVer/include/configs/
make -C $workDir/$uBootVer ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- vexpress_ca9x4_defconfig
make -C $workDir/$uBootVer CROSS_COMPILE=arm-linux-gnueabihf- -j 8
cp $workDir/$uBootVer/u-boot /mnt/sdcard1
cp $workDir/$uBootVer/u-boot.bin /mnt/sdcard1
cp $workDir/$uBootVer/u-boot ./u-boot
