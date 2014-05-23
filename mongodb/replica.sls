{% from "mongodb/map.jinja" import mongodb with context %}
{% set replica_set = salt['pillar.get']('mongodb:replica_set', {}) %}

{% if replica_set %}

python_pip:
  pkg.installed:
    - name: {{ mongodb.pip }}

pymongo_package:
  pip.installed:
    - name: pymongo
    - require:
      - pkg: python_pip

{% endif %}
