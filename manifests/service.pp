class portal_alfresco::service {
    service {'alfresco':
      ensure => running
    }
}