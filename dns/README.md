## questions

2.1 Caching-only nameserver configuration

Configure the nameserver to forward all queries for which it does not have a
cached answer to Google's public nameserver (8.8.8.8). Only allow queries and
recursion from local network.

Start your nameserver and watch the logfile /var/log/syslog for any error
messages. Check that you can resolve addresses through your own nameserver from
the client machine. You can use dig(1) to do the lookups.

```
# refer to https://www.digitalocean.com/community/tutorials how-to-configure-bind-as-a-caching-or-forwarding-dns-server-on-ubuntu-14-04
sudo apt update
# install name server daemon, named, the Bind administration tool, rndc
sudo apt-get install bind9 bind9utils -y
systemctl start named


systemctl stop systemd-resolved

# /etc/bind
cp /etc/bind/named.conf.options{,.bak}
vim /etc/bind/named.conf.options
max-cache-ttl 600 # 600s


#  -x option is supplied to indicate a reverse looku
dig @192.168.64.13 www.alibaba.com

# view bind9 cache https://linuxconfig.org/how-to-view-and-clear-bind-dns-server-s-cache-on-linux
rndc dumpdb -cache
grep alibaba /var/named/data/cache_dump.db
rndc dumpdb flush
```

2.2 What is a recursive query? How does it differ from an iterative query?

In the context of DNS, a recursive query is a query made by a client to a DNS
resolver, asking the resolver to find the answer to a specific domain name
question. The DNS resolver will then make multiple iterative queries to various
DNS servers in order to resolve the requested domain name.

In an iterative query, the DNS client directly queries multiple DNS servers, and
receives the best answer available from each server. The client then combines
the information obtained from all the servers to build a complete response.

The main difference between the two approaches is that in a recursive query, the
responsibility of finding the complete answer is taken on by the DNS resolver,
while in an iterative query, the responsibility is shared between the client and
the DNS servers. The use of recursive queries is more common in modern DNS
setups, as it simplifies the process for the client and reduces the load on
individual DNS servers.

3.1 Configure ns1 to be the primary master for .insec domain.

```
# refer to https://blog.csdn.net/networken/article/details/120908256
# check configuration
named-checkconf
named-checkzone insec ./db.64.168.192.in-addr.arpa
named-checkzone insec ./db.insec


# named.conf add zone
```

3.2 Provide the output of dig(1) for a successful query.

```
# test
root@lab1:/etc/bind# dig @127.0.0.1 www.ns1.insec

; <<>> DiG 9.16.1-Ubuntu <<>> @127.0.0.1 www.ns1.insec
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 53171
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: ba5121ed65655a3d0100000063e1389a40449c3e5828f9bd (good)
;; QUESTION SECTION:
;www.ns1.insec.                 IN      A

;; AUTHORITY SECTION:
insec.                  60      IN      SOA     insec. hostmaster.insec. 2022120100 60 60 60 60

;; Query time: 0 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Mon Feb 06 17:27:54 UTC 2023
;; MSG SIZE  rcvd: 122
```

3.3 How would you add an IPv6 address entry to a zone file?

```
To add an IPv6 address entry to a zone file, you can use an AAAA (quad-A) record, which is used to map a hostname to an IPv6 address. Here is an example of how you would add an AAAA record to a zone file:

example.com. IN AAAA 2001:0db8:85a3:0000:0000:8a2e:0370:7334


example.com. is the hostname for which the IPv6 address is being defined.
IN is the record class, which stands for "Internet."
AAAA is the record type, which stands for "IPv6 address."
2001:0db8:85a3:0000:0000:8a2e:0370:7334 is the IPv6 address being mapped to the hostname.
After adding the AAAA record to your zone file, be sure to save the changes and reload your DNS server to make the changes take effect.
```

4.1 Configure ns2 to work as a slave for .insec domain.

```
# add zone in named.conf
# add slave information in named.conf, db.insec, db.64.168.192.in-addr.arpa in master
# increase serial number in master and restart named

# show zone file in slave
named-compilezone -f raw -F text -o insec.zone.out insec db.insec
cat insec.zone.out
```

