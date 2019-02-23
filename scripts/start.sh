#!/bin/bash

ANYCAST=$1

apt-get update >/dev/null 2>&1
apt-get install -y bird golang >/dev/null 2>&1
bash ./create_bird_conf.sh "$ANYCAST"
go build web.go ; nohup ./web & 
exit
