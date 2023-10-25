Function Get-SystemInfo{
    <#
    .SYNOPSIS
    Gether system inforamtion
    .DESCRIPTION
    Gather information such as the Computer Name, OS, Memory Information, Disk Information and CPU Information on a local or remote system.
    .PARAMETER Computer
    The local or remote system to gather information from
    .NOTES
    Email: contact@mosaicMK.com
    Version: 3.2.3
    Copyright (C) MosaicMK Software LLC - All Rights Reserved
    Unauthorized copying of this application via any medium is strictly prohibited Proprietary and confidential
    Written by MosaicMK Software LLC (contact@mosaicmk.com)

    By using this software you agree to the following:
    Agreement Permission is hereby granted, free of charge, to any person or organization obtaining a copy of this software and associated documentation files (the 'Software'),
    to deal in the Software and the rights to use and distribute the software so long a no licensing and or documentation files are remove, revised or modified
    the Software is furnished to do so, subject to the following conditions:

    THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
    IN THE SOFTWARE.
    Contact: Contact@MosaicMK.com
    .LINK
    https://www.mosaicmk.com/2019/05/get-system-info-module.html
    #>

    param([string]$ComputerName)
    $Computer = $ComputerName
    #Gets the OS info
    $GetOS = get-ciminstance -class Win32_OperatingSystem -computername $Computer
    $OS = $GetOS.Caption
    $OSArchitecture = $GetOS.OSArchitecture
    $OSBuildNumber = $GetOS.BuildNumber
    #Gets memory information
    $Getmemoryslot = get-ciminstance Win32_PhysicalMemoryArray -ComputerName $computer
    $Getmemory = get-ciminstance Win32_PhysicalMemory -ComputerName $computer
    $Getmemorymeasure = get-ciminstance Win32_PhysicalMemory -ComputerName $computer | Measure-Object -Property Capacity -Sum
    $MemorySlot = $Getmemoryslot.MemoryDevices
    $MaxMemory = $($Getmemoryslot.MaxCapacity/1024/1024)
    $TotalMemSticks = $Getmemorymeasure.count
    $TotalMemSize = $($Getmemorymeasure.sum/1024/1024/1024)
    #Get the disk info
    $GetDiskInfo = get-ciminstance Win32_logicaldisk -ComputerName $computer -Filter "DeviceID='C:'"
    $DiskSize = $([math]::Round($GetDiskInfo.Size/1GB))
    $FreeSpace = $([math]::Round($GetDiskInfo.FreeSpace/1GB))
    $UsedSapce =$([math]::Round($DiskSize-$FreeSpace))
    #Gets CPU info
    $GetCPU = get-ciminstance win32_processor -ComputerName $Computer
    $CPUName = $GetCPU.Name
    $CPUManufacturer = $GetCPU.Manufacturer
    $CPUMaxClockSpeed = $GetCPU.MaxClockSpeed
    #Computer Model
    $ComputerModel = (get-ciminstance Win32_ComputerSystem -ComputerName $Computer).Model
    #account status
    $LoggedOnUser = (get-ciminstance win32_computersystem -ComputerName $Computer).Username
    if ($Computer){$getLockedStart = Get-Process logonui -ComputerName $Computer -ErrorAction SilentlyContinue} else {
        $getLockedStart = Get-Process logonui -ErrorAction SilentlyContinue
    }
    If ($getLockedStart) {$Locked = "Yes"} Else {$Locked = "No"}
    #Serial Number
    $SerialNumber = (get-ciminstance win32_bios -ComputerName $Computer).SerialNumber
    #get IP address
    $IPAddress = (get-ciminstance win32_NetworkadapterConfiguration -ComputerName $Computer | Where-Object IPAddress -ne $null).IPAddress
    #Gets BIOS info
    $BIOSName = (get-ciminstance win32_bios -ComputerName $Computer ).Name
    $BIOSManufacturer = (get-ciminstance win32_bios -ComputerName $Computer).Manufacturer
    $BIOSVersion = (get-ciminstance win32_bios -ComputerName $Computer).Version
    #Gets Motherboard info
    $MotherBoardName = (get-ciminstance Win32_BaseBoard -ComputerName $Computer).Name
    $MotherBoardManufacturet = (get-ciminstance Win32_BaseBoard -ComputerName $Computer).Manufacturer
    $MotherBoardModel = (get-ciminstance Win32_BaseBoard -ComputerName $Computer).Model
    $MotherBoardProduct = (get-ciminstance Win32_BaseBoard -ComputerName $Computer).Product
    $MotherBoardSerial = (get-ciminstance Win32_BaseBoard -ComputerName $Computer).SerialNumber

    $ComputerInfo = New-Object -TypeName psobject
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name OperatingSystem -Value $os
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name OSArchitecture -Value $OSArchitecture
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name OSBuild -Value $OSBuildNumber
    if ($Computer){$Comp = $Computer} else {$Comp = $ENV:COMPUTERNAME}
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name ComputerName -Value $Comp
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name ComputerModel -Value $ComputerModel
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name SerialNumber -Value $SerialNumber
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name IPAddress -Value $IPAddress
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name LoggedInUsers -Value $LoggedOnUser
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name ComputerIsLocked -Value $Locked
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name MemorySlots -Value $MemorySlot
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name MaxMemory -Value "$MaxMemory GB"
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name MemorySlotsUsed -Value $TotalMemSticks
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name MemoryInstalled -Value "$TotalMemSize GB"
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name SystemDrive -Value $ENV:SystemDrive
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name DiskSize -Value "$DiskSize GB"
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name FreeSpace -Value "$FreeSpace GB"
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name UsedSpace -Value "$UsedSapce GB"
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name CPU -Value $CPUName
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name CPUManufacturer -Value $CPUManufacturer
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name CPUMaxClockSpeed -Value $CPUMaxClockSpeed
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name MotherBoard -Value $MotherBoardName
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name MotherBoardManufacturer -Value $MotherBoardManufacturet
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name MotherBoardModel -Value $MotherBoardModel
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name MotherBoardSerialNumber -Value $MotherBoardSerial
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name MotherBoardProduct -Value $MotherBoardProduct
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name BIOSName -Value $BIOSName
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name BIOSManufacturer -Value $BIOSManufacturer
    $ComputerInfo | Add-Member -MemberType NoteProperty -Name BIOSVersion -Value $BIOSVersion
    $ComputerInfo
}

