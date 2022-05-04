Param (
    [parameter(Position=0, Mandatory=$true)]
    [string] $filepath,

    [parameter(Position=1, Mandatory=$true)]
    [string] $key,

    [parameter(Mandatory=$false)]
    [string] $type = "SHA256"
)

$validate = (certutil -hashfile $filepath $type)
$foundKey = ($validate -split "`n")[1]

$isValid = ($false)

if ($foundKey -eq $key) {
    $isValid = $true
}
Write-Output "Validity status of [$filepath]: $isValid"

