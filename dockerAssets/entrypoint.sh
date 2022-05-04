#!/bin/bash

set -e

clear
heroku auth:login -i

echo
echo "Your Heroku apps:"
heroku apps --json | jq -r .[].name
echo
read -p "Which one do you want to use? " HEROKU_APP
export HEROKU_APP
sleep 1

/bin/bash -l