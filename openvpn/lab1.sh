# Gateway
sudo apt-get install openvpn easy-rsa -y

# sudo tee -a /usr/share/easy-rsa/vars > /dev/null <<EOF
# export KEY_COUNTRY="FI"
# export KEY_PROVINCE="Espoo"
# export KEY_CITY="Espoo"
# export KEY_ORG="aalto"
# export KEY_EMAIL="jinjia.zhang@aalto.fi"
# export KEY_OU="aalto"
# EOF

# sudo source /usr/share/easy-rsa/vars

# sudo /usr/share/easy-rsa/easyrsa init-pki
# sudo /usr/share/easy-rsa/easyrsa build-ca nopass
# sudo /usr/share/easy-rsa/easyrsa build-server-full vpnserver nopass
# sudo /usr/share/easy-rsa/easyrsa build-client-full vpnclient nopass
# sudo /usr/share/easy-rsa/easyrsa gen-dh
# sudo /usr/sbin/openvpn --genkey --secret ta.key


# sudo /usr/share/easy-rsa/easyrsa init-pki
# sudo /usr/share/easy-rsa/easyrsa build-ca nopass
# ./easyrsa gen-req vpnserver nopass  
# ./easyrsa sign-req server vpnserver
# sudo /usr/share/easy-rsa/easyrsa gen-dh
# sudo /usr/sbin/openvpn --genkey --secret ta.key

sudo mkdir -p /usr/share/easy-rsa/pki/issued
sudo mkdir -p /usr/share/easy-rsa/pki/private

sudo tee -a /usr/share/easy-rsa/pki/ca.crt > /dev/null <<EOF
-----BEGIN CERTIFICATE-----
MIIDSzCCAjOgAwIBAgIUUkTk65BMsq+1vQ9Z5663x/yNgLMwDQYJKoZIhvcNAQEL
BQAwFjEUMBIGA1UEAwwLRWFzeS1SU0EgQ0EwHhcNMjMwMzEzMTExMjM0WhcNMzMw
MzEwMTExMjM0WjAWMRQwEgYDVQQDDAtFYXN5LVJTQSBDQTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALvhuFepLgq50S6vzAYhWkYvL1X4J3MHV67bUVtu
hSN8CNU/8o9Yg31QaNN3IocxZJZZ2Cdtg44r/sZxr/KpYk82uZ0wZ/RTMA5HVa4t
PYhKcyRjrHhwBsuLnt4j+Foz6MCP4H9cP3yK8OGqSSitcVt76j9Jk0vA3sHDRycN
MS5tkz76G7GnLUTuoyRqGq+rUpBR2JfGQcX/ZeFTQi86i3qYlnYFEw+qGM/NHMkU
BEdFON/EOR+WZbOBul9Y0QIwZ749Jj8c32r6kQYNtRDz00yhgFgQ7RS2Oy3o7bOe
OxNr08mrL3VfsiqKgEo/MS+C5NT62w1BdJ/fGAyv3aozjk8CAwEAAaOBkDCBjTAd
BgNVHQ4EFgQUQzaS476cIL7qjngUcoj5XM54K5owUQYDVR0jBEowSIAUQzaS476c
IL7qjngUcoj5XM54K5qhGqQYMBYxFDASBgNVBAMMC0Vhc3ktUlNBIENBghRSROTr
kEyyr7W9D1nnrrfH/I2AszAMBgNVHRMEBTADAQH/MAsGA1UdDwQEAwIBBjANBgkq
hkiG9w0BAQsFAAOCAQEAtV9poQt7ShxsOJZBchU2x+g/qzwiKIcHRsnQjYinAX6n
EhnrNhZ4rXicdYnrEgMYnt1bzSlNRhbFkxpx0ATz+lFOyzPOyX6o1AbyDY8lmhgG
0RavFca0pCEu7ceUuJBVOQz46qAxNMgIT9b2uapU2bIKpE3cYrCcBNsIgKXVG68p
9cpvCc4MFS/k7Y74yJDNNqyCYHjnbtT7MHll5mPA2tzhlZOOtBD+E5vYVlQ3yuQU
QvAqdtyhBW94sEngZPKcfRXOt1sQfEb/vjcTM+We9I3hMk9YW79wUS+C6D+RiEfP
vi6NnH6vWk0jQnB7H3PetoHNwFPoOhe7qctML+LvEA==
-----END CERTIFICATE-----
EOF

