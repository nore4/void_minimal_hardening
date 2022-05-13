#!/bin/bash

# Project: Backup script
# GNU/Linux Distro: Tested on Ubuntu 20.04
# Architecture: Tested and working on x86-64

# Configuration
m_logo(){
cat << "EOF"

                    .___                             __
  _____ _____     __| _/____    _____ _____    _____/  |_
 /     \\__  \   / __ |\__  \  /     \\__  \  /    \   __\
|  Y Y  \/ __ \_/ /_/ | / __ \|  Y Y  \/ __ \|   |  \  |
|__|_|  (____  /\____ |(____  /__|_|  (____  /___|  /__|
      \/     \/      \/     \/      \/     \/     \/
EOF

echo ""
echo -e "\e[37mMinimal hardening script\nTested on ubuntu server 20.04\nBy mrm"

}


# Update the system
update_system(){
   clear
   m_logo
   echo -e "\e[36m************************************************************\e[00m"
   echo -e "\e[37m Updating the System..."
   echo -e "\e[36m************************************************************\e[00m"
   echo ""
   apt update
   apt upgrade -y
   apt dist-upgrade -y

}


# Create admin user
add_admin(){
    clear
    m_logo
    echo -e "\e[36m************************************************************\e[00m"
    echo -e "\e[37m Creating admin user..."
    echo -e "\e[36m************************************************************\e[00m"
    echo ""
    echo -n " New username: "; read username
    adduser $username
    usermod -aG sudo $username

}


# Set umask rules for admin user
set_umask(){
  clear
  m_logo
  echo -e "\e[36m************************************************************\e[00m"
  echo -e "\e[37m Setting umask (077) for admin"
  echo -e "\e[36m************************************************************\e[00m"
  echo ""
  echo "umask 077" >> /home/$username/.bashrc

}


# Protect allocated memory
grub_sec(){
  clear
  m_logo
  echo -e "\e[36m************************************************************\e[00m"
  echo -e "\e[37m Updating GRUB..."
  echo -e "\e[36m************************************************************\e[00m"
  echo ""
  sed -i 's#^\(GRUB_CMDLINE_LINUX_DEFAULT="maybe-ubiquity\)"$#\1 init_on_alloc=1 init_on_free=1"#' /etc/default/grub
  sudo update-grub

}


# Configure Iptables
iptables_conf(){
  clear
  m_logo
  echo -e "\e[36m************************************************************\e[00m"
  echo -e "\e[37m Configuring Iptables..."
  echo -e "\e[36m************************************************************\e[00m"
  echo ""
  bash rules_iptables.sh
  cp rules_iptables.sh /etc/init.d/
  chmod +x /etc/init.d/rules_iptables.sh
  ln -s /etc/init.d/rules_iptables.sh /etc/rc2.d/S01rules_iptables.sh

}


# Disable Physical USB Ports
disable_usb(){
  clear
  m_logo
  echo "Disable USB PORTS"
  clear
  echo "blacklist usb_storage" >> /etc/modprobe.d/blacklist.conf
  echo ""
  update-initramfs -u
  echo "Done"

}


# More secure sshd_config (WIP)
secure_ssh(){
  clear
  m_logo
  echo -e "\e[36m************************************************************\e[00m"
  echo -e "\e[37m Configuring Iptables..."
  echo -e "\e[36m************************************************************\e[00m"
  echo ""
  echo -n " Securing SSH..."
  sed s/USERNAME/$username/g sshd_config > /etc/ssh/sshd_config; echo "sshd_config done!"
  systemctl restart sshd
  echo "Done"

}


#### End of all functions. Main Menu below ####


clear
m_logo
echo
echo -e "\e[36m***********************************************************\e[00m"
echo -e "\e[37m Enter your choice ->"
echo -e "\e[36m***********************************************************\e[00m"
echo -e "\e[37m"
echo "1. madamant configuration "
echo "2. Cherry-pick what you want to configure"
echo "3. Exit"
echo

read choice

case $choice in

1)
update_system
add_admin
set_umask
grub_sec
iptables_conf
disable_usb
secure_ssh
;;

2)

menu=""
until [ "$menu" = "5" ]; do

clear
m_logo
echo -e "\e[36m***********************************************************\e[00m"
echo -e "\e[37m Enter your choice ->"
echo -e "\e[36m***********************************************************\e[00m"
echo ""
echo "1. Update the system"
echo "2. Create admin"
echo "3. Protect allocated memory"
echo "4. IPtables"
echo "5. Disable USB Ports"
echo "6. Generate RSA keys (WIP)"
echo "7. Secure sshd_config"
echo "8. Exit"
echo ""

read menu
case $menu in

1)
update_system
;;

2)
add_admin
;;

3)
grub_sec
;;

4)
iptables_conf
;;

5)
disable_usb
;;

6)
secure_ssh
;;

7)
break ;;

8)
break ;;

*) ;;

esac
done
;;

3)
exit 0
;;

esac
