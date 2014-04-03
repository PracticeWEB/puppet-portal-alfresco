class portal_alfresco::install {

  $sdk_download = 'http://dl.alfresco.com/release/community/build-4848/alfresco-community-sdk-4.2.e.zip'
  $alfresco_download = 'http://www2.alfresco.com/l/1234/2013-10-22/3dntj7'
  $alfresco_download_file = '/opt/alfresco-community-4.2.e-installer-linux-x64.bin'
  $alfresco_install_args = '--optionfile /opt/alfresco-install-opts.txt'

# Hardcoded template vars
  $alfresco_admin_password = 'admin'
  $alfresco_install_service = $portal_alfresco::start_method ? {
    'service' => 1,
    'script' => 0,
    default => 0
  }

  file {'create option file':
    ensure  => present,
    path    => '/opt/alfresco-install-opts.txt',
    content => template('portal_alfresco/alfresco-install-opts.txt.erb')
  }

  exec {'download_alfresco_installer':
    command => "/usr/bin/wget -q $alfresco_download -O $alfresco_download_file",
    creates => $alfresco_download_file,
    timeout => 600
  }

  file {'alfresco_installer':
    ensure  => file,
    path    => $alfresco_download_file,
    mode    => '0774',
    require => Exec['download_alfresco_installer']
  }

  exec {'install_alfresco':
    command => "$alfresco_download_file $alfresco_install_args",
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
