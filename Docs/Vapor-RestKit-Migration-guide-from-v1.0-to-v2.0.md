#  Migration Guide from v1.0 to v.2.0


## Resource Controller Migration Guide

### v1.0:

#### Controller implementaion:

```swift

struct StarController {
    var controller: APIMethodsProviding {
        Star.Output
            .controller(eagerLoading: EagerLoadingUnsupported.self)
            .create(using: Star.Input.self)
            .read()
            .update(using: Star.Input.self)
            .patch(using: Star.PatchInput.self)
            .delete()
            .collection(sorting: StarTagControllers.StarsSorting.self, filtering: StarTagControllers.StarsFiltering.self)
    }
}

``` 

#### Routes setup:

```swift 
 
app.group("v1") {
    StarController().controller.addMethodsTo($0, on: "stars")
}

```

### v2.0:

#### Controller implementaion:

```swift

struct StarController {

    var queryModifier: QueryModifier<Star> {
        QueryModifier.using(
            eagerLoadProvider: EagerLoadingUnsupported(),
            sortProvider: StarTagControllers.StarsSorting(),
            filterProvider: StarTagControllers.StarsFiltering())
    }

    func create(req: Request) throws -> EventLoopFuture<Star.Output> {
        try ResourceController<Star.Output>().create(
            req: req,
            using: Star.Input.self)
    }

    func read(req: Request) throws -> EventLoopFuture<Star.Output> {
        try ResourceController<Star.Output>().read(
            req: req,
            queryModifier: queryModifier)
    }

    func update(req: Request) throws -> EventLoopFuture<Star.Output> {
        try ResourceController<Star.Output>().update(
            req: req,
            using: Star.Input.self,
            queryModifier: queryModifier)
    }

    func delete(req: Request) throws -> EventLoopFuture<Star.Output> {
        try ResourceController<Star.Output>().delete(
            req: req,
            queryModifier: queryModifier)
    }

    func patch(req: Request) throws -> EventLoopFuture<Star.Output> {
        try ResourceController<Star.Output>().patch(
            req: req,
            using: Star.PatchInput.self,
            queryModifier: queryModifier)
    }

    func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.Output>> {
        try ResourceController<Star.Output>().getCursorPage(
            req: req,
            queryModifier: queryModifier)
    }
}

```

#### Routes setup:

```swift 

app.group("v1") { base in

    base.group("stars") {
        let controller = StarController()

        $0.on(.POST, use: controller.create)
        $0.on(.GET, Star.idPath, use: controller.read)
        $0.on(.PUT, Star.idPath, use: controller.update)
        $0.on(.PATCH, Star.idPath, use: controller.patch)
        $0.on(.DELETE, Star.idPath, use: controller.delete)
        $0.on(.GET, use: controller.index)
    }
}

```

## Related Resource Controller Migration Guide

### v1.0:

#### Controller implementaion:

```swift

struct GalaxyForStarsNestedController {
    var controller: APIMethodsProviding {
        Galaxy.Output
            .controller(eagerLoading: EagerLoadingUnsupported.self)
            .related(by: \Galaxy.$stars, relationName: "belongs")
            .create(using: Galaxy.Input.self)
            .read()
            .update(using: Galaxy.Input.self)
            .patch(using: Galaxy.PatchInput.self)
            .delete()
            .collection(sorting: SortingUnsupported.self, filtering: FilteringUnsupported.self)
    }
}

```

#### Routes setup:

```swift
 
app.group("v1") {

    $0.group("stars") {
        GalaxyForStarsNestedController().controller.addMethodsTo($0, on: "galaxies")
    }
}

```

### v2.0:

#### Controller implementaion:

