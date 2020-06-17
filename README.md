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
    .package(url: "https://github.com/KazaiMazai/vapor-rest-kit",  from: "1.0.0-beta.1.2")
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


1. Define Inputs, Outputs structs for your Model
2. Define controller with RestKit Declarative API:

```swift
let controller = Tag.Output
        .controller(eagerLoading: TagsEagerLoading.self)
        .related(with: \Todo.$tags, relationName: "mentioned")
        .create(using: Tag.CreateInput.self)
        .read()
        .update(using: Tag.UpdateInput.self)
        .patch(using: Tag.PatchInput.self)
        .collection(sorting: TagsSortingKeys.self,
                    filtering: TagsFilteringKeys.self)

```
 
## Check Docs for more details:

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

