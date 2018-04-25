$inp = $args[0]
function stag($stag){
    echo "inside function"
    echo $stag
    [Math]::Round($stag / 1GB)
    #return
}

if($inp -eq 1){
    $test = 4011851776
    stag($test)
    echo "Outside Function"
}
else {
    echo "else"
}
echo "test"