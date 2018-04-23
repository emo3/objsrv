# Install the Netcool tools defined between ()
%w(nco-g-jdbc nco-g-bmc-remedy).each do |tool|
  install_tool 'do install tool' do
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
