[CmdletBinding()]
Param (
    [string]$Network = "192.168.0",
    [int]$IPStart = 100,
    [int]$IPEnd = 120
)

#ForEach ($IP in ($IPStart..$IPEnd))
#{
    #$ipAddress = $Network+'.'+$IP
    #Write-Host $ipAddress
#}

ForEach ($IP in ($IPStart..$IPEnd))
{   
    $Ping = Get-WMIObject Win32_PingStatus -Filter "Address = '$Network.$IP' AND ResolveAddressNames = TRUE" -ErrorAction Stop
    #$Ping | Select StatusCode,ProtocolAddressResolved

    $ListIP = @()
    if ($Ping.ProtocolAddressResolved -eq "")
    {}
    else {
        #$ListIP += [string]$Ping.ProtocolAddressResolved
        Write-Host $Ping.ProtocolAddressResolved
    }
    #Write-Host $ListIP
}