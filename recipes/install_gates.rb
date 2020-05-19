# Install the Netcool tools defined between ()
%w(jnetcool nco-g-jdbc nco-g-bmc-remedy nco-g-jdbc-reporting-scripts).each do |tool|
  install_tool 'do OBS install tool' do
    tool_package node['nc_tools'][tool]['tool_package']
    tool_url node['nc_tools'][tool]['tool_url']
    tool_dir node['nc_tools'][tool]['tool_dir']
    tool_lif node['nc_tools'][tool]['tool_lif']
    tool_version node['nc_tools'][tool]['tool_version']
    tool_name node['nc_tools'][tool]['tool_name']
    tool_imd node['nc_tools'][tool]['tool_imd']
    action :install
  end
end

# cmd tool file
tcmd = []
log '**** ^^^^ ####'
%w(nco-g-jdbc nco-g-bmc-remedy).each do |cmd|
  tcmd << node['nc_tools'][cmd].merge({'pa_name' => node['objsrv']['os_pa_name']})
end

log tcmd
template "#{node['objsrv']['nc_home']}/ncprofile-c" do
  source 'ncprofilec.erb'
  variables(
    tools: tcmd
  )
#  sensitive true
  owner node['objsrv']['nc_act']
  group node['objsrv']['nc_grp']
  mode '0755'
end

# %w(nco-g-jdbc nco-g-bmc-remedy).each do |cmd|
#   execute "create-tool-cmd for #{cmd}" do
#     command "echo #{node['nc_tools'][cmd]['tool_cmd']} >> #{node['nc_tools']['nc_home']}/ncprofile-c"
#     action :run
#   end
# end
