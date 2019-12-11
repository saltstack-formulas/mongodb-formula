##mongodb/bic/config.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from 'mongodb/map.jinja' import mongodb with context %}

   {%- if mongodb.system.use_selinux %}
mongodb bic selinux packages:
  pkg.installed:
    - names:
      - policycoreutils-python
      - selinux-policy-targeted
    - refresh: True
   {%- endif %}

   {%- if mongodb.system.use_firewalld %}
mongodb bic firewalld service:
  service.running:
    - name: firewalld
    - enable: True
   {%- endif %}

mongodb bic user and group present:
  group.present:
    - name: {{ mongodb.bic.group }}
  user.present:
    - name: {{ mongodb.bic.user }}
    - fullname: mongoDB user
    - shell: /bin/bash
    - createhome: False
        {%- if grains.os != 'MacOS' %}
    - groups:
      - {{ mongodb.bic.group }}
        {%- endif %}

mongodb bic tools pypip package:
  pkg.installed:
    - name: {{ mongodb.system.pip }}
    - unless: test "`uname`" = "Darwin"

{%- for svc in ('mongosqld',) %}

   {%- if "processManagement" in mongodb.bic[svc]['conf'] and mongodb.bic[svc]['conf']['processManagement']['pidFilePath'] %}
      {%- set pidpath = salt['file.dirname']( mongodb.bic[svc]['conf']['processManagement']['pidFilePath']) %}
   {%- else %}
      {%- set pidpath = mongodb.system.pidpath %}
   {%- endif %}

mongodb bic {{ svc }} logpath:
  file.directory:
    - name: {{ salt['file.dirname'](mongodb.bic[svc]['conf']['systemLog']['path']) }}
    - user: {{ mongodb.bic.user }}
    - group: {{ mongodb.bic.group }}
    - dir_mode: '0775'
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - user: mongodb bic user and group present
   {%- if mongodb.system.use_selinux %}
  selinux.fcontext_policy_present:
    - name: '{{ salt['file.dirname'](mongodb.bic[svc]['conf']['systemLog']['path']) }}(/.*)?'
    - sel_type: mongod_log_t
    - require_in:
      - selinux: mongodb bic {{ svc }} service running
   {%- endif %}

mongodb bic {{ svc }} config:
  file.managed:
    - name: {{ mongodb.bic[svc]['conf_path'] }}
    - source: salt://mongodb/files/service.conf.jinja
    - template: jinja
    - user: root
    - group: {{ 'wheel' if grains.os in ('MacOS',) else 'root' }}
    - mode: '0644'
    - makedirs: True
    - context:
        svc: {{ svc }}
        component: 'bic'
        mongodb: {{ mongodb|json }}
    - require:
      - user: mongodb bic user and group present

   {%- if mongodb.system.use_selinux %}

  selinux.fcontext_policy_present:
    - name: '{{ mongodb.bic[svc]['conf_path'] }}(/.*)?'
    - sel_type: etc_t
    - require_in:
      - selinux: mongodb bic {{ svc }} service running
   {%- endif %}


  {%- if mongodb.bic.use_schema and "schema" in mongodb.bic[svc]['conf'] and mongodb.bic[svc]['conf']['schema']['path'] %}

mongodb bic {{ svc }} schema path:
  file.directory:
    - name: {{ mongodb.bic[svc]['conf']['schema']['path'] }}
    - user: {{ mongodb.bic.user }}
    - group: {{ mongodb.bic.group }}
    - dir_mode: '0755'
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
    - require:
      - user: mongodb bic user and group present

     {%- if mongodb.system.use_selinux %}

  selinux.fcontext_policy_present:
    - name: {{ salt['file.dirname']( mongodb.bic[svc]['conf']['schema']['path']) }}
    - sel_type: etc_t
    - require_in:
      - selinux: mongodb bic {{ svc }} service running

     {%- endif %}
  {%- endif %}

mongodb bic {{ svc }} logrotate add:
  file.managed:
    - name: /etc/logrotate.d/mongodb_{{ svc }}
    - unless: ls /etc/logrotate.d/mongodb_{{ svc }}
    - user: root
    - group: {{ 'wheel' if grains.os in ('MacOS',) else 'root' }}
    - mode: '0440'
    - source: salt://mongodb/files/logrotate.jinja
    - makedirs: True
    - context:
        svc: {{ svc }}
        pattern: {{ mongodb.bic[svc]['conf']['systemLog']['path'] }}
        days: 7
   {%- if mongodb.system.use_selinux %}
  selinux.fcontext_policy_present:
    - name: '/etc/logrotate.d/mongodb_{{ svc }}(/.*)?'
    - sel_type: etc_t
    - require_in:
      - selinux: mongodb bic {{ svc }} service running

   {%- endif %}

