# Create the dir's that are needed by netcool knowledge library
directory node['objsrv']['nckl_dir'] do
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  recursive true
  mode '0755'
end

# Download the netcool knowledge library
remote_file "#{node['objsrv']['nckl_dir']}/NcKL_4.6-im.zip" do
  source "#{node['objsrv']['media_url']}/NcKL_4.6-im.zip"
  not_if { File.exist?("#{node['objsrv']['nckl_dir']}/NcKL_4.6-im.zip") }
  not_if { File.exist?("#{node['objsrv']['nckl_dir']}/repository.xml") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode '0755'
  action :create
end

# unzip the netcool knowledge library
execute 'unzip_nckl' do
  command "unzip -q #{node['objsrv']['nckl_dir']}/NcKL_4.6-im.zip"
  cwd node['objsrv']['nckl_dir']
  not_if { File.exist?("#{node['objsrv']['app_dir']}/NcKL/advcorr.sql") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  umask '022'
  action :run
end

template "#{node['objsrv']['temp_dir']}/install_product-nckl.xml" do
  source 'install_nckl.xml.erb'
  not_if { File.exist?("#{node['objsrv']['app_dir']}/NcKL/advcorr.sql") }
  mode 0755
end

# install the netcool knowledge library
execute 'install_nckl' do
  command "#{node['objsrv']['app_dir']}/InstallationManager/eclipse/tools/imcl \
  input #{node['objsrv']['temp_dir']}/install_product-nckl.xml \
  -log #{node['objsrv']['temp_dir']}/install-nckl_log.xml \
  -acceptLicense"
  not_if { File.exist?("#{node['objsrv']['app_dir']}/NcKL/advcorr.sql") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  umask '022'
  action :run
end

file "#{node['objsrv']['temp_dir']}/install_product-nckl.xml" do
  action :delete
end

# remove temporary netcool knowledge library
directory node['objsrv']['nckl_dir'] do
  recursive true
  action :delete
end
