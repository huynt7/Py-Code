param(
    [Parameter(Mandatory=$true)]
    $ipAddress
)


$Computer = [System.Net.Dns]::GetHostByAddress($IPAddress).Hostname
#Write-Host $Computer

$Locked = "No"
#Gets ths system drive
$SysDrive = $env:SystemDrive
#Gets the OS and OS architecture
$GetOS = Get-WmiObject -class Win32_OperatingSystem -computername $Computer
foreach($sProperty in $GetOS)
{
    $OS = $sProperty.Caption
    $OSArchitecture = $sProperty.OSArchitecture
}
#Gets memory information
$Getmemoryslot = Get-WmiObject Win32_PhysicalMemoryArray -ComputerName $computer
$Getmemory = Get-WMIObject Win32_PhysicalMemory -ComputerName $computer
$Getmemorymeasure = Get-WMIObject Win32_PhysicalMemory -ComputerName $computer | Measure-Object -Property Capacity -Sum
#Sets the memory info
$MemorySlot = $Getmemoryslot.MemoryDevices
$MaxMemory = $($Getmemoryslot.MaxCapacity/1024/1024)
$TotalMemSticks = $Getmemorymeasure.count
$TotalMemSize = $($Getmemorymeasure.sum/1024/1024/1024)
#Get the disk info
$GetDiskInfo = Get-WmiObject Win32_logicaldisk -ComputerName $computer -Filter "DeviceID='$env:SystemDrive'"
#Sets the disk info
$DiskSize = $([math]::Round($GetDiskInfo.Size/1GB))
$FreeSpace = $([math]::Round($GetDiskInfo.FreeSpace/1GB))
$UsedSapce =$([math]::Round($DiskSize-$FreeSpace))
#Gets CPU info 
$GetCPU = Get-wmiobject win32_processor -ComputerName $Computer
#Sets the CPU Name
$CPUName = $GetCPU.Name
$CPUManufacturer = $GetCPU.Manufacturer
$CPUMaxClockSpeed = $GetCPU.MaxClockSpeed

$OSBuildNumber = (Get-WmiObject Win32_OperatingSystem -ComputerName $Computer).BuildNumber 

$ComputerModel = (Get-WmiObject Win32_ComputerSystem -ComputerName $Computer).Model


$LoggedOnUser = (Get-WmiObject win32_computersystem -ComputerName $Computer).Username

$getLockedStart = If (Get-Process logonui -ComputerName $Computer) {$Locked = "Yes"}

$SerialNumber = (Get-WmiObject win32_bios -ComputerName $Computer).SerialNumber

function Show-SystemInfo
{
    Write-Host "_____________________________________________"
    Write-Host ""
    Write-Host "Computer Name: $Computer"
    Write-Host ""
    Write-Host "Serial Number: $SerialNumber"
    Write-Host ""
    Write-Host "Logged In users: $LoggedOnUser "
    Write-Host ""
    Write-Host "Computer is Locked: $Locked "
    Write-Host ""
    Write-Host "Computer Model: $ComputerModel"
    Write-Host ""
    Write-Host "OS: $OS"
    Write-Host ""
    Write-Host "Build Number: $OSBuildNumber"
    Write-Host ""
    Write-Host "OS Architecture: $OSArchitecture"
    Write-Host "_____________________________________________"
    Write-Host ""
    Write-Host "Memory Slots: $MemorySlot"
    Write-Host ""
    Write-Host "Max Memory Supported (GB): $MaxMemory"
    Write-Host ""
    Write-Host "Total Slots used: $TotalMemSticks"
    Write-Host ""
    Write-Host "Total Memory Installed (GB): $TotalMemSize"
    Write-Host "_____________________________________________"
    Write-Host ""
    Write-Host "System Drive: $Sysdrive"
    Write-Host ""
    Write-Host "Disk Size (GB): $DiskSize"
    Write-Host ""
    Write-Host "Free Disk Space (GB): $FreeSpace"
    Write-Host ""
    Write-Host "Used Disk Space (GB): $UsedSapce"
    Write-Host "_____________________________________________"
    Write-Host ""
    Write-Host "CPU: $CPUName"
    Write-Host ""
    Write-Host "CPU Manufacturer: $CPUManufacturer"
    Write-Host ""
    Write-Host "CPU Max Clock Speed: $CPUMaxClockSpeed"
    Write-Host "_____________________________________________"
    Write-Host ""
}
cls
Write-Host "System Info"
Show-SystemInfo
