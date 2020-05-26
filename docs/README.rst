.. _readme:

mongodb-formula
==================

Formula for MongoDB on GNU/Linux and MacOS.

|img_travis| |img_sr|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/mongodb-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/mongodb-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release


.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.  If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_. If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``, which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.  See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

Special notes
-------------

By default only MongoDB server component (`mongod`) is installed.  This behaviour is configurable via pillars.

.. code-block:: yaml

    mongodb:
      wanted:
        # choose what you want or everything
        database:
          - mongod
          - mongos
          - dbtools
          - shell
        gui:
          - robo3t
          - compass
        connectors:
          - bi
          - kafka

Configuration can be supplied in yaml:

.. code-block:: yaml

    mongodb:
      pkg:
        database:
          version: 4.2.6.1
          archive:
            skip_verify: true
          config:
            # http://docs.mongodb.org/manual/reference/configuration-options
            storage:
              dbPath: /var/lib/mongodb/mongod
            replication:
              replSetName: "rs1"
            sharding:
              clusterRole: shardsvr
            net:
              bindIp: '0.0.0.0,::'
              port: 27018
          firewall:
            ports:
              - tcp/27017
              - tcp/27018
              - tcp/27019

Contributing to this repo
-------------------------

**Commit message formatting is significant!!**

Please see :ref:`How to contribute <CONTRIBUTING>` for more details.

Available metastates
--------------------

.. contents::
   :local:

``mongodb``
^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This installs the MongoDB solution.


``mongodb.install``
^^^^^^^^^^^^^^^^^

This state will install mongodb components on MacOS and GNU/Linux from archive.

``mongodb.config``
^^^^^^^^^^^^^^^^

This state will apply mongodb service configuration (files).

``mongodb.service``
^^^^^^^^^^^^^^^^^

This state will start mongodb component services.

``mongodb.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^

This state will stop mongodb component services.

``mongodb.config.clean``
^^^^^^^^^^^^^^^^^^^^^^

This state will remove mongodb service configuration (files).

``mongodb.clean``
^^^^^^^^^^^^^^^^^^^^^^^

This state will remove mongodb components on MacOS and GNU/Linux.


Testing
-------

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``mongodb`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.

