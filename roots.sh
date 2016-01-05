#!/bin/bash

if [ "$(uname)" == "Darwin" ]; then
	DEPENDENCIES=("ansible" "git" "VirtualBox" "vagrant")
else
	DEPENDENCIES=("ansible" "git" "virtual-box" "vagrant")
fi


f_create(){
clear
echo -n "Project name: "
read name

# If folder doesn't exist, create it
if [ ! -d $name ]; then
	mkdir $name && cd $name
	git clone --depth=1 git@github.com:roots/trellis.git && rm -rf trellis/.git
	git clone --depth=1 git@github.com:roots/bedrock.git site && rm -rf site/.git
	git clone --depth=1 git@github.com:roots/sage.git site/web/app/themes/sage && rm -rf site/web/app/themes/sage/.git
else
	echo "$name already exists"
	echo
	echo
	f_ask_update(){	
		read -p "Do you want to update to latest roots dependencies (y/n)" choice
		case "$choice" in 
		  y|Y ) f_update;;
		  n|N ) exit;;
		  * ) f_error;;
		esac  
	}
	while true; do f_ask_update; done
fi

exit
}

f_update(){
echo "TODO: Update existing project"
exit
}

f_error(){
echo "invalid option"
}

f_check_dependency(){

#TODO: Install / update vagrant dependencies (vagrant-bindfs, vagrant-hostmanager)

for i in ${DEPENDENCIES[@]}
do
	if [ ! -f "$(which $i)" ]; then
		echo "$i not found, please install $i"
		exit
	fi
	
done

}

f_main(){
f_check_dependency
echo -e "\e[1;34mRoots Wordpress scaffolding\e[0m"
echo "1. Create project"
echo "2. Update dependencies"
echo
echo -n "Choice: "
read choice

case $choice in
     1) f_create;;
     2) f_update;;
     3) exit;;
     *) f_error;;
esac 
}

# Program
while true; do f_main; done
