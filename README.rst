mongodb
=======

Install and configure MongoDB products on GNU/Linux and MacOS.

Meta states
================

``mongodb``
-----------

Metastate to deploy MongoDB products from packages and/or archive files.  

``mongodb.server``
-------------------

Deploy and configure MongoDB "Community Server" and start 'mongos' and 'mongod' services.

``mongodb.bic``
-------------------

Deploy and configure MongoDB "Connector for BI" and start 'mongosqld' service.

``mongodb.remove``
-----------

Metastate to uninstall MongoDB products

Other states
================

``mongodb.server.config``
``mongodb.server.clean``
``mongodb.bic.config``
``mongodb.bic.clean``

Pillar Data
===============
Use linux distribution repo::

       mongodb:
         server:
           version: '4.0'

Use official  upstream repo::

       mongodb:
         server:
           use_repo: True
           version: '4.0'

Use official upstream archives::

       mongodb:
         server:
           use_archive: True
           version: '4.0.3'
         bic:
           version: 2.7.0

Testing
========
This formula works "out-of-the-box", or with pillars, on these operating systems.

- Ubuntu 16.04
- Centos 7.5.1804 (firewall + selinux enforcing)
- MacOS/Darwin

.. vim: fenc=utf-8 spell spl=en cc=100 tw=99 fo=want sts=2 sw=2 et
