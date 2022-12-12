#!/bin/bash
readarray -t lines < $1
username=${lines[0]}
password=${lines[1]}

userpass=`cat ovpnauth.passwd | grep $username= | awk -F= '{print $2}'`

if [ "$password" = "$userpass" ]
then
        log "OpenVPN authentication successfull: $username"
        logenv
        exit 0
fi
echo "Authentication failed!"
exit 1