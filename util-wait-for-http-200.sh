#!/bin/bash

# USAGE:  util-wait-for-http-200.sh http://myurl.foo

while true
do
  STATUS=$(curl -s -o /dev/null -w '%{http_code}' $1)
  if [ $STATUS -eq 200 ]; then
    echo "SITE IS UP!"
    break
  else
    echo "."
  fi
  sleep 5
done
