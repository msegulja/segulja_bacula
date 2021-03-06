#
# Cookbook:: segulja_bacula
# Recipe:: database
#
# Copyright:: 2018, The Authors, All Rights Reserved.

service 'mysqld' do
  action [:enable, :start]
end

execute 'Create the Bacula MySQL Database' do
  command '/opt/bacula/etc/create_bacula_database'
  action :run
  not_if 'mysql -u root -e "SHOW DATABASES LIKE \'bacula\'" | grep bacula'
  live_stream true
end

execute 'Create the Bacula MySQL Database Tables' do
  command '/opt/bacula/etc/make_bacula_tables'
  action :run
  not_if 'mysql -u root -e "SHOW TABLES" bacula | grep BaseFiles'
  live_stream true
end

execute 'Set the default privileges on the Bacula Database' do
  command '/opt/bacula/etc/grant_bacula_privileges'
  action :run
  not_if 'mysql -u root -e "SELECT DISTINCT user FROM user" mysql | grep -i bacula'
  live_stream true
end

execute 'Set the bacula user database password' do
  command 'mysql -u root -e "SET PASSWORD FOR \'bacula\'@\'localhost\' = PASSWORD(\'bacula\')"'
  action :run
  not_if 'mysql -u bacula -pbacula -e "SHOW TABLES" bacula | grep -i version'
end
