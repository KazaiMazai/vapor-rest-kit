## Sorting

### Static Sorting
#### How to setup static sorting for controller methods


1. Pass query modifier with necessary sorting to controller's methods:

```swift

struct StarController {
    func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.Output>> {
        try ResourceController<Star.Output>().getCursorPage(
            req: req,
            queryModifier: QueryModifier { querybuilder, _ in
                queryBuilder.sort(\Star.$title, .ascending)
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

### Dynamic Sorting

#### How to setup dynamic sorting query keys

1. Define Sorting keys, conforming to SortingQueryKey protocol:
```swift 

enum StarsSortingKeys: String, SortingQueryKey {
    typealias Model = Star

    case title
    case subtitle

    func sortFor(_ queryBuilder: QueryBuilder<Star>, direction: DatabaseQuery.Sort.Direction) -> QueryBuilder<Star> {
        switch self {
        case .title:
            return queryBuilder.sort(\Star.$title, direction)
        case .subtitle:
            return queryBuilder.sort(\Star.$subtitle, direction)
        }
    }
    
    // (Optional) This guy is used when there is no keys in the request query:
    
    static func emptyQuerySort(queryBuilder: QueryBuilder<Star>)-> QueryBuilder<Star> {
        queryBuilder
    }

    // This guy is applied as the last sort to ensure the exact sorting. 
    // No need to override it unless you are 300% sure what you are doing

    static func uniqueKeySort(queryBuilder: QueryBuilder<Star>)-> QueryBuilder<Star> {
    
        // default implementation looks like this:
        
        queryBuilder.sort(\Star._$id, .ascending)
    }
}

```

2. Pass  ```.sort(...)``` query modifier to necessary controller's methods:


```swift

struct StarController {
    func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.Output>> {
        try ResourceController<Star.Output>().getCursorPage(
            req: req,
            queryModifier: .sort(StarsSortingKeys.self))
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

#### How to use dynamic sort query

RestKit uses the following format to parse sort query string. Query key is **sort**, value is **key:direction**
where direction is **asc** or **desc**.

The result request will look like:
```
https://api.yourservice.com/v1/stars?sort=title:asc
```

#### How to use dynamic sort query with multiple keys

It's also possible to use several sort keys, separated by comma:

```
https://api.yourservice.com/v1/stars?sort=title:asc,subtitle:desc
```
