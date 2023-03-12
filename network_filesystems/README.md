## questions

1. Preparation

You'll need two virtual machines for this exercise. Add aliases (lab1 and lab2) for the addresses to /etc/hosts.

Create two new users (e.g. "testuser1" and "testuser2") with adduser to both the computers. Ensure that users have the same UID on both computers (eg. testuser1 UIDis 1001 on lab1 and lab2, testuser2 is 1002). The easiest way is to create both users in the same order onboth computers. Make sure you have a home directory for testuser1 on lab1.

```

useradd -m -u 2001 testuser1
useradd -m -u 2002 testuser2

# Get the Current User in Linux
id

# change user
su testuser1

$env:VAGRANT_EXPERIMENTAL="disks"
VAGRANT_EXPERIMENTAL="disks" vagrant up
```


2. Configuring and testing NFS
NFS is an acronym for "network filesystem". NFS is implemented for nearly all unix variations and even for windows.

Make sure you have nfs-kernel-server installed on lab1. Export /home directory via /etc/exports. Restart the NFS server daemon. Mount lab1:/home to lab2:/mnt. You can change user with su, e.g. "su testuser1". Test that NFS works by writing a file in lab1:/home/testuser1/test.txt and open the same file at lab2:/mnt/testuser1/test.txt.

2.1 Demonstrate a working configuration.

refer to https://www.cnblogs.com/mchina/archive/2013/01/03/2840040.html


```
// 查看自己共享的服务，前提是要DNS能解析自己，不然容易报错
root@lab1:/home# showmount -e
Export list for lab1:
/home *

// 查询NFS的共享状态
root@lab2:/mnt/testuser1# showmount -e lab1
Export list for lab1:
/home *


root@lab2:/mnt/testuser1#  mount | grep nfs
lab1:/home on /mnt type nfs4 (rw,relatime,vers=4.2,rsize=524288,wsize=524288,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=192.168.64.21,local_lock=none,addr=192.168.64.20)
```
2.2 Is it possible to encrypt all NFS traffic? How?

Yes, it is possible to encrypt all NFS (Network File System) traffic using different encryption methods.

One way to encrypt NFS traffic is to use the Transport Layer Security (TLS) protocol. This protocol provides secure communication between network applications by encrypting data transmitted over the network. In the case of NFS, TLS can be used to encrypt data as it moves between the NFS server and the client.

To use TLS with NFS, you will need to perform the following steps:

Generate a TLS certificate and key for the NFS server.
Configure the NFS server to use the TLS certificate and key.
Configure the NFS client to use the same TLS certificate and key.
Ensure that the NFS client and server are using the same version of TLS and that they support the same set of encryption algorithms.
Enable TLS encryption for NFS traffic.
To enable TLS encryption for NFS traffic, you can use the "sec" mount option in the NFS client configuration. For example, if you want to use TLSv1.2 with AES-128 encryption, you can use the following mount command:

```
mount -o sec=krb5p,tls,vers=3,proto=tcp,nolock server:/export /mnt
```

In this example, "krb5p" specifies that the Kerberos protocol should be used for authentication, "tls" specifies that TLS should be used for encryption, "vers=3" specifies that TLSv1.2 should be used, and "proto=tcp" specifies that TCP should be used as the transport protocol. The "nolock" option is used to disable the use of file locking, which can cause problems when using NFS over a network.

It's important to note that configuring NFS to use TLS encryption can have performance implications, especially if the encryption is performed using software rather than hardware. You should test the performance of your NFS system with and without encryption to determine the impact on performance.


3. Configuring and testing samba


Samba is unix/linux implementation for normal Windows network shares(netbios and CIFS (common internet filesystem)). You can configure samba via /etc/samba/smb.conf. You can access files shared with samba with command smbclient or by mounting the filesystem via mount, like with NFS. Mounting will require cifs-utils to be installed on lab2.

Start by unmounting with umount(8) the NFS directory in lab2 from the previous assignment. If unmounting complains "resource busy", you have a shell with your current directory in the /mnt directory and you need to switch to another directory.

Make sure you have samba installed on lab1. Share /home with read and write permissions (/home shares are already at smb.conf but it needs a little bit of tweaking) and reload samba. Run smbpasswd on lab1 and add testuser1 as a user. Try to mount //lab1/home/testuser1 to lab2:/mnt with username testuser1 and testuser1's password. If it doesn’t work, check that necessary services and ports are open.


3.1 Demonstrate a working configuration.
refer to https://linuxconfig.org/how-to-configure-samba-server-share-on-ubuntu-20-04-focal-fossa-linux
https://www.myfreax.com/how-to-install-and-configure-samba-on-ubuntu-20-04how-to-install-and-configure-samba-on-ubuntu-20-04


