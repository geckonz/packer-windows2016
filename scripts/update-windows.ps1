#########################
# Install Windows Updates
#########################

# See: https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/ADV990001
$ssu_file_name = "windows10.0-kb4550994-x64_1df8a8ea245041495f3b219fb22f3849908d8e27.msu"
$cu_file_name = "windows10.0-kb4550929-x64_1d6541833fc96407f5c59911aaf1fcd2bf2036aa.msu"

if ($httpIp){
	if (!$httpPort){
    	$httpPort = "80"
    }
    $download_url = "http://$($httpIp):$($httpPort)/"
} else {
    $download_url = "http://$ENV:PACKER_HTTP_ADDR/"
}
Write-Host "Using download location: $download_url"

Write-Host "Downlading: $ssu_file_name"
Invoke-WebRequest -Uri "$($download_url)$($ssu_file_name)" -OutFile "C:\Windows\Temp\$ssu_file_name"

Write-Host "Installing servicing stack update: $ssu_file_name"
$ssu_argument_list = '"C:\Windows\Temp\' + $ssu_file_name + '" /quiet /norestart"'
$ssu_process = Start-Process -FilePath "wusa.exe" -ArgumentList $ssu_argument_list -NoNewWindow -PassThru -Wait
Write-Host "Servicing stack update exitcode: $($ssu_process.ExitCode)"
Remove-Item "C:\Windows\Temp\$ssu_file_name"

Write-Host "Downlading: $cu_file_name"
Invoke-WebRequest -Uri "$($download_url)$($cu_file_name)" -OutFile "C:\Windows\Temp\$cu_file_name"

Write-Host "Installing cumulative update: $cu_file_name"
$cu_argument_list = '"C:\Windows\Temp\' + $cu_file_name + '" /quiet /norestart"'
$cu_process = Start-Process -FilePath "wusa.exe" -ArgumentList $cu_argument_list -NoNewWindow -PassThru -Wait
Write-Host "Cumulative update exitcode: $($cu_process.ExitCode)"
Remove-Item "C:\Windows\Temp\$cu_file_name"
