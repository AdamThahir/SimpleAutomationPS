param (
    [string]$ip = $null,
    [string]$id = $null,
    [string]$Username = $null,
    [string]$Password = $null
)

Function Find-IP{
    $PC_LIST = Import-Csv -Path .\NetworkList.csv

    foreach ($row in $PC_LIST) {
        if ($row.ID -eq $id) {
            return $row.IP
        }
    }

    return $null
}

$ForceNewCredentials = $false


if ((-not ([string]::IsNullOrEmpty($Username))) -or (-not ([string]::IsNullOrEmpty($Password)))) {
    $ForceNewCredentials = $true
}

if ([string]::IsNullOrEmpty($Username)) {
    $Username = "User"
}

if ([string]::IsNullOrEmpty($Password)) {
    $Password = "DEFAULT00PASSWORD"
}


if (([string]::IsNullOrEmpty($id)) -and ([string]::IsNullOrEmpty($ip))) {
    Write-Host "Either IP or ID should be provided"
    Exit 1
}

if ([string]::IsNullOrEmpty($ip)) {
    # Find IP from list
    $ip = Find-IP
    if (-not [string]::IsNullOrEmpty($ip)) {
        Write-Host "[" $id "] IP Found: " $ip 
    } else {
        Write-Host "[" $id "] IP was not found. Exiting..."
        Exit 1        
    }
} 

$CredentialExists = $false

if (-not $ForceNewCredentials) {
    $AllCredentials = (cmdkey /list)
    
    foreach ($row in $AllCredentials) {
        if ($row.IndexOf($ip) -gt 0) {
            $CredentialExists = $true
            break
        }
    }
}

if (-not $CredentialExists) {
    Write-Host "Saving credientials for IP [" $ip "]. | User [" $Username "] | Password [" $Password "]"  
    cmdkey /generic:$ip /user:$Username /pass:$Password
}

Write-Host "Connecting..."
mstsc /v:"$ip"