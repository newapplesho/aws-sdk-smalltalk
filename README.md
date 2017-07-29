AWS SDK for Smalltalk
=================

The AWS SDK for Pharo Smalltalk enables Smalltalk developers to easily work with [Amazon Web Services](http://aws.amazon.com/). You can get started in minutes using Metacello and FileTree.

# Features
* AWS Signature version 4
* Amazon DynamoDB
* Amazon S3
* Elastic Transcoder
* STS
* CloudFront

The following data types are supported for use in DynamoDB:

* Scalar types – Number, String.
* Multi-valued types – String Set, Number Set.

# Requirement
  - Pharo 3.0, Pharo 4.0, Pharo 5.0, Pharo 6.0

# How to install

You can easily install from inside Smalltalk:

```smalltalk
Metacello new
    baseline: 'AWS';
    repository: 'github://newapplesho/aws-sdk-smalltalk:v1.10/pharo-repository';
    load.
```

# How to use
[Wiki](https://github.com/newapplesho/aws-sdk-smalltalk/wiki)
