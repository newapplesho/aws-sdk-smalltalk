# Usage

How to call each AWS service with aws-sdk-smalltalk. For installation see the
[README](../README.md); for working on the SDK itself see
[development.md](development.md).

## Services

- [S3](usage/s3.md)
- [DynamoDB](usage/dynamodb.md)
- [SNS](usage/sns.md)
- [Lambda](usage/lambda.md)
- [STS](usage/sts.md)
- [CloudFront](usage/cloudfront.md)

## Credentials and configuration

Every service has a config class named `AWS<Service>Config` (a typed wrapper
over a settings dictionary). There are three ways to supply credentials; the
per-service pages above use the first for brevity.

**1. The shared default config** (simplest; mutates a per-service singleton):

```smalltalk
AWSS3Config default
    accessKeyId: 'AWS_ACCESS_KEY_ID';
    secretKey: 'AWS_SECRET_ACCESS_KEY';
    regionName: 'ap-northeast-1'.

s3 := AWSS3 new.   "picks up AWSS3Config default"
```

**2. An AWS CLI profile** from `~/.aws/config` + `~/.aws/credentials`
(see [authentication.md](authentication.md)):

```smalltalk
s3 := AWSS3 profile: 'myprofile'.
```

**3. An explicit config injected into the service** (no global state — good for
tests and for talking to several accounts/regions at once):

```smalltalk
s3 := AWSS3 new.
s3 awsConfig: (AWSS3Config new
    accessKeyId: 'AWS_ACCESS_KEY_ID';
    secretKey: 'AWS_SECRET_ACCESS_KEY';
    regionName: 'ap-northeast-1';
    yourself).
```

### Temporary credentials (session token)

Set `sessionToken:` on the config and every service sends it as
`X-Amz-Security-Token` (signed):

```smalltalk
s3 awsConfig sessionToken: 'FQoGZ...'.
```

`awsConfig` returns a stable config object (the default singleton, or the
injected/profile-resolved config, which the service caches), so setting the
token on it sticks for all three configuration styles.

Nothing wires an STS result into a config automatically — extract the token
from the STS response and set it yourself (see [STS](usage/sts.md)).

### Errors

Every service signals a single `AWSException` (a subclass of `Error`) on a
failed request:

```smalltalk
[ s3 createBucket: 'my-bucket' ]
    on: AWSException
    do: [ :e | Transcript showCr: e messageText ].
```
