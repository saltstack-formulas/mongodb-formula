##mongodb/robo3t/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from 'mongodb/map.jinja' import mongodb with context %}

mongodb robo3t cleanup:
  file.absent:
    - names:
        {%- if grains.os in ('MacOS',) %}
      - {{ mongodb.system.userhome }}/{{ mongodb.system.user }}/Desktop/Robo 3T Community
      - {{ mongodb.system.userhome }}/{{ mongodb.system.user }}/Desktop/Robo 3T
        {%- endif %}
      - {{ mongodb.system.prefix }}/{{ mongodb.robo3t.pkgname }}
      - {{ mongodb.dl.tmpdir }}/{{ mongodb.robo3t.name }}
