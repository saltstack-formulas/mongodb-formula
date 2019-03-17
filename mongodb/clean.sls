##mongodb/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

include:
  - mongodb.server.clean
  - mongodb.bic.clean
  - mongodb.robo3t.clean
