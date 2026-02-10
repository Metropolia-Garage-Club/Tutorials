# Introduction to SSH

## What is it and why is it needed

In short, the Secure Shell Protocol (SSH) is a secure remote login service over a network. \
It allows you to connect to another machine, so you can control it without needing to plug in a mouse, \
keyboard and monitor. Very convenient for embedded devices, which might be housed inside a moving robot.

**Password vs Key authentication** \
Generally, password login should only be used to establish the inital connection between machines \
and to copy your public key to the host you are connecting to. After this you can disable \
password login on the host machine so that only known keys will be able to connect to it.

## How to use SSH

**Generating a key**
Make sure you have an OpenSSH compatible client installed, on most linux distributions it is preinstalled, \
but the server might need to be manually enabled on the remote machine: to find out if the SSH server is enabled, \
run `systemctl status sshd`, and in case it is not active, enable it with `systemctl enable sshd` \
Remember to restart the _sshd_ service by running `systemctl restart sshd` after editing any of its config files.

A key can be generated from the client device with the following command: `ssh-keygen -t ed25519 -f /path/to/key/file`. \
While the -f [name] is not needed, it can be useful to name keys for specific uscases i.e. scool, work, home. \
The reason why you'd want to do this is, that if you use the same key for every remote device you connec to, \
a potential attacker will only need to get you key from one source and be able to authenticate to any device \
that key has been used to authenticate to.

**Connecting to host**
Now, you can connect to your target either through the VS Code Remote-SSH Extension or on the commandline: \
`ssh <user>@<host>`, the user is your user on the target machine you want to login as and the host can be \
either a valid hostname or more commonly the IPv4 / IPv6 address of the target machine (192.168.x.x).

In case the conneciton is refused, even though the user and IP are correct, check what port the ssh server \
is listening on from the sshd config file: `/etc/ssh/sshd_config`. If the port is anything other than the \
default port 22 i.e. 23, connecting to the host is done by giving the port as an additional parameter: \
`ssh <user>@<host> -p <port_number>`

After creating your key and verifying that you are able to connect to the host. Disconnect from the host \
using `ctrl+d` or typing `exit` in the command line. Your _public_ key can now be copied over to the host \
machine with the following command: \
`ssh-copy-id -i /path/to/your/key.pub <user>@<host>`

At this point, it is also worth mentioning that setting a static IP for the host is advised, as doing so \
ensures that the host is always found at the same IP, so you won't run into problems when connecting. \
Also, be aware, when using a local IP (looks like this: 192.168.x.x), the client and host will need to be \
in the same network for a local IP connection to be possible.

After testing the connection, we are going to disable password authentication in the ssh_config file, \
which on Linux is found at `/etc/ssh/ssh_config`. Do note that there are other configuraration files in \
the same directory, which might need to be checked if someone else has previously used the machine and \
potentially altered the default configuration.

Commenting out the line saying `PasswordAuthentication yes` disables the ability for any machine to \
connect to your host, unless it has a known public key. For security reasons, disabling password authentication\
is recommended, even if the host doesn't necessarily have any super secret data.

## Recommended use cases

**Connecting to another machine remotely** \
Regardless whether the machine you want to connect to is a container running on your machine or \
a Raspberry Pi running a server of some kind, perhaps it's a Jetson powering the robot you are developing, \
in any case: you need a remote connection to it.

**Copying files from one machine to another** \
Another useful feature of remote connection is the ability to copy over files from machine A (local) \
to B (remote) or B to A. This is done using the _scp_ command as follows: \
`scp /path/to/file/on/machine/A <user>@<host>:/path/where/to/copy/to/on/machine/B`\
Incase you want to go in the other direction (from remote to local), all you need to do is reverse the order, \
in which machines A and B are given as arguments to the _scp_ command.

**Connecting to GitHub or another Git host** \
If you've ever cloned a git repository you may have noticed that there is more than one way of cloning a repository.

First one is the more common way of using https: \
`https://github.com/<user>/<repository>.git`

The second option is using SSH, where the url instead looks like this: \
`git@github.com:<user>/<repository>.git`

As a more concrete example, to clone the repository where this guide resides into your currently active directory, \
run one of the following commands: \
`git clone git@github.com:Metropolia-Garage-Club/Tutorials.git` \
`git clone https://github.com/Metropolia-Garage-Club/Tutorials.git`

With the latter method, if you have authenticated a key on your machine to be used with your GitHub account \
using github-cli, you can interact with any repository you have access to wihout needing password authentication, \
or specifically GitHub Desktop / VS Code installed (to which you likely logged in with a GitHub account).

The reason why you might need to authenticate a machine to use GitHub from the command line, is that you work on a private repository \
or host config files in one, your options for getting the contents of that repository onto a headless server are: either copying \
files over ssh, copying files from a USB Stick (meaning you have physical access to the host), or directly cloning the repository after \
authentication to GitHub via either github-cli or VS Code. And the more actively you want to contribute to any project, the more annoying \
the non-direct communication methods to GitHub become.
