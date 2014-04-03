class portal_alfresco::amps::alfviral {

  $download = 'https://alfviral.googlecode.com/files/fegorsoft-alfviral-1.3.0.420.zip'
  $repo_amp_path = "${portal_alfresco::amps::amp_download_folder}/fegorsoft-alfviral-alfresco-1.3.0.420.amp"
  $jar_path = "${portal_alfresco::amps::amp_download_folder}/fegorsoft-alfviral-share-1.3.0.420.jar"


  exec {'download_alfviral':
    command => "/usr/bin/wget $download -O ${portal_alfresco::amps::amp_download_folder}/fegorsoft-alfviral-1.3.0.420.zip",
    creates => "${portal_alfresco::amps::amp_download_folder}/fegorsoft-alfviral-1.3.0.420.zip",
  } -> exec {'unzip_alfviral':
    command => "/usr/bin/unzip -u  ${portal_alfresco::amps::amp_download_folder}/fegorsoft-alfviral-1.3.0.420.zip -d ${portal_alfresco::amps::amp_download_folder}",
    creates => $repo_amp_path
  }

  # Share just looks for a jar

  file {'tomcat_lib_folder':
    ensure => directory,
    path   => "${portal_alfresco::alfresco_install_path}/tomcat/shared/classes/lib"
  } ->
  file {'add_av_jar':
    ensure => present,
    path   => "${portal_alfresco::alfresco_install_path}/tomcat/shared/classes/lib/fegorsoft-alfviral-share-1.3.0.420.jar",
    source => "$jar_path",
  }

  # Install to repo with mmt
  exec{'install_alfviral_repo':
    command => "${portal_alfresco::amps::mmt_cmd_base} ${repo_amp_path} ${portal_alfresco::alfresco_install_path}/tomcat/webapps/alfresco.war",
    creates => "${portal_alfresco::flags_path}/jconsole_repo_installed"
  } -> file{ 'flag_alfviral_repo':
    ensure => present,
    path   => "${portal_alfresco::flags_path}/alfviral_repo_installed"
  }

  # deps
  Exec['download_alfviral']->Exec['unzip_alfviral']->File['add_av_jar']
  Exec['download_alfviral']->Exec['unzip_alfviral']->Exec['install_alfviral_repo']

}
