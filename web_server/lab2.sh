#!/usr/bin/env bash

# install apache2
sudo apt update
sudo apt install apache2 -y
sudo systemctl start apache2

# keys
mkdir /keys
tee /keys/apache.key > /dev/null <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAsfyEGx049MC7bbWQNBHpYP7Be541CC7Rq/FIXnzBT/ET7owu
FK0skwO56RXPhBiX+/fiUYp6+fW5jSZmiCDZqm13TyMinTy5e+AdbdhLJ+uYWxqq
bt1rLbQECsdw/H7G3xj2As3b7YVJs108KbraBHvQmP6jICZTWBmkgf/jQu08pTSO
rKBtvcd6jRyFVo3hfKVPZNIQVrRw8yxGRz7Xl/czU1MTzXG8xI1cgDQ5h/tvYjuZ
D+DV+fW7727ZjLxrZ//Q0G/bbmeHodpFtFrrbr9xh6qy3F0khh5/byst28kyH+ys
kGbffvEbYt0Vunc2fnwGZiVJToq7deWrtqPisQIDAQABAoIBAEoFAQ+hpIktCgWD
J5hwBoWfDOoTDmz7w5jlPDqHWYGcebSQOa3BozL0rsE/n9CIxdQ077sHg0MmrOcF
nEhqmPsmkSKpMwD/OwhIWRTQidjtQqxIt65piOQ15CRzcwqe0qf/YngiEp+B+feN
A7M7EOYic8rcwwxgw/J0n5SszV+MRjgESOkypZLvKcy4fP8zVOoHFlLGLmRUVH78
JOtd7ZXctW77/zlvybDfmU6XwAD+lS1AdPzztwioxhpQBS8TShulgUr/TK8+STxJ
ID9N5APpcuF0ehALK8SAsG9xEb70VSa+q4D/vl7N3uqnPSgJr7bBZ8SaNdunUd00
26FMNe0CgYEA29R3d5jK5mn74lYnmXFqu/tbE6LgQrc3SMeDxy7Nw091c3he87so
3PpxZDW1sL48D9DKfY4eMVc4i2tdx+eIL4cfdOlD9VHxRal/Cmj0vU6vgBl2pSKM
EIxPfflrucOjjaxnvh6bGglb597wkWMqruHIoZoazsjP+OnqSaj6yLsCgYEAz0WK
27hTEK6ILP9NRcSdzj4o6fndR0hkb9DOJyo5QijU5p9ElPENjFjnpBx1sxOk9ZAX
u6Pxg19UMwhHNq4dA2QRolDfRo96Cdozwhh1+c8yD0DhPfi8mBtkk6g/gN5HBfde
BjOystQLLVR4W7vD+HZNTuSc1RuIfo6WHJekUYMCgYAO3ptKIrKuzUJ1d+Br16kh
mAn8FQtYV+5MZPp78aWHbYuDSQQbNnC4KdSbs6pbjzKe2z+nKILQUZcIjzWjvPyQ
QnKVROYM5QMN9D4cpSbQ206xuoc0+lZBFEyYN9Pal+orPhsyV/2j0DhAQetB2lRb
yff5PmRL0neG3cO0QdLc2wKBgQCmwtTNoqdyLHnzehS5pU8xuGFCnn2h9GSacezr
JdWbnS5tvoZ3LtovqPf12c/4nD2ENMJjfau6fuBHjsl8/Ojq6YAmj9qT8qvFcYFj
EDsbGdC05QZTzeQunRt2kU9GZ4/NBRDo/H8x0diMSAHuDEvHg6b/an+kFdrjt+Se
bIMP8QKBgQCxzb5cfLE0zbaMLhmNjGgcDI5utS5PiKVXGYSHHZ5BOBF0E4Q8myO5
Lm2cXE2dS4D1aiRU7PP8u2epSdUbD3qVcUPmdZAv/cfMxb/DhXurBxEucTh+5zuc
2Ch7NsAll3ayzu+GOYpIBX5XlUViLdX1RKhMro4b7wyAGHvT1OtA7A==
-----END RSA PRIVATE KEY-----
EOF

tee /keys/apache_public.key > /dev/null <<EOF
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsfyEGx049MC7bbWQNBHp
YP7Be541CC7Rq/FIXnzBT/ET7owuFK0skwO56RXPhBiX+/fiUYp6+fW5jSZmiCDZ
qm13TyMinTy5e+AdbdhLJ+uYWxqqbt1rLbQECsdw/H7G3xj2As3b7YVJs108Kbra
BHvQmP6jICZTWBmkgf/jQu08pTSOrKBtvcd6jRyFVo3hfKVPZNIQVrRw8yxGRz7X
l/czU1MTzXG8xI1cgDQ5h/tvYjuZD+DV+fW7727ZjLxrZ//Q0G/bbmeHodpFtFrr
br9xh6qy3F0khh5/byst28kyH+yskGbffvEbYt0Vunc2fnwGZiVJToq7deWrtqPi
sQIDAQAB
-----END PUBLIC KEY-----
EOF

