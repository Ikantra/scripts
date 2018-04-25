#!/usr/bin/env python3
#By JMH
from sys import platform
import os
IPolicy = "Not the right policy"
def Linux():
    print('Linux')
    os.system('lin.sh')
def OSX():
    print('OSX')
    os.system('osx.sh')
def Windows():
    #print('Windows')
    helpvar = os.popen('powershell Get-ExecutionPolicy')
    IPolicy=helpvar[:-1]
    print(IPolicy)
    #os.system('Set-ExecutionPolicy Unrestricted') #Change to funct?
    os.system('powershell bachelor2.ps1')
if platform == "linux" or platform == "linux2":
    print('Linux platform detected, running bash script')
    Linux()
elif platform == "darwin":
    print('OSX platform detected, running bash script')
    OSX()
elif platform == "linux" or platform == "linux2":
    print('Windows platform detected, running Powershell script')
    Windows()
#os.system('powershell '+IPolicy)
print('End')
