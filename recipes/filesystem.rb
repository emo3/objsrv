#################################################################
# Create directories
directory node['objsrv']['app_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

#################################################################
# Set physical volume
lvm_physical_volume '/dev/sdb'

#################################################################
# Set volume group
lvm_volume_group 'apmvg' do
  physical_volumes ['/dev/sdb']
end

#################################################################
# Set logical volume
lvm_logical_volume 'lvapm' do
  group 'apmvg'
  size '60G'
  filesystem 'xfs'
  mount_point node['objsrv']['app_dir']
end

#################################################################
# Set /tmp to 3G, from the original 1.99 provided by build.
# APM needs minimum of 2G
lvm_logical_volume 'lvtmp' do
  group 'rootvg'
  size '7G'
  filesystem 'xfs'
  mount_point node['objsrv']['temp_dir']
  # action :resize
  action :nothing
end
