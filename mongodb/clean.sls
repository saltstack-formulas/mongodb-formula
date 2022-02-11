# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- set formula = d.formula %}

include:
  - {{ sls_service_clean }}
  - {{ sls_config_clean }}

{{ formula }}-clean-prerequisites:
  pip.removed:
    - names: {{ d.pkg.pips|json }}
    - require:
      - sls: {{ sls_service_clean }}
      - sls: {{ sls_config_clean }}
    - require_in:
      - file: {{ formula }}-clean-prerequisites
  file.absent:
    - names:
      - {{ d.dir.tmp }}
      - {{ d.dir.var }}
      - /tmp/mac_shortcut.sh

    {%- for comp in d.componentypes %}
        {%- if comp in d.wanted and d.wanted is iterable and comp in d.pkg and d.pkg[comp] is mapping %}
            {%- for name,v in d.pkg[comp].items() %}
                {%- if name in d.wanted[comp] %}
                    {%- set software = d.pkg[comp][name] %}
                    {%- set package = software['use_upstream'] %}
                    {%- if package in d.packagetypes %}

                            {#- PACKAGE CLEAN #}
                        {%- if package in software and software[package] is mapping %}

{{ formula }}-{{ comp }}-{{ name }}-clean:
  pkg.removed:
    - name: {{ software.get('name', name) }}
    - require:
      - file: {{ formula }}-clean-prerequisites
  file.absent:
    - name: {{ software['path'] }}
    - require:
      - file: {{ formula }}-clean-prerequisites
                            {%- if package == 'repo' %}
  pkgrepo.absent:
    - name: {{ d.pkg['repo']['name'] }}
                            {%- endif %}

                        {%- endif %}
                        {%- if grains.kernel|lower in ('linux', 'darwin')  %}
                            {%- if package in ('macapp', 'archive',) %}
                                {#- SYMLINK CLEAN #}
                                {%- if d.linux.altpriority|int <= 0 or grains.os_family in ('MacOS', 'Arch',) %}
                                    {%- if 'commands' in software  and software['commands'] is iterable %}
                                        {%- for cmd in software['commands'] %}

{{ formula }}-{{ comp }}-{{ name }}-{{ package }}-clean-symlink-{{ cmd }}:
  file.absent:
    - names:
      - {{ d.dir.symlink }}/{{ 's' if 'service' in software else '' }}bin/{{ cmd }}
      - {{ d.dir.macapp }}/{{ software['name'] }}.app
    - require:
      - file: {{ formula }}-clean-prerequisites

                                        {%- endfor %}  {# command #}
                                    {%- endif %}       {# commands #}
                                {%- endif %}           {# wanted #}
                            {%- endif %}               {# symlink #}
                        {%- endif %}                   {# darwin/linux #}
                    {%- endif %}                       {# software/package #}

                        {#- SERVICE CLEAN #}

                    {%- if 'service' in software and software['service'] %}
                        {%- set service = software['service'] %}

{{ formula }}-{{ comp }}-{{ package }}-{{ name }}-clean-service:
  file.absent:
    - names:
      - {{ d.dir.var }}/{{ name }}
      - {{ d.dir.service }}/{{ name }}.service
      - /Library/LaunchAgents/{{ name if 'name' not in service else service.name }}.plist
    - require:
      - file: {{ formula }}-clean-prerequisites
  cmd.run:
    - name: systemctl daemon-reload >/dev/null 2>&1 || true
    - onlyif: {{ grains.kernel|lower == 'linux' }}
    - onchanges:
      - file: {{ formula }}-{{ comp }}-{{ package }}-{{ name }}-clean-service

                    {%- endif %}          {# service #}
                {%- endif %}              {# wanted #}
            {%- endfor %}                 {# component #}
        {%- endif %}                      {# wanted #}
    {%- endfor %}                         {# components #}
