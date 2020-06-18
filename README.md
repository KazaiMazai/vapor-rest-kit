
<p align="center">
  <img src="Logo.svg?raw=true" alt="Sublime's custom image"/>
</p>

This package is intended to speed up backend development using server side swift framework [Vapor](https://github.com/vapor/vapor)



## Features
- Generic-powered Declarative API 
- CRUD for Resource Models 
- CRUD for Related Resource Models 
- Nested routes for Parent-Child, Siblings relations
- Nested */me* routes for Authenticatable Related Resource
- API versioning for controllers and Resource Models 
- Pagination for Resource Collections by Cursor or Page 
- Filtering 
- Sorting
- Eager loading
- Dynamic query keys for sorting, filtering and eager loading
- Controller Middlewares for business logic
- Compound Controllers
- Fluent Model convenience extensions for models initial migrations
- Fluent Model convenience extensions for Siblings relations
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


2. Define ```TodoEagerLoading, TodoSortKeys, TodoFilterKeys``` if needed

3. Create controller with RestKit Declarative API:

```swift
let controller = Todo.Output
                .controller(eagerLoading: TodoEagerLoading.self)
                .related(with: \Tag.$relatedTodos, relationName: "related")
                .create(using: Todo.Input.self)
                .read()
                .update(using: Todo.Input.self)
                .patch(using: Todo.PatchInput.self)
                .read()
                .delete()
                .collection(sorting: TodoSortKeys.self,
                            filtering: TodoFilterKeys.self)


```

4. Add methods to route builder:

```swift
let tags = routeBuilder.grouped("tags")
controller.addMethodsTo(tags, on: "todos")
```

5. Get result:
 

| HTTP Method                 | Route               | Result
| --------------------------- |:--------------------| :---------------|
|POST       | /tags/:tagId/related/todos          | Create new
|GET        | /tags/:tagId/related/todos/:todoId  | Show existing
|PUT        | /tags/:tagId/related/todos/:todoId  | Update existing (Replace)
|PATCH      | /tags/:tagId/related/todos/:todoId  | Patch exsiting (Partial update)
|DELETE     | /tags/:tagId/related/todos/:todoId  | Delete 
|GET        | /tags/:tagId/related/todos          | Show list


___________
 
## Check out the Docs for more details:

- [Basics](Docs/Basics.md)

- [Fluent Model Extensions](Docs/Fluent-Model-Convenience-Extensions.md)

- [CRUD for Resource Models](Docs/CRUD-for-Resource-Models.md)

- [CRUD for Related Resource Models](Docs/CRUD-Related-Resource-Models.md)

- [CRUD for Relations](Docs/CRUD-for-Relations.md)

- [Controller Middlewares](Docs/Controller-Middlewares.md)

- [Combine Controllers](Docs/Combine-Controllers.md)

- [API Versioning](Docs/API-Versioning.md)

- [Filtering](Docs/Filtering.md)

- [Sorting](Docs/Sorting.md)

- [Eager Loading](Docs/Eager-Loading.md)

- [Pagination](Docs/Pagination.md)
 
# Licensing

Vapor RestKit is licensed under MIT license.

