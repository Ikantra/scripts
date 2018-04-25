$inp = $args[1]
$type = $args[0]
$upper = $args[3]
$def_upper=16
$if
$count
$count1
$count2
$def_count=1
$shift_count=55
$Decrypt
$Encrypt

function Ceasar {
    if($inp -eq "lat"){
        $inp="Lfzcpbse!opu!gpvoe/!Qsftt!G2!up!dpoujovf"
    }
    for($i = 0; $i -lt $inp.length;$i++){
        $j=$inp[$i]
        $k=[byte][char]$j
        $k--
        $Decrypt+=[char]$k
        $k++
        $k++
        $Encrypt+=[char]$k
    }
    echo "      Input"
    echo $inp
    echo "      Decrypted Message"
    echo $Decrypt
    echo "      Reencrypted Message"
    echo $Encrypt
    echo ""
}

function BetterEncryptFunction {
    #echo $inp
    if ($upper -le 0){
        $upper=$def_upper
    }
    for($i = 0; $i -lt $inp.length;$i++){
        $j=$inp[-($i+1)]
        $k=[byte][char]$j
        $k=$k+($count*$if)
        if($k -eq 96){
            $k=127
        }
        $Encrypt+=[char]$k
        $count=$count+$count
        if ($count -eq $upper){
            $count=0
        }
    }
    $Encrypt+=[char]($count+$shift_count)
    echo $Encrypt
    echo ""
}

function BetterDecryptFunction {
    #echo $inp
    if ($upper -le 0){
        $upper=$def_upper
    }
    $count=([int]($inp[-1])-$shift_count)
    for($i = 1; $i -lt $inp.length;$i++){
        $j=$inp[-($i+1)]
        $k=[int][char]$j
        if($k -eq 8962){
            $k = 96
        }
        $k=$k+($count*$if)
        $k--
        $Decrypt+=[char]$k
        [char]$k
        $count--
        if ($count -eq 0){
            $count=$upper
        }
        $count
    }
    echo $Decrypt
    echo ""
}

if ($type -eq 1){
    echo "--- Encrypt ---"
    $if=-1
    BetterEncryptFunction
}
elseif ($type -eq 2){
    echo "--- Decrypt ---"
    $if=1
    BetterDecryptFunction
}
elseif ($type -eq 3){
    echo "--- Ceasar Cipher/Substitution Cipher ---"
    Ceasar
}
else{
    echo "--- Invalid input; 1=Enc, 2=Dec, 3=Ceasar ---"
}