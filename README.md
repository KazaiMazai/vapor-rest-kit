
<p align="center">
  <img src="Logo.svg?raw=true" alt="Sublime's custom image"/>
</p>

This package is intended to speed up backend development using server side swift framework [Vapor](https://github.com/vapor/vapor)



## Features
- CRUDs with Resource and Nested Resource Controllers
- Parent-Child, Siblings relations support
- Nested Resource Controllers for Authenticatable Resource
- Filter query
- Sorting query
- Eager loading query
- Fluent Model convenience extensions 
- Cursor Pagination 
____________

## Installation

Add this package to your Package.swift as dependency and to your target.

```swift
dependencies: [
    .package(url: "https://github.com/KazaiMazai/vapor-rest-kit",  from: "1.0.0-beta.1.6")
],
targets: [
    .target(name: "App", dependencies: [
        .product(name: "VaporRestKit", package: "vapor-rest-kit")
    ])
]

```

Import in your code

```swift
import VaporRestKit
```

____________


1. Define Input, Output structs for your Model, conforming to ```ResourceUpdateModel, ResourcePatchModel, ResourceOutputModel``` protocols:

```swift
protocol ResourceUpdateModel: Content, Validatable {
    associatedtype Model: Fields

    func update(_: Model) -> Model
}

protocol ResourcePatchModel: Content, Validatable {
    associatedtype Model: Fields

    func patch(_: Model) -> Model
}

protocol ResourceOutputModel: Content {
    associatedtype Model: Fields

    init(_: Model)
}

```

2. Define ```StarsEagerLoadQueryKeys, StarsSortQueryKeys, StarsFilterQueryKeys``` if needed

3. Implement controller with RestKit ResourceControllers API:

```swift

struct StarForGalaxyNestedController {
     
    func create(req: Request) throws -> EventLoopFuture<Star.Output> {
        try RelatedResourceController<Star.Output>().create(
            req: req,
            using: Star.Input.self,
            relationKeyPath: \Galaxy.$stars)
    }

    func read(req: Request) throws -> EventLoopFuture<Star.Output> {
        try RelatedResourceController<Star.Output>().read(
            req: req,
            queryModifier: .eagerLoading(StarEagerLoadingKeys.self),
            relationKeyPath: \Galaxy.$stars)
    }

    func update(req: Request) throws -> EventLoopFuture<Star.Output> {
        try RelatedResourceController<Star.Output>().update(
            req: req,
            using: Star.Input.self,
            relationKeyPath: \Galaxy.$stars)
    }

    func delete(req: Request) throws -> EventLoopFuture<Star.Output> {
        try RelatedResourceController<Star.Output>().delete(
            req: req,
            relationKeyPath: \Galaxy.$stars)
    }

    func patch(req: Request) throws -> EventLoopFuture<Star.Output> {
        try RelatedResourceController<Star.Output>().patch(
            req: req,
            using: Star.PatchInput.self,
            relationKeyPath: \Galaxy.$stars)
    }

    func index(req: Request) throws -> EventLoopFuture<CursorPage<Star.Output>> {
        try RelatedResourceController<Star.Output>().getCursorPage(
            req: req,
            queryModifier:
                .eagerLoading(StarEagerLoadingKeys.self) &
                .sort(using: StarsSortingKeys.self) &
                .filter(StarsFilterKeys.self),
            relationKeyPath: \Galaxy.$stars)
    }
}

```

3. Routes setup:


```swift

app.group("galaxies", Galaxy.idPath, "stars") {
    let controller = StarForGalaxyNestedController()

    $0.on(.POST, use: controller.create)
    $0.on(.GET, Star.idPath, use: controller.read)
    $0.on(.PUT, Star.idPath, use: controller.update)
    $0.on(.PATCH, Star.idPath, use: controller.patch)
    $0.on(.DELETE, Star.idPath, use: controller.delete)
    $0.on(.GET, use: controller.index)
}
```
     
4. Get result


| HTTP Method                 | Route               | Result
| --------------------------- |:--------------------| :---------------|
|POST       | /galaxies/:GalaxyId/stars         | Create new
|GET        | /galaxies/:GalaxyId/stars/:starId  | Show existing
|PUT        | /galaxies/:GalaxyId/stars/:starId  | Replace existing 
|PATCH      | /galaxies/:GalaxyId/stars/:starId  | Patch exsiting
|DELETE     | /galaxies/:GalaxyId/stars/:starId  | Delete 
|GET        | /galaxies/:GalaxyId/stars         | Show list with cursor pagination
___________
 
## Check out the Docs for more details:

[Basics](Docs/Basics.md)

[Fluent Model Extensions](Docs/Fluent-Model-Convenience-Extensions.md)

[CRUD for Resource Models](Docs/CRUD-for-Resource-Models.md)

[CRUD for Related Resource Models](Docs/CRUD-Related-Resource-Models.md)

[CRUD for Relations](Docs/CRUD-for-Relations.md)

[Controller Middlewares](Docs/Controller-Middlewares.md)
  
[Filtering](Docs/Filtering.md)

[Sorting](Docs/Sorting.md)

[Eager Loading](Docs/Eager-Loading.md)

[QueryModifier](Docs/QueryModifier.md)

[Pagination](Docs/Pagination.md)
 
# Licensing

Vapor RestKit is licensed under MIT license.

