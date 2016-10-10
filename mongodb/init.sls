# This setup for mongodb assumes that the replica set can be determined from
# the id of the minion

{%- from 'mongodb/map.jinja' import mdb with context -%}

{%- if mdb.use_repo %}

  {%- if grains['os_family'] == 'Debian' %}

    {%- set os   = salt['grains.get']('os') | lower() %}
    {%- set code = salt['grains.get']('oscodename') %}

mongodb_repo:
  pkgrepo.managed:
    - humanname: MongoDB.org Repository
    - name: deb http://repo.mongodb.org/apt/{{ os }} {{ code }}/mongodb-org/{{ mdb.version }} {{ mdb.repo_component }}
    - file: /etc/apt/sources.list.d/mongodb-org.list
    - keyid: {{ mdb.keyid }}
    - keyserver: keyserver.ubuntu.com

  {%- elif grains['os_family'] == 'RedHat' %}

mongodb_repo:
  pkgrepo.managed:
    {%- if mdb.version == 'stable' %}
    - name: mongodb-org
    - humanname: MongoDB.org Repository
    - gpgkey: https://www.mongodb.org/static/pgp/server-3.2.asc
    - baseurl: https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/{{ mdb.version }}/$basearch/
    - gpgcheck: 1
    {%- elif mdb.version == 'oldstable' %}
    - name: mongodb-org-{{ mdb.version }}
    - humanname: MongoDB oldstable Repository
    - baseurl: http://downloads-distro.mongodb.org/repo/redhat/os/$basearch/
    - gpgcheck: 0
    {%- else %}
    - name: mongodb-org-{{ mdb.version }}
    - humanname: MongoDB {{ mdb.version | capitalize() }} Repository
    - gpgkey: https://www.mongodb.org/static/pgp/server-{{ mdb.version }}.asc
    - baseurl: https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/{{ mdb.version }}/$basearch/
    - gpgcheck: 1
    {%- endif %}
    - disabled: 0

  {%- endif %}

{%- endif %}

mongodb_package:
  pkg.installed:
    - name: {{ mdb.mongodb_package }}

mongodb_log_path:
  file.directory:
    {%- if 'mongod_settings' in mdb %}
    - name: {{ salt['file.dirname'](mdb.mongod_settings.systemLog.path) }}
    {%- else %}
    - name: {{ mdb.log_path }}
    {%- endif %}
    - user: {{ mdb.mongodb_user }}
    - group: {{ mdb.mongodb_group }}
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group

mongodb_db_path:
  file.directory:
    {%- if 'mongod_settings' in mdb %}
    - name: {{ mdb.mongod_settings.storage.dbPath }}
    {%- else %}
    - name: {{ mdb.db_path }}
    {%- endif %}
    - user: {{ mdb.mongodb_user }}
    - group: {{ mdb.mongodb_group }}
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group

mongodb_config:
  file.managed:
    - name: {{ mdb.conf_path }}
    - source: salt://mongodb/files/mongodb.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

mongodb_service:
  service.running:
    - name: {{ mdb.mongod }}
    - enable: True
    - watch:
      - file: mongodb_config
