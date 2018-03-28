include_recipe '::filesystem'
include_recipe '::fix_objsrv'
# include_recipe '::create_nc_acct'
include_recipe '::install_im'

# Create the dir's that are needed by apm
directory node['objsrv']['install_dir'] do
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  recursive true
  mode '0755'
end

# Download the object server package file
remote_file "#{node['objsrv']['install_dir']}/#{node['objsrv']['package']}" do
  source "#{node['objsrv']['media_url']}/#{node['objsrv']['package']}"
  not_if { File.exist?("#{node['objsrv']['install_dir']}/#{node['objsrv']['package']}") }
  not_if { File.exist?("#{node['objsrv']['install_dir']}/install_gui.sh") }
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
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  umask '022'
  action :run
end

file "#{node['objsrv']['install_dir']}/#{node['objsrv']['package']}" do
  only_if { File.exist?("#{node['objsrv']['install_dir']}/install_gui.sh") }
  action :delete
end

template '/tmp/install_sf_nc81.xml' do
  source 'install_sf_nc81.xml.erb'
  mode 0755
end

execute 'install_netcool' do
  command "#{node['objsrv']['app_dir']}/InstallationManager/eclipse/tools/imcl \
  input /tmp/install_sf_nc81.xml \
  -log /tmp/install-nc81_log.xml \
  -acceptLicense"
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  umask '022'
  action :run
end

template '/etc/profile.d/nco.sh' do
  source 'nco.sh.erb'
  mode 0755
end

# Download the java security file
remote_file "#{Chef::Config[:file_cache_path]}/java.security" do
  source "#{node['objsrv']['media_url']}/java.security"
  not_if { File.exist?("#{Chef::Config[:file_cache_path]}/java.security") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode '0755'
  action :create
end

template '/tmp/fix_java.sh' do
  source 'fix_java.sh.erb'
  mode 0755
end

execute 'Configure_JRE' do
  command '/tmp/fix_java.sh'
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  action :run
end

template '/tmp/list_apps.sh' do
  source 'list_apps.sh.erb'
  mode 0755
end
