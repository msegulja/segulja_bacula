# # encoding: utf-8

# Inspec test for recipe segulja_bacula::director

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe file('/opt/bacula/etc/bacula-dir.conf') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
end

describe service('mysqld') do
  it { should be_running }
  it { should be_enabled }
end

describe package('mt-st') do
  it { should be_installed }
end
