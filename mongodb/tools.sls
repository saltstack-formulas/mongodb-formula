{% from "mongodb/map.jinja" import mdb with context %}

{% if mdb.include_tools %}

python_pip:
  pkg.installed:
    - name: {{ mdb.pip }}

pymongo_package:
  pip.installed:
    - name: pymongo
    - require:
      - pkg: python_pip

{% endif %}