mongodb bic {{ svc }} pidpath add:
  file.directory:
    - name: {{ pidpath }}
    - user: {{ mongodb.bic.user }}
    - group: {{ mongodb.bic.group }}
    - dir_mode: '0755'
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
    - require:
      - user: mongodb bic user and group present
   {%- if mongodb.system.use_selinux %}
  selinux.fcontext_policy_present:
    - name: {{ pidpath }}
    - sel_type: mongod_var_run_t
    - require_in:
      - selinux: mongodb bic {{ svc }} service running

   {%- endif %}
   {%- if grains.os in ('MacOS',) %}

mongodb bic {{ svc }} launchd service file:
  file.managed:
    - name: /Library/LaunchAgents/org.mongo.mongodb.{{ svc }}.plist
    - source: salt://mongodb/files/mongodb.plist.jinja
    - mode: '0644'
    - user: root
    - group: wheel
    - template: jinja
    - makedirs: True
    - context:
        svc: {{ svc }}
        config: {{ mongodb.bic[svc]['conf_path'] }}
        binpath: {{ mongodb.bic.binpath }}
    - require_in:
      - service: mongodb bic {{ svc }} service running

       {%- if mongodb.bic[svc]['shortcut'] %}

mongodb bic {{ svc }} desktop shortcut clean:
  file.absent:
    - name: '{{ mongodb.userhome }}/{{ mongodb.system.user }}/Desktop/MongoDB ({{ svc }})'
    - onlyif: test -f {{ mongodb.userhome }}/{{ mongodb.system.user }}/Desktop/MongoDB ({{ svc }})
    - require_in:
      - file: mongodb bic {{ svc }} desktop shortcut add

mongodb bic {{ svc }} desktop shortcut add:
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://mongodb/templates/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - makedirs: True
    - context:
      user: {{ mongodb.system.user }}
      home: {{ mongodb.userhome }}
  cmd.run:
    - name: '/tmp/mac_shortcut.sh "MongoDB ({{ mongodb.bic.use_repo }})"'
    - runas: {{ mongodb.system.user }}
    - require:
      - file: mongodb bic {{ svc }} desktop shortcut add

        {%- endif %}
    {%- elif grains.os not in ('Windows',) %}

mongodb bic {{ svc }} systemd service file:
  file.managed:
    - name: {{ mongodb.bic[svc]['systemd']['file'] }}
    - source: salt://mongodb/files/mongodb.service.jinja
    - mode: '0644'
    - template: jinja
    - makedirs: True
    - context:
        svc: {{ svc }}
        binpath: {{ mongodb.bic.binpath }} #don't change me
        mongodb: {{ mongodb.bic|json }}
        pidpath: {{ pidpath }}

        {%- if mongodb.system.use_firewalld %}
  firewalld.service:
    - name: {{ svc }}
    - ports:
      - {{ mongodb.bic[svc]['conf']['net']['port'] }}/tcp
    - require:
      - service: mongodb bic firewalld service
         {%- endif %}
    - require_in:
      - service: mongodb bic {{ svc }} service running

    {%- endif %}

mongodb bic {{ svc }} service running:

      {%- if mongodb.system.use_selinux %}
  selinux.fcontext_policy_applied:
    - names:
      - {{ salt['file.dirname'](mongodb.bic[svc]['conf']['systemLog']['path']) }}
      - {{ mongodb.bic[svc]['conf_path'] }}
      - {{ pidpath }}
      - /etc/logrotate.d/mongodb_{{ svc }}
      {%- if mongodb.bic.use_schema and "schema" in mongodb.bic[svc]['conf'] and mongodb.bic[svc]['conf']['schema']['path'] %}
      - {{ salt['file.dirname']( mongodb.bic[svc]['conf']['schema']['path']) }}
      {%- endif %}
    - recursive: True
    - require:
      - pkg: mongodb bic selinux packages

     {%- endif %}
     {%- if mongodb.system.use_firewalld %}
  cmd.run:
    - names:
      - firewall-cmd --add-service {{ svc }} --permanent
      - firewall-cmd --add-port={{ mongodb.bic[svc]['conf']['net']['port'] }}/tcp --permanent
      - firewall-cmd --reload
    - require:
      - service: mongodb bic firewalld service

     {%- endif %}

  service.running:
    - name: {{ mongodb.bic[svc]['service'] }}
    - enable: True
    - watch:
      - file: mongodb bic {{ svc }} config

{%- endfor %}
