mongodb
=======

Install and configure various parts of a MongoDB cluster.

Available states
================

``mongodb``
-----------

Install MongoDB server and run the service.

By default the latest stable version of MongoDB 3.X packages will be installed from official
repository at `repo.mongodb.org`_.

.. note::

  By default on Debian 8 (or later) MongoDB 2.4 packages will be installed from distribution
  repository. It is also possible to install newer version from `repo.mongodb.org`_ by setting
  ``mongodb:lookup:use_repo`` Pillar to the ``True`` and other related keys. See ``pillar.example``
  file for details.

.. _`repo.mongodb.org`: https://repo.mongodb.org/

``mongodb.logrotate``
---------------------

Install MongoDB logrotate configuration file.

``mongodb.mongos``
------------------

Install/configure MongoDB query router service.

This state requires ``mongos:settings:config_svrs`` Pillar to be set correctly, its value will be
substituted as argument for ``--configdb`` option of ``mongos`` executable (in the configuration
file). See `MongoDB reference manual`_ for additional information.

.. note::

  The state currently works only on Ubuntu LTS releases 12.04 and 14.04.

.. _`MongoDB reference manual`: https://docs.saltstack.com/en/latest/topics/mine/index.html

``mongodb.tools``
-----------------

Install additional tools and Python libraries.

Operating systems support
=========================

This formula works "out-of-the-box" and tested on those operating systems:

- CentOS/Red Hat Enterprise Linux 5, 6 and 7
- Debian GNU/Linux 8 "Jessie" (stable)
- Ubuntu LTS 12.04
- Ubuntu LTS 14.04


.. vim: fenc=utf-8 spell spl=en cc=100 tw=99 fo=want sts=2 sw=2 et
