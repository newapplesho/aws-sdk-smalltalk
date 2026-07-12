# AWS SDK for Smalltalk [![ci](https://github.com/newapplesho/aws-sdk-smalltalk/actions/workflows/ci.yml/badge.svg)](https://github.com/newapplesho/aws-sdk-smalltalk/actions/workflows/ci.yml)

The AWS SDK for Pharo Smalltalk enables Smalltalk developers to easily work with [Amazon Web Services](http://aws.amazon.com/). You can get started in minutes using Metacello.

# Supported Pharo Versions

| Pharo Version | aws-sdk-smalltalk |
| -------------- | ------------------ |
| 12.0, 13.0     | Latest Version     |
| 11.0           | v1.15.0             |
| 8.0, 7.0       | v1.11.1             |
| < 7.0          | v1.10.4             |

CI ([ci.yml](.github/workflows/ci.yml)) runs against Pharo 12 and 13 only.
v1.15.0 is the last version also tested against Pharo 11.

# How to install

You can easily install from inside Pharo Smalltalk:

## Pharo 12, 13

```smalltalk
Metacello new
    baseline: 'AWS';
    repository: 'github://newapplesho/aws-sdk-smalltalk:v1.15.0/src';
    load.
```

## Pharo 11

```smalltalk
Metacello new
    baseline: 'AWS';
    repository: 'github://newapplesho/aws-sdk-smalltalk:v1.15.0/src';
    load.
```

## Pharo 8 and GlamorousToolkit

```smalltalk
Metacello new
    baseline: 'AWS';
    repository: 'github://newapplesho/aws-sdk-smalltalk:v1.11.1/pharo-repository';
    onConflictUseLoaded;
    load.
```

## Pharo 7

```smalltalk
Metacello new
    baseline: 'AWS';
    repository: 'github://newapplesho/aws-sdk-smalltalk:v1.11.1/pharo-repository';
    load.
```

## Pharo 6

```smalltalk
Metacello new
    baseline: 'AWS';
    repository: 'github://newapplesho/aws-sdk-smalltalk:v1.10.4/pharo-repository';
    load.
```

# How to use

[Wiki](https://github.com/newapplesho/aws-sdk-smalltalk/wiki)

# Development

Working on aws-sdk-smalltalk itself (not just using it) requires a local
Pharo image:

```bash
make setup   # one-time: download a local Pharo image + VM into pharo-local/
make load    # load/reload the project into the image
make test    # run tests headless
make ui      # open the Pharo GUI
```

See [docs/development.md](docs/development.md) for the full workflow and test
scope, and [docs/architecture.md](docs/architecture.md) for the class design.
