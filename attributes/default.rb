default['bacula']['dir']['max_concurrent_jobs'] = '1'
default['bacula']['sd']['max_concurrent_jobs'] = '1'

default['bacula']['dir']['file_storage_device'] = 'File'
default['bacula']['dir']['file_storage_pool'] = 'File'

default['bacula']['dir']['address'] = node['ipaddress']
default['bacula']['sd']['address'] = node['ipaddress']
