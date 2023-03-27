## Pagination

ResourceControllers support resource listing methods with pagination by cursor by page or without pagination

### By cursor 

```swift

struct StarsController {
      
    func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.Output>> {
        try ResourceController<Star.Output>().getCursorPage(
            req: req,
            queryModifier:
                .eagerLoading(StarEagerLoadingKeys.self) &
                .sort(using: StarsSortingKeys.self) &
                .filter(StarsFilterKeys.self)
        )
    }
}

```
#### How to query cursor pagination

When making initial request, client may provide only limit parameter, like this:

```
https://api.yourservice.com/v1/stars?limit=10
```
Limit parameter is optional, defaults to pagination config.
 
As a part of metadata, returned by server, there will be **next_cursor** parameter.
In order to get the next portion of data, client should include cursor in the request query:

```
https://api.yourservice.com/v1/stars?limit=10&cursor=W3siZmllbGRLZXkiOiJhc3NldHNfW3RpY2tlcl0iLCJ2YWx1Z...

```

*Cursor is a base64 encoded string, containing meta data that points to the last element of the returned portion of items. 
It also contains all sorting-related metadata allowing to use cursor pagination along with the sorting applied to query builder, including dynamic sorting query keys*

#### How to configure cursor pagination

1. Define config:

```swift
//defalut parameters are limitMax: 25, defaultLimit: 10

let cursorPaginationConfig = CursorPaginationConfig(limitMax: 25, defaultLimit: 10)
```

`defaultLimit` is applied if there is no limit specified in the request query
`limitMax` is the max allowed limit for the query 

2. Provide cursor config parameter to collection controller builder:

```swift

struct StarsController {
      
    func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.Output>> {
        try ResourceController<Star.Output>().getCursorPage(
            req: req,
            queryModifier:
                .eagerLoading(StarEagerLoadingKeys.self) &
                .sort(using: StarsSortingKeys.self) &
                .filter(StarsFilterKeys.self),
            config: cursorPaginationConfig
        )
    }
}

```
#### How to configure bi-directional cursor pagination

Bi-directional pagination is disabled by default. It can be turned on in pagination config:

```swift
//defalut parameters are limitMax: 25, defaultLimit: 10

let cursorPaginationConfig = CursorPaginationConfig(limitMax: 25, defaultLimit: 10, allowBackwardPagination: true)
```

When enabled, cursor page API response metadata would contain both next and previous cursors.

```json
{
   "items": [
      //your data collection here
   ],
   
   "metadata": {
     "next_cursor": "W3siZmllbGRLZXkiOiJhc3NldHNfW3RpY2tlcl0iLCJ2",
     "prev_cursor": "dW3siZmllbGRLZXkiOiJhc3NldHNf2312RpY2tlcl0i3"
      
   }
}
```
They can be used with `after` and `before`query parameters to request next and previous portions of collection.

Next portion:

```
https://api.yourservice.com/v1/stars?limit=10&after=W3siZmllbGRLZXkiOiJhc3NldHNfW3RpY2tlcl0iLCJ2YWx1Z...

```

Previous portion:

```
https://api.yourservice.com/v1/stars?limit=10&before=W3siZmllbGRLZXkiOiJhc3NldHNfW3RpY2tlcl0iLCJ2YWx1Z...

```

### By page

#### How to use page pagination

```swift

struct StarsController {
      
    func index(req: Request) throws -> EventLoopFuture<Page<Star.Output>> {
        try ResourceController<Star.Output>().getPage(
            req: req,
            queryModifier:
                .eagerLoading(StarEagerLoadingKeys.self) &
                .sort(using: StarsSortingKeys.self) &
                .filter(StarsFilterKeys.self)
        )
    }
}

```

That config will apply default Vapor Fluent per page pagination with the following parameters:

- **page**  - for page number
- **per** - for number of items per page

Can be queried like this:

```
https://api.yourservice.com/v1/stars?page=2&per=15
```
 

### Collection listing without Pagination

#### How to get all items 

It's sometimes useful to provide API for the whole list of items, although not recommended for large collections


```swift

struct StarsController {

    func index(req: Request) throws -> EventLoopFuture<[Star.Output]> {
        try ResourceController<Star.Output>().getAll(
            req: req,
            queryModifier:
                .eagerLoading(StarEagerLoadingKeys.self) &
                .sort(using: StarsSortingKeys.self) &
                .filter(StarsFilterKeys.self)
        )
    }
}

```
