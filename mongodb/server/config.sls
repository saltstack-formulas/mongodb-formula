##mongodb/server/config.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from 'mongodb/map.jinja' import mongodb with context %}

   {%- if mongodb.system.use_selinux %}
mongodb server selinux packages:
  pkg.installed:
    - names:
      - policycoreutils-python
      - selinux-policy-targeted
    - refresh: True
   {%- endif %}

   {%- if mongodb.system.use_firewalld %}
mongodb server firewalld service:
  service.running:
    - name: firewalld
    - enable: True
   {%- endif %}

mongodb server user and group present:
  group.present:
    - name: {{ mongodb.server.group }}
  user.present:
    - name: {{ mongodb.server.user }}
    - fullname: mongoDB user
    - shell: /bin/bash
    - createhome: False
    {%- if grains.os != 'MacOS' %}
    - groups:
      - {{ mongodb.server.group }}
    {%- endif %}

mongodb server tools pypip package:
  pkg.installed:
    - name: {{ mongodb.system.pip }}
    - unless: test "`uname`" = "Darwin"

mongodb server tools pymongo package:
  pip.installed:
    - name: pymongo
    - reload_modules: True
    - require:
      - pkg: mongodb server tools pypip package

{%- for svc in ('mongod', 'mongos',) %}

  {%- if "processManagement" in mongodb.server[svc]['conf'] and mongodb.server[svc]['conf']['processManagement']['pidFilePath'] %}
     {%- set pidpath = salt['file.pkgname']( mongodb.server[svc]['conf']['processManagement']['pidFilePath']) %}
  {%- else %}
     {%- set pidpath = mongodb.system.pidpath %}
  {%- endif %}

mongodb server {{ svc }} logpath:
  file.directory:
    - name: {{ salt['file.pkgname'](mongodb.server[svc]['conf']['systemLog']['path']) }}
    - user: {{ mongodb.server.user }}
    - group: {{ mongodb.server.group }}
    - dir_mode: '0775'
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - user: mongodb server user and group present
   {%- if mongodb.system.use_selinux %}
  selinux.fcontext_policy_present:
    - name: '{{ salt['file.pkgname'](mongodb.server[svc]['conf']['systemLog']['path']) }}(/.*)?'
    - sel_type: mongod_log_t
    - require_in:
      - selinux: mongodb server {{ svc }} service running
   {%- endif %}

   {%- if "storage" in mongodb.server[svc]['conf'] and "dbPath" in mongodb.server[svc]['conf']['storage'] %}

mongodb server {{ svc }} datapath:
  file.directory:
    - name: {{ mongodb.server[svc]['conf']['storage']['dbPath'] }}
    - user: {{ mongodb.server.user }}
    - group: {{ mongodb.server.group }}
    - dir_mode: '0775'
    - makedirs: True
    - recurse:
      - user
      - group
    - require:
      - user: mongodb server user and group present
     {%- if mongodb.system.use_selinux %}
  selinux.fcontext_policy_present:
    - name: '{{ salt['file.pkgname'](mongodb.server[svc]['conf']['storage']['dbPath']) }}(/.*)?'
    - sel_type: mongod_var_lib_t
    - require_in:
      - selinux: mongodb server {{ svc }} service running
     {%- endif %}

    {%- endif %}

mongodb server {{ svc }} config:
  file.managed:
    - name: {{ mongodb.server[svc]['conf_path'] }}
    - source: salt://mongodb/files/service.conf.jinja
    - template: jinja
    - user: root
    - group: {{ 'wheel' if grains.os in ('MacOS',) else 'root' }}
    - mode: '0644'
    - makedirs: True
    - context:
        svc: {{ svc }}
        component: 'server'
        mongodb: {{ mongodb|json }}
    - require:
      - user: mongodb server user and group present
   {%- if mongodb.system.use_selinux %}
  selinux.fcontext_policy_present:
    - name: '{{ mongodb.server[svc]['conf_path'] }}(/.*)?'
    - sel_type: etc_t
    - require_in:
      - selinux: mongodb server {{ svc }} service running
   {%- endif %}

{%- if mongodb.server.use_schema and "schema" in mongodb.server[svc]['conf'] and mongodb.server[svc]['conf']['schema']['path'] %}

mongodb server {{ svc }} schema path:
  file.directory:
    - name: {{ mongodb.server[svc]['conf']['schema']['path'] }}
    - user: {{ mongodb.server.user }}
    - group: {{ mongodb.server.group }}
    - dir_mode: '0755'
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
    - require:
      - user: mongodb server user and group present

   {%- if mongodb.system.use_selinux %}

  selinux.fcontext_policy_present:
    - name: {{ salt['file.pkgname']( mongodb.server[svc]['conf']['schema']['path']) }}
    - sel_type: etc_t
    - require_in:
      - selinux: mongodb server {{ svc }} service running

   {%- endif %}
{%- endif %}

mongodb server {{ svc }} logrotate add:
  file.managed:
    - name: /etc/logrotate.d/mongodb_{{ svc }}
    - unless: ls /etc/logrotate.d/mongodb_{{ svc }}
    - user: root
    - group: {{ 'wheel' if grains.os in ('MacOS',) else 'root' }}
    - mode: '0440'
    - makedirs: True
    - source: salt://mongodb/files/logrotate.jinja
    - context:
        svc: {{ svc }}
        pattern: {{ mongodb.server[svc]['conf']['systemLog']['path'] }}
        pidpath: {{ pidpath }}
        days: 7
   {%- if mongodb.system.use_selinux %}
  selinux.fcontext_policy_present:
    - name: '/etc/logrotate.d/mongodb_{{ svc }}(/.*)?'
    - sel_type: etc_t
    - require_in:
      - selinux: mongodb server {{ svc }} service running

   {%- endif %}

