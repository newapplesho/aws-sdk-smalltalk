# aws-sdk-smalltalk

The AWS SDK for Pharo Smalltalk. Wraps AWS REST APIs (S3, DynamoDB, Lambda,
SNS, STS, CloudFront, ElasticTranscoder) over Zinc (`ZnClient`), with a
hand-rolled Signature Version 4 implementation for request signing. Sources
are in [Tonel](https://github.com/pharo-vcs/tonel) format (`src/`): one
`.class.st` per class, one `package.st` per package.

## Commands

A `Makefile` wraps a local Pharo image in `pharo-local/` (see
[docs/development.md](docs/development.md)):

```bash
make setup   # one-time: download Pharo 13 image + VM into pharo-local/
make load    # load/reload the project into the image
make test    # run tests headless (pattern AWS.*, broader than what CI runs — see below)
make ui      # open the Pharo GUI
```

`scripts/load-project.st` is the single source of truth for the Metacello load
expression (paste into a Playground with Ctrl+D to load manually). CI uses
[smalltalkCI](https://github.com/hpi-swa/smalltalkCI):

```bash
smalltalkci -s Pharo64-13 .smalltalk.ston   # matrix also covers Pharo64-12
```

After editing a `.class.st` file, reload it into the image (`make load`,
re-run the Metacello load, or use Iceberg), otherwise the change is not
reflected in tests.

**CI test-scope constraint:** `.smalltalk.ston` only runs `SignatureV4Test`;
every other test (DynamoDB, S3/Lambda config) is excluded from CI because the
DynamoDB tests need a live DynamoDB Local instance. `make test` runs a
broader local pattern (`AWS.*`) — expect the DynamoDB integration tests to
fail unless DynamoDB Local is running (see
[docs/development.md](docs/development.md)). Full detail in
`.claude/rules/project-conventions.md`.

## Packages

| Package | Role |
|---------|------|
| AWS-Core | HTTP/REST foundation (`AWSClient`, `AWSResponse`, `AWSService`, `AWSConfig`, `AWSException`), SigV4 signing (`SignatureV4`) |
| AWS-S3 | S3 buckets/objects (XML responses) |
| AWS-SNS | SNS topics/platform applications (XML responses) |
| AWS-DynamoDB | DynamoDB tables/items (JSON only) |
| AWS-Lambda | Lambda function invocation (JSON only) |
| AWS-STS | Temporary credentials — `assumeRole`, `getSessionToken` (XML responses) |
| AWS-CloudFront | CDN invalidations (XML request/response) |
| AWS-ElasticTranscoder | Transcoding jobs/pipelines (JSON only) |
| BaselineOfAWS | Metacello baseline |

## Signing & error handling (overview)

Every service builds a `ZnRequest` in its own `createRequest:url:method:` and
signs it with `SignatureV4 creatAuthorization:andConfig:andDateTime:andOption:`
(implements AWS SigV4's 3-task algorithm from scratch on the legacy
`Cryptography` package's `SHA256`). Errors are signalled as a single, generic
`AWSException` (subclass of `Error`) — there is no per-service exception
hierarchy. See `.claude/rules/rest-api-patterns.md` for the full pattern with
quoted source, and `docs/architecture.md` for the class-relationship picture.

## Documentation style

- In Japanese text, do not put a space between Japanese characters and Latin
  characters (English words, code, numbers) — e.g. `AWSでは`, `Signature V4`.
- Do not use `→`. Express references with `：` and connections with words like
  `と` / `して`.

## Detailed rules

The rules are split into "generic (copyable to other Smalltalk projects)" and
"specific to this project". See `.claude/rules/README.md` for how they are
organized.

- Pharo syntax & naming (generic): `.claude/rules/pharo-syntax.md` (auto-loaded for `.st` files)
- REST API / SigV4 patterns (generic): `.claude/rules/rest-api-patterns.md` (auto-loaded for `src/AWS-*/`)
- Testing conventions: `.claude/rules/testing.md` (auto-loaded for test files)
- Project-specific conventions: `.claude/rules/project-conventions.md` (class-prefix inconsistency, packages, protocols, config defaults, known baseline gaps)
- Architecture: `docs/architecture.md`
- Authentication / credentials: `docs/authentication.md`

## Conventions for writing rules files

- **Language: English.**
- **Cite sources:** point to a primary source where one exists (official docs,
  class comments, e.g. `src/AWS-Core/SignatureV4.class.st`).
- **No speculation:** record only verified facts. If a reason is unknown,
  write "reason unknown" or omit it.
- **Only verified code:** include code examples only for patterns that have
  passed local tests, or are quoted verbatim from source already in the repo.
