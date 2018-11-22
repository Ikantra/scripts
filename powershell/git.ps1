#Just a howto and stuff

$myRepo = "http://www.github.com/ikantra/scripts"

function initGit($uName, $eMail){
    git config --global user.name $uName
    git config --global user.email $eMail
}

#Copy from branch
git clone $myRepo

#Overwrite current changes with the one on the master
#git pull --rebase $myRepo #Will overwrite
git pull $myRepo #Sufficient?
