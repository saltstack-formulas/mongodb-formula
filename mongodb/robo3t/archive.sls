##mongodb/robo3t/archive.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from 'mongodb/map.jinja' import mongodb with context %}

mongodb robo3t archive {{ mongodb.robo3t.dirname }} download:
  file.directory:
    - names:
      - {{ mongodb.dl.tmpdir }}
      - {{ mongodb.system.prefix }}/{{ mongodb.robo3t.dirname }}/
    - makedirs: True
  cmd.run:
    - name: curl -s -L -o {{ mongodb.dl.tmpdir }}/{{ mongodb.robo3t.arcname }} {{ mongodb.robo3t.url }}
    - unless: test -f {{ mongodb.dl.tmpdir }}/{{ mongodb.robo3t.arcname }}
          {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ mongodb.dl.retries }}
        interval: {{ mongodb.dl.interval }}
        until: True
        splay: 10
          {% endif %}

mongodb robo3t archive {{ mongodb.robo3t.dirname }} install:
      {% if grains.os == 'MacOS' %}
  macpackage.installed:
    - name: '{{ mongodb.dl.tmpdir }}/{{ mongodb.robo3t.arcname }}'
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
      {% else %}
  archive.extracted:
    - source: file://{{ mongodb.dl.tmpdir }}/{{ mongodb.robo3t.arcname }}
    - name: {{ mongodb.system.prefix }}
    - makedirs: True
    - trim_output: True
    - enforce_toplevel: True
    - source_hash: {{ mongodb.robo3t.source_hash }}
      {%- endif %}
    - require:
      - mongodb robo3t archive {{ mongodb.robo3t.dirname }} download
    - require_in:
      - file: mongodb robo3t archive {{ mongodb.robo3t.dirname }} install
      {% if mongodb.robo3t.binpath and grains.os not in ('MacOS', 'Windows') %}
  file.symlink:
    - name: {{ mongodb.robo3t.binpath }}
    - target: {{ mongodb.system.prefix }}/{{ mongodb.robo3t.dirname }}
    - unless: test -d {{ mongodb.robo3t.binpath }}
      {%- endif %}
