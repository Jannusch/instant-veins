#!/bin/bash
echo ""
echo "Finishing the build process."
echo "This task can take a while."
echo ""
sed -i "s/hosts: all/hosts: localhost/g" ~/ansible/instant-veins.yml
sed -i "s/internal: false/internal: true/g" ~/ansible/instant-veins.yml
ansible-playbook ~/ansible/instant-veins.yml -e "ansible_become_pass=veins"
echo "Removing files";
rm -rf ~/ansible
rm -rf ~/final_build.log
echo "Sync filesystem";
sync
echo "The build finished. Press Enter to close the terminal."
read line