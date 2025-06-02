Rem This file is used to setup registry keys to remove bing results from windows search
Rem Run as Admin
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f
taskkill /f /im explorer.exe & start explorer.exe
