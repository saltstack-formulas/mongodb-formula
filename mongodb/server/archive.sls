##mongodb/server/archive.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from 'mongodb/map.jinja' import mongodb with context %}

mongodb server archive {{ mongodb.server.dirname }} cleancache:
  file.absent:
    - name: /private/{{ mongodb.dl.tmpdir }}/{{ mongodb.server.arcname }}

mongodb server archive {{ mongodb.server.dirname }} download:
  file.directory:
    - names:
      - {{ mongodb.dl.tmpdir }}
      - {{ mongodb.system.prefix }}/{{ mongodb.server.dirname }}/
    - makedirs: True
  pkg.installed:
    - names: {{ mongodb.system.deps }}
  cmd.run:
    - name: curl -s -L -o {{ mongodb.dl.tmpdir }}/{{ mongodb.server.arcname }} {{ mongodb.server.url }}
        {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ mongodb.dl.retries }}
        interval: {{ mongodb.dl.interval }}
        {% endif %}

mongodb server archive {{ mongodb.server.dirname }} install:
  archive.extracted:
    - source: file://{{ mongodb.dl.tmpdir }}/{{ mongodb.server.arcname }}
    - name: {{ mongodb.system.prefix }}
    - makedirs: True
    - trim_output: True
    - enforce_toplevel: True
    - source_hash: {{ mongodb.server.url ~ '.sha256' if "source_hash" not in mongodb.server else mongodb.server.source_hash }}
    - onchanges:
      - mongodb server archive {{ mongodb.server.dirname }} download
    - require_in:
      - file: mongodb server archive {{ mongodb.server.dirname }} install
      - file: mongodb server archive {{ mongodb.server.dirname }} profile
      - file: mongodb server archive {{ mongodb.server.dirname }} tidyup
   {%- if mongodb.server.use_archive %}
  file.symlink:
    - name: {{ mongodb.server.binpath }}
    - target: {{ mongodb.system.prefix }}/{{ mongodb.server.dirname }}
    - unless: test -d {{ mongodb.server.binpath }}
   {%- endif %}

mongodb server archive {{ mongodb.server.dirname }} profile:
  file.managed:
    - name: /etc/profile.d/mongodb.sh
    - source: salt://mongodb/files/mongodb.profile.jinja
    - template: jinja
    - mode: 644
    - context:
      path: {{ mongodb.server.binpath }}
      svrpath: {{ mongodb.server.binpath }}
      bicpath: {{ mongodb.bic.binpath or None }}
    - onlyif: test -d {{ mongodb.server.binpath }}

mongodb server archive {{ mongodb.server.dirname }} tidyup:
  file.absent:
    - name: {{ mongodb.dl.tmpdir }}/{{ mongodb.server.arcname }}

