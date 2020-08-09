# Changelog

## [1.0.2](https://github.com/saltstack-formulas/mongodb-formula/compare/v1.0.1...v1.0.2) (2020-08-09)


### Bug Fixes

* **issues:** file various minor issues ([cf8b457](https://github.com/saltstack-formulas/mongodb-formula/commit/cf8b457bb75fcfde90cfa77d9ad113922bb1fc74))

## [1.0.1](https://github.com/saltstack-formulas/mongodb-formula/compare/v1.0.0...v1.0.1) (2020-08-09)


### Bug Fixes

* **config:** rename config file to .conf ([274e50b](https://github.com/saltstack-formulas/mongodb-formula/commit/274e50ba35b73d2d9fea1991ac246a48cd21b65e))
* **linux:** fixup linux ci/cd ([b002965](https://github.com/saltstack-formulas/mongodb-formula/commit/b00296553f36fb02ad6fae3961f1c9bad1fc415e))
* **macos:** hugepages in linux kernel only ([25a6883](https://github.com/saltstack-formulas/mongodb-formula/commit/25a6883d36540a78baea2d478ed3a22180d04c28))
* **macos:** launchctl and plist fixes ([543d5c7](https://github.com/saltstack-formulas/mongodb-formula/commit/543d5c7e6c0ff8a9de0b2cf3e086dee090a8fabd))


### Code Refactoring

* **jinja:** depreciate/replacer two variable names ([2f07675](https://github.com/saltstack-formulas/mongodb-formula/commit/2f076757cf31b216d11699d7604f5dc36614e454))


### Continuous Integration

* **kitchen:** use `saltimages` Docker Hub where available [skip ci] ([2f143f9](https://github.com/saltstack-formulas/mongodb-formula/commit/2f143f9dccfad53a52e0b7135a962daa60da9b9d))
* **kitchen+travis:** add new platforms [skip ci] ([c16bb41](https://github.com/saltstack-formulas/mongodb-formula/commit/c16bb4167af505633d7b0fd79f404d3adb5e02e5))


### Styles

* **libtofs.jinja:** use Black-inspired Jinja formatting [skip ci] ([af35635](https://github.com/saltstack-formulas/mongodb-formula/commit/af35635af74ce477d720d078b11bda654f140a44))

# [1.0.0](https://github.com/saltstack-formulas/mongodb-formula/compare/v0.19.1...v1.0.0) (2020-05-26)


### Bug Fixes

* **script:** fix some travis tests ([63cfb1e](https://github.com/saltstack-formulas/mongodb-formula/commit/63cfb1e388b46f82b5e555f27839f618d49734f4))


### Code Refactoring

* **all:** align to template; fix bugs and ci ([fc1ff28](https://github.com/saltstack-formulas/mongodb-formula/commit/fc1ff28b9dc944bf9460c804e8a70d2be6cd4fb8))


### Continuous Integration

* **gemfile.lock:** add to repo with updated `Gemfile` [skip ci] ([e76b40c](https://github.com/saltstack-formulas/mongodb-formula/commit/e76b40ce14405173c1d4f88584dba8ef28c1eb07))
* **kitchen:** avoid using bootstrap for `master` instances [skip ci] ([498b79f](https://github.com/saltstack-formulas/mongodb-formula/commit/498b79f6ffaeef4560c02d805536d20c6f7d1ba7))
* **kitchen+travis:** adjust matrix to add `3000.3` [skip ci] ([f98319a](https://github.com/saltstack-formulas/mongodb-formula/commit/f98319a348c222462a0ef9bad7662e927b9f4e37))
* **kitchen+travis:** remove `master-py2-arch-base-latest` [skip ci] ([2220bd9](https://github.com/saltstack-formulas/mongodb-formula/commit/2220bd95bad711817b1deebf70184555fa3d66fc))
* **travis:** add notifications => zulip [skip ci] ([81d3677](https://github.com/saltstack-formulas/mongodb-formula/commit/81d3677a277b92b2de0998f2d98224607a32f4ac))
* **workflows/commitlint:** add to repo [skip ci] ([3e8848d](https://github.com/saltstack-formulas/mongodb-formula/commit/3e8848db7b08dd3368b969039031d61916d6a2fb))


### Documentation

* **readme:** add depth one ([5680c6b](https://github.com/saltstack-formulas/mongodb-formula/commit/5680c6b151c1db2d43fb81d7d3b02c3bea0eedc6))


### Features

* **semantic-release:** standardise for this formula ([f56ba6a](https://github.com/saltstack-formulas/mongodb-formula/commit/f56ba6ac75998b97842f897266b4c6b13d9e37c7))


### BREAKING CHANGES

* **all:** The data dictionary is simplified and redesigned.
This formula is aligned to template-formula with multiple fixes.
Retest your states and update pillar data accordingly.
For developer convenience, connectors and gui states are introduced.
See pillar.example, defaults.yaml, and docs/README.
