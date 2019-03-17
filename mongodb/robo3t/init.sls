##mongodb/robo3t/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from 'mongodb/map.jinja' import mongodb with context %}

include:
  - mongodb.robo3t.archive
