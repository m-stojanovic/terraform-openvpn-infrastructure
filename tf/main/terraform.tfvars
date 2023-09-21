aws_account_id                         = "123456789876"
instance_root_block_device_volume_size = 10
vpc_id                                 = "vpc-123456789"
instance_type                          = "c5.xlarge"
aws_region                             = "eu-west-1"
ssh_private_key_file                   = "../../settings/openvpn"
ssh_public_key_file                    = "../../settings/openvpn.pub"
ovpn_config_directory                  = "../../generated/ovpn-config"
ec2_username                           = "ec2-user"
dns_record                             = "internalaccess.devops.com"
ovpn_users                             = [
  "milos.stojanovic",
  "test.new"
 ]
 ovpn_users_mail                       = [
  "milos.stojanovic@devops.com",
  "test.new@devops.com"
 ]
tags = {
  "Name"       = "openvpn-server"
  "created-by" = "terraform"
  "env"        = "prod"
  "vpc"        = "devops-services"
  "org"        = "devops"
  "service"    = "openvpn"
  "team"       = "devops"
}