```swift

struct GalaxyForStarsNestedController {
    func create(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
        try RelatedResourceController<Galaxy.Output>().create(
            req: req,
            using: Galaxy.Input.self,
            relationKeyPath: \Galaxy.$stars)
    }

    func read(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
        try RelatedResourceController<Galaxy.Output>().read(
            req: req,
            relationKeyPath: \Galaxy.$stars)
    }

    func update(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
        try RelatedResourceController<Galaxy.Output>().update(
            req: req,
            using: Galaxy.Input.self,
            relationKeyPath: \Galaxy.$stars)
    }

    func delete(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
        try RelatedResourceController<Galaxy.Output>().delete(
            req: req,
            relationKeyPath: \Galaxy.$stars)
    }

    func patch(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
        try RelatedResourceController<Galaxy.Output>().patch(
            req: req,
            using: Galaxy.PatchInput.self,
            relationKeyPath: \Galaxy.$stars)
    }

    func index(req: Request) throws -> EventLoopFuture<CursorPage<Galaxy.Output>> {
        try RelatedResourceController<Galaxy.Output>().getCursorPage(
            req: req,
            relationKeyPath: \Galaxy.$stars)
    }
}

```

#### Routes setup:


```swift

app.group("v1") { base in

    base.group("stars") {
         
        $0.group(Star.idPath, "belongs") {
        
            $0.group("galaxies") {
                let controller = GalaxyForStarsNestedController()

                $0.on(.POST, use: controller.create)
                $0.on(.GET, Galaxy.idPath, use: controller.read)
                $0.on(.PUT, Galaxy.idPath, use: controller.update)
                $0.on(.PATCH, Galaxy.idPath, use: controller.patch)
                $0.on(.DELETE, Galaxy.idPath, use: controller.delete)
                $0.on(.GET, use: controller.index)
            }
        }
    }
}

```


## Relations Controller Migration Guide

### v1.0:

#### Controller implementaion:

```swift

struct GalaxyForStarsRelationNestedController {
    var controller: APIMethodsProviding {
        Galaxy.Output
            .controller(eagerLoading: EagerLoadingUnsupported.self)
            .related(by: \Galaxy.$stars, relationName: "belongs")
            .relation
            .create()
            .delete()
    }
}

```

#### Routes setup:

```swift
 
app.group("v1") {
    
    $0.group("stars") {
     
        GalaxyForStarsRelationNestedController().controller.addMethodsTo($0, on: "galaxies")
    }
}

```

### v2.0:

#### Controller implementaion:


```swift

struct GalaxyForStarsRelationNestedController {
    func createRelation(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
        try RelationsController<Galaxy.Output>().createRelation(
            req: req,
            relationKeyPath: \Galaxy.$stars)
    }

    func deleteRelation(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
        try RelationsController<Galaxy.Output>().deleteRelation(
            req: req,
            relationKeyPath: \Galaxy.$stars)
    }
}


```

#### Routes setup:


```swift

app.group("v1") { base in
    
    base.group("stars") {
         
        $0.group(Star.idPath, "belongs") {
        
            $0.group("galaxies") {
             
                $0.group(Galaxy.idPath, "relation") {
                    let controller = GalaxyForStarsRelationNestedController()

                    $0.on(.POST, use: controller.createRelation)
                    $0.on(.DELETE, use: controller.deleteRelation)
                }
            }
    }
}
                
```


## Sorting, Filtering, Eagerloading Migration Guide


Sorting, Filtering, Eagerloading related things may be wrapped into a QueryModifier without changes or updated to a new query keys API: ( SortingQueryKey, FilterQueryKey,  EagerLoadingKey)


### v1.0:

#### Controller implementaion:

```swift

struct GalaxyController {
    var controller: APIMethodsProviding {
        Galaxy.Output
            .controller(eagerLoading: GalaxyEagerLoader.self)
            .collection(sorting: GalaxySorting.self, filtering: GalaxyFiltering.self)
    }
}

```

### v2..0:

#### Controller implementaion:

```swift

struct GalaxyController {

    let queryModifier = QueryModifier.using(
        eagerLoadProvider: GalaxyEagerLoader(),
        sortProvider: GalaxySorting(),
        filterProvider: GalaxyFiltering())

    func index(req: Request) throws -> EventLoopFuture<CursorPage<Galaxy.Output>> {
        try RelatedResourceController<Galaxy.Output>().getCursorPage(
            req: req,
            queryModifier: queryModifier)
    }
}

```


## Middleware migration guide

Not much acutally changed since v1.0. 

In v2.0 Middleware is the same as before. The difference is that it's passed as a parameter of the related resosource controller methods

### v1.0:

#### Controller implementaion:

```
struct TodoAssigneesRelationController: VersionableController {
    let todoOwnerGuardMiddleware = ControllerMiddleware<User, Todo>(handler: { (user, todo, req, db) in
        db.eventLoop
            .tryFuture { try req.auth.require(User.self) }
            .guard( { $0.id == todo.$user.id}, else: Abort(.unauthorized))
            .transform(to: (user, todo))
    })

    var controller: APIMethodsProviding {
        User.Output
            .controller(eagerLoading: EagerLoadingUnsupported.self)
            .related(by: \Todo.$assignees, relationName: "assignees")
            .relation
            .create(with: todoOwnerGuardMiddleware)
            .delete(with: todoOwnerGuardMiddleware)
    }
}

```

#### Routes setup:


```swift
 
app.group("v1") {
    
    $0.group("todos") {
     
        TodoAssigneesRelationController().controller.addMethodsTo($0, on: "users")
    }
}

```


### v2.0:

#### Controller implementaion:

```swift

struct TodoAssigneesRelationController {
    let todoOwnerGuardMiddleware = ControllerMiddleware<User, Todo>(handler: { (user, todo, req, db) in
        db.eventLoop
            .tryFuture { try req.auth.require(User.self) }
            .guard({ $0.id == todo.$user.id }, else: Abort(.unauthorized))
            .transform(to: (user, todo))
    })

    func addAssignee(req: Request) throws -> EventLoopFuture<User.Output> {
        try RelationsController<User.Output>().createRelation(
            req: req,
            willAttach: todoOwnerGuardMiddleware,
            relationKeyPath: \Todo.$assignees)
    }

    func removeAssignee(req: Request) throws -> EventLoopFuture<User.Output> {
        try RelationsController<User.Output>().deleteRelation(
            req: req,
            willDetach: todoOwnerGuardMiddleware,
            relationKeyPath: \Todo.$assignees)
    }
}

```

#### Routes setup:

```swift

app.group("v1") { base in

    base.group("todos") {
            
        $0.group(Todo.idPath, "assignees", "users") {
            
            $0.group(User.idPath, "relation") {
                    let controller = TodoAssigneesRelationController()

                    $0.on(.POST, use: controller.addAssignee)
                    $0.on(.DELETE, use: controller.removeAssignee)
            }
        }
    }
}


```


## Deleter handler migration guide

Not much acutally changed since v1.0. In v2.0 Delete handler is the same as before. The only difference now is that it's passed as a parameter to the delete method

### v1.0:

```swift

struct GalaxyForStarsNestedController {
    let customDeleter = Deleter<Galaxy>(useForcedDelete: true) { (itemToDelete, forceDelete, req, db) in
        //do some delete things here
    }

    var controller: APIMethodsProviding {
        Galaxy.Output
            .controller(eagerLoading: EagerLoadingUnsupported.self)
            .related(by: \Galaxy.$stars, relationName: "belongs")
            .delete()
    }
}

```


### v2.0:

#### Controller implementaion:


```

struct GalaxyForStarsNestedController {
    let customDeleter = Deleter<Galaxy>(useForcedDelete: true) { (itemToDelete, forceDelete, req, db) in
        //do some delete things here
    }
     
    func delete(req: Request) throws -> EventLoopFuture<Galaxy.Output> {
        try RelatedResourceController<Galaxy.Output>().delete(
            req: req,
            using: customDeleter,
            relationKeyPath: \Galaxy.$stars)
    }

```
