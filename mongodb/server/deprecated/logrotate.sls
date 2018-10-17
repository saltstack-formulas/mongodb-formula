##mongodb/database/depreciated/logrotate.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

## DEPRECIATED. See config.sls and clean.sls

mongodb_logrotate:
  file.managed:
    - name: /etc/logrotate.d/mongodb
    - unless: ls /etc/logrotate.d/mongodb-server
    - user: root
    - group: root
    - mode: 440
    - source: salt://mongodb/files/depreciated/logrotate
