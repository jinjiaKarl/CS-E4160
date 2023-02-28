#!/usr/bin/env bash

sudo apt update
sudo apt-get install nfs-common -y

useradd -m -u 1001 testuser1
useradd -m -u 1002 testuser2

# nfs
sudo mount lab1:/home /mnt
sudo umount /mnt

# samba cifs
sudo apt install -y cifs-utils
sudo mount -t cifs //lab1/testuser1 /mnt -o username=testuser1,password=123456,vers=3.0
sudo umount /mnt

# samba smbclient
# sudo apt install -y smbclient
# smbclient //lab1/testuser1 -U testuser1

# sshfs
apt install sshfs -y
su testuser1
mkdir /home/testuser1/mnt
exit
sshfs jinjia@lab1:/home/testuser1 /home/testuser1/mnt
# fusermount -u /home/testuser1/mnt
# umount /home/testuser1/mnt


# WebDAV
sudo apt install cadaver
cadaver http://lab1/WebDAV