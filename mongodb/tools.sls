{% from "mongodb/map.jinja" import mongodb with context %}
{% set include_tools = salt['pillar.get']('mongodb:include_tools', False) %}

{% if include_tools %}

python_pip:
  pkg.installed:
    - name: {{ mongodb.pip }}

pymongo_package:
  pip.installed:
    - name: pymongo
    - require:
      - pkg: python_pip

{% endif %}
