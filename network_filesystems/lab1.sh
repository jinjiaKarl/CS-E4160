#!/usr/bin/env bash

sudo apt update
sudo apt install nfs-kernel-server -y

# useradd vs adduser  注意生成家目录的权限
useradd -m -u 2001 testuser1
useradd -m -u 2002 testuser2

# nfs
sudo tee -a /etc/exports > /dev/null <<EOF
/home *(rw,sync,no_subtree_check)
EOF

sudo systemctl restart nfs-kernel-server
sudo -u testuser1 tee /home/testuser1/test.txt <<< "Hello, NFS!"


# samba
sudo apt-get install samba -y
tee -a /etc/samba/smb.conf > /dev/null <<EOF
[homes]
   comment = Home Directories
   browseable = yes
   read only = no
   valid users = %S
   create mask = 0775
   directory mask = 0775
EOF

sudo systemctl restart smbd

sudo echo -e "123456\n123456" | smbpasswd -a testuser1 -s 

# sshfs
sudo apt-get install sshfs -y


# WebDAV
sudo apt install apache2 -y
sudo systemctl start apache2
sudo a2enmod dav_fs
sudo a2enmod dav
sudo a2enmod auth_digest
sudo systemctl restart apache2


sudo mkdir -p /var/www/WebDAV/files
sudo chmod -R 775 /var/www/WebDAV
sudo tee -a /var/www/WebDAV/files/test.txt > /dev/null <<EOF
hello WebDAV
EOF

# sudo tee -a /var/www/WebDAV/files/index.html > /dev/null <<EOF
# <html>
#   <head>
#     <title>WebDAV</title>
#   </head>
#   <body>
#     <h1>Hello WebDAV</h1>
#   </body>
# </html>
# EOF
sudo chown -R www-data:vagrant /var/www/WebDAV

# sudo sed -i '/VirtualHost.*80/a \
# Alias /webdav /var/www/WebDAV \
# <Directory /var/www/WebDAV> \
#     Dav On \
#     Options Indexes FollowSymLinks \
#     Require all granted \
# </Directory> \
# ' /etc/apache2/sites-available/000-default.conf

# 将Directory放到VirtualHost中或者放到apache2.conf中都可以
# tee -a /etc/apache2/apache2.conf > /dev/null <<EOF
# <Directory /var/www/WebDAV>
#     Dav On
#     Options Indexes FollowSymLinks
#     Require all granted
# </Directory>
# EOF

# create a symbolic link but it is created by default
# sudo ln -s /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf

# sudo htdigest -c /var/www/WebDAV/.htdigest testuser testuser # 123456
sudo tee -a /var/www/WebDAV/.htdigest > /dev/null <<EOF
testuser:testuser:61e38645d7ab62f04486e002bb7db499
EOF
sudo chown www-data:root /var/www/WebDAV/.htdigest
sudo chmod 640 /var/www/WebDAV/.htdigest
sudo sed -i '/VirtualHost.*80/a \
Alias /webdav /var/www/WebDAV/files \
<Directory /var/www/WebDAV/files> \
    Dav On \
    Options Indexes FollowSymLinks \
    AllowOverride None \
    Require all granted \
</Directory> \
<Location /webdav> \
    DAV On \
    AuthType Digest \
    AuthName "testuser" \
    AuthUserFile /var/www/WebDAV/.htdigest \
    Require valid-user \
</Location> \
' /etc/apache2/sites-available/000-default.conf

sudo systemctl restart apache2


# NAS
sudo apt-get install mdadm -y
sudo mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sdc /dev/sdd /dev/sde
sudo mkfs.ext4 /dev/md0
sudo mkdir /mnt/nfs
sudo mount /dev/md0 /mnt/nfs
sudo chmod 777 /mnt/nfs # lab2 can create files in /mnt/nfs
sudo tee -a /etc/exports <<EOF
/mnt/nfs *(rw,sync,no_subtree_check)
EOF
sudo systemctl restart nfs-kernel-server

# sudo umount /dev/md0
# mdadm --stop /dev/md0
# mdadm --remove /dev/md0

sudo tee -a /mnt/nfs/lab1.txt > /dev/null <<EOF
from lab1
EOF


# sudo mdadm --fail /dev/md0 /dev/sdc
# cat /proc/mdstat
# sudo mdadm --remove /dev/md0 /dev/sdc
# sudo mdadm --add /dev/md0 /dev/sdf