4.2 Explain the changes you made

```
type: slave
increment serial number on master
```

4.3 Provide the output of dig(1) for a successful query from the slave server.
Are there any differences to the queries from the master?

```
dig SOA +multiline  www.baidu.com
root@lab2:/etc/bind# dig @192.168.64.15  www.ns1.insec

; <<>> DiG 9.16.1-Ubuntu <<>> @192.168.64.15 www.ns1.insec
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 37354
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 078b096e1165c2bc0100000063e155f1ae730e476674519b (good)
;; QUESTION SECTION:
;www.ns1.insec.                 IN      A

;; AUTHORITY SECTION:
insec.                  60      IN      SOA     insec. hostmaster.insec. 2022120102 60 60 60 60

;; Query time: 0 msec
;; SERVER: 192.168.64.15#53(192.168.64.15)
;; WHEN: Mon Feb 06 19:33:05 UTC 2023
;; MSG SIZE  rcvd: 122


In DNS, a slave server (also known as a secondary server) obtains DNS information from a master (or primary) server through a process called zone transfer. The slave server uses this information to answer queries for a specific portion of the DNS namespace, called a zone.

There should be no difference in the query process between a master and a slave server, as both servers are capable of answering queries. However, the data served by the slave server is a copy of the data on the master server and may be slightly out of date, as zone transfers are not performed in real-time. Additionally, the master server is responsible for making changes to the DNS data, while the slave server is read-only.
```

5.1 Create a subdomain .not.insec, use ns2 as a master and ns3 as a slave.

```
```

5.2 Provide the output of dig(1) for successful queries from all the three name
servers.

```
root@lab1:/etc/bind# dig @127.0.0.1 ns2.not.insec.

; <<>> DiG 9.16.1-Ubuntu <<>> @127.0.0.1 ns2.not.insec.
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 50054
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 2e8ece9cae4e0fc10100000063e3f84a3a92f98949e808df (good)
;; QUESTION SECTION:
;ns2.not.insec.                 IN      A

;; ANSWER SECTION:
ns2.not.insec.          60      IN      A       192.168.64.15

;; Query time: 4 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Wed Feb 08 19:30:18 UTC 2023
;; MSG SIZE  rcvd: 86



root@lab2:/etc/bind# dig @127.0.0.1 ns2.not.insec.

; <<>> DiG 9.16.1-Ubuntu <<>> @127.0.0.1 ns2.not.insec.
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 64435
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: d528ab5ee9ded1930100000063e3f83c86db922f65f0d847 (good)
;; QUESTION SECTION:
;ns2.not.insec.                 IN      A

;; ANSWER SECTION:
ns2.not.insec.          60      IN      A       192.168.64.15

;; Query time: 0 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Wed Feb 08 19:30:04 UTC 2023
;; MSG SIZE  rcvd: 86



root@lab3:/etc/bind# dig @127.0.0.1 ns2.not.insec.

; <<>> DiG 9.16.1-Ubuntu <<>> @127.0.0.1 ns2.not.insec.
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 50221
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 3f3dd87783e09a720100000063e3f81d0277d4338c1843e0 (good)
;; QUESTION SECTION:
;ns2.not.insec.                 IN      A

;; ANSWER SECTION:
ns2.not.insec.          60      IN      A       192.168.64.15

;; Query time: 3 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Wed Feb 08 19:29:33 UTC 2023
;; MSG SIZE  rcvd: 86
```

6.1 Implement transaction signatures

