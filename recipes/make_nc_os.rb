# setup the netcool enviroment
# include_recipe '::make_nc_base'
# install the netcool gateways
# include_recipe '::install_gateways'
# setup and start Object server
include_recipe '::setup_netcool'
# setup the remedy gateway
include_recipe '::setup_gateways'
