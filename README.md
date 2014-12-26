AWS SDK for Smalltalk
=================

The AWS SDK for Pharo Smalltalk enables Smalltalk developers to easily work with [Amazon Web Services](http://aws.amazon.com/) with Amazon DynamoDB. You can get started in minutes using Metacello and FileTree.

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

```smalltalk
| pathToPackageDirectory  |
"edit to match the path to your chosen package directory"
pathToPackageDirectory := '/Users/sho/repository/aws-sdk-smalltalk/pharo-repository/'.
Metacello new
  baseline: 'AWS';
  repository: 'filetree://', pathToPackageDirectory;
  load.
```


#Next Support
* DynamoDB 
* EC2
* S3
* Elastic Transcoder
* Signature V2

ただし、AWSを色々いじるための時間と私のポケットマネーとの相談しながら作成していきます。

Copyright Sho Yoshida.

AWS SDK for Smalltalk
=================
AWS SDK for SmalltalkはSmalltalerが簡単にAmazon Web Servicesを利用できるライブラリです。現在はAmazon DynamoDBのみ利用できます。MetacelloとFileTree環境を使ってインストールが可能です。


#開発経緯
Pharo Smalltalkでクラウドサービスを操作してみる - Smalltalk Advent Calendar 2014
http://qiita.com/newapplesho/items/3a4847386686e6f2f18d

Smalltalkに何か還元すべきだと考え、公開することにしました。仕事を作成したものはサービスに特化させて作ってしまっため、業務外の時間を使って切り出して一般公開できるものを準備しました（いずれはSDK全てを公開します）。

# 公開して期待したいこと
**Smalltalkerが増えること。特に日本のSmalltalker。** あと私が英語が苦手（というかできないため）。心優しい方が翻訳していただけることを期待。*私の来年の最大の課題です。*

# 公開したものについて
公開したものは業務で使っているものもありますが、今回のために作成したものがあり、十分試験ができておりません。利用される場合は、自己責任でお願いします。

# 公開するもの
* AWSのほとんどのサービスにアクセスするためのSignature V4
* DynamoDBの接続クライアント（低レベル API、エラー処理は未実装）
* DynamoDBのマッパー（未完成）

Amazon DynamoDB for Smalltalkでサポートするデータ型(supports data types)
対応するデーター型は以下です。

* スカラーデータ型 - 文字列、数値
* 多値型 - 文字列セット、数値セット

# インストール方法

gitをcloneして以下のコードをWorkspaceで実行する。

```smalltalk
| pathToPackageDirectory |
"edit to match the path to your chosen package directory"
pathToPackageDirectory := '/Users/sho/repository/aws-sdk-smalltalk/pharo-repository/'.
Metacello new
  baseline: 'AWS';
  repository: 'filetree://', pathToPackageDirectory;
  load.
```

#今後について
DynamoDBの改良版、S3, EC2, Elastic Transcoderを公開予定。またEC2を操作するための証明書Signature V2も公開予定。ただし、AWSを色々いじるための時間と私のポケットマネーとの相談しながら作成していきます。

Copyright Sho Yoshida.

#References
* Pharo Smalltalkでクラウドサービスを操作してみる http://qiita.com/newapplesho/items/3a4847386686e6f2f18d
* How Smalltalker Works http://www.slideshare.net/newapplesho/how-smalltalker-works
* 愛せよ、さもなくば捨てよ http://www.slideshare.net/newapplesho/ss-42024412

