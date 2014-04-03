class portal_alfresco {
  # ensure that we have a download

# Common variables
  $alfresco_install_path = '/opt/alfresco-4.2.e'
  $flags_path = '/opt/alfresco-install-flags/'

  # TODO make sure this comes first before includes
  file {'alfresco_install_flags':
    ensure => directory,
    path   => $flags_path
  }

  # includes
  include portal_alfresco::install,portal_alfresco::amps,portal_alfresco::portal, portal_alfresco::config
  # Class deps
  File['alfresco_install_flags']->Class['portal_alfresco::install']->Class['portal_alfresco::amps']->Class['portal_alfresco::portal']->Class['portal_alfresco::config']
  
  # Setup start
  $start_method = 'script'
  
  case $start_method {
    'script': {
      include portal_alfresco::startscript
      Class['portal_alfresco::config']->Class['portal_alfresco::startscript']
    }
    'service': {
      include portal_alfresco::service
      Class['portal_alfresco::config']->Class['portal_alfresco::service']
    }
  }



}
