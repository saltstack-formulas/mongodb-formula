##mongodb/server/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from 'mongodb/map.jinja' import mongodb with context %}

   {%- if mongodb.system.use_firewalld %}
mongodb server clean firewalld service running:
  service.running:
    - name: firewalld
    - enable: True
   {%- endif %}

{%- for svc in ('mongod', 'mongos',) %}

  {%- if "processManagement" in mongodb.server[svc]['conf'] and mongodb.server[svc]['conf']['processManagement']['pidFilePath'] %}
     {%- set pidpath = mongodb.server[svc]['conf']['processManagement']['pidFilePath'] %}
  {%- else %}
     {%- set pidpath = mongodb.system.pidpath %}
  {%- endif %}

mongodb server {{ svc }} cleanup:
  service.dead:
    - name: {{ mongodb.server[svc]['service'] }}
  file.absent:
    - names:
      - {{ pidpath }}
      - /etc/logrotate.d/mongodb_{{ svc }}
      - {{ mongodb.server[svc]['systemd']['file'] }}
      - {{ mongodb.server[svc]['conf_path'] }}
      - /Library/LaunchAgents/org.mongo.{{ svc }}.plist
      - /Library/LaunchAgents/org.mongo.mongodb.{{ svc }}.plist
      - {{ salt['file.dirname'](mongodb.server[svc]['conf']['systemLog']['path']) }}
     {%- if "storage" in mongodb.server[svc]['conf'] and "dbPath" in mongodb.server[svc]['conf']['storage'] %}
      - {{ mongodb.server[svc]['conf']['storage']['dbPath'] }}
     {%- endif %}
      - {{ salt['file.dirname'](mongodb.server[svc]['conf']['systemLog']['path']) }}
     {%- if "schema" in mongodb.server[svc]['conf'] and "path" in mongodb.server[svc]['conf']['schema'] %}
      - {{ salt['file.dirname']( mongodb.server[svc]['conf']['schema']['path']) }}
     {%- endif %}
     {%- if grains.os in ('MacOS',) %}
      - {{ mongodb.system.userhome }}/{{ mongodb.system.user }}/Desktop/MongoDB ({{ svc }})
     {%- endif %}
   {%- if mongodb.system.use_firewalld %}
  cmd.run:
    - names:
      - firewall-cmd --remove-service {{ svc }} --permanent
      - firewall-cmd --remove-port={{ mongodb.server[svc]['conf']['net']['port'] }}/tcp --permanent
      - firewall-cmd --reload
    - require:
      - service: mongodb server clean firewalld service running

   {%- endif %}
{%- endfor %}

mongodb server cleanup:
  pip.removed:
    - name: pymongo
  file.absent:
    - names:
      - {{ mongodb.server.shell.mongorc }} 
      - {{ mongodb.system.prefix }}/{{ mongodb.server.dirname }}
      - {{ mongodb.dl.tmpdir }}/{{ mongodb.server.arcname }}
      - /etc/logrotate.d/mongodb-mongod
      - /etc/logrotate.d/mongodb-mongos
      - /etc/logrotate.d/mongodb-server
      - /tmp/mac_shortcut.sh
      - /etc/init.d/disable-transparent-hugepages
  user.absent:
    - name: {{ mongodb.server.user }}
  group.absent:
    - name: {{ mongodb.server.group }}

