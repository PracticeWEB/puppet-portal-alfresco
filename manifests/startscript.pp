class portal_alfresco::startscript {
  # TODO check for running
  # if not 
  exec {"start_alfresco":
    command => "${portal_alfresco::alfresco_install_path}/alfresco.sh start",
    onlyif => "${portal_alfresco::alfresco_install_path}/alfresco.sh status |grep 'not running'"
  }
  
}