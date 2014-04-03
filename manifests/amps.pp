class portal_alfresco::amps {

  if ($::amp_download_folder) {
    $amp_download_folder =  $::amp_download_folder    
  } else {
    $amp_download_folder = hiera('amp_download_folder','/opt/amps-downloaded')  
  }
  

  $mmt_path = "${portal_alfresco::alfresco_install_path}/bin/alfresco-mmt.jar"
  $mmt_cmd_base = "${portal_alfresco::alfresco_install_path}/java/bin/java -jar ${mmt_path} install"

# TODO make sure this comes first before includes
  file {'amps_download_folder':
    ensure => directory,
    path   => $amp_download_folder
  }


# Installing amps creates backups - we cleanup the initial ones
  exec{'clean_backups':
    command => "/bin/rm -f ${portal_alfresco::alfresco_install_path}/tomcat/webapps/*.bak",
    creates => "${portal_alfresco::flags_path}/backups-cleaned"
  } ->
  file {'clean_backups_flag':
    ensure => present,
    path   => "${portal_alfresco::flags_path}/backups-cleaned"
  }

  include portal_alfresco::amps::alfviral,portal_alfresco::amps::countersign,portal_alfresco::amps::jconsole
  File['amps_download_folder']->Class['portal_alfresco::amps::alfviral']
  File['amps_download_folder']->Class['portal_alfresco::amps::countersign']
  File['amps_download_folder']->Class['portal_alfresco::amps::jconsole']

  # clean up after all amps
  Class['portal_alfresco::amps::alfviral']->Exec['clean_backups']
  Class['portal_alfresco::amps::countersign']->Exec['clean_backups']
  Class['portal_alfresco::amps::jconsole']->Exec['clean_backups']
}
