 #!/usr/bin/bash

 #netstat -tnpa | grep 'ESTABLISHED.*sshd'

 function getSessionHashFromSSH_CLIENT() {
   ipanddestport=`/usr/bin/echo $SSH_CLIENT | /usr/bin/awk '{ printf "%s:%d", $1, $2 }'`
   sha256hash=`/usr/bin/echo $ipanddestport | /usr/bin/sha256sum | /usr/bin/awk '{ print $1 }'`
   sessionhash=`/usr/bin/echo $sha256hash | /usr/bin/head -c 7`
   export SESSION_HASH_ID=$sessionhash
 }

 function getSessionHashFromNetstat() {
   ipanddestport=$1
   sha256hash=`/usr/bin/echo $ipanddestport | /usr/bin/sha256sum | /usr/bin/awk '{ print $1 }'`
   sessionhash=`/usr/bin/echo $sha256hash | /usr/bin/head -c 7`
   export SESSION_HASH_ID=$sessionhash
   echo $sessionhash
 }

 export CURRENT_CONNECTIONS=`netstat -tnpa | grep 'ESTABLISHED.*sshd' | awk '{ print $5 }'`
 export CURRENT_SSH_CONN_HASHES=""


 for connection in $CURRENT_CONNECTIONS; do
   #echo "conn: $connection"
   tester=$(getSessionHashFromNetstat $connection)
   CURRENT_SSH_CONN_HASHES="$CURRENT_SSH_CONN_HASHES $(getSessionHashFromNetstat $connection)";
   #echo $tester;
 done

 for cHash in $CURRENT_SSH_CONN_HASHES; do
   echo $cHash;
 done
