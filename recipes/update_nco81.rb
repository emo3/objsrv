# Create the dir's that are needed by netcool update
directory node['objsrv']['fp_dir'] do
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  not_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/etc/default/update81fp13to81fp15.sql") }
  recursive true
  mode '0755'
end

# Download the object server fix pack file
remote_file "#{node['objsrv']['fp_dir']}/#{node['objsrv']['fp_pkg']}" do
  source "#{node['objsrv']['media_url']}/#{node['objsrv']['fp_pkg']}"
  not_if { File.exist?("#{node['objsrv']['fp_dir']}/#{node['objsrv']['fp_pkg']}") }
  not_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/etc/default/update81fp13to81fp15.sql") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode '0755'
  action :create
end

# unzip the object server fix pack file
execute 'unzip_fp_package' do
  command "unzip -q #{node['objsrv']['fp_dir']}/#{node['objsrv']['fp_pkg']}"
  cwd node['objsrv']['fp_dir']
  not_if { File.exist?("#{node['objsrv']['fp_dir']}/update_gui.sh") }
  not_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/etc/default/update81fp13to81fp15.sql") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  umask '022'
  action :run
end

template "#{node['objsrv']['temp_dir']}/update_sf_nc81fp.xml" do
  not_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/etc/default/update81fp13to81fp15.sql") }
  source 'update_sf_nc81fp.xml.erb'
  mode 0755
end

execute 'update_netcool' do
  command "#{node['objsrv']['app_dir']}/InstallationManager/eclipse/tools/imcl \
  input #{node['objsrv']['temp_dir']}/update_sf_nc81fp.xml \
  -log #{node['objsrv']['temp_dir']}/update-nc81_log.xml \
  -acceptLicense"
  not_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/etc/default/update81fp13to81fp15.sql") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  umask '022'
  action :run
end

file "#{node['objsrv']['temp_dir']}/update_sf_nc81fp.xml" do
  only_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/etc/default/update81fp13to81fp15.sql") }
  action :delete
end

directory node['objsrv']['fp_dir'] do
  only_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/etc/default/update81fp13to81fp15.sql") }
  recursive true
  action :delete
end
