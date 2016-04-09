AWS SDK for Smalltalk
=================

The AWS SDK for Pharo Smalltalk enables Smalltalk developers to easily work with [Amazon Web Services](http://aws.amazon.com/) and Amazon DynamoDB, S3, Elastic Transcoder. You can get started in minutes using Metacello and FileTree.

<img src="http://2.bp.blogspot.com/-3caM96eyEOM/VJ6S70lf-YI/AAAAAAAAARM/IvmnJdN0yp0/s1600/20141225howsmalltalkerworks.jpg" width="400"/>

# Features
* AWS Signature version 4
* Amazon DynamoDB
* Amazon S3
* Elastic Transcoder

The following data types are supported for use in DynamoDB:

* Scalar types – Number, String.
* Multi-valued types – String Set, Number Set.

# Requirement
  - Pharo 3.0, Pharo 4.0.

# How to install

You can easily install from inside Smalltalk:

```smalltalk
Metacello new
    baseline: 'AWS';
    repository: 'github://newapplesho/aws-sdk-smalltalk:v1.6/pharo-repository';
    load.
```

or 

```smalltalk
Gofer new
url:'http://smalltalkhub.com/mc/newapplesho/aws-sdk-smalltalk/main';
    package: 'ConfigurationOfAWS';
    load.
(Smalltalk at: #ConfigurationOfAWS) load.
```

# How to use
[Wiki](https://github.com/newapplesho/aws-sdk-smalltalk/wiki)
