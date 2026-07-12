---
paths:
  - "src/**/*.st"
---

# aws-sdk-smalltalk — Project Conventions

This file holds everything **specific to this project**. The other rules
files (`pharo-syntax.md`, `rest-api-patterns.md`, `testing.md`) are generic
and reusable; when starting a new Smalltalk library, copy those and rewrite
only this file.

## Class Prefixes (inconsistent — documented as-is, not fixed)

Unlike a greenfield project, this codebase does **not** use a single
consistent class prefix. Match the existing convention within each package
rather than "correcting" it project-wide:

| Package | Config class | Facade / client / model classes |
|---------|--------------|----------------------------------|
| `AWS-Core` | `AWSConfig` | `AWSClient`, `AWSResponse`, `AWSService`, `AWSException`, `SignatureV4` |
| `AWS-S3` | `AWSS3Config` | `AWSS3` (facade), `S3Client`, `S3Response`, `S3Bucket` (bare `S3` prefix) |
| `AWS-SNS` | `AWSSNSConfig` | `AWSSNS` (facade), `SNSClient`, `SNSResponse`, `SNSPlatformApplication` (bare `SNS` prefix) |
| `AWS-STS` | `AWSSTSConfig` | `STS` (facade — **not** `AWSSTS`), `STSClient`, `STSResponse` |
| `AWS-CloudFront` | `AWSCFConfig` | `CloudFront` (facade — **not** `AWSCloudFront`), `CloudFrontClient`, `CFModel`/`CFPaths`/`CFInvalidationBatch` (`CF` abbreviation) |
| `AWS-ElasticTranscoder` | `AETConfig` | `ElasticTranscoder` (facade — **not** `AWSElasticTranscoder`), `AET*` request/model classes |
| `AWS-DynamoDB` | `AWSDynamoDBConfig` | `DynamoDBRawClient`, `DynamoDBTable`, `DynamoDBOperations` and subclasses, `DynamoDBMapper` (bare `DynamoDB` prefix, no `AWS`) |
| `AWS-Lambda` | `AWSLambdaConfig` | `AWSLambda` (facade) |

The one consistent rule: **config classes are always `AWS<Service>Config`.**
Everything else varies per package — follow the sibling classes already in the
package you're editing.

## Packages

| Package | Role | `requires:` (per `BaselineOfAWS`) |
|---------|------|-------------------------------------|
| `AWS-Core` | Base classes: `AWSClient`, `AWSResponse`, `AWSService`, `AWSConfig`, `AWSException`, `SignatureV4` | (none declared) |
| `AWS-S3` | S3 bucket/object operations, XML responses | `AWS-Core`, `XMLParser` |
| `AWS-SNS` | SNS topics/platform applications, XML responses | `AWS-Core`, `XMLParser` |
| `AWS-DynamoDB` | DynamoDB table/item operations, JSON only | `AWS-Core` |
| `AWS-Lambda` | Lambda function invocation, JSON only | `AWS-Core` |
| `AWS-STS` | Temporary credentials (`assumeRole`, `getSessionToken`), XML responses | `AWS-Core` (runtime also uses `XMLParser` — see "Known baseline gaps" below) |
| `AWS-CloudFront` | CDN invalidations, XML request/response | `AWS-Core` (runtime also uses `XMLParser` — see below) |
| `AWS-ElasticTranscoder` | Transcoding jobs/pipelines, JSON only | `AWS-Core` |
| `BaselineOfAWS` | Metacello baseline | — |

Test classes and per-service model/operation classes physically live inside
their parent package's Tonel folder (there is no separate `AWS-Core-Tests`
folder on disk) but are tagged with a suffixed Pharo category, e.g.
`#category: #'AWS-Core-Tests'`, `#category: #'AWS-DynamoDB-Operations'`. New
tests/model classes should follow this same in-folder, suffixed-category
pattern rather than creating a new physical package.

## Protocol / Category Names in Use

In addition to the standard set in `pharo-syntax.md`, the existing code uses
several ad hoc, per-area protocol names — reuse the one matching the class
you're editing rather than inventing a new style:

```
'low-level-api'        AWSClient / DynamoDBRawClient / S3Client / SNSClient / STSClient
'api-putItem' etc.     DynamoDBTable — one protocol per DynamoDB operation
'public-listing'       S3Bucket
'actions'              CloudFront (getInvalidation:, postInvalidation:)
'job-Operations'       ElasticTranscoder job methods
'pipeline-Operations'  ElasticTranscoder pipeline methods
```

Known inconsistencies in the legacy code (do not copy into new code):
`'tests-private'` vs `'test-api-query'` (singular/plural), a typo
`'convencience'` on `AWSClient>>dateTimeString` (correct spelling elsewhere is
`'convenience'`), and one method left in `'as yet unclassified'`
(`AWSSNS>>publishMessage:arn:`). New methods should use a clean, consistently
pluralized `'tests-<area>'` / `'<area>'` protocol name.

## Config Defaults Per Service

