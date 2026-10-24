---
paths:
  - "src/AWS-*/**/*.st"
---

# REST API Patterns

This file is **reusable** for any Pharo library that wraps an AWS-style
Signature-V4-signed HTTP REST API with Zinc (`ZnClient`). This project has
**no UFFI** — there is no native library to load. Snippets below are quoted
directly from `src/AWS-Core/` and `src/AWS-S3/` and have passed local review
against the actual source.

## Layers

```
AWSS3 / AWSLambda / STS / CloudFront / AWSSNS   ← facades (extend AWSService)
  └─ AWSClient (S3Client / SNSClient / STSClient / ... subclass it) ← Zn wrapper
       └─ ZnClient                                                  ← Pharo Zinc HTTP
AWS<Service>Config (extends AWSConfig)                              ← credentials/region/endpoint
```

- **`AWSService`** (`src/AWS-Core/AWSService.class.st`) is the facade base.
  `client` lazily builds `self defaultClientClass awsConfig: self awsConfig`;
  `awsConfig` resolves `self defaultConfigClass default` or, if a `profile`
  was set, `self defaultConfigClass profile: profile`.
  `createRequest:url:method:` is `subclassResponsibility` — every service
  overrides it.
- **`AWSClient`** (`src/AWS-Core/AWSClient.class.st`) holds `awsConfig` and
  `httpClient`. `request:andOption:` builds a `ZnUrl` from the request's
  `host` header + the request's own url, sets the scheme from
  `awsConfig useSSL`, executes, and returns the raw `ZnResponse`:

  ```smalltalk
  AWSClient >> request: request andOption: anObject [
      | client url hostUrl keyUrl |
      client := self httpClient ifNil: [ self defaultHttpClient ].
      awsConfig useSSL
          ifTrue: [ client https ].
      client request: request.
      hostUrl := request headers at: 'host' ifAbsent: [ '' ].
      keyUrl := request url asString.
      url := ZnUrl fromString: hostUrl , keyUrl defaultScheme: #https.
      awsConfig useSSL
          ifFalse: [ url scheme: #http ].
      client url: url.
      client execute.
      ^ client response
  ]
  ```

  Per-service subclasses (`S3Client`, `SNSClient`, `STSClient`,
  `CloudFrontClient`) typically override `request:andOption:` to parse the
  response automatically:

  ```smalltalk
  S3Client >> request: request andOption: anObject [
      ^ self readFromResponse: (super request: request andOption: anObject).
  ]
  ```

  `DynamoDBRawClient` and the base `AWSClient` do **not** do this — callers
  get the raw `ZnResponse`/parsed body back and read it directly.

- **The shared signing step lives in `AWSService>>signRequest:`.** Each
  service's `createRequest:url:method:` sets only its service-specific headers
  (host, content-type, `x-amz-content-sha256`, ...) and then delegates the
  common tail — `x-amz-date`, session token, and `Authorization` — to
  `signRequest:`. Quoted from the current `AWSS3` and `AWSService`:

  ```smalltalk
  AWSS3 >> createRequest: aRequestBody url: url method: method andBucketName: bucketNameString [
      | hostUrl request |
      hostUrl := bucketNameString
          ifNil: [ self awsConfig endpoint ]
          ifNotNil: [ bucketNameString, '.', self awsConfig endpoint ].
      request := ZnRequest empty.
      request method: method.
      request url: url.
      request entity: (ZnEntity readBinaryFrom: aRequestBody asByteArray readStream
          usingType: ZnMimeType textPlain andLength: aRequestBody byteSize).
      request headers at: 'host' put: hostUrl.
      request headers at: 'x-amz-content-sha256' put: (SHA256 new hashMessage: aRequestBody) hex.
      ^ self signRequest: request
  ]

  AWSService >> signRequest: request [
      | datetimeString |
      datetimeString := self amzDatePrintString.
      request headers at: 'x-amz-date' put: datetimeString.
      self awsConfig sessionToken ifNotNil: [ :token |
          request headers at: 'X-Amz-Security-Token' put: token ].
      request setAuthorization: (SignatureV4
          creatAuthorization: request andConfig: self awsConfig
          andDateTime: datetimeString andOption: nil).
      ^ request
  ]
  ```

  New services should set their headers and call `^ self signRequest: request`
  rather than re-implementing the signing tail. `X-Amz-Security-Token` is added
  centrally in `signRequest:` (for every `AWSService`) — not by `SignatureV4`
  itself. `DynamoDBRawClient` is an `AWSClient`, not an `AWSService`, so it
  applies the same three steps inline instead of calling `signRequest:`.

  Two hooks support this: `AWSService>>awsConfig:` injects a config (so a
  service can be pointed at a test endpoint without touching the global
  singleton), and `AWSService>>amzDatePrintString:` pins the signing date-time
  (so signatures are deterministic in offline unit tests).

