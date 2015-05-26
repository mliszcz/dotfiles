#
# Cookbook Name:: devenv
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

log "Welcome to Chef" do
  level :info
end

directory "/tmp/my-atom"

ark "maven3-task" do
  url 'file:///home/michal/Downloads/apache-maven-3.3.1-bin.tar.gz'
  path '/tmp/maven-3'
  action :put
  # strip_components 2
  owner node['current_user']
  group node['current_user']
end
