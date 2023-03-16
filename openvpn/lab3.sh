# Roadwarrior

sudo apt-get update
sudo apt-get install openvpn easy-rsa -y

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


sudo tee -a /usr/share/easy-rsa/pki/issued/vpnclient.crt > /dev/null <<EOF
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            fe:48:c3:84:29:50:5c:39:73:80:0b:06:27:83:cc:98
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN=Easy-RSA CA
        Validity
            Not Before: Mar 13 11:14:23 2023 GMT
            Not After : Feb 25 11:14:23 2026 GMT
        Subject: CN=vpnclient
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:b3:55:db:53:3f:8e:cf:e2:20:95:e0:05:69:a4:
                    31:01:1e:d3:0f:2b:55:88:c4:38:76:cd:21:3b:f3:
                    7b:6b:ef:c7:e3:a8:87:58:8a:c4:be:e1:7e:67:02:
                    e9:8f:ad:15:59:ca:40:1c:86:20:02:9d:96:4e:96:
                    65:05:41:bf:96:ff:39:59:5e:8d:0f:0b:54:c1:04:
                    cf:f5:58:ad:43:77:df:8f:4b:99:f1:18:c4:5d:18:
                    1e:29:34:63:e6:f9:14:e9:41:28:af:79:31:f8:5f:
                    03:1a:3b:97:ae:71:70:59:32:74:39:af:25:41:79:
                    57:1b:eb:00:11:35:d3:2f:43:9b:81:81:2b:0c:bb:
                    11:b3:e5:2d:93:b6:61:f6:a1:da:03:e0:b6:78:9c:
                    c6:66:35:fa:7c:43:ce:4f:05:e0:2e:c1:c7:78:24:
                    57:78:cc:37:a6:3a:b1:95:60:06:d1:f4:21:f3:30:
                    d5:19:cc:32:b0:96:56:3f:2f:41:83:e8:f4:9f:fb:
                    a3:9b:8c:f3:fb:b7:9d:22:2d:8a:7b:e3:f2:b5:1f:
                    4a:27:6f:5e:13:4b:83:a5:62:16:c7:8d:a9:a7:a3:
                    e7:aa:c1:60:0d:6f:fc:88:1f:38:a5:54:ea:3b:f1:
                    a7:51:60:c1:ee:98:60:37:ef:be:57:1c:61:c2:38:
                    2c:59
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints:
                CA:FALSE
            X509v3 Subject Key Identifier:
                09:DC:4D:B7:5F:3C:4A:83:C4:7C:2F:0D:7F:E1:09:1F:56:71:9B:4D
            X509v3 Authority Key Identifier:
                keyid:43:36:92:E3:BE:9C:20:BE:EA:8E:78:14:72:88:F9:5C:CE:78:2B:9A
                DirName:/CN=Easy-RSA CA
                serial:52:44:E4:EB:90:4C:B2:AF:B5:BD:0F:59:E7:AE:B7:C7:FC:8D:80:B3

            X509v3 Extended Key Usage:
                TLS Web Client Authentication
            X509v3 Key Usage:
                Digital Signature
    Signature Algorithm: sha256WithRSAEncryption
         20:79:a2:18:dd:04:8d:e2:77:54:88:5d:18:f1:be:ef:d6:2a:
         ea:45:05:da:9b:6f:3c:8f:b1:55:6a:6b:61:c1:69:a6:a9:d6:
         d6:3c:b8:7c:bb:52:0c:47:9f:5d:ef:4e:a5:48:ce:20:fc:90:
         e4:c5:67:4d:c8:7a:0e:73:0d:66:d3:25:18:4e:b7:f6:d6:15:
         f7:fa:72:e3:35:72:f5:19:0b:ae:3b:aa:09:eb:df:e5:8c:6a:
         1b:6d:31:30:f9:b8:40:ec:48:ef:3e:98:b4:87:96:fb:26:db:
         53:ff:17:9b:0d:78:d0:c9:21:1c:20:5f:44:8b:0b:3d:62:33:
         28:bd:c8:9d:65:a0:c9:f8:4e:ca:4a:c3:78:07:36:7d:28:85:
         68:8d:e3:1d:6b:57:9a:f4:11:a3:c0:7a:47:8b:56:6d:4e:75:
         7c:37:98:95:65:89:04:ba:a1:d3:4e:ac:42:16:01:f8:ef:8b:
         4a:74:c1:4c:3b:06:32:2a:45:f1:39:ba:d1:24:46:fb:ee:11:
         34:00:24:6e:21:29:c7:4d:19:5e:4e:c1:62:44:95:c7:7c:ee:
         9c:34:fe:ff:ba:55:18:01:e4:d7:70:ce:4b:d4:07:ab:1d:f6:
         b6:38:1d:83:92:8d:2d:30:a0:c4:35:61:87:e4:90:78:06:13:
         03:ba:36:5d
