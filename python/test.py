##To load file into python from python
import os
#execfile('test.py')
#-
#import test.py
#-
#from test.py import *
##To load file into python from python3
#exec(open("./filename").read())
##Alternatively from cmd/bash
#python -i test.py
testint = 2
teststring = "echo stag"
test2string = "powershell "+teststring
#print(test2string)
os.system(test2string)