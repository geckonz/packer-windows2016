Write-Host "Installing certificates..."
certutil -addstore -f 'TrustedPublisher' 'D:\cert\vbox-sha1.cer'
certutil -addstore -f 'TrustedPublisher' 'D:\cert\vbox-sha256.cer'

Write-Host "Installing guest additions..."
Start-Process 'D:\VBoxWindowsAdditions.exe' '/S' -Wait
