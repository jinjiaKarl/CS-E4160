#!/usr/bin/env bash

sudo apt update
sudo apt install nfs-kernel-server -y


useradd -m -u 1001 testuser1
useradd -m -u 1002 testuser2

# nfs
tee -a /etc/exports > /dev/null <<EOF
/home *(rw,sync,no_subtree_check)
EOF

sudo systemctl restart nfs-kernel-server

su testuser1
echo "Hello, NFS!" > /home/testuser1/test.txt
exit


# samba
sudo apt-get install samba -y
tee -a /etc/samba/smb.conf > /dev/null <<EOF
[homes]
   comment = Home Directories
   browseable = yes
   writable = yes
   read only = no
   valid users = %S
EOF

sudo systemctl restart smbd
echo -e "123456\n123456" | smbpasswd -a testuser1 -s 

# sshfs
# sudo apt-get install sshfs -y


# WebDAV
sudo apt install apache2 -y
sudo systemctl start apache2
a2enmod dav_fs
a2enmod dav
a2enmod auth_digest

mkdir  /var/www/WebDAV
touch /var/www/WebDAV/DavLock
sudo chown -R www-data:www-data /var/www/WebDAV/*
echo "hello WebDAV" | tee /var/www/WebDAV/test.txt
cat << EOF > /var/www/WebDAV/index.html
<html>
  <head>
    <title>WebDAV</title>
  </head>
  <body>
    <h1>Hello WebDAV</h1>
  </body>
</html>
EOF

sed -i '/VirtualHost.*80/a \
DavLockDB "/var/www/WebDAV/DavLock" \
Alias /webdav /var/www/WebDAV \
<Directory /var/www/WebDAV> \
    Dav On \
    Options Indexes FollowSymLinks \
    Require all granted \
</Directory> \
' /etc/apache2/sites-available/000-default.conf

# 将Directory放到VirtualHost中或者放到apache2.conf中都可以
# tee -a /etc/apache2/apache2.conf > /dev/null <<EOF
# <Directory /var/www/WebDAV>
#     Dav On
#     Options Indexes FollowSymLinks
#     Require all granted
# </Directory>
# EOF
sudo systemctl restart apache2

# create a symbolic link but it is created by default
# sudo ln -s /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf

sudo a2enmod auth_digest
#sudo htdigest -c /var/www/WebDAV/.htdigest auth_name testuser1
# htpasswd -c /var/www/WebDAV/passwd.dav pp
echo "test:auth_name:e7bf99c1bde865a3aa4da066f36a3cb7" | tee /var/www/WebDAV/.htdigest
sudo chown www-data:www-data /var/www/WebDAV/.htdigest
sudo chmod 640 /var/www/WebDAV/.htdigest
sed -i '/Alias/a \
<Location /webdav> \
    DAV On \
    AuthType Digest \
    AuthName "auth_name" \
    AuthUserFile /var/www/WebDAV/.htdigest \
    Require valid-user \
</Location> \
' /etc/apache2/sites-available/000-default.conf

sudo systemctl restart apache2


# NAS
sudo apt-get install mdadm
