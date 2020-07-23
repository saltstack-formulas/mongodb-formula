# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- set sls_software_install = tplroot ~ '.install' %}
{%- set sls_config_users = tplroot ~ '.config.users' %}
{%- set formula = d.formula %}

include:
  - {{ sls_software_install }}
  - {{ sls_config_users }}

{{ formula }}-config-file-etc-file-directory:
  file.directory:
    - name: {{ d.dir.etc }}
    - user: {{ d.identity.rootuser }}
    - group: {{ d.identity.rootgroup }}
    - mode: '0755'
    - makedirs: True
    - require:
      - sls: {{ sls_software_install }}

    {%- for comp in d.software_component_matrix %}
        {%- if comp in d.wanted and d.wanted is iterable and comp in d.pkg and d.pkg[comp] is mapping %}
            {%- for name,v in d.pkg[comp].items() %}
                {%- if name in d.wanted[comp] %}
                    {%- set software = d.pkg[comp][name] %}
                    {%- if 'service' in software and software['service'] is mapping %}
                        {%- set servicename = name if 'service' not in software else software.service.name %}
                        {%- if 'config_file' in software and 'config' in software and software['config'] is mapping %}

{{ formula }}-config-file-{{ servicename }}-file-managed:
  file.managed:
    - name: {{ d.dir.etc }}/{{ servicename|replace('org.mongo.mongodb.', '') }}.conf
    - source: {{ files_switch(['config.yml.jinja'],
                              lookup=formula ~ '-config-file-' ~ servicename ~ '-file-managed'
                 )
              }}
    - mode: 644
    - user: {{ d.default.user if 'user' not in software else software['user']  }}
    - group: {{ d.default.group if 'group' not in software else software['group']  }}
    - makedirs: True
    - template: jinja
    - context:
        config: {{ software['config']|json }}
    - require:
      - user: {{ formula }}-config-usergroup-{{ servicename }}-install-usergroup-present
      - group: {{ formula }}-config-usergroup-{{ servicename }}-install-usergroup-present
      - sls: {{ sls_software_install }}

                        {%- endif %}  {# config #}
                    {%- endif %}      {# service #}
                {%- endif %}          {# wanted #}
            {%- endfor %}             {# component #}
        {%- endif %}                  {# wanted #}
    {%- endfor %}                     {# components #}
