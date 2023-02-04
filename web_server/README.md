    Apache2              nginx                   node
+------------+       +-------------+        +-------------+
|            |       |             |        |             |
|   lab2     |       |    lab1     |        |    lab3     |
|            | <-----+             +------> |             |
|            |       |             |        |             |
+------------+       +------+------+        +-------------+
                            ^
                            |
                            +
                        http request

## reqestion
1.1 Serve a default web page using Apache2 on lab2
` sudo systemctl start apache2`

1.2 Show that the web page can be loaded on local browser using SSH port forwarding
```
// -p lab2 port, you can find it on vagrant up log
ssh -NL 8080:localhost:80 vagrant@127.0.0.1 -p 2200

curl 127.0.0.1:8080
```
2.1 Provide a working web page with text "Hello World!" on lab3
```
npm install express
node helloworld.js
```
2.2 Explain the contents of the helloworld.js file

2.3 What is the node.js event driven? What are the advantages?


3.1 Configure SSL for Apache2
```
apache2ctl -S # show the current configuration
a2enmod ssl # enable ssl module
# vim /etc/apache2/sites-available/default-ssl.conf change certificate location
sudo a2ensite default-ssl.conf

ssh -NL 8080:localhost:443 vagrant@127.0.0.1 -p 2200
curl -k https://127.0.0.1:8080
```
3.2 What information can a certificate include? What is necessary for it to work in the context of a web server?


3.3 What do PKI and requesting a certificate mean?


4.1 Enforcing https on lab2
```
// use userdir module
mkdir -p $HOME/public_html/secure_secrets
vagrant@lab2:~/public_html$ cat > $HOME/public_html/secure_secrets/index.html << EOF

> <html>
>   <head>
>     <title>TecMint is Best Site for Linux</title>
>   </head>
>   <body>
>     <h1>TecMint is Best Site for Linux</h1>
>   </body>
> </html>

sudo a2enmod userdir
sudo a2enmod rewrite
sudo systemctl restart apache2

curl 127.0.0.1/~vagrant/secure_secrets/
curl -k https://127.0.0.1/~vagrant/secure_secrets/

// use  
// https://httpd.apache.org/docs/2.4/mod/mod_rewrite.html#rewriterule
// R: redirect default 302
// L: Stop the rewriting process immediately and don't apply any more rules. 
RewriteEngine On
RewriteCond %{SERVER_PORT} 80
#RewriteRule ^(.*)$ https://127.0.0.1/~vagrant/$1 [R,L]
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]


curl -v -k -L http://127.0.0.1/~vagrant/secure_secrets/
```
4.2 What is c?

4.3 When to use .htaccess? In contrast, when not to use it?

5.1 serving both web application from nginx on lab1
```
sudo apt update
sudo apt install nginx -y
sudo systemctl start nginx

# edit /etc/nginx/sites-available/default
upstream apache {
   server lab2:80;
}
upstream node {
  server lab3:8080;
}
server {
    location /apache {
      rewrite /apache(/|$)(.*) /$2 break;
      proxy_pass http://apache;
    }
    location /node {
      proxy_pass http://node/;
    }
}

curl http://lab1/apache
curl http://lab1/node
```

5.2 Explain the contents of the nginx configuration file

5.3 What is commonly the primary purpose of an nginx server and why?

6.1 using nmap, detect the os version, php version, apache version and open ports
```
# https://nmap.org/nsedoc/scripts/http-php-version.html
# mysql is configured to only login locally(127.0.0.1) default.
root@lab1:~# nmap -sV -A  -sS -p- -T5 --script=http-php-version lab2
Nmap scan report for lab2 (192.168.1.11)
Host is up (0.00077s latency).
Not shown: 65532 closed ports
PORT    STATE SERVICE VERSION
22/tcp  open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.5 (Ubuntu Linux; protocol 2.0)
80/tcp  open  http    Apache httpd 2.4.41 ((Ubuntu))
|_http-server-header: Apache/2.4.41 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works
443/tcp open  ssl/ssl Apache httpd (SSL-only mode)
|_http-server-header: Apache/2.4.41 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works
| ssl-cert: Subject: commonName=\xC3\xA8\xC2\x9Clab2/organizationName=Network/stateOrProvinceName=Espoo/countryName=FI
| Not valid before: 2023-02-03T20:48:12
|_Not valid after:  2024-02-03T20:48:12
| tls-alpn:
|_  http/1.1
MAC Address: 08:00:27:AF:0A:BC (Oracle VirtualBox virtual NIC)
Aggressive OS guesses: Linux 2.6.32 (96%), Linux 3.2 - 4.9 (96%), Linux 2.6.32 - 3.10 (96%), Linux 3.4 - 3.10 (95%), Synology DiskStation Manager 5.2-5644 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), Netgear RAIDiator 4.2.28 (94%), Linux 2.6.32 - 2.6.35 (94%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 1 hop
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE
HOP RTT     ADDRESS
1   0.77 ms lab2 (192.168.1.11)

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 29.06 seconds


php -v
```

