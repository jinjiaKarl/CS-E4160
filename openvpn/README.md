
## 1. Initial Setup

Install openvpn package for GW and RW if it has not been preinstalled. Install also bridge-utils for GW.

On lab1 (GW):

Assign a static IP from the subnet 192.168.0.0/24 to the interface enp0s8
Assign a static IP from the subnet 192.168.2.0/24 to the interface enp0s9
On lab2 (SS):

Assign a static IP from the subnet 192.168.0.0/24 to the interface enp0s8
On lab3 (RW):

Assign a static IP from the subnet 192.168.2.0/24 to the interface enp0s8
In this exercise, the enp0s3 interfaces are only used for SSH remote access. Do not use them for any other traffic. Verify that you can ping the gateway from the other hosts, and that you can not ping the RW from the SSor vice versa. Write down the network configuration.

1.1 Present your network configuration. What IPs did you assign to the interfaces (4 interfaces in all) of each of the three hosts?

```
# lab1 (GW)
vagrant@lab1:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 02:cd:6a:13:84:49 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 86192sec preferred_lft 86192sec
    inet6 fe80::cd:6aff:fe13:8449/64 scope link
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:9e:f6:c4 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.2/24 brd 192.168.0.255 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe9e:f6c4/64 scope link
       valid_lft forever preferred_lft forever
4: enp0s9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:91:d8:67 brd ff:ff:ff:ff:ff:ff
    inet 192.168.2.2/24 brd 192.168.2.255 scope global enp0s9
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe91:d867/64 scope link
       valid_lft forever preferred_lft forever

# lab2 (SS)

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 02:cd:6a:13:84:49 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 86248sec preferred_lft 86248sec
    inet6 fe80::cd:6aff:fe13:8449/64 scope link
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:69:96:9e brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.3/24 brd 192.168.0.255 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe69:969e/64 scope link
       valid_lft forever preferred_lft forever

# lab3 (RW)

vagrant@lab3:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 02:cd:6a:13:84:49 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 86302sec preferred_lft 86302sec
    inet6 fe80::cd:6aff:fe13:8449/64 scope link
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:15:9b:f0 brd ff:ff:ff:ff:ff:ff
    inet 192.168.2.3/24 brd 192.168.2.255 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe15:9bf0/64 scope link
       valid_lft forever preferred_lft forever



```


## 2. Setting up a PKI (Public Key Infrastructure)
The first step in establishing an OpenVPN connection is to build the public key infrastructure (PKI).

You'll need to generate the master Certificate Authority (CA) certificate/key, the server certificate/key and a key for at least one client. In addition you also have to generate the Diffie-Hellman parameters for the server. Note: the Ubuntu openvpn package no longer ships with easy-rsa.

After you have generated all the necessary certificates and keys, copy the necessary files (securely) to the road warrior (RW) host.

2.1 What is the purpose of each of the generated files? Which ones are needed by the client?
* CA certificate `./easyrsa build-ca`
    * `ca.crt` is the CA’s public certificate file which, in the context of OpenVPN, the server and the client use to inform one another that they are part of the same web of trust and not someone performing a man-in-the-middle attack. For this reason, your server and all of your clients will need a copy of the ca.crt file.
    * `ca.key` is the private key which the CA machine uses to sign keys and certificates for servers and clients. If an attacker gains access to your CA and, in turn, your ca.key file, they will be able to sign certificate requests and gain access to your VPN, impeding its security. This is why your ca.key file should only be on your CA machine and that, ideally, your CA machine should be kept offline when not signing certificate requests as an extra security measure.
* Server certificate `./easyrsa build-server-full vpnserver nopass`
    * `vpnserver.crt`
    * `vpnserver.key`
* Client certificate
    * `vpnclient.crt`
    * `vpnclient.key`
* create a strong Diffie-Hellman key to use during key exchange `./easyrsa gen-dh`
* generate an HMAC signature key to strengthen the server’s TLS integrity verification capabilities `openvpn --genkey --secret ta.key`

Client 
* `ca.key`
* `vpnclient.crt`
* `vpnclient.key`
* `dh.pem`
  

2.2 Is there a simpler way of authentication available in OpenVPN? What are its benefits/drawbacks?

Yes, OpenVPN supports a simpler authentication method called "Static Key Authentication."

In Static Key Authentication, both the client and the server share a pre-shared key (PSK) that is used to authenticate the connection. This method does not require a certificate infrastructure or a Public Key Infrastructure (PKI), making it simpler to set up and configure.

