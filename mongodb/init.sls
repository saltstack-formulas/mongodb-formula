##mongodb/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

include:
  - mongodb.server
{%- if salt['pillar.get']('mongodb:compass:install', False) %}
  - mongodb.compass
{%- endif %}