6.2 using nikto, to detect vulnerabilities on lab2
```
sudo apt-get install nikto -y
nikto -h http://lab2/dvwa
root@lab1:/etc/nginx/sites-available# nikto -h http://lab2
- Nikto v2.1.5
---------------------------------------------------------------------------
+ Target IP:          192.168.1.11
+ Target Hostname:    lab2
+ Target Port:        80
+ Start Time:         2023-02-04 11:54:36 (GMT0)
---------------------------------------------------------------------------
+ Server: Apache/2.4.41 (Ubuntu)
+ Server leaks inodes via ETags, header found with file /, fields: 0x2aa6 0x5f3d1914cfc39
+ The anti-clickjacking X-Frame-Options header is not present.
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ Allowed HTTP Methods: HEAD, GET, POST, OPTIONS
^Croot@lab1:/etc/nginx/sites-available# nikto -h http://lab2/dvwa
- Nikto v2.1.5
---------------------------------------------------------------------------
+ Target IP:          192.168.1.11
+ Target Hostname:    lab2
+ Target Port:        80
+ Start Time:         2023-02-04 11:55:32 (GMT0)
---------------------------------------------------------------------------
+ Server: Apache/2.4.41 (Ubuntu)
+ Cookie security created without the httponly flag
+ Cookie PHPSESSID created without the httponly flag
+ The anti-clickjacking X-Frame-Options header is not present.
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ Server leaks inodes via ETags, header found with file /dvwa/robots.txt, fields: 0x1a 0x5f378d82ce800
+ File/dir '/' in robots.txt returned a non-forbidden or redirect HTTP code (200)
+ "robots.txt" contains 1 entry which should be manually viewed.
+ Allowed HTTP Methods: HEAD, GET, POST, OPTIONS
+ DEBUG HTTP verb may show server debugging information. See http://msdn.microsoft.com/en-us/library/e8z01xdh%28VS.80%29.aspx for details.
+ OSVDB-3268: /dvwa/config/: Directory indexing found.
+ /dvwa/config/: Configuration information may be available remotely.
+ OSVDB-3233: /dvwa/phpinfo.php: Contains PHP configuration information
+ OSVDB-3268: /dvwa/tests/: Directory indexing found.
+ OSVDB-3092: /dvwa/tests/: This might be interesting...
+ OSVDB-3268: /dvwa/database/: Directory indexing found.
+ OSVDB-3093: /dvwa/database/: Databases? Really??
+ OSVDB-3268: /dvwa/docs/: Directory indexing found.
+ /dvwa/login.php: Admin login page/section found.
+ 6544 items checked: 0 error(s) and 17 item(s) reported on remote host
+ End Time:           2023-02-04 11:55:58 (GMT0) (26 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested
```

