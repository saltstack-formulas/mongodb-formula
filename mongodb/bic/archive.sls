##mongodb/bic/archive.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from 'mongodb/map.jinja' import mongodb with context %}

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
    - unless: test -f {{ mongodb.dl.tmpdir }}/{{ mongodb.bic.arcname }}
        {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ mongodb.dl.retries }}
        interval: {{ mongodb.dl.interval }}
        until: True
        splay: 10
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
    - require:
      - cmd: mongodb bic archive {{ mongodb.bic.dirname }} download
    - require_in:
      - file: mongodb bic archive {{ mongodb.bic.dirname }} install
      - file: mongodb bic archive {{ mongodb.bic.dirname }} profile
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
