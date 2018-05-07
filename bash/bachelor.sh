#!/bin/bash
#By JMH
TYPE = $1
ISO1NAME = $2
ISO2NAME = $3


function MBUDependencies(){
    pip3 install pyqt5
    pip3 install wmi
    pip3 install pywin32
    pip3 install psutil
}

function USBSizeFunction(){

}

function ISOPath(){

}

if (TYPE = 1){
    echo "test"
}