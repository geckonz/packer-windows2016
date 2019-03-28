#################
# Compact machine
#################

Write-Host "Compacting machine"

Stop-Service wuauserv
#Set-Service wuauserv -Startup disabled

#Get-ChildItem -Path 'C:\Windows\SoftwareDistribution\Download' -Recurse | Remove-Item -Force -Recurse

Optimize-Volume -DriveLetter $($env:SystemDrive)[0] -Verbose
