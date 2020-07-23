# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- set sls_alternatives_clean = tplroot ~ '.config.alternatives.clean' %}
{%- set formula = d.formula %}

include:
  - {{ sls_service_clean }}
  - {{ sls_alternatives_clean }}

    {%- for comp in d.software_component_matrix %}
        {%- if comp in d.wanted and d.wanted is iterable and comp in d.pkg and d.pkg[comp] is mapping %}
            {%- for name,v in d.pkg[comp].items() %}
                {%- if name in d.wanted[comp] %}
                    {%- set software = d.pkg[comp][name] %}
                    {%- if 'user' in software and 'group' in software %}

{{ formula }}-config-clean-{{ name }}-usergroup:
  user.absent:
    - name: {{ d.default.user if 'user' not in software else software['user'] }}
                        {%- if grains.os_family == 'MacOS' %}
    - onlyif: /usr/bin/dscl . list /Users | grep {{ name }} >/dev/null 2>&1
                        {%- endif %}
    - require_in:
      - group: {{ formula }}-config-clean-{{ name }}-usergroup
    - require:
      - sls: {{ sls_service_clean }}
  group.absent:
    - name: {{ d.default.group if 'group' not in software else software['group'] }}
                    {%- endif %}  {# users #}

{{ formula }}-config-clean-{{ name }}-files:
  file.absent:
    - names:
            {%- if 'service' in software and software['service'] is mapping %}
                {%- set servicename = name if 'service' not in software else software.service.name %}
      - {{ d.dir.etc }}/{{ servicename|replace('org.mongo.mongodb.', '') }}.conf
            {%- endif %}
            {%- if 'config_file' in software and 'config' in software and software['config'] is mapping %}
      - {{ software['config_file'] }}
            {%- endif %}
            {%- if 'environ_file' in software and 'environ' in software and software['environ'] is mapping %}
      - {{ software['environ_file'] }}
            {%- endif %}
    - require:
      - sls: {{ sls_service_clean }}

                {%- endif %}          {# wanted #}
            {%- endfor %}             {# component #}
        {%- endif %}                  {# wanted #}
    {%- endfor %}                     {# components #}
