#!/bin/bash
USERNAMES="$@"

echo $USERNAMES | tr " " "\n" > ovpn_mail_tansfer.txt

# Check is directory available
cd /home/ec2-user/
if [ -d /home/ec2-user/ovpn-files ]; then
        echo "Directory ovpn-files exists. Ready to move files."
else
   mkdir /home/ec2-user/ovpn-files
fi

# Loop over the mailing list and apply changes to files in order to successfully send a mail without json parsing errors
while IFS="" read -r p || [ -n "$p" ]
do
c=${p%@*}
echo "User in progress: $c"
if [ -z "$c" ]
then
      echo "No new users for mail transfer action. Exiting.."
      exit 0
else
      echo "Continuing with mail transfer."
fi
PW=$(cat $c.ovpn | grep Your | cut -d' ' -f4)
sed -i 's/$/\\~n/g' $c.ovpn
OVPN_FILE=$(tr '\n' ' ' < $c.ovpn)
echo '{"Data":"From:'$(echo ${p})'\nTo:'$(echo ${p})'\nSubject:OpenVPN-Credentials\nMIME-Version:1.0\nContent-type:Multipart/Mixed;boundary=\"NextPart\"\n\n--NextPart\nContent-Type:text/plain\n\nYour username is: '$(echo ${c})' and Your password is '$(echo ${PW})'. Password is also located within your '$(echo ${c}.ovpn)' file.\n\n--NextPart\nContent-Type:text/csv;\nContent-Disposition:attachment;filename=\"'$(echo ${c})'.ovpn\"\n\n'$(echo ${OVPN_FILE})'\n\n--NextPart--"}' > message.json
sed -i 's/~n /n/g' message.json
sed -i 's/\\~n//g' message.json
sed -i 's/\\~n//g' $c.ovpn
# Send the ovpn file to the new user
/usr/local/bin/aws ses send-raw-email \
  --cli-binary-format raw-in-base64-out \
  --raw-message file://message.json | exit 0
echo "OVPN file has been successfully sent to $p"
# Move user ovpn file that have recieved the mail
mv $c.ovpn ovpn-files/
done < ovpn_mail_tansfer.txt