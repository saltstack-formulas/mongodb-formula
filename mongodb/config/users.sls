# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- set formula = d.formula %}

    {%- for comp in d.components %}
        {%- if comp in d.wanted and d.wanted is iterable and comp in d.pkg and d.pkg[comp] is mapping %}
            {%- for name,v in d.pkg[comp].items() %}
                {%- if name in d.wanted[comp] %}
                    {%- set software = d.pkg[comp][name] %}
                    {%- if 'user' in software and 'service' in software and software['service'] is mapping %}
                        {%- set servicename = name if 'service' not in software else software.service.name %}
                        {%- set user = d.default.user if 'user' not in software else software['user'] %}

{{ formula }}-config-usergroup-{{ servicename }}-install-usergroup-present:
  group.present:
    - name: {{ d.default.group if 'group' not in software else software['group'] }}
    - require_in:
      - user: {{ formula }}-config-usergroup-{{ servicename }}-install-usergroup-present
  user.present:
    - name: {{ user }}
    - shell: /bin/false
    - createhome: false
    - groups:
      - {{ d.default.group if 'group' not in software else software['group'] }}
                        {%- if grains.os_family == 'MacOS' %}
    - unless: /usr/bin/dscl . list /Users | grep {{ user }} >/dev/null 2>&1
                        {%- endif %}  {# darwin #}

                    {%- endif %}      {# service-users #}
                {%- endif %}          {# wanted #}
            {%- endfor %}             {# component #}
        {%- endif %}                  {# wanted #}
    {%- endfor %}                     {# components #}
