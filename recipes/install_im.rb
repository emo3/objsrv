# create netcool admin group
group node['objsrv']['nc_grp'] do
  action :create
end

# create netcool admin account
user node['objsrv']['nc_act'] do
  gid node['objsrv']['nc_grp']
  shell '/bin/bash'
  password node['objsrv']['nc_pwd']
  manage_home true
  action :create
end

# Add group vagrant to netcool account
group 'vagrant' do
  members node['objsrv']['nc_act']
  action :modify
  append true
end

# Add netcool admin group account to root
group node['objsrv']['nc_grp'] do
  members 'root'
  action :modify
  append true
end

# Create the dir's that are needed by installation Manager
directory node['objsrv']['im_dir'] do
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  not_if { File.exist?("#{node['objsrv']['app_dir']}/InstallationManager/eclipse/IBMIM") }
  recursive true
  mode '0755'
end

# Download the object server package file
remote_file "#{node['objsrv']['im_dir']}/#{node['objsrv']['im_pkg']}" do
  source "#{node['objsrv']['media_url']}/#{node['objsrv']['im_pkg']}"
  not_if { File.exist?("#{node['objsrv']['im_dir']}/#{node['objsrv']['im_pkg']}") }
  not_if { File.exist?("#{node['objsrv']['im_dir']}/userinstc") }
  not_if { File.exist?("#{node['objsrv']['app_dir']}/InstallationManager/eclipse/IBMIM") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode '0755'
  action :create
end

# unzip the object server package file
execute 'unzip_package' do
  command "unzip -q #{node['objsrv']['im_dir']}/#{node['objsrv']['im_pkg']}"
  cwd node['objsrv']['im_dir']
  not_if { File.exist?("#{node['objsrv']['im_dir']}/userinstc") }
  not_if { File.exist?("#{node['objsrv']['app_dir']}/InstallationManager/eclipse/IBMIM") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  umask '022'
  action :run
end

# Change ownership of directories
directory node['objsrv']['app_dir'] do
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode '0755'
  recursive true
  action :create
end

# Install Installation Manager
execute 'install_im' do
  command "#{node['objsrv']['im_dir']}/userinstc \
  -acceptlicense \
  -accessRights nonAdmin \
  -installationDirectory #{node['objsrv']['app_dir']}/InstallationManager \
  -log #{node['objsrv']['temp_dir']}/install-im_log.xml"
  cwd node['objsrv']['im_dir']
  not_if { File.exist?("#{node['objsrv']['app_dir']}/InstallationManager/eclipse/IBMIM") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  umask '022'
  action :run
end

directory node['objsrv']['im_dir'] do
  only_if { File.exist?("#{node['objsrv']['app_dir']}/InstallationManager/eclipse/IBMIM") }
  recursive true
  action :delete
end

template '/etc/profile.d/im.sh' do
  source 'im.sh.erb'
  mode 0755
end