## Lab1
```bash
# install nginx
sudo apt update
sudo apt install nginx -y

sudo systemctl stop nginx
sudo systemctl start nginx
sudo systemctl restart nginx
sudo systemctl reload nginx
sudo systemctl status nginx
# config nginx
# reference: https://blog.csdn.net/u012911347/article/details/83068191
echo "127.0.0.1 lab2" | sudo tee -a /etc/hosts
echo "127.0.0.1 lab3" | sudo tee -a /etc/hosts
# edit /etc/nginx/sites-available/default
upstream apache {
   server 192.168.64.15:80;
}
upstream node {
  server 192.168.64.17:8080;
}
server {
    location /apache {
       proxy_pass http://apache/;
    }
    location /node {
       proxy_pass http://node/;
    }
}
```

	
Explain the contents of the nginx configuration file.

	
What is commonly the primary purpose of an nginx server and why?
```
The primary purpose of an nginx (pronounced "engine-x") server is to act as a reverse proxy and load balancer. This means that it receives incoming network traffic and forwards it to one of several backend servers based on a set of rules or criteria.

Nginx is commonly used for this purpose because it is designed to handle a large number of concurrent connections and has a small memory footprint. This makes it well-suited for high-traffic websites and web applications that need to handle a lot of incoming requests. Additionally, Nginx can handle many other functions such as caching, SSL/TLS termination, and serving static content.

Another reason why nginx is commonly used as a reverse proxy and load balancer is its ability to handle a wide range of protocols, including HTTP, HTTPS, TCP and UDP. This makes it flexible enough to handle different types of web traffic and applications, such as web servers, email servers, and real-time streaming applications.

In summary, Nginx is commonly used as a reverse proxy and load balancer because it is designed to handle a large number of concurrent connections, has a small memory footprint, and can handle a wide range of protocols.
```

## Lab2	
Show that the web page can be loaded on local browser (your machine or Niksula) using SSH port forwarding.
```bash
# install apache2
# https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-20-04
sudo apt update
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl status apache2
sudo systemctl stop apache2
sudo systemctl reload apache2
apache2 -version

# tls config
mkdir /keys && cd /keys
# The generated key is created using the OpenSSL format called PEM
openssl genrsa -out apache.key 2048 # generate ca private key
# The private key file contains both the private key and the public key. You can extract your public key from your private key file
openssl rsa -in apache.key -pubout -out apache_public.key
# show the content of the private key
openssl rsa -text -in apache.key -noout

# generate a certificate signing request (CSR)
openssl req -new -key apache.key -out apache.csr
Country Name (2 letter code) [AU]:FI
State or Province Name (full name) [Some-State]:Espoo
Locality Name (eg, city) []:Espoo
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Network    
Organizational Unit Name (eg, section) []:Web
Common Name (e.g. server FQDN or YOUR name) []:lab2   
Email Address []:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:


# generate a self-signed certificate
root@lab2:/keys# openssl x509 -signkey apache.key -in apache.csr -req -days 365 -out apache.crt
Signature ok
subject=C = FI, ST = Espoo, L = Espoo, O = Network, OU = Web, CN = lab2

openssl x509 -text -noout -in apache.crt


# using one command to generate a self-signed certificate
# -batch skip all configuration, use default info
# 
openssl req -batch -newkey rsa:2048 -keyout domain.key -x509 -days 365 -out domain.crt

# 
# reference: https://www.baeldung.com/openssl-self-signed-cert
# generate a CA-Signed Certificate
openssl req -nodes -newkey  rsa:2048 -keyout myserver.key -out myserver.csr
cat > myserver.v3.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
subjectAltName = @alt_names
[alt_names]
DNS.1 = www.web.me
EOF
openssl x509 -req -CA apache.crt -CAkey apache.key -in myserver.csr -out myserver.crt -days 365 -CAcreateserial -extfile myserver.v3.ext



# config ssl apache2
# reference: https://www.rosehosting.com/blog/how-to-enable-https-protocol-with-apache-2-on-ubuntu-20-04/
apache2ctl -S # show the current configuration
a2enmod ssl # enable ssl module
sudo a2ensite default-ssl.conf # 修改default-ssl.conf中的SSLCertificateFile和SSLCertificateKeyFile
curl -k https://127.0.1.1:443 # -k ignore certificate verification, on server
ssh -L 8080:127.0.1.1:443 jinjia@192.168.64.15 # on local machine
# open browser and visit https://127.0.0.1:8080 on local machine

# enforce https
# reference https://askubuntu.com/questions/849702/userdir-with-virtual-host-apache2
mkdir -p $HOME/public_html/secure_secrets
cat > $HOME/public_html/secure_secrets/index.html << EOF
<html>
  <head>
    <title>TecMint is Best Site for Linux</title>
  </head>
  <body>
    <h1>TecMint is Best Site for Linux</h1>
  </body>
</html>
EOF
a2enmod userdir
sudo a2enmod rewrite && sudo service apache2 restart
# a2dissite 000-default.conf # disable default site
sudo a2ensite 000-default.conf # /etc/apache2/sites-available/
sudo a2ensite default-ssl.conf
curl 127.0.0.1/~jinjia/secure_secrets/
curl -k https://127.0.1.1:443/~jinjia/secure_secrets/

# TODO: .htaccess 文件怎么写 rewrite rule
RewriteEngine On
RewriteCond %{SERVER_PORT} 80
RewriteRule ^(.*)$ https://127.0.1.1/~jinjia/$1 [R,L]


# 查看日志
grep 'LOG' /etc/apache2/envvars
tail -f /var/log/apache2/error.log 
```
Provide and explain your solution.
`using self-signed certificate as a server certificate`

