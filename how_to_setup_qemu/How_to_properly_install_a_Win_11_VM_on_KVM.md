## Credits to SysGuides for creating the articles this guide is made from
**https://sysguides.com**

[How to Properly Install a Windows 11 Virtual Machine on KVM](https://sysguides.com/install-a-windows-11-virtual-machine-on-kvm)
[(190) How To PROPERLY Install Windows 11 on KVM (2024) - YouTube](https://www.youtube.com/watch?v=7tqKBy9r9b4)
[How Do I Properly Install KVM on Linux (2024)](https://sysguides.com/install-kvm-on-linux

Arch qemu
```
sudo yay -S qemu-full libvirt virt-install virt-manager virt-viewer \    edk2-ovmf swtpm qemu-img guestfs-tools libosinfo tuned
```

Debian qemu
```
sudo nala install qemu-system-x86 libvirt-daemon-system virtinst \
    virt-manager virt-viewer ovmf swtpm qemu-utils guestfs-tools \
    libosinfo-bin tuned
```

virtIO drivers for windows guests
```
mkdir -p ~/Documents/vm
wget -O ~/Documents/vm/virtio-win-0.1.240.iso https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.240-1/virtio-win-0.1.240.iso
```

Enable modular libvirt Arch (does not work in fish)
```
for drv in qemu interface network nodedev nwfilter secret storage; do \
    sudo systemctl enable virt${drv}d.service; \
    sudo systemctl enable virt${drv}d{,-ro,-admin}.socket; \
  done
```

Enable monolithic libvirt Debian
```
sudo systemctl enable libvirtd.service
```

configure network bridge Debian
```
sudo virsh net-start default
sudo virsh net-autostart default
```


If you want to run Microsoft Windows 11 as a guest virtual machine on KVM, you must take some extra steps to ensure it runs smoothly. So, in this tutorial, I'll show you how to properly install a Windows 11 virtual machine on KVM.

    If you're interested in dual booting Windows 11 with Ubuntu on your current hardware, check out my other blog, 'How to Properly Dual-boot Windows 11 and Ubuntu'.

Before you begin, make sure you have met the following requirements:

    You have installed the KVM hypervisor on your computer. If not, see my other guide, 'How Do I Properly Install KVM on Linux'.
    You have installed or downloaded the virtio drivers for Windows guests on your host system. If not, see the section 'Install VirtIO Drivers for Windows Guests'.
    You downloaded the official Windows 11 installation ISO image. You can get the ISO from the 'Download Windows 11' page.

So let's get started.
## Table of Contents

    1. Configure Windows 11 Virtual Hardware
        1.1. Configure Default Virtual Hardware Using the Wizard
        1.2. Configure Chipset and Firmware
        1.3. Enable Hyper-V Enlightenments
        1.4. Enable CPU Host-Passthrough
        1.5. Configure the Storage
        1.6. Mount the VirtIO-Win.ISO Image
        1.7. Configure Virtual Network Interface
        1.8. Remove the USB Tablet Device
        1.9. Add QEMU Guest Agent Channel
        1.10. Enable Trusted Platform Module (TPM)
    2. Install a Windows 11 Virtual Machine on KVM
    3. Enable Hardware Security on Windows 11
    4. Optimize Windows 11 Performance
        4.1. Disable SuperFetch
        4.2. Disable Windows Web Search
        4.3. Disable useplatformclock
        4.4. Disable Unnecessary Scheduled Tasks
        4.5. Disable Unnecessary Startup Programs
        4.6. Adjust the Visual Effects in Windows 11
    5. Conclusion
    6. Watch on YouTube

## 1. Configure Windows 11 Virtual Hardware

Start the Virtual Machine Manager application.

Before you begin creating a Windows 11 guest virtual machine, you must first enable XML editing because you will need to add the Hyper-V XML component later in this section.

Go to **Edit > Preferences** and **Enable XML editing**.
![[02-install-windows-11-virtual-machine-on-kvm-enable-xml-editing.webp]]

After that, click the computer icon in the upper left corner.
![[03-install-windows-11-virtual-machine-on-kvm-start-wizard.webp]]

This will launch a wizard that will guide you through the process of creating a new virtual machine in five easy steps.
### 1.1. Configure Default Virtual Hardware Using the Wizard

The Virtual Machine Manager wizard lets you quickly create a guest virtual machine with the default settings. Once that's done, you can make additional changes to the settings to ensure that the Windows 11 virtual machine runs smoothly.

**STEP 1: Choose how you would like to install the operating system.**

As you are installing Windows 11 from an ISO image, choose the first option. Then click the Forward button.
![[04-install-windows-11-virtual-machine-on-kvm-wizard-step1.webp]]

**STEP 2: Choose ISO installation media.**

Provide the location of the Windows 11 ISO installer image. Then click the Forward button.
![[05-install-windows-11-virtual-machine-on-kvm-wizard-step2.webp]]

**STEP 3: Choose Memory and CPU settings**.

Set the amount of host memory and virtual CPUs that will be assigned to the guest virtual machine. I'll set the guest memory to 6 GiB and the virtual CPUs to 2. You can, however, change this based on your RAM and CPU availability. Click the Forward button to continue.
![[06-install-windows-11-virtual-machine-on-kvm-wizard-step3.webp]]

**STEP 4: Enable storage for this virtual machine.**

Set the disk image size for the virtual machine. The disk image that is created will be of the type QCOW2, which is a copy-on-write format. The QCOW2's initial file size will be smaller, and it will only grow as more data is added. So I'll set the disk image size to 80 GiB, but you can change it to suit your needs. To install Windows 11, you need to have a disk space of 64 GiB or greater.
![[07-install-windows-11-virtual-machine-on-kvm-wizard-step4.webp]]

**STEP 5: Set the name of the virtual machine.**

This is the final configuration screen of the Virtual Machine Creation Wizard. Give the guest virtual machine a name. I'll set it to 'Windows-11', but you can change it to anything you want.

Also, ensure that the 'Customize configuration before install' checkbox is selected. Click the Finish button to finish the wizard and proceed to the advanced options.
![[08-install-windows-11-virtual-machine-on-kvm-wizard-step5.webp]]

You will now be in the advanced options window.
### 1.2. Configure Chipset and Firmware

In the Overview section, make sure the chipset is set to Q35 and the firmware is set to UEFI.
![[09-install-windows-11-virtual-machine-on-kvm-adv-chipset-firmware.webp]]

The Q35 chipset natively supports PCIe and provides improved PCI-E pass-through support.

The UEFI firmware option, on the other hand, enables Secure Boot, which is required for Windows 11. When using the UEFI firmware, you can take internal snapshots while the guest is shut down but not while it is running.
### 1.3. Enable Hyper-V Enlightenments

Hyper-V Enlightenments allow KVM to emulate the Microsoft Hyper-V hypervisor. This improves the performance of the Windows 11 virtual machine.

For more information, check out the pages 'Hyper-V Enlightenments' and 'Hypervisor Features'.

```
Click the XML tab and add or replace the highlighted XML in the <hyperv> and <timer> in <clock> sections.
```
![[10-install-windows-11-virtual-machine-on-kvm-adv-hyperv.webp]]

    Note: If you have an AMD processor, you cannot use the 'hv-evmcs' feature. This VMCS feature is only available for Intel platforms.

    You must remove the line '<evmcs state="on"/>' from the following XML. I've highlighted it in bold.

    Thanks to Benjamin Poirier for suggesting this.
```
The XML for <hyperv> is:

<hyperv mode="custom">
  <relaxed state="on"/>
  <vapic state="on"/>
  <spinlocks state="on" retries="8191"/>
  <vpindex state="on"/>
  <runtime state="on"/>
  <synic state="on"/>
  <stimer state="on">
    <direct state="on"/>
  </stimer>
  <reset state="on"/>
  <vendor_id state="on" value="KVM Hv"/>
  <frequencies state="on"/>
  <reenlightenment state="on"/>
  <tlbflush state="on"/>
  <ipi state="on"/>
  <evmcs state="on"/>
</hyperv>

The XML for the <timer> in the <clock> section is:

<clock offset="localtime">
  ... 
  <timer name="hypervclock" present="yes"/>
</clock>
```

### 1.4. Enable CPU Host-Passthrough

Select the CPUs section in the left panel. Ensure that host-passthrough is enabled.
![[11-install-windows-11-virtual-machine-on-kvm-adv-cpu-host-passthrough.webp]]

When the mode is set to host-passthrough, the host CPU's model and features are exactly passed on to the guest virtual machine. This causes the virtual machine to run close to the host's native speed. This is the recommended and default option as well.
### 1.5. Configure the Storage

From the left panel, select SATA Disk 1.

Change the disk bus from SATA to VirtIO. VirtIO is preferred over other emulated storage controllers as it is specifically designed and optimized for virtualization.

Set the cache mode to none. In this mode, the host page cache is bypassed, and I/O occurs directly between the hypervisor user space buffers and the storage device. In terms of performance, it is equivalent to direct disk access on your host.

Set the discard mode to unmap. When you delete files in the guest virtual machine, the changes are reflected immediately in the guest file system. The qcow2 disk image associated with the VM on the host, however, does not shrink to reflect the newly freed space. When you set the discard mode to unmap, the qcow2 disk image will automatically shrink to reflect the newly freed space.
![[12-install-windows-11-virtual-machine-on-kvm-adv-storage.webp]]

### 1.6. Mount the VirtIO-Win.ISO Image

VirtIO drivers are para-virtualized drivers for KVM guests. Microsoft, unfortunately, does not provide these drivers. When installing a Microsoft Windows virtual machine, you must install certain VirtIO drivers.

As a result, you must mount the virtio-win.iso image file, which contains the VirtIO drivers for Windows. This requires the addition of a second CDROM.

Click the Add Hardware button, then select CDROM device as the Device type in the window that appears and mount the virtio-win.iso image file.
How to Properly Install a Windows 11 Virtual Machine on KVM - CDROM 2

If you're using Fedora as your KVM host, the ISO image will be located at /usr/share/virtio-win/.

If you haven't already installed or downloaded virtio-win.iso, see the section titled 'Install VirtIO Drivers for Windows Guests' in my other blog post titled 'How Do I Properly Install KVM on Linux'.
### 1.7. Configure Virtual Network Interface

In the NIC section, change the device model to virtio. The network VirtIO driver is specifically designed and optimized for virtualization. As a result, there will be no processing overhead, and the performance of the guest virtual machine will naturally improve.
![[13-install-windows-11-virtual-machine-on-kvm-adv-CDROM-2.webp]]
## 1.8. Remove the USB Tablet Device

In a Windows virtual machine, removing the USB tablet device can reduce idle CPU usage and context switches. As a result, the performance of the Windows 11 virtual machine will improve.
![[14-install-windows-11-virtual-machine-on-kvm-adv-nic.webp]]

### 1.9. Add QEMU Guest Agent Channel

The QEMU Guest Agent Channel establishes a private communication channel between the host physical machine and the guest virtual machine. This enables the host machine to issue commands to the guest operating system using libvirt. The guest operating system then responds to those commands asynchronously.

For example, after creating the Windows 11 guest virtual machine, you can shut it down from the host by issuing the following command:

`$ sudo virsh shutdown Windows-11 --mode=agent`

This shutdown method is more reliable than virsh shutdown --mode=acpi because it guarantees to shut down a cooperative guest in a clean state. If the agent is not present, libvirt must rely on injecting an ACPI shutdown event, which some guests ignore and thus do not shut down. You can also use the same syntax to reboot (virsh reboot).

Some of the commands you can try, among many others, are:

```
### Query the guest operating system's IP address via the guest agent.
$ sudo virsh domifaddr Windows-11 --source agent

### Show a list of mounted filesystems in the running guest.
$ sudo virsh domfsinfo Windows-11

### Instructs the guest to trim its filesystem.
$ sudo virsh domfstrim Windows-11
```

So, add a QEMU guest agent channel to the Windows 11 guest virtual machine.

Click the Add Hardware button to open the Add New Virtual Hardware window, and select Channel. Then, from the drop-down list, select 'org.qemu.guest_agent.0' and click Finish to apply.

![[16-install-windows-11-virtual-machine-on-kvm-adv-channel.webp]]
### 1.10. Enable Trusted Platform Module (TPM)

Enable the Trusted Platform Module (TPM). TPM technology is designed to provide hardware-based, security-related functions. Windows 11 requires TPM version 2.0.
![[17-install-windows-11-virtual-machine-on-kvm-adv-tpm.webp]]

All of the virtual hardware and settings needed to install Microsoft Windows 11 have been configured. To begin the installation of Windows 11, click the 'Begin Installation' button in the upper left corner of the window.
![[18-install-windows-11-virtual-machine-on-kvm-adv-begin-installation.webp]]
## 2. Install a Windows 11 Virtual Machine on KVM

Now that you have finished configuring Windows 11 virtual hardware and have clicked the 'Begin Installation' button, the Windows 11 installation starts.

On the screen that appears, choose your language, time and currency format, and keyboard from the list of available options. Then press the Next button.
![[19-install-windows-11-virtual-machine-on-kvm-install-language.webp]]

On the following screen, click Install Now. The Windows activation screen will appear. If you have a product key, enter it here. Otherwise, choose I don't have a product key.
![[20-install-windows-11-virtual-machine-on-kvm-install-product-key.webp]]

Choose the Windows version you want to install. I'll be installing Windows 11 Home for this tutorial.
![[21-install-windows-11-virtual-machine-on-kvm-install-win-home.webp]]

When you get to the type of installation screen, choose Custom: Install Windows only (advanced).
![[22-install-windows-11-virtual-machine-on-kvm-install-custom.webp]]

You must now select the disk on which Windows 11 will be installed. However, as you can see, the installer was unable to find any drives.
![[23-install-windows-11-virtual-machine-on-kvm-install-no-disk.webp]]

This is because you selected the VirtIO disk bus when configuring Windows 11 virtual hardware. VirtIO devices are not natively recognized by Windows, so you must manually install the drivers.

To install the VirtIO disk driver, click Load driver, then Browse, expand the CD Drive (E:), expand Viostor, expand w11, select amd64, and click OK.
![[24-install-windows-11-virtual-machine-on-kvm-install-viostor.webp]]

Click Next to install.
![[25-install-windows-11-virtual-machine-on-kvm-install-viostor-driver.webp]]

As you can see, the disk is now visible after installing the VirtIO storage driver.
![[26-install-windows-11-virtual-machine-on-kvm-install-disk-80.webp]]

But don't proceed with the installation just yet. You still need to install the VirtIO network driver.

Repeat the procedure for the network device as well. Click Load driver again, then Browse, expand the CD Drive (E:), expand NetKVM, expand w11, select amd64, and click OK.
![[27-install-windows-11-virtual-machine-on-kvm-install-netkvm-driver.webp]]

After installing the VirtIO network device driver, click the Next button to proceed with the installation.
![[28-install-windows-11-virtual-machine-on-kvm-install-start.webp]]

The next installation steps are all about personalization. Complete the installation according to your needs, and you will be taken to the desktop environment once it is finished.
![[29-install-windows-11-virtual-machine-on-kvm-install-windows-desktop.webp]]

Finally, you must install VirtIO Windows Guest Tools. This package includes some optional drivers and services that will boost SPICE performance and integration. This includes the QXL video driver as well as the SPICE guest agent for copy and paste, automatic resolution switching, and other features.

So launch **Windows Explorer**, navigate to the **CD Drive (E:)**, and double-click the **virtio-win-guest-tools** package to install it.
![[30-install-windows-11-virtual-machine-on-kvm-install-guest-tools.webp]]

After installing the guest tools, on the Windows-11 KVM window, click View, Scale Display, and check the 'Auto resize VM with window' option. This will enable the Windows 11 guest window to automatically resize as you scale it.
![[31-install-windows-11-virtual-machine-on-kvm-install-auto-resize.webp]]

The Windows 11 operating system installation is now complete. Shut down the Windows 11 virtual machine.

Now that you've installed guest tools, you don't need the second CDROM drive. Click the lightbulb icon to access the hardware details. Unmount the virtio-win.iso image and then remove the second CDROM drive.
![[32-install-windows-11-virtual-machine-on-kvm-remove-cdrom-2.webp]]

Unmount the ISO image of the Windows 11 installer from the first CDROM drive as well.

![[33-install-windows-11-virtual-machine-on-kvm-unmount-iso.webp]]
## 3. Enable Hardware Security on Windows 11

With the Q35 chipset selected, Secure Boot and TPM 2.0 enabled, and the latest WHQL-certified VirtIO drivers installed, your Windows 11 guest virtual machine already has standard security.

You can check if your VM passes standard security by opening the Device Security page.

To access the Device Security page, navigate to Settings > Privacy & Security > Windows Security > Device Security.
![[34-install-windows-11-virtual-machine-on-kvm-standard-security.webp]]

To make Windows 11 even more secure, you can enable Core Isolation.

Core isolation safeguards against malware and other attacks by separating computer processes from your operating system and device.

But before attempting to enable this feature, make sure that your processor supports it.

Your processor must meet the Windows Processor Requirements to enable this feature. If your processor is not on the list, skip this section and proceed to the next one.

Shut down your Windows 11 guest virtual machine. Open the virtual hardware details page, then click the Overview option on the left panel and the XML tab on the right.

```
Under the <cpu> section, specify the CPU mode and add the policy flag.

Replace this:

<cpu mode="host-passthrough" check="none" migratable="on"/>

With this:

<cpu mode="host-passthrough" check="none" migratable="on">
  <feature policy="require" name="vmx"/>
</cpu>
```

If you're using AMD CPUs, replace **vmx** with the **svm** policy flag.
![[35-install-windows-11-virtual-machine-on-kvm-enable-vmx.webp]]

Start your Windows 11 guest virtual machine and navigate to the Core isolation details page.

To access the Core isolation details page, navigate to Settings > Privacy & Security > Windows Security > Device Security > Core isolation details.

Toggle the Memory Integrity switch to enable it. When prompted, restart the Windows 11 VM.
![[36-install-windows-11-virtual-machine-on-kvm-toggle-memory.webp]]

After the reboot, check the security level of your device once more. Go to the Device Security page by navigating to Settings > Privacy & Security > Windows Security > Device Security.
![[37-install-windows-11-virtual-machine-on-kvm-enhanced-security.webp]]

You now have a Windows 11 guest virtual machine running with enhanced hardware security.
## 4. Optimize Windows 11 Performance

Configuring or disabling a number of Windows processes and features can help optimize the performance of a Windows 11 guest virtual machine.

The following are some suggestions for improving performance:
### 4.1. Disable SuperFetch

SuperFetch, also known as SysMain, is a standard Windows feature that preloads the apps you use the most frequently. Although Superfetch is useful, it consumes a significant amount of CPU and RAM as a background service.

To disable Superfetch, type services into the search box and press [Enter] to open the Services window.

In the Services window, look for SysMain. Right-click it and select Properties. Then disable the service.
![[38-install-windows-11-virtual-machine-on-kvm-disable-superfetch.webp]]
### 4.2. Disable Windows Web Search

When you search for something in the Windows Search box or Start menu, you may have to wait a few seconds as Windows retrieves your search results along with a list of suggested web results from Bing. Although this is a useful feature, you may dislike it and wish to disable it.

To disable web results on Windows 11, follow these steps:

    Enter regedit into the search box and press [Enter] to launch the Registry Editor.
    Browse to: Computer\HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows.
    Right-click the Windows key, select New, and then select the Key option. Enter Explorer as the key name and press [Enter].
    Now, right-click on the newly created Explorer key, select New, and then the DWORD (32-bit) Value option. Name the DWORD DisableSearchBoxSuggestions and press [Enter].
    Double-click the newly created DWORD DisableSearchBoxSuggestions and change its value from 0 to 1.

![[39-install-windows-11-virtual-machine-on-kvm-disable-web-search.webp]]

Close the Registry Editor window and restart your computer. You will now have fast-loading search results that do not retrieve results from the web.
### 4.3. Disable useplatformclock

When the Hyper-V extensions are enabled, setting the useplatformclock option in bcdedit to "yes" results in poor performance. As a result, disable this feature.

Open the Terminal as an Administrator and type the following command, then press [Enter].

`C:\> bcdedit /set useplatformclock No`

### 4.4. Disable Unnecessary Scheduled Tasks

Review and disable any unnecessary scheduled tasks.

To get a list of all scheduled tasks, open the Terminal as an Administrator and run the following command:

`C:\> Get-ScheduledTask`

Use the command below to search for tasks that have the word 'schedule' in their name.

`C:\> Get-ScheduledTask -TaskName '*schedule*'`

TaskPath                                TaskName                         State
--------                                --------                         -----
\Microsoft\Windows\Defrag\              ScheduledDefrag                  Ready
\Microsoft\Windows\Diagnosis\           Scheduled                        Ready
\Microsoft\Windows\UpdateOrchestrator\  Schedule Maintenance Work        Disabled
\Microsoft\Windows\UpdateOrchestrator\  Schedule Scan                    Ready
\Microsoft\Windows\UpdateOrchestrator\  Schedule Scan Static Task        Ready
\Microsoft\Windows\UpdateOrchestrator\  Schedule Wake To Work            Disabled
\Microsoft\Windows\UpdateOrchestrator\  Schedule Work                    Ready
\Microsoft\Windows\Windows Defender\    Windows Defender Scheduled Scan  Ready
\Microsoft\Windows\WindowsUpdate\       Scheduled Start                  Ready

I'm only going to disable the ScheduledDefrag task. It is entirely up to you which other scheduled tasks you wish to disable.

C:\> Disable-ScheduledTask -TaskPath '\Microsoft\Windows\Defrag\' -TaskName ScheduledDefrag

TaskPath                    TaskName         State
--------                    --------         -----
\Microsoft\Windows\Defrag\  ScheduledDefrag  Disabled

### 4.5. Disable Unnecessary Startup Programs

Some programs start automatically and run in the background when you turn on your computer. You can disable these programs so that they do not start when your computer boots.

To stop a program from starting automatically, navigate to Settings > Apps > Startup. Then, turn off all programs that you don't need or use frequently.
![[40-install-windows-11-virtual-machine-on-kvm-disable-auto-start.webp]]
### 4.6. Adjust the Visual Effects in Windows 11

Many visual effects, such as animations and shadow effects, are included in Windows 11. These are visually appealing, but they can consume additional system resources and slow down your computer.

To disable visual effects in Windows, first type performance in the Search box, then select Adjust the appearance and performance of Windows from the list of results.
![[41-install-windows-11-virtual-machine-on-kvm-disable-animation-1.webp]]

On the Visual Effects tab, select Adjust for best performance > Apply.
![[42-install-windows-11-virtual-machine-on-kvm-disable-animation-1.webp]]

The process of properly installing a Windows 11 Virtual Machine on KVM has now been completed.
## 5. Conclusion

You can boost the performance of the Windows 11 guest virtual machine even further by turning off antivirus software, uninstalling unwanted software, and so on. These, however, are beyond the scope of this tutorial. You can look up optimizing Windows 11 on the internet, and there are numerous guides available.

If you want to share the host system files with your Windows guest virtual machine, please see my other blog on how to share files between the KVM host and Windows guest virtual machine using Virtiofs.