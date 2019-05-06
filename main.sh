#!/bin/bash


az vm availability-set create --name project1 -g project1 --location southcentralus --platform-fault-domain-count 3
az vmss create --name project1 -g project1 --image UbuntuLTS --location southcentralus --custom-data './project1.txt' --platform-fault-domain-count 3 --instance-count 3 --load-balancer --generate-ssh-keys --public-ip-address-dns-name project1

az disk create --name project1disk -g project1 --os-type Linux
az vm create --name project1-VM1 -g project1  --attach-data-disk project1disk --custom-data './project1.txt' --image UbuntuLTS --size Standard_B1s --generate-ssh-keys --location southcentralus


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

