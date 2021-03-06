#By JMH
$type = $args[0]
$global:Iso1Name = $args[1]
$global:Iso2Name = $args[2]
$global:MBUPath = $args[3]
$global:Iso1Path = 'C:\Users\ikantra\Downloads\kali-linux-2016.2-amd64.iso'
$global:Iso2Path = 'C:\Users\ikantra\Downloads\ubuntu-18.04-live-server-amd64.iso'
$global:DMBUPath = 'C:\Users\ikantra\Downloads\MultiBootUSB'
$global:OS_Size
$global:Share_Size
$global:discnum = -1             #changed to -1 to remove fringe cases where the default variable could be used
$DriveLetter1 = "M:"
$DriveLetter2 = "S:"
$DriveLetter3 = "N:"
$MBName = 'OS'
$ShareName = 'Share'
$FixName = 'Fix'
$OS = (Get-WmiObject Win32_OperatingSystem).Name
function FixFunction(){
    Get-Disk
    $tofix = Read-Host 'Which disc has a problem?'
    while( ![int]::TryParse( $tofix, [ref]$global:discnum)) {
        $tofix = Read-Host 'Please enter the disc number you wish to format'
    }
    New-Partition -DiskNumber $global:discnum -DriveLetter $DriveLetter3[0] -Size 1GB | Format-Volume -FileSystem NTFS -Confirm:$false -NewFileSystemLabel $FixName
}
function MBUDependencies(){
    pip3 install pyqt5
    pip3 install wmi
    pip3 install pywin32
    pip3 install psutil
}

function IsoPath(){
    $global:Iso1Path = (pwd).Path + '\' + $global:Iso1Name
    $global:Iso2Path = (pwd).Path + '\' + $global:Iso2Name
}
function USBSizeFunction($disc){
    $help = get-disk $disc
    $size = [Math]::Round($help.size / 1GB)
    if ($size -lt 4) {
        echo 'Size of volume too small, select other volume'
    }
    elseif ($size -eq 4) {
        $global:OS_Size = 2GB
        $global:Share_Size = 1GB
    }
    elseif ($size -le 8) {
        $global:OS_Size = 6GB
        $global:Share_Size = 1GB
    }
    elseif ($size -le 16) {
        $global:OS_Size = 10GB
        $global:Share_Size = 3GB
    }
    elseif ($size -le 32) {
        $global:OS_Size = 22GB
        $global:Share_Size = 4GB
    }
    elseif ($size -le 64) {
        $global:OS_Size = 32GB
        $global:Share_Size = 8GB
    }
    elseif ($size -le 128) {
        $global:OS_Size = 64GB
        $global:Share_Size = 32GB
    }
    else {
        #something something size of ISO
        $global:OS_Size = 64GB
        $global:Share_Size = 32GB
        echo 'such size, much wow'
    }
}
function MultiBoot () {
    if ($type -eq 'full') {
        MBUDependencies
    }
    IsoPath
    if ($global:MBUPath -eq $null) {
        echo '--- Path to MultiBootUSB not added, will attempt to see if it can be run from current path ---'
        cd (pwd).Path + '\MultiBootUSB'
        #cd $global:DMBUPath    
    }
    python multibootusb -c -i $global:Iso1Path,$global:Iso2Path -t $DriveLetter1 -y
}
function Win7Function {
    echo '--- Multiple partitioning is only supported Server 2012 R3 and newer --- '
    $read1 = Read-Host 'Do you want just multiple OS capability? y/n'
    if ($read1 -match 'y') {
        Win7FunctionObsolete
    }
}
function Win7FunctionObsolete {
    'list disk' | diskpart
    $disc = Read-Host 'Which disk do you want to format?'
    while( ![int]::TryParse( $read, [ref]$disc)) {
        $read = Read-Host 'Could not validate input as a integer, please input the disc number you wish to format'
    }
    $input='select disk $disc
    clean
    convert mbr
    create partition primary
    select part 1
    active
    format fs=ntfs label=Boot'
    $input | diskpart
    MultiBoot
}
function WinServerFunction {
    echo '--- WinServ 2012 R3 and newer should run fine, problems might occur ---'
    Win10Function
}
function Win10Function {
    Get-Disk
    $read2 = Read-Host 'Which disc do you wish to format?'
    while( ![int]::TryParse( $read2, [ref]$global:discnum)) {
        $read2 = Read-Host 'Could not validate input as a integer, please input the disc number you wish to format'
    }
    Get-Disk $global:discnum | Clear-Disk -RemoveData -Confirm:$false
    USBSizeFunction($global:discnum)
    New-Partition -DiskNumber $global:discnum -DriveLetter $DriveLetter1[0] -Size $global:OS_Size -IsActive | Format-Volume -FileSystem NTFS -Confirm:$false -NewFileSystemLabel $MBName
    New-Partition -DiskNumber $global:discnum -DriveLetter $DriveLetter2[0] -Size $global:Share_Size | Format-Volume -FileSystem NTFS -Confirm:$false -NewFileSystemLabel $ShareName
    MultiBoot
}

if ($type -eq 'fix') {
    echo '--- Running fix for (Format-Volume) Error ---'
    FixFunction
}
elseif ($type -eq 'add') {
    echo '--- Running function to add additional OS ---'
    MultiBoot
}
elseif ($OS -Match 'Windows 7'){
    echo '--- Operating System Verified as Windows 7 ---'
    Win7Function
}
elseif ($OS -Match 'Windows Server 201?'){
    echo '--- Operating System Verified as Server 201X ---'
    WinServerFunction
}
elseif ($OS -Match 'Windows 10') {
    echo '--- Operating System Verified as Windows 10 ---'
    Win10Function
}
else{
    echo '--- Could not validate Operating System ---'
    $read4 = Read-Host 'Do you wish to force Win7 Diskpart(1) or Win 10 Get-Disk(2) function?'
    if ($read4 -eq 1) {
        Win7Function
    }
    elseif ($read -eq 2) {
        Win10Function
    }
}