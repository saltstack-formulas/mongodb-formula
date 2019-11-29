.. _readme:

mongodb
=======

|img_travis| |img_sr|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/mongodb-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/mongodb-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release

Install and configure MongoDB products on GNU/Linux and MacOS.

.. contents:: **Table of Contents**

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please pay attention to the ``pillar.example`` file and/or `Special notes`_ section.

Contributing to this repo
-------------------------

**Commit message formatting is significant!!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

Special notes
-------------

None

Available states
----------------

.. contents::
   :local:

``mongodb``
^^^^^^^^^^^

Metastate to deploy MongoDB products from packages and/or archive files.  

``mongodb.server``
^^^^^^^^^^^^^^^^^^

Deploy and configure MongoDB "Community Server" and start 'mongos' and 'mongod' services.

``mongodb.bic``
^^^^^^^^^^^^^^^

Deploy and configure MongoDB "Connector for BI" and start 'mongosqld' service.

``mongodb.compass``
^^^^^^^^^^^^^^^^^^^

Deploy Compass, the GUI for MongoDB

``mongodb.robo3t``
^^^^^^^^^^^^^^^^^^

Deploy Robo 3T (formerly Robomongo), another GUI for MongoDB

``mongodb.clean``
^^^^^^^^^^^^^^^^^

Metastate to uninstall MongoDB products

Other states
------------

``mongodb.server.config``

``mongodb.server.clean``

``mongodb.bic.config``

``mongodb.bic.clean``

``mongodb.compass.clean``

``mongodb.robo3t.clean``


Pillar Data
-----------
Use Linux distribution repo::

       mongodb:
         server:
           version: '4.0'

Use official upstream repo::

       mongodb:
         server:
           use_repo: true
           version: '4.0'

Use official upstream archives::

       mongodb:
         server:
           use_archive: true
           version: '4.0.3'
         bic:
           version: 2.7.0

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

.. vim: fenc=utf-8 spell spl=en cc=100 tw=99 fo=want sts=2 sw=2 et