sudo tee -a /usr/share/easy-rsa/pki/issued/vpnserver.crt > /dev/null <<EOF
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            05:e0:c8:15:c2:83:59:b2:1c:0d:95:da:e2:6d:65:ed
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN=Easy-RSA CA
        Validity
            Not Before: Mar 13 11:12:43 2023 GMT
            Not After : Feb 25 11:12:43 2026 GMT
        Subject: CN=vpnserver
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:ab:df:8e:ad:de:86:0e:c2:3f:27:2b:6f:c9:6f:
                    76:d2:83:fd:ef:59:0a:2d:bd:41:19:6d:3d:04:33:
                    62:51:06:3c:74:6c:55:80:96:63:28:3f:76:38:63:
                    61:b0:98:82:6d:4d:1a:72:c9:e3:0a:98:99:58:c1:
                    6b:dd:af:86:e0:5a:d7:49:7e:04:c7:a3:1c:88:7a:
                    61:40:fd:dc:d1:73:f5:19:e7:4b:a1:95:f0:25:dd:
                    c8:83:49:57:bd:03:a2:64:7f:9e:eb:1a:39:0e:27:
                    35:e3:8f:19:c1:61:be:33:3a:9b:e1:91:42:1f:7d:
                    85:7d:a7:97:1f:03:47:97:89:7d:dd:d9:a3:f9:4a:
                    17:66:75:27:a3:1c:8f:76:0b:c0:1d:18:b3:09:58:
                    31:7f:db:c1:65:ed:b8:75:6d:ec:11:c6:7a:a4:e8:
                    4b:ba:82:1c:86:d1:b5:68:93:fe:af:a4:33:96:a2:
                    e1:d9:da:c8:8f:0f:9f:35:b9:8f:e0:90:49:0a:4f:
                    71:47:79:78:25:1a:04:c2:e3:21:0a:7a:8c:db:45:
                    e0:21:bf:15:b5:42:02:95:cf:27:f1:0a:80:d1:e3:
                    bf:59:dc:19:70:d3:79:51:0b:27:aa:36:7c:49:95:
                    6d:b3:ad:90:36:97:b5:15:41:6b:6f:65:7e:a6:7a:
                    66:8d
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints:
                CA:FALSE
            X509v3 Subject Key Identifier:
                FF:33:4C:F5:79:B2:A4:46:28:29:0B:DD:B9:0E:80:E7:AE:23:4B:0C
            X509v3 Authority Key Identifier:
                keyid:43:36:92:E3:BE:9C:20:BE:EA:8E:78:14:72:88:F9:5C:CE:78:2B:9A
                DirName:/CN=Easy-RSA CA
                serial:52:44:E4:EB:90:4C:B2:AF:B5:BD:0F:59:E7:AE:B7:C7:FC:8D:80:B3

            X509v3 Extended Key Usage:
                TLS Web Server Authentication
            X509v3 Key Usage:
                Digital Signature, Key Encipherment
            X509v3 Subject Alternative Name:
                DNS:vpnserver
    Signature Algorithm: sha256WithRSAEncryption
         b3:1a:e6:16:ba:5d:bb:69:63:58:17:64:c7:37:57:c6:68:df:
         55:1a:84:3a:b1:a5:1d:b9:de:2f:38:b3:31:af:53:67:00:82:
         86:a8:a9:0e:cc:ca:4f:40:b8:65:7a:96:2e:e3:cf:c6:50:91:
         09:40:2a:ac:b5:ec:7c:25:ef:4e:71:89:21:d7:59:d1:ac:8a:
         63:a7:50:19:8f:3c:8c:91:40:0f:1a:4c:8a:e8:a8:c9:00:d4:
         04:b9:67:50:22:ed:25:2a:92:f0:4d:bc:ea:3a:d0:32:45:d9:
         66:a5:98:21:cb:53:52:ec:74:11:24:8d:33:d5:79:2d:99:36:
         53:7d:f4:d8:ea:21:3c:dd:ad:75:1e:b4:75:77:c3:d9:f3:90:
         71:ca:2a:16:62:f6:c7:3f:6f:fc:20:4a:06:c5:e7:03:e4:41:
         41:88:85:0d:56:c8:06:07:e7:fb:83:0e:7d:7f:e6:5e:f0:37:
         90:28:a1:e1:5e:31:70:a9:da:0e:12:88:6d:2d:69:82:41:20:
         51:b2:a3:0b:b8:86:14:ba:08:4d:97:88:7b:ce:9a:ec:b8:5d:
         71:e8:0c:b8:37:57:06:ea:58:fa:6d:3f:d4:4c:d5:77:b5:16:
         67:23:c8:15:a4:75:e3:f8:f7:9f:26:44:54:d8:13:e5:7b:1d:
         f7:87:a3:35
