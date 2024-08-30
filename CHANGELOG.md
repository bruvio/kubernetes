## [1.0.1](https://github.com/bruvio/kubernetes/compare/1.0.0-typhoon...1.0.1-typhoon) (2024-08-30)


### Bug Fixes

* add nginx ingress ([bcfb283](https://github.com/bruvio/kubernetes/commit/bcfb2833a91f77f43336b047034d5cdd5671c6c8))

# 1.0.0 (2024-08-30)


### Bug Fixes

* add custom components ([dd92fa7](https://github.com/bruvio/kubernetes/commit/dd92fa72f959eab3f359b1c1a055beaefc32a3de))
* add iam role output ([f9b7abc](https://github.com/bruvio/kubernetes/commit/f9b7abc336b49f9e131d66f47a72d11352b7f788))
* add iam role output ([84a62f8](https://github.com/bruvio/kubernetes/commit/84a62f871c51415be1a59e0ef2629b0be27f379f))
* add time wait before provisioning workers ([a35125a](https://github.com/bruvio/kubernetes/commit/a35125a5c8f0bf38fcb7cb749eae5cf3b6ee4400))
* add worker node labels ([1fdf8d1](https://github.com/bruvio/kubernetes/commit/1fdf8d10ee11db638c9eda6cf18436d57aa730d8))
* Apply the Hostname Change Without Rebooting ([b91caa6](https://github.com/bruvio/kubernetes/commit/b91caa64fce6d38c4671e460fa253dad8445aa34))
* associate public ip with ec2 ([eb9db8c](https://github.com/bruvio/kubernetes/commit/eb9db8ca9ca966a5990b0c715729c63e15e5708a))
* create workers after master ([43bd8f6](https://github.com/bruvio/kubernetes/commit/43bd8f666a2c58112dc93c08f7029c95717f77a4))
* dns zone name ([8ef4926](https://github.com/bruvio/kubernetes/commit/8ef4926d004fb005e989e02025e9f2e729d7911a))
* fix ec2 security group ([97a7166](https://github.com/bruvio/kubernetes/commit/97a7166e79ac5f1c00d0845337d1dd36618c77f9))
* fix env reference ([4d57c9a](https://github.com/bruvio/kubernetes/commit/4d57c9a981f9c98e9e5b4ca16dcbfabde4adced9))
* fix kubernetes install ([8caed23](https://github.com/bruvio/kubernetes/commit/8caed23316ea5b3a275c289a9c98fb2c3d96305d))
* fix nginx port mismatch ([1553cf5](https://github.com/bruvio/kubernetes/commit/1553cf5c2e679c1bd221e7a6b09b02974534faea))
* fix script installation ([0e5f164](https://github.com/bruvio/kubernetes/commit/0e5f1640030b0ce4a88375c944c31e960cb96ead))
* fix script to finalize installation ([96828b1](https://github.com/bruvio/kubernetes/commit/96828b11d545156dc7c3713d5d29e63d62c32c8e))
* fix sed command to mark cloud init completion ([d485936](https://github.com/bruvio/kubernetes/commit/d48593680a164d2a2efd39448f4b779615ddd020))
* fix state ([ec4d9c8](https://github.com/bruvio/kubernetes/commit/ec4d9c8d87e9fb90b4b9c36b7a21d6f9fc52c5a2))
* improve script ([cb55f89](https://github.com/bruvio/kubernetes/commit/cb55f8908044bb2cd8a7ef520d642064f3bb8ae0))
* improve script ([0161a3f](https://github.com/bruvio/kubernetes/commit/0161a3f10ccaddafb452530b6e61bad8142427be))
* improve script ([e26166e](https://github.com/bruvio/kubernetes/commit/e26166e2f12ad5b42760f939875147afea452ec6))
* improve tags and permission to ec2 ([6265e75](https://github.com/bruvio/kubernetes/commit/6265e7531fb5fee84cb1685b18f60d2c77d2bcc6))
* install go ([3ea50bb](https://github.com/bruvio/kubernetes/commit/3ea50bbd075ac98ab20f29f82fb7b786ba460cd9))
* kubeconfig - working ([840deda](https://github.com/bruvio/kubernetes/commit/840deda17f685c402cd425cce48378bf6e688ab4))
* manually attach iam role to service account ([f9bfb3a](https://github.com/bruvio/kubernetes/commit/f9bfb3a9777d7592f37f5fcb768c9bc066a0f6ef))
* nginx test ([a3aa500](https://github.com/bruvio/kubernetes/commit/a3aa500c618a35b3ffdeb945c3fc2ed3055c3742))
* pin kubernetes version to 1.30.0 ([7deba0f](https://github.com/bruvio/kubernetes/commit/7deba0f0be6972ad94d4e50aaaba8a5767cec091))
* pin kubernetes version, fix installation script ([58d10db](https://github.com/bruvio/kubernetes/commit/58d10db396882032ee4a393ad013c9124c033e28))
* refactor ([91dcabc](https://github.com/bruvio/kubernetes/commit/91dcabcd4de19462b41b1d3a1cefce9c7b3016ff))
* remove configfile ([b85bf28](https://github.com/bruvio/kubernetes/commit/b85bf28089bea000b1c7507732f295943612efab))
* test simple ([dc2e7b8](https://github.com/bruvio/kubernetes/commit/dc2e7b806f958899e55a49a4fbfb46302d5a1cb7))
* Update .releaserc.yml ([24a31c6](https://github.com/bruvio/kubernetes/commit/24a31c627c862e87d02e4313f43b5dc75844792a))
* Update release.yml ([c08c14d](https://github.com/bruvio/kubernetes/commit/c08c14da37102db23fa6c0039478f49a144c4916))
* use nodeport as loadbalancer is not working ([2cc69be](https://github.com/bruvio/kubernetes/commit/2cc69bed942981691326743418c8a986b400d622))
* use remove exec to wait for user data completion or time out ([3bb0557](https://github.com/bruvio/kubernetes/commit/3bb055744a8ed5131501259626ba5b7ad7b7f410))
* variables ([3954f7d](https://github.com/bruvio/kubernetes/commit/3954f7d53314c4190f15b35f3099fa16427f8394))
* working examples ([9f10fbe](https://github.com/bruvio/kubernetes/commit/9f10fbe82a9da8dd5f35dd92ebafb2c00b2b28b8))


### Features

* add cloud-provider-aws and networking plugin ([1e05384](https://github.com/bruvio/kubernetes/commit/1e053844b2924086253d5fd7abcfabdf4a74629d))
* add working script to setup the cluster ([87cb827](https://github.com/bruvio/kubernetes/commit/87cb827f3126eff64eb8b8717cabdf1758c1c55f))
* adding s3 bucket as storage and use to sync data to nodes ([a575f9c](https://github.com/bruvio/kubernetes/commit/a575f9ca2d3a040c8fe2b4f8c689239f13091236))
* adding terraform to deploy cluster ([7146773](https://github.com/bruvio/kubernetes/commit/7146773a2e9d8a9ccb8199cdb2e4099646b142ca))
* install nginx-ingress-controller ([1bc0995](https://github.com/bruvio/kubernetes/commit/1bc09955fafac705c843328cab860ab35270c2a6))
* switch to Typhoon ([edab076](https://github.com/bruvio/kubernetes/commit/edab076963222f828be1ca7f88289733dcfcf85b))
* update user data to deploy Kubernetes cluster with the Cloud Controller Manager (CCM) pre-configured ([b36baf1](https://github.com/bruvio/kubernetes/commit/b36baf142977d703c9e1d91835d85167c530aa61))
* use s3 backend ([9b2a063](https://github.com/bruvio/kubernetes/commit/9b2a06328e14bbb86e82c834947bee0e98c67fe9))


### Reverts

* remove installation of eksctl ([c240bd5](https://github.com/bruvio/kubernetes/commit/c240bd565ffca06e2c68e6ba504a35be4d3be35e))

## [1.3.5](https://github.com/bruvio/kubernetes/compare/1.3.4...1.3.5) (2024-08-25)


### Bug Fixes

* add iam role output ([f9b7abc](https://github.com/bruvio/kubernetes/commit/f9b7abc336b49f9e131d66f47a72d11352b7f788))
* add iam role output ([84a62f8](https://github.com/bruvio/kubernetes/commit/84a62f871c51415be1a59e0ef2629b0be27f379f))

## [1.3.4](https://github.com/bruvio/kubernetes/compare/1.3.3...1.3.4) (2024-08-25)


### Bug Fixes

* manually attach iam role to service account ([f9bfb3a](https://github.com/bruvio/kubernetes/commit/f9bfb3a9777d7592f37f5fcb768c9bc066a0f6ef))

## [1.3.3](https://github.com/bruvio/kubernetes/compare/1.3.2...1.3.3) (2024-08-24)


### Bug Fixes

* pin kubernetes version, fix installation script ([58d10db](https://github.com/bruvio/kubernetes/commit/58d10db396882032ee4a393ad013c9124c033e28))

## [1.3.2](https://github.com/bruvio/kubernetes/compare/1.3.1...1.3.2) (2024-08-24)


### Bug Fixes

* associate public ip with ec2 ([eb9db8c](https://github.com/bruvio/kubernetes/commit/eb9db8ca9ca966a5990b0c715729c63e15e5708a))
* fix ec2 security group ([97a7166](https://github.com/bruvio/kubernetes/commit/97a7166e79ac5f1c00d0845337d1dd36618c77f9))

## [1.3.1](https://github.com/bruvio/kubernetes/compare/1.3.0...1.3.1) (2024-08-24)


### Bug Fixes

* fix env reference ([4d57c9a](https://github.com/bruvio/kubernetes/commit/4d57c9a981f9c98e9e5b4ca16dcbfabde4adced9))

# [1.3.0](https://github.com/bruvio/kubernetes/compare/1.2.2...1.3.0) (2024-08-24)


### Features

* update user data to deploy Kubernetes cluster with the Cloud Controller Manager (CCM) pre-configured ([b36baf1](https://github.com/bruvio/kubernetes/commit/b36baf142977d703c9e1d91835d85167c530aa61))

## [1.2.2](https://github.com/bruvio/kubernetes/compare/1.2.1...1.2.2) (2024-08-24)


### Bug Fixes

* improve tags and permission to ec2 ([6265e75](https://github.com/bruvio/kubernetes/commit/6265e7531fb5fee84cb1685b18f60d2c77d2bcc6))

## [1.2.1](https://github.com/bruvio/kubernetes/compare/1.2.0...1.2.1) (2024-08-22)


### Bug Fixes

* fix sed command to mark cloud init completion ([d485936](https://github.com/bruvio/kubernetes/commit/d48593680a164d2a2efd39448f4b779615ddd020))

# [1.2.0](https://github.com/bruvio/kubernetes/compare/1.1.4...1.2.0) (2024-08-22)


### Bug Fixes

* add time wait before provisioning workers ([a35125a](https://github.com/bruvio/kubernetes/commit/a35125a5c8f0bf38fcb7cb749eae5cf3b6ee4400))
* create workers after master ([43bd8f6](https://github.com/bruvio/kubernetes/commit/43bd8f666a2c58112dc93c08f7029c95717f77a4))
* use remove exec to wait for user data completion or time out ([3bb0557](https://github.com/bruvio/kubernetes/commit/3bb055744a8ed5131501259626ba5b7ad7b7f410))


### Features

* adding s3 bucket as storage and use to sync data to nodes ([a575f9c](https://github.com/bruvio/kubernetes/commit/a575f9ca2d3a040c8fe2b4f8c689239f13091236))

## [1.1.4](https://github.com/bruvio/kubernetes/compare/1.1.3...1.1.4) (2024-08-21)


### Bug Fixes

* use nodeport as loadbalancer is not working ([2cc69be](https://github.com/bruvio/kubernetes/commit/2cc69bed942981691326743418c8a986b400d622))

## [1.1.3](https://github.com/bruvio/kubernetes/compare/1.1.2...1.1.3) (2024-08-21)


### Bug Fixes

* working examples ([9f10fbe](https://github.com/bruvio/kubernetes/commit/9f10fbe82a9da8dd5f35dd92ebafb2c00b2b28b8))

## [1.1.2](https://github.com/bruvio/kubernetes/compare/1.1.1...1.1.2) (2024-08-20)


### Bug Fixes

* Apply the Hostname Change Without Rebooting ([b91caa6](https://github.com/bruvio/kubernetes/commit/b91caa64fce6d38c4671e460fa253dad8445aa34))

## [1.1.1](https://github.com/bruvio/kubernetes/compare/1.1.0...1.1.1) (2024-08-20)


### Bug Fixes

* fix script to finalize installation ([96828b1](https://github.com/bruvio/kubernetes/commit/96828b11d545156dc7c3713d5d29e63d62c32c8e))

# [1.1.0](https://github.com/bruvio/kubernetes/compare/1.0.0...1.1.0) (2024-08-19)


### Features

* add working script to setup the cluster ([87cb827](https://github.com/bruvio/kubernetes/commit/87cb827f3126eff64eb8b8717cabdf1758c1c55f))

# 1.0.0 (2024-08-19)


### Bug Fixes

* fix kubernetes install ([8caed23](https://github.com/bruvio/kubernetes/commit/8caed23316ea5b3a275c289a9c98fb2c3d96305d))


### Features

* adding terraform to deploy cluster ([7146773](https://github.com/bruvio/kubernetes/commit/7146773a2e9d8a9ccb8199cdb2e4099646b142ca))
