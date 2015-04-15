{% from "mongodb/map.jinja" import ms with context %}

mongos_package:
{% if ms.use_ppa or ms.use_repo %}
  {% set os = salt['grains.get']('os')|lower %}
  {% set code = salt['grains.get']('oscodename') %}
  pkgrepo.managed:
    - humanname: MongoDB.org Repo
    - name: deb http://repo.mongodb.org/apt/{{ os }} {{ code }}/mongodb-org/stable main
    - file: /etc/apt/sources.list.d/mongodb.list
    - keyid: 7F0CEB10
    - keyserver: keyserver.ubuntu.com
{% endif %}
  pkg.installed:
     - name: {{ ms.mongos_package }}

mongos_log_file:
  file.directory:
    - name: {{ ms.log_path }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

mongos_init:
  file.managed:
    - name: /etc/init/mongos.conf
    - source: salt://mongodb/files/mongos.upstart.conf.jinja
    - template: jinja

mongos_service:
  service.running:
    - name: {{ ms.mongos }}
    - enable: True
    - watch:
      - file: mongos_configuration

mongos_configuration:
  file.managed:
    - name: {{ ms.conf_path }}
    - user: root
    - group: root
    - mode: 644
    - source: salt://mongodb/files/mongos.conf.jinja
    - template: jinja
