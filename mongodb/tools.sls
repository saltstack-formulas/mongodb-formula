{% from "mongodb/map.jinja" import mdb with context %}

python_pip:
  pkg.installed:
    - name: {{ mdb.pip }}

pymongo_package:
  pip.installed:
    - name: pymongo
    - require:
      - pkg: python_pip