mongodb server {{ svc }} pidpath add:
  file.directory:
    - name: {{ pidpath }}
    - user: {{ mongodb.server.user }}
    - group: {{ mongodb.server.group }}
    - dir_mode: '0755'
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
    - require:
      - user: mongodb server user and group present
   {%- if mongodb.system.use_selinux %}
  selinux.fcontext_policy_present:
    - name: {{ pidpath }}
    - sel_type: mongod_var_run_t
    - require_in:
      - selinux: mongodb server {{ svc }} service running

   {%- endif %}
   {%- if grains.os in ('MacOS',) %}

mongodb server {{ svc }} launchd service file:
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
        binpath: {{ mongodb.server.binpath }}
        config: {{ mongodb.server[svc]['conf_path'] }}
    - require_in:
      - service: mongodb server {{ svc }} service running

       {%- if mongodb.server[svc]['shortcut'] %}

mongodb server {{ svc }} desktop shortcut clean:
  file.absent:
    - name: '{{ mongodb.userhome }}/{{ mongodb.system.user }}/Desktop/MongoDB ({{ svc }})'
    - onlyif: test -f {{ mongodb.userhome }}/{{ mongodb.system.user }}/Desktop/MongoDB ({{ svc }})
    - require_in:
      - file: mongodb server {{ svc }} desktop shortcut add

mongodb server {{ svc }} desktop shortcut add:
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
    - name: '/tmp/mac_shortcut.sh "MongoDB ({{ mongodb.server.use_repo }})"'
    - runas: {{ mongodb.system.user }}
    - require:
      - file: mongodb server {{ svc }} desktop shortcut add

        {%- endif %}
    {%- elif grains.os not in ('Windows',) %}

mongodb server {{ svc }} transparent huge pages:
  file.managed:
    - name: /etc/init.d/disable-transparent-hugepages
    - source: salt://mongodb/files/disable-transparent-hugepages.init
    - unless: test -f /etc/init.d/disable-transparent-hugepages
    - onlyif: {{ mongodb.server.disable_transparent_hugepages and loop.index == 1 }}
    - mode: '0755'
    - makedirs: True
    - require_in:
      - mongodb server {{ svc }} service
  cmd.run:
    - name: echo never >/sys/kernel/mm/transparent_hugepage/enabled
    - onlyif: {{ mongodb.server.disable_transparent_hugepages and loop.index == 1 }}

mongodb server {{ svc }} systemd service file:
  file.managed:
    - name: {{ mongodb.server[svc]['systemd']['file'] }}
    - source: salt://mongodb/files/mongodb.service.jinja
    - mode: '0644'
    - template: jinja
    - makedirs: True
    - context:
        svc: {{ svc }}
        pidpath: {{ pidpath }}
        binpath: {{ mongodb.server.binpath }} #don't change me
        mongodb: {{ mongodb.server|json }}

       {%- if mongodb.system.use_firewalld %}
  firewalld.service:
    - name: {{ svc }}
    - ports:
      - {{ mongodb.server[svc]['conf']['net']['port'] }}/tcp
    - require:
      - service: mongodb server firewalld service
      {%- endif %}
    - require_in:
      - service: mongodb server {{ svc }} service running

    {%- endif %}

mongodb server {{ svc }} service running:

      {%- if mongodb.system.use_selinux %}
  selinux.fcontext_policy_applied:
    - names:
    {%- if "storage" in mongodb.server[svc]['conf'] and "dbPath" in mongodb.server[svc]['conf']['storage'] %}
      - {{ mongodb.server[svc]['conf']['storage']['dbPath'] }}
    {%- endif %}
      - {{ salt['file.pkgname'](mongodb.server[svc]['conf']['systemLog']['path']) }}
      - {{ pidpath }}
      - {{ mongodb.server[svc]['conf_path'] }}
      - /etc/logrotate.d/mongodb_{{ svc }}
 {%- if mongodb.server.use_schema and "schema" in mongodb.server[svc]['conf'] and mongodb.server[svc]['conf']['schema']['path'] %}
      - {{ salt['file.pkgname']( mongodb.server[svc]['conf']['schema']['path']) }}
 {%- endif %}
    - recursive: True
    - require:
      - pkg: mongodb server selinux packages

     {%- endif %}
     {%- if mongodb.system.use_firewalld %}
  cmd.run:
    - names:
      - firewall-cmd --add-service {{ svc }} --permanent
      - firewall-cmd --add-port={{ mongodb.server[svc]['conf']['net']['port'] }}/tcp --permanent
      - firewall-cmd --reload
    - require:
      - service: mongodb server firewalld service

     {%- endif %}

  service.running:
    - name: {{ mongodb.server[svc]['service'] }}
    - enable: True
    - watch:
      - file: mongodb server {{ svc }} config

     {%- if mongodb.server.shell.mongorc and loop.index == 1 %}

mongodb server shell etc mongorc add:
  file.managed:
    - name: {{ mongodb.server.shell.mongorc }}
    - unless: test -f {{ mongodb.server.shell.mongorc }}
    - user: {{ mongodb.server.user }}
    - group: {{ mongodb.server.group }}
    - mode: '0644'
    - source: salt://mongodb/files/mongorc.js.jinja
    - template: jinja
    - makedirs: True
    - context:
        svc: {{ svc }}
    - require:
      - user: mongodb server user and group present

     {%- endif %}
{%- endfor %}
