#Just a howto and stuff

$myRepo = "http://www.github.com/ikantra/scripts"

function gitInit {
    git remote add origin $myRepo
}
function initSetup($uName, $eMail){
    git config --global user.name $uName
    git config --global user.email $eMail
}

function gitCopy {
    #Copy from branch
    git clone $myRepo
}

function gitPull {
    #Overwrite current changes with the one on the master
    #git pull --rebase $myRepo #Will overwrite
    git pull $myRepo #Sufficient?
}

echo "please navigate to your git repository"