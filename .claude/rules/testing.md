---
paths:
  - "src/AWS-*/**/*Test*.st"
---

# Testing Conventions

This file is **project-independent in spirit** (setUp/tearDown, naming,
assertions) but the "no live network" rule from other Smalltalk REST-client
projects does **not** apply here as-is — see "Two existing test styles" below,
which documents this project's actual, bimodal testing reality rather than an
aspirational one. Project-specific fixtures are described in
`project-conventions.md`.

Tests live inside their owning service's package folder (e.g.
`src/AWS-Core/SignatureV4Test.class.st`), not a separate `*-Tests` package —
this matches the existing layout; do not create a new top-level `-Tests`
package for new tests.

## Two existing test styles

1. **Pure unit tests, no network** — `SignatureV4Test` (+ its S3 extension in
   `src/AWS-S3/SignatureV4Test.extension.st`), `AWSS3ConfigTest`,
   `AWSLambdaConfigTest`, `DynamoDBListTablesTest`, `DynamoDBMapperTest`, and
   the stub-based request tests `AWSClientTest`, `AWSS3RequestTest`,
   `AWSLambdaRequestTest`, `DynamoDBRawClientRequestTest`. These assert against
   hard-coded fixtures (e.g. the official AWS SigV4 documentation examples) and
   have empty or absent `setUp`/`tearDown`.
2. **Live integration tests against a local emulator** —
   `DynamoDBRawClientTest`, `DynamoDBTableTest` (DynamoDB Local on
   `localhost:8000`) and `AWSS3IntegrationTest` (the [floci](https://floci.io)
   emulator on `localhost:4566`). Their `setUp` points a config at the emulator
   and creates a resource (a table, a bucket); `tearDown` deletes it. The
   DynamoDB tests use `AWSDynamoDBConfig developmentDynamoDBSetting`; the S3
   test injects a config via `awsConfig:` and reads `S3_TEST_ENDPOINT` /
   `S3_TEST_BUCKET` from the environment so CI can pin a bucket name. Unique
   keys/names use `UUID new asString`. The emulators are defined in
   `docker-compose.yml` (`make ddb-up` / `make floci-up`); see
   `docs/development.md`.

There is no mocking framework, but the HTTP layer has one hand-rolled stub:
`AWSHttpClientStub` (`src/AWS-Core/`), a plain object implementing the slice of
the `ZnClient` protocol that `AWSClient>>request:andOption:` uses. Inject it
with `AWSClient>>httpClient:` to test request dispatch offline
(`AWSClientTest`). For a genuinely new collaborator, prefer this same
hand-rolled-stub approach over adding a framework.

When adding a test for signing or config logic, follow style 1 (hard-coded
fixture, no network). When adding a test that necessarily exercises a live
AWS-like endpoint (as DynamoDB does via DynamoDB Local), follow style 2's
setUp/tearDown create-then-delete resource pattern and document the external
dependency in the test class comment.

## setUp / tearDown

```smalltalk
DynamoDBRawClientTest >> setUp [
	super setUp.
	AWSDynamoDBConfig initialize.
	AWSDynamoDBConfig developmentDynamoDBSetting.
	"... create a table used by this test ..."
]
```

Tests must be independent — do not rely on state left behind by another test
method.

## Test Method Naming

`test` + what is tested + expected outcome.

```
testCreatAuthorizationForS3
testEndpointForUsEast1
testLimitReturnsSetValue
```

(Note: the existing naming is inconsistent about singular/plural in categories
— `'tests-private'` vs `'test-api-query'` — do not copy that inconsistency into
new code; use the standard `'tests-<area>'` shape.)

## Assertions

```smalltalk
self assert: x equals: y.          "prefer over assert: (x = y)"
self assert: x.
self deny: x.
self should: [ AWSS3Config profile: 'missing' ] raise: Error.
```

Prefer `assert:equals:` over `assert: (x = y)` — gives better failure messages.

## CI test scope (known constraint)

CI has two jobs (`.github/workflows/ci.yml`):

- **`build`** runs `.smalltalk.ston`, which includes only the offline
  unit-test classes listed in its `#include` and excludes the rest of
  `AWS.*`. Offline, fast, runs on the Pharo 12/13 matrix. A new offline test
  class must be added to that `#include` list to run here.
- **`integration`** starts the emulators (`docker compose up -d`), adds one
  `/etc/hosts` line for the S3 bucket host (Linux does not resolve
  `*.localhost`, which floci's virtual-hosted addressing needs), and runs
  `.smalltalk.ci-integration.ston` — which loads all packages and runs the full
  `AWS.*` suite, including the live integration tests.

So a new integration test *does* run in CI via the `integration` job, but not
in `build`. See `docs/development.md` for running the suite locally via `make
test`, and `project-conventions.md` for the baseline/`.ston` wiring.
