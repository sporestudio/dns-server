#!/usr/bin/env bash

## This script updates the repositories and
## provides the server with its config files

# Exit is some command fail
set -euo pipefail

machine_name=$1

# General provison
function general_provision() {
    echo -e "Updating and upgrading the repositories in $machine_name..."
    apt-get update -y && apt-get upgrade -y
    echo -e "Instaling bind9 and utils in $machine_name..."
    apt-get install -y bind9 bind9utils bind9-doc
}


function common_setup() {
    echo -e "Provisioning the dns server, master and slaves..."
    cp -v /vagrant/files/named /etc/default/
    cp -v /vagrant/files/named.conf.options /etc/bind/
}


function tierra_setup() {
    echo -e "Provisoning $machine_name files..."
    cp -v /vagrant/files/tierra/named.conf.local /etc/bind/
    cp -v /vagrant/files/sistema.test.dns /var/lib/bind/
    cp -v /vagrant/files/sistema.test.rev /var/lib/bind/ 
    chown bind:bind /var/lib/bind/*
    systemctl restart named
}


function venus_setup() {
    echo -e "Provisioning $machine_name files..."
    cp -v /vagrant/files/venus/named.conf.local /etc/bind/ 
    systemctl restart named
}


function main() {
    if [ "$machine_name" == "tierra" ]; then
        general_provision
        common_setup
        tierra_setup
    elif [ "$machine_name" == "venus" ]; then
        general_provision
        common_setup
        venus_setup
    else
        echo -e "Machine not recognized"
        exit 1
    fi
}

main