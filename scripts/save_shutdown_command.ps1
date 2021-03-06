$packerWindowsDir = 'C:\Windows\packer'
New-Item -Path $packerWindowsDir -ItemType Directory -Force

# final shutdown command
$shutdownCmd = @"
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new action=block

C:/windows/system32/sysprep/sysprep.exe /generalize /oobe /unattend:C:/Windows/packer/unattended.xml /quiet /shutdown
"@

# unattend XML to run on first boot after sysprep
$unattendedXML = @"
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="generalize">
        <component name="Microsoft-Windows-Security-SPP" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <SkipRearm>1</SkipRearm>
        </component>
        <component name="Microsoft-Windows-PnpSysprep" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <PersistAllDeviceInstalls>false</PersistAllDeviceInstalls>
            <DoNotCleanUpNonPresentDevices>false</DoNotCleanUpNonPresentDevices>
        </component>
    </settings>
    <settings pass="oobeSystem">
      <component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <InputLocale>1409:00000409</InputLocale>
        <SystemLocale>en-NZ</SystemLocale>
        <UILanguage>en-NZ</UILanguage>
        <UILanguageFallback>en-US</UILanguageFallback>
        <UserLocale>en-NZ</UserLocale>
      </component>
      <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
          <OOBE>
              <HideEULAPage>true</HideEULAPage>
              <ProtectYourPC>1</ProtectYourPC>
              <NetworkLocation>Home</NetworkLocation>
              <HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
          </OOBE>
          <TimeZone>New Zealand Standard Time</TimeZone>
          <UserAccounts>
              <AdministratorPassword>
                  <Value>1-ChangeMePlease!</Value>
                  <PlainText>true</PlainText>
              </AdministratorPassword>
          </UserAccounts>
      </component>
    </settings>
    <settings pass="specialize">
    </settings>
</unattend>
"@

Set-Content -Path "$($packerWindowsDir)\PackerShutdown.bat" -Value $shutdownCmd
Set-Content -Path "$($packerWindowsDir)\unattended.xml" -Value $unattendedXML

# will run on first boot
# https://technet.microsoft.com/en-us/library/cc766314(v=ws.10).aspx
$setupComplete = @"
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new action=allow
"@

New-Item -Path 'C:\Windows\Setup\Scripts' -ItemType Directory -Force
Set-Content -path "C:\Windows\Setup\Scripts\SetupComplete.cmd" -Value $setupComplete
