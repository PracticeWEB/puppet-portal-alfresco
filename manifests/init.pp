class portal_alfresco {

  # Common variables
  if ($::alfresco_install_path) {
    $alfresco_install_path = $::alfresco_install_path
  } else {
    $alfresco_install_path = hiera('alfresco_install_path', '/opt/alfresco-4.2.e')
  }

  if ($::flags_path) { 
    $flags_path = $::flags_path
  } else {
    $flags_path = hiera('flags_path', '/opt/alfresco-install-flags/')
  }

  # Install flags gives us some state. 
  file {'alfresco_install_flags':
    ensure => directory,
    path   => $flags_path
  }

  # includes
  include portal_alfresco::install,portal_alfresco::amps,portal_alfresco::portal, portal_alfresco::config
  # Class deps
  File['alfresco_install_flags']->Class['portal_alfresco::install']->Class['portal_alfresco::amps']->Class['portal_alfresco::portal']->Class['portal_alfresco::config']

  if ($::alfresco_start_method) {
    $start_method = $::alfresco_start_method
  } else {
    $start_method = hiera('alfresco_start_method', 'none')
  }

  case $start_method {
    'script': {
      include portal_alfresco::startscript
      Class['portal_alfresco::config']->Class['portal_alfresco::startscript']
    }
    'service': {
      include portal_alfresco::service
      Class['portal_alfresco::config']->Class['portal_alfresco::service']
    }
    default :{}
  }



}