## Authentication / signing (SigV4)

`SignatureV4` (`src/AWS-Core/SignatureV4.class.st`) implements AWS Signature
Version 4 from the [AWS SigV4 documentation](https://docs.aws.amazon.com/general/latest/gr/signature-version-4.html)'s
3-task structure, on top of the legacy `Cryptography` package's `SHA256`:

1. **Task 1 — Canonical Request**: `createCanonicalRequest:andOption:`
   (method, `ZnUrl>>awsEncodeCanonicalUri`, sorted query string, canonical
   headers via `creatCanonicalHeaders:`, signed-header list via
   `createSignHeaders:`, SHA256 hex of the body).
2. **Task 2 — String to Sign**: `createStringtoSign:andDateTime:andCanonicalRequest:`.
3. **Task 3 — Signature**: `createDerivedSigningKey:andDateTime:` chains
   `SHA256 new hmac` over `'AWS4' , secretKey` → date → region → service →
   `'aws4_request'`; `createSign:andConfig:andDateTime:andOption:` HMACs the
   string-to-sign with the derived key.

The entry point every service calls is:

```smalltalk
SignatureV4 creatAuthorization: request andConfig: awsConfig andDateTime: datetimeString andOption: nil
```

which returns the full `Authorization` header value
(`AWS4-HMAC-SHA256 Credential=..., SignedHeaders=..., Signature=...`), set via
`request setAuthorization:`. A presigned-URL variant also exists:
`creatPreSignedUrlToRequest:config:dateTime:option:` (supports an `#expire`
option key for `X-Amz-Expires`).

Note the selector spelling is `creatAuthorization:`/`creatSign:`/
`creatCanonicalHeaders:`/`creatPreSignedUrlToRequest:...` (missing "e" in
"create") — this is the actual, existing API; do not silently "fix" the typo
in new code that calls these methods, since renaming would break every
caller.

## Response objects: JSON vs XML

`AWSResponse` (`src/AWS-Core/AWSResponse.class.st`) is the JSON-only base:

```smalltalk
AWSResponse >> value [
    | responseJson exception |
    responseJson := NeoJSONReader fromString: self response contents.
    self response isSuccess
        ifTrue: [ ^ responseJson ].
    exception := self defaultExceptionClass new.
    exception properties: responseJson.
    exception messageText: (responseJson at: 'message' ifAbsent: [ nil ]).
    exception signal.
]
```

JSON is read and written with **NeoJSON** (`NeoJSONReader fromString:` /
`NeoJSONWriter toString:`) throughout — objects parse to a plain `Dictionary`
with string keys, so use `at:ifAbsent:` for optional fields (a bare `at:` on a
missing key raises, unlike the old `JsonObject`).

Services whose API returns XML (S3, SNS, STS, CloudFront) override `value` to
branch on content type instead, e.g. `S3Response`
(`src/AWS-S3/S3Response.class.st`):

```smalltalk
S3Response >> value [
    | result exception |
    result := (self response hasEntity and: [ self response contentType sub = 'xml' ])
        ifTrue: [ XMLDOMParser parse: self response contents readStream ]
        ifFalse: [ self response contents ].
    self response isSuccess
        ifTrue: [ ^ result ].
    exception := self defaultExceptionClass new.
    exception properties: result.
    exception messageText: (result firstNode contentStringAt: 'Code').
    exception signal.
]
```

DynamoDB and Lambda use JSON only (no XML override needed).

## Error handling

There is a single, generic exception class: `AWSException`
(`src/AWS-Core/AWSException.class.st`, subclass of `Error`), reused by every
service via `defaultExceptionClass` — there is **no** per-service exception
hierarchy (contrast this with SDKs that define one exception class per
service). It is always **signalled**, never returned:

```smalltalk
[ s3 createBucket: 'my-bucket' ] on: AWSException do: [ :e | e messageText ]
```

Do not introduce a new exception subclass for a single service unless the
project as a whole is moving to a per-service hierarchy — that would be
inconsistent with every other service's error handling until the others are
migrated too.

## Session tokens (STS)

`AWSConfig>>sessionToken`/`sessionToken:` exists, and `AWSService>>signRequest:`
sets `X-Amz-Security-Token` for every service when it is non-nil
(`DynamoDBRawClient` does the same inline) — but **nothing in this codebase
automatically feeds an STS `assumeRole`/`getSessionToken` result back into an
`AWSConfig`**. Callers must extract the token from the returned XML themselves
and call `awsConfig sessionToken:` manually.