```
# https://tomthorp.me/blog/using-tsig-enable-secure-zone-transfers-between-bind-9x-servers
root@lab2:/etc/bind# tsig-keygen -a hmac-sha1 keyname | tee keyname.key
key "keyname" {
        algorithm hmac-sha1;
        secret "w5aj7j4O54Tl6OdncPOMr0aKnno=";
};
root@lab2:/etc/bind# cat keyname.key
key "keyname" {
        algorithm hmac-sha1;
        secret "w5aj7j4O54Tl6OdncPOMr0aKnno=";
};




root@lab3:/etc/bind# dig @192.168.64.15 not.insec axfr

; <<>> DiG 9.16.1-Ubuntu <<>> @192.168.64.15 not.insec axfr
; (1 server found)
;; global options: +cmd
; Transfer failed.


root@lab3:/etc/bind# dig @192.168.64.15 not.insec axfr

; <<>> DiG 9.16.1-Ubuntu <<>> @192.168.64.15 not.insec axfr
; (1 server found)
;; global options: +cmd
; Transfer failed.
root@lab3:/etc/bind# dig @192.168.64.15 not.insec axfr  -k /etc/bind/keyname.key

; <<>> DiG 9.16.1-Ubuntu <<>> @192.168.64.15 not.insec axfr -k /etc/bind/keyname.key
; (1 server found)
;; global options: +cmd
not.insec.              60      IN      SOA     ns2.not.insec. not.hostmaster.insec. 2022120200 60 60 60 60
not.insec.              60      IN      NS      ns2.not.insec.
not.insec.              60      IN      NS      ns3.not.insec.
host1.not.insec.        60      IN      A       192.168.64.99
ns2.not.insec.          60      IN      A       192.168.64.15
ns3.not.insec.          60      IN      A       192.168.64.17
not.insec.              60      IN      SOA     ns2.not.insec. not.hostmaster.insec. 2022120200 60 60 60 60
keyname.                0       ANY     TSIG    hmac-sha1. 1675893793 300 20 zwkbSYYs6gPkJQ3wj+/KgcVDO54= 42470 NOERROR 0 
;; Query time: 4 msec
;; SERVER: 192.168.64.15#53(192.168.64.15)
;; WHEN: Wed Feb 08 22:03:13 UTC 2023
;; XFR size: 7 records (messages 1, bytes 314)
```

6.2 TSIG is one way to implement transaction signatures. DNSSEC describes
another, SIG(0). Explain the differences.

TSIG (Transaction SIGnature) and SIG(0) (Signature 0) are both methods for
authenticating DNS transactions, but they are different in their implementation
and security properties.

TSIG is a method for adding an authentication mechanism to DNS transactions,
which are used to transfer DNS data between a client and a server. TSIG uses a
secret key shared between the client and server to sign each DNS transaction and
ensure its integrity and authenticity. TSIG uses a message-digest algorithm
(such as HMAC-MD5) to generate the signature.

SIG(0) (Signature 0), on the other hand, is part of the DNSSEC (Domain Name
System Security Extensions) protocol, which provides a more comprehensive
security mechanism for the DNS. DNSSEC uses public-key cryptography to secure
the DNS data, and SIG(0) is used to sign individual resource records within a
DNS zone. Unlike TSIG, which only provides transaction-level security, DNSSEC
provides end-to-end security for the entire DNS data, from the root zone down to
individual resource records.

In summary, while both TSIG and SIG(0) are methods for authenticating DNS
transactions, TSIG provides transaction-level security while SIG(0) provides
end-to-end security for the entire DNS data through the use of public-key
cryptography.

## Basic DNS concepts

```
https://www.starduster.me/2016/08/16/brief-discussion-of-dns-lookup/
```

Caching DNS Server: When a caching DNS server tracks down the answer to a
client’s query, it returns the answer to the client. But it also stores the
answer in its cache for the period of time allowed by the records’ TTL value.

Forwarding DNS Server: A forwarding DNS server offers the same advantage of
maintaining a cache to improve DNS resolution times for clients. However, it
actually does none of the recursive querying itself. Instead, it forwards all
requests to an outside resolving server and then caches the results to use for
later queries.

bind9 configuration file

- named.conf
- named.conf.options
- named.conf.local
- named.conf.default-zones

bind9 concepts

- acl
  定义这部分的内容来规定IP是否能够被接入以及Blocklist来阻止某些特定的IP地址介入到域名解析服务器中。
- zone file 定义域名与IP地址的映射关系以及DNS发送的解析域名数据包的相关参数设置
  @代表当前的区域，可以由@ORIGIN定义

Transaction Signatures (TSIG) provide a secure method for communicating from a
primary to a secondary Domain Name server (DNS).
