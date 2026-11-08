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

This fetches Pharo 14 via `get.pharo.org` (the README lists 12.0/13.0/14.0 as the
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

## Pinned dependencies

Dependencies are fixed at commit SHAs with
[metacello-pin](https://github.com/newapplesho/pharo-metacello-pin), in two
places:

- `BaselineOfAWS>>baseline:` pins the direct dependencies (`NeoJSON`,
  `XMLParser`). The original ref is kept as a comment, e.g.
  `'github://svenvc/NeoJSON:11e274dd.../repository' "master"`. Everyone who
  loads this project gets these SHAs.
- `metacello.lock.st` (repository root, generated, do not edit by hand) locks
  the whole tree, including the dependencies of `XMLParser`
  (`BitmapCharacterSet`, `OrderPreservingDictionary`, `XMLWriter`), whose own
  baselines name branches. It is evaluated before the project is loaded by
  `scripts/load-project.st` (`make load`) and by both smalltalkCI specs
  (`#preLoading` in `.smalltalk.ston` and `.smalltalk.ci-integration.ston`).
  People who load this project from their own image do not evaluate it.

Dependabot does not update these SHAs.

### Updating the SHAs

metacello-pin runs in its own Pharo image, not in `pharo-local/`. One-time
setup:

```bash
git clone https://github.com/newapplesho/pharo-metacello-pin
cd pharo-metacello-pin
make setup PHARO_VERSION=140
make load
```

Then, from `pharo-metacello-pin/pharo-local/`, with `REPO` set to the
absolute path of this repository (set `GITHUB_TOKEN` to avoid the GitHub API
rate limit):

1. In `src/BaselineOfAWS/BaselineOfAWS.class.st`, put the ref you want back in
   place of the SHA (e.g. `'github://svenvc/NeoJSON:master/repository'`, or a
   tag) and drop the old comment. `pin` only rewrites references that are not
   pinned yet. You can also edit the SHA by hand.
2. Pin the baseline, then regenerate the lock file:

   ```bash
   ./pharo --headless Pharo.image metacello-pin pin "$REPO/src"
   ./pharo --headless Pharo.image metacello-pin lock "$REPO/src" --output "$REPO/metacello.lock.st"
   ./pharo --headless Pharo.image metacello-pin check "$REPO/src"   # exit 1 if anything is unpinned
   ```

3. Do a clean reload (delete `pharo-local/Pharo.image`, `make setup`,
   `make load`) and run the tests.

Always regenerate `metacello.lock.st` after changing a pin. A locked project
is not replaced when the baseline asks for another version (metacello-pin
README, "Lock file"), so a stale lock file silently overrides the new pin in
`make load` and in CI.

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
| BaselineOfAWS | Metacello baseline |

New classes go into the existing packages — no baseline edit needed, unless
you are adding an entirely new service package (in which case update
`BaselineOfAWS>>baseline:` too).

## Test scope (known constraint)

Two different things run tests, with two different scopes:

- **CI `build` job** (`smalltalkci` + `.smalltalk.ston`, Pharo 12/13/14) runs
  only the offline unit-test classes listed in `.smalltalk.ston`'s
  `#include` (`SignatureV4Test`, `AWSClientTest`, `AWSS3ConfigTest`,
  `AWSS3RequestTest`, `AWSLambdaConfigTest`, `AWSLambdaRequestTest`,
  `DynamoDBListTablesTest`, `DynamoDBMapperTest`,
  `DynamoDBRawClientRequestTest`). `BaselineOfAWS`'s
  `Tests` group (`CI` group is `Tests`) loads `AWS-Core`, `AWS-S3`,
  `AWS-Lambda` and `AWS-DynamoDB` so those classes are present.
- **CI `integration` job** (`.smalltalk.ci-integration.ston`, Pharo 14)
  starts the emulators and runs the full `AWS.*` suite, including the live
  integration tests below.
- **`make test`** (this project's new local target) runs the broader
  `AWS.*` pattern directly against the Pharo test runner, independent of
  `.smalltalk.ston`. This picks up all test classes, including:
  - Pure unit tests (the `build` job's classes above, plus the S3 extension
    of `SignatureV4Test`) — always safe to run,
    no network required.
  - `DynamoDBRawClientTest` / `DynamoDBTableTest` — **live integration tests**
    against a real DynamoDB Local instance on `localhost:8000`.
  - `AWSS3IntegrationTest` — **live integration test** against a local
    [floci](https://floci.io) AWS emulator on `localhost:4566`.

  Both fail with connection errors unless the emulator is running.

The emulators are defined in `docker-compose.yml` at the repository root; the
images are pinned by digest (Dependabot keeps them current — see
`.github/dependabot.yml`). Bring them up with the Makefile targets:

```bash
make ddb-up                              # DynamoDB Local  (docker compose up -d dynamodb-local)
make floci-up                            # floci emulator  (docker compose up -d floci)
make emu-up                              # both
make test TEST_PATTERN=AWS-DynamoDB.*    # run just the DynamoDB tests
make test TEST_PATTERN=AWS-S3.*          # run just the S3 tests
make emu-down                            # stop everything (docker compose down)
```

floci is chosen over LocalStack because it is MIT-licensed and needs no auth
token (recent LocalStack images require one). It listens on the same port
(`4566`). The SDK addresses S3 buckets in virtual-hosted style, so requests go
to `<bucket>.localhost`. macOS resolves that name to `127.0.0.1` (RFC 6761
loopback); Linux does not, so the CI `integration` job adds the bucket host to
`/etc/hosts`. To run only the tests
that need no emulator, narrow the pattern, e.g. `make test TEST_PATTERN=AWS-Core.*`.

See `.claude/rules/testing.md` and `.claude/rules/project-conventions.md` for
the full detail on this constraint and on the two existing test styles.

## CI

`.github/workflows/ci.yml` runs smalltalkCI across a Pharo matrix
(`Pharo64-12`, `Pharo64-13` and `Pharo64-14`):

```bash
smalltalkci -s Pharo64-14 .smalltalk.ston
```

## Coding conventions

See [`.claude/rules/`](../.claude/rules/) — `pharo-syntax.md` (generic Pharo /
Tonel style), `rest-api-patterns.md` (Zinc + SigV4 request/response
patterns), `testing.md`, and `project-conventions.md` (this project's
class-prefix inconsistency, packages, protocols, config defaults, and known
baseline gaps). These are auto-loaded by Claude Code when editing.