Benefits:

* Simple to configure and set up
* Does not require a PKI or certificate infrastructure
* Fast and efficient because it does not need to perform complex cryptographic operations

Drawbacks:

* Less secure than certificate-based authentication methods since the same pre-shared key is used for all connections, making it easier for an attacker to intercept and potentially compromise the key.
* Difficult to revoke a key if it gets compromised, as the same key is used for all connections.
Cannot provide user-level authentication, meaning all clients with the same key have the same level of access.

In summary, while Static Key Authentication is simpler to set up and configure, it may not be suitable for environments that require a higher level of security and user-level authentication.



## 3. Configuring the VPN server
On GW copy /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz to for example /etc/openvpn and extract it. You have to edit the server.conf to use bridged mode with the correct virtual interface. You also have to check that the keys and certificates point to the correct files. Set the server to listen for connection in GW's enp0s9 IP address.

Start the server on GW with openvpn server.conf .

3.1 List and give a short explanation of the commands you used in your server configuration.
https://abcdxyzk.github.io/blog/2021/05/31/base-openvpn/
https://blog.mycroft.wang/2021/09/16/ubuntu-an-zhuang-openvpn-fu-wu-qi/


```


# server.conf
dev tap0
server-bridge 192.168.0.2 255.255.255.0 192.168.0.50 192.168.0.100

```


3.2 What IP address space did you allocate to the OpenVPN clients?
```
# server.conf
server-bridge 192.168.0.2 255.255.255.0 192.168.0.50 192.168.0.100


192.168.0.50
```

3.3 Where can you find the log messages of the server by default? How can you change this?
```
# By default, log messages will go to the syslog (or
# on Windows, if running as a service, they will go to
# the "\Program Files\OpenVPN\log" directory).
# Use log or log-append to override this default.
# "log" will truncate the log file on OpenVPN startup,
# while "log-append" will append to it.  Use one
# or the other (but not both).
log         /var/log/openvpn/openvpn.log
```


## 4. Bridging setup
Next you have to setup network bridging on the GW. We'll combine the enp0s8 interface of the gateway with a virtual TAP interface and bridge them together under an umbrella bridge interface.

OpenVPN provides a script for this in /usr/share/doc/openvpn/examples/sample-scripts . Copy the bridge-start and the bridge-stop scripts to a different folder for editing. Edit the parameters of the script files to match with GW's enp0s8. Start the bridge and check with ifconfig that the bridging was successful.

4.1 Show with ifconfig that you have created the new interfaces (virtual and bridge). What's the IP of the bridge interface?

```
3: enp0s8: <BROADCAST,MULTICAST,PROMISC,UP,LOWER_UP> mtu 1500 qdisc fq_codel master br0 state UP group default qlen 1000
    link/ether 08:00:27:9e:f6:c4 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::a00:27ff:fe9e:f6c4/64 scope link
       valid_lft forever preferred_lft forever
4: enp0s9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:91:d8:67 brd ff:ff:ff:ff:ff:ff
    inet 192.168.2.2/24 brd 192.168.2.255 scope global enp0s9
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe91:d867/64 scope link
       valid_lft forever preferred_lft forever
5: tap0: <NO-CARRIER,BROADCAST,MULTICAST,PROMISC,UP> mtu 1500 qdisc fq_codel master br0 state DOWN group default qlen 100
    link/ether 3a:e0:c8:36:47:82 brd ff:ff:ff:ff:ff:ff
6: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:9e:f6:c4 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.2/24 brd 192.168.0.255 scope global br0
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe9e:f6c4/64 scope link
       valid_lft forever preferred_lft forever
```

IP of the bridge is same as enp0s8 before. It is 192.168.0.2.


4.2 What is the difference between routing and bridging in VPN? What are the benefits/disadvantages of the two? When would you use routing and when bridging?

https://openvpn.net/community-resources/how-to/#determining-whether-to-use-a-routed-or-bridged-vpn

Routing:
Routing is the process of forwarding packets between different subnets or networks. In OpenVPN, a routed VPN works at the IP layer (Layer 3) of the OSI model. It uses the tun (tunnel) device, which operates at the IP level, and can support various IP protocols like TCP, UDP, ICMP, etc.

Benefits of Routing:

* Easier to set up and manage.
* Lower overhead due to reduced broadcast traffic.
* Better security since you can apply firewall rules on the VPN subnet.
* Typically more scalable, as it works well with large networks.

Disadvantages of Routing:

