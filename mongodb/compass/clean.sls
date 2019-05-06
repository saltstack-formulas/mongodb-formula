##mongodb/compass/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from 'mongodb/map.jinja' import mongodb with context %}

mongodb compass cleanup:
  file.absent:
    - names:
        {%- if grains.os in ('MacOS',) %}
      - {{ mongodb.system.userhome }}/{{ mongodb.system.user }}/Desktop/MongoDB ({{ svc }})
        {%- endif %}
      - {{ mongodb.system.prefix }}/{{ mongodb.compass.dirname }}
      - {{ mongodb.dl.tmpdir }}/{{ mongodb.compass.arcname }}
        {%- if grains.os in ('MacOS',) %}
      - {{ mongodb.system.userhome }}/{{ mongodb.system.user }}/Desktop/MongoDB ({{ svc }})
        {%- endif %}
