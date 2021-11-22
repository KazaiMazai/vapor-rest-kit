## Sorting

### Static Sorting
#### How to setup default sorting for controller methods

1. Define Sorting struct, conforming to StaticSorting protocol:

```swift
struct StaticStarsSorting: StaticSorting {
    typealias Key = EmptySortingKey<Star>
    typealias Model = Star

    func defaultSorting(_ queryBuilder: QueryBuilder<Star>) -> QueryBuilder<Star> {
        return queryBuilder
    }
}
```

2. When defining controller, add sorting type as collection controller builder parameter:

```swift 

let controller = Star.Output
            .controller(eagerLoading: EagerLoadingUnsupported.self)
            .create(using: Star.Input.self)
            .read()
            .update(using: Star.Input.self)
            .patch(using: Star.PatchInput.self)
            .delete()
            .collection(sorting: StarControllers.StaticStarsSorting.self, 
                        filtering: StarControllers.StarsFiltering.self)
```

### Dynamic Sorting
#### How to setup dynamic sorting query keys

1. Define Sorting struct, conforming to DynamicSorting protocol:
```swift 

struct StarsSorting: DynamicSorting {
    typealias Model = Star
    typealias Key = Keys
    
    func defaultSorting(_ queryBuilder: QueryBuilder<Star>) -> QueryBuilder<Star> {
        return queryBuilder
    }
    
    enum Keys: String, SortingKey {
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
    }
}

```

2. When defining controller, add sorting type as collection controller builder parameter:

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
This func that defines default sorting, applied to the collection:

```swift
func defaultSorting() 
```

- If sorting enitity conforms to **StaticSorting** default sorting is always applied. 
- If sorting enitity conforms to **DynamicSorting** default StaticSorting is applied if no sorting keys provided.

### Important

**RestKit always appends sorting by ID with ascending order. This is necessary for valid cursor pagination.**

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
