#
# Cookbook:: segulja_bacula
# Recipe:: director
#
# Copyright:: 2018, The Authors, All Rights Reserved.

package 'mysql-community-common' do
  action :remove
  version ['5.7.16-1.el7']
end

%w(
  mt-st
  gcc
  gcc-c++
  make
  ncurses
  ncurses-devel
  ncurses-libs
).each do |pkg|
  package pkg do
    action :install
  end
end

%w(
  mysql-community-client
  mysql-community-common
  mysql-community-devel
  mysql-community-libs
  mysql-community-server
).each do |pkg|
  package pkg do
    version ['5.6.39-2.el7']
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
  EOH
  action :run
  not_if { ::File.exist?('/tmp/bacula/bacula-9.0.6/README') }
end

execute 'Configure Bacula Backup System from source code' do
  command 'cd /tmp/bacula/bacula-9.0.6 ; CFLAGS="-g -Wall" ./configure \
            --sbindir=/opt/bacula/bin \
            --sysconfdir=/opt/bacula/etc \
            --enable-smartalloc \
            --with-mysql \
            --with-working-dir=/opt/bacula/working \
            --with-pid-dir=/opt/bacula/working \
            --with-subsys-dir=/opt/bacula/working \
            --enable-conio \
            --with-archivedir=/opt/bacula/working/archive \
            --with-dump-email=michael@segulja.com'
  action :run
  live_stream true
  not_if { ::File.exist?('/tmp/bacula/bacula-9.0.6/config.out') }
end

execute 'Compile and Install Bacula Backup System from source code' do
  command 'cd /tmp/bacula/bacula-9.0.6 ; make ; make install'
  action :run
  live_stream true
  not_if { :: File.exist?('/opt/bacula/bin/bacula') }
end

template '/opt/bacula/etc/bacula-dir.conf' do
  source 'bacula-dir.conf.erb'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

service 'mysqld' do
  action [:enable, :start]
end
