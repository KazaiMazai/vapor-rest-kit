
<p align="center">
  <img src="Logo.svg?raw=true" alt="Sublime's custom image"/>
</p>

This package is intended to speed up backend development using server side swift framework [Vapor](https://github.com/vapor/vapor)



## Features
- CRUDs with Resource and Nested Resource Controllers
- Parent-Child and Siblings relations for Nested Resource Controllers
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
    .package(url: "https://github.com/KazaiMazai/vapor-rest-kit",  from: "2.0.0")
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

2. Define `EagerLoadQueryKeys`, `SortQueryKeys`, `FilterQueryKeys`  if needed

3. Implement controller with the help of RestKit ResourceController:

```swift

struct TodoController {
    func create(req: Request) throws -> EventLoopFuture<Todo.Output> {
        try ResourceController<Todo.Output>().create(req: req, using: Todo.Input.self)
    }

    func read(req: Request) throws -> EventLoopFuture<Todo.Output> {
        try ResourceController<Todo.Output>().read(req: req)
    }

    func update(req: Request) throws -> EventLoopFuture<Todo.Output> {
        try ResourceController<Todo.Output>().update(req: req, using: Todo.Input.self)
    }

    func patch(req: Request) throws -> EventLoopFuture<Todo.Output> {
        try ResourceController<Todo.Output>().patch(req: req, using: Todo.PatchInput.self)
    }

    func delete(req: Request) throws -> EventLoopFuture<Todo.Output> {
        try ResourceController<Todo.Output>().delete(req: req)
    }

    func index(req: Request) throws -> EventLoopFuture<CursorPage<Todo.Output>> {
        try ResourceController<Todo.Output>().getCursorPage(req: req)
    }
}

```

4. Setup routes:

```swift

app.group("todos") {
    let controller = TodoController()

    $0.on(.POST, use: controller.create)
    $0.on(.GET, Todo.idPath, use: controller.read)
    $0.on(.PUT, Todo.idPath, use: controller.update)
    $0.on(.DELETE, Todo.idPath, use: controller.delete)
    $0.on(.PATCH, Todo.idPath, use: controller.patch)
    $0.on(.GET, use: controller.index)
}

```

  
This will add the following methods to your API endpoint: 


| HTTP Method                 | Route            | Result
| --------------------------- |:-----------------| :---------------|
|POST       | /todos                    | Create new
|GET        | /todos/:todoId            | Show existing
|PUT        | /todos/:todoId            | Update existing (Replace)
|PATCH      | /todos/:todoId            | Patch exsiting (Partial update)
|DELETE     | /todos/:todoId            | Delete 
|GET        | /todos                    | Show paginated list

___________
 
## Check out the Docs for more details:

- [Basics](Docs/Basics.md)
- [Fluent Model Extensions](Docs/Fluent-Model-Convenience-Extensions.md)
- [CRUD for Resource Models](Docs/CRUD-for-Resource-Models.md)
- [CRUD for Related Resource Models](Docs/CRUD-Related-Resource-Models.md)
- [CRUD for Relations](Docs/CRUD-for-Relations.md)
- [Controller Middlewares](Docs/Controller-Middlewares.md)
- [Filtering](Docs/Filtering.md)
- [Sorting](Docs/Sorting.md)
- [Eager Loading](Docs/EaagerLoading.md)
- [QueryModifier](Docs/QueryModifier.md)
- [Pagination](Docs/Pagination.md)


## Migration Guides

- [Migration from v1.x to v2.0](Docs/Vapor-RestKit-Migration-guide-from-v1.0-to-v2.0.md)
 
# Licensing

Vapor RestKit is licensed under MIT license.

