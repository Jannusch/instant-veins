//
//Packer Template for building Instant Veins
//Copyright (C) 2018 Christoph Sommer <sommer@ccs-labs.org>
//
//Documentation for this template is at http://veins.car2x.org/
//
//This program is free software; you can redistribute it and/or modify 
//it under the terms of the GNU General Public License as published by 
//the Free Software Foundation; either version 2 of the License, or 
//(at your option) any later version. 
// 
//This program is distributed in the hope that it will be useful, 
//but WITHOUT ANY WARRANTY; without even the implied warranty of 
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
//GNU General Public License for more details. 
// 
//You should have received a copy of the GNU General Public License 
//along with this program; if not, write to the Free Software 
//Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
//

variable "version" {
  type    = string
  default = "5.2-i1"
}

packer {
  required_plugins {
    virtualbox = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}


source "virtualbox-iso" "instant-veins" {
  iso_urls = [
    "files/debian-11.1.0-amd64-netinst.iso",
    "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.4.0-amd64-netinst.iso"
  ]
  iso_checksum         = "sha256:d490a35d36030592839f24e468a5b818c919943967012037d6ab3d65d030ef7f"
  headless             = true
  disk_size            = 20480
  guest_additions_mode = "disable"
  guest_os_type        = "Debian 11"
  post_shutdown_delay  = "1m"
  shutdown_command     = "echo 'veins' | sudo -S shutdown -P now"
  boot_wait            = "5s"
  http_directory       = "scripts"
  ssh_username         = "veins"
  ssh_password         = "veins"
  ssh_wait_timeout     = "10000s"
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--memory", "4096"],
    ["modifyvm", "{{.Name}}", "--cpus", "2"],
    ["modifyvm", "{{.Name}}", "--vram", "128"]
  ]
  vboxmanage_post = [
    ["storageattach", "{{.Name}}", "--storagectl", "IDE Controller", "--port", "0", "--device", "1", "--type", "dvddrive", "--medium", "emptydrive"]
  ]
  boot_command = [
    "<esc><wait>",
    "install ",
    "auto ",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "locale=en_US.UTF-8 ",
    "kbd-chooser/method=us ",
    "keyboard-configuration/xkb-keymap=us ",
    "netcfg/get_hostname=instant-veins ",
    "netcfg/get_domain=car2x.org ",
    "<enter>"
  ]
  format           = "ova"
  output_directory = "output/instant-veins-${var.version}"
  vm_name          = "instant-veins-${var.version}"
  export_opts = [
    "--manifest",
    "--vsys", "0",
    "--description", "Instant Veins ${var.version}",
    "--version", "${var.version}"
  ]
}

build {
  sources = ["sources.virtualbox-iso.instant-veins"]


  provisioner "shell" {
    execute_command = "echo 'veins' | {{.Vars}} sudo -E -S bash '{{.Path}}'"
    script          = "scripts/pre.sh"
  }

  provisioner "ansible-local" {
    playbook_file = "ansible/instant-veins.yml"
    playbook_dir  = "ansible"
    extra_arguments = [
      "-e",
      "'ansible_python_interpreter=/usr/bin/python3'"
    ]
  }

  provisioner "shell" {
    execute_command = "echo 'veins' | {{.Vars}} sudo -E -S bash '{{.Path}}'"
    script          = "scripts/post.sh"
  }
}