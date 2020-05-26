# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- set formula = d.formula %}

include:
  - {{ sls_config_clean }}

    {%- for comp in d.software_component_matrix %}
        {%- if comp in d.wanted and d.wanted is iterable and comp in d.pkg and d.pkg[comp] is mapping %}
            {%- for name,v in d.pkg[comp].items() %}
                {%- if name in d.wanted[comp] %}
                    {%- set software = d.pkg[comp][name] %}
                    {%- if 'service' in software and software['service'] is mapping %}
                        {%- if 'config' in software and software['config'] is mapping %}
                            {%- set config = software['config'] %}
                            {%- set servicename = name if 'service' not in software else software.service.name %}

{{ formula }}-service-dead-{{ comp }}-{{ servicename }}-clean:
  service.dead:
    - name: {{ servicename }}
                            {% if grains.kernel|lower == 'linux' %}
    - onlyif: systemctl list-units |grep {{ servicename }} >/dev/null 2>&1
                            {%- endif %}  {# linux #}
    - enable: False
  file.absent:
    - names:
      - {{ d.dir.service }}/{{ servicename }}.service
      - /etc/logrotate.d/{{ formula }}_{{ servicename }}
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
                            {%- if 'processManagement' in config and config['processManagement']['pidFilePath'] %}
    - {{ config['processManagement']['pidFilePath'] }}
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
