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
  mode 0440
end

# Create user netcool within Object Server
execute 'create_netcool' do
  command "#{node['objsrv']['ob_dir']}/bin/nco_sql \
  -server #{node['objsrv']['ncoms']} \
  -user root \
  -password '' \
  -input #{node['objsrv']['temp_dir']}/create_user.sql"
  sensitive true
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
  mode 0440
end

# Change root password
execute 'change_root' do
  command "#{node['objsrv']['ob_dir']}/bin/nco_sql \
  -server #{node['objsrv']['ncoms']} \
  -user root \
  -password '' \
  -input #{node['objsrv']['temp_dir']}/set_rpwd.sql"
  sensitive true
  action :run
end

file "#{node['objsrv']['temp_dir']}/set_rpwd.sql" do
  action :delete
end

# This will stop the object server via nco_sql
# create sql file to do shutdown
template "#{node['objsrv']['temp_dir']}/shutdown.sql" do
  source 'shutdown.sql.erb'
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  only_if { File.exist?("#{node['objsrv']['ob_dir']}/var/#{node['objsrv']['ncoms']}.pid") }
  mode 0444
end

# shutdown object server
execute 'shutdown_objsrv' do
  command "#{node['objsrv']['ob_dir']}/bin/nco_sql \
  -server #{node['objsrv']['ncoms']} \
  -user root \
  -password '#{node['objsrv']['root_pwd']}' \
  -input #{node['objsrv']['temp_dir']}/shutdown.sql"
  cwd "#{node['objsrv']['ob_dir']}/bin"
  only_if { File.exist?("#{node['objsrv']['ob_dir']}/var/#{node['objsrv']['ncoms']}.pid") }
  # The nco_sql will exit with error always
  returns [0, 255]
  sensitive true
  action :run
end

file "#{node['objsrv']['temp_dir']}/shutdown.sql" do
  action :delete
end

# create configuration files for PA
template "#{node['objsrv']['ob_dir']}/etc/#{node['objsrv']['os_pa_name']}.conf" do
  source 'nco_pa.conf.erb'
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode 0444
end
template "#{node['objsrv']['ob_dir']}/etc/#{node['objsrv']['os_pa_name']}.props" do
  source 'nco_pa.props.erb'
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode 0444
end

## create files for PAM
# netcool
template '/etc/pam.d/netcool' do
  source 'netcool.erb'
  mode 0644
end
# object server
template '/etc/pam.d/nco_objserv' do
  source 'nco_objserv.erb'
  mode 0644
end

# This is so PAD can read shadow file
file '/etc/shadow' do
  mode 0004
end

# create setup script for netcool applications
template '/etc/init.d/nco_pa' do
  source 'nco_pa.erb'
  mode 0755
end

# add script to system configuration
service 'nco_pa' do
  action [:enable, :start]
end

# create sql file to verify netcool
template "#{node['objsrv']['ob_dir']}/verify_nc.sql" do
  source 'verify_nc.sql.erb'
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode 0444
end
