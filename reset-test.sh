#!/bin/bash

ROOT="/home/michal3/ansible-tests"
HOME="$ROOT/home/michal"

rm -rf $ROOT
mkdir -p $ROOT

mkdir -p $ROOT/{opt,usr/local/lib}
mkdir -p $HOME
