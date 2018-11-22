#Just a howto and stuff

$myRepo = "http://www.github.com/ikantra/scripts"

#

#Copy from branch
git clone $myRepo

#Overwrite current changes with the one on the master
#git pull --rebase $myRepo #Will overwrite
git pull $myRepo #Sufficient?
