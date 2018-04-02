# set the IP and probe server name
hostsfile_entry node['PAP'] do
  hostname node['PA']
  action   :create
  unique   true
end

# create omni.dat via template
template "#{node['objsrv']['nc_dir']}/etc/omni.dat" do
  source 'omni.dat.erb'
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

# Download the password key file
remote_file "#{node['objsrv']['ob_dir']}/etc/passwdkey.key" do
  source "#{node['objsrv']['media_url']}/passwdkey.key"
  not_if { File.exist?("#{node['objsrv']['ob_dir']}/etc/passwdkey.key") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode 0440
  action :create
end
