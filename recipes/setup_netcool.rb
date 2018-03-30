# set the IP and probe server name
hostsfile_entry node['objsrv']['ps_ip'] do
  hostname node['objsrv']['PS']
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

# Download the password key file
remote_file "#{node['objsrv']['ob_dir']}/etc/passwdkey.key" do
  source "#{node['objsrv']['media_url']}/passwdkey.key"
  not_if { File.exist?("#{node['objsrv']['ob_dir']}/etc/passwdkey.key") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode '0644'
  action :create
end

# create ncoms property file
template "#{node['objsrv']['ob_dir']}/etc/#{node['objsrv']['ncoms']}.props" do
  source 'ncoms.props.erb'
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode 0444
end

# start the object server
bash 'run_objsrv' do
  cwd "#{node['objsrv']['ob_dir']}/bin"
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  code <<-EOH
    #{node['objsrv']['ob_dir']}/bin/nco_objserv \
    -name #{node['objsrv']['ncoms']} &
    # Give time for the Object Server to come up completely
    sleep 5
  EOH
  not_if { File.exist?("#{node['objsrv']['ob_dir']}/var/#{node['objsrv']['ncoms']}.pid") }
  action :run
end

# create sql file to add user and password
template "#{node['objsrv']['temp_dir']}/create_user.sql" do
  source 'create_user.sql.erb'
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  sensitive true
  mode 0444
end

# Create user netcool within Object Server
execute 'create_netcool' do
  command "#{node['objsrv']['ob_dir']}/bin/nco_sql \
  -server #{node['objsrv']['ncoms']} \
  -user root \
  -password '' \
  -input #{node['objsrv']['temp_dir']}/create_user.sql"
  action :run
end

file "#{node['objsrv']['temp_dir']}/create_user.sql" do
  action :delete
end

# create sql file to change root password
template "#{node['objsrv']['temp_dir']}/set_rpwd.sql" do
  source 'set_rpwd.sql.erb'
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  sensitive true
  mode 0444
end

# Change root password
execute 'change_root' do
  command "#{node['objsrv']['ob_dir']}/bin/nco_sql \
  -server #{node['objsrv']['ncoms']} \
  -user root \
  -password '' \
  -input #{node['objsrv']['temp_dir']}/set_rpwd.sql"
  action :run
end

file "#{node['objsrv']['temp_dir']}/set_rpwd.sql" do
  action :delete
end
