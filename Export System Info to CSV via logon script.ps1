# Exports Local System Information to CSV
# Run this PowerShelll script at log on to collect PC information to a CSV file on a network share
# Thom McKiernan 28/08/2014

# Collect the info from WMI
$computerSystem = get-wmiobject Win32_ComputerSystem
$computerBIOS = get-wmiobject Win32_BIOS
$computerOS = get-wmiobject Win32_OperatingSystem
$computerCPU = get-wmiobject Win32_Processor
$computerHDD = Get-WmiObject Win32_LogicalDisk -Filter drivetype=3

#Build the CSV file
$csvObject = New-Object PSObject -property @{
    'PCName' = $computerSystem.Name
    'Manufacturer' = $computerSystem.Manufacturer
    'Model' = $computerSystem.Model
    'SerialNumber' = $computerBIOS.SerialNumber
    'RAM' = "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB)
    'HDDSize' = "{0:N2}" -f ($computerHDD.Size/1GB)
    'HDDFree' = "{0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size)
    'CPU' = $computerCPU.Name
    'OS' = $computerOS.caption
    'SP' = $computerOS.ServicePackMajorVersion
    'User' = $computerSystem.UserName
    'BootTime' = $computerOS.ConvertToDateTime($computerOS.LastBootUpTime)
    } 

#Export the fields you want from above in the specified order
$csvObject | Select PCName, Ram, OS | Export-Csv 'system-info.csv' -NoTypeInformation -Append

# Open CSV file for review (leave this line out when deploying)
notepad system-info.csv