{% from "mongodb/map.jinja" import ms with context %}

mongos_package:
{% if ms.use_ppa is not none %}
  pkgrepo.managed:
    - humanname: MongoDB PPA
    - name: deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen
    - file: /etc/apt/sources.list.d/mongodb.list
    - keyid: 7F0CEB10
    - keyserver: keyserver.ubuntu.com
  pkg.installed:
    - name: {{ ms.repo_package_name }}
{% else %}
  pkg.installed:
    - name: {{ ms.package_name }}
{% endif %}

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

mongos_init_d:
  file.managed:
    - name: /etc/init.d/mongos
    - source: salt://mongodb/mongos/files/init.d/mongos.jinja
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