* Not suitable for non-IP protocols.
* Inability to handle certain network configurations like when devices require Layer 2 (Ethernet) visibility.


When to use Routing:
You would use routing in most scenarios when connecting different networks or subnets. It's particularly useful when connecting remote sites, mobile clients, or when you need to apply specific firewall rules for the VPN traffic.

Bridging:
Bridging works at the Ethernet (Layer 2) level of the OSI model. In OpenVPN, a bridged VPN uses the tap (network tap) device, which simulates a virtual Ethernet network interface. It can carry any Ethernet traffic, including non-IP protocols such as NetBIOS or IPX.

Benefits of Bridging:
* Transparent to all network protocols, including non-IP traffic.
* Devices connected to the VPN appear as if they are on the same local network, making it suitable for certain applications that require Layer 2 visibility.
* Supports network configurations that rely on Ethernet broadcasts or multicast traffic.

Disadvantages of Bridging:
* Higher overhead due to increased broadcast traffic.
* More complex setup and configuration.
* Less scalable compared to routing, as it may lead to performance issues in large networks.
* Security is less granular, as firewall rules cannot be applied at the VPN subnet level.


When to use Bridging:
You would use bridging when your network scenario requires Layer 2 connectivity between remote sites or devices, or when dealing with non-IP protocols. Bridging is also suitable for applications that rely on Ethernet broadcasts or multicast traffic.

In summary, routing is generally preferred due to its simplicity, better scalability, and security advantages. However, bridging may be necessary for specific scenarios that require Layer 2 connectivity or compatibility with non-IP protocols.


5. Configuring the VPN client and testing connection
On RW copy /usr/share/doc/openvpn/examples/sample-config-files/client.conf to for example /etc/openvpn. Edit the client.conf to match with the settings of the server. Remember to check that the certificates and keys point to the right folders.

Connect RW to the server on GW with openvpn client.conf. Pinging the SSfrom RW should now work.

If you have problems with the ping not going through, go to VirtualBox network adapter settings and allow promiscuous mode for internal networks that need it.

5.1 List and give a short explanation of the commands you used in your VPN client configuration.
```
# client.conf
dev tap
remote lab1 1194 udp
ca ca.crt
cert vpnclient.crt
key vpnclient.key
tls-auth /etc/openvpn/ta.key 1

```

5.2 Demonstrate that you can reach the SS from the RW. Setup a server on the client with netcat and connect to this with telnet/nc. Send messages to both directions.
```
# set up a server on the client with netcat
vagrant@lab2:~$  nc -l 8080

# connect to this with telnet/nc on the server
vagrant@lab3:~$ nc lab2 8080


```

5.3 Capture incoming/outgoing traffic on GW's enp0s9 or RW's enp0s8. Why can't you read the messages sent in 5.2 (in plain text) even if you comment out the cipher command in the config-files?
```
# GW
root@lab1:/etc/openvpn# tcpdump -i enp0s9 -s 0 -w - port 1194

# RW
tcpdump -i enp0s8
```

If you comment out the cipher command in the OpenVPN server or client configuration file, the VPN traffic will be encrypted using the default cipher specified by OpenVPN (which is AES-256-GCM as of version 2.4). However, even if you use a cipher that does not provide encryption, such as "none", you still won't be able to read the messages sent in plain text. It will still negotiate AES-256-GCM. If we disable negotiate `ncp-disable`, using `tcpdump -i enp0s9 -s 0 -w - ` can see the content.




5.4 Enable ciphering. Is there a way to capture and read the messages sent in 5.2 on GW despite the encryption? Where is the message encrypted and where is it not?

Enabling ciphering in OpenVPN will encrypt the traffic between the client and the server, making it much harder to intercept and read the messages being sent. If you capture the encrypted traffic using a packet capture tool like tcpdump or Wireshark, you will not be able to read the messages sent in plain text without the encryption key. 

But, only in `br0` and `enp0s8`, we can see the decrypted message. `tcpdump -i br0 -s 0 -w -` and `tcpdump -i enp0s8 -s 0 -w -`. Or you have the encryption key, the messages can be decrypted and read between the client and openserver.

The message is encrypted in the OpenVPN tunnel between the client and the server. The message is not encrypted on the client or server itself before it enters the tunnel, nor is it encrypted on the server after it leaves the tunnel. 


