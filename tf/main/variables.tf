variable "dns_record" {
  description = "The CloudFlare DNS record to attach to OpenVPN server"
}

variable "aws_region" {
  description = "The AWS region to use"
}

variable "vpc_id" {
  description = "The VPC ID for the openvpn server"
}

variable "instance_type" {
  description = "The instance type to use"
}

variable "instance_root_block_device_volume_size" {
  description = "The size of the root block device volume of the EC2 instance in GiB"
}

variable "ec2_username" {
  description = "The user to connect to the EC2 as"
}

variable "ssh_public_key_file" {
  description = "The public SSH key to store in the EC2 instance"
}

variable "ssh_private_key_file" {
  description = "The private SSH key used to connect to the EC2 instance"
}

variable "ovpn_users" {
  type        = list(string)
  description = "The list of users to automatically provision with OpenVPN access"
}

variable "ovpn_users_mail" {
  type        = list(string)
  description = "The list of users mail address to automatically transfer ovpn client file with OpenVPN access"
}

variable "ovpn_config_directory" {
  description = "The name of the directory to eventually download the OVPN configuration files to"
}

variable "aws_account_id" {
  description = "AWS Account ID"
}

variable "tags" {
  description = "Tags to apply to resources"
}