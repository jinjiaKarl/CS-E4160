## Setting up 

```bash
az login
terrform init
terraform apply

```

## Questions

1.1 Verify that you can ssh from lab1 to lab2 & lab3. Use ssh agent forwarding when connecting to lab2 and lab3 or copy the private key to lab1 to allow login to lab2 & lab3. Ensure that you can ping other instances over all of the three networks. 

```bash
# ssh agent forwarding
# on local machine
eval `ssh-agent`
ssh-add ~/.ssh/id_rsa
ssh -A azuseruser@public_ip
ssh azuser@private_ip
```

2.1 Using ip(8), find all the active interfaces on your machine.
```bash
azureuser@lab1:~$ ip link show up
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 00:22:48:a3:d9:7a brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 00:22:48:a3:d7:90 brd ff:ff:ff:ff:ff:ff
```

2.2 Using netstat(8) and arp(8), find the MAC address of the default router of your machine.

```bash
azureuser@lab1:~$ netstat -rn | awk '{print $2}' | awk 'NR==3' | arp -n
Address                  HWtype  HWaddress           Flags Mask            Iface
10.0.1.4                 ether   12:34:56:78:9a:bc   C                     eth0
10.0.1.1                 ether   12:34:56:78:9a:bc   C                     eth0
10.0.2.4                 ether   12:34:56:78:9a:bc   C                     eth1
```

2.3	From resolv.conf(5), find the default name servers and the internet domain of your machine. How is this file generated?

```bash
azureuser@lab1:~$ cat /etc/resolv.conf 
# This file is managed by man:systemd-resolved(8). Do not edit.
#
# This is a dynamic resolv.conf file for connecting local clients to the
# internal DNS stub resolver of systemd-resolved. This file lists all
# configured search domains.
#
# Run "resolvectl status" to see details about the uplink DNS servers
# currently in use.
#
# Third party programs must not access this file directly, but only through the
# symlink at /etc/resolv.conf. To manage man:resolv.conf(5) in a different way,
# replace this symlink by a static file or a different symlink.
#
# See man:systemd-resolved.service(8) for details about the supported modes of
# operation for /etc/resolv.conf.

nameserver 127.0.0.53
options edns0 trust-ad
search xfjdr3y3vjyevevb1di4udcxse.fx.internal.cloudapp.net



systemd-resolve --status
netstat -ltun | grep 53
```

2.4 Using dig(1), find the responsible name servers for the cs.hut.fi domain.
```bash
azureuser@lab1:~$ dig cs.hut.fi +short ns
sauna.cs.hut.fi.
ns.niksula.hut.fi.
```

2.5 Using dig(1), find the responsible mail exchange servers for cs.hut.fi domain.
```bash
azureuser@lab1:~$ dig cs.hut.fi +short mx
1 mail.cs.hut.fi.
```


2.6 Using ping(8), send 5 packets to aalto.fi and find out the average latency. Try then pinging Auckland University of Technology, aut.ac.nz, and see if the latency is different. 
```bash
azureuser@lab1:~$ ping -c 5 aalto.fi
PING aalto.fi (104.17.221.22) 56(84) bytes of data.
64 bytes from 104.17.221.22 (104.17.221.22): icmp_seq=1 ttl=56 time=1.99 ms
64 bytes from 104.17.221.22 (104.17.221.22): icmp_seq=2 ttl=56 time=2.00 ms
64 bytes from 104.17.221.22 (104.17.221.22): icmp_seq=3 ttl=56 time=1.93 ms
64 bytes from 104.17.221.22 (104.17.221.22): icmp_seq=4 ttl=56 time=1.99 ms
64 bytes from 104.17.221.22 (104.17.221.22): icmp_seq=5 ttl=56 time=1.93 ms

--- aalto.fi ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4004ms
rtt min/avg/max/mdev = 1.930/1.969/2.001/0.032 ms

azureuser@lab1:~$ ping -c 5 aut.ac.nz
PING aut.ac.nz (156.62.238.90) 56(84) bytes of data.
64 bytes from bax.aut.ac.nz (156.62.238.90): icmp_seq=1 ttl=42 time=276 ms
64 bytes from bax.aut.ac.nz (156.62.238.90): icmp_seq=2 ttl=42 time=276 ms
64 bytes from bax.aut.ac.nz (156.62.238.90): icmp_seq=3 ttl=42 time=276 ms
64 bytes from bax.aut.ac.nz (156.62.238.90): icmp_seq=4 ttl=42 time=276 ms
64 bytes from bax.aut.ac.nz (156.62.238.90): icmp_seq=5 ttl=42 time=276 ms

--- aut.ac.nz ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4000ms
rtt min/avg/max/mdev = 275.754/275.891/276.024/0.091 ms
```

2.7 Using traceroute(1), find out how many hops away is amazon.com. 

Why does this address sometimes produce different results on different traceroute runs? 

