#!/bin/bash

while getopts "i:p:" opt; do
  case $opt in
    i) IP4="$OPTARG" ;;
    p) PEER="$OPTARG" ;;
  esac
done

if [ -n "$IP4" ] && [ -n "$PEER" ]; then
    sudo apt update
    echo "sudo apt install wireguard wireguard-tools -y"
    sudo apt install wireguard wireguard-tools -y
    echo ''

    echo "ssh root@$IP4 'cat /wireguard/peer$PEER/peer$PEER.conf' | sudo tee /etc/wireguard/wg$PEER.conf"
    ssh root@$IP4 "cat /wireguard/peer$PEER/peer$PEER.conf" | sudo tee /etc/wireguard/wg$PEER.conf
    echo ''
    echo "sudo chmod 600 /etc/wireguard/wg$PEER.conf"
    sudo chmod 600 /etc/wireguard/wg$PEER.conf
    echo ''

    echo "sudo wg-quick up wg$PEER"
    sudo wg-quick up wg$PEER
    echo ''
    echo 'curl ifconfig.me'
    curl ifconfig.me
    echo ''
    echo ''
    echo "sudo wg-quick down wg$PEER"
    sudo wg-quick down wg$PEER
    echo ''
    echo ''
    echo '-----------------------'
    echo 'Turn On VPN:'
    echo "sudo wg-quick up wg$PEER"
    echo ''
    echo 'Turn Off VPN:'
    echo "sudo wg-quick down wg$PEER"
    echo '-----------------------'
else
    echo "Invalid option"
    echo "IP4 (-i 'YOUR_VPS_IP') => xxx.xxx.xxx.xxx"
    echo "PEER (-p 1) => /wireguard/peer1/peer1.conf, (-p 2) => /wireguard/peer2/peer2.conf"
    echo "Example: sh wireguard-use.sh -i '100.101.110.123' -p 1"
fi