-----BEGIN CERTIFICATE-----
MIIDbTCCAlWgAwIBAgIQBeDIFcKDWbIcDZXa4m1l7TANBgkqhkiG9w0BAQsFADAW
MRQwEgYDVQQDDAtFYXN5LVJTQSBDQTAeFw0yMzAzMTMxMTEyNDNaFw0yNjAyMjUx
MTEyNDNaMBQxEjAQBgNVBAMMCXZwbnNlcnZlcjCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAKvfjq3ehg7CPycrb8lvdtKD/e9ZCi29QRltPQQzYlEGPHRs
VYCWYyg/djhjYbCYgm1NGnLJ4wqYmVjBa92vhuBa10l+BMejHIh6YUD93NFz9Rnn
S6GV8CXdyINJV70DomR/nusaOQ4nNeOPGcFhvjM6m+GRQh99hX2nlx8DR5eJfd3Z
o/lKF2Z1J6Mcj3YLwB0YswlYMX/bwWXtuHVt7BHGeqToS7qCHIbRtWiT/q+kM5ai
4dnayI8PnzW5j+CQSQpPcUd5eCUaBMLjIQp6jNtF4CG/FbVCApXPJ/EKgNHjv1nc
GXDTeVELJ6o2fEmVbbOtkDaXtRVBa29lfqZ6Zo0CAwEAAaOBuDCBtTAJBgNVHRME
AjAAMB0GA1UdDgQWBBT/M0z1ebKkRigpC925DoDnriNLDDBRBgNVHSMESjBIgBRD
NpLjvpwgvuqOeBRyiPlczngrmqEapBgwFjEUMBIGA1UEAwwLRWFzeS1SU0EgQ0GC
FFJE5OuQTLKvtb0PWeeut8f8jYCzMBMGA1UdJQQMMAoGCCsGAQUFBwMBMAsGA1Ud
DwQEAwIFoDAUBgNVHREEDTALggl2cG5zZXJ2ZXIwDQYJKoZIhvcNAQELBQADggEB
ALMa5ha6XbtpY1gXZMc3V8Zo31UahDqxpR253i84szGvU2cAgoaoqQ7Myk9AuGV6
li7jz8ZQkQlAKqy17Hwl705xiSHXWdGsimOnUBmPPIyRQA8aTIroqMkA1AS5Z1Ai
7SUqkvBNvOo60DJF2WalmCHLU1LsdBEkjTPVeS2ZNlN99NjqITzdrXUetHV3w9nz
kHHKKhZi9sc/b/wgSgbF5wPkQUGIhQ1WyAYH5/uDDn1/5l7wN5AooeFeMXCp2g4S
iG0taYJBIFGyowu4hhS6CE2XiHvOmuy4XXHoDLg3VwbqWPptP9RM1Xe1FmcjyBWk
deP4958mRFTYE+V7HfeHozU=
-----END CERTIFICATE-----
EOF

