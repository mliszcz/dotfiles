#!/usr/bin/env bash

DDB_LIBDIR=~/.local/lib/deadbeef

function ddb_plugin {
  mkdir -p $DDB_LIBDIR
  curl -Lo ddb_plugin.zip $1
  unzip ddb_plugin.zip
  rm -f ddb_plugin.zip
  mv plugins/* $DDB_LIBDIR/
  rm -rf plugins
}

ddb_plugin 'http://sourceforge.net/projects/deadbeef/files/plugins/x86_64/ddb_filebrowser-1562809-x86_64.zip/download'
ddb_plugin 'http://sourceforge.net/projects/deadbeef/files/plugins/x86_64/ddb_quick_search-f1fc797-x86_64.zip/download'
