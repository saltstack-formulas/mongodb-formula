mongodb:
  pkg:
     - latest
     - name: mongodb
  file:
    - managed
    - name: /etc/logrotate.d/mongodb
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://mongodb/files/logrotate.jinja
  service:
     - running
     - enable: True
     - watch:
       - pkg: mongodb
