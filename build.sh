#!/bin/bash
set -exu

user_name=${1:-veins}
if [ $user_name != 'veins' ]; then
	# replace user in ansible playbook
	sed -i "s/user: \"veins\"/user: $user_name/g" ansible/instant-veins.yml	
	sed -i "s/\"Veins/\"$user_name/g" ansible/instant-veins.yml
	# replace user in scripts
	sed -i "s/veins/$user_name/g" scripts/preseed.cfg
	sed -i "s/veins/$user_name/g" scripts/post.sh
	sed -i "s/veins/$user_name/g" scripts/pre.sh
	
fi

echo '=> checking SHA1 sums'
(cd files; shasum --algorithm 1 --check SHA1SUMS)

echo '=> attempting to auto-determine git version'
SET_VERSION_A=
SET_VERSION_B=
VERSION=$(git describe --tags --match 'instant-veins-*' --always HEAD | sed -e 's/^instant-veins-//' || echo -ne '')
if test -n ${VERSION}; then
	SET_VERSION_A="-var"
	SET_VERSION_B="version=${VERSION}"
fi
packer init .
packer fmt .
packer validate .
packer build ${SET_VERSION_A} ${SET_VERSION_B} -on-error=ask instant-veins.pkr.hcl 
