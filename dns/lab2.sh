#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install -y bind9 bind9utils  net-tools



tee -a /etc/bind/keyname.key > /dev/null <<EOF
key "keyname" {
        algorithm hmac-sha1;
        secret "w5aj7j4O54Tl6OdncPOMr0aKnno=";
};
EOF


sudo tee -a /etc/bind/named.conf > /dev/null <<EOF
zone "insec" {
    type slave;
    masters { 192.168.1.10; };
    // masters { 192.168.1.10 port 5353; };
    file "/var/cache/bind/db.insec";
};

zone "1.168.192.in-addr.arpa" {
    type slave;
    masters { 192.168.1.10; };
    // masters { 192.168.1.10 port 5353; };
    file "/var/cache/bind/db.1.168.192.in-addr.arpa";
    allow-transfer { key "keyname";};
};

zone "not.insec" {
  type master;
  file "/etc/bind/db.not.insec";
  allow-transfer { key "keyname";};
  // allow-transfer { 192.168.1.12; }
  // also-notify { 192.168.1.12; };
};

include "/etc/bind/keyname.key";
EOF

sudo tee -a /etc/bind/db.not.insec > /dev/null <<EOF
\$TTL 60
@ IN SOA ns2.not.insec. not.hostmaster.insec. (
      2022120200 ; Serial
      60 ; Refresh
      60 ; Retry
      60 ; Expire
      60 ; Minimum TTL
)

@ IN NS ns2.not.insec.
@ IN NS ns3.not.insec.

ns2 IN A 192.168.1.11
ns3 IN A 192.168.1.12
host1.not.insec. IN A 192.168.1.99
EOF

sed -i '/options /a \
recursion yes; \
allow-query { localhost;192.168.1.0/24; }; \
' /etc/bind/named.conf.options


cd /etc/bind
named-checkzone not.insec ./db.not.insec
systemctl restart bind9 