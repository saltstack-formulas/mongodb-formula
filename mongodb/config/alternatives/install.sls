# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- set sls_software_install = tplroot ~ '.install' %}
{%- set formula = d.formula %}

include:
  - {{ sls_software_install }}

{%- if grains.kernel|lower == 'linux' and d.linux.altpriority|int > 0 and grains.os_family != 'Arch' %}
    {%- for comp in d.software_component_matrix %}
        {%- if comp in d.wanted and d.wanted is iterable and comp in d.pkg and d.pkg[comp] is mapping %}
            {%- for name,v in d.pkg[comp].items() %}
                {%- if name in d.wanted[comp] %}
                    {%- set software = d.pkg[comp][name] %}
                    {%- set path = software['path'] %}
                    {%- set package = software.package_format %}
                    {%- if package == 'archive' and package in software and software[package] is mapping %}

                        {# LINUX ALTERNATIVES #}

                        {%- set bindir = '/sbin' if 'service' in software else '/bin' %}
                        {%- if 'commands' in software  and software['commands'] is iterable %}
                            {%- for cmd in software['commands'] %}

{{ formula }}-{{ comp }}-archive-{{ name }}-{{ cmd }}-alternatives-install:
                                    {%- if grains.os_family in ('Suse',) %}
  cmd.run:
    - name: update-alternatives --install {{ dir_symlink }}/{{ bindir }}/{{ cmd }} link-{{ formula }}-{{ name }}-{{ cmd }} {{ path }}/bin/{{ cmd }} {{ d.linux.altpriority }}  # noqa 204
    - require_in:
      - alternatives: {{ formula }}-{{ comp }}-archive-{{ name }}-{{ cmd }}-alternatives-set
                                    {%- else %}
  alternatives.install:
    - link: {{ d.dir.symlink }}/{{ bindir }}/{{ cmd }}
    - path: {{ path }}/bin/{{ cmd }}
    - order: 10
    - priority: {{ d.linux.altpriority }}
    - name: link-{{ formula }}-{{ name }}-{{ cmd }}
                                    {%- endif %}
    - require:
      - sls: {{ sls_software_install }}
    - onlyif: test -x {{ path }}/bin/{{ cmd }}
    - require_in:
      - alternatives: {{ formula }}-{{ comp }}-archive-{{ name }}-{{ cmd }}-alternatives-set

{{ formula }}-{{ comp }}-archive-{{ name }}-{{ cmd }}-alternatives-set:
  alternatives.set:
    - name: link-{{ formula }}-{{ name }}-{{ cmd }}
    - path: {{ path }}/bin/{{ cmd }}
    - onlyif: test -x {{ path }}/bin/{{ cmd }}

                            {%- endfor %}  {# alternative #}
                        {%- endif %}       {# commands #}
                    {%- endif %}           {# archive #}
                {%- endif %}               {# wanted #}
            {%- endfor %}                  {# component #}
        {%- endif %}                       {# wanted #}
    {%- endfor %}                          {# components #}

{%- else %}

{{ formula }}-config-alternatives-install-notification:
  test.show_notification:
    - text: |
        Note: The linux alternatives state is not applicable for {{ grains.os }}

{%- endif %}                               {# os #}
