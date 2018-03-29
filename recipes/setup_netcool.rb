# set the IP and probe server name
hostsfile_entry node['objsrv']['ps_ip'] do
  hostname node['objsrv']['PS']
  action   :create
  unique   true
end

# copy original omni.dat to backup name
execute 'backup_objsrv' do
  command "mv #{node['objsrv']['nc_dir']}/etc/omni.dat #{node['objsrv']['nc_dir']}/etc/omni.dat.orig"
  cwd "#{node['objsrv']['nc_dir']}/etc"
  not_if { File.exist?("#{node['objsrv']['nc_dir']}/etc/omni.dat.orig") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  action :run
end

# create omni.dat via template
template "#{node['objsrv']['nc_dir']}/etc/omni.dat" do
  source 'omni.dat.erb'
  not_if { File.exist?("#{node['objsrv']['nc_dir']}/etc/omni.dat") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode 0664
end

# create the interface file
execute 'create_interface' do
  command "#{node['objsrv']['nc_dir']}/bin/nco_igen"
  cwd "#{node['objsrv']['nc_dir']}/bin"
  not_if { File.exist?("#{node['objsrv']['nc_dir']}/etc/interfaces.linux2x86") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  action :run
end

# create fips.conf file for TLS 1.2 security
template "#{node['objsrv']['nc_dir']}/etc/security/fips.conf" do
  source 'fips.conf.erb'
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode 0444
end

# create the object server database
execute 'create_objsrv' do
  command "#{node['objsrv']['ob_dir']}/bin/nco_dbinit \
  -server #{node['objsrv']['ncoms']} \
  -force"
  cwd "#{node['objsrv']['ob_dir']}/bin"
  not_if { File.exist?("#{node['objsrv']['ob_dir']}/db/#{node['objsrv']['ncoms']}/master_store.tab") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  action :run
end