tee /keys/apache.crt > /dev/null <<EOF
-----BEGIN CERTIFICATE-----
MIIDRzCCAi8CFFYSx9PvRncz+jWgzyD+9nrzPPfuMA0GCSqGSIb3DQEBCwUAMGAx
CzAJBgNVBAYTAkZJMQ4wDAYDVQQIDAVFc3BvbzEOMAwGA1UEBwwFRXNwb28xEDAO
BgNVBAoMB05ldHdvcmsxDDAKBgNVBAsMA1dlYjERMA8GA1UEAwwIw6jCnGxhYjIw
HhcNMjMwMjAzMjA0ODEyWhcNMjQwMjAzMjA0ODEyWjBgMQswCQYDVQQGEwJGSTEO
MAwGA1UECAwFRXNwb28xDjAMBgNVBAcMBUVzcG9vMRAwDgYDVQQKDAdOZXR3b3Jr
MQwwCgYDVQQLDANXZWIxETAPBgNVBAMMCMOowpxsYWIyMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAsfyEGx049MC7bbWQNBHpYP7Be541CC7Rq/FIXnzB
T/ET7owuFK0skwO56RXPhBiX+/fiUYp6+fW5jSZmiCDZqm13TyMinTy5e+AdbdhL
J+uYWxqqbt1rLbQECsdw/H7G3xj2As3b7YVJs108KbraBHvQmP6jICZTWBmkgf/j
Qu08pTSOrKBtvcd6jRyFVo3hfKVPZNIQVrRw8yxGRz7Xl/czU1MTzXG8xI1cgDQ5
h/tvYjuZD+DV+fW7727ZjLxrZ//Q0G/bbmeHodpFtFrrbr9xh6qy3F0khh5/byst
28kyH+yskGbffvEbYt0Vunc2fnwGZiVJToq7deWrtqPisQIDAQABMA0GCSqGSIb3
DQEBCwUAA4IBAQApMc4nO7A9mba4ZjPF9s9nu8bfvm5ZUIZjhj8g2ePAUlYmi+kI
x1bIMdLnlqqVFkeEhAoEBihwMuM3a7/3oNhHmTZjLWa1HZ2X9CqjJLmO0LNEIULC
MtOS02QC8ru4bMXT9U7unqdKM+TfOQURQuXKAf9nsDJP48pCyygHaYXvCH6vKg6s
bcm7qotRVKvjAD4rSPtQOu6mFclIRTn/lxuiIvrhHHy7qMVC0wybpgrxCaVZQ/xh
ZWl/8gR5dUlTdE20OhiRfIsXBi5vW3EMgJ+iC5i1I50bJDV8HWZC46NhFCU9jKG0
AKdtndDReISOy0u6YA6Y+2xOHFoL83qsj8I3
-----END CERTIFICATE-----
EOF

# ssl
sudo a2enmod ssl
sudo sed -i "s/SSLCertificateFile.*/SSLCertificateFile \/keys\/apache.crt/g" /etc/apache2/sites-available/default-ssl.conf
sudo sed -i "s/SSLCertificateKeyFile.*/SSLCertificateKeyFile \/keys\/apache.crt/g" /etc/apache2/sites-available/default-ssl.conf
sudo a2ensite default-ssl.conf

mkdir -p $HOME/public_html/secure_secrets
cat << EOF > $HOME/public_html/secure_secrets/index.html
<html>
  <head>
    <title>TecMint is Best Site for Linux</title>
  </head>
  <body>
    <h1>TecMint is Best Site for Linux</h1>
  </body>
</html>
EOF

# userdir
sudo a2enmod userdir
sudo a2enmod rewrite
sudo systemctl restart apache2

touch $HOME/public_html/.htaccess
cat << EOF > $HOME/public_html/.htaccess
RewriteEngine On
RewriteCond %{SERVER_PORT} 80
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
EOF


# dvwa
sudo apt install -y apache2 mariadb-server mariadb-client php php-mysqli php-gd libapache2-mod-php unzip
sudo systemctl start mysqld
mysql -u root -p -e "create database dvwa; grant all on dvwa.* to dvwa@localhost identified by 'p@ssw0rd'; flush privileges;"
cd /var/www/html
wget https://github.com/digininja/DVWA/archive/master.zip
unzip master.zip
mv DVWA-master dvwa
sudo chown -R www-data:www-data /var/www/html/*
cd dvwa/config
sudo cp config.inc.php.dist config.inc.php
