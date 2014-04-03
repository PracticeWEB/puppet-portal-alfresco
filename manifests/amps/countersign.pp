class portal_alfresco::amps::countersign {
  
  $repo_amp_path = "${portal_alfresco::amps::amp_download_folder}/countersign-repo.amp"
  $repo_download = "https://github.com/ntmcminn/CounterSign/releases/download/v1.0-BETA-1/countersign-repo.amp"

  $share_amp_path = "${portal_alfresco::amps::amp_download_folder}/countersign-share.amp"
  $share_download = "https://github.com/ntmcminn/CounterSign/releases/download/v1.0-BETA-1/countersign-share.amp" 
  

  exec{'download_countersign_repo': 
    command => "/usr/bin/wget ${repo_download} -O $repo_amp_path",
    creates => "${portal_alfresco::flags_path}/countersign_repo_installed"
  } -> exec{'install_countersign_repo':
    command => "${portal_alfresco::amps::mmt_cmd_base} ${repo_amp_path} ${portal_alfresco::alfresco_install_path}/tomcat/webapps/alfresco.war",
    creates => "${portal_alfresco::flags_path}/countersign_repo_installed",
  } -> file{ 'flag_countersign_repo' :
    ensure => present,
    path => "${portal_alfresco::flags_path}/countersign_repo_installed"    
  }
    
  exec{'download_countersign_share': 
    command => "/usr/bin/wget ${share_download} -O $share_amp_path",
    creates => "${portal_alfresco::flags_path}/countersign_share_installed"
  } -> exec{'install_countersign_share':
    command => "${portal_alfresco::amps::mmt_cmd_base} ${share_amp_path} ${portal_alfresco::alfresco_install_path}/tomcat/webapps/share.war",
    creates => "${portal_alfresco::flags_path}/countersign_share_installed"  
  } -> file{ 'flag_countersign_share' :
    ensure => present,
    path => "${portal_alfresco::flags_path}/countersign_share_installed"    
  } 

}