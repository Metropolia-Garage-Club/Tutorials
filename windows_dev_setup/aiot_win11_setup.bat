Rem This file is used to setup registry keys to remove bing results from windows search
Rem Run as Admin

Rem This blocks Bing Search in windows search on the entire machine (supposed to)
Rem reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f
Rem taskkill /f /im explorer.exe & start explorer.exe

Rem This is for the currently active user only
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Search /v BingSearchEnabled /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe & start explorer.exe
