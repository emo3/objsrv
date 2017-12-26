include_recipe '::filesystem'
include_recipe '::fix_objsrv'

# Create the dir's that are needed by apm
directory node['objsrv']['install_dir'] do
  owner 'root'
  group 'root'
  recursive true
  mode '0755'
end

# Download the object server package file
remote_file "#{node['objsrv']['install_dir']}/#{node['objsrv']['package']}" do
  source "#{node['objsrv']['media_url']}/#{node['objsrv']['package']}"
  not_if { File.exist?("#{node['objsrv']['install_dir']}/#{node['objsrv']['package']}") }
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  # action :nothing
end

# unzip the object server package file
execute 'unzip_package' do
  command "unzip -q #{node['objsrv']['install_dir']}/#{node['objsrv']['package']}"
  cwd node['objsrv']['install_dir']
  # not_if { File.exist?("#{node['objsrv']['install_dir']}/install_gui.sh") }
  user 'root'
  group 'root'
  umask '022'
  action :run
end
