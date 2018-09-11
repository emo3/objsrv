# create local extra FS
include_recipe '::nc_filesystem'
# install the base Netcool software
include_recipe 'nc_base::make_nc_base'
include_recipe 'nc_base::add_x11'
include_recipe 'nc_base::install_nckl'
# install the netcool gateways
include_recipe '::install_gates'
# setup and start Object server
include_recipe '::setup_netcool'
# setup the remedy gateway
# include_recipe '::setup_gateways'
