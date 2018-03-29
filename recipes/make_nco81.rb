# add/create any file systems that are needed for netcool
include_recipe '::filesystem'
# fix anything with RHEL that is needed for netcool
include_recipe '::fix_netcool'
# install the latest version of installation manager
include_recipe '::install_im'
# install base netcool
include_recipe '::install_nco81'
# remove when you do not need any X11 stuff
include_recipe '::add_x11'
# Update Netcool to latest fix pack
include_recipe '::update_nco81'
# install the netcool gateways
include_recipe '::install_gateways'
# install the netcool knowledge library
include_recipe '::install_nckl'
