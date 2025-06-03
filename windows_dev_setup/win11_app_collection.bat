Rem This script installs useful software used in the AIoT Garage 
Rem ### CAD ###
winget install --id=KiCad.KiCad -e --scope machine &&
winget install --id=FreeCAD.FreeCAD -e --scope machine &&
winget install --id=GNU.Octave -e --scope machine &&

Rem ### 3D Printing 
winget install --id=Prusa3D.PrusaSlicer -e --scope machine && 
winget install --id=SoftFever.OrcaSlicer -e --scope machine &&
Rem winget install --id=Mango3D.LycheeSlicer -e --scope machine && 
Rem winget install --id=Ultimaker.Cura -e --scope machine &&

Rem Currently not allowed in Metropolia Network!!
Rem winget install --id=Bambulab.Bambustudio -e --scope machine &&

Rem Communication Software
Rem winget install --id=Zoom.Zoom -e --scope machine &&

Rem ### Media & Document Tools ###
Rem winget install --id=TheDocumentFoundation.LibreOffice -e --scope machine &&
Rem winget install --id=Adobe.Acrobat.Reader.64-bit -e --scope machine &&
winget install --id=Audacity.Audacity -e --scope machine &&
winget install --id=GIMP.GIMP.3 -e --scope machine &&
winget install --id=OBSProject.OBSStudio -e --scope machine &&
Rem winget install --id=VideoLAN.VLC -e --scope machine &&

Rem ### DEV Tools ###
Rem winget install --id=Notepad++.Notepad++ -e --scope machine &&
Rem winget install --id=Microsoft.VisualStudioCode -e --scope machine && 
winget install --id=ArduinoSA.IDE.stable -e --scope machine &&
winget install --id=Git.Git -e --scope machine &&
winget install --id=GitHub.cli -e --scope machine &&
winget install --id=GitHub.GitHubDesktop -e --scope machine &&
winget install --id=Google.CloudSDK -e --scope machine &&
winget install --id=Amazon.AWSCLI -e --scope machine && 
winget install --id=Hashicorp.Terraform -e --scope machine &&
Rem winget install --id=Python.Python.3.12 -e --scope machine &&
Rem winget install --id=Anaconda.Anaconda3 -e --scope machine &&
Rem winget install --id=Anaconda.Miniconda3 -e --scope machine && 
winget install --id=Docker.DockerDesktop -e --scope machine &&
Rem winget install --id=DEVCOM.Lua -e --scope machine &&

Rem ## Disk Image Tools ##
winget install --id=Rufus.Rufus -e --scope machine &&
winget install --id=RaspberryPiFoundation.RaspberryPiImager -e --scope machine &&

Rem ## Network and VM
winget install --id=WireGuard.WireGuard -e --scope machine &&
winget install --id=Netbird.Netbird -e --scope machine && 
Rem winget install --id=WiresharkFoundation.Wireshark -e --scope machine &&
Rem winget install --id=Microsoft.WSL -e --scope machine && 
Rem winget install --id=Bostrot.WSLManager -e --scope machine &&
Rem winget install --id=Oracle.VirtualBox -e --scope machine &&

Rem ## Other Useful tools
Rem winget install --id=Mozilla.Firefox -e --scope machine &&
Rem winget install --id=RARLab.WinRAR -e --scope machine &&
Rem winget install --id=7zip.7zip -e --scope machine &&
Rem winget install --id=KeePassXCTeam.KeePassXC -e --scope machine &&

Rem winget install --id=Microsoft.PowerToys -e --scope machine &&
Rem inget install --id=Henry++.ErrorLookup -e --scope machine &&

Rem ### Benchark Tools ###
Rem winget install --id=Maxon.CinebenchR23 -e --scope machine &&

Rem ### Gaming related applications ###
Rem winget install --id=GOG.Galaxy -e --scope machine &&
Rem winget install --id=Valve.Steam -e --scope machine &&
Rem winget install --id=Spotify.Spotify -e --scope machine &&
Rem winget install --id=Discord.Discord -e --scope machine &&
Rem winget install --id=Nvidia.GeForceNow -e --scope machine &&
Rem winget install --id=WhirlwindFX.SignalRgb -e --scope machine &&
Rem winget install --id=Wagnardsoft.DisplayDriverUninstaller -e --scope machine &&
Rem winget install --id=Guru3D.Afterburner -e --scope machine &&
Rem winget install --id=CPUID.HWMonitor -e --scope machine && 
Rem winget install --id=REALiX.HWiNFO -e --scope machine &&
Rem winget install --id=TechPowerUp.GPU-Z -e --scope machine &&
Rem winget install --id=CPUID.CPU-Z -e --scope machine
