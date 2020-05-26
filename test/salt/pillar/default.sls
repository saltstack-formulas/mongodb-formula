# -*- coding: utf-8 -*-
# vim: ft=yaml
---
mongodb:
  wanted:
    # choose what you want
    database:
      - mongod
      - mongos
      - dbtools
      - shell
    gui:
      - robo3t
           {%- if grains.kernel|lower == 'darwin' %}
      - compass
           {%- endif %}
    connectors:
      # bi   # enterprise advanced subscription
      - kafka
    upstream_repo: false
  linux:
    altpriority: 10000
