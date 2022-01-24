# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- set formula = d.formula %}
{%- set sls_software_install = tplroot ~ '.install' %}

include:
  - {{ sls_software_install }}

    {%- for comp in d.componentypes %}
        {%- if comp in d.wanted and d.wanted is iterable and comp in d.pkg and d.pkg[comp] is mapping %}
            {%- for name,v in d.pkg[comp].items() %}
                {%- if name in d.wanted[comp] %}
                    {%- set software = d.pkg[comp][name] %}
                    {%- if 'user' in software and 'service' in software and software['service'] is mapping %}
                        {%- set servicename = name if 'service' not in software else software.service.name %}

{{ formula }}-config-usergroup-{{ servicename }}-install-usergroup-present:
  group.present:
    - name: {{ software['group'] }}
    - system: true
    - require_in:
      - user: {{ formula }}-config-usergroup-{{ servicename }}-install-usergroup-present
    - require_in:
      - sls: {{ sls_software_install }}
  user.present:
    - name: {{ software['user'] }}
    - system: true
    - shell: /bin/false
    - createhome: false
    - groups:
      - {{ software['group'] }}
                        {%- if grains.os_family == 'MacOS' %}
    - unless: /usr/bin/dscl . list /Users | grep {{ software['user'] }} >/dev/null 2>&1
                        {%- endif %}  {# darwin #}

                    {%- endif %}      {# service-users #}
                {%- endif %}          {# wanted #}
            {%- endfor %}             {# component #}
        {%- endif %}                  {# wanted #}
    {%- endfor %}                     {# components #}
