
Changelog
=========

`1.0.0 <https://github.com/saltstack-formulas/mongodb-formula/compare/v0.19.1...v1.0.0>`_ (2020-05-26)
----------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **script:** fix some travis tests (\ `63cfb1e <https://github.com/saltstack-formulas/mongodb-formula/commit/63cfb1e388b46f82b5e555f27839f618d49734f4>`_\ )

Code Refactoring
^^^^^^^^^^^^^^^^


* **all:** align to template; fix bugs and ci (\ `fc1ff28 <https://github.com/saltstack-formulas/mongodb-formula/commit/fc1ff28b9dc944bf9460c804e8a70d2be6cd4fb8>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **gemfile.lock:** add to repo with updated ``Gemfile`` [skip ci] (\ `e76b40c <https://github.com/saltstack-formulas/mongodb-formula/commit/e76b40ce14405173c1d4f88584dba8ef28c1eb07>`_\ )
* **kitchen:** avoid using bootstrap for ``master`` instances [skip ci] (\ `498b79f <https://github.com/saltstack-formulas/mongodb-formula/commit/498b79f6ffaeef4560c02d805536d20c6f7d1ba7>`_\ )
* **kitchen+travis:** adjust matrix to add ``3000.3`` [skip ci] (\ `f98319a <https://github.com/saltstack-formulas/mongodb-formula/commit/f98319a348c222462a0ef9bad7662e927b9f4e37>`_\ )
* **kitchen+travis:** remove ``master-py2-arch-base-latest`` [skip ci] (\ `2220bd9 <https://github.com/saltstack-formulas/mongodb-formula/commit/2220bd95bad711817b1deebf70184555fa3d66fc>`_\ )
* **travis:** add notifications => zulip [skip ci] (\ `81d3677 <https://github.com/saltstack-formulas/mongodb-formula/commit/81d3677a277b92b2de0998f2d98224607a32f4ac>`_\ )
* **workflows/commitlint:** add to repo [skip ci] (\ `3e8848d <https://github.com/saltstack-formulas/mongodb-formula/commit/3e8848db7b08dd3368b969039031d61916d6a2fb>`_\ )

Documentation
^^^^^^^^^^^^^


* **readme:** add depth one (\ `5680c6b <https://github.com/saltstack-formulas/mongodb-formula/commit/5680c6b151c1db2d43fb81d7d3b02c3bea0eedc6>`_\ )

Features
^^^^^^^^


* **semantic-release:** standardise for this formula (\ `f56ba6a <https://github.com/saltstack-formulas/mongodb-formula/commit/f56ba6ac75998b97842f897266b4c6b13d9e37c7>`_\ )

BREAKING CHANGES
^^^^^^^^^^^^^^^^


* **all:** The data dictionary is simplified and redesigned.
  This formula is aligned to template-formula with multiple fixes.
  Retest your states and update pillar data accordingly.
  For developer convenience, connectors and gui states are introduced.
  See pillar.example, defaults.yaml, and docs/README.
