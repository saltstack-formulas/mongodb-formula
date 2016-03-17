{%- from "mongodb/map.jinja" import ms with context -%}

mongos_package:
{%- if ms.use_repo %}
  {%- set os = salt['grains.get']('os') | lower() %}
  {%- set code = salt['grains.get']('oscodename') %}
  pkgrepo.managed:
    - humanname: MongoDB.org Repo
    - name: deb http://repo.mongodb.org/apt/{{ os }} {{ code }}/mongodb-org/stable multiverse
    - file: /etc/apt/sources.list.d/mongodb-org.list
    - keyid: EA312927
    - keyserver: keyserver.ubuntu.com
{%- endif %}
  pkg.installed:
    - name: {{ ms.mongos_package }}

mongodb_user:
  user.present:
    - name: mongodb
    - gid_from_name: True
    - home: {{ ms.log_path }}
    - shell: /bin/sh
    - system: True

mongos_log_path:
  file.directory:
    - name: {{ ms.log_path }}
    - user: mongodb
    - group: mongodb
    - mode: 755
    - makedirs: True

mongos_init:
  file.managed:
    - name: /etc/init/mongos.conf
    - source: salt://mongodb/files/mongos.upstart.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

mongos_config:
  file.managed:
    - name: {{ ms.conf_path }}
    - source: salt://mongodb/files/mongos.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

mongos_service:
  service.running:
    - name: {{ ms.mongos }}
    - enable: True
    - watch:
      - file: mongos_config
