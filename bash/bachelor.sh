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

function FormatPart(){
    dd if=/dev/zero of=/dev/sdX bs=512 count=1
    fdisk /dev/sdX     #(where X is the drive we want to partition)
        > n             
        > p             
        > 24            #(+24GB?????????)
        > a             
        > 1             #(toggles boot flag)
        > t             
        > c             #(filesystem type maybe needs change?)
    #From what i can gather this is the creation of the secibd oartutuib
        > n             
        > p             
        > 2             #(defaults)
        > t             #(specify 2nd partition)
        > c             #(same as above)
        > p             #(prints current configuration)
        > w             #(write the new table and quit)
    mkfs.ntfs /dev/sdX1     #(swapped for ntfs)
    mkfs.ntfs /dev/sdX2     #(same as above)
}

if ($TYPE = 1){
    echo "test"
}