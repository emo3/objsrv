# Create the dir's that are needed by netcool gateways
directory node['objsrv']['gate_dir'] do
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  not_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/gates/jdbc/default/jdbc.map") }
  not_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/gates/bmc_remedy/default/bmc_remedy.map") }
  recursive true
  mode '0755'
end

# Download the gateway file(s)
remote_file "#{node['objsrv']['gate_dir']}/nc81-gateways.zip" do
  source "#{node['objsrv']['media_url']}/nc81-gateways.zip"
  not_if { File.exist?("#{node['objsrv']['gate_dir']}/nc81-gateways.zip") }
  not_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/gates/jdbc/default/jdbc.map") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode '0755'
  action :create
end
remote_file "#{node['objsrv']['gate_dir']}/IM-nco-g-misc.zip" do
  source "#{node['objsrv']['media_url']}/IM-nco-g-misc.zip"
  not_if { File.exist?("#{node['objsrv']['gate_dir']}/IM-nco-g-misc.zip") }
  not_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/gates/bmc_remedy/default/bmc_remedy.map") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode '0755'
  action :create
end

# unzip the gateway file(s)
execute 'unzip_gateways' do
  command "unzip -q #{node['objsrv']['gate_dir']}/nc81-gateways.zip"
  cwd node['objsrv']['gate_dir']
  not_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/gates/jdbc/default/jdbc.map") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  umask '022'
  action :run
end
execute 'unzip_gw_misc' do
  command "unzip -q #{node['objsrv']['gate_dir']}/IM-nco-g-misc.zip"
  cwd node['objsrv']['gate_dir']
  not_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/gates/bmc_remedy/default/bmc_remedy.map") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  umask '022'
  action :run
end

template "#{node['objsrv']['temp_dir']}/install_product-gateways81.xml" do
  not_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/gates/jdbc/default/jdbc.map") }
  not_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/gates/bmc_remedy/default/bmc_remedy.map") }
  source 'install_sf_gateways81.xml.erb'
  mode 0755
end

# install the netcool gateways
execute 'install_gateways' do
  command "#{node['objsrv']['app_dir']}/InstallationManager/eclipse/tools/imcl \
  input #{node['objsrv']['temp_dir']}/install_product-gateways81.xml \
  -log #{node['objsrv']['temp_dir']}/install-gateways_log.xml \
  -acceptLicense"
  not_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/gates/jdbc/default/jdbc.map") }
  not_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/gates/bmc_remedy/default/bmc_remedy.map") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  umask '022'
  action :run
end

file "#{node['objsrv']['temp_dir']}/install_product-gateways81.xml" do
  only_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/gates/jdbc/default/jdbc.map") }
  only_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/gates/bmc_remedy/default/bmc_remedy.map") }
  action :delete
end

# remove temporary gateway dir
directory node['objsrv']['gate_dir'] do
  only_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/gates/jdbc/default/jdbc.map") }
  only_if { File.exist?("#{node['objsrv']['nc_dir']}/omnibus/gates/bmc_remedy/default/bmc_remedy.map") }
  recursive true
  action :delete
end
