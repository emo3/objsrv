# Create the dir's that are needed by netcool
directory node['objsrv']['install_dir'] do
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  not_if { File.exist?("#{node['objsrv']['app_dir']}/netcool/bin/nco_id") }
  recursive true
  mode '0755'
end

# Download the object server package file
remote_file "#{node['objsrv']['install_dir']}/#{node['objsrv']['package']}" do
  source "#{node['objsrv']['media_url']}/#{node['objsrv']['package']}"
  not_if { File.exist?("#{node['objsrv']['install_dir']}/#{node['objsrv']['package']}") }
  not_if { File.exist?("#{node['objsrv']['install_dir']}/install_gui.sh") }
  not_if { File.exist?("#{node['objsrv']['app_dir']}/netcool/bin/nco_id") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode '0755'
  action :create
end

# unzip the object server package file
execute 'unzip_package' do
  command "unzip -q #{node['objsrv']['install_dir']}/#{node['objsrv']['package']}"
  cwd node['objsrv']['install_dir']
  not_if { File.exist?("#{node['objsrv']['install_dir']}/install_gui.sh") }
  not_if { File.exist?("#{node['objsrv']['app_dir']}/netcool/bin/nco_id") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  umask '022'
  action :run
end

template "#{node['objsrv']['temp_dir']}/install_sf_nc81.xml" do
  not_if { File.exist?("#{node['objsrv']['app_dir']}/netcool/bin/nco_id") }
  source 'install_sf_nc81.xml.erb'
  mode 0755
end

execute 'install_netcool' do
  command "#{node['objsrv']['app_dir']}/InstallationManager/eclipse/tools/imcl \
  input #{node['objsrv']['temp_dir']}/install_sf_nc81.xml \
  -log #{node['objsrv']['temp_dir']}/install-nc81_log.xml \
  -acceptLicense"
  not_if { File.exist?("#{node['objsrv']['app_dir']}/netcool/bin/nco_id") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  umask '022'
  action :run
end

file "#{node['objsrv']['temp_dir']}/install_sf_nc81.xml" do
  only_if { File.exist?("#{node['objsrv']['app_dir']}/netcool/bin/nco_id") }
  action :delete
end

directory node['objsrv']['install_dir'] do
  only_if { File.exist?("#{node['objsrv']['app_dir']}/netcool/bin/nco_id") }
  recursive true
  action :delete
end

template '/etc/profile.d/nco.sh' do
  source 'nco.sh.erb'
  mode 0755
end

# Download the java security file
remote_file "#{node['objsrv']['temp_dir']}/java.security" do
  source "#{node['objsrv']['media_url']}/java.security"
  not_if { File.exist?("#{node['objsrv']['temp_dir']}/java.security") }
  not_if { File.exist?("#{node['objsrv']['app_dir']}/netcool/bin/nco_id") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode '0755'
  action :create
end

template "#{node['objsrv']['temp_dir']}/fix_java.sh" do
  not_if { File.exist?("#{node['objsrv']['app_dir']}/netcool/bin/nco_id") }
  source 'fix_java.sh.erb'
  mode 0755
end

execute 'Configure_JRE' do
  command "#{node['objsrv']['temp_dir']}/fix_java.sh"
  not_if { File.exist?("#{node['objsrv']['app_dir']}/netcool/bin/nco_id") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  action :run
end

file "#{node['objsrv']['temp_dir']}/fix_java.sh" do
  action :delete
end

file "#{node['objsrv']['temp_dir']}/java.security" do
  action :delete
end
