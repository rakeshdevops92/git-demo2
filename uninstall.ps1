
function Get-InstalledApps
{
    if ([IntPtr]::Size -eq 4) {
        $regpath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
    }
    else {
        $regpath = @(
            'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
            'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
        )
    }
    Get-ItemProperty $regpath | .{process{if($_.DisplayName -and $_.UninstallString) { $_ } }} | Select DisplayName, Publisher, InstallDate, DisplayVersion, UninstallString |Sort DisplayName
}


$ApplicationName = "Azure Data Studio"
$result = Get-InstalledApps | where {$_.DisplayName -eq $ApplicationName}
if ($result -ne $null) {
Write-Host $result is installed
Write-Host "Unstalling ...."

$uninstallString = $result.UninstallString
Write-Host $uninstallString
# $isExeOnly = Test-Path -LiteralPath $uninstallString
# if ($isExeOnly) { $uninstallString = "`"$uninstallString`"" } 
Start-Process $uninstallString /quiet -Wait
# Write-Host "$ApplicationName Has been removed"
}
