# install the base Netcool software
include_recipe 'nc_base::my_nc_base'
# install the netcool gateways
include_recipe '::install_gates'
# setup and start Object server
include_recipe '::setup_netcool'
# setup the remedy gateway
# include_recipe '::setup_gateways'
