#!/usr/bin/env bash

if [ "$#" -lt 3 ]; then
  echo "usage: $0 <user> <pass> <url> [dir]"
  exit 1
fi

USER="$1"
PASS="$2"
URL="$3"
DIR=${4:-.}

function log {
  stdbuf -o0 echo "($URL): $1"
}

function json_get {
  node -e "console.log(JSON.parse('$1').$2)"
}

function assert_status {
  if [ $? -ne 0 ]; then
    echo "($URL): $1"
    exit 1
  fi
}

LOCKDIR='/tmp/rg_download.lock'
LOGIN_FILE='/tmp/rg_download.login.json'

while : ; do
  if mkdir $LOCKDIR 2>/dev/null; then
    # log 'login lock acquired'

    if [ -f $LOGIN_FILE ]; then
      # log 'login file exists'

      LOGIN_DATA=`cat $LOGIN_FILE`
      EXP=`json_get "$LOGIN_DATA" 'response.expire_date'`
      SID=`json_get "$LOGIN_DATA" 'response.session_id'`
      NOW=`date --date='1 week' +%s` # SID is ~6 months valid, assume buffer

      if [ "$NOW" -gt "$EXP" ]; then
        log 'login data expired'
        SID=''
      fi
    fi

    if [ -z "$SID" ]; then
      log 'performing fresh login'
      RES=`curl -X POST --fail -s "https://rapidgator.net/api/user/login?username=$USER&password=$PASS"`
      if [ $? -ne 0 ]; then
        log 'login failed'
        rm -rf $LOCKDIR
        exit 1
      fi
      echo "$RES" > "$LOGIN_FILE"
      SID=`json_get "$RES" 'response.session_id'`
    fi

    rm -rf $LOCKDIR
    break

  else
    # log 'will retry'
    sleep 1s
  fi
done

RES=`curl -X GET --fail -s "https://rapidgator.net/api/file/info?sid=$SID&url=$URL"`
assert_status 'info failed'
FILE=`json_get "$RES" 'response.filename'`

RES=`curl -X GET --fail -s "https://rapidgator.net/api/file/download?sid=$SID&url=$URL"`
assert_status 'link failed'
DOWN_URL=`json_get "$RES" 'response.url'`

log 'starting'

curl -X GET --fail -s -o "$DIR/$FILE" "$DOWN_URL"
