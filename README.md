AWS SDK for Smalltalk
=================

The AWS SDK for Pharo Smalltalk enables Smalltalk developers to easily work with [Amazon Web Services](http://aws.amazon.com/) and Amazon DynamoDB, S3. You can get started in minutes using Metacello and FileTree.

<img src="http://2.bp.blogspot.com/-3caM96eyEOM/VJ6S70lf-YI/AAAAAAAAARM/IvmnJdN0yp0/s1600/20141225howsmalltalkerworks.jpg" width="400"/>

#language
* [English](https://github.com/newapplesho/aws-sdk-smalltalk/blob/master/README.md)
* [Japanese](https://github.com/newapplesho/aws-sdk-smalltalk/blob/master/README-ja.md)

# Features
* AWS Signature version 4
* Amazon DynamoDB
 * Low-level API
 * Easy-access library, in a more Smalltalk manner
* Amazon S3
 * Create Bucket and Delete Bucket	

The following data types are supported for use in DynamoDB:

* Scalar types – Number, String.
* Multi-valued types – String Set, Number Set.

# Requirement
  - Pharo 3.0, Pharo 4.0.

# How to install

You can easily install from inside Smalltalk:

```smalltalk
Gofer new
url:'http://smalltalkhub.com/mc/newapplesho/aws-sdk-smalltalk/main';
    package: 'ConfigurationOfAWS';
    load.
(Smalltalk at: #ConfigurationOfAWS) load.
```

or you may use git (complicated, but reveals package depencencies):

step 1

```bash
$ git clone https://github.com/newapplesho/aws-sdk-smalltalk
```

step 2

```smalltalk
| pathToPackageDirectory |
"edit to match the path to your chosen package directory"
pathToPackageDirectory := '/YOUR-GIT-DIRECTORY-PATH/aws-sdk-smalltalk/pharo-repository/'.
Metacello new
baseline: 'AWS';
repository: 'filetree://', pathToPackageDirectory;
load.
```

# How to use
slideshare
http://www.slideshare.net/newapplesho/aws-sdk-for-smalltalk


# TODO
* Improve the support for DynamoDB 
* EC2
* S3
* Elastic Transcoder