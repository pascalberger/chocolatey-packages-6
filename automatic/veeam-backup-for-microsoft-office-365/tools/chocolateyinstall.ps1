﻿$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download2.veeam.com/VeeamBackupOffice365_4.0.0.1345.zip'
$checksum = 'd2523a719d516b71bbeb5df7d4b13d715b99ac852e15e7a0db0447c74b136dd3'
$checksumType = 'sha256'
$version = '4.0.0.1345'
$fileLocation = Join-Path $toolsDir "Veeam.Backup365_$($version).msi"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
}

$pp = Get-PackageParameters

[System.Collections.ArrayList]$silentArgs = @()

if ($pp.server) {
  $silentArgs.Add('BR_OFFICE365')
}

if ($pp.console) {
  $silentArgs.Add('CONSOLE_OFFICE365')
}

if ($pp.powershell) {
  $silentArgs.Add('PS_OFFICE365')
}

if ($silentArgs.Count -eq 0) {
  $silentArgs.Add('BR_OFFICE365')
  $silentArgs.Add('CONSOLE_OFFICE365')
  $silentArgs.Add('PS_OFFICE365')
}

$silent = $silentArgs -join ','

Install-ChocolateyZipPackage @packageArgs

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Veeam Backup for Microsoft Office 365*'
  file          = $fileLocation
  fileType      = 'msi'
  silentArgs    = "/qn /norestart ADDLOCAL=$($silent) ACCEPT_THIRDPARTY_LICENSES=1 ACCEPT_EULA=1 /l*v `"$env:TEMP\$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.log`""
  validExitCodes= @(0,1641,3010)
}

Install-ChocolateyInstallPackage @packageArgs
