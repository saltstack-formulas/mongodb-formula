##mongodb/server/packages.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from 'mongodb/map.jinja' import mongodb with context %}

  {%- if mongodb.server.use_repo %}

mongodb server package repo:
  pkgrepo.managed:
    - name: {{ mongodb.server.repo.name|replace('RELEASE', mongodb.server.version) }}
    - enabled: {{ mongodb.server.repo.enabled }}

    {%- if grains['os_family'] in ('Ubuntu', 'Debian',) %}

    - file: {{ mongodb.server.repo.file|replace('RELEASE', mongodb.server.version) }}
    - keyid: {{ mongodb.server.repo.keyid }}
    - keyserver: {{ mongodb.server.repo.keyserver }}

    {%- elif grains['os_family'] in ('RedHat',) %}

    - gpgkey: {{ mongodb.server.repo.gpgkey|replace('RELEASE', mongodb.server.version) }}
    - baseurl: {{ mongodb.server.repo.baseurl|replace('RELEASE', mongodb.server.version) }}
    - gpgcheck: {{ mongodb.server.repo.gpgcheck }}
    - humanname: {{ mongodb.server.repo.humanname|replace('RELEASE', mongodb.server.version) }}

    {%- endif %}
    - require_in:
      - mongodb server package installed

  {%- endif %}

mongodb server package installed:
  pkg.installed:
    - refresh: True
    - name: {{ mongodb.server.package }}
        {%- if mongodb.server.use_repo %}
    - fromrepo: {{ mongodb.server.repo.from_repo_value or mongodb.server.repo.name|replace('RELEASE', mongodb.server.version) or None }}
 }}
        {%- endif %}

