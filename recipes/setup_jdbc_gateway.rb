# This will setup the gateways
# create the jdbc Gateway dir
directory node['objsrv']['tdw_dir'] do
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode '0755'
  recursive true
  action :create
end

# copy jdbc template from default location
execute 'copy_default_jdbc' do
  command "find #{node['objsrv']['ob_dir']}/gates/jdbc -maxdepth 1 -type f -exec cp -t #{node['objsrv']['tdw_dir']} {} +"
  cwd '/usr/bin'
  not_if { ::File.exist?("#{node['objsrv']['tdw_dir']}/tdw.map") }
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  action :run
end

# create jdbc configuration files
# map file
template "#{node['objsrv']['tdw_dir']}/tdw.map" do
  source 'reporting.jdbc.map.erb'
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode '0444'
end
# props file
template "#{node['objsrv']['tdw_dir']}/G_JDBC.props" do
  source 'reporting.G_JDBC.props.erb'
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode '0444'
end
# r/w file
template "#{node['objsrv']['tdw_dir']}/tdw.rdrwtr.tblrep.def" do
  source 'jdbc.rdrwtr.tblrep.def.erb'
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode '0444'
end
# command file
template "#{node['objsrv']['tdw_dir']}/tdw.startup.cmd" do
  source 'jdbc.startup.cmd.erb'
  user node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode '0444'
end
