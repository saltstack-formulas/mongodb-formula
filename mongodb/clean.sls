##mongodb/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

include:
  - mongodb.mongod.clean
  - mongodb.mongos.clean
  - mongodb.bic.clean
  - mongodb.robo3t.clean
