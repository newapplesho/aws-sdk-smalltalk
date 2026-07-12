---
paths:
  - "src/**/*.st"
---

# Pharo Coding Rules

Based on [Pharo with Style](https://books.pharo.org/booklet-WithStyle/).

This file is **project-independent** — it can be copied as-is to any Pharo project
using Tonel format. Project-specific conventions (class prefix, custom protocol
names) live in `project-conventions.md`.

## Development Cycle

Edit `.class.st` files, reload into the Pharo image via Metacello or Iceberg, run tests.
Edits to Tonel files are **not live** until re-imported into the image.

## Method Constraints

- **15 lines maximum** per method — extract helpers when exceeded
- **100 characters maximum** per line — wrap long expressions
- **Never access instance variables directly from outside the object** — always go through accessor messages
- Every method **must** have a protocol/category — unclassified methods are a style violation

## Syntax Quick Reference

```smalltalk
"--- Returns ---"
^ value                         "not: return value"

"--- Nil ---"
nil                             "not: null"

"--- Comments ---"
"this is a comment"             "not: // or /* */"

"--- Comparison ---"
x = y                           "value equality  (not: ==)"
x == y                          "identity only"
x ~= y                          "not equal       (not: !=)"

"--- Accessors: no get/set prefix ---"
count                           "getter  (not: getCount)"
count: n                        "setter  (not: setCount:)"

"--- Conditionals ---"
x > 0 ifTrue: [ ... ].
x ifNil: [ ... ].
x ifNil: [ ... ] ifNotNil: [:v | ... ].

"--- Guard clause: early return instead of nesting ---"
config ifNil: [ ^ AWSException signal: 'No config' ].

"--- Loops ---"
1 to: 10 do: [:i | ... ].
collection do: [:each | ... ].
collection doWithIndex: [:each :i | ... ].

"--- Collections: prefer semantic messages ---"
col isEmpty.                    "not: col size = 0"
col notEmpty.                   "not: col size > 0"
col includes: x.
col collect: [:x | x * 2 ].
col select: [:x | x > 0 ].
col detect: [:x | x > 0 ] ifNone: [ nil ].
col inject: 0 into: [:sum :x | sum + x ].

"--- yourself: return receiver after cascade ---"
^ OrderedCollection new
    add: firstItem;
    add: secondItem;
    yourself

"--- Exceptions ---"
[ risky ] on: Error do: [:e | self handleError: e ].
[ risky ] ensure: [ resource release ].

"--- initialize: super first ---"
MyClass >> initialize [
    super initialize.
    count := 0
]

"--- Abstract method ---"
MyClass >> abstractMethod [ self subclassResponsibility ]
```

## Message Formatting

Method bodies **must** use a newline and indent — never inline on the same line as the selector.
The only exception is `self subclassResponsibility`.

```smalltalk
"--- NG: single-line body + space-aligned columns ---"
MyConstants class >> maxRetries     [ ^ 18 ]

"--- OK: body on new line, indented ---"
MyConstants class >> maxRetries [
	^ 18
]
```

Long lines (>100 chars) must be wrapped. Rules by message type:

| Kind | Rule |
|---|---|
| Unary | One line |
| Binary | One line; parenthesize if needed |
| Keyword (1 pair) | One line if ≤100 chars |
| Keyword (multiple pairs) | One `keyword: arg` pair per line, 1 tab indent |
| Cascade (`;`) | One message per line, aligned under receiver |

```smalltalk
"--- multiple keywords: one pair per line ---"
request := self
	createRequest: aRequestBody
	url: url
	method: method.

"--- cascade: newline per message ---"
^ OrderedCollection new
	add: firstItem;
	add: secondItem;
	yourself.

"--- condition block: one space before and after [ ---"
x > 0 ifTrue: [ self doSomething ].
result ifNil: [ ^ AWSException signal: 'No result' ].
```

## Code Style Idioms

| Anti-pattern | Correct | Reason |
|---|---|---|
| `value isNil ifTrue: [...]` | `value ifNil: [...]` | specialized message |
| `value notNil ifTrue: [...]` | `value ifNotNil: [:v | ...]` | passes non-nil value |
| `col at: 1` | `col first` | intent is clear |
| `col at: col size` | `col last` | intent is clear |
| `MyClass new` (inside a method) | `self class new` | rename-safe, inheritance-friendly |
| `flag = true` | `flag` | redundant comparison |
| `flag = false` | `flag not` | redundant comparison |
| `^ condition ifTrue: [ true ] ifFalse: [ false ]` | `^ condition` | boolean IS the result |

Instance variable access rules:

- **Outside `initialize`**: always use accessor methods — never `ivar := value` directly
- **Inside `initialize`**: direct assignment is permitted and expected

## Naming Conventions

| Kind            | Rule                                            | Example                |
|-----------------|-------------------------------------------------|------------------------|
| Class           | UpperCamelCase + project prefix (see `project-conventions.md`) | `AWSS3Config` |
| Action method   | lowerCamelCase verb                             | `createBucket:`, `invokeLambda:withPayload:` |
| Getter          | noun only (no `get`)                            | `regionName`, `accessKeyId` |
| Setter          | noun + `:` (no `set`)                           | `regionName:`, `accessKeyId:` |
| Predicate       | `is`/`has` + adjective                          | `isSuccess`, `hasEntity` |
| Instance var    | lowerCamelCase, no underscores                  | `awsConfig`, `httpClient` |
| Class var       | UpperCamelCase                                  | `Default`, `Instance`  |

## Protocol Names (standard set)

```
'instance creation'    class-side factory methods
'initialization'       initialize
'accessing'            getters and setters
'private'              internal helpers
'printing'             printOn:
'error handling'       error signaling helpers
'testing'              predicate methods (isText, hasEntity, etc.)
```

Project-specific protocols (e.g. `'low-level-api'`, `'api-putItem'`) are described
in `project-conventions.md`, including the ad hoc ones already present in the
legacy codebase.

## Class Comment Convention (first-person "I")

Every class must have a class comment. In Tonel format it is a quoted string
placed immediately before the `Class { ... }` definition.

```smalltalk
"I represent a set of credentials for AWS.

 I hold the accessKeyId, secretKey, sessionToken, region and endpoint used to
 sign and address a request to a single AWS service.
"
```

## Tonel File Layout

Each package is a directory under `src/`. The directory name **must match** the package name exactly.

```
src/
  .properties                ← Tonel repository marker (REQUIRED for CI)
  BaselineOfAWS/             ← directory name = package name
    package.st               ← Package { #name : 'BaselineOfAWS' }
    BaselineOfAWS.class.st
  AWS-S3/
    package.st               ← Package { #name : 'AWS-S3' }
    AWSS3.class.st
    ...
```

**`src/.properties` is required.** Without it, smalltalkCI assumes MCFileTree
format, causing `NotFound: BaselineOfAWS` in CI. Locally the explicit `tonel://`
prefix hides the problem, so the failure only surfaces in CI.

```ston
{
	#format : #tonel
}
```

## Project Root: `.project` File

Every Pharo/Smalltalk repository must have a `.project` file at the repository
root. This is Iceberg's project descriptor (hardcoded in
`IceBasicProject>>projectFilePath`), used to resolve `srcDirectory` and other
project metadata. It is part of the wider Pharo ecosystem convention (used by
Pharo itself, Seaside, Moose, Tonel, etc.) — not project-specific, so create it
when scaffolding any new Pharo project:

