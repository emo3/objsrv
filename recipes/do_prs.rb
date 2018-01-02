include_recipe '::fix_objsrv'

# Download the prs file
remote_file "#{node['objsrv']['temp_dir']}/#{node['objsrv']['prs']}" do
  source "#{node['objsrv']['media_url']}/#{node['objsrv']['prs']}"
  not_if { File.exist?("#{node['objsrv']['temp_dir']}/#{node['objsrv']['prs']}") }
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# untar the prs tar file
execute 'untar_package' do
  command "tar -xf #{node['objsrv']['temp_dir']}/#{node['objsrv']['prs']}"
  cwd node['objsrv']['temp_dir']
  not_if { File.exist?("#{node['objsrv']['temp_dir']}/prereq_checker.sh") }
  user 'root'
  group 'root'
  umask '022'
  action :run
end

selinux_state 'SELinux Permissive' do
  action :permissive
end

template '/tmp/run_prs.sh' do
  source 'prs.sh.erb'
  mode 0755
end

bash 'run prs' do
  cwd '/tmp'
  code <<-EOH
# setup NTP
systemctl start ntpd
systemctl enable ntpd
systemctl status ntpd
/tmp/run_prs.sh
EOH
end

selinux_state 'SELinux Enforcing' do
  action :enforcing
end
