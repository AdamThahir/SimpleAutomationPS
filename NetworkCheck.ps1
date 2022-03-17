param (
    [string]$ById = $null,
    [string]$ByIp = $null,
    [switch]$SkipPing = $false
)
$PC_LIST = Import-Csv -Path .\NetworkList.csv

$PC_INFORMATION = @{}

foreach ($row in $PC_LIST) {
    if ( (-not ([string]::IsNullOrEmpty($ById))) -and ($ById -ne $row.ID)){
        continue
    }

    if ( (-not ([string]::IsNullOrEmpty($ByIp))) -and ($ByIp -ne $row.IP)){
        continue
    }



    try {
        $PC = @{
            ADDRESS     = $row.IP
            STATE       = "offline"
            HOSTNAME    = $null
            ERROR       = $null
            ID          = $row.ID
            
            LOCALUI_RUNNING = $false
        }
        
        if ($SkipPing -ne $true){
            if (Test-Connection -ComputerName $PC.ADDRESS -Count 1 -Quiet) {
                $PC.STATE = "online"
            }
                            
            if ($hostname = (Resolve-DnsName -Name $PC.ADDRESS -ErrorAction Stop).NameHost){
                $PC.HOSTNAME = $hostname
            }
        } else {
            $PC.STATE = "SKIPPED"
            $PC.HOSTNAME = "SKIPPED"
        }

    } catch {
        $PC.ERROR = $_.Exception.Message
    } finally {
        $PC_INFORMATION[$PC.ID] = $PC
    }
}

foreach ($pc_id in $PC_INFORMATION.Keys){
    [pscustomobject]$PC_INFORMATION.$pc_id
}