#!/bin/bash

command=$1
disk=$2
group=$3
VM=$4
finalName=$5


case $command in
    image)
        az vm disk detach --name $disk
        az vm stop -g $group --name $VM
        az vm deallocate --name $VM -g $group
        az vm generalize -g $group --name $VM
        az image create -g $group --name $finalName --source $VM
        ;;
    snapshot)
        az vm disk detach --name $disk -g $group --vm-name $VM
        az snapshot create --source $disk --name $finalName -g $group
        ;;
    *)
        echo invalid argument
        exit 1
esac