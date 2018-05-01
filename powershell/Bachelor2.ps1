#By JMH
$type = $args[0]
$Iso1Name = $args[1]
$Iso2Name = $args[2]
$OS_Size
$Share_Size
$OS = (Get-WmiObject Win32_OperatingSystem).Name
$GitSource = "http://github.com/Ikantra/scripts"
function MBUDependancies(){
    pip3 install pyqt5
    pip3 install wmi
    pip3 install pywin32
    pip3 install psutil
}
function NoGit(){
    mkdir Git
    cd Git
    git init
    git pull $GitSource
}
function IsoPath(){
    $Iso1Path = (Get-Item -Path ".\" -Verbose).FullName + $Iso1Name
    $Iso2Path = (Get-Item -Path ".\" -Verbose).FullName + $Iso1Name
}

function USBSizeFunction($disc){
    $help = get-disk $disk
    $size = [Math]::Round($help.size / 1GB)
    if ($size -lt 4) {
        echo "Size of volume too small, select other volume"
    }
    elseif ($size -eq 4) {
        $OS_Size = 2
        $Share_Size = 1
    }
    elseif ($size -eq 8) {
        $OS_Size = 6
        $Share_Size = 1
    }
    elseif ($size -eq 16) {
        $OS_Size = 10
        $Share_Size = 3
    }
    elseif ($size -eq 32) {
        $OS_Size = 22
        $Share_Size = 4
    }
    elseif ($size -eq 64) {
        $OS_Size = 32
        $Share_Size = 8
    }
    elseif ($size -eq 128) {
        $OS_Size = 64
        $Share_Size = 32
    }
    else {
        #something something size of ISO
        echo "such size, much wow"
    }
}
function Win7Function {
    echo "--- Multiple  only supports Server 2012 R3 and newer --- "
}
function WinServerFunction {
    echo "--- WinServ 2012 R3 and newer should run fine, problems might occur ---"
    Win10Function
}
function Win10Function {
    Get-Disk
    $discnum = -1             #changed to -1 to remove fringe cases where the default variable could be used
    $read = Read-Host 'Which disc do you wish to format?'
    while( ![int]::TryParse( $read, [ref]$discnum)) {
        $read = Read-Host 'Please enter the disc number you wish to format'
    }
    Get-Disk $discnum | Clear-disk -RemoveData -Confirm:$false
    USBSizeFunction($discnum)
    New-Partition -DiskNumber $discnum -DriveLetter M -Size $OS_Size -IsActive | Format-Volume -FileSystem NTFS -Confirm:$false -NewFileSystemLabel OS –Force
    New-Partition -DiskNumber $discnum -DriveLetter S -Size $Share_Size | Format-Volume -FileSystem NTFS -Confirm:$false -NewFileSystemLabel Share –Force
    python multibootusb -c -i Iso1Path,Iso2Path -t M:
}

if ($type -eq test) {
    Get-Disk 1 | Clear-disk -RemoveData -Confirm:$false
    New-Partition -DiskNumber 1 -DriveLetter G -UseMaximumSize -IsActive | Format-Volume -FileSystem NTFS -Confirm:$false -NewFileSystemLabel OS –Force
}
elseif ($type -eq full) {
    MBUDependancies()
    NoGit()
    IsoPath()
}

if ($OS -Match "Windows 7"){
    echo "--- Operating System Verified as Windows 7 ---"
    Win7Function
}
elseif ($OS -Match "Windows Server 201?"){
    echo "--- Operating System Verified as Server 201X ---"
    WinServerFunction
}
elseif ($type -Match "Windows 10") {
    echo "--- Operating System Verified as Windows 10 ---"
    Win10Function
}
else{
    echo "--- Could not validate OS, manual input/something ---"
}