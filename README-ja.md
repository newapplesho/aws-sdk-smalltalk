AWS SDK for Smalltalk
=================
AWS SDK for SmalltalkはSmalltalerが簡単にAmazon Web Servicesを利用できるライブラリです。現在はAmazon DynamoDBとS3 のみ利用できます。MetacelloとFileTree環境を使ってインストールが可能です。

<img src="http://2.bp.blogspot.com/-3caM96eyEOM/VJ6S70lf-YI/AAAAAAAAARM/IvmnJdN0yp0/s1600/20141225howsmalltalkerworks.jpg" width="400"/>

#言語
* [English](https://github.com/newapplesho/aws-sdk-smalltalk/blob/master/README.md)
* [Japanese](https://github.com/newapplesho/aws-sdk-smalltalk/blob/master/README-ja.md)

# 公開して期待したいこと
**Smalltalkerが増えること。特に日本のSmalltalker。** あと私が英語が苦手（というかできないため）。心優しい方が翻訳していただけることを期待。*私の来年の最大の課題です。*

# 公開したものについて
公開したものは業務で使っているものもありますが、今回のために作成したものがあり、十分試験ができておりません。利用される場合は、自己責任でお願いします。

# 公開するもの
* AWSのほとんどのサービスにアクセスするためのSignature V4
* DynamoDBの接続クライアント（低レベル API、エラー処理は未実装）
* DynamoDBのマッパー（未完成）
* S3
 * バケット作成、削除 

Amazon DynamoDB for Smalltalkでサポートするデータ型(supports data types)
対応するデーター型は以下です。

* スカラーデータ型 - 文字列、数値
* 多値型 - 文字列セット、数値セット

# 必要要件
  - Pharo 3.0, Pharo 4.0

# インストール方法

##簡単インストール

```smalltalk
Gofer new
url:'http://smalltalkhub.com/mc/newapplesho/aws-sdk-smalltalk/main';
    package: 'ConfigurationOfAWS';
    load.
(Smalltalk at: #ConfigurationOfAWS) load.
```

##Git


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

# 使い方
slideshare
http://www.slideshare.net/newapplesho/aws-sdk-for-smalltalk

#今後について
DynamoDBの改良版、S3, EC2, Elastic Transcoderを公開予定。またEC2を操作するための証明書Signature V2も公開予定。