What information can a certificate include? What is necessary for it to work in the context of a web server?
```bash
# issuer, subject, validity, public key, digital signature of the certificate
# For a certificate to work in the context of a web server, it must include a public key that can be used to establish an encrypted connection with a client's web browser, and it must be issued by a trusted certificate authority (CA) that the client's web browser already recognizes. Additionally, the certificate must be valid and not expired.
#The certificate must also have the correct "Common Name" (CN) or "Subject Alternative Name" (SAN) that matches the hostname or domain name of the website that the certificate is being used for, so that browser can check that it is connecting to the correct website.

root@lab2:/keys# openssl x509 -text -noout -in apache.crt
Certificate:
    Data:
        Version: 1 (0x0)
        Serial Number:
            76:6f:f6:7e:c7:a9:88:39:a3:65:38:fd:f6:bd:fc:34:b3:d3:3f:80
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C = FI, ST = Espoo, L = Espoo, O = Nework, OU = Web, CN = lab2
        Validity
            Not Before: Jan 24 12:17:54 2023 GMT
            Not After : Jan 24 12:17:54 2024 GMT
        Subject: C = FI, ST = Espoo, L = Espoo, O = Nework, OU = Web, CN = lab2
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:b0:4a:42:a4:00:0c:e4:35:fe:42:a4:6e:87:71:
                    e7:38:9c:ed:fa:65:95:8a:07:1c:d7:4b:ab:80:7e:
                    3a:d5:bf:f1:69:88:c7:66:d9:24:dd:ae:5b:1a:a8:
                    6c:ad:ae:2f:9d:ac:d3:4d:0c:2b:ab:69:a0:15:e0:
                    39:df:f5:53:b4:ae:3e:f3:e2:47:46:ae:73:5a:77:
                    92:66:aa:0c:71:60:f5:c6:3f:8d:88:57:06:69:db:
                    a5:cb:cf:6e:74:b0:9e:d0:08:11:9a:52:1d:5a:0e:
                    c8:5c:3f:0d:13:4c:56:ce:3f:fa:36:74:b2:92:84:
                    b9:3d:e9:63:80:cd:96:79:10:b3:13:65:7c:c3:d1:
                    a4:20:20:12:27:5f:17:bc:48:81:a8:d6:f8:9a:c8:
                    f6:da:77:7d:97:a5:c9:64:7d:b1:0e:0d:f0:60:35:
                    69:b7:6d:9d:40:0a:04:5d:46:5f:60:59:80:9e:5d:
                    40:5c:fb:74:08:5f:e3:7a:f1:0b:81:61:fe:15:33:
                    a8:3d:d2:7b:5c:a9:60:81:0b:8c:30:c8:b7:07:ce:
                    14:dc:28:5d:d1:1c:10:64:0c:ba:e3:65:d2:b9:2b:
                    ed:b9:df:93:e2:a4:47:41:e9:a3:16:79:68:4e:16:
                    bd:dd:bd:bd:88:8b:90:e3:59:c0:43:dd:be:78:7e:
                    fc:83
                Exponent: 65537 (0x10001)
    Signature Algorithm: sha256WithRSAEncryption
         30:b9:4f:33:57:69:2d:6d:56:6e:06:ab:15:5a:28:41:6c:12:
         ae:c1:b5:25:ff:9b:15:02:b5:e5:57:c5:10:86:c3:e3:6f:8c:
         93:b2:58:10:9a:0e:76:b1:02:26:f6:02:59:8f:dd:fe:11:b7:
         7a:0c:9d:ca:1e:1d:76:87:0b:76:b4:60:f3:f2:0e:8b:fe:ab:
         c0:a5:90:4b:8a:5e:f0:72:8b:19:7c:14:84:fd:61:69:ae:f8:
         cd:a9:2a:75:43:ae:11:8c:8d:62:30:04:89:ec:b0:b3:7d:8d:
         e6:9d:0d:c7:f3:df:69:78:42:4a:cf:2f:95:77:88:fa:af:91:
         2e:92:b5:52:44:31:93:5d:3d:ff:41:aa:8d:74:66:5d:70:d7:
         e0:61:2e:52:66:1a:c1:ae:e2:f9:f8:0a:95:67:ff:61:00:81:
         c0:90:9a:3b:d5:da:62:e3:a0:d5:a2:8b:d7:4c:79:6d:42:fd:
         7d:04:5d:cc:3f:aa:12:3c:9b:1c:1d:59:4e:91:6d:61:29:bf:
         02:8e:dc:be:50:8b:0d:04:e1:1a:79:ef:a6:ba:ae:0d:9b:28:
         5c:60:3f:c9:d5:d8:87:11:59:83:62:04:e8:03:8f:99:4b:fd:
         d0:b2:12:0b:38:0e:0e:6d:20:82:51:07:1b:79:2c:b5:e4:24:
         a6:a5:c2:76
```

