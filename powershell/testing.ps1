#By JMH
#$GitSource = "http://github.com/Ikantra/scripts"
$inp = $args[0]
$global:test = 1
echo "Top:"$test
function stag($stag){
    echo "inside function"
    echo $stag
    [Math]::Round($stag / 1GB)
    #return
}
function CarryFunction () {
    $global:test = 3
    echo "Inside Function :"$global:test

}
function InputFunction ($help) {
    echo "Inside function: "$help
}
function Win10Function {
    #Get-Disk
    $discnum = -1             #changed to -1 to remove fringe cases where the default variable could be used
    $read2 = Read-Host 'Which disc do you wish to format?'
    #echo "Input is: "$read2
    while( ![int]::TryParse( $read2, [ref]$discnum)) {
        $read2 = Read-Host 'Please enter the disc number you wish to format'
    }
    #echo "magic number is: "$discnum
    #echo "not the right variable is: "$read2
    #Get-Disk $discnum | Clear-disk -RemoveData -Confirm:$false
    #USBSizeFunction($discnum)
    #New-Partition -DiskNumber $discnum -DriveLetter M -Size $OS_Size -IsActive | Format-Volume -FileSystem NTFS -Confirm:$false -NewFileSystemLabel OS –Force
    #New-Partition -DiskNumber $discnum -DriveLetter S -Size $Share_Size | Format-Volume -FileSystem NTFS -Confirm:$false -NewFileSystemLabel Share –Force
    #MultiBoot
    InputFunction($discnum)
}
if($inp -eq 1){
    $test = 4011851776
    stag($test)
    echo "Outside Function"
}
elseif ($inp -eq 2) {
    Win10Function
}
elseif ($inp -eq 3) {
    echo "Start of if: "$global:test
    $global:test = 2
    echo "If before function: "$global:test
    CarryFunction
    echo "If after function: "$global:test
    #$array = @("test1", "test2", "test3")
    #$tiss[0]
}
else {
    echo "else"
}
#echo "test"


#########
#function NoGit(){
#    mkdir Git
#    cd Git
#    git init
#    git pull $GitSource
#}