All config classes subclass `AWSConfig` (`src/AWS-Core/AWSConfig.class.st`),
a typed wrapper over an `IdentityDictionary`. Key accessors: `accessKeyId`,
`secretKey`, `sessionToken`, `regionName` (default `'ap-northeast-1'` unless
overridden), `serviceName`, `apiVersion`, `hostUrl`, `endpoint` (defaults to
`hostUrl`), `useSSL` (default `true`). `AWSConfig class>>profile:` reads
AWS-CLI-style `~/.aws/config` + `~/.aws/credentials` (see
`docs/authentication.md`). Setting `hostUrl:` clears the cached `endpoint`;
setting `regionName:` clears both `hostUrl` and `endpoint` (they are lazily
recomputed as `<service>.<region>.amazonaws.com` unless explicitly set).

| Config | Default region | serviceName | Notable override |
|--------|-----------------|-------------|-------------------|
| `AWSS3Config` | `ap-northeast-1` | `s3` | `us-east-1` → `s3.amazonaws.com`; other regions → `s3-<region>.amazonaws.com` |
| `AWSLambdaConfig` | (unset) | `lambda` | minimal — only overrides `defaultServiceName` |
| `AWSDynamoDBConfig` | `ap-northeast-1` | `DynamoDB` | `apiVersion: '20120810'`; `developmentDynamoDBSetting` points `default` at DynamoDB Local (`localhost:8000`, `useSSL: false`, sample keys) |
| `AWSSNSConfig` | `eu-west-1` (only non-Tokyo default) | `sns` | — |
| `AWSCFConfig` | `us-east-1` | `cloudfront` | `apiVersion: '2016-09-29'`; `hostUrl` hardcoded to `cloudfront.amazonaws.com` (CloudFront is global) |
| `AWSSTSConfig` | `ap-northeast-1` | `sts` | `apiVersion` instance-side override hardcodes `'2011-06-15'`, ignoring whatever the class-side `defaultSTSSetting` stored via the inherited accessor — known inconsistency, not fixed here |
| `AWSIAMConfig` | — | `iam` | `hostUrl` = `iam.amazonaws.com` (no region in host) |
| `AETConfig` | (unset) | `elastictranscoder` | minimal, same shape as `AWSLambdaConfig` |

Each config class caches a class-side singleton in a `default` class-instance
variable, reset via a companion `initialize` class method — tests that need a
fresh config call `AWS<Service>Config initialize` first (see `testing.md`).

## Error Handling

Single exception class `AWSException` (subclass of `Error`), reused by every
service — see `rest-api-patterns.md` for the signalling pattern. There is no
per-service or per-error-code exception hierarchy.

## Authentication

See `docs/authentication.md` for the full picture. Summary: `AWSConfig
profile:` reads `~/.aws/config` + `~/.aws/credentials`; `STS>>assumeRoleRoleArn:roleSessionName:`
and `STS>>getSessionToken` (`src/AWS-STS/STS.class.st`) return parsed XML —
neither call wires the resulting token back into an `AWSConfig`
automatically; the caller must do that manually via `sessionToken:`.

## Known baseline / dependency gaps (documented, not fixed)

- `NeoJSON` is declared as a baseline dependency but is **not referenced
  anywhere** in the actual source — only `Json`/`JsonObject` (from the
  `Json-BackwardCompatibility` baseline) are used.
- `AWS-CloudFront` and `AWS-STS` use `XMLWriter`/`XMLDOMParser` at runtime
  (`CFModel`/`CFPaths`/`CFInvalidationBatch`, `STSResponse`) but their
  `BaselineOfAWS` package specs only `requires: #('AWS-Core')`, omitting
  `XMLParser` — unlike `AWS-S3`/`AWS-SNS`, which declare it correctly. Reason
  unknown; likely works today only because `XMLParser` gets loaded
  transitively by another package in the same image.
- The legacy `Cryptography` package (source of `SHA256`, used by
  `SignatureV4` and every service's `createRequest:...`) is declared in
  `BaselineOfAWS` only `for: #'pharo3.x'`, yet is used unconditionally by code
  that also targets Pharo 7–13 per the CI matrix. Reason unknown — do not
  assume this is safe to remove; do not silently "fix" the `for:` guard
  without confirming how `SHA256` actually gets loaded on modern Pharo images.

## CI Test Scope

`.smalltalk.ston` (`#testing`) restricts CI to `SignatureV4Test` only, and
`BaselineOfAWS`'s `Tests` group is `#('AWS-Core')` (`CI` group is `#('Tests')`).
Every other test class (DynamoDB, S3/Lambda config tests) exists in the repo
but does **not** run in CI. This is an intentional-looking constraint tied to
the DynamoDB tests needing a live DynamoDB Local instance — see `testing.md`
and `docs/development.md` for how to run the broader suite locally via `make
test`.

## Documentation Style

- In Japanese text, do not put a space between Japanese characters and Latin
  characters (English words, code, numbers) — e.g. `AWSでは`, `Signature V4`.
- Do not use `→`. Express references with `：` and connections with words like
  `と` / `して`.

## Reference Docs

- Architecture: `docs/architecture.md`
- Local development workflow: `docs/development.md`
- Authentication / credentials: `docs/authentication.md`
- AWS Signature Version 4 (source of truth for `SignatureV4`):
  https://docs.aws.amazon.com/general/latest/gr/signature-version-4.html