What do PKI and requesting a certificate mean?
`PKI (Public Key Infrastructure) refers to the system of digital certificates, certificate authorities (CAs), and other registration authorities that verify and authenticate the validity of public keys used for encrypting communications and digitally signing documents.

When requesting a certificate, it typically means that an individual or organization is requesting a digital certificate from a certificate authority (CA) to prove their identity or the authenticity of their website. This certificate can be used to establish a secure, encrypted connection (e.g. HTTPS) between the user's web browser and the website, or to digitally sign electronic documents, among other uses.`

Enforcing HTTPS provide and explain your solution.
```bash
using rewrite module and .htaccess file
```

	
What is HSTS?
```
https://zhuanlan.zhihu.com/p/130946490

HSTS (HTTP Strict Transport Security) is a security feature that is implemented by web servers to ensure that web browsers only connect to them using a secure HTTPS connection, rather than an insecure HTTP connection. When a web browser receives an HSTS policy from a web server, it will automatically convert any insecure HTTP links to HTTPS links, and will only allow connections to the server using HTTPS in the future, even if the user types the link in manually with HTTP.

HSTS policy is communicated to the browser via a special HTTP header "Strict-Transport-Security" which contains the policy information. The policy includes a "max-age" value which determines how long the browser should remember the HSTS policy for that domain.

HSTS is an important security measure as it helps to protect against several types of attacks, such as:

SSL stripping: attackers intercept and downgrade HTTPS connections to HTTP connections to intercept traffic.
Cookie hijacking: attackers intercept and steal cookies, which can be used to impersonate the user.
Phishing: attackers create fake, but very similar looking websites to steal login credentials.
Enabling HSTS on a website can help to prevent these types of attacks by ensuring that all connections to the website are made over HTTPS, which provides encryption and authentication, making it much more difficult for attackers to intercept or tamper with the traffic.

```
When to use .htaccess? In contrast, when not to use it?
```
.htaccess is a configuration file used by the Apache web server to control various settings for a website or a directory on a website. It is commonly used to control redirects, authentication, and other server-side configurations.

It should be used when you need to make configuration changes to your website or directory that are not possible through the main Apache configuration file, such as when you don't have access to the main configuration file, or when you need to make changes to a specific directory on your website.


It should not be used when making changes that can be made through the main Apache configuration file(require root priviledge), as changes made in .htaccess can have a negative impact on server performance. Additionally, it is not recommended to use .htaccess on a production server with many concurrent connections, as it can slow down the server.
```

