##mongodb/server/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from 'mongodb/map.jinja' import mongodb with context %}

include:
    {%- if mongodb.server.use_archive %}
  - mongodb.server.archive

    {%- else %}
  - mongodb.server.packages

    {%- endif %}
  - mongodb.server.config
