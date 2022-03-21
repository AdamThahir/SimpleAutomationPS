param (
    [Parameter(Mandatory=$true)][string]$NTP
)

$w32StartupType = (Get-Service -Name "Windows Time" | Select-Object -Property StartType).StartType)

$IsRunning = $false

if ($w32StartupType -eq "Automatic") {
    Write-Host "W32TM will be set to start up automatically."
    Set-Service -Name "W32Time" -StartupType Automatic
}

$w32Status = (Get-Service -Name "Windows Time" | Select-Object -Property Status).Status)
if ($w32Status -ne "Running") {
    Write-Host "W32Time will be started..."
    Start-Service -Name "W32Time"
}

Write-Host "`nNET will be set to [" $NTP "]"
w32tm /config /manualpeerlist:$NTP
w32tm /config /update
w32tm /resync /rediscover

Write-Host "Done.."