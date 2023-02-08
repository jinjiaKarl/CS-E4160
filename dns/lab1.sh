#!/usr/bin/env bash


sudo apt-get update
sudo apt-get install -y bind9 bind9utils
sed -i '1i\
acl goodclients { \
192.168.64.0/24; \
localhost; \
localnets; \
}; \
' /etc/bind/named.conf.options

sed -i '/options /i \
forwarders { \
8.8.8.8; \
}; \
recursion yes; \
allow-query { goodclients; }; \
' /etc/bind/named.conf.options



tee -a /etc/bind/named.conf > /dev/null <<EOF
zone "insec" {
    type master;
    file "/etc/bind/db.insec";
    allow-transfer { 192.168.64.15; };
    also-notify { 192.168.64.15; };
};

zone "64.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.64.168.192.in-addr.arpa";
    allow-transfer { 192.168.64.15; };
    also-notify { 192.168.64.15; };
};

zone "not.insec" {
   type forward;
   forwarders {192.168.64.15;};
};
EOF

cd /etc/bind
touch db.insec
touch db.64.168.192.in-addr.arpa

tee /etc/bind/db.insec > /dev/null <<EOF
; Zone file for .insec
$TTL 60
@ IN SOA ns1.insec. hostmaster.insec. (
      2022120105 ; Serial
      60 ; Refresh
      60 ; Retry
      60 ; Expire
      60 ; Minimum TTL
)
; Define the default name server to ns1.insec.
;@ IN NS ns1
@ IN NS ns1.insec.
@ IN NS ns2

; Resolve ns1 to server IP address
; A record for the main DNS
ns1 IN A 192.168.64.13
ns2 IN A 192.168.64.15

; host
host1 IN A 192.168.64.88
web.insec. IN CNAME host1.insec.

; sub domain
; @ORIGIN not.insec.
not.insec. IN NS ns2.not.insec.
;@ IN NS ns1.insec.
ns2.not.insec. IN A 192.168.64.15 ; 'glue' record
EOF

tee -a /etc/bind/db.64.168.192.in-addr.arpa > /dev/null <<EOF
$TTL 60
@ IN SOA 64.168.192.in-addr.arpa hostmaster.insec. (
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
ns1  IN      A       192.168.64.13
ns2  IN      A       192.168.64.15

; PTR records
13 IN PTR ns1.insec. ; 192.168.64.13
15 IN PTR ns2.insec. ; 192.168.64.15
88 IN PTR host1.insec. ; 192.168.64.88
EOF
