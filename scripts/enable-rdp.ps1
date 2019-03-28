############
# Enable RDP
############

Write-Host "Enabling RDP Access"

Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\' -Name "fDenyTSConnections" -Value 0
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "UserAuthentication" -Value 1

Set-NetFirewallRule -Name RemoteDesktop-UserMode-In-TCP -Enabled true
