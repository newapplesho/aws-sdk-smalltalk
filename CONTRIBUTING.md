# Contributing

aws-sdk-smalltalk is an unofficial, community-maintained AWS SDK for Pharo
Smalltalk. This document describes how to report issues and submit changes.

Contributions are accepted under the project's [MIT License](LICENSE).

## Issues

Report bugs and feature requests at
<https://github.com/newapplesho/aws-sdk-smalltalk/issues>.

A bug report should state:

- the steps taken and the expected result;
- the actual result, including any error message or stack trace;
- the Pharo version (12.0 or 13.0) and the operating system;
- a minimal reproducing snippet where possible.

Do not include AWS access keys, secret keys, or session tokens in issues or
pull requests.

For a non-trivial change, open an issue before implementing it to agree on the
approach.

## Development setup

This is a Pharo / [Tonel](https://github.com/pharo-vcs/tonel) project built
against a local Pharo image:

```bash
make setup   # one-time: download Pharo 13 image + VM into pharo-local/
make load    # load (or reload) the project into the image
make test    # run tests headless (pattern AWS.*)
make ui      # open the Pharo GUI
```

Tonel `.class.st` files are not live until re-imported: run `make load` again
after editing source, before `make test`. If a change does not take effect, do
a clean reload (delete `pharo-local/Pharo.image`, then `make setup && make
load`) — Metacello's incremental load can miss new files.

[docs/development.md](docs/development.md) covers the full workflow (loading
without the Makefile, project layout, CI); [docs/usage.md](docs/usage.md)
documents the public API.

## Coding conventions

The conventions are defined in [`.claude/rules/`](.claude/rules/):

- [`pharo-syntax.md`](.claude/rules/pharo-syntax.md) — syntax, naming,
  formatting, Tonel layout.
- [`rest-api-patterns.md`](.claude/rules/rest-api-patterns.md) — request
  building, SigV4 signing via `AWSService>>signRequest:`, JSON/XML responses,
  error handling.
- [`testing.md`](.claude/rules/testing.md) — SUnit conventions.
- [`project-conventions.md`](.claude/rules/project-conventions.md) — packages,
  protocol names, config defaults, and class prefixes (which are inconsistent
  per package by design — match the sibling classes in the package you edit).

Points worth stating up front:

- Methods are at most 15 lines and 100 columns; every method has a protocol.
- Accessors take the noun form (`regionName`, `regionName:`), not `get`/`set`.
- Every class carries a class comment.
- New classes go into the existing `AWS-*` packages. Add a new package, and a
  `requires:` entry in `BaselineOfAWS`, only for a new service.

A service is a facade on `AWSService`. Its `createRequest:url:method:` sets the
service-specific headers (host, content type, payload hash) and delegates the
common signing tail — date, session token, `Authorization` — to
`AWSService>>signRequest:`. Errors surface as a single `AWSException`. Follow
this shape rather than introducing a parallel one.

## Tests

There are two test styles ([`testing.md`](.claude/rules/testing.md)):

- Offline unit tests (signing, config, request building) require no network and
  are the default for new logic. Pin the signing time with
  `amzDatePrintString:` and inject a config with `awsConfig:` to keep them
  deterministic.
- Live integration tests run against local emulators — DynamoDB Local and the
  [floci](https://floci.io) AWS emulator — defined in `docker-compose.yml`:

  ```bash
  make ddb-up      # DynamoDB Local  (AWS-DynamoDB tests)
  make floci-up    # floci emulator  (AWS-S3 tests)
  make test        # or: make test TEST_PATTERN=AWS-S3.*
  make emu-down    # stop the emulators
  ```

Add or update tests for any behavior you change, and confirm the suite passes
before opening a pull request.

## Pull requests

Open pull requests against `main`.

- Keep each pull request to one logical change.
- Include tests and documentation for the behavior you change.
- Run `make test` locally, starting the emulators first if the change touches
  an integration-tested service.
- Write commit messages that state what changed and why. The history uses a
  short type prefix for tooling-related commits (for example `ci:`).
- CI must pass: the `build` job (smalltalkCI on Pharo 12 and 13) and the
  `integration` job (the emulator-backed suite).
