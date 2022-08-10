#!/bin/bash
echo '
---
#
# Ansible Playbook for building Instant Veins
# Copyright (C) 2018 Christoph Sommer <sommer@ccs-labs.org>
#
# Documentation for this template is at http://veins.car2x.org/
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
- hosts: localhost
  connection: local
  vars:
    user: "veins"
    password: "$6$nkDuo0SdUXR8Im$4g8tXbIruu1YLimqImncK0pQ2EDzMuQjBwt8QRxS9L11NxvYCZarFdLvCwK28S.pF7aG2QpwUlG9J5i9GkYZB0" # hash of veins
    comment: "Veins (password is veins),,,"
    internal: false
  roles:
    - finish_veins_build
' > playbook.yml

(
    ansible-playbook playbook.yml > final_build.log && 
    echo "80";
    echo "# removing files";
    rm -rf ~/.ansible/roles
    rm -rf ~/final_build.log
    echo "90";
    echo "# sync filesystem";
    sync
) |
zenity --progress \
    --title="Finish veins build" \
    --text="Build veins" \
    --percentage=0