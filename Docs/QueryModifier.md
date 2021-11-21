#  QueryModifier

RestKit allows to handle requests and do some custom querying via QueryModifier

QueryModifier takes a Request and QueryBuilder for controller resource model and allows to make some modifications to the QueryBuilder.

For example:
- Extract sort and filter query paramers and perform sorting and filtering
- Extract include parameters and related models via EagerLoader


All this is already done in RestKit's Sorting, Filtering, and EagerLoading. 



QueryModifier can be combined together:

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
