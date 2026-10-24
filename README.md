# AWS SDK for Smalltalk [![ci](https://github.com/newapplesho/aws-sdk-smalltalk/actions/workflows/ci.yml/badge.svg)](https://github.com/newapplesho/aws-sdk-smalltalk/actions/workflows/ci.yml)

An unofficial AWS SDK for [Pharo](https://pharo.org) Smalltalk. It wraps the AWS
REST APIs — S3, DynamoDB, SNS, Lambda, STS and CloudFront — over Zinc
(`ZnClient`) HTTP with a hand-rolled Signature Version 4 implementation. No
native libraries and no generated code.

## Requirements

The current version targets **Pharo 12 and 13** (the versions CI runs against).
Older Pharo releases are served by earlier tags:

| Pharo | Use |
| ----- | --- |
| 12.0, 13.0 | latest (`main`) |
| 11.0 | tag `v1.15.0` |
| 7.0, 8.0 | tag `v1.11.1` |
| ≤ 6.0 | tag `v1.10.4` |

## Install

From inside Pharo 12 or 13, load with Metacello:

```smalltalk
Metacello new
    baseline: 'AWS';
    repository: 'github://newapplesho/aws-sdk-smalltalk:main/src';
    load.
```

For an older Pharo, use the matching tag from the table above. The pre-`v1.15.0`
tags keep their sources under `pharo-repository/` rather than `src/`, e.g.
`github://newapplesho/aws-sdk-smalltalk:v1.11.1/pharo-repository`.

## Usage

See [docs/usage.md](docs/usage.md) for per-service examples (S3, DynamoDB, SNS,
Lambda, STS, CloudFront) and credential configuration.

## Development

Working on aws-sdk-smalltalk itself (not just using it) uses a local Pharo image:

```bash
make setup   # one-time: download a local Pharo image + VM into pharo-local/
make load    # load/reload the project into the image
make test    # run tests headless
make ui      # open the Pharo GUI
```

See [docs/development.md](docs/development.md) for the full workflow (including
the local emulators the integration tests need), [docs/architecture.md](docs/architecture.md)
for the class design, and [CONTRIBUTING.md](CONTRIBUTING.md) to contribute.
