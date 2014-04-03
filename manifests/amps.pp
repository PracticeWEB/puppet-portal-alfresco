class portal_alfresco::amps {
  
  $amp_download_folder = '/opt/amps-downloaded'
  $mmt_path = "${portal_alfresco::alfresco_install_path}/bin/alfresco-mmt.jar"
  $mmt_cmd_base = "/opt/alfresco-4.2.e/java/bin/java -jar ${mmt_path} install"

# TODO make sure this comes first before includes
  file {'amps_download_folder':
    ensure => directory,
    path => $amp_download_folder
  }  

  include portal_alfresco::amps::alfviral,portal_alfresco::amps::countersign,portal_alfresco::amps::jconsole
  Class['portal_alfresco::amps']->Class['portal_alfresco::amps::alfviral']
  Class['portal_alfresco::amps']->Class['portal_alfresco::amps::countersign']
  Class['portal_alfresco::amps']->Class['portal_alfresco::amps::jconsole']
   
}
