mongodb:
  use_repo: True
  version: 3.4
  repo_component: multiverse    # this is for Ubuntu, use 'main' for Debian
  mongodb_package: mongodb-org
  mongodb_user: mongodb
  mongodb_group: mongodb
  mongod: mongod
  conf_path: /etc/mongod.conf
  log_path: /mongodb/log
  db_path: /mongodb/data
  mongod_settings:
    systemLog:
      destination: file
      logAppend: true
      path: /var/log/mongodb/mongod.log
    storage:
      dbPath: /var/lib/mongodb
      journal:
        enabled: true
    net:
      port: 27017
      bindIp: 0.0.0.0
    setParameter:
      textSearchEnabled: true