3.2 Only root can use mount. What problem does this pose for users trying to access their remote home directories? Is there a workaround for the problem?

The problem with only root being able to use the mount command is that regular users are unable to mount remote file systems, including their own home directories. This means that they are unable to access their files and data stored on the remote file system.

One workaround for this problem is to use the "user" mount option when mounting the file system. This allows regular users to mount the file system and access their files. Here's an example of how to do this:

```
sudo mount -t nfs remote-host:/remote/directory /local/directory -o user=username
```
In this command, "username" should be replaced with the username of the user who wants to mount the file system. The "user" option allows that user to mount the file system.

Another option is to modify the /etc/fstab file to allow users to mount the file system. This involves adding the "user" option to the appropriate line in the file. Here's an example:

```
remote-host:/remote/directory /local/directory nfs user,auto 0 0
```

In this line, the "user" option is included to allow users to mount the file system. The "auto" option specifies that the file system should be mounted at boot time, and the "0 0" options specify that the file system should not be dumped or checked by the file system checker.

Use the mount command with the suid bit set, which allows users to mount network filesystems as themselves instead of root.

It's important to note that allowing users to mount file systems can have security implications, so it's important to carefully consider the risks before making this change.


4. Configuring and testing sshfs

sshfs is filesystem for FUSE (filesystem in userspace).

Start by unmounting the samba share on lab2.

Next mount lab1:/home/testuser1 to lab2:/home/testuser1/mnt using sshfs. Demonstrate this to the assistant.

4.1 Provide the commands that you used.

refer to https://www.myfreax.com/how-to-use-sshfs-to-mount-remote-directories-over-ssh/
```
sshfs [user@]host:[remote_directory] mountpoint [options]
```

4.2 When is sshfs a good solution?

sshfs can be a good solution in various scenarios where remote access to files is required securely over the SSH protocol. Some examples of when sshfs can be a good solution include:

* Accessing files on a remote server: If you need to access files on a remote server, sshfs can provide a secure way to do so over an SSH connection. This can be useful in situations where you need to transfer files back and forth between the local and remote machines.

* Sharing files between computers: If you have multiple computers that need to share files, sshfs can be a good solution for securely mounting remote directories on local machines.

* Remote development: If you are a developer working on a remote server, sshfs can be used to mount the remote project directory on your local machine, allowing you to work on the code locally while the files are stored remotely.

* Accessing cloud storage: If you are using cloud storage services like Amazon S3 or Google Cloud Storage, you can use sshfs to mount the remote storage on your local machine, making it easier to access and manage files.

Overall, sshfs can be a good solution when you need to access or share files securely over an SSH connection. It provides a convenient way to mount remote directories as if they were local directories, making it easy to work with files on remote machines.

Already has a SSH connection or you need to access to the filesystem as a normal user.

4.3 What are the advantages of FUSE?


FUSE (Filesystem in Userspace) has several advantages, including:

* Flexibility: FUSE allows developers to create filesystems in userspace without modifying the kernel. This makes it easier to develop and test new filesystems, and it provides greater flexibility for users to customize their filesystems as needed.

* Compatibility: FUSE is compatible with a wide range of operating systems, including Linux, macOS, and Windows. This makes it easy to create filesystems that can be used on multiple platforms.

* `User-level access`: FUSE allows users to access filesystems at the user level, which provides greater security and control. Users can mount and unmount filesystems without requiring root access, which reduces the risk of accidental damage or security breaches.

* Performance: While FUSE adds an extra layer of abstraction, it has been optimized to provide high performance. FUSE uses a kernel-level caching mechanism to reduce the overhead of accessing files in userspace, which helps to maintain good performance.

* Community support: FUSE has a large and active community of developers who are constantly working to improve the technology. This means that there is a wealth of resources available, including documentation, tutorials, and support forums, which makes it easier for developers to create and maintain FUSE filesystems.

Overall, FUSE provides a flexible and compatible way to create filesystems in userspace. It offers many benefits, including improved security, performance, and community support, which make it a popular choice for creating custom filesystems.

4.4 Why doesn't everyone use encrypted channels for all network filesystems?

While encrypted channels provide a higher level of security for network filesystems, there are some potential drawbacks that can limit their adoption:

* Performance overhead: Encryption and decryption can add significant overhead to network file access, especially for large files. This can result in slower access times and decreased performance, which may be unacceptable in some scenarios.

* Complexity: Implementing encryption in a network filesystem can be complex and may require additional software or hardware components. This can increase the cost and complexity of deploying and maintaining the system.

* Compatibility: Encrypted channels may not be compatible with all network filesystems, which can limit their adoption in certain environments. In some cases, older or less common filesystems may not support encryption, which can make it difficult to ensure the security of the network.

