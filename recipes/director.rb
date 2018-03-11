#
# Cookbook:: segulja_bacula
# Recipe:: director
#
# Copyright:: 2018, The Authors, All Rights Reserved.

package 'mysql-community-common' do
  action :remove
end

%w(
  mt-st
  gcc
  gcc-c++
  make
  postgresql
  mariadb
).each do |pkg|
  package pkg do
    action :install
  end
end

%w(
  /tmp/bacula
  /opt/bacula
  /opt/bacula/working
).each do |dir|
  directory dir do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
end

cookbook_file '/tmp/bacula/bacula-server.tar.gz' do
  source 'bacula-9.0.6.tar.gz'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

bash 'Extract and configure the Bacula source code' do
  code <<-EOH
  cd /tmp/bacula
  echo
  echo
  echo "Extracting the Bacula Source Code into /tmp/bacula"
  tar zxvf /tmp/bacula/bacula-server.tar.gz
  cd /tmp/bacula/bacula-9.0.6
  echo
  echo "Configuring the Bacula Source Code for installation"
  CFLAGS="-g -Wall" ./configure \
  --sbindir=/opt/bacula/bin \
  --sysconfdir=/opt/bacula/etc \
  --enable-smartalloc \
  --with-postgresql \
  --with-working-dir=/opt/bacula/working \
  --with-pid-dir=/opt/bacula/working \
  --with-subsys-dir=/opt/bacula/working \
  --enable-readline
  EOH
  action :run
  # not_if { ::File.exist?('/tmp/bacula/bacula-9.0.6/README') }
end
