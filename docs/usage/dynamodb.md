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

For local development, `AWSDynamoDBConfig developmentDynamoDBSetting` points the
default config at DynamoDB Local on `localhost:8000` (see
[development.md](../development.md)).
