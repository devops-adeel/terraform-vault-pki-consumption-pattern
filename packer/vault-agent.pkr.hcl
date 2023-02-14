packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

data "amazon-ami" "default" {
  filters = {
    virtualization-type = "hvm"
    name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
    root-device-type    = "ebs"
  }
  owners      = ["099720109477"]
  most_recent = true
}

source "amazon-ebs" "default" {
  ami_name      = var.image_name
  ssh_username  = var.ssh_username
  instance_type = var.instance_type
  region        = var.region
  source_ami    = data.amazon-ami.default.id
}

build {
  sources = ["source.amazon-ebs.default"]

  provisioner "shell" {
    script = "ansible/install_ansible.sh"
  }

  provisioner "ansible-local" {
    galaxy_file       = "ansible/requirements.yml"
    playbook_file     = "ansible/install.yml"
    galaxy_roles_path = "/usr/share/ansible/roles"

    extra_arguments = [
      "--extra-vars",
      "'packer_build=true vault_version=${var.vault_version}'",
    ]
  }

  provisioner "shell" {
    script = "ansible/uninstall_ansible.sh"
  }
}

build {
  hcp_packer_registry {
    bucket_name = "learn-packer-ubuntu"

    bucket_labels = {
      owner          = "platform-team"
      os             = "Ubuntu"
      ubuntu-version = "Focal 20.04"
    }

    sources = [
      "source.amazon-ebs.default",
    ]
  }
}
