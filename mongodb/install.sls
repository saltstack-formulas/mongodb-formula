# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- set sls_config_users = tplroot ~ '.config.users' %}
{%- set formula = d.formula %}

include:
  - {{ sls_config_users }}

{{ formula }}-install-prerequisites:
  pkg.installed:
    - names: {{ d.pkg.deps|json }}
  pip.installed:
    - names: {{ d.pkg.pips|json }}
    - reload_modules: True
    - require:
      - pkg: {{ formula }}-install-prerequisites
  file.directory:
    - names:
      - {{ d.dir.var }}
      - {{ d.dir.tmp }}
    - user: root
    - group: {{ d.identity.rootgroup }}
    - mode: '0755'
    - makedirs: True
    - require:
      - pkg: {{ formula }}-install-prerequisites
      - pip: {{ formula }}-install-prerequisites

    {%- for comp in d.components %}
        {%- if comp in d.wanted and d.wanted is iterable and comp in d.pkg and d.pkg[comp] is mapping %}
            {%- for name,v in d.pkg[comp].items() %}
                {%- if name in d.wanted[comp] %}
                    {%- set software = d.pkg[comp][name] %}
                    {%- set package = software.package_format %}
                    {%- if package in d.use_upstream %}

                            {# DOWNLOAD NATIVE PACKAGE #}

                        {%- if package != 'archive' and package in software and software[package] is mapping %}
                            {%- if 'source' in software[package] %}

{{ formula }}-{{ comp }}-{{ name }}-{{ package }}-download:
  cmd.run:
    - name: curl -Lo  {{ d.dir.tmp ~ '/' ~ comp ~ name ~ software['version'] }} {{ software[package]['source'] }}
    - unless: test -f {{ d.dir.tmp ~ '/' ~ comp ~ name ~ software['version'] }}
    - retry: {{ d.retry_option|json }}
    - require:
      - file: {{ formula }}-install-prerequisites
    - require_in:
      - {{ formula }}-{{ comp }}-{{ name }}-{{ package }}-install
                                {%- if 'source_hash' in software[package] %}
  module.run:
    - name: file.check_hash
    - path: {{ d.dir.tmp ~ '/' ~ comp ~ name ~ software['version'] }}
    - file_hash: {{ software[package]['source_hash'] }}
  file.absent:
    - name: {{ d.dir.tmp ~ '/' ~ comp ~ name ~ software['version'] }}
    - onfail:
      - module: {{ formula }}-{{ comp }}-{{ name }}-{{ package }}-download
                                {%- endif %}

                            {%- else %}
  test.show_notification:
    - text: |
        Note: there is no dict named 'source' in 'pkg:{{ comp }}:{{ name }}'.
                            {%- endif %}  {# source #}
                        {%- endif %}      {# download #}

{{ formula }}-{{ comp }}-{{ name }}-{{ package }}-install:

                            {#- NATIVE PACKAGE INSTALL #}

                        {%- if package == 'native' %}
                            {%- if d.use_upstream = 'repo' and 'repo' in d.pkg and d.pkg.repo %}
  pkgrepo.managed:
    {{- format_kwargs(d.pkg['repo']) }}
                            {%- endif %}
  pkg.installed:
                            {%- if package in software and software[package] is mapping %}
    - sources:
      - {{ software.name }}: {{ d.dir.tmp ~ '/' ~ comp ~ name ~ software['version'] }}
      - {{ software.name }}: {{ software[package]['source'] }}
                                {%- if 'source_hash' in software[package] %}
    - require:
      - module: {{ formula }}-{{ comp }}-{{ name }}-{{ package }}-download
                                {%- endif %}
                            {%- else %}
    - name: {{ software.get('name', name) }}
                            {%- endif %}
    - reload_modules: true

                            {#- ARCHIVE PACKAGE INSTALL #}

                        {%- elif package == 'archive' and package in software and software[package] is mapping %}
                            {%- if 'source' in software[package] %}
  file.directory:
    - name: {{ software['path'] }}
    - user: {{ d.identity.rootuser }}
    - group: {{ d.identity.rootgroup }}
    - mode: '0755'
    - makedirs: True
    - require:
      - file: {{ formula }}-install-prerequisites
    - require_in:
      - archive: {{ formula }}-{{ comp }}-{{ name }}-{{ package }}-install
    - recurse:
        - user
        - group
        - mode
  archive.extracted:
    {{- format_kwargs(software[package]) }}
    - trim_output: true
                {%- if 'tar' in software[package]['source'] or 'tgz' in software[package]['source'] %}
    - enforce_toplevel: false
    - options: --strip-components=1
                {%- endif %}
    - retry: {{ d.retry_option|json }}
    - user: {{ d.identity.rootuser }}
    - group: {{ d.identity.rootgroup }}
    - require:
      - file: {{ formula }}-{{ comp }}-{{ name }}-{{ package }}-install

                            {%- else %}
  test.show_notification:
    - text: |
        Note: there is no dict named 'source' in 'pkg:{{ comp }}:{{ name }}'.
                            {%- endif %}

                            {#- MACAPP PACKAGE INSTALL #}

                        {%- elif package == 'macapp' and package in software and software[package] is mapping %}
                            {%- if 'source' in software[package] %}
  macpackage.installed:
    - name: {{ d.dir.tmp ~ '/' ~ comp ~ name ~ software['version'] }}
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
    - onchanges:
      - cmd: {{ formula }}-{{ comp }}-{{ name }}-{{ package }}-download
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: {{ files_switch(['mac_shortcut.sh.jinja'],
                              lookup=formula ~ '-' ~ comp ~ '-' ~ name ~ '-' ~ package ~ '-install'
                 )
              }}
    - mode: 755
    - template: jinja
    - context:
        appdir: {{ d.dir.macapp }}
        appname: {{ software['name'] }}
        user: {{ d.identity.rootuser }}
        homes: {{ d.dir.homes }}
    - require:
      - macpackage: {{ formula }}-{{ comp }}-{{ name }}-{{ package }}-install
  cmd.run:
    - name: /tmp/mac_shortcut.sh
    - runas: {{ d.identity.user }}
    - require:
      - file: {{ formula }}-{{ comp }}-{{ name }}-{{ package }}-install

                            {%- else %}
  test.show_notification:
    - text: |
        Note: there is no dict named 'source' in 'pkg:{{ comp }}:{{ name }}'.
                            {%- endif %}
                        {%- else %}
  test.show_notification:
    - text: |
        Note: there is no dict named {{ package }} in 'pkg:{{ comp }}:{{ name }}'.
              Maybe the value of 'pkg:{{ comp }}:{{ name }}:package_format' is incorrect.
                        {%- endif %}

                                    {#- SYMLINK INSTALL #}

                        {%- if grains.kernel|lower in ('linux', 'darwin') %}
                            {%- if package in ('archve', 'macapp') %}
                                {%- if d.linux.altpriority|int <= 0 or grains.os_family in ('MacOS', 'Arch') %}
                                    {%- if 'commands' in software  and software['commands'] is iterable %}
                                        {%- for cmd in software['commands'] %}

{{ formula }}-{{ comp }}-{{ name }}-{{ package }}-install-symlink-{{ cmd }}:
  file.symlink:
    - name: {{ d.dir.symlink }}/{{ 's' if 'service' in software else '' }}bin/{{ cmd }}
    - target: {{ software['path'] }}/{{ cmd }}
    - onlyif: test -f {{ d.dir.symlink }}/{{ 's' if 'service' in software else '' }}bin/{{ cmd }}
    - force: True

                                        {%- endfor %}  {# command #}
                                    {%- endif %}       {# commands #}
                                {%- endif %}           {# service #}
                            {%- endif %}               {# symlink #}
                        {%- endif %}                   {# darwin/linux #}
                    {%- endif %}                       {# software/package #}

                        {#- SERVICE INSTALL #}

                    {%- if 'service' in software and software['service'] %}
                        {%- set service = software['service'] %}

{{ formula }}-{{ comp }}-{{ service.name }}-install-service-directory:
  file.directory:
    - name: {{ d.dir.var }}/{{ name }}
    - user: {{ d.default.user if 'user' not in software else software['user'] }}
    - group: {{ d.default.group if 'group' not in software else software['group'] }}
    - mode: '0755'
    - makedirs: True
    - require:
      - sls: {{ sls_config_users }}
      - file: {{ formula }}-install-prerequisites
    - require_in:
                        {%-  if grains.kernel == 'Linux' %}
      - file: {{ formula }}-{{ comp }}-{{ service.name }}-install-service-systemd

{{ formula }}-{{ comp }}-{{ service.name }}-install-service-systemd:
  file.managed:
    - name: {{ d.dir.service }}/{{ name }}.service
    - source: {{ files_switch(['systemd.ini.jinja'],
                               lookup=formula ~ '-' ~ comp ~ '-' ~ service.name ~ '-install-service-systemd'
                 )
              }}
    - mode: '0644'
    - user: {{ d.identity.rootuser }}
    - group: {{ d.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        desc: {{ formula }} {{ name }} service
        name: {{ name }}
        workdir: {{ d.dir.var }}/{{ name }}
        user: {{ d.default.user if 'user' not in software else software['user'] }}
        group: {{ d.default.group if 'group' not in software else software['group'] }}
        stop: ''
        start: {{ software['path'] }}/bin/{{ name }}
    - watch_in:
      - cmd: {{ formula }}-{{ comp }}-{{ service.name }}-install-service-systemd
  cmd.run:
    - name: systemctl daemon-reload

                        {%- elif grains.kernel == 'Darwin' %}
                            {%- set servicename = name if 'name' not in service else service.name %}

      - file: {{ formula }}-{{ comp }}-{{ servicename }}-install-service-launched

{{ formula }}-{{ comp }}-{{ servicename }}-install-service-launched:
  file.managed:
    - name: /Library/LaunchAgents/{{ servicename }}.plist
    - source: salt://{{ formula }}/files/default/macos.plist.jinja
    - mode: '0644'
    - user: root
    - group: wheel
    - template: jinja
    - makedirs: True
    - context:
        svc: {{ servicename|replace('org.mongo.mongodb.', '') }}
        config: {{ software['config_file'] }}
        binpath: {{ software['path'] }}

                        {%- endif %}   {# linux/darwin #}
                    {%- endif %}       {# service #}
                {%- endif %}           {# wanted #}
            {%- endfor %}              {# component #}
        {%- endif %}                   {# wanted #}
    {%- endfor %}                      {# components #}