-----BEGIN CERTIFICATE-----
MIIDWDCCAkCgAwIBAgIRAP5Iw4QpUFw5c4ALBieDzJgwDQYJKoZIhvcNAQELBQAw
FjEUMBIGA1UEAwwLRWFzeS1SU0EgQ0EwHhcNMjMwMzEzMTExNDIzWhcNMjYwMjI1
MTExNDIzWjAUMRIwEAYDVQQDDAl2cG5jbGllbnQwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQCzVdtTP47P4iCV4AVppDEBHtMPK1WIxDh2zSE783tr78fj
qIdYisS+4X5nAumPrRVZykAchiACnZZOlmUFQb+W/zlZXo0PC1TBBM/1WK1Dd9+P
S5nxGMRdGB4pNGPm+RTpQSiveTH4XwMaO5eucXBZMnQ5ryVBeVcb6wARNdMvQ5uB
gSsMuxGz5S2TtmH2odoD4LZ4nMZmNfp8Q85PBeAuwcd4JFd4zDemOrGVYAbR9CHz
MNUZzDKwllY/L0GD6PSf+6ObjPP7t50iLYp74/K1H0onb14TS4OlYhbHjamno+eq
wWANb/yIHzilVOo78adRYMHumGA3775XHGHCOCxZAgMBAAGjgaIwgZ8wCQYDVR0T
BAIwADAdBgNVHQ4EFgQUCdxNt188SoPEfC8Nf+EJH1Zxm00wUQYDVR0jBEowSIAU
QzaS476cIL7qjngUcoj5XM54K5qhGqQYMBYxFDASBgNVBAMMC0Vhc3ktUlNBIENB
ghRSROTrkEyyr7W9D1nnrrfH/I2AszATBgNVHSUEDDAKBggrBgEFBQcDAjALBgNV
HQ8EBAMCB4AwDQYJKoZIhvcNAQELBQADggEBACB5ohjdBI3id1SIXRjxvu/WKupF
BdqbbzyPsVVqa2HBaaap1tY8uHy7UgxHn13vTqVIziD8kOTFZ03Ieg5zDWbTJRhO
t/bWFff6cuM1cvUZC647qgnr3+WMahttMTD5uEDsSO8+mLSHlvsm21P/F5sNeNDJ
IRwgX0SLCz1iMyi9yJ1loMn4TspKw3gHNn0ohWiN4x1rV5r0EaPAekeLVm1OdXw3
mJVliQS6odNOrEIWAfjvi0p0wUw7BjIqRfE5utEkRvvuETQAJG4hKcdNGV5OwWJE
lcd87pw0/v+6VRgB5NdwzkvUB6sd9rY4HYOSjS0woMQ1YYfkkHgGEwO6Nl0=
-----END CERTIFICATE-----
EOF

