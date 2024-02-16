#!/bin/bash

# this script adds or deletes port forwarding, it's still raw and will be updated
# note that the script is case sensitive for now, when asking for your input 
read -p "Would you like to add or remove " op
read -p "Enter zone " zone
read -p "Enter first port " p1
read -p "Enter second port " p2
read -p "Enter protocol " prt
read -p "Enter address " addr

sudo firewall-cmd --zone=$zone --permanent --$op-forward-port=port=$p1:proto=$prt:toport=$p2:toaddr=$addr
sudo firewall-cmd --reload
sudo firewall-cmd --list-all --zone=$zone
