# DynamoDB

See [Usage](../usage.md) for credential options, session tokens, and error
handling.

Items are plain `Dictionary` objects; the SDK maps them to/from DynamoDB's
typed JSON. A table is addressed by name:

```smalltalk
AWSDynamoDBConfig default
    accessKeyId: 'AWS_ACCESS_KEY_ID';
    secretKey: 'AWS_SECRET_ACCESS_KEY';
    regionName: 'ap-northeast-1'.

table := DynamoDBTable tableNamed: 'dynamoDbTestTable'.

"Put / get / delete an item"
table putItem: (Dictionary newFrom: { 'id' -> 'abc'. 'name' -> 'newapplesho' }).
table getItemBy: { #id -> 'abc' } asDictionary.
table deleteItem: { #id -> 'abc' } asDictionary.

"Conditional put"
table
    putItem: (Dictionary newFrom: { 'id' -> 'abc' })
    conditionExpressionString: 'attribute_not_exists(id)'.

"Query and scan"
table
    queryKeyConditionExpressionString: 'id = :id'
    binding: { ':id' -> 'abc' } asDictionary.
table scanNumberOfResultsToFetch: 100.

"Table metadata"
table describeTable.
table listTables.
```

### Type mapping

`DynamoDBMapper` converts values the same way as the official AWS SDKs:

| Pharo value | DynamoDB type |
|-------------|---------------|
| `nil` | `NULL` |
| `true` / `false` | `BOOL` |
| Integer, Float, ScaledDecimal | `N` (plain decimal string) |
| String / Symbol | `S` (an empty string is sent as `S ""`) |
| `ByteArray` | `B` (base64) |
| `Dictionary` | `M` |
| `Array`, `OrderedCollection` (any non-`Set` collection) | `L` |
| `Set` of Numbers / Strings / ByteArrays | `NS` / `SS` / `BS` |

Use a `Set` when you want a DynamoDB set; an `Array` such as `#(1 2 3)` is a
list (`L`). Sets read back as `Set`, lists as `Array`, maps as `Dictionary`
keyed by symbols. An `AWSException` is signalled for values DynamoDB would
reject: an empty `Set`, a `Set` mixing types, NaN / Infinity, and Fractions
(use a Float or ScaledDecimal instead). A whole-number Float such as `2.0` is
stored as `2` and reads back as an Integer.

For local development, `AWSDynamoDBConfig developmentDynamoDBSetting` points the
default config at DynamoDB Local on `localhost:8000` (see
[development.md](../development.md)).
