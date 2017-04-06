 #!/usr/bin/bash

function getSessionHashFromSSH_CLIENT() {
  ipanddestport=`/usr/bin/echo $SSH_CLIENT | /usr/bin/awk '{ printf "%s:%d", $1, $2 }'| sed 's/[^a-zA-Z0-9]//g'`
  sha256hash=`/usr/bin/echo $ipanddestport | /usr/bin/sha256sum | /usr/bin/awk '{ print $1 }'`
  sessionhash=`/usr/bin/echo $sha256hash | /usr/bin/head -c 7`
  export SESSION_HASH_ID=$sessionhash
}

function getSessionHashFromNetstat() {
  ipanddestport=$1
  sha256hash=`/usr/bin/echo $ipanddestport | /usr/bin/sha256sum | /usr/bin/awk '{ print $1 }'| sed 's/[^a-zA-Z0-9]//g'`
  sessionhash=`/usr/bin/echo $sha256hash | /usr/bin/head -c 7`
  export SESSION_HASH_ID=$sessionhash
  /usr/bin/echo $sessionhash
}

export CURRENT_CONNECTIONS=`/usr/bin/netstat -tnpa | /usr/bin/grep 'ESTABLISHED.*sshd' | /usr/bin/awk '{ print $5 }'`
export CURRENT_SSH_CONN_HASHES=""


for connection in $CURRENT_CONNECTIONS; do
  /usr/bin/echo "$connection $(getSessionHashFromNetstat `echo $connection| sed 's/[^a-zA-Z0-9]//g'`)";
done
