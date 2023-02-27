#!/usr/bin/env bash


sudo apt-get update
sudo apt-get install -y bind9 bind9utils  net-tools
sed -i '1i\
acl goodclients { \
192.168.1.0/24; \
localhost; \
localnets; \
}; \
' /etc/bind/named.conf.options



sed -i '/options /a \
forwarders { \
8.8.8.8; \
//127.0.0.1 port 5353; \
}; \
recursion yes; \
allow-query { goodclients; }; \
allow-recursion { goodclients; }; \
//listen-on port 53 { 127.0.0.1; 192.168.1.10;}; \
' /etc/bind/named.conf.options


tee -a /etc/bind/named.conf > /dev/null <<EOF
zone "insec" {
    type master;
    file "/etc/bind/db.insec";
    allow-transfer { 192.168.1.11; };
    also-notify { 192.168.1.11; };
};

zone "1.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.1.168.192.in-addr.arpa";
    allow-transfer { 192.168.1.11; };
    also-notify { 192.168.1.11; };
};

zone "not.insec" {
   type forward;
   forwarders {192.168.1.11;};
};
EOF

cd /etc/bind
touch db.insec
touch db.1.168.192.in-addr.arpa

tee /etc/bind/db.insec > /dev/null <<EOF
; Zone file for .insec
\$TTL 60
@ IN SOA ns1.insec. hostmaster.insec. (
      2022120100 ; Serial
      60 ; Refresh
      60 ; Retry
      60 ; Expire
      60 ; Minimum TTL
)
; Define the default name server to ns1.insec.
;@ IN NS ns1
@ IN NS ns1.insec.
@ IN NS ns2.insec.


; Resolve ns1 to server IP address
; A record for the main DNS
ns1 IN A 192.168.1.10
ns2 IN A 192.168.1.11

; host
host1 IN A 192.168.1.88
web.insec. IN CNAME host1.insec.

; sub domain
; @ORIGIN not.insec.
not.insec. IN NS ns2.not.insec.
;@ IN NS ns1.insec.
ns2.not.insec. IN A 192.168.1.11 ; 'glue' record
EOF

tee -a /etc/bind/db.1.168.192.in-addr.arpa > /dev/null <<EOF
\$TTL 60
@ IN SOA 1.168.192.in-addr.arpa hostmaster.insec. (
      2022120100 ; Serial
      60 ; Refresh
      60 ; Retry
      60 ; Expire
      60 ; Minimum TTL
)
; Name server
@ IN NS ns1
@ IN NS ns2

;Other Servers
ns1  IN      A       192.168.1.10
ns2  IN      A       192.168.1.11

; PTR records
10 IN PTR ns1.insec. ; 192.168.1.10
11 IN PTR ns2.insec. ; 192.168.1.11
11 IN PTR ns2..not.insec. ; 192.168.1.11
88 IN PTR host1.insec. ; 192.168.1.88
EOF

cd /etc/bind
named-checkzone insec ./db.1.168.192.in-addr.arpa
named-checkzone insec ./db.insec

systemctl restart bind9 

# block data from lab3
iptables -I INPUT -s 192.168.1.12 -j DROP

sudo mkdir -p /etc/pihole
sudo tee /etc/pihole/setupVars.conf <<EOF
PIHOLE_INTERFACE=enp0s8
PIHOLE_DNS_1=8.8.8.8
PIHOLE_DNS_2=8.8.4.4
QUERY_LOGGING=true
INSTALL_WEB_SERVER=true
INSTALL_WEB_INTERFACE=true
LIGHTTPD_ENABLED=true
CACHE_SIZE=10000
DNS_FQDN_REQUIRED=true
DNS_BOGUS_PRIV=true
DNSMASQ_LISTENING=local
WEBPASSWORD=49dc52e6bf2abe5ef6e2bb5b0f1ee2d765b922ae6cc8b95d39dc06c21c848f8c
EOF

curl -sSL https://install.pi-hole.net | bash /dev/stdin --unattended
pihole -b google.com
# # pihole -b -d google.com
sudo tee -a /etc/dnsmasq.conf <<EOL
port=5353
EOL
pihole restartdns