default['objsrv'].tap do |obs|
  obs['app_dir']     = '/apps'
  obs['nc_dir']      = "#{node['objsrv']['app_dir']}/netcool"
  obs['nc_home']     = '/home/netcool'
  obs['ob_dir']      = "#{node['objsrv']['nc_dir']}/omnibus"
  obs['temp_dir']    = '/tmp'
  obs['media_url']   = 'http://10.1.1.30/media'
  obs['lv_name']     = 'lvnc'
  obs['lv_size']     = '40G'
  obs['nc_act']      = 'netcool'
  obs['nc_grp']      = 'ncoadmin'
  obs['nc_pwd']      = 'P@ssw0rd'
  obs['obs_domain']  = 'Primary'
  obs['obs_type']    = 'ObjectServer'
  obs['obs_acting']  = 'TRUE'
  obs['obs_backup']  = 'FALSE'
  obs['ncoms']       = 'NCO'
  obs['OS']          = 'nco'
  obs['OSP']         = '10.1.1.40'
  obs['PS']          = 'ncp'
  obs['PSP']         = '10.1.1.41'
  obs['os_pa_name']  = 'NCO_PA'
  obs['ps_pa_name']  = 'NCP_PA'
  obs['p-ncoms']     = 'P_NCO'
  obs['b-ncoms']     = 'B_NCO'
  obs['bi-name']     = 'BI_GATE'
  obs['remedy']      = 'REMEDY_GATE'
  obs['tdw']         = 'TDW_GATE'
  obs['os_port']     = '4100'
  obs['pa_port']     = '4200'
  obs['bi_port']     = '4300'
  obs['remedy_port'] = '4301'
  obs['tdw_port']    = '4302'
  obs['mrules_file']  = 'snmptrap.rules'
  obs['erules_file']  = 'tivoli_eif.rules'
  obs['rdy_dir']     = "#{node['objsrv']['ob_dir']}/etc/#{node['objsrv']['remedy']}"
  obs['tdw_dir']     = "#{node['objsrv']['ob_dir']}/etc/#{node['objsrv']['tdw']}"
  obs['root_pwd']    = 'nc0Adm1n'
  obs['pa_epwd']     = '@44:GlEwL3cFaU+Pfjcm5S7xNs00PubYXnWhTqEVDtgvUjo=@'
  obs['encryption']  = 'AES'
end
