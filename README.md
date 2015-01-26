AWS SDK for Smalltalk
=================

The AWS SDK for Pharo Smalltalk enables Smalltalk developers to easily work with [Amazon Web Services](http://aws.amazon.com/) with Amazon DynamoDB. You can get started in minutes using Metacello and FileTree.

<img src="http://2.bp.blogspot.com/-3caM96eyEOM/VJ6S70lf-YI/AAAAAAAAARM/IvmnJdN0yp0/s1600/20141225howsmalltalkerworks.jpg" width="400"/>

#language
* [English](https://github.com/newapplesho/aws-sdk-smalltalk/blob/master/README.md)
* [Japanese](https://github.com/newapplesho/aws-sdk-smalltalk/blob/master/README-ja.md)

#開発経緯
Pharo Smalltalkでクラウドサービスを操作してみる - Smalltalk Advent Calendar 2014
http://qiita.com/newapplesho/items/3a4847386686e6f2f18d

# Features
* Amazon Web Services Signature version 4
* Amazon Web Services DynamoDB for Pharo Smalltalk Low API
* DynamoDB Easy Access Library

Amazon DynamoDB for Smalltalk supports the following data types:

* Scalar types – Number, String.
* Multi-valued types – String Set, Number Set.

# How to install

easy install

```smalltalk
Gofer new
url:'http://smalltalkhub.com/mc/newapplesho/aws-sdk-smalltalk/main';
    package: 'ConfigurationOfAWS';
    load.
(Smalltalk at: #ConfigurationOfAWS) load.
```

or

step 1
```bash
$ git clone https://github.com/newapplesho/aws-sdk-smalltalk
```

step 2
```smalltalk
| pathToPackageDirectory |
"edit to match the path to your chosen package directory"
pathToPackageDirectory := '/YOUR-GIT-DIRECTORY-PATH/aws-sdk-smalltalk/pharorepository/'.
Metacello new
baseline: 'AWS';
repository: 'filetree://', pathToPackageDirectory;
load.
```

# How to use
slideshare
http://www.slideshare.net/newapplesho/aws-sdk-for-smalltalk


#Next Support
* DynamoDB 
* EC2
* S3
* Elastic Transcoder
* Signature V2

ただし、AWSを色々いじるための時間と私のポケットマネーとの相談しながら作成していきます。

Copyright Sho Yoshida.