```
{
	'srcDirectory' : 'src'
}
```

Set `'srcDirectory'` to match the actual source folder name (`src` for
Tonel-based layouts, `pharo-repository` for legacy Monticello-package layouts).

## Metacello Baseline Convention

**CRITICAL:** The baseline package must be named `BaselineOf<ProjectName>`, NOT
`<ProjectName>-Baseline`. When Metacello runs `baseline: 'AWS'`, it looks for a
package literally named `BaselineOfAWS`. Any other name causes
`NotFound: BaselineOfAWS`.

## Do NOT Generate

- `return`, `null`, `//`, `!=`, `getX`, `setX:`
- Direct instance variable access from outside the owning class
- Methods longer than 15 lines
- Lines longer than 100 characters
- Methods without a protocol/category
- `^` inside blocks (causes non-local return — exits the enclosing method)
- 1-line method bodies with space-padding alignment: `method  [ ^ val ]`
- `isNil ifTrue: [...]` — use `ifNil: [...]`
- `notNil ifTrue: [...]` — use `ifNotNil: [:v | ...]`
- `col at: 1` — use `col first`; `col at: col size` — use `col last`
- `ClassName new` inside a method body — use `self class new`
- `flag = true` or `flag = false` — use `flag` or `flag not`
- `someVar := nil` inside `initialize` — instance variables are already `nil`;
  only set non-nil default values in `initialize`
