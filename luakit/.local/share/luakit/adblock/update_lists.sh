#!/bin/sh
mkdir -p ~/.local/share/luakit/adblock
cd ~/.local/share/luakit/adblock

set -v

curl -OL https://easylist.to/easylist/easylist.txt
curl -OL https://easylist.to/easylist/easyprivacy.txt
curl -OL https://secure.fanboy.co.nz/fanboy-cookiemonster.txt
curl -OL https://easylist.to/easylist/fanboy-social.txt
curl -OL https://secure.fanboy.co.nz/fanboy-annoyance.txt
curl -OL https://easylist-downloads.adblockplus.org/easylistpolish.txt
