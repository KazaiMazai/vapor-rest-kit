## Pagination

Reskit supports pagination for collection controller:

```swift
let controller = Star.Output
        .controller(eagerLoading: EagerLoadingUnsupported.self) 
        .collection(sorting: StarControllers.StarsSorting.self, 
                    filtering: StarControllers.StarsFiltering.self)
```

### By cursor

By default, cursor pagination is applied to collection controller.

#### How to query cursor pagination

When making initial request, client should provide only limit parameter, like this:

```
https://api.yourservice.com/v1/stars?limit=10
```
 
As a part of metadata, returned by server, there will be **next_cursor** parameter.
In order to get the next portion of data, client should include cursor in the requers query:

```
https://api.yourservice.com/v1/stars?limit=10cursor=W3siZmllbGRLZXkiOiJhc3NldHNfW3RpY2tlcl0iLCJ2YWx1Z

```

Cursor is a base64 encoded string, containing data pointing to the last element of the returned portion of items. 
It also contains sorting metadata allowing to use cursor pagination along with static or dynamic sorting keys.

#### How to configure cursor pagination

1. Define config:

```swift
//defalut parameters are limitMax: 25, defaultLimit: 10

let cursorPaginationConfig = CursorPaginationConfig(limitMax: 25, defaultLimit: 10)
```

2. Provide cursor config parameter to collection controller builder:

```swift
let controller = Star.Output
        .controller(eagerLoading: StarEagerLoading.self)
        .collection(sorting: StarsSorting.self,
                    filtering: StarsFiltering.self,
                    config: .paginateWithCursor(cursorPaginationConfig))
```

### By page

#### How to use page pagination

```swift
let controller = Star.Output
        .controller(eagerLoading: StarEagerLoading.self)
        .collection(sorting: StarsSorting.self,
                    filtering: StarsFiltering.self,
                    config: .paginateByPage)
```

That config will apply default Vapor Fluent per page pagination with the following parameters:

- **page**  - for page number
- **per** - for number of items per page

This will result in something like:

```
https://api.yourservice.com/v1/stars?page=2&per=15
```
 

### Collection response without Pagination

#### How to get all items 

Not recommended for large collections, but sometimes useful to provide api for the whole list of items.

The controller should be set-up in the following way:

```swift
let controller = Star.Output
        .controller(eagerLoading: StarEagerLoading.self)
        .collection(sorting: StarsSorting.self,
                    filtering: StarsFiltering.self,
                    config: .fetchAll)
```
