# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- set formula = d.formula %}

{%- if grains.kernel|lower == 'linux' and d.linux.altpriority|int > 0 and grains.os_family != 'Arch' %}
    {%- for comp in d.software_component_matrix %}
        {%- if comp in d.wanted and d.wanted is iterable and comp in d.pkg and d.pkg[comp] is mapping %}
            {%- for name,v in d.pkg[comp].items() %}
                {%- if name in d.wanted[comp] %}
                    {%- set software = d.pkg[comp][name] %}
                    {%- set package = software.package_format %}
                    {%- if package == 'archive' and package in software and software[package] is mapping %}

                        {# LINUX ALTERNATIVES #}

                        {%- set bindir = '/sbin' if 'service' in software else '/bin' %}
                        {%- if 'commands' in software  and software['commands'] is iterable %}
                            {%- for cmd in software['commands'] %}

{{ formula }}-{{ comp }}-{{ name }}-{{ cmd }}-alternatives-clean:
  alternatives.remove:
    - name: link-{{ formula }}-{{ name }}-{{ cmd }}
    - path: {{ software['path'] }}/bin/{{ cmd }}
    - onlyif: update-alternatives --get-selections |grep ^{{ formula }}-{{ name }}-{{ cmd }}

                            {%- endfor %}  {# alternative #}
                        {%- endif %}       {# commands #}
                    {%- endif %}           {# archive #}
                {%- endif %}               {# wanted #}
            {%- endfor %}                  {# component #}
        {%- endif %}                       {# wanted #}
    {%- endfor %}                          {# components #}
{%- endif %}                               {# linux #}
