echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
Disk=`fdisk -l|grep "Linux"|grep "sd"|sed 's/\// /g'|awk '{print $2}'|awk '{print substr($1,1,3)}'|sort -u`;EmptyDisk=`fdisk -l|grep -u "/dev/sd"|grep -v "Linux"|grep -v $Disk|awk '{print $2}'|sed 's/://g'`;[ "$EmptyDisk" = "" ] && echo "None" || echo $EmptyDisk
