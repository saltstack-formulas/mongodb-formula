# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- set formula = d.formula %}

include:
  - {{ sls_config_clean }}

    {%- for comp in d.componentypes %}
        {%- if comp in d.wanted and d.wanted is iterable and comp in d.pkg and d.pkg[comp] is mapping %}
            {%- for name,v in d.pkg[comp].items() %}
                {%- if name in d.wanted[comp] %}
                    {%- set software = d.pkg[comp][name] %}
                    {%- if 'service' in software and software['service'] is mapping %}
                        {%- if 'config' in software and software['config'] is mapping %}
                            {%- set config = software['config'] %}
                            {%- set servicename = name if 'service' not in software else software.service.name %}

{{ formula }}-service-dead-{{ comp }}-{{ servicename }}-clean:
            {%- if grains.kernel|lower == 'darwin' %}  {# service.running is buggy #}
  cmd.run:
    - names:
      - launchctl stop {{ servicename }} || true
      - launchctl unload /Library/LaunchAgents/{{ servicename }}.plist || true
            {%- else %}
  service.dead:
    - name: {{ servicename }}
                            {% if grains.kernel|lower == 'linux' %}
    - onlyif: systemctl list-unit-files |grep {{ servicename }} >/dev/null 2>&1
                            {%- endif %}  {# linux #}
    - enable: False
            {%- endif %}
    - require_in:
      - sls: {{ sls_config_clean }}
  file.absent:
    - names:
      - {{ d.dir.service }}/{{ servicename }}.service
      - /etc/logrotate.d/{{ formula }}_{{ servicename }}
                  {%- if 'systemLog' in config and 'destination' in config['systemLog'] %}
                      {%- if config['systemLog']['destination'] == 'file'  %}
      - {{ config['systemLog']['path'] }}
                      {%- else %}
      - {{ '/var/log/mongodb/' ~ servicename ~ '.log' }}
                      {%- endif %}
                  {%- endif %}
    - require_in:
      - sls: {{ sls_config_clean }}
                            {% if grains.kernel|lower == 'linux' %}
  cmd.run:
    - name: systemctl daemon-reload
    - watch:
      - file: {{ formula }}-service-dead-{{ comp }}-{{ servicename }}-clean
                            {%- endif %}  {# linux #}

{{ formula }}-service-dead-{{ comp }}-{{ servicename }}-clean-dirs:
  file.absent:
  - names:
    - /tmp/MySiLydUmMyFiLE
               {%- if 'processManagement' in config and 'pidFilePath' in config['processManagement'] %}
    - {{ config['processManagement']['pidFilePath'] }}
               {%- else %}
    - {{ '/var/run/{{ name }}.pid' }}
               {%- endif %}
               {%- if 'storage' in config and 'dbPath' in config['storage'] %}
    - {{ config['storage']['dbPath'] }}
               {%- endif %}
               {%- if 'schema' in config and 'path' in config['schema'] %}
    - {{ config['schema']['path'] }}
               {%- endif %}
               {%- if 'systemLog' in config and 'path' in config['systemLog'] %}
    - {{ config['systemLog']['path'] }}
               {%- endif %}
  - require_in:
    - sls: {{ sls_config_clean }}

                        {%- endif %}       {# service #}
                    {%- endif %}           {# service #}
                {%- endif %}               {# wanted #}
            {%- endfor %}                  {# component #}
        {%- endif %}                       {# wanted #}
    {%- endfor %}                          {# components #}