Show that the web page can be loaded on local browser (your machine or Niksula) using SSH port forwarding.
[ssh端口转发](https://zhuanlan.zhihu.com/p/148825449)
```bash
# ssh local port forward
# ssh -L hosta_port_X:hostc_ip:hostc_port_Z hostb_username@hostname

# host c is a server listening on port 8080
# host c is localhost, means host c is the same machine as host b
# -N  Do not execute a remote command; -L local port forward
ssh -NL 8080:localhost:80 jinjia@192.168.64.15  # execute on host a
curl localhost:8080 # execute on host a
```

## Lab3
```bash
# install node
sudo apt update
sudo apt install nodejs npm -y

# Provide a working web page with the text "Hello World!"
```

What does it mean that Node.js is event driven? What are the advantages in such an approach?
```
In Node.js, "event-driven" refers to the way in which the program handles input/output (I/O) operations. Instead of waiting for an I/O operation to complete before moving on to the next task, Node.js allows other code to continue running while an I/O operation is taking place. When the I/O operation is finished, an "event" is emitted, and a callback function is invoked to handle the results of the operation.

There are several advantages to this approach:

Non-blocking I/O: Because Node.js doesn't block the execution of other code while it's waiting for an I/O operation to complete, it can handle many I/O operations concurrently, making it well-suited for high-concurrency applications such as real-time web applications and chat apps.
High performance: The event-driven architecture of Node.js makes it highly scalable and performant, as it can handle a large number of simultaneous connections with relatively low overhead.
Asynchronous programming: The callback-based nature of Node.js's event-driven architecture makes it well-suited for asynchronous programming, which can be more efficient and easier to reason about than traditional synchronous programming.
Single-threaded: Node.js uses a single-threaded event loop, which means that it can handle many concurrent connections with a smaller memory footprint than a multi-threaded solution. This makes it more cost-efficient.
In summary, event-driven approach in Node.js allows for non-blocking I/O, high performance, asynchronous programming and cost-efficiency, making it a great option for high-concurrency and real-time web applications.
```


Using Nmap, enumerate the lab2, and detect the os version, php version, apache version and open ports
```

sudo apt install -y apache2 mariadb-server mariadb-client php php-mysqli php-gd libapache2-mod-php
sudo systemctl start mysqld
sudo mysql_secure_installation # set password 123456

mysql -u root -p
CREATE DATABASE dvwa;
CREATE USER 'dvwa'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON dvwa.* TO 'dvwa'@'localhost' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;

# install
# refence: https://bytedecay.com/index.php/2023/01/06/install-dvwa-on-ubuntu-linux/
# https://securingninja.com/how-to-install-dvwa-in-ubuntu/
# https://github.com/digininja/DVWA/blob/master/README.zh.md
cd /var/www/html
wget https://github.com/digininja/DVWA/archive/master.zip
unzip master.zip
mv DVWA-master dvwa
sudo chown -R www-data:www-data /var/www/html/*
cd dvwa/config
sudo cp config.inc.php.dist config.inc.php # change password


curl http://127.0.0.1:8080/dvwa/ # on host machine 如果配置了端口转发


# 靶场练习
# https://zhuanlan.zhihu.com/p/565945383

root@lab2:/var/www/html/dvwa/config# nmap -sV -sU -sS -p- -T5 192.168.64.15
Starting Nmap 7.80 ( https://nmap.org ) at 2023-01-24 20:32 UTC
Nmap scan report for lab2 (192.168.64.15)
Host is up (0.0000010s latency).
Not shown: 131066 closed ports
PORT    STATE         SERVICE  VERSION
22/tcp  open          ssh      OpenSSH 8.2p1 Ubuntu 4ubuntu0.5 (Ubuntu Linux; protocol 2.0)
80/tcp  open          http     Apache httpd 2.4.41 ((Ubuntu))
443/tcp open          ssl/http Apache httpd 2.4.41 ((Ubuntu))
68/udp  open|filtered dhcpc
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 100.77 seconds

# 怎么使用nmap查看php版本
root@lab2:/var/www/html/dvwa/config# php -v
PHP 7.4.3-4ubuntu2.17 (cli) (built: Jan 10 2023 15:37:44) ( NTS )
Copyright (c) The PHP Group
Zend Engine v3.4.0, Copyright (c) Zend Technologies
    with Zend OPcache v7.4.3-4ubuntu2.17, Copyright (c), by Zend Technologies
```
sudo apt-get install nikto -y

Using Nikto, to detect vulnerabilities on lab2
```
sudo apt-get install nikto -y
nikto -h 127.0.1.1 -p 80
```