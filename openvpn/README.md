
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
* generate an HMAC signature to strengthen the server’s TLS integrity verification capabilities `openvpn --genkey --secret ta.key`

2.2 Is there a simpler way of authentication available in OpenVPN? What are its benefits/drawbacks?

Yes, OpenVPN supports a simpler authentication method called "Static Key Authentication."

In Static Key Authentication, both the client and the server share a pre-shared key (PSK) that is used to authenticate the connection. This method does not require a certificate infrastructure or a Public Key Infrastructure (PKI), making it simpler to set up and configure.

Benefits:

Simple to configure and set up
Does not require a PKI or certificate infrastructure
Fast and efficient because it does not need to perform complex cryptographic operations
Drawbacks:

Less secure than certificate-based authentication methods since the same pre-shared key is used for all connections, making it easier for an attacker to intercept and potentially compromise the key.
Difficult to revoke a key if it gets compromised, as the same key is used for all connections.
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
server-bridge 192.168.64.20 255.255.255.0 192.168.64.30 192.168.8.40
#server-bridge 192.168.2.10 255.255.255.0 192.168.0.30 192.168.0.40
duplicate-cn
# OpenVPN的状态日志，默认为/var/log/openvpn/openvpn-status.log
status openvpn-status.log 
# OpenVPN的运行日志，默认为/var/log/openvpn/openvpn.log
log-append openvpn.log
# 改成verb 5可以多查看一些调试信息
verb 5
```


3.2 What IP address space did you allocate to the OpenVPN clients?
```
# server.conf
server-bridge 192.168.2.10 255.255.255.0 192.168.0.30 192.168.0.40
```

3.3 Where can you find the log messages of the server by default? How can you change this?
```
# server.conf
# OpenVPN的状态日志，默认为/var/log/openvpn/openvpn-status.log
status openvpn-status.log 
# OpenVPN的运行日志，默认为/var/log/openvpn/openvpn.log
log-append openvpn.log
```


## 4. Bridging setup
Next you have to setup network bridging on the GW. We'll combine the enp0s8 interface of the gateway with a virtual TAP interface and bridge them together under an umbrella bridge interface.

OpenVPN provides a script for this in /usr/share/doc/openvpn/examples/sample-scripts . Copy the bridge-start and the bridge-stop scripts to a different folder for editing. Edit the parameters of the script files to match with GW's enp0s8. Start the bridge and check with ifconfig that the bridging was successful.

4.1 Show with ifconfig that you have created the new interfaces (virtual and bridge). What's the IP of the bridge interface?


4.2 What is the difference between routing and bridging in VPN? What are the benefits/disadvantages of the two? When would you use routing and when bridging?
https://openvpn.net/community-resources/how-to/#determining-whether-to-use-a-routed-or-bridged-vpn
Routing and bridging are two different methods for forwarding network traffic in a VPN.

Routing is a process of forwarding packets from one network to another based on their destination IP addresses. In a VPN, routing involves creating a tunnel between two networks and forwarding packets between them using the tunnel. The VPN gateway device performs the routing function by examining the packet headers and forwarding them to the appropriate destination based on the routing table.

Bridging, on the other hand, is a process of forwarding packets between two networks at the data link layer (layer 2) of the OSI model. In a VPN, bridging involves connecting two or more network segments together to form a single logical network. This can be achieved using a Layer 2 VPN technology, such as Ethernet bridging, which allows multiple networks to appear as a single network.

The benefits and disadvantages of routing vs. bridging in a VPN depend on the specific use case and network requirements.

Benefits of Routing:

More secure: Routing isolates traffic between different networks and provides greater control over traffic flow and access control policies.
More scalable: Routing allows for more complex network topologies and larger networks than bridging.
More flexible: Routing enables different IP address spaces to be used on each network segment.
Disadvantages of Routing:

More complex: Routing requires more configuration and management than bridging.
Slower performance: Routing can introduce more overhead and latency than bridging.
Benefits of Bridging:

Simpler configuration: Bridging requires less configuration and management than routing.
Faster performance: Bridging can provide faster throughput and lower latency than routing.
Seamless network integration: Bridging allows multiple networks to appear as a single network, simplifying network integration.
Disadvantages of Bridging:

Less secure: Bridging can increase the risk of unauthorized access to the network due to the flat network topology.
Less scalable: Bridging is not as scalable as routing and can be limited by the number of devices that can be connected to a single network segment.
In general, routing is preferred for larger and more complex networks where security and scalability are important, while bridging is preferred for simpler networks that require seamless integration and high performance.



5. Configuring the VPN client and testing connection
On RW copy /usr/share/doc/openvpn/examples/sample-config-files/client.conf to for example /etc/openvpn. Edit the client.conf to match with the settings of the server. Remember to check that the certificates and keys point to the right folders.

Connect RW to the server on GW with openvpn client.conf. Pinging the SSfrom RW should now work.

If you have problems with the ping not going through, go to VirtualBox network adapter settings and allow promiscuous mode for internal networks that need it.

5.1 List and give a short explanation of the commands you used in your VPN client configuration.
```
# client.conf
dev tap
remote 192.168.64.20 1194 udp
#remote 192.168.2.10 1194 udp
ca ca.crt
cert vpnclient.crt
key vpnclient.key
cipher AES-256-CBC
auth SHA25
key-direction 1

```

5.2 Demonstrate that you can reach the SS from the RW. Setup a server on the client with netcat and connect to this with telnet/nc. Send messages to both directions.
```
# set up a server on the client with netcat
netcat -l 8080

# connect to this with telnet/nc on the server
nc 192.168.64.20 8080
nc 192.168.2.11 8080


```

5.3 Capture incoming/outgoing traffic on GW's enp0s9 or RW's enp0s8. Why can't you read the messages sent in 5.2 (in plain text) even if you comment out the cipher command in the config-files?
```
# GW
tcpdump -i enp0s9 -w /tmp/gw.pcap

# RW
tcpdump -i enp0s8 -w /tmp/rw.pcap
```

If you comment out the cipher command in the OpenVPN server or client configuration file, the VPN traffic will be encrypted using the default cipher specified by OpenVPN (which is AES-256-CBC as of version 2.5). However, even if you use a cipher that does not provide encryption, such as "none", you still won't be able to read the messages sent in plain text.

This is because OpenVPN uses a tunneling protocol to encapsulate the VPN traffic and send it over the internet. The traffic is not sent in plain text, but is encrypted and encapsulated within the tunnel. The tunneling protocol itself provides some level of security, even if the traffic within the tunnel is not encrypted. Therefore, even if you use a cipher that does not provide encryption, you still won't be able to read the messages sent in plain text because they are encapsulated within the tunnel and not accessible to you without the encryption key.


5.4 Enable ciphering. Is there a way to capture and read the messages sent in 5.2 on GW despite the encryption? Where is the message encrypted and where is it not?

Enabling ciphering in OpenVPN will encrypt the traffic between the client and the server, making it much harder to intercept and read the messages being sent. If you capture the encrypted traffic using a packet capture tool like tcpdump or Wireshark, you will not be able to read the messages sent in plain text without the encryption key.

The message is encrypted in the OpenVPN tunnel between the client and the server. The message is not encrypted on the client or server itself before it enters the tunnel, nor is it encrypted on the client or server after it leaves the tunnel. However, the OpenVPN tunnel provides end-to-end encryption between the client and server, which means that the message cannot be intercepted and read by anyone who does not have the encryption key.

To read the messages sent in 5.2 on the GW despite the encryption, you would need to have the encryption key that was used to encrypt the traffic. Without the encryption key, the messages cannot be decrypted and read.

It's important to note that OpenVPN uses a strong encryption algorithm to protect the traffic, so it is generally considered to be secure. However, there are some weaknesses that could potentially be exploited by a skilled attacker, so it's important to use strong encryption keys and follow best practices for securing your OpenVPN deployment.


5.5 Traceroute RW from SS and vice versa. Explain the result.
```
# RW to SS
traceroute 192.168.0.11

# SS to RW
traceroute 192.168.2.11
```



## 6. Setting up routed VPN
In this task, you have to set up routed VPN as opposed to the bridged VPN above.  Stop openvpn service on both server and client.

1. Reconfigure the server.conf and the client.conf to have routed vpn.
https://linuxops.org/blog/linux/openvpn.html
https://github.com/icyb3r-code/SysAdmin/tree/master/Linux/Contents/OpenVpn


```
# server.conf
local 192.168.2.10
port 1194
proto udp
dev tun
ca ca.crt
cert vpnserver.crt
key vpnserver.key
dh dh.pem
cipher AES-256-CBC
auth SHA256
push "route 192.168.0.0 255.255.255.0"
status /var/log/openvpn/openvpn-status.log
log-append /var/log/openvpn/openvpn.log

# client.conf
dev tap
remote 192.168.2.10 1194 udp
ca ca.crt
cert vpnclient.crt
key vpnclient.key
cipher AES-256-CBC
auth SHA256
key-direction 1
tls-auth ta.key 1

```

2. Restart openvpn service on both server and client.
如果建立成功在客户端：`tail -f /var/log/syslog | grep "Initialization Sequence Completed"`

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
3. Now you should be able to ping virtual IP address of vpn server from client.

```

```
 
6.1 List and give a short explanation of the commands you used in your server configuration


6.2 Show with ifconfig that you have created the new virtual IP interfaces . What's the IP  address?