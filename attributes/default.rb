default['objsrv']['base_ver']    = '8.1.0'
default['objsrv']['point_ver']   = "#{node['objsrv']['base_ver']}.1"
default['objsrv']['fp_ver']      = '15'
default['objsrv']['fp_pkg']      = "#{node['objsrv']['base_ver']}-TIV-NCOMNIbus-Linux-FP00#{node['objsrv']['fp_ver']}.zip"
default['objsrv']['package']     = "OMNIbus-v#{node['objsrv']['point_ver']}-Core.linux64.zip"
default['objsrv']['prs']         = '1.2.0.18-Tivoli-PRS-Unix-fp0001.tar'
default['objsrv']['cots_dir']    = '/sfcots'
default['objsrv']['app_dir']     = "#{node['objsrv']['cots_dir']}/apps"
default['objsrv']['media_dir']   = "#{node['objsrv']['app_dir']}/media"
default['objsrv']['install_dir'] = "#{node['objsrv']['media_dir']}/nco81"
default['objsrv']['fp_dir']      = "#{node['objsrv']['media_dir']}/nco81fp"
default['objsrv']['temp_dir']    = '/tmp'
default['objsrv']['media_url']   = 'http://10.1.1.30/media'
default['objsrv']['rhel']        = %w(bc ntp firefox compat-libstdc++-33.i686)
