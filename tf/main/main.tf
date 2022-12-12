resource "aws_security_group" "openvpn" {
  name        = "openvpn-server"
  description = "Allow inbound traffic to OpenVPN server"
  vpc_id      = var.vpc_id

  ingress {
    description = "Access VPN anywhere"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Access from Cisco server"
    from_port   = 500
    to_port     = 500
    protocol    = "tcp"
    cidr_blocks = ["54.77.94.65/32"]
  }

  ingress {
    description = "SSH access from Gateway"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.249.95.10/32"]
  }
  ingress {
    description = "SSH access from wowcher-ci vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.249.162.0/23"]
  }

  tags = var.tags
}

resource "aws_key_pair" "openvpn" {
  key_name   = var.ssh_private_key_file
  public_key = file("${path.module}/${var.ssh_public_key_file}")
}

resource "aws_eip" "openvpn" {
  instance = aws_instance.openvpn.id
  vpc      = true
  tags     = var.tags
}

resource "aws_instance" "openvpn" {
  ami                         = "ami-0dcc20d3a15abf9bb"
  associate_public_ip_address = true
  instance_type               = var.instance_type
  iam_instance_profile        = "Puppet-Agent"
  key_name                    = aws_key_pair.openvpn.key_name
  subnet_id                   = "subnet-fde2dfa5"

  vpc_security_group_ids = [aws_security_group.openvpn.id]

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.instance_root_block_device_volume_size
    delete_on_termination = false
    encrypted             = true
  }

  tags = var.tags
}

resource "aws_cloudwatch_event_rule" "openvpn" {
  name                = "openvpn-daily-backup-${var.aws_region}"
  description         = "Fires every day at 00:00 UTC"
  schedule_expression = "cron(0 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "openvpn" {
  target_id = "create-snapshot"
  arn       = "arn:aws:events:${var.aws_region}:${var.aws_account_id}:target/create-snapshot"
  input     = jsonencode(aws_instance.openvpn.root_block_device.0.volume_id)
  rule      = aws_cloudwatch_event_rule.openvpn.name
  role_arn  = aws_iam_role.openvpn.arn
}

resource "null_resource" "openvpn_bootstrap" {
  connection {
    type        = "ssh"
    host        = aws_instance.openvpn.private_dns
    user        = var.ec2_username
    port        = "22"
    private_key = file("${path.module}/${var.ssh_private_key_file}")
    agent       = false
  }

  provisioner "file" {
    source      = "../../scripts/openvpn-install.sh"
    destination = "/home/ec2-user/openvpn-install.sh"
  }
  provisioner "file" {
    source      = "../../scripts/ovpnauth.sh"
    destination = "/home/ec2-user/ovpnauth.sh"
  }
  provisioner "file" {
    source      = "../../scripts/ovpn_client_transfer.sh"
    destination = "/home/ec2-user/ovpn_client_transfer.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "chmod +x ./ovpnauth.sh",
      "chmod +x ./openvpn-install.sh",
      "chmod +x ./ovpn_client_transfer.sh",
      <<EOT
      sudo AUTO_INSTALL=y \
           APPROVE_IP=${aws_eip.openvpn.public_ip} \
           ENDPOINT=${var.dns_record} \
           ./openvpn-install.sh
EOT
    ]
  }
  depends_on = [aws_eip.openvpn]
}

resource "null_resource" "openvpn_update_users_script" {
  depends_on = [null_resource.openvpn_bootstrap]

  triggers = {
    ovpn_users = join(" ", var.ovpn_users)
  }

  connection {
    type        = "ssh"
    host        = aws_instance.openvpn.private_dns
    user        = var.ec2_username
    port        = "22"
    private_key = file("${path.module}/${var.ssh_private_key_file}")
    agent       = false
  }

  provisioner "file" {
    source      = "${path.module}/../../scripts/update_users.sh"
    destination = "/home/${var.ec2_username}/update_users.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~${var.ec2_username}/update_users.sh",
      "sudo ~${var.ec2_username}/update_users.sh ${join(" ", var.ovpn_users)}",
    ]
  }
}

resource "null_resource" "openvpn_download_configurations" {
  depends_on = [null_resource.openvpn_update_users_script]

  triggers = {
    ovpn_users = join(" ", var.ovpn_users)
  }

  provisioner "local-exec" {
    command = <<EOT
    mkdir -p ${var.ovpn_config_directory};
    chmod 400 ../../settings/openvpn;
    scp -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -i ${var.ssh_private_key_file} ${var.ec2_username}@${aws_instance.openvpn.private_dns}:/home/${var.ec2_username}/*.ovpn ${var.ovpn_config_directory}/
    ssh -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -i ${var.ssh_private_key_file} ${var.ec2_username}@${aws_instance.openvpn.private_dns} '/home/${var.ec2_username}/ovpn_client_transfer.sh ${join(" ", var.ovpn_users_mail)}'
    ssh -o StrictHostKeyChecking=no \
        -o UserKnownHostsFile=/dev/null \
        -i ${var.ssh_private_key_file} ${var.ec2_username}@${aws_instance.openvpn.private_dns} 'sed -i '/^#/d' /home/${var.ec2_username}/ovpn-files/*.ovpn'
EOT

  }
}

resource "aws_iam_role" "openvpn" {
  name               = "cloudwatch-event-rule-snapshot-execution-role"
  tags               = var.tags
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "events.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "openvpn" {
  name        = "cloudwatch-event-rule-snapshot-execution-role"
  description = "Policy for CloudWatch event rule"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CloudWatchEventsBuiltInTargetExecutionAccess",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateSnapshot"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "openvpn" {
  role       = aws_iam_role.openvpn.name
  policy_arn = aws_iam_policy.openvpn.arn
}