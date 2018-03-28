# remove when you do not need any X11 stuff
include_recipe '::add_x11'

# Create the dir's that are needed by netcool update
directory node['objsrv']['fp_dir'] do
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  recursive true
  mode '0755'
end

# Download the object server fix pack file
remote_file "#{node['objsrv']['fp_dir']}/#{node['objsrv']['fp_pkg']}" do
  source "#{node['objsrv']['media_url']}/#{node['objsrv']['fp_pkg']}"
  not_if { File.exist?("#{node['objsrv']['fp_dir']}/#{node['objsrv']['fp_pkg']}") }
  # not_if { File.exist?("#{node['objsrv']['install_dir']}/install_gui.sh") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode '0755'
  action :create
end

# unzip the object server fix pack file
execute 'unzip_fp_package' do
  command "unzip -q #{node['objsrv']['fp_dir']}/#{node['objsrv']['fp_pkg']}"
  cwd node['objsrv']['fp_dir']
  # not_if { File.exist?("#{node['objsrv']['install_dir']}/install_gui.sh") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  umask '022'
  action :run
end

file "#{node['objsrv']['fp_dir']}/#{node['objsrv']['fp_pkg']}" do
  # only_if { File.exist?("#{node['objsrv']['install_dir']}/install_gui.sh") }
  action :nothing
end

template "#{node['objsrv']['temp_dir']}/update_sf_nc81fp.xml" do
  source 'update_sf_nc81fp.xml.erb'
  mode 0755
end

execute 'update_netcool' do
  command "#{node['objsrv']['app_dir']}/InstallationManager/eclipse/tools/imcl \
  input #{node['objsrv']['temp_dir']}/update_sf_nc81fp.xml \
  -log #{node['objsrv']['temp_dir']}/update-nc81_log.xml \
  -acceptLicense"
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  umask '022'
  action :run
end
