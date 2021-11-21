##  EagerLoading
 
### Static Eager Loading

#### How to setup default eager loading of nested models for controller


1. Implement Output model to support optional nested models:

```swift 

struct StarOutput<GalaxyOutput, TagsOutput>: ResourceOutputModel

    where
    GalaxyOutput: ResourceOutputModel,
    GalaxyOutput.Model == Galaxy,
    TagsOutput: ResourceOutputModel,
    TagsOutput.Model == StarTag  {

    let id: Int?
    let title: String
    let subtitle: String?
    let size: Int

    let galaxy: GalaxyOutput?
    let tags: [TagsOutput]?

    init(_ model: Star, req: Request) {
        id = model.id
        title = model.title
        subtitle = model.subtitle
        size = model.size
        galaxy = model.$galaxy.value.map { GalaxyOutput($0, req: req) }
        tags = model.$starTags.value?.map { TagsOutput($0, req: req) }
    }
}

```

2. Pass query modifier with necessary eager loading to controller's methods:

```swift

struct StarController {
    func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
        try ResourceController<Star.Output>().getCursorPage(
            req: req,
            queryModifier: QueryModifier { queryBuilder, _ in
                queryBuilder
                    .with(\.$galaxy)
                    .with(\.$starTags)
            })
    }
    
    func read(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
        try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().read(
            req: req,
            queryModifier: QueryModifier { queryBuilder, _ in
                queryBuilder
                    .with(\.$galaxy)
                    .with(\.$starTags)
            })
    }
}

```

2. Setup route:
 

```swift

app.group("stars") {
    let controller = StarController()
 
    $0.on(.GET, Star.idPath, use: controller.read)
    $0.on(.GET, use: controller.index)
}

```


### Dynamic Eager Loading

#### How to setup dynamic eager loading for query keys


1. Implement Output model to support optional nested models:

```swift 

struct StarOutput<GalaxyOutput, TagsOutput>: ResourceOutputModel

    where
    GalaxyOutput: ResourceOutputModel,
    GalaxyOutput.Model == Galaxy,
    TagsOutput: ResourceOutputModel,
    TagsOutput.Model == StarTag  {

    let id: Int?
    let title: String
    let subtitle: String?
    let size: Int

    let galaxy: GalaxyOutput?
    let tags: [TagsOutput]?

    init(_ model: Star, req: Request) {
        id = model.id
        title = model.title
        subtitle = model.subtitle
        size = model.size
        galaxy = model.$galaxy.value.map { GalaxyOutput($0, req: req) }
        tags = model.$starTags.value?.map { TagsOutput($0, req: req) }
    }
}

```

2. Implement Key enum and comform to EagerLoadingQueryKey protocol

```swift

enum StarEagerLoadingKeys: String, EagerLoadingQueryKey {
    case galaxy
    case tags

    func eagerLoadFor(_ queryBuilder: QueryBuilder<Star>) -> QueryBuilder<Star> {
        switch self {
        case .galaxy:
            return queryBuilder.with(\.$galaxy)
        case .tags:
            return queryBuilder.with(\.$starTags)
        }
    }

    // (Optional) This guys is used when there is no keys found in the request query:
    
    static func eagerLoadEmptyQueryFor(_ queryBuilder: QueryBuilder<Star>) -> QueryBuilder<Star> {
        //does not eager load anything by in default implementation
        
        queryBuilder
    }
}

```
 
3. Pass  ```.eagerLoading(...)``` query modifier to necessary controller's methods:


```swift

struct StarController {
    func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
        try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().getCursorPage(
            req: req,
            queryModifier: .eagerLoading(StarEagerLoadingKeys.self))
    }
    
    func read(req: Request) throws -> EventLoopFuture<CursorPage<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>> {
        try ResourceController<Star.ExtendedOutput<Galaxy.Output, StarTag.Output>>().read(
            req: req,
            queryModifier: .eagerLoading(StarEagerLoadingKeys.self))
    }
}
```

4. Setup route:
 

```swift

app.group("stars") {
    let controller = StarController()
 
    $0.on(.GET, Star.idPath, use: controller.read)
    $0.on(.GET, use: controller.index)
}

```


#### How to query nested models with dynamic eager loading key

Query parameter key is *include*, value is comma-separated eagerLoading keys.

The result request will look like:

```
https://api.yourservice.com/stars/1?include=galaxy,tags
```

and


```
https://api.yourservice.com/stars?include=galaxy,tags
```
