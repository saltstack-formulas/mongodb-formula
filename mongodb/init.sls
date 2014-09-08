# This setup for mongodb assumes that the replica set can be determined from
# the id of the minion
# NOTE: Currently this will not work behind a NAT in AWS VPC.
# see http://lodge.glasgownet.com/2012/07/11/apt-key-from-behind-a-firewall/comment-page-1/ for details
{% from "mongodb/map.jinja" import mongodb with context %}

{% set version        = salt['pillar.get']('mongodb:version', '2.6.4') %}
{% set package_name   = salt['pillar.get']('mongodb:package_name', "mongodb-10gen") %}

{% if version is not none %}

{% set settings       = salt['pillar.get']('mongodb:settings', {}) %}
{% set replica_set    = salt['pillar.get']('mongodb:replica_set', {}) %}
{% set config_svr     = salt['pillar.get']('mongodb:config_svr', False) %}
{% set shard_svr      = salt['pillar.get']('mongodb:shard_svr', False) %}
{% set use_ppa        = salt['pillar.get']('mongodb:use_ppa', none) %}
{% set db_path        = settings.get('db_path', '/data/db') %}
{% set log_path       = settings.get('log_path', '/var/log/mongodb') %}

include:
  - .tools

mongodb_package:
{% if use_ppa %}
  pkgrepo.managed:
    - humanname: MongoDB PPA
    - name: deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen
    - file: /etc/apt/sources.list.d/mongodb.list
    - keyid: 7F0CEB10
    - keyserver: keyserver.ubuntu.com
  pkg.installed:
    - name: {{ package_name }}
    - version: {{ version }}
{% else %}
  pkg.installed:
     - name: mongodb
{% endif %}

mongodb_db_path:
  file.directory:
    - name: {{ db_path }}
    - user: mongodb
    - group: mongodb
    - mode: 755
    - makedirs: True
    - recurse:
        - user
        - group

mongodb_log_path:
  file.directory:
    - name: {{ log_path }}
    - user: mongodb
    - group: mongodb
    - mode: 755
    - makedirs: True

mongodb_service:
  service.running:
    - name: {{ mongodb.mongod }}
    - enable: True
    - watch:
      - file: mongodb_configuration

mongodb_configuration:
  file.managed:
    - name: {{ mongodb.conf_path }}
    - user: root
    - group: root
    - mode: 644
    - source: salt://mongodb/files/mongodb.conf.jinja
    - template: jinja
    - context:
        dbpath: {{ db_path }}
        logpath: {{ log_path }}
        port: {{ settings.get('port', 27017) }}
        bind_ip: {{ settings.get('bind_ip', "127.0.0.1") }}
        replica_set: {{ replica_set }}
        config_svr: {{ config_svr }}
        shard_svr: {{ shard_svr }}

mongodb_logrotate:
  file.managed:
    - name: /etc/logrotate.d/mongodb
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://mongodb/files/logrotate.jinja

{% endif %}
