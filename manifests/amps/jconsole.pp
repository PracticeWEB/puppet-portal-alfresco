class portal_alfresco::amps::jconsole {

  $repo_amp_path = "${portal_alfresco::amps::amp_download_folder}/javascript-console-repo-0.6.0.amp"
  $repo_download = 'https://github.com/share-extras/js-console/releases/download/v0.6.0-rc1/javascript-console-repo-0.6.0.amp'

  $share_amp_path = "${portal_alfresco::amps::amp_download_folder}/javascript-console-share-0.6.0.amp"
  $share_download = 'https://github.com/share-extras/js-console/releases/download/v0.6.0-rc1/javascript-console-share-0.6.0.amp'

  exec{'download_jconsole_repo':
    command => "/usr/bin/wget ${repo_download} -O $repo_amp_path",
    creates => "${portal_alfresco::flags_path}/jconsole_repo_installed"
  } -> exec{'install_jconsole_repo':
    command => "${portal_alfresco::amps::mmt_cmd_base} ${repo_amp_path} ${portal_alfresco::alfresco_install_path}/tomcat/webapps/alfresco.war",
    creates => "${portal_alfresco::flags_path}/jconsole_repo_installed"
  } -> file{ 'flag_jconsole_repo' :
    ensure => present,
    path   => "${portal_alfresco::flags_path}/jconsole_repo_installed"
  }

  exec{'download_jconsole_share':
    command => "/usr/bin/wget ${share_download} -O $share_amp_path",
    creates => "${portal_alfresco::flags_path}/jconsole_repo_installed"
  } -> exec{'install_jconsole_share':
    command => "${portal_alfresco::amps::mmt_cmd_base} ${share_amp_path} ${portal_alfresco::alfresco_install_path}/tomcat/webapps/share.war",
    creates => "${portal_alfresco::flags_path}/jconsole_repo_installed"
  } -> file{ 'flag_jconsole_share' :
    ensure => present,
    path   => "${portal_alfresco::flags_path}/jconsole_share_installed"
  }

}