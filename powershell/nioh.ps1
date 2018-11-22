#By JMH
$type = $args[0]
#$inp = $args[1]
#$upper = $args[3]

$SaveLoc = "D:\Brukere\Soveilion\Dokumenter\KoeiTecmo\NIOH"
$BackupLoc = "D:\Brukere\Soveilion\Dokumenter\Spill+\Nioh"
function Save {
    cp $SaveLoc $BackupLoc -Recurse -Force
}

function Restore {
    cp $BackupLoc\Savedata $SaveLoc  -Recurse -Force
}

function Backup {
    $now = [datetime]::now.ToString('yyyy-MM-dd-hh_mm')
    cp $BackupLoc\Savedata $BackupLoc\Backup\Savedata.$now
}

if ($type -eq "restore"){
    echo "--- Restoring Save From Backup ---"
    Restore
}
elseif ($type -eq "save"){
    echo "--- Saving a backup ---"
    Save
}
elseif ($type -eq "backup") {
    echo "--- Adding backup to folder ---"
    Backup
}
else{
    echo "--- Invalid input; save, restore, backup ---"
}