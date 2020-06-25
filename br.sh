br=10
brctl addbr br$br
ifconfig br$br 192.168.$br.1/24 up
chmod u+s /usr/lib/qemu/qemu-bridge-helper
mkdir -p /etc/qemu
echo "allow br$br" >> /etc/qemu/bridge.conf
