$iprange = 100..200
Foreach ($ip in $iprange)
{
    $computer = "192.168.0.$ip"
    $status = Test-Connection $computer -count 1 -Quiet
    if ($status)
    {
        $Computer = [System.Net.Dns]::GetHostByAddress($IPAddress).Hostname
    }
    Write-Host $computer
}