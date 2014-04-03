class portal_alfresco::startscript {

  # onlyif condition checks to see if we're running.
  exec {'start_alfresco':
    command => "${portal_alfresco::alfresco_install_path}/alfresco.sh start",
    onlyif  => "${portal_alfresco::alfresco_install_path}/alfresco.sh status |grep 'not running'"
  }

}
