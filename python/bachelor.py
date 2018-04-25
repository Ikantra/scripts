#!/usr/bin/env python3
#By JMH
from sys import platform
import os
def Linux():
    print('Linux')
    os.system('lin.sh')
def OSX():
    print('OSX')
    os.system('osx.sh')
def Windows():
    #print('Windows')
    #os.system('Set-ExecutionPolicy Unrestricted') #Change to funct?
    os.system('powershell win.ps1')
if platform == "linux" or platform == "linux2":
    print('Linux platform detected, running bash script')
    Linux()
elif platform == "darwin":
    print('OSX platform detected, running bash script')
    OSX()
elif platform == "linux" or platform == "linux2":
    print('Windows platform detected, running Powershell script')
    Windows()
print('End')
