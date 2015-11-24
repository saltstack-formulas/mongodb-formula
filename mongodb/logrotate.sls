mongodb_logrotate:
  file.managed:
    - name: /etc/logrotate.d/mongodb
    - unless: ls /etc/logrotate.d/mongodb-server
    - user: root
    - group: root
    - mode: 440
    - source: salt://mongodb/files/logrotate
