##mongodb/bic/archive.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from 'mongodb/map.jinja' import mongodb with context %}

mongodb bic archive {{ mongodb.bic.dirname }} cleancache:
  file.absent:
    - name: /private/{{ mongodb.dl.tmpdir }}/{{ mongodb.bic.arcname }}

mongodb bic archive {{ mongodb.bic.dirname }} download:
  file.directory:
    - names:
      - {{ mongodb.dl.tmpdir }}
      - {{ mongodb.system.prefix }}/{{ mongodb.bic.dirname }}
    - makedirs: True
  pkg.installed:
    - names: {{ mongodb.system.deps }}
  cmd.run:
    - name: curl -s -L -o {{ mongodb.dl.tmpdir }}/{{ mongodb.bic.arcname }} {{ mongodb.bic.url }}
        {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ mongodb.dl.retries }}
        interval: {{ mongodb.dl.interval }}
        {% endif %}

mongodb bic archive {{ mongodb.bic.dirname }} install:
  archive.extracted:
    - source: file://{{ mongodb.dl.tmpdir }}/{{ mongodb.bic.arcname }}
    - name: {{ mongodb.system.prefix }}
    - makedirs: True
    - trim_output: True
    - enforce_toplevel: True
    - skip_verify: True  ## see https://jira.mongodb.org/browse/DOCS-12151
    # source_hash: {{ mongodb.bic.url ~ '.sha256' if "source_hash" not in mongodb.bic else mongodb.bic.source_hash }}
    - onchanges:
      - mongodb bic archive {{ mongodb.bic.dirname }} download
    - require_in:
      - file: mongodb bic archive {{ mongodb.bic.dirname }} install
      - file: mongodb bic archive {{ mongodb.bic.dirname }} profile
      - file: mongodb bic archive {{ mongodb.bic.dirname }} tidyup
  file.symlink:
    - name: {{ mongodb.bic.binpath }}
    - target: {{ mongodb.system.prefix }}/{{ mongodb.bic.dirname }}
    - unless: test -d {{ mongodb.bic.binpath }}

mongodb bic archive {{ mongodb.bic.dirname }} profile:
  file.managed:
    - name: /etc/profile.d/mongodb.sh
    - source: salt://mongodb/files/mongodb.profile.jinja
    - template: jinja
    - mode: 644
    - context:
      svrpath: {{ mongodb.server.binpath or None }}
      bicpath: {{ mongodb.bic.binpath }}
    - onlyif: test -d {{ mongodb.bic.binpath }}

mongodb bic archive {{ mongodb.bic.dirname }} tidyup:
  file.absent:
    - name: {{ mongodb.dl.tmpdir }}/{{ mongodb.bic.arcname }}

