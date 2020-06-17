# Vapor RestKit

This package is intended to speed up backend development using server side swift framework Vapor 4.

## Features
- Generic-powered Declarative API 
- CRUD for Resource Models 
- CRUD for Related Resource Models 
- Nested routes for Parent-Child, Siblings relations
- Nested */me* routes for Authenticatable Related Resource
- API versioning for controllers and Resource Models 
- Resource Collections with pagination by Cursor, Page, or without 
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
    .package(url: "https://github.com/KazaiMazai/vapor-rest-kit",  from: "1.0.0-beta.1.5")
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


1. Define Input, Output structs for your Model, conforming to ```ResourceUpdateModel, ResourcePatchModel, ResourceOutputModel``` protocols

2. Create controller with RestKit Declarative API:

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

3. Add methods to route builder:

```swift
let tags = routeBuilder.grouped("tags")
controller.addMethodsTo(tags, on: "todos")
```

4. Get result:
 

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

- [Fluent Model Extensions](Docs/Fluent-Model-Convenience-Extensions.md)

- [Basics](Docs/Basics.md)

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

