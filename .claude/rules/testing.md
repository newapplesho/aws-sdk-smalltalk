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
   `AWSLambdaConfigTest`, `DynamoDBListTablesTest`. These assert against
   hard-coded fixtures (e.g. the official AWS SigV4 documentation examples) and
   have empty or absent `setUp`/`tearDown`.
2. **Live integration tests against DynamoDB Local** —
   `DynamoDBRawClientTest`, `DynamoDBTableTest`. `setUp` calls
   `AWSDynamoDBConfig initialize` then `AWSDynamoDBConfig
   developmentDynamoDBSetting` (points the config at `localhost:8000` with
   sample credentials) and issues a real `CreateTable` call; `tearDown` issues
   a real `DeleteTable` call. These require an actual DynamoDB Local process
   listening on port 8000 (see `docs/development.md`) and use
   `UUID new primMakeUUID hex` to avoid item-key collisions between runs.

**There is no mocking/stubbing framework anywhere in this codebase.** When
adding a test for signing or config logic, follow style 1 (hard-coded fixture,
no network). When adding a test that necessarily exercises a live AWS-like
endpoint (as DynamoDB does via DynamoDB Local), follow style 2's
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

`.smalltalk.ston` only includes `SignatureV4Test` and excludes every other
`AWS.*` package from CI (`BaselineOfAWS`'s `Tests` group is scoped to
`AWS-Core` only). This is a pre-existing, intentional-looking constraint — the
DynamoDB integration tests need a live DynamoDB Local instance CI does not
provide. Do not assume a new test class will run in CI just because it exists;
see `docs/development.md` for how to run the fuller local suite via `make
test`, and `project-conventions.md` for the exact `.smalltalk.ston` /
baseline wiring.
