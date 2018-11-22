#!/usr/bin/env python3
#By JMH

#exec(open("./filename").read())
import sys
from sys import platform
import os
IPolicy=str('Not the right policy')
def Linux():
    print('Linux')
    os.system(".\'bachelor.sh'")
def OSX():
    print('OSX')
    os.system(".\'osx.sh'")
def Windows():
    #print('Windows')
    global IPolicy
    Helpvar = os.popen('powershell Get-ExecutionPolicy').read()
    #print("Current Execution Policy: "+Helpvar)
    IPolicy=Helpvar[:-1]
    #print(IPolicy)
    os.system('powershell Set-ExecutionPolicy "Unrestricted"') #Change to funct?
    #os.system("powershell .\'testing.ps1' full "+sys.argv[1]+" "+sys.argv[2])
    os.system("powershell .\'bachelor.ps1' full "+sys.argv[1]+" "+sys.argv[2])
    #print("Changing Execution Policy back to: "+IPolicy)
    IPolicy="powershell Set-ExecutionPolicy "+IPolicy
    os.system(IPolicy)
if platform == "linux" or platform == "linux2":
    print('Linux platform detected, running bash script')
    Linux()
elif platform == "darwin":
    print('OSX platform detected, running bash script')
    OSX()
elif platform == "win32":
    print('Windows platform detected, running Powershell script')
    Windows()
print('Done')