* Usability: Encrypted channels can add additional steps to the file access process, such as entering passwords or configuring encryption keys. This can make the system less user-friendly, which may be a concern in some environments.

* Trade-offs between security and convenience: While encrypted channels provide a higher level of security, they may also make it more difficult to share files between different systems or users. In some cases, users may choose to sacrifice security for the sake of convenience, which can undermine the effectiveness of the encryption.

Overall, while encrypted channels provide a higher level of security for network filesystems, there are several potential drawbacks that can limit their adoption. Organizations must carefully consider the trade-offs between security, performance, complexity, and usability when deciding whether to implement encrypted channels for their network filesystems.


5. Configuring and testing WebDAV

WebDAV (Web-based Distributed Authoring and Versioning) is a set of extensions to the HTTP protocol which allows users to collaboratively edit and manage files on remote web servers.

In this exercise we'll use the built-in WebDAV module of Apache2 server platform. Check that apache2 is installed and enable the dav_fs module. Restart apache2 every time after enabling a module.

Create a directory /var/www/WebDAV for storing WebDAV related files and add subdirectory files to be shared using WebDAV. Change the owner of the directories created to www-data (Apache's user ID) and the group to your user ID. Change the permissions if needed.

Create an alias to the virtual host file (/etc/apache2/sites-available/000-default.conf) so that /var/www/WebDAV/files can be reached through http://localhost/webdav. Enable the virtual host by creating a symbolic link between /etc/apache2/sites-available/000-default.conf and /etc/apache2/sites-enabled/.

Restart apache2 and check that you can reach the server with, for example, elinks(1).

Set up Authorization

Enable the auth_digest module for apache. Create a password file for a testuser with htdigest(1) to /var/www/WebDAV. Edit permissions of the file so that only www-data and root can access it. Use the following template to add the location to the virtual host file:
```
<Location /webdav>
  DAV On
  AuthType Digest
  AuthName "your_auth_name"
  AuthUserFile path_to_your_password_file
  Require valid-user
</Location>
```
Restart Apache2 and test the server from another machine using cadaver(1). You should reach the server http://lab1/webdav .


5.1 Demonstrate a working setup. (View for example a web page on one machine and edit it from another using cadaver).
refer to https://www.rman.top/2022/01/20/webdav/
https://www.digitalocean.com/community/tutorials/how-to-configure-webdav-access-with-apache-on-ubuntu-20-04
https://www.jianshu.com/p/1bac4f50acb9
https://pangruitao.com/post/2130


```
# why does it not work?
root@lab1:/etc/apache2# cadaver http://lab1/webdav
Authentication required for pp on server `lab1':
Username: pp
Password: 
Could not access /webdav/ (not WebDAV-enabled?):
405 Method Not Allowed
Connection to `lab1' closed.
dav:!> exit


# open locally
ssh -NL 8081:localhost:80 vagrant@127.0.0.1 -p 2222
```

5.2 Demonstrate mounting a WebDAV resource into the local filesystem.
1.Install davfs2 package:
```
sudo apt-get install davfs2 -y
```

2.Create a mount point directory:
```
sudo mkdir /mnt/webdav
```


3.Add your user to the davfs2 group to allow mounting:
```
sudo usermod -aG davfs2 <your_username>
```

4.Edit the davfs2 configuration file:

```
sudo nano /etc/davfs2/davfs2.conf
```
Uncomment the line # use_locks 0 by removing the # symbol.

5.Create a secrets file with the credentials for the WebDAV server:

```
sudo nano /etc/davfs2/secrets
```
Add the following line, replacing <username> and <password> with your credentials:

```
https://<server_address>/webdav <username> <password>
```

6.Set the correct permissions for the secrets file:

```
sudo chmod 600 /etc/davfs2/secrets
```

7.Mount the WebDAV resource to the mount point:
```
sudo mount -t davfs https://<server_address>/webdav /mnt/webdav
```

You will be prompted to enter your username and password. Once you've entered them, the WebDAV resource will be mounted to the specified directory.

Now you can access the WebDAV resource by navigating to /mnt/webdav on your local filesystem.


5.3 Does your implementation support versioning? If not, what should be added?

https://en.wikipedia.org/wiki/WebDAV
http://webdav.org/specs/rfc3253.html


The buit-in WebDAV module of Apache2 doesn't support versionging out of box.

To enable versioning, you can use a third-party WebDAV server software that supports versioning `Delta-V`. Or you can use file system like ZFS or Btrfs. Or you can configure a WebDAV server with a version control system like Git.


Another option is to use a WebDAV client with built-in versioningg support, such as WebDrive client.
1. Raid 5

In this task, you are going to establish a Network Attached Storage (NAS) system with lab1 as a server.   The server should use Raid for data integrity. Set up Raid 5 on the NAT server and create EXT4 filesystem on the array.

You need at least three partitions to do this, you can either partition current storage or add more virtual storage to your virtual machine.  Then use mdadm tool to create raid 5.  Share the NAS device you setup with NFS.

6.1 What is raid?  What is parity? Explain raid5?

RAID stands for Redundant Array of Independent Disks, which is a method of combining multiple physical hard drives into a single logical unit to improve performance, reliability, and/or capacity.

Parity is a technique used in RAID to protect data against disk failures. Parity information is generated and stored across multiple drives in the RAID array, allowing the system to rebuild lost data in the event of a disk failure. Parity stores information in each disk, Let’s say we have 4 disks, in 4 disks one disk space will be split into all disks to store the parity information. If any one of the disks fails still we can get the data by rebuilding from parity information after replacing the failed disk.

RAID 5 is a specific type of RAID that uses block-level striping and parity data across multiple drives. It requires a minimum of three disks to implement, and provides a good balance of performance, capacity, and data protection. In RAID 5, data is split into blocks and distributed across all the disks in the array, with parity information stored on a separate disk. If one disk fails, the system can use the parity data to reconstruct the lost data and store it on a replacement disk. However, if two disks fail, data loss can occur, as the system can no longer reconstruct the lost data. RAID 5 is often used in file servers and other applications where data protection is important, but performance and capacity are also key factors.


6.2 Show that your raid5 solution is working.

```
# list all available block devices
lsblk
fdisk -l
df -lh

# 创建虚机的时候，留出多余的free space，然后在虚机里面创建分区
# create partitions,  p: print, n: new, w: write, d: delete
fdisk /dev/vda

# lab1
sudo apt-get install mdadm
modprobe raid5  # load raid5 module
grep _MD_ /boot/config-`uname -r` # 查看内核是否支持raid5
sudo mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/vda3 /dev/vda4 /dev/vda5 # 创建raid5 array

# delete RAID https://bobcares.com/blog/removal-of-mdadm-raid-devices/
# sudo umount /dev/md0
# mdadm --stop /dev/md0
# mdadm --remove /dev/md0

sudo mkfs.ext4 /dev/md0 # 格式化
sudo mkdir /mnt/nfs # 创建挂载点
sudo mount /dev/md0 /mnt/nfs # 挂载
echo "/mnt/nfs *(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports
sudo systemctl restart nfs-kernel-server

# lab2
mkdir /mnt/nfs
sudo mount lab1:/mnt/nfs /mnt/nfs
unmount /mnt/nfs


# test raid5 working
mdadm -D /dev/md0 # 查看raid5状态
cat /proc/mdstat # 查看raid5状态
echo "Hello, RAID5" > /mnt/nfs/test.txt
# test raid5 failure
sudo mdadm --fail /dev/md0 /dev/vda3
cat /proc/mdstat
sudo mdadm --remove /dev/md0 /dev/vda3
sudo mdadm --add /dev/md0 /dev/vda6

```

6.3 Access the NAS device from lab2 over NFS

```
# lab2
cat /mnt/nfs/test.txt
```

7. Final question
7.1 Describe briefly a few use cases for samba, nfs, sshfs and WebDAV. Where, why, weaknesses?

Samba:

* Use case: Sharing files and printers between Linux/Unix and Windows machines over a network.
* Where: Small to large networks with a mix of Linux/Unix and Windows machines.
* Why: Provides seamless file and printer sharing between different operating systems.
* Weaknesses: Can be more difficult to set up and configure compared to other solutions, may have performance issues with larger networks.

NFS:

* Use case: Sharing files between Unix/Linux machines over a network.
* Where: Unix/Linux networks.
* Why: Provides fast, efficient file sharing between Unix/Linux machines.
* Weaknesses: May have security concerns, especially when used over an unsecured network. May not be as compatible with other operating systems.

SSHFS:

* Use case: Mounting remote file systems over SSH.
* Where: Anywhere with remote servers accessible over SSH.
* Why: Provides a secure way to access and manipulate files on remote servers, with the ability to mount remote file systems as if they were local.
* Weaknesses: May have performance issues with larger file transfers, may not be as seamless as other solutions for file sharing.

WebDAV:

* Use case: Collaborative editing and management of files on remote web servers.
* Where: Teams working on shared files and documents.
* Why: Provides a way to access and edit files on a web server, with features like versioning, locking, and sharing.
* Weaknesses: May have performance issues with larger file transfers, may not be as secure as other solutions depending on how it is implemented.