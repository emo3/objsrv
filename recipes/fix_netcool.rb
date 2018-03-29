# make sure we have the latest RHEL versions
execute 'update_RHEL' do
  command 'yum -y -q update'
  action :run
end

#######################################
# The following was taken from the PreRequisite Scanner
# begin PRS Section

# Install RPM's
package node['objsrv']['rhel']

# set ulimits needed for ibm_apm
## max number of processes
set_limit '*' do
  type 'hard'
  item 'nproc'
  value 'unlimited'
  use_system true
end

set_limit '*' do
  type 'soft'
  item 'nproc'
  value 'unlimited'
  use_system true
end

## max number of open file descriptors
set_limit '*' do
  type 'hard'
  item 'nofile'
  value 33000
  use_system true
end

set_limit '*' do
  type 'soft'
  item 'nofile'
  value 33000
  use_system true
end

## limits the core file size (KB)
set_limit '*' do
  type 'hard'
  item 'core'
  value 390001
  use_system true
end

set_limit '*' do
  type 'soft'
  item 'core'
  value 390001
  use_system true
end

## maximum filesize (KB)
set_limit '*' do
  type 'soft'
  item 'fsize'
  value 'unlimited'
  use_system true
end

## max stack file size
set_limit '*' do
  type 'soft'
  item 'stack'
  value 'unlimited'
  use_system true
end
# end PRS Section
#######################################

# This is so PAD can read shadow file
file '/etc/shadow' do
  mode '0400'
end

service 'ntpd' do
  action [:enable, :start]
end
