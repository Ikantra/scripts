#By JMH
$type = $args[0]
#$inp = $args[1]
#$upper = $args[3]

function Save {
    cp C:\Users\Soveilion\Documents\KoeiTecmo\NIOH\Savedata D:\Brukere\Soveilion\Dokumenter\Spill+\Nioh -Recurse -Force
}

function Restore {
    cp D:\Brukere\Soveilion\Dokumenter\Spill+\Nioh\Savedata C:\Users\Soveilion\Documents\KoeiTecmo\NIOH  -Recurse -Force
}

function Backup {
    $now = [datetime]::now.ToString('yyyy-MM-dd-hh_mm')
    cp D:\Brukere\Soveilion\Dokumenter\Spill+\Nioh\Savedata D:\Brukere\Soveilion\Dokumenter\Spill+\Nioh\Backup\Savedata.$now
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