class portal_alfresco::install {

  #$sdk_download = 'http://dl.alfresco.com/release/community/build-4848/alfresco-community-sdk-4.2.e.zip'
  
  if ($::alfresco_download) {
    $download = $::alfresco_download
  } else {
    $download = hiera('alfresco_download', 'http://www2.alfresco.com/l/1234/2013-10-22/3dntj7')
  }
  
  if ($::alfresco_install_file) {
    $install_file = $::alfresco_install_file
  } else {
    $install_file = hiera('alfresco_install_file', '/opt/alfresco-community-4.2.e-installer-linux-x64.bin')
  }
  
  $alfresco_install_args = '--optionfile /opt/alfresco-install-opts.txt'

  # Hardcoded template vars
  if ($::alfresco_admin_password) {
    $alfresco_admin_password = $::alfresco_admin_password
  } else {
    $alfresco_admin_password = hiera('alfresco_admin_password','admin')    
  }
    
  $alfresco_install_service = $portal_alfresco::start_method ? {
    'service' => 1,
    'script'  => 0,
    default   => 0
  }

  file {'create option file':
    ensure  => present,
    path    => '/opt/alfresco-install-opts.txt',
    content => template('portal_alfresco/alfresco-install-opts.txt.erb')
  }

  exec {'download_alfresco_installer':
    command => "/usr/bin/wget -q $download -O $install_file",
    creates => $install_file,
    timeout => 600
  }

  file {'alfresco_installer':
    ensure  => file,
    path    => $install_file,
    mode    => '0774',
    require => Exec['download_alfresco_installer']
  }

  exec {'install_alfresco':
    command => "$install_file $alfresco_install_args",
    creates => $portal_alfresco::alfresco_install_path,
    require => Exec['download_alfresco_installer'],
    timeout => 30000
  } ->
  file {'alfresco_installed_flag' :
    ensure => present,
    path   => "${portal_alfresco::flags_path}/alfresco_installed"
  }

  File['create option file']->Exec['install_alfresco']

}
