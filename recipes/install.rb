#
# Cookbook Name:: elasticsearch::install
# Recipe:: install
#
# Copyright (C) 2016 Thomas Cate
#
#

package 'openjdk-7-jre' do
  action :install
end

apt_repository 'elasticsearch' do
  uri          'http://packages.elastic.co/elasticsearch/2.x/debian'
  arch         'amd64'
  distribution 'stable'
  components   ['main']
  key          'https://packages.elastic.co/GPG-KEY-elasticsearch'
end

package 'elasticsearch' do
  action :install
end
