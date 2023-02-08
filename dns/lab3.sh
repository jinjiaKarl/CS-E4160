sudo apt-get update
sudo apt-get install -y bind9 bind9utils


tee -a /etc/bind/keyname.key > /dev/null <<EOF
key "keyname" {
        algorithm hmac-sha1;
        secret "w5aj7j4O54Tl6OdncPOMr0aKnno=";
};
EOF


sudo tee -a /etc/bind/named.conf > /dev/null <<EOF
include "/etc/bind/keyname.key";

zone "not.insec" {
  type slave;
  masters { 192.168.64.15; };
  file "/var/cache/bind/db.not.insec";
};

server 192.168.64.15 {
  keys {keyname;};
};
EOF

sed -i '/options /i \
recursion yes; \
allow-query { localhost;192.168.64.0/24; }; \
' /etc/bind/named.conf.options