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
  value unlimited
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
# end PRS Section
#######################################
