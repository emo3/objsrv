# Create account for Netcool
# add netcool account stuff
execute 'create_group' do
  command "groupadd #{node['objsrv']['nc_grp']}"
end

execute 'create_user' do
  command "useradd #{node['objsrv']['nc_act']} -g #{node['objsrv']['nc_grp']} -G vagrant"
end

execute 'create_pwd' do
  command "usermod --password $(echo #{node['objsrv']['nc_pwd']} | openssl passwd -1 -stdin) #{node['objsrv']['nc_act']}"
end
# Add UG1=ncoadmin group to user root
execute 'add_group' do
  command "usermod -a -G #{node['objsrv']['nc_grp']} root"
end
# This is so PAD can read file
execute 'change shadow' do
  command 'chmod +r /etc/shadow'
end
