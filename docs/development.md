# Development

How to work on aws-sdk-smalltalk itself (a Pharo / Tonel project).

## Prerequisites

- macOS or Linux (Windows: load manually in the Pharo UI — see below)
- `make`, `curl`, `bash`

## One-time setup

Download a local Pharo image + VM into `pharo-local/` (git-ignored):

```bash
make setup
```

This fetches Pharo 13 via `get.pharo.org` (the README lists 12.0/13.0 as the
currently CI-tested versions). To use a different version, override
`PHARO_VERSION` (e.g. `make setup PHARO_VERSION=120`).

## Daily cycle

```bash
make load    # load (or reload) the project into pharo-local/Pharo.image
make test    # run tests headless (JUnit XML), pattern AWS.* — see "Test scope" below
make ui      # open the Pharo GUI on the loaded image
make help    # list targets
```

Tonel `.class.st` files are **not live** until re-imported. After editing
source, run `make load` again (or reload via Iceberg in the UI) before
`make test`.

- `scripts/load-project.st` is the **single source of truth** for the
  Metacello load expression. Paste it into a Playground and press Ctrl+D to
  load manually (this is also the Windows path).
- `scripts/run-tests.st` runs the suite and prints a summary to the Transcript
  (handy inside the UI).

## Loading without the Makefile

In a Playground (any platform):

```smalltalk
Metacello new
    baseline: 'AWS';
    repository: 'github://newapplesho/aws-sdk-smalltalk:main/src';
    load.
```

For a working copy, replace the repository with your local checkout:
`'tonel://', '<repository root>/src'`.

## Project layout

| Package | Role |
|---------|------|
| AWS-Core | HTTP/REST foundation (`AWSClient`, `AWSResponse`, `AWSService`, `AWSConfig`, `AWSException`), SigV4 signing |
| AWS-S3 | S3 buckets/objects (XML responses) |
| AWS-SNS | SNS topics/platform applications (XML responses) |
| AWS-DynamoDB | DynamoDB tables/items (JSON only) |
| AWS-Lambda | Lambda function invocation (JSON only) |
| AWS-STS | Temporary credentials (XML responses) |
| AWS-CloudFront | CDN invalidations (XML request/response) |
| AWS-ElasticTranscoder | Transcoding jobs/pipelines (JSON only) |
| BaselineOfAWS | Metacello baseline |

New classes go into the existing packages — no baseline edit needed, unless
you are adding an entirely new service package (in which case update
`BaselineOfAWS>>baseline:` too).

## Test scope (known constraint)

Two different things run tests, with two different scopes:

- **CI** (`smalltalkci` + `.smalltalk.ston`) only runs `SignatureV4Test`.
  `BaselineOfAWS`'s `Tests` group is scoped to `AWS-Core` only (`CI` group is
  `Tests`), and `.smalltalk.ston`'s `#testing` block explicitly excludes every
  other `AWS.*` package. This is because the DynamoDB tests are live
  integration tests, not unit tests (see below), and CI has no DynamoDB Local
  instance to talk to.
- **`make test`** (this project's new local target) runs the broader
  `AWS.*` pattern directly against the Pharo test runner, independent of
  `.smalltalk.ston`. This picks up all test classes, including:
  - Pure unit tests (`SignatureV4Test` + its S3 extension, `AWSS3ConfigTest`,
    `AWSLambdaConfigTest`, `DynamoDBListTablesTest`) — always safe to run,
    no network required.
  - `DynamoDBRawClientTest` and `DynamoDBTableTest` — **live integration
    tests** against a real DynamoDB Local instance on `localhost:8000`; they
    will fail with connection errors unless one is running.

To run the DynamoDB integration tests locally, start DynamoDB Local first,
for example via Docker:

```bash
docker run -d -p 8000:8000 amazon/dynamodb-local
```

then `make test`. To run only the tests that don't need DynamoDB Local,
narrow the pattern, e.g. `make test TEST_PATTERN=AWS-Core.*`.

See `.claude/rules/testing.md` and `.claude/rules/project-conventions.md` for
the full detail on this constraint and on the two existing test styles.

## CI

`.github/workflows/ci.yml` runs smalltalkCI across a Pharo matrix
(`Pharo64-12` and `Pharo64-13`):

```bash
smalltalkci -s Pharo64-13 .smalltalk.ston
```

## Coding conventions

See [`.claude/rules/`](../.claude/rules/) — `pharo-syntax.md` (generic Pharo /
Tonel style), `rest-api-patterns.md` (Zinc + SigV4 request/response
patterns), `testing.md`, and `project-conventions.md` (this project's
class-prefix inconsistency, packages, protocols, config defaults, and known
baseline gaps). These are auto-loaded by Claude Code when editing.
