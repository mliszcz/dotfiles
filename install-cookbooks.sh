#!/bin/bash

cwd=`pwd`

rm -rf ./berks-cookbooks

# fetch dependencies for each cookbook

for dir in cookbooks/*
do
  cd $dir && berks install
  cd $cwd
done

# vendor cookbooks in ./berks-cookbooks

berks vendor
