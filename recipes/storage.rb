#
# Cookbook:: segulja_bacula
# Recipe:: storage
#
# Copyright:: 2018, The Authors, All Rights Reserved.

template '/opt/bacula/etc/bacula-sd.conf' do
  source 'bacula-sd.conf.erb'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
