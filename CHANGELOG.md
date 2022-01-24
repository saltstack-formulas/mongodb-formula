# Changelog

## [1.1.1](https://github.com/saltstack-formulas/mongodb-formula/compare/v1.1.0...v1.1.1) (2022-01-24)


### Bug Fixes

* **repo:** do not override service from package ([789bb9a](https://github.com/saltstack-formulas/mongodb-formula/commit/789bb9a7c205a80163bea96652e3e1e758387609))
* **users:** mongodb as system user/group ([0054e6e](https://github.com/saltstack-formulas/mongodb-formula/commit/0054e6ebf1f58411e8a7041d7f930e9cce93490e))


### Continuous Integration

* **kitchen+ci:** update with `3004` pre-salted images/boxes [skip ci] ([1ed6fd5](https://github.com/saltstack-formulas/mongodb-formula/commit/1ed6fd507b0ac58bb095b4860a40c01246e88fe2))
* **kitchen+ci:** update with latest `3003.2` pre-salted images [skip ci] ([c66a656](https://github.com/saltstack-formulas/mongodb-formula/commit/c66a6566142d5d30a429771601ed8562875b468a))
* **kitchen+ci:** update with latest CVE pre-salted images [skip ci] ([67228eb](https://github.com/saltstack-formulas/mongodb-formula/commit/67228eb31c1a646996efbdc5e534d056c075c3ce))

# [1.1.0](https://github.com/saltstack-formulas/mongodb-formula/compare/v1.0.3...v1.1.0) (2021-08-09)


### Continuous Integration

* **gemfile+lock:** use `ssf` customised `inspec` repo [skip ci] ([0baed21](https://github.com/saltstack-formulas/mongodb-formula/commit/0baed214054aff08236184d096d9add7c7442e35))
* add Debian 11 Bullseye & update `yamllint` configuration [skip ci] ([6266aa9](https://github.com/saltstack-formulas/mongodb-formula/commit/6266aa95d08e411f0a0d7ef456381ed0d5635f4f))
* **3003.1:** update inc. AlmaLinux, Rocky & `rst-lint` [skip ci] ([b34922b](https://github.com/saltstack-formulas/mongodb-formula/commit/b34922bd9448b22940f549ce2f498d39efeaf9ba))
* **kitchen:** move `provisioner` block & update `run_command` [skip ci] ([a1af7a5](https://github.com/saltstack-formulas/mongodb-formula/commit/a1af7a575a942a48bf1d3af026c78d790ce1e04f))


### Features

* **repository:** only take keys with values ([d71b5d1](https://github.com/saltstack-formulas/mongodb-formula/commit/d71b5d144818dd668af51bd7c158a5e797b05fa6))

## [1.0.3](https://github.com/saltstack-formulas/mongodb-formula/compare/v1.0.2...v1.0.3) (2021-06-24)


### Bug Fixes

* remove firewalld from dependencies ([7bf363c](https://github.com/saltstack-formulas/mongodb-formula/commit/7bf363c9830b86939d6442d615f4d03c435435c2))


### Continuous Integration

* **kitchen+gitlab:** remove Ubuntu 16.04 & Fedora 32 (EOL) [skip ci] ([f709345](https://github.com/saltstack-formulas/mongodb-formula/commit/f70934596c541cdfc4ab6f6276e5513101e8b6b0))
* add `arch-master` to matrix and update `.travis.yml` [skip ci] ([706b49f](https://github.com/saltstack-formulas/mongodb-formula/commit/706b49fe244a581c5621e3faabf04300d4a51687))
* **commitlint:** ensure `upstream/master` uses main repo URL [skip ci] ([8c82e2b](https://github.com/saltstack-formulas/mongodb-formula/commit/8c82e2b7bb4e49825cbe766a35bfc2a54c127d7b))
* **gemfile+lock:** use `ssf` customised `kitchen-docker` repo [skip ci] ([b24c101](https://github.com/saltstack-formulas/mongodb-formula/commit/b24c101f24c33c0f5f4b07cb13fbc2daffd34f0d))
* **gitlab-ci:** add `rubocop` linter (with `allow_failure`) [skip ci] ([586292c](https://github.com/saltstack-formulas/mongodb-formula/commit/586292c2e2d02202cc1474f524dce3401ac630d1))
* **gitlab-ci:** use GitLab CI as Travis CI replacement ([b743808](https://github.com/saltstack-formulas/mongodb-formula/commit/b7438088004ed6147338c4bead19e3dbb2ccee03))
* **kitchen+ci:** use latest pre-salted images (after CVE) [skip ci] ([74ce488](https://github.com/saltstack-formulas/mongodb-formula/commit/74ce4886c79f8192c207c1268313343bfa6ca946))
* **kitchen+gitlab:** adjust matrix to add `3003` [skip ci] ([d3e5feb](https://github.com/saltstack-formulas/mongodb-formula/commit/d3e5feb2ed06739ffb228ed06d51b6e9f0a754f8))
* **kitchen+gitlab-ci:** use latest pre-salted images [skip ci] ([7db78ba](https://github.com/saltstack-formulas/mongodb-formula/commit/7db78ba0919a42c271c48e26a40f9ba3ac142212))
* **pre-commit:** add to formula [skip ci] ([6849f80](https://github.com/saltstack-formulas/mongodb-formula/commit/6849f80287e608fdf7230ebe8dbdf9c4634f132e))
* **pre-commit:** enable/disable `rstcheck` as relevant [skip ci] ([ffe3388](https://github.com/saltstack-formulas/mongodb-formula/commit/ffe33882c7815cc8b3ba60c282bcfac770974947))
* **pre-commit:** finalise `rstcheck` configuration [skip ci] ([b9e0df0](https://github.com/saltstack-formulas/mongodb-formula/commit/b9e0df09fab10aa7cd14c32ec9b41aeab53d9f93))
* **pre-commit:** update hook for `rubocop` [skip ci] ([dccb17c](https://github.com/saltstack-formulas/mongodb-formula/commit/dccb17cbab62f4f1aa9ee438155f2e2ab5965d93))


### Documentation

* remove files which aren't formula-specific [skip ci] ([b8bfdd3](https://github.com/saltstack-formulas/mongodb-formula/commit/b8bfdd3a0e35d03095c1543f49f169972bb9f366))
* **readme:** fix headings and contributing link [skip ci] ([8e6d59b](https://github.com/saltstack-formulas/mongodb-formula/commit/8e6d59b4b3a30745e48f9ee24d6df4b5a80e883b))


### Tests

* standardise use of `share` suite & `_mapdata` state [skip ci] ([82a3b26](https://github.com/saltstack-formulas/mongodb-formula/commit/82a3b2611858189baa186fa098c3f5281fb6ad2f))

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
