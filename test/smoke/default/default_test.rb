# # encoding: utf-8

# Inspec test for recipe segulja_bacula::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package('mt-st') do
  it { should be_installed }
end

describe directory('/opt/bacula/') do
  it { should exist }
end

describe file('/opt/bacula/etc/bacula-sd.conf') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
end

describe file('/opt/bacula/etc/bacula-fd.conf') do
  it { should exist }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
end
