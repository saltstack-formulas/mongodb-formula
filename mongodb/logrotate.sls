mongodb_logrotate:
  file.managed:
    - name: /etc/logrotate.d/mongodb
    - user: root
    - group: root
    - mode: 440
    - source: salt://mongodb/files/logrotate
