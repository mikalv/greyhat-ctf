#!/usr/bin/bash

# CTF_SERVER_TEMP_DIR is set by ctf_tmp_datadir in ansible
#export TEMP_FILE=$CTF_SERVER_TEMP_DIR/xss-boot-run-level00.$$.$RANDOM

function clean_up {
   # Perform program exit housekeeping
  rm $TEMP_FILE
  exit
}

#trap clean_up SIGHUP SIGINT SIGTERM

#pr $1 > $TEMP_FILE

#while [[ -f "$TEMP_FILE" ]]; do
while [ true ]; do
  sleep 1;
  /usr/bin/phantomjs --ignore-ssl-errors=true \
    --local-to-remote-url-access=true \
    --web-security=false \
    --ssl-protocol=any xss-bot.js;
done;

clean_up
