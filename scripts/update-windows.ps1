#########################
# Install Windows Updates
#########################

$ssu_file_name = "windows10.0-kb4520724-x64_97604f0b532d6da814b4120fc43b2d9f6fd0b356.msu"
$cu_file_name = "windows10.0-kb4537764-x64_93e41ada5a984e3749ecd87bc5515bdc48cefb4d.msu"

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