sudo tee -a /usr/share/easy-rsa/pki/private/vpnclient.key > /dev/null << EOF
-----BEGIN PRIVATE KEY-----
MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCzVdtTP47P4iCV
4AVppDEBHtMPK1WIxDh2zSE783tr78fjqIdYisS+4X5nAumPrRVZykAchiACnZZO
lmUFQb+W/zlZXo0PC1TBBM/1WK1Dd9+PS5nxGMRdGB4pNGPm+RTpQSiveTH4XwMa
O5eucXBZMnQ5ryVBeVcb6wARNdMvQ5uBgSsMuxGz5S2TtmH2odoD4LZ4nMZmNfp8
Q85PBeAuwcd4JFd4zDemOrGVYAbR9CHzMNUZzDKwllY/L0GD6PSf+6ObjPP7t50i
LYp74/K1H0onb14TS4OlYhbHjamno+eqwWANb/yIHzilVOo78adRYMHumGA3775X
HGHCOCxZAgMBAAECggEBAJdR873b3GI22O392DNakuryGn8rPoInp8k+rzNJ8LOT
4OOM+Z9RgE/cL282OuO71U8tZEltNydd1006g8UaxFHhy39IU9gE5J/1so/AInrS
dDYSQbP5BP/UcOatyTpEpEtpaq4doneDnDePXx6Xo4fwFbfyvInxm/n3odfjxe2T
QU/TxfKfjWxmNYE5ckfc+nnPFpfr3D1FNjnaQ0hJmTjGVT5QobDJ8NeD2xcBVqb6
oHF3RyNpHYzMy3X2ZQa0e11DvH0MasLJWDFUyX+Yn8D9DUIhQca9xNALUmet5mwS
wqla0eEU+eYw1ZNxZHGsC1t3vMP4XBP9B52zn6HwZe0CgYEA4hHqkJdQKDJfjSws
Hv8cbik6Ev89ZdNeVEC4Wrsf2gPozU+Y0d8XQO+M+wUTSGZpar5mDVHx60j7c5y9
/YkF8KixW+Mm18LtUShzTSsxJ9AP2PNSlCFVktuoW2RRM3VJxjan1tWO8r9E+fRk
9xL/TORUGfTq7LnTlyKTAn/KnYsCgYEAyxP8g/oALn0Qym/sksfS0E2n7aVeOnkk
gjTbjr/n7KYE1Ml7Nmm3QJnaUttUrPAmLEAX/bIjwuAQgeCEuQ552E63Kz3KS6Yc
zTmAfSJSGzrsHBGGI9oyEaqs93oamOrKUM1hNPuJKKg51CibXMPZGr3ra7dOOX+w
Js2/2V2x4isCgYEAqLDjzmcKiiQkhsxKVArbJRygWCKbpwrVHZt5tUJinyVBp0pY
52pICM137qu32tOIn/1ZW2ElWwOHlpqEbta7VvwZ9E4I4wFyYpgDibbMJEAuQx42
JZDGMSK1exTdPr+rgDuyfC25UEwHZVjHqlJDrRXH5+KJFoIHcIR9HGVNRMcCgYAe
kYacMyCd3tONNWXN/mg8VMQnYJIbiSq2stAt37NAiwkFIsL6QNWF0uLrP/qyAYAt
fwRdetgpOGMjubEgzg4HQmoOB0IROxLwzWwK6gSj9q2d2AFyGiEZSbC5m9avGACW
QyQTvp050oDJ78bbItvmS5pJX5FV1GOmo6fyR0lEewKBgQCwW4N/kver3+pfd1/B
T5rqyc4bzn5xoiL/vBbVZRdlN9tMXkpma/58LgcaOME+xXGam2uUMgR5/RgkDMBQ
x9M410ZCPLIpGEJTGO2OtXG1rkSfb+qDZAq+B8XkSoES7owMCwPfFpLR2lnfQ/Cr
1MBDA2cHhSD3I/UFYti31z+eUQ==
-----END PRIVATE KEY-----
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


sudo cp /usr/share/easy-rsa/pki/ca.crt /usr/share/easy-rsa/pki/issued/vpnclient.crt /usr/share/easy-rsa/pki/private/vpnclient.key /usr/share/easy-rsa/ta.key /etc/openvpn/


# route
sudo tee -a /etc/openvpn/bash.conf > /dev/null <<EOF
remote 192.168.64.20 1194
#ca ca.crt
#cert client.crt
#key client.key
#tls-auth ta.key 1

cipher AES-256-CBC
auth SHA256
key-direction 1
EOF
sudo bash /etc/openvpn/make_client.sh vpnclient
# 
# sudo systemctl start openvpn@client