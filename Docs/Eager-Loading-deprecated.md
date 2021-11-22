## Eager Loading

### Static Eager Loading
#### How to setup default eager loading of nested models for controller

1. Define eager loading struct conforming to *StaticEagerLoading* protocol:


```swift
 struct StarStaticEagerLoading: StaticEagerLoading {
    typealias Key = EmptyEagerLoadKey<Model>
    typealias Model = Star

    func defaultEagerLoading(_ queryBuilder: QueryBuilder<Star>) -> QueryBuilder<Star> {
        return queryBuilder.with(\.$galaxy).with(\.$starTags)
    }
}
```
3. Add nested models to the output model:

```swift 
struct ExtendedOutput<GalaxyOutput, TagsOutput>: ResourceOutputModel

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
 

2. When creating controller, use new output type and pass eager loading type to builder:
```swift
let controller = Star.ExtendedOutput<Galaxy.Output, StarTag.Output>
           .controller(eagerLoading: StarStaticEagerLoading.self)
           .create(using: Star.Input.self)
           .read()
           .update(using: Star.Input.self)
           .patch(using: Star.PatchInput.self)
           .delete()
           .collection(sorting: StarTagControllers.StarsSorting.self, 
                        filtering: StarTagControllers.StarsFiltering.self)
```


### Dynamic Eager Loading
#### How to setup dynamic eager loading for query keys

1. Define eager loading struct conforming to *DynamicEagerLoading* protocol with EagerLoadingKeys:

```swift 
struct StarDynamicEagerLoading: DynamicEagerLoading {
    typealias Model = Star
    typealias Key = Keys

    func defaultEagerLoading(_ queryBuilder: QueryBuilder<Star>) -> QueryBuilder<Star> {
        return queryBuilder
    }

    enum Keys: String, EagerLoadingKey {
        typealias Model = Star

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

    }
}
```


#### Definitions
The following func defines default eager loading for nested models. In other words, it simply joins your db tables.


```swift
func defaultEagerLoading(...) -> > QueryBuilder<Model> 

vs

func baseEagerLoading(...) -> > QueryBuilder<Model>
```

- If eager loading conforms to **StaticEagerLoading** base eager loading is always applied. 
- If eager loading conforms to **DynamicEagerLoading** default eager loading is applied only if no eager loading keys provided in the request query by client.
- If eager loading conforms to **DynamicEagerLoading** base eager loading is always applied

#### How to query nested models with dynamic eager loading key

Query parameter key us *include*, value is comma-separated eagerLoading keys.

The result request will look like:
```
https://api.yourservice.com/v1/stars/1?include=galaxy,tags
```



#### How to use versionable Output for Eager Loaded Resource Models

Using versionable output models for nested entities is enforced by using generic output types:


```swift 
struct ExtendedOutput<GalaxyOutput, TagsOutput>: ResourceOutputModel

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

In that case, when creating controller, nested output types are passed expicitly:

```swift
let controllerV1 = Star.ExtendedOutput<Galaxy.Output, StarTag.Output>
           .controller(eagerLoading: StarStaticEagerLoading.self) 
           .read()
```
and 

```swift
let controllerV2 = Star.ExtendedOutput<Galaxy.OutputV2, StarTag.OutputV2>
           .controller(eagerLoading: StarStaticEagerLoading.self) 
           .read()
```
