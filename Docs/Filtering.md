## Filtering

### Static Filtering
#### How to setup default filters for controller methods


1. Define filter struct, conforming to StaticFiltering protocol:

```swift
struct StarsFiltering: StaticFiltering {
    typealias Model = Star
    typealias Key = EmptyFilteringKey

    func defaultFiltering(_ queryBuilder: QueryBuilder<Star>) -> QueryBuilder<Star> {
        //no filter will be applied:
        return queryBuilder
    }
}

```

2. When defining controller, add filter type as collection controller builder parameter:

```swift

let controller = Star.Output
        .controller(eagerLoading: EagerLoadingUnsupported.self)
        .create(using: Star.Input.self)
        .read()
        .update(using: Star.Input.self)
        .patch(using: Star.PatchInput.self)
        .delete()
        .collection(sorting: StarControllers.StarsSorting.self, 
                    filtering: StarControllers.StarsFiltering.self)

```

Such filter will be always applied to the collection request

### Dynamic Filtering

*Restkit allows to define acceptable filtering keys for dynamic filtering.

Supported filter types: 
- value filters
- field filters allowing to filter against entity's other fields values*


#### How to setup dynamic filters query

1. Define filter struct, conforming to DynamicFiltering protocol:

```swift
struct StarsFiltering: DynamicFiltering {
    typealias Model = Star
    typealias Key = Keys

    func defaultFiltering(_ queryBuilder: QueryBuilder<Star>) -> QueryBuilder<Star> {
        //no filter
        return queryBuilder
    }

    enum Keys: String, FilteringKey {
        typealias Model = Star

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
                              lhs: Keys,
                              method: DatabaseQuery.Filter.Method,
                              rhs: Keys) -> QueryBuilder<Star> {
            switch (lhs, rhs) {
            case (.title, .subtitle):
                return queryBuilder.filter(\.$title, method, \.$subtitle)
            case (.subtitle, .title):
                return queryBuilder.filter(\.$subtitle, method, \.$title)
            default:
                return queryBuilder
            }
        }
    }
}
```

2. When defining controller, add filter type as collection controller builder parameter:

```swift

let controller = Star.Output
        .controller(eagerLoading: EagerLoadingUnsupported.self)
        .create(using: Star.Input.self)
        .read()
        .update(using: Star.Input.self)
        .patch(using: Star.PatchInput.self)
        .delete()
        .collection(sorting: StarControllers.StarsSorting.self, 
                    filtering: StarControllers.StarsFiltering.self)

```
#### Definitions



The following func defines default filtering, applied to the collection.
```swift
func defaultFiltering() 
```
- If filtering enitity conforms to **StaticFiltering** default filtering is always applied. 
- If filtering enitity conforms to **DynamicFiltering** default filtering is applied if no filter keys provided.



The following Keys enum defines supported dynamic keys 


```swift 
 enum Keys: String, FilteringKey {
        typealias Model = Star

        case title
        case subtitle
        case size
}
```
 
The following func provides mapping current of keys to a filtered queryBuilder via

```swift
func filterFor(queryBuilder: QueryBuilder<Star>,
                           method: DatabaseQuery.Filter.Method,
                           value: String) -> QueryBuilder<Star> 

```

The following func defines supported field filter if needed. 
It provides mapping of filter keys and method to a filtered queryBuilder:

```swift
static func filterFor(queryBuilder: QueryBuilder<Star>,
                                  lhs: Keys,
                                  method: DatabaseQuery.Filter.Method,
                                  rhs: Keys) -> QueryBuilder<Star> 
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
