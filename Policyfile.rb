# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'objsrv'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'objsrv::make_nc_os', 'nc_base::add_x11'

# Specify a custom source for a single cookbook:
cookbook 'objsrv',       path: '.'
## Use when you have to pushed to supermarket
# cookbook 'nc_base',      git: 'https://github.com/emo3/nc_base.git'
# cookbook 'nc_tools',     git: 'https://github.com/emo3/nc_tools.git'
# cookbook 'server_utils', git: 'https://github.com/emo3/server_utils.git'
## Use when debugging local
# cookbook 'nc_base',      path: '~/chef/cookbooks/nc_base'
# cookbook 'nc_tools',     path: '~/chef/cookbooks/nc_tools'
# cookbook 'server_utils', path: '~/chef/cookbooks/server_utils'

# Override variables in nc_base
override['nc_base']['fp_ver'] = '30'
override['nc_base']['fp_rel'] = '5.50.105.20221024_1718'
