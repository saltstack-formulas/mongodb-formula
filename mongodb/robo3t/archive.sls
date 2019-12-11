##mongodb/robo3t/archive.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from 'mongodb/map.jinja' import mongodb with context %}

mongodb robo3t archive {{ mongodb.robo3t.pkgname }} download:
  file.directory:
    - names:
      - {{ mongodb.dl.tmpdir }}
      - {{ mongodb.system.prefix }}/{{ mongodb.robo3t.pkgname }}/
    - makedirs: True
  cmd.run:
    - name: curl -s -L -o {{ mongodb.dl.tmpdir }}/{{ mongodb.robo3t.name }} {{ mongodb.robo3t.url }}
    - unless: test -f {{ mongodb.dl.tmpdir }}/{{ mongodb.robo3t.name }}
         {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ mongodb.dl.retries }}
        interval: {{ mongodb.dl.interval }}
        until: True
        splay: 10
         {% endif %}
         {%- if mongodb.robo3t.source_hash and (grains['saltversioninfo'] <= [2016, 11, 6] or grains.os in ('MacOS',)) %}
  module.run:
    - name: file.check_hash
    - path: '{{ mongodb.dl.tmpdir }}/{{ mongodb.robo3t.name }}'
    - file_hash: {{ mongodb.robo3t.source_hash }}
    - onchanges:
      - cmd: mongodb robo3t archive {{ mongodb.robo3t.pkgname }} download
    - require_in:
           {% if grains.os == 'MacOS' %}
      - macpackge: mongodb robo3t archive {{ mongodb.robo3t.pkgname }} install
           {%- else %}
      - archive: mongodb robo3t archive {{ mongodb.robo3t.pkgname }} install
           {%- endif %}
        {%- endif %}

mongodb robo3t archive {{ mongodb.robo3t.pkgname }} install:
      {% if grains.os == 'MacOS' %}
  macpackage.installed:
    - name: '{{ mongodb.dl.tmpdir }}/{{ mongodb.robo3t.name }}'
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
      {% else %}
  archive.extracted:
    - source: file://{{ mongodb.dl.tmpdir }}/{{ mongodb.robo3t.name }}
    - name: {{ mongodb.system.prefix }}
    - makedirs: True
    - trim_output: True
    - enforce_toplevel: True
    - source_hash: {{ mongodb.robo3t.source_hash }}
      {%- endif %}
    - require:
      - mongodb robo3t archive {{ mongodb.robo3t.pkgname }} download
    - require_in:
      - file: mongodb robo3t archive {{ mongodb.robo3t.pkgname }} install
      {% if mongodb.robo3t.binpath and grains.os not in ('MacOS', 'Windows') %}
  file.symlink:
    - name: {{ mongodb.robo3t.binpath }}
    - target: {{ mongodb.system.prefix }}/{{ mongodb.robo3t.pkgname }}
    - unless: test -d {{ mongodb.robo3t.binpath }}
      {%- endif %}