sudo tee -a /usr/share/easy-rsa/pki/private/vpnserver.key > /dev/null << EOF
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCr346t3oYOwj8n
K2/Jb3bSg/3vWQotvUEZbT0EM2JRBjx0bFWAlmMoP3Y4Y2GwmIJtTRpyyeMKmJlY
wWvdr4bgWtdJfgTHoxyIemFA/dzRc/UZ50uhlfAl3ciDSVe9A6Jkf57rGjkOJzXj
jxnBYb4zOpvhkUIffYV9p5cfA0eXiX3d2aP5ShdmdSejHI92C8AdGLMJWDF/28Fl
7bh1bewRxnqk6Eu6ghyG0bVok/6vpDOWouHZ2siPD581uY/gkEkKT3FHeXglGgTC
4yEKeozbReAhvxW1QgKVzyfxCoDR479Z3Blw03lRCyeqNnxJlW2zrZA2l7UVQWtv
ZX6memaNAgMBAAECggEAfKzqnw1wSXx2uz8zE/gbRZIhvmHklFFYy80GGen8Q7I2
YG3FiEWPID8IztaooqW+1vK7YNE6NRGFC3Ejgeg1+sFqshEL/pU/uXCs46xDZlyr
S2MQ5eISFiXPsgyd7KqaPjSlXv3irXWcDbpcgH8araayNOpeAOHY19GeOgzy/eS6
akcD0velWRfl5OByQJ6tdt2GSiBw8p0jlOzuETrJWumOS6nRSZ6vfD869B1T9njy
7i2m867gb9sKf9jtrCDsx/4aUfU/8jmGszkY2Il0nH/LDs8tLCZaPT4q4efUFlp6
ZDnAGCYj1Qu+q7ROkFB8HSVVaADZh+ElmSnX55sqAQKBgQDSabSKF2k8yTx1rTyp
x3GcmDOEtM8ksJWhQj1BwLbV0++Zow3oiwP4GPx0dsGuJfE7q3fQyc5UrTuHC22W
7hccWD316rJWhBSH2cHkRenEUSWox7+2qU5ph8nyBZX6YacextiqEKEg5AlPL0ox
YLOG8OZ5YwzwXpj83ViSwxGmrQKBgQDRHExQTXjmwjLR/GN3epmh0efCcIAzwjWo
R/WiHlHsGcQiAfXNbDEhuIStgi3xvhQw+213tscuHyetcRRZPudpAIAkBLRAlZ51
UxtFPuYjpGb0hW5jJJL1KTOKvi+ARCyY/89Zp0mQvDCLm5Ux9pu+fogt6OW4+G0J
8iRv5c4bYQKBgQCuoyE/Q/MKipNtsB0bZPe82u5XhKIwd4eZUhr5ifO2QbMptxWC
Hm9q6YIPP8m8uq0fs088sWJZEXbIvQl2LaJs2iiDBQqDmBhaMLgmuIgvcpJpJXDP
MHJuUE+iWlSCfa5xcuS9MhQp8lpvqHZRyUr4AtWnhjhlAH7F0QkEtnbd+QKBgGYo
Tfv5LTSG8S72/1zybzXIB1JNhcRDf9U7env+FgWjPNdkX8JAtewEagUeEPYF53Va
j8spZztYCxlHoipLeeApV3DBP5JBxg0JUcxNgz8sZQPWX+xdhNHyk/SXHzupkqQY
bSMef+kOlyTNGGE1WjcBN+Q94GSyMQrn2fc0rLFhAoGABFWH7YFHUSZQQCKP/8st
ZCp7fnbJvXOztptOxULkC6pJ+EFpH+l+4cyhVQAaIJ4Vl+rk0QvCFWOvx+hgjimq
PE+O7a4UF449ha1H3uvlGRoOLInxwZ4BDPWYP4hX+RWP/Zi0gsFezwOAWqAcv5/y
z9Oc6U0wumOXqi9JzVFZKyw=
-----END PRIVATE KEY-----
EOF

