##mongodb/bic/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from 'mongodb/map.jinja' import mongodb with context %}

   {%- if mongodb.system.use_firewalld %}
mongodb bic clean firewalld service running:
  service.running:
    - name: firewalld
    - enable: True
   {%- endif %}

{%- for svc in ('mongosqld',) %}

  {%- if "processManagement" in mongodb.bic[svc]['conf'] and mongodb.bic[svc]['conf']['processManagement']['pidFilePath'] %}
     {%- set pidpath = mongodb.bic[svc]['conf']['processManagement']['pidFilePath'] %}
  {%- else %}
     {%- set pidpath = mongodb.system.pidpath %}
  {%- endif %}

mongodb bic {{ svc }} cleanup:
  service.dead:
    - name: {{ mongodb.bic[svc]['service'] }}
  file.absent:
    - names:
      - {{ pidpath }}
      - /etc/logrotate.d/mongodb_{{ svc }}
      - {{ mongodb.bic[svc]['systemd']['file'] }}
      - {{ mongodb.bic[svc]['conf_path'] }}
      - /Library/LaunchAgents/org.mongo.{{ svc }}.plist
      - /Library/LaunchAgents/org.mongo.mongodb.{{ svc }}.plist
      - {{ salt['file.dirname'](mongodb.bic[svc]['conf']['systemLog']['path']) }}
     {%- if "storage" in mongodb.bic[svc]['conf'] and "dbPath" in mongodb.bic[svc]['conf']['storage'] %}
      - {{ mongodb.bic[svc]['conf']['storage']['dbPath'] }}
     {%- endif %}
     {%- if "schema" in mongodb.bic[svc]['conf'] and "path" in mongodb.bic[svc]['conf']['schema'] %}
      - {{ salt['file.dirname']( mongodb.bic[svc]['conf']['schema']['path']) }}
     {%- endif %}
     {%- if grains.os in ('MacOS',) %}
      - {{ mongodb.system.userhome }}/{{ mongodb.system.user }}/Desktop/MongoDB ({{ svc }})
     {%- endif %}
   {%- if mongodb.system.use_firewalld %}
  cmd.run:
    - names:
      - firewall-cmd --remove-service {{ svc }} --permanent
      - firewall-cmd --remove-port={{ mongodb.bic[svc]['conf']['net']['port'] }}/tcp --permanent
      - firewall-cmd --reload
    - require:
      - service: mongodb bic clean firewalld service running

  {%- endif %}
{%- endfor %}

mongodb bic cleanup:
  file.absent:
    - names:
      - {{ mongodb.system.prefix }}/{{ mongodb.bic.dirname }}
      - {{ mongodb.bic.binpath }}
      - {{ mongodb.dl.tmpdir }}/{{ mongodb.bic.name }}
      - /etc/logrotate.d/mongodb-bic
      - /tmp/mac_shortcut.sh
  user.absent:
    - name: {{ mongodb.bic.user }}
  group.absent:
    - name: {{ mongodb.bic.group }}

