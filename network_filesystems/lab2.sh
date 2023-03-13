#!/usr/bin/env bash

sudo apt update
sudo apt-get install nfs-common -y

useradd -m -u 2001 testuser1
useradd -m -u 2002 testuser2

# nfs
# sudo mount lab1:/home /mnt
# cat /mnt/testuser1/test.txt
# sudo mount -l | grep lab1
# sudo umount /mnt

# samba cifs
sudo apt install -y cifs-utils
# sudo mount -t cifs //lab1/testuser1 /mnt -o username=testuser1,password=123456,vers=3.0
# cat /mnt/test.txt
# sudo mount -t cifs //lab1/home/testuser1 /mnt -o username=testuser1,password=123456,vers=3.0 # not working but it is the requirement
# sudo umount /mnt

# samba smbclient
sudo apt install -y smbclient
# smbclient //lab1/testuser1 -U testuser1

# sshfs
apt install sshfs -y
sudo -u testuser1 mkdir /home/testuser1/mnt
# sudo -u testuser1 chmod 600  /home/testuser1/.ssh/me
# sudo -u testuser1 ssh -i /home/testuser1/.ssh/me vagrant@lab1
# todo: add private key
sudo -u testuser1 tee -a /home/testuser1/.ssh/me << EOF

EOF

# sudo -u testuser1 sshfs -o IdentityFile=/home/testuser1/.ssh/me vagrant@lab1:/home/testuser1 /home/testuser1/mnt
# sudo -u testuser1 cat /home/testuser1/mnt/test.txt

# sudo -u testuser1 fusermount -u /home/testuser1/mnt
# sudo -u testuser1 umount /home/testuser1/mnt


# WebDAV
sudo apt install cadaver elinks -y
sudo -u vagrant tee -a /home/vagrant/lab2.txt > /dev/null <<EOF
from lab2
EOF
# cadaver http://lab1/webdav
# testuser
# 123456
# put /home/vagrant/lab2.txt
# set editor vim
# edit test.txt

# sudo apt-get install davfs2 -y
# sudo mkdir /mnt/webdav
# sudo tee -a /etc/davfs2/davfs2.conf <<< "use_locks 0" # disable file locking
#sudo mount -t davfs http://lab1/webdav /mnt/webdav -o username=testuser <<< "123456"
# sudo cat /mnt/webdav/test.txt
# sudo umount /mnt/webdav


# RAID5
# sudo mkdir /mnt/nfs
# sudo mount -t nfs lab1:/mnt/nfs /mnt/nfs
# sudo cp /home/vagrant/lab2.txt /mnt/nfs/lab2.txt
# sudo cat /mnt/nfs/lab2.txt
# sudo umount /mnt/nfs