# Packer-Windows2016 (Evaluation)

Makes a Windows Server 2016 x64 box for use with Virtualbox or Hyper-V.

Inspired by so many other repositories on GitHub.

## Background

The intent for this project was to create something as close to an Enterprise build as possible. For example the build only uses the Administrator user rather than using a separate Vagrant account, and also take advantages of up-to date features of Windows 2016+. The images are Windows Server Std based images, using an Evaluation product key. I live in New Zealand and therefore the images are localised to the NZ language and TimeZone.

## Usage

There is both a Desktop edition and the Core edition of the Packer builds.

Simple replace -core with -desktop to change. The Desktop edition has RDP enabled.

```
$ packer build -only=virtualbox-iso windows2016-core.json

$ vagrant box add --name windows2016-core builds/windows2016-core.virtualbox.box --force

$ vagrant init windows2016-core

$ vagrant up
```

**Note** There are two default passwords used. The first is the Administrator password for the Packer tasks, the second is the final password change for the Administrator user for Vagrant to then use. Changing the first password is considered optional, however it is recommended that you change "1-ChangeMePlease!" in  scripts/save_shutdown_command.ps1 and then set it to match in your Vagrantfile.

## Features

This repository is based on **Windows Server 2016 Evaluation** and the build does the following:

* Autounattend.xml
  * enable winrm
* windows2016-core.json
  * restart windows
    * update windows (see below)
  * restart windows
    * compiles dot net assemblies
    * enables RDP (Desktop build only)
    * does some tweaks
    * compacts the drive

The installation of Guest Tools is left to the Vagrant job, that way it is easier to support different versions of the Guest Tools without having to rebuild the image.

Windows updates are not installed from Windows Update. The process is designed to manually download the latest Servicing Stack Update and the latest Cumulative Update and save these files in the update_files directory, then set the variables in the update-windows.ps1 script. This make the build more predictable and also prevents multiple downloads occurring if you are changing and testing the builds.
