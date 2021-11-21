## Filtering

### Static Filtering

#### How to setup static filters for controller methods

1. Pass query modifier with necessary filter to controller's methods:

```swift

struct StarController {
    func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.Output>> {
        try ResourceController<Star.Output>().getCursorPage(
            req: req,
            queryModifier: QueryModifier { querybuilder, _ in
                queryBuilder.filter(\.$title == value)
            })
    }
}

```

2. Setup route:
 

```swift

app.group("stars") {
    let controller = StarController()
 
    $0.on(.GET, use: controller.index)
}

```

Such filter will be always applied to the paginated collection request

### Dynamic Filtering

*Restkit allows to define acceptable filtering keys for dynamic filtering.

Supported filter types: 
- value filters
- field filters allowing to filter against entity's other fields values*


#### How to setup dynamic filters query

1. Implement Fitler Key enum comforming to FilterQueryKey protocol

```swift

enum StarsFilterKeys: String, FilterQueryKey {
    case title
    case subtitle
    case size

    func filterFor(queryBuilder: QueryBuilder<Star>,
                   method: DatabaseQuery.Filter.Method,
                   value: String) -> QueryBuilder<Star> {

        switch self {
        case .title:
            return queryBuilder.filter(\.$title, method, value)
        case .subtitle:
            return queryBuilder.filter(\.$subtitle, method, value)
        case .size:
            guard let intValue = Int(value) else {
                return queryBuilder
            }
            return queryBuilder.filter(\.$size, method, intValue)
        }
    }

    static func filterFor(queryBuilder: QueryBuilder<Star>,
                          lhs: Self,
                          method: DatabaseQuery.Filter.Method,
                          rhs: Self) -> QueryBuilder<Star> {
        switch (lhs, rhs) {
        case (.title, .subtitle):
            return queryBuilder.filter(\.$title, method, \.$subtitle)
        case (.subtitle, .title):
            return queryBuilder.filter(\.$subtitle, method, \.$title)
        default:
            return queryBuilder
        }
    }
    
    
    // (Optional) This guy is used when there is no keys in the request query:
    
    static func emptyQueryFilter(queryBuilder: QueryBuilder<Star>)-> QueryBuilder<Star> {
        // does not filter anything in default implementation
        
        queryBuilder
    }
}
```

2. Pass  ```.filter(...)``` query modifier to necessary controller's methods:


```swift

struct StarController {
    func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.Output>> {
        try ResourceController<Star.Output>().getCursorPage(
            req: req,
            queryModifier: .filter(StarsFilterKeys.self))
    }
}

```

3. Setup route:
 

```swift

app.group("stars") {
    let controller = StarController()
 
    $0.on(.GET, use: controller.index)
}

```

#### Definitions


FilterQueryKey enum defines all keys that would be supported in queries: 


```swift 
 enum Keys: String, FilterQueryKey {
        typealias Model = Star

        case title
        case subtitle
        case size
}
```
The following func defines how filter query key is applied to the queryBuilder for value fitlers:
 

```swift
func filterFor(queryBuilder: QueryBuilder<Star>,
                           method: DatabaseQuery.Filter.Method,
                           value: String) -> QueryBuilder<Star> {
   ...
}

```

The following func defines how filter query key is applied to the queryBuilder for field fitlers:

```swift
static func filterFor(queryBuilder: QueryBuilder<Star>,
                                  lhs: Keys,
                                  method: DatabaseQuery.Filter.Method,
                                  rhs: Keys) -> QueryBuilder<Star> {
    ...                              
}
```

The following func allows to apply default filter in case of empty filter query:

```swift

static func emptyQueryFilter(queryBuilder: QueryBuilder<Star>)-> QueryBuilder<Star> {
    // does not filter anything in default implementation
    
    queryBuilder
}

```

#### How to use dynamic filters query

##### Filters methods
The following filter methods are supported for querying:

```swift
enum FilterOperations: String, Codable {
    case less = "lt"
    case greater = "gt"
    case lessOrEqual = "lte"
    case greaterOrEqual = "gte"
    case equal = "eq"
    case notEqual = "ne"

    case prefix = "prefix"
    case suffix = "suffix"
    case like = "like"
}
```
#### How to query Value Filter

RestKit uses JSON format to parse filter query string. Query key is **filter**, value is valid JSON string:

```JSON
{"value":  {"value": "X", "method": "eq", "key": "title"}}
```
So the overall request query will look like:

```
https://api.yourservice.com?/v1/stars?filter={"value":  {"value": "X", "method": "eq", "key": "title"}}
```

*All values should be passed as string even if it's numerical values.*

#### How to query Field Filter
For field filters, RestKit uses JSON of the following format to parse filter query string. 
Query key is **filter**, value is valid JSON string:
```json
{"field":  {"lhs": "title", "method": "eq", "rhs": "subtitle"}}
 ```
#### How to query Complex filters

Restkit supports complex nested filters with Value and/or Field filters:
- **OR** predicate:
```json
{"or": [
    {"value":  {"value": "AAPL", "method": "eq", "key": "ticker"} },
    {"field":  {"lhs": "title", "method": "eq", "rhs": "subtitle"}}
]}

```
- **AND** predicate:
```json
{"and": [
    {"value":  {"value": "AAPL", "method": "eq", "key": "ticker"} },
    {"value":  {"value": "F", "method": "like", "key": "ticker"} }
]}

```
 
#### How to query Complex nested filters

Element of array of nested filters can be also a complex nested filter:
```json
{"or": [
    {"value":  {"value": "Hello", "method": "eq", "key": "subtitle"} },
    {"and": [
        {"value":  {"value": "h", "method": "like", "key": "title"} },
        {"value":  {"value": "f", "method": "like", "key": "title"} },
        {"value":  {"value": "a", "method": "like", "key": "title"} }
    ]}
]}
```

The complexity of nested filters is not limited.