5.5 Traceroute RW from SS and vice versa. Explain the result.
```
# RW to SS
vagrant@lab3:~$  traceroute lab2
traceroute to lab2 (192.168.0.3), 64 hops max
  1   192.168.0.3  2.574ms  2.291ms  2.435ms



# SS to RW
vagrant@lab2:~$ traceroute lab3
traceroute to lab3 (192.168.2.3), 64 hops max
  1   10.0.2.2  0.323ms  0.294ms  0.285ms
  2   *  *  *

vagrant@lab2:~$ ip route
default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15
10.0.2.2 dev enp0s3 proto dhcp scope link src 10.0.2.15 metric 100
192.168.0.0/24 dev enp0s8 proto kernel scope link src 192.168.0.3

# 192.168.0.50 is the virtual ip address of lab3
root@lab2:~# traceroute 192.168.0.50
traceroute to 192.168.0.50 (192.168.0.50), 64 hops max
  1   192.168.0.50  2.947ms  1.354ms  2.447ms




# 在routed情况下，为什么arp在lab1回不去了？
# ip route add 192.168.2.0/24 via 192.168.0.3 dev enp0s8
# ip route del 192.168.2.0/24 via 192.168.0.3 dev ~~enp0s8~~
```



## 6. Setting up routed VPN
In this task, you have to set up routed VPN as opposed to the bridged VPN above.  Stop openvpn service on both server and client.

1. Reconfigure the server.conf and the client.conf to have routed vpn.
https://linuxops.org/blog/linux/openvpn.html
https://github.com/icyb3r-code/SysAdmin/tree/master/Linux/Contents/OpenVpn


1. Restart openvpn service on both server and client.
`tail -f /var/log/syslog | grep "Initialization Sequence Completed"`
```
Mar 16 15:12:22 lab3 ovpn-client[3768]: TUN/TAP device tun0 opened
Mar 16 15:12:22 lab3 systemd-udevd[3774]: ethtool: autonegotiation is unset or enabled, the speed and duplex are not writable.
Mar 16 15:12:22 lab3 ovpn-client[3768]: TUN/TAP TX queue length set to 100
Mar 16 15:12:22 lab3 systemd-networkd[766]: tun0: Link UP
Mar 16 15:12:22 lab3 ovpn-client[3768]: /sbin/ip link set dev tun0 up mtu 1500
Mar 16 15:12:22 lab3 systemd-networkd[766]: tun0: Gained carrier
Mar 16 15:12:22 lab3 systemd-networkd[766]: tun0: Gained IPv6LL
Mar 16 15:12:22 lab3 ovpn-client[3768]: /sbin/ip addr add dev tun0 local 10.8.0.6 peer 10.8.0.5
Mar 16 15:12:22 lab3 ovpn-client[3768]: /sbin/ip route add 10.8.0.1/32 via 10.8.0.5
Mar 16 15:12:22 lab3 ovpn-client[3768]: WARNING: this configuration may cache passwords in memory -- use the auth-nocache option to prevent this
Mar 16 15:12:22 lab3 ovpn-client[3768]: Initialization Sequence Completed
```
1. Now you should be able to ping virtual IP address of vpn server from client.
 
6.1 List and give a short explanation of the commands you used in your server configuration

```
# server.conf
# # Configure server mode and supply a VPN subnet
# for OpenVPN to draw client addresses from.
# The server will take 10.8.0.1 for itself,
# the rest will be made available to clients.
# Each client will be able to reach the server
# on 10.8.0.1. Comment this line out if you are
# ethernet bridging. See the man page for more info.
server 10.8.0.0 255.255.255.0 
push "route 192.168.0.0 255.255.255.0" # subnet address space behind the openvpn server

```

6.2 Show with ifconfig that you have created the new virtual IP interfaces. What's the IP  address?


```
root@lab1:/etc/openvpn# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 02:cd:6a:13:84:49 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 85000sec preferred_lft 85000sec
    inet6 fe80::cd:6aff:fe13:8449/64 scope link
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,PROMISC,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:9e:f6:c4 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.2/24 brd 192.168.0.255 scope global enp0s8
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe9e:f6c4/64 scope link
       valid_lft forever preferred_lft forever
4: enp0s9: <BROADCAST,MULTICAST,PROMISC,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:91:d8:67 brd ff:ff:ff:ff:ff:ff
    inet 192.168.2.2/24 brd 192.168.2.255 scope global enp0s9
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe91:d867/64 scope link
       valid_lft forever preferred_lft forever
8: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 100
    link/none
    inet 10.8.0.1 peer 10.8.0.2/32 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::4132:5ccb:6f3c:18f2/64 scope link stable-privacy
       valid_lft forever preferred_lft forever
```