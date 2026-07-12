# Authentication

How `aws-sdk-smalltalk` resolves AWS credentials, and per-service config
defaults.

## Credential resolution

Every service's config class (`AWSS3Config`, `AWSLambdaConfig`, ...)
subclasses `AWSConfig` (`src/AWS-Core/AWSConfig.class.st`). There are two ways
to get a config:

1. **Default, unauthenticated shape** — `AWS<Service>Config default` builds a
   config with just the service's default region/serviceName/host, with
   `accessKeyId`/`secretKey` left unset. Set them explicitly:

   ```smalltalk
   config := AWSS3Config default.
   config accessKeyId: 'AKIA...'.
   config secretKey: '...'.
   ```

2. **AWS-CLI-style profile file** — `AWSConfig class>>profile: aProfileName`
   reads credentials from `~/.aws/credentials` (`aws_access_key_id` /
   `aws_secret_access_key` for the named `[profile]` section, falling back to
   `[default]` if the profile isn't found, and to `self default` if neither
   exists) and the region from `~/.aws/config`. This is the same file
   format/location the official AWS CLI uses. Every `AWSService` subclass
   exposes this via `profile:`:

   ```smalltalk
   s3 := AWSS3 profile: 'my-profile'.
   ```

## Per-service config defaults

| Config | Default region | serviceName | Host/endpoint notes |
|--------|-----------------|-------------|----------------------|
| `AWSS3Config` | `ap-northeast-1` | `s3` | `us-east-1` → `s3.amazonaws.com`; other regions → `s3-<region>.amazonaws.com` |
| `AWSLambdaConfig` | (unset — falls through to `AWSConfig>>defaultRegionName`, `ap-northeast-1`) | `lambda` | standard `<service>.<region>.amazonaws.com` |
| `AWSDynamoDBConfig` | `ap-northeast-1` | `DynamoDB` | `apiVersion: '20120810'`; `developmentDynamoDBSetting` repoints `default` at DynamoDB Local (`localhost:8000`, `useSSL: false`, sample keys — see `docs/development.md`) |
| `AWSSNSConfig` | `eu-west-1` | `sns` | standard pattern |
| `AWSCFConfig` | `us-east-1` | `cloudfront` | `hostUrl` hardcoded to `cloudfront.amazonaws.com` — CloudFront is a global service, not regional |
| `AWSSTSConfig` | `ap-northeast-1` | `sts` | `apiVersion` is hardcoded to `'2011-06-15'` on the instance side regardless of what was set on `default` |
| `AWSIAMConfig` | — | `iam` | `hostUrl` = `iam.amazonaws.com` (no region in host — IAM is global) |
| `AETConfig` (ElasticTranscoder) | (unset) | `elastictranscoder` | standard pattern |

`useSSL` defaults to `true` for all configs. `endpoint` defaults to `hostUrl`
if not explicitly set; setting `regionName:` clears any cached `hostUrl`/
`endpoint` so they get recomputed from the new region.

## Temporary credentials (STS)

`STS` (`src/AWS-STS/STS.class.st`) exposes:

```smalltalk
STS new assumeRoleRoleArn: 'arn:aws:iam::123456789012:role/example' roleSessionName: 'session1'.
STS new getSessionToken.
```

Both sign and POST a request and return the **parsed XML response** from
AWS STS — the raw `AssumeRoleResponse` / `GetSessionTokenResponse` document.

**There is no automatic wiring from an STS result back into an `AWSConfig`.**
To actually use the temporary credentials for a subsequent call, extract
`AccessKeyId` / `SecretAccessKey` / `SessionToken` from the returned XML
yourself and set them on the target config:

```smalltalk
config accessKeyId: (extractedAccessKeyId).
config secretKey: (extractedSecretAccessKey).
config sessionToken: (extractedSessionToken).
```

`AWSConfig>>sessionToken:` exists specifically for this. Every service's
`createRequest:url:method:` checks `self awsConfig sessionToken` and, if
non-nil, sets the `X-Amz-Security-Token` header automatically — so once the
token is on the config, no further wiring is needed.

## See also

- `.claude/rules/project-conventions.md` — full per-service config defaults
  table and the `AWSSTSConfig apiVersion` inconsistency.
- `docs/architecture.md` — how config feeds into request signing.
