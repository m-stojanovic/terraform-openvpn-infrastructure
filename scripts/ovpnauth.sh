#!/bin/sh

conf="/etc/openvpn/ovpnauth.passwd"

md5(){
	echo "$1" > /tmp/$$.md5calc
    sum="`md5sum /tmp/$$.md5calc | awk '{print $1}'`"
    rm /tmp/$$.md5calc
    echo "$sum"
}

if [ "$1" = "md5" ]
then
    echo `md5 $2`
	exit 1
fi

userpass=`cat $1`
username=`echo $userpass | awk '{print $1}'`
password=`echo $userpass | awk '{print $2}'`

# computing password md5
password=`md5 $password`
userpass=`cat $conf | grep $username= | awk -F= '{print $2}'`

if [ "$password" = "$userpass" ]
then
	echo "OpenVPN authentication successfull: $username"
	exit 0
fi

echo "OpenVPN authentication failed"
echo `cat $1`
exit 1