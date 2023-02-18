#!/bin/bash
echo "SSH hangup user tool. For killing other users connections."
if [ $# -eq 0 ]
  then
    echo "use: $0 <PTS number to kill>"
    exit
fi
echo "Terminating PTS/$1"
OWNER=$(stat -c '%U' /dev/pts/$i)
SSH_PID=$(pgrep -a sshd | grep pts/$1 | cut -d ' ' -f 1)
echo "Owner of PTS is $OWNER"
echo "SSH PID is $SSH_PID"
echo "You have been expunged." > /dev/pts/$1
sleep 2 
kill -9 $SSH_PID
