
Changelog
=========

`0.19.1 <https://github.com/saltstack-formulas/mongodb-formula/compare/v0.19.0...v0.19.1>`_ (2020-01-25)
------------------------------------------------------------------------------------------------------------

Code Refactoring
^^^^^^^^^^^^^^^^


* **variable:** rename private vars to (pkgname, name) (\ `55655d9 <https://github.com/saltstack-formulas/mongodb-formula/commit/55655d9d52a9b0a30c0f6ae3ac1d64aa19120bf5>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **gemfile:** restrict ``train`` gem version until upstream fix [skip ci] (\ `5405069 <https://github.com/saltstack-formulas/mongodb-formula/commit/54050694813564fe72b6af3cc6a3797f18fd69e7>`_\ )
* **travis:** use ``major.minor`` for ``semantic-release`` version [skip ci] (\ `e3be127 <https://github.com/saltstack-formulas/mongodb-formula/commit/e3be1276b87c1fece23c75b68342d6384c7b29f2>`_\ )

`0.19.0 <https://github.com/saltstack-formulas/mongodb-formula/compare/v0.18.3...v0.19.0>`_ (2019-11-29)
------------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **salt-lint:** fix all errors (\ `0b748ff <https://github.com/saltstack-formulas/mongodb-formula/commit/0b748ff3e1f1f2bf6b130c1af246e2d25f68cdfc>`_\ )
* **shellcheck:** fix all errors (\ `0399d36 <https://github.com/saltstack-formulas/mongodb-formula/commit/0399d36805563a65c2f08d931eba0130002e6001>`_\ )
* **yamllint:** fix all errors (\ `fe6ce81 <https://github.com/saltstack-formulas/mongodb-formula/commit/fe6ce812f4f4c478369d1b84e9f2975b47abb31c>`_\ )

Code Refactoring
^^^^^^^^^^^^^^^^


* **kitchen:** prefer ``kitchen.yml`` to ``.kitchen.yml`` (\ `7b5b905 <https://github.com/saltstack-formulas/mongodb-formula/commit/7b5b905d2755743f24e1f268bd1c837891a9a722>`_\ )

Documentation
^^^^^^^^^^^^^


* **readme:** modify according to standard structure (\ `f4af1ac <https://github.com/saltstack-formulas/mongodb-formula/commit/f4af1ac5d67632e0857e00d85252b112fc427b25>`_\ )
* **readme:** move to ``docs/`` directory (\ `668850e <https://github.com/saltstack-formulas/mongodb-formula/commit/668850eb36e133f6c59f9e27ad3c6be32189a745>`_\ )

Features
^^^^^^^^


* **semantic-release:** implement for this formula (\ `c778890 <https://github.com/saltstack-formulas/mongodb-formula/commit/c778890fb6c535f4dd244e78375f75aae64cd0f4>`_\ )

Tests
^^^^^


* **inspec:** add tests for package & service (\ `15b8d4c <https://github.com/saltstack-formulas/mongodb-formula/commit/15b8d4c820a20e6ccddcf3b4ecb5e6ddc6ad2e8e>`_\ )
* **pillar:** add pillar for ``default`` suite (from ``pillar.example``\ ) (\ `2167491 <https://github.com/saltstack-formulas/mongodb-formula/commit/216749170953cb9122e0558a2e74f9e774c2f67e>`_\ )
* **pillar:** install ``4.2`` from repo (\ `d6df790 <https://github.com/saltstack-formulas/mongodb-formula/commit/d6df790c83c541aa50d589a60f93c6d40c7ffa5b>`_\ )
