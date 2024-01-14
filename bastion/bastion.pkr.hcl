packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
variable "region" {
  type    = string
  default = "us-east-1"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "terraform-bastion-prj-19" {
  ami_name      = "terraform-bastion-prj-19-${local.timestamp}"
  instance_type = "t2.micro"
  region        = var.region
  
  source_ami_filter {
    filters = {
      name                = "RHEL-8.1.0_HVM-20231109-x86_64-3-Hourly2-GP2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["309956199498"]
  }
  ssh_username = "ec2-user"
  tags = {
    Name = "terraform-bastion-prj-19"
    value = "terraform-bastion-prj-19"

  }
}

build {
  name    = "terraform-bastion-prj-19"
  sources = [
    "source.amazon-ebs.terraform-bastion-prj-19"
  ]
  provisioner "shell" {
    script = "bastion.sh"
  }
}