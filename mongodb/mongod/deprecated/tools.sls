##mongodb/database/tools.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "mongodb/map.jinja" import mongodb with context %}

## DEPRECIATED. See config.sls and clean.sls

python_pip:
  pkg.installed:
    - name: {{ mdb.pip }}

# Upgrade from too old versions of pip (on Ubuntu 12.04 for example)
pip_upgrade:
  cmd.run:
    - name: pip install --upgrade pip
    # pip state functions need an importable pip module
    - unless: python -c 'import pip; pip.__version__'

pymongo_package:
  pip.installed:
    - name: pymongo
    # This is needed for mongodb_* states to work in the same Salt job
    - reload_modules: True
    - require:
      - pkg: python_pip
