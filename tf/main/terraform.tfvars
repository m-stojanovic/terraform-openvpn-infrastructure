aws_account_id                         = "147453477443"
instance_root_block_device_volume_size = 10
vpc_id                                 = "vpc-61bd2a04"
instance_type                          = "c5.xlarge"
aws_region                             = "eu-west-1"
ssh_private_key_file                   = "../../settings/openvpn"
ssh_public_key_file                    = "../../settings/openvpn.pub"
ovpn_config_directory                  = "../../generated/ovpn-config"
ec2_username                           = "ec2-user"
dns_record                             = "internalaccess.wowcher.co.uk"
ovpn_users                             = [
  "n.sengottuvel",
  "nikolay.malarenko",
  "naveen.pitta",
  "ojas.harkare",
  "milos.stojanovic",
  "dan.bennettnew",
  "mohan.kumar",
  "anuj.pandit",
  "salma.begum",
  "kuldeep.chandel",
  "momon.singha",
  "soujanya.balam",
  "abhishek.dutta",
  "dommaraju.venkatesh",
  "munisekhar.g",
  "deepank.sharma",
  "parth.gupta",
  "akshay.patil",
  "ramesh.ramaswamy",
  "navinkumar.veeramani",
  "shraddha.makwe",
  "ashok.surugu",
  "manoj.manchappagari",
  "shivam.ojha",
  "narendra.inamdar",
  "mohit.patel",
  "rajesh.balaji",
  "pankaj.kumar",
  "sunil.kumar"
 ]
 ovpn_users_mail                       = [
  "anuj.pandit@wowcher.co.uk",
  "salma.begum@wowcher.co.uk",
  "kuldeep.chandel@wowcher.co.uk",
  "momon.singha@wowcher.co.uk",
  "soujanya.balam@wowcher.co.uk",
  "abhishek.dutta@wowcher.co.uk",
  "dommaraju.venkatesh@wowcher.co.uk",
  "munisekhar.g@wowcher.co.uk",
  "deepank.sharma@wowcher.co.uk",
  "parth.gupta@wowcher.co.uk",
  "akshay.patil@wowcher.co.uk",
  "ramesh.ramaswamy@wowcher.co.uk",
  "navinkumar.veeramani@wowcher.co.uk",
  "shraddha.makwe@wowcher.co.uk",
  "ashok.surugu@wowcher.co.uk",
  "manoj.manchappagari@wowcher.co.uk",
  "shivam.ojha@wowcher.co.uk",
  "narendra.inamdar@wowcher.co.uk",
  "mohit.patel@wowcher.co.uk",
  "rajesh.balaji@wowcher.co.uk"
 ]
tags = {
  "Name"           = "openvpn-server"
  "wow:created-by" = "terraform"
  "wow:env"        = "prod"
  "wow:vpc"        = "wowcher-common-services"
  "wow:org"        = "wowcher"
  "wow:service"    = "openvpn"
  "wow:team"       = "devops"
}
