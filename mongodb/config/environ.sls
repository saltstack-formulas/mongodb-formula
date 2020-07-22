# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import data as d with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}
{%- set sls_software_install = tplroot ~ '.install' %}
{%- set formula = d.formula %}

include:
  - {{ sls_software_install }}

    {%- for comp in d.components %}
        {%- if comp in d.wanted and d.wanted is iterable and comp in d.pkg and d.pkg[comp] is mapping %}
            {%- for name,v in d.pkg[comp].items() %}
                {%- if name in d.wanted[comp] %}
                    {%- set software = d.pkg[comp][name] %}
                    {%- if 'environ_file' in software and 'environ' in software and software['environ'] is mapping %}

{{ formula }}-config-install-{{ name }}-environ_file:
  file.managed:
    - name: {{ software['environ_file'] }}
    - source: {{ files_switch(['environ.sh.jinja'],
                              lookup=formula ~ ' -config-install-' ~ name ~ '-environ_file'
                 )
              }}
    - mode: 640
    - user: {{ d.identity.rootuser }}
    - group: {{ d.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        path: {{ software['path']|json }}
        environ: {{ software['environ']|json }}
    - require:
      - sls: {{ sls_software_install }}

                    {%- endif %}      {# environ #}
                {%- endif %}          {# wanted #}
            {%- endfor %}             {# component #}
        {%- endif %}                  {# wanted #}
    {%- endfor %}                     {# components #}
