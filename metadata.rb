name 'objsrv'
maintainer 'Ed Overton'
maintainer_email 'infuse.1301@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures objsrv'
long_description 'Installs/Configures objsrv'
version '0.1.0'
chef_version '>= 13.0'
supports 'redhat'
supports 'centos'

issues_url 'https://github.com/<insert_org_here>/objsrv/issues' if respond_to?(:issues_url)
source_url 'https://github.com/<insert_org_here>/objsrv'

depends 'nc_base'
depends 'nc_tools'
depends 'server_utils'
