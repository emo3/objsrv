default['objsrv']['cots_dir']    = '/cots'
default['objsrv']['app_dir']     = "#{node['objsrv']['cots_dir']}/apps"
default['objsrv']['nc_dir']      = "#{node['objsrv']['app_dir']}/netcool"
default['objsrv']['ob_dir']      = "#{node['objsrv']['nc_dir']}/omnibus"
default['objsrv']['temp_dir']    = '/tmp'
default['objsrv']['media_url']   = 'http://10.1.1.30/media'
# default['objsrv']['rhel']        = %w(bc ntp firefox compat-libstdc++-33.i686)
default['objsrv']['rhel']        = %w(bc ntp firefox compat-libstdc++-33.i686 libXtst.i686 compat-libstdc++-33 compat-db libXp libXmu libXtst pam libXft gtk2 xauth motif)
default['objsrv']['nc_act']      = 'netcool'
default['objsrv']['nc_grp']      = 'ncoadmin'
default['objsrc']['root_pwd']    = 'nc0Adm1n'
default['objsrv']['nc_epwd']     = '$1$xyz$KYGw.YHIMKWpbx6InG1H9/'
default['objsrv']['pa_epwd']     = '@44:GlEwL3cFaU+Pfjcm5S7xNs00PubYXnWhTqEVDtgvUjo=@'
default['objsrv']['encryption']  = 'AES'
default['objsrv']['os_pa_name']  = 'NCO_PA'
default['objsrv']['ps_pa_name']  = 'NCP_PA'
default['objsrv']['ncoms']       = 'NCO'
default['objsrv']['p-ncoms']     = 'P_NCO'
default['objsrv']['b-ncoms']     = 'B_NCO'
default['objsrv']['bi-name']     = 'BI_GATE'
default['objsrv']['remedy']      = 'REMEDY_GATE'
default['objsrv']['rdy_dir']     = "#{node['objsrv']['ob_dir']}/etc/#{node['objsrv']['remedy']}"
default['objsrv']['tdw']         = 'TDW_GATE'
default['objsrv']['os_port']     = '4100'
default['objsrv']['pa_port']     = '4200'
default['objsrv']['bi_port']     = '4300'
default['objsrv']['remedy_port'] = '4301'
default['objsrv']['tdw_port']    = '4302'
# Taken from environmental variables via .kitchen.yml
default['PAP']                   = ''
default['PA']                    = ''
