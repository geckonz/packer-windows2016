##############
# Final Tweaks
##############

Write-Host "Starting final tweaks"

# diable autologin *************************************************************

Set-ItemProperty                                                               `
    'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'              `
    -name AutoAdminLogon                                                       `
    -value 0

# diable hibernate *************************************************************

Set-ItemProperty                                                               `
    -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Power'                       `
    -Name HiberFileSizePercent                                                 `
    -value 0

Set-ItemProperty                                                               `
    -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Power'                       `
    -name HibernateEnabled                                                     `
    -value 0

# allow acpi shutdown **********************************************************

Set-ItemProperty                                                               `
    -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\system'                       `
    -Name shutdownwithoutlogon                                                 `
    -value 1

# enable user account controls (UAC) - formerly LUA (Limited User Accounts) ****

Set-ItemProperty                                                               `
    -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\system'    `
    -Name EnableLUA                                                            `
    -Value 1

#Monitor timeout
&powercfg -Change -monitor-timeout-ac 0
&powercfg -Change -monitor-timeout-dc 0
&powercfg -hibernate OFF

Write-Host "Final tweaks complete"
