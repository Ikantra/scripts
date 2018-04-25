#By JMH
#$type = $args[0]
#$inp = $args[1]
#$upper = $args[3]
$OS = (Get-WmiObject Win32_OperatingSystem).Name
function Win7Function {
    "list disk" | diskpart
    $disc = Read-Host 'Which disk do you want to format?'
    while( ![int]::TryParse( $read, [ref]$disc)) {
        $read = Read-Host 'Please enter the disc number you wish to format'
    }
    $input="select disk $disc
    clean
    convert mbr
    create partition primary
    select part 1
    active
    format fs=ntfs label=Boot"
    #create partition primary size=24795
    #create partition primary size=1908
    $input | diskpart
}
function WinServerFunction {
    #Homebrew.function
    echo "--- nothing here so far ---"
}
function Win10Function {
    #Homebrew.function
    echo "--- nothing here so far ---"
}

if ($OS -Match "Windows 7"){
    echo "--- Operating System Verified ad Windows 7 ---"
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