Function Get-SystemSoftware{
    <#
    .SYNOPSIS
    Gather software installed on a local or remote device
    .DESCRIPTION
    Gather Software and information about the software installed on a local or remote device using the registry or WMI
    .PARAMETER ComputerName
    Computer to gather software on
    .PARAMETER QueryType
    Specify how you want to gather the information
    WMI - Gather installed software installed using an msi
    Registry - Pulls the software info from the computer registry, Requires WinRM to be running on the target computer
    .NOTES
    Contact: contact@mosaicmk.com
    Version: 4.4.4
    Copyright (C) MosaicMK Software LLC - All Rights Reserved
    Unauthorized copying of this application via any medium is strictly prohibited Proprietary and confidential
    Written by MosaicMK Software LLC (contact@mosaicmk.com)

    By using this software you agree to the following:
    Agreement Permission is hereby granted, free of charge, to any person or organization obtaining a copy of this software and associated documentation files (the 'Software'),
    to deal in the Software and the rights to use and distribute the software so long a no licensing and or documentation files are remove, revised or modified
    the Software is furnished to do so, subject to the following conditions:

    THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
    IN THE SOFTWARE.
    Contact: Contact@MosaicMK.com
    .LINK
    https://www.mosaicmk.com/2019/05/get-system-info-module.html
    #>
    param(
        [string]$ComputerName = $env:computername,
        [ValidateSet('Registry','WMI')]
        [string]$QueryType
    )

    If (!($QueryType)){$QueryType='WMI'}
    $ComputerSoftware = @()
    IF ($QueryType -eq "Registry"){
        IF ($ComputerName -ne $env:computername){[array]$uniReg = Invoke-Command -ComputerName $ComputerName {Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" | Get-Item | Get-ItemProperty}}else{
            [array]$uniReg = Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" | Get-Item | Get-ItemProperty
        }
        foreach ($item in $uniReg){
            if ($item.DisplayName){
                $Name = $item.DisplayName
                $Version = $item.DisplayVersion
                $Publisher = $item.Publisher
                $InstallSource = $item.InstallSource
                $InstallDate = $item.InstallDate
                $UninstallString = $item.UninstallString
                $RegPath = $item.pspath -replace "Microsoft\.PowerShell\.Core\\Registry\:\:",""
                $ComputerSoftware += [pscustomobject]@{
                    Name = $Name
                    Version = $Version
                    Publisher = $Publisher
                    InstallDate = $InstallDate
                    InstallSource = $InstallSource
                    UninstallString = $UninstallString
                    RegPath = $RegPath
                }
            }
        }
        IF ($ComputerName -ne $env:computername){[array]$uniReg = Invoke-Command -ComputerName $ComputerName {Get-ChildItem -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | Get-Item | Get-ItemProperty}}Else{
            [array]$uniReg = Get-ChildItem -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | Get-Item | Get-ItemProperty
        }
        foreach ($item in $uniReg){
            if ($item.DisplayName){
                $Name = $item.DisplayName
                $Version = $item.DisplayVersion
                $Publisher = $item.Publisher
                $InstallSource = $item.InstallSource
                $InstallDate = $item.InstallDate
                $UninstallString = $item.UninstallString
                $RegPath = $item.pspath -replace "Microsoft\.PowerShell\.Core\\Registry\:\:",""
                $ComputerSoftware += [pscustomobject]@{
                    Name = $Name
                    Version = $Version
                    Publisher = $Publisher
                    InstallDate = $InstallDate
                    InstallSource = $InstallSource
                    UninstallString = $UninstallString
                    RegPath = $RegPath
                }
            }
        }
        $ComputerSoftware
    }
    IF ($QueryType -eq "WMI"){
        IF ($ComputerName -ne $env:computername){$SFInfo = get-ciminstance Win32_Product -ComputerName $ComputerName}else{
            $SFInfo = get-ciminstance Win32_Product
        }
        foreach ($item in $SFInfo){
            $Name = $item.Name
            $ID = $item.IdentifyingNumber
            $Publisher = $item.Vendor
            $Version = $item.Version
            $InstallDate = $item.InstallDate
            $InstallSource = $item.InstallSource
            $ComputerSoftware += [pscustomobject]@{
                Name = $Name
                Version = $Version
                ID = $ID
                Publisher = $Publisher
                InstallDate = $InstallDate
                InstallSource = $InstallSource
            }
        }
        $ComputerSoftware
    }
}

function Get-InstalledDotNet {
    <#
    .SYNOPSIS
    Display version of .net installed on a system
    .DESCRIPTION
    Query the registry on a local or remote system to display the version of .net installed
    .PARAMETER ComputerName
    The name of the computer to run the query on
    .NOTES
    Contact: contact@mosaicmk.com
    Version: 1.2.0
    Copyright (C) MosaicMK Software LLC - All Rights Reserved
    Unauthorized copying of this application via any medium is strictly prohibited Proprietary and confidential
    Written by MosaicMK Software LLC (contact@mosaicmk.com)

    By using this software you agree to the following:
    Agreement Permission is hereby granted, free of charge, to any person or organization obtaining a copy of this software and associated documentation files (the 'Software'),
    to deal in the Software and the rights to use and distribute the software so long a no licensing and or documentation files are remove, revised or modified
    the Software is furnished to do so, subject to the following conditions:

    THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
    IN THE SOFTWARE.
    .LINK
    https://www.mosaicmk.com/2019/05/get-system-info-module.html
    #>

    PARAM([String]$ComputerName = $ENV:COMPUTERNAME)
    IF ($ComputerName -ne $ENV:COMPUTERNAME){[array]$netTypes = Invoke-Command -ComputerName $ComputerName {Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\" -Recurse | Get-Item | Get-ItemProperty}}else {
    $netTypes = Get-ChildItem -Path "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\" -Recurse | Get-Item | Get-ItemProperty
    }

    Foreach ($item in $netTypes){
        IF ($item.InstallPath){
            $Type = $item.PSChildName
            $Version = $item.Version
            $Release = $item.Release
            $InstallPath = $item.InstallPath
            $DotNet = New-Object -TypeName psobject
            $DotNet | Add-Member -MemberType NoteProperty -Name Type -Value $Type
            $DotNet | Add-Member -MemberType NoteProperty -Name Version -Value $Version
            $DotNet | Add-Member -MemberType NoteProperty -Name Release -Value $Release
            $DotNet | Add-Member -MemberType NoteProperty -Name InstallPath -Value $InstallPath
            $DotNet
        }
    }
}

Function Get-InstalledUpdates{
    <#
    .SYNOPSIS
    Display Updates that have been installed on a Local or Remote Device
    .DESCRIPTION
    Display Updates that have been installed on a Local or Remote Device
    .PARAMETER ComputerName
    The name of the computer to run the query on
    .NOTES
    Contact: contact@mosaicmk.com
    Version: 1.0.1
    Copyright (C) MosaicMK Software LLC - All Rights Reserved
    Unauthorized copying of this application via any medium is strictly prohibited Proprietary and confidential
    Written by MosaicMK Software LLC (contact@mosaicmk.com)

    By using this software you agree to the following:
    Agreement Permission is hereby granted, free of charge, to any person or organization obtaining a copy of this software and associated documentation files (the 'Software'),
    to deal in the Software and the rights to use and distribute the software so long a no licensing and or documentation files are remove, revised or modified
    the Software is furnished to do so, subject to the following conditions:

    THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
    IN THE SOFTWARE.
    .LINK
    https://www.mosaicmk.com/2019/05/get-system-info-module.html
    #>
    PARAM(
        [String]$ComputerName = $ENV:COMPUTERNAME
    )
    IF ($ComputerName -ne $ENV:COMPUTERNAME){
        $Updates = Invoke-Command -ComputerName $ComputerName {
            $Session = New-Object -ComObject "Microsoft.Update.Session"
            $Searcher = $Session.CreateUpdateSearcher()
            $historyCount = $Searcher.GetTotalHistoryCount()
            $SearchResults = $Searcher.QueryHistory(0, $historyCount)
            Return $SearchResults
        }
    } else {
        $Session = New-Object -ComObject "Microsoft.Update.Session"
        $Searcher = $Session.CreateUpdateSearcher()
        $historyCount = $Searcher.GetTotalHistoryCount()
        $Updates = $Searcher.QueryHistory(0, $historyCount)
    }

    foreach ($Update in $Updates){
        [array]$WSU += [pscustomobject]@{
            Name = $($Update.title)
            Date = $($Update.Date)
            Description = $($Update.Description)
            URL = $($Update.SupportUrl)
        }
    }
    $WSU
}