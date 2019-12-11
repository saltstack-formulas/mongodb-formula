##mongodb/compass/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from 'mongodb/map.jinja' import mongodb with context %}

include:
    {%- if mongodb.compass.use_archive %}
  - mongodb.compass.archive
    {%- else %}
  - mongodb.compass.package
    {%- endif %}