sudo tee -a /usr/share/easy-rsa/pki/dh.pem > /dev/null << EOF
-----BEGIN DH PARAMETERS-----
MIIBCAKCAQEAgQ+dT6G7HSHzApe9KaMiVwK72RLFQ5Ir3TusOAVQxzMlrvXwS+NV
pwQ6HTfSHf8lDzldVGDx7ors+m9NzWWAsAt84pILueaUdOLwMc7gtvCkb+rlV2B8
puRyZ2mJOnOlDIKch2NAA+49N+Zd6Qu8RxVc6t5xJgbICpKwThpgt6DVANEAEEe8
XvwgQJ2WOK6jCAip8EJZRKmhFIslE+xx9HtMHaUlX9+D8bSefXNOdHaTxVYe8iJQ
fp2221KQhk2GKGK7+BX2ejON0njG/3nBMBhqCPzpVh7jqN39AD9hwuHeH4QjEMMB
Ym0RenoIZgArtNz1XkxB/2/AsYiq7/AHKwIBAg==
-----END DH PARAMETERS-----
EOF

sudo tee -a /usr/share/easy-rsa/ta.key > /dev/null <<EOF
#
# 2048 bit OpenVPN static key
#
-----BEGIN OpenVPN Static key V1-----
ce675a9ba8666a7a48dc6d1d4f5ee2f7
13560fa4fc642129f7d1f552d218d79b
71a6a8753abc749e8590bb46bae898a1
8739947b07660a7ae242ea12732634ec
546bf81b0ecfe6f8a493bd1ea7747f57
3b06640d8ff7e1daf97e1faf39fd0c59
1d99b86c588912a55c685e142cc330ac
14419baaa9be11792c6b5cf0527e4657
8a37b147a18ad2a6c73516df2eb5433c
827c050a29e4ccca7a2b72755e390e13
3039560ef4fb8568fbc06200a6a60c14
dfda29161591b86722596a226b73bd69
1727afedd793a5b7a8d35580aac0cd1b
7b7d2ff07e11358d8255fda546028712
a13da489c4c3f8fd0b45b9be8e4c8ca1
290e5a246df5609db07fe394ce3a5e09
-----END OpenVPN Static key V1-----
EOF

sudo cp /usr/share/easy-rsa/pki/ca.crt /usr/share/easy-rsa/pki/issued/vpnserver.crt /usr/share/easy-rsa/pki/private/vpnserver.key /usr/share/easy-rsa/pki/dh.pem /usr/share/easy-rsa/ta.key /etc/openvpn/

# sudo gzip -d /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz
# sudo cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf /etc/openvpn/
# sudo cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf /etc/openvpn/client.conf

sudo cp /usr/share/doc/openvpn/examples/sample-scripts/bridge-start /etc/openvpn/
sudo sed -i 's/eth0/enp0s8/g' /etc/openvpn/bridge-start
sudo sed -i 's/192.168.8./192.168.0./g' /etc/openvpn/bridge-start
sudo sed -i 's/192.168.0.4/192.168.0.2/g' /etc/openvpn/bridge-start
sudo /etc/openvpn/bridge-start

sudo cp /vagrant/server.conf /etc/openvpn/
sudo systemctl restart openvpn@server

# sudo systemctl status openvpn@server
# sudo systemctl enable openvpn@server #enable it so that it starts automatically at boot


# sudo systemctl stop openvpn@server
# sudo cp /usr/share/doc/openvpn/examples/sample-scripts/bridge-stop /etc/openvpn/
# sudo /etc/openvpn/bridge-stop


# route setup
# sudo cp /vagrant/server_route.conf /etc/openvpn/server.conf
# # sudo openvpn --config server.conf # check if it works
# sudo tee -a /etc/sysctl.conf > /dev/null <<EOF
# net.ipv4.ip_forward=1
# EOF
# sudo iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE
# sudo systemctl restart openvpn@server
