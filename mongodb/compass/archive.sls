##mongodb/compass/archive.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from 'mongodb/map.jinja' import mongodb with context %}

mongodb compass archive {{ mongodb.compass.pkgname }} download:
  file.directory:
    - names:
      - {{ mongodb.dl.tmpdir }}
      - {{ mongodb.system.prefix }}/{{ mongodb.compass.pkgname }}/
    - makedirs: True
  cmd.run:
    - name: curl -s -L -o {{ mongodb.dl.tmpdir }}/{{ mongodb.compass.name }} {{ mongodb.compass.url }}
    - unless: test -f {{ mongodb.dl.tmpdir }}/{{ mongodb.compass.name }}
         {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ mongodb.dl.retries }}
        interval: {{ mongodb.dl.interval }}
        until: True
        splay: 10
         {% endif %}
         {%- if mongodb.compass.source_hash and (grains['saltversioninfo'] <= [2016, 11, 6] or grains.os in ('MacOS',)) %}
  module.run:
    - name: file.check_hash
    - path: '{{ mongodb.dl.tmpdir }}/{{ mongodb.compass.name }}'
    - file_hash: {{ mongodb.compass.source_hash }}
    - onchanges:
      - cmd: mongodb compass archive {{ mongodb.compass.pkgname }} download
    - require_in:
           {% if grains.os == 'MacOS' %}
      - macpackge: mongodb compass archive {{ mongodb.compass.pkgname }} install
           {%- else %}
      - archive: mongodb compass archive {{ mongodb.compass.pkgname }} install
           {%- endif %}
        {%- endif %}

mongodb compass archive {{ mongodb.compass.pkgname }} install:
      {% if grains.os == 'MacOS' %}
  macpackage.installed:
    - name: '{{ mongodb.dl.tmpdir }}/{{ mongodb.compass.name }}'
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
      {% else %}
  archive.extracted:
    - source: file://{{ mongodb.dl.tmpdir }}/{{ mongodb.compass.name }}
    - name: {{ mongodb.system.prefix }}
    - makedirs: True
    - trim_output: True
    - enforce_toplevel: True
    - source_hash: {{ mongodb.compass.source_hash }}
      {%- endif %}
    - require:
      - mongodb compass archive {{ mongodb.compass.pkgname }} download
    - require_in:
      - file: mongodb compass archive {{ mongodb.compass.pkgname }} install
      {% if mongodb.compass.binpath and grains.os not in ('MacOS', 'Windows') %}
  file.symlink:
    - name: {{ mongodb.compass.binpath }}
    - target: {{ mongodb.system.prefix }}/{{ mongodb.compass.pkgname }}
    - unless: test -d {{ mongodb.compass.binpath }}
      {%- endif %}
