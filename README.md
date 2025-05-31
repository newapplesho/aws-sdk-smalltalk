# AWS SDK for Smalltalk [![ci](https://github.com/newapplesho/aws-sdk-smalltalk/actions/workflows/ci.yml/badge.svg)](https://github.com/newapplesho/aws-sdk-smalltalk/actions/workflows/ci.yml)

The AWS SDK for Pharo Smalltalk enables Smalltalk developers to easily work with [Amazon Web Services](http://aws.amazon.com/). You can get started in minutes using Metacello.

# Supported Pharo Versions

| Pharo Version    | aws-sdk-smalltalk |
| ---------------- | ----------------- |
| 11.0, 12.0, 13.0 | Latest Version    |
| 8.0, 7.0         | v1.11.1           |
| < 7.0            | v1.10.4           |

# How to install

You can easily install from inside Pharo Smalltalk:

## Pharo 11, 12, 13

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
    repository: 'github://newapplesho/aws-sdk-smalltalk/pharo-repository';
    onConflictUseLoaded;
    load.
```

## Pharo 7

```smalltalk
Metacello new
    baseline: 'AWS';
    repository: 'github://newapplesho/aws-sdk-smalltalk/pharo-repository';
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
