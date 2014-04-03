class portal_alfresco::portal {

  if ($::portal_download) {
    $download = $::portal_download
  } else {
    $download = hiera('portal_download', 'http://jenkins-test.dev.sift.com:8080/job/Portal%20CI/ws/pw_portal/dist/Portal3.zip')
  }

  $portal_zip_path = '/opt/Portal.zip'
# TODO args need more prep
  $alfresco_webapps_path = "${portal_alfresco::alfresco_install_path}/tomcat/webapps"
  $alfresco_war_path = "${alfresco_webapps_path}/alfresco.war"
  $portal_unzip_path = '/opt/portal-unzip'

#  TODO ensure unzip is empty?
  exec {'extract portal.zip':
    command => "/usr/bin/unzip -u ${portal_zip_path} -d ${portal_unzip_path}",
    creates => "${portal_alfresco::flags_path}/portal-installed"
  }
  # TODO create file afterwards

  # TODO add to war
  exec {'update war':
    command => "${portal_alfresco::alfresco_install_path}/java/bin/jar uf ${alfresco_war_path} -C ${portal_unzip_path} WEB-INF",
    require => Exec['extract portal.zip'],
    creates => "${portal_alfresco::flags_path}/portal-installed",
  } -> file {'portal-installed-flag':
    ensure => present,
    path   => "${portal_alfresco::flags_path}/portal-installed",
  }

  # Download from jenkins
  exec {'download portal.zip':
    command => "/usr/bin/wget -q $download -O $portal_zip_path",
    creates => "${portal_alfresco::flags_path}/portal-installed"
  }

  #deps
  Exec['download portal.zip']->Exec['extract portal.zip']->Exec['update war']

}
