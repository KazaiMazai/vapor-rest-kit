#  QueryModifier

RestKit allows to handle requests and do some custom querying via QueryModifier

QueryModifier takes a Request and QueryBuilder for controller resource model and allows to make some modifications to the QueryBuilder.

For example:
- Extract `sort` and `filter` query paramers and apply sorting and filtering to the query builder
- Extract `include` parameters and apply EagerLoader for the query builder


All this is already done in RestKit's Sorting, Filtering, and EagerLoading. 


QueryModifiers can be combined together with `&`

```swift

struct StarController {
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
