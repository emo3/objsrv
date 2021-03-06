#################################################################
# Create directories
directory node['objsrv']['app_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

package 'lvm2'

create_xfs 'create netcool extra file system' do
  lv_size   node['objsrv']['lv_size']
  lv_name   node['objsrv']['lv_name']
  mnt_point node['objsrv']['app_dir']
  action :run
end