```bash
# -I icmp; -m maxhop; -n no-reverse-dns
traceroute -I -n -m 60 amazon.com
# Because amazon.com has a few ip addresses. You can use `dig amazon.com`
```

2.8 Using mtr(8) find out the minimum, maximum and average network latency between your machine and google.com

Can the packet loss %age > 0 even if there is no loss in transport layer traffic? Why?

```bash
# -r report; -c number of packtes
mtr -rn -c 20 google.com
# Maybe firewalls, limit the icmp speed; security consideration, do not respond ICMP
```

3.1 Using nmap(1) to scan your  local network, and show  the list of all live and up hosts and open ports on VMs.

```bash
# -sV version; -sT tcp scan; -sU udp scan; -p- all ports; -T5 timing template
nmap -sV -sU -sS -p- -T5 10.0.2.0/24 
```


4.1 Using netcat, nc(1), capture the version number of the ssh daemon running on your machine.
```bash
azureuser@lab1:~$ nc localhost 22
SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5
```

4.2 Using netcat, nc(1), craft a valid HTTP/1.1 request for getting HTTP headers (not the html file itself) from the front page of www.aalto.fi. What request method did you use? Which headers did you need to send to the server? What was the status code for the request? Which headers did the server return? Explain the purpose of each header.

```bash
azureuser@lab1:~$ echo -e 'HEAD http://www.aalto.fi HTTP/1.1\nHost: www.aalto.fi\n\n' | nc www.aalto.fi 80
HTTP/1.1 301 Moved Permanently
Date: Thu, 12 Jan 2023 20:02:48 GMT
Connection: keep-alive
Cache-Control: max-age=3600
Expires: Thu, 12 Jan 2023 21:02:48 GMT
Location: https://www.aalto.fi/fi
Server: cloudflare
CF-RAY: 78887deb1cae9588-DUB

# HEAD: only get the header
# Host: the host name
# 301: Moved Permanently
# Location: real website address
# max-age: the max age of the cache
# Expires: the expire time of the cache; But it does not work if max-age is set
# CF-RAY: the cloudflare ray id
```
4.3 Using netcat, nc(1), start a bogus web server listening on the loopback interface port 8080. Verify with netstat(8), that the server really is listening where it should be. Direct your browser lynx(1) to the bogus server and capture the User-Agent: header. 
```bash
azureuser@lab1:~$ while true; do echo -e "HTTP/1.1 200 OK\n\n $(date)" | nc -l localhost 8080; done
GET / HTTP/1.0
Host: localhost:8080
Accept: text/html, text/plain, text/sgml, text/css, */*;q=0.01
Accept-Encoding: gzip, compress, bzip2
Accept-Language: en
User-Agent: Lynx/2.9.0dev.5 libwww-FM/2.14 SSL-MM/1.4.1 GNUTLS/3.6.13


azureuser@lab1:~$ netstat -ltun  | grep 8080
tcp        0      0 127.0.0.1:8080          0.0.0.0:*               LISTEN  

azureuser@lab1:~$ lynx localhost:8080
```


4.4 With similar setup to 4.3, start up a bogus ssh server with nc and try to connect to it with ssh(1). Copy-paste the server version string you captured in 3.1 and see if you get a response from the client. What is the client trying to negotiate?

```bash
azureuser@lab1:~$ while true; do echo -e "HTTP/1.1 200 OK\n\n $(date)" | nc -l localhost 8080; done
SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5


azureuser@lab1:~$ ssh azureuser@127.0.0.1 -p 8080

# ssh-client and server are processing Protocol Version Exchange.
```

5.1 Which providers does vagrant support?
`docker, virtualbox, vmware, azure, libvirt, and more`

What does command: `vagrant init` do?
`This initializes the current directory to be a Vagrant environment by creating an initial Vagrantfile if one does not already exist.
`
5.2 What is box in Vagrant? 
`Boxes are the package format for Vagrant environments. It is similar to images for containers.`
How to add a box to the vagrant environment?
```
Command: vagrant box add ADDRESS

This adds a box with the given address to Vagrant. The address can be one of three things:

1.A shorthand name from the public catalog of available Vagrant images, such as "hashicorp/bionic64".

2.File path or HTTP URL to a box in a catalog. For HTTP, basic authentication is supported and http_proxy environmental variables are respected. HTTPS is also supported.

3.URL directly a box file. In this case, you must specify a --name flag (see below) and versioning/updates will not work.
```

5.3 Show the provisioning part of your sample code and explain it?

5.4 Upload a file from your host to a vm? Share a folder on your host to a vm.
```bash
vagrant scp <some_local_file_or_dir> [vm_name]:<somewhere_on_the_vm>

# Vagrant support Synced Folders and File provisioning
```
5.5 Show the running boxes in your provider via ssh ?

```bash
vagrant status
VBoxManage list runningvms
```
