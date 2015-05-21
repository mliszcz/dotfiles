#
# Cookbook Name:: devenv
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

log "Welcome to Chef" do
  level :info
end

tar_extract 'https://github.com/atom/atom/archive/v0.200.0.tar.gz' do
  target_dir '/tmp/my-atom'
  creates '/tmp/my-atom/README.md'
  tar_flags [ '--strip-components 1' ]
end
