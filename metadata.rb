name 'objsrv'
maintainer 'Ed Overton'
maintainer_email 'bogus@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures objsrv'
long_description 'Installs/Configures objsrv'
version '0.4.1'
chef_version '>= 13.0'
supports 'redhat'
supports 'centos'

issues_url 'https://github.com/emo3/objsrv/issues' if respond_to?(:issues_url)
source_url 'https://github.com/emo3/objsrv'

depends 'nc_base'
depends 'nc_tools'
depends 'server_utils'
