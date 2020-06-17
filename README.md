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
## Fluent Model Extensions
### FieldsProvidingModel
#### How to stop suffering from string literals in Fluent Models' Fields


Allows to create Model's fields as an enum and then safely use it without hassling with string literals and suffering from fat fingers.

```swift
extension User: FieldsProvidingModel {
    enum Fields: String, FieldKeyRepresentable {
        case username
    }
}

final class User: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: Fields.username.key)
    var username: String?
    
}
    
 extension User: InitMigratableSchema {
    static func prepare(on schemaBuilder: SchemaBuilder) -> EventLoopFuture<Void> {
        return schemaBuilder
            .id()
            .field(Fields.username.key, .string)
            .create()
    }
}


```
### InitMigratableSchema
#### How to stop suffering from Fluent Models' initial migrations boilerplate 


Easy-breazy stuff for creating initial migrations in three simple steps.
1. Make your model conform to InitMigratableSchema protocol, by implementing static prepare(...) method (almost as usual)

```swift
extension User: InitMigratableSchema {
    static func prepare(on schemaBuilder: SchemaBuilder) -> EventLoopFuture<Void> {
        return schemaBuilder
            .id()
            .field(Fields.username.key, .string)
            .create()
    }
}

```

2. Add initial migration for the model in your configuration file:

```swift
func configureDatabaseInitialMigrations(_ app: Application) {
    app.migrations.add(User.createInitialMigration()) 
}
```

3. PROFIT!


    ### SiblingRepresentable
    #### How to stop suffering from Siblings pivot models boiler plate

    Short-cut for creating many-to-many relations.

    1. Define whatever as SiblingRepresentable (enum for example)

    ```swift
    extension Todo {
        enum Relations {
            enum RelatedTags: SiblingRepresentable {
                typealias From = Todo
                typealias To = Tag
                typealias Through = SiblingModel<Todo, Tag, Self>
            }
        }
    }

    ```

    2. Add corresponding property with @Siblings property wrapper

    ```swift
    final class User: Model, Content {
        static let schema = "users"

        @ID(key: .id)
        var id: UUID?

        @Siblings(through: Relations.RelatedTags.through, from: \.$from, to: \.$to)
        var relatedTags: [Tag]
    }
    ```

    3. Add initial migration for pivot Fluent model representing the sibling after related models:

    ```swift
    private func configureDatabaseInitialMigrations(_ app: Application) {
        app.migrations.add(Todo.createInitialMigration())
        app.migrations.add(Tag.createInitialMigration()) 
        app.migrations.add(Todo.Relations.RelatedTags.Through.createInitialMigration())
    }

    ```

    4. Profit! No need to feel pain from pivot models manual creation any more.

## Basics
 
While **Mode**l is something represented by a table in your database, RestKit introduces such thing as **ResourceModel**. ResourceModel is a wrap over the Model that is returned from backend API as a response and consumed by backend API as a request.


At Rest-Kit, Resource is separated into **Output**:

```swift
protocol ResourceOutputModel: Content {
    associatedtype Model: Fields

    init(_: Model)
}
```

and **Input**:

```swift
protocol ResourceUpdateModel: Content, Validatable {
    associatedtype Model: Fields

    func update(_: Model) -> Model
}

protocol ResourcePatchModel: Content, Validatable {
    associatedtype Model: Fields

    func patch(_: Model) -> Model
}

```
**Input** and **Output** Resources provide managable interface for the models. Each model can have as many possible inputs and outputs as you wish, though it's better not to.


## CRUD for Resource Models
### Resource Controllers

#### How to create CRUD API

1. Create Inputs, Outputs for your model:

```swift
extension Todo {
    struct Output: ResourceOutputModel {
        let id: Int?
        let title: String

        init(_ model: Todo, req: Request) {
            id = model.id
            title = model.title
        }
    }
    
    struct CreateInput: ResourceUpdateModel {
        let title: String

        func update(_ model: Todo) throws -> Todo {
            model.title = title
            return model
        }

        static func validations(_ validations: inout Validations) {
            //Validate something
        }
    }
    
    
    struct UpdateInput: ResourceUpdateModel {
        let title: String

        func update(_ model: Todo) throws -> Todo {
            model.title = title
            return model
        }

        static func validations(_ validations: inout Validations) {
            //Validate something
        }
    }

    struct PatchInput: ResourcePatchModel {
        let title: String?

        func patch(_ model: Todo) throws -> Todo {
            model.title = title ?? model.title
            return model
        }

        static func validations(_ validations: inout Validations) {
            //Validate something
        }
    }

}

```

2. Define which operations will be supported by your resource controller:

```swift
let controller = Todo.Output
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .create(using: Todo.CreateInput.self)
                    .read()
                    .update(using: Todo.UpdateInput.self)
                    .patch(using: Todo.PatchInput.self)
                    .delete()
                    .collection(sorting: DefaultSorting.self,
                                filtering: DefaultFiltering.self)

``` 
3. Add controller's methods to Vapor's routes builder:

```swift
controller.addMethodsTo(routeBuilder, on: "todos")

```
  
This will add the following methods to your API endpoint: 


| HTTP Method                 | Route            | Result
| --------------------------- |:-----------------| :---------------|
|POST       | /todos                    | Create new
|GET        | /todos/:todoId            | Show existing
|PUT        | /todos/:todoId            | Update existing (Replace)
|PATCH      | /todos/:todoId            | Patch exsiting (Partial update)
|DELETE     | /todos/:todoId            | Delete 
|GET        | /todos                    | Show list

### DeleteOutput
#### How to change Delete Output

If defined this way, controller will return deleted model instance wrapped into output as response:

```swift
let controller = Todo.Output
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .delete()

```

It's possible to define special empty Output for delete controller, or use default **SuccessOutput**:

```swift
let controller =  SuccessOutput<Todo>
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .delete()

```


## CRUD for Related Resource Models

### Related Resource Controllers

#### How to create nested CRUD API with related models

### Siblings

1. Define Inputs, Outputs as usual
2. Define relation controller providing sibling relation keyPath and some *relationName* or nil, if not needed.

```swift
let controller = Tag.Output
        .controller(eagerLoading: EagerLoadingUnsupported.self)
        .related(with: \Todo.$tags, relationName: "mentioned")
        .create(using: Tag.CreateInput.self)
        .read()
        .update(using: Tag.UpdateInput.self)
        .patch(using: Tag.PatchInput.self)
        .collection(sorting: DefaultSorting.self,
                    filtering: DefaultFiltering.self)

```

3. Add related tags controller on top of "todos" route group:


```swift
let todos = routeBuilder.grouped("todos")
controller.addMethodsTo(todos, on: "tags")
```

This will add the following methods:


| HTTP Method                 | Route               | Result
| --------------------------- |:--------------------| :---------------|
|POST       | /todos/:todoId/mentioned/tags         | Create new
|GET        | /todos/:todoId/mentioned/tags/:tagId  | Show existing
|PUT        | /todos/:todoId/mentioned/tags/:tagId  | Update existing (Replace)
|PATCH      | /todos/:todoId/mentioned/tags/:tagId  | Patch exsiting (Partial update)
|DELETE     | /todos/:todoId/mentioned/tags/:tagId  | Delete 
|GET        | /todos/:todoId/mentioned/tags         | Show list



In case of nil provided as *relationName*, the following routes will be created:

| HTTP Method                 | Route               | Result
| --------------------------- |:--------------------| :---------------|
|POST       | /todos/:todoId/tags         | Create new as related
|GET        | /todos/:todoId/tags/:tagId  | Show existing
|PUT        | /todos/:todoId/tags/:tagId  | Update existing (Replace)
|PATCH      | /todos/:todoId/tags/:tagId  | Patch exsiting (Partial update)
|DELETE     | /todos/:todoId/tags/:tagId  | Delete 
|GET        | /todos/:todoId/tags         | Show list of related

### Inversed Siblings

Nested controllers for siblings work in both directions. 
We can create:
- Tags controller for Tags related to a Todo
- Todo controller for Todos related to a Tag:

1. Create controller
```swift
let controller = Todo.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(with: \Tag.$relatedTodos, relationName: "related")
                .create(using: Todo.Input.self)
                .read()
                .update(using: Todo.Input.self)
                .patch(using: Todo.PatchInput.self)
                .read()
                .delete()
                .collection(sorting: DefaultSorting.self,
                            filtering: DefaultFiltering.self)


```
2. Add methods to route builder
```swift
let tags = routeBuilder.grouped("tags")
controller.addMethodsTo(tags, on: "todos")
```
Will result in:

| HTTP Method                 | Route               | Result
| --------------------------- |:--------------------| :---------------|
|POST       | /tags/:tagId/related/todos          | Create new
|GET        | /tags/:tagId/related/todos/:todoId  | Show existing
|PUT        | /tags/:tagId/related/todos/:todoId  | Update existing (Replace)
|PATCH      | /tags/:tagId/related/todos/:todoId  | Patch exsiting (Partial update)
|DELETE     | /tags/:tagId/related/todos/:todoId  | Delete 
|GET        | /tags/:tagId/related/todos          | Show list

### Parent / Child relations

1. Create controller with child relation keyPath and optional *relationName*

```swift
let controller = Todo.Output
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .related(with: \User.$todos, relationName: "managed")
                    .create(using: Todo.Input.self)
                    .read()
                    .update(using: Todo.Input.self)
                    .patch(using: Todo.PatchInput.self)
                    .read()
                    .delete()
                    .collection(sorting: DefaultSorting.self,
                                filtering: DefaultFiltering.self)
        

```

2. Add methods to route builder:

```swift
let users = routeBuilder.grouped("users")
controller.addMethodsTo(userss, on: "todos")

```


Will result in:

| HTTP Method                 | Route               | Result
| --------------------------- |:--------------------| :---------------|
|POST       | /users/:userId/managed/todos          | Create new
|GET        | /users/:userId/managed/todos/:todoId  | Show existing
|PUT        | /users/:userId/managed/todos/:todoId  | Update existing (Replace)
|PATCH      | /users/:userId/managed/todos/:todoId  | Patch exsiting (Partial update)
|DELETE     | /users/:userId/managed/todos/:todoId  | Delete 
|GET        | /users/:userId/managed/todos          | Show list


### Child / Parent relations
Probably more rare case, but still supported. Inversed nested controller for child - parent relation

1. Create controller with child relation keyPath and optional *relationName*:

```swift
let controller = User.Output
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .related(with: \User.$todos, relationName: "author")
                    .read()
```


2. Add methods to route builder:

```swift
let users = routeBuilder.grouped("users")
controller.addMethodsTo(users, on: "todos")

```



Will result in:

| HTTP Method                 | Route               | Result
| --------------------------- |:--------------------| :---------------|
|POST       | /todos/:todoId/author/users          | Create new
|GET        | /todos/:todoId/author/users/:userId  | Show existing
|PUT        | /todos/:todoId/author/users/:userId  | Update existing (Replace)
|PATCH      | /todos/:todoId/author/users/:userId  | Patch exsiting (Partial update)
|DELETE     | /todos/:todoId/author/users/:userId  | Delete
|GET        | /todos/:todoId/author/users          | Show list


### Related to Authenticatable Model
If root Model conforms to Vapor's Authenticatable protocol, it's possible to add **/me** nested controllers.
It works the same way as with other type of relations:


1. Create controller with relation keyPath, optional *relationName* and mention **authenticatable** type:

```swift
let controller = Todo.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(with: \User.$todos, relationName: "managed")
                .read(authenticatable: User.self)
                .collection(authenticatable: User.self,
                            sorting: DefaultSorting.self,
                            filtering: DefaultFiltering.self)
        

```
2. Make sure that auth and auth guard middlewares are added to the routee

```swift
authRoutesBuilder = routeBuilder.grouped(Authenticator(), User.guardMiddleware())
```

3. Add methods to route builder:

```swift
let users = authRoutesBuilder.grouped("users")
controller.addMethodsTo(userss, on: "todos")

```

Will result in:

| HTTP Method                 | Route               | Result
| --------------------------- |:--------------------| :---------------|
|POST       | /users/me/managed/todos          | Create new
|GET        | /users/me/managed/todos/:todoId  | Show existing
|PUT        | /users/me/managed/todos/:todoId  | Update existing (Replace)
|PATCH      | /users/me/managed/todos/:todoId  | Patch exsiting (Partial update)
|DELETE     | /users/me/managed/todos/:todoId  | Delete 
|GET        | /users/me/managed/todos          | Show list


## CRUD for Relations 
### RelationControllers
#### How to create controllers for relations

It's possible to create relation controllers to attach/detach existing entites

The proccess is almost the same as usual:

1. Use **relation** property of contoller builder:

```swift
let controller = Tag.Output
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .related(with: \Todo.$tags, relationName: "relation_name")
                    .relation
                    .create()
                    .delete()

```

Will result in:

| HTTP Method                 | Route                                              | Result
| --------------------------- |:---------------------------------------------------| :---------------|
|POST                         | /todos/:todoId/relation_name/tags/:tagId/relation  | Attach instances with relation
|DELETE                       | /todos/:todoId/relation_name/tags/:tagId/relation  | Detach instances using relation 


Everything is the same as with RelatedResourceController. 
Relation name parameter is still optional. If nil is provided then the routes will look like:

| HTTP Method                 | Route                                              | Result
| --------------------------- |:---------------------------------------------------| :---------------|
|POST                         | /todos/:todoId/tags/:tagId/relation  | Attach instances with relation
|DELETE                       | /todos/:todoId/tags/:tagId/relation  | Detach instances using relation 


**It's also possible to use use RelationController with Authenticatable models.**
**It's possible to use RelationController with all types of relations mentioned above.**
 


## Controller Middlewares

### ResourceUpdateModel
#### How to add custom business logic to Resource Controller


#### Override ResourceUpdateModel method

Default implementation of that method is:

```swift
func update(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model> {
    return database.eventLoop.tryFuture { try update(model) }
}

```

It can be made complex, but with the following restrictions: 
- **All database requests should be performed with provided database instance parameter**
- **Database instance parameter should be used for obtaining event loop**
- **Transactions should not be used because write operations are already wrapped in a transaction on upper layers**

### ResourcePatchModel
#### Override ResourcePatchModel method

Default implementation of that method is:

```swift
func patch(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model> {
    return database.eventLoop.tryFuture { try patch(model) }
}

```

It can be made complex, but with the following restrictions: 
- **All database requests should be performed with provided database instance**
- **Database instance parameter should be used for obtaining event loop**
- **Transactions should not be used because write operations are already wrapped in a transaction on upper layers**

### RelatedResourceControllerMiddleware
#### How to provide custom middleware for RelatedResourceControllers or RelationControllers

When creating nested controller that works with related resource or relations, it's possible to provide middleware method that will be called **before** saving to database:
- Right **after** Resource Model is created/patched/updated in memory
- Right **before** Resource Model and Related Resource models will be attached/detached and saved to database.


1. Define middleware:

```swift
let middleware = RelatedResourceControllerMiddleware<Todo, User>() { todo, user, req, database in

    // Do something here
    // return database.eventLoop.makeFailedFuture(SomeError())
    // or
    // return database.eventLoop.tryFuture { try someFailingStuff() }
    
    return database.eventLoop.makeSucceededFuture((todo, user))
}
```

2. Add middleware to controller 
```swift
let controller = Todo.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(with: \User.$todos, relationName: nil)
                .create(using: Todo.Input.self,
                        middleware: middleware)
                .patch(using: Todo.PatchInput.self, middleware: middleware)

```
3. Profit!

For middlewares restrictions are the same:
- **All database requests should be performed with provided database instance**
- **Database instance parameter should be used for obtaining event loop**
- **Transactions should not be used because write operations are already wrapped in a transaction on upper layers**

### DeleteHandler
#### Custom Delete logic with DeleteHandler
 
Custon delete busiess logic can be defined via Fluent on database level: cascade delete, etc.
Fluent also provides model lifecycle callbacks that can be used for that.

RestKit provides a way to implement delete logic on controller's layer via DeleteHandler

1. Define delete handler:

```swift

let deleter = DeleteHandler<Todo>(handler: { (todo, forceDelete, req, database) -> EventLoopFuture<Todo> in
                //that's the default implementation:
                return todo.delete(force: forceDelete, on: database)
 }, useForcedDelete: false)
 
```

2. Provide custom deleter to delete controller builder:

```swift
let controller = Todo.Output
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .read()
                    .delete(with: deleter)

```

Restrictions are usual for RestKit middlewares:
- **All database requests should be performed with provided database instance**
- **Database instance parameter should be used for obtaining event loop**
- **Transactions should not be used because write operations are already wrapped in a transaction on upper layers**



## Combine controllers
### CompoundResourceController
#### How to use custom controllers along with pre-implemented


CompoundResourceController allows to combine several controllers into one.  


1. Create your custom CustomTodoController and make it conform to *APIMethodsProviding* protocol:

```swift
struct CustomCreateUserController:  APIMethodsProviding {

    func someMethod(_ req: Request) -> EventLoopFuture<SomeResponse> {
       //Some stuff here
    }
    
    
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        let path = resourcePathFor(endpoint: endpoint)
        routeBuilder.on(.POST, path, body: .collect, use: self.someMethod)
    }
}

```

2. Use CompoundResourceController:
 
```swift
let controller: APIMethodsProviding = CompoundResourceController(with: [
                Todo.Output
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .collection(sorting: DefaultSorting.self, filtering: DefaultFiltering.self),

                CustomCreateUserController() ])
```

 ### Important

 **It's up to developer to take care of http methods that are still available, otherwise Vapor will probably get sad due to attempt to use the same method several times.**
 



## API versioning
### VersionableController
#### How to distinguish api versions

VersionableController protocol is to force destinguishing controllers versions.

```swift
open protocol VersionableController {
    associatedtype ApiVersion

    func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion)
}

```

### Versioning via Resource Models
#### How to manage API inputs and outputs

Resource Inputs and Outputs as well as all necessary dependencies needed for Controllers and ModelProviders are required to be provided explicitly as associated types.  

Protocols constraints applied on associated types would make sure, that we haven't missed anything. Complier just won't let.

This allows to create manageable versioned Resource Models as follows:

```swift
extension Todo {
    struct OutputV1: ResourceOutputModel {
        let id: UUID?
        let name: String
        let oldNotes: String 
 
        init(_ model: Todo) {
            self.id = model.id
            self.name = model.title
            self.oldNotes = model.notes
        }
    }
    
    struct OutputV2: ResourceOutputModel {
        let id: UUID?
        let title: String  
        let notes: String
 
        init(_ model: Todo) {
            self.id = model.id
            self.title = model.title
            self.notes = model.notes
        }
    }
}

struct TodoController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Todo.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .read()
                .collection(sorting: DefaultSorting.self,
                            filtering: DefaultFiltering.self)

        }

        var apiV2: APIMethodsProviding {
            return Todo.OutputV2
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .read()
                .collection(sorting: DefaultSorting.self, filtering: DefaultFiltering.self)
        }

        func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
            switch version {
            case .v1:
                apiV1.addMethodsTo(routeBuilder, on: endpoint)
            case .v2:
                apiV2.addMethodsTo(routeBuilder, on: endpoint)
            }
        }
    }

```


## Filtering

### Static Filtering
#### How to setup default filters for controller methods


1. Define filter struct, conforming to StaticFiltering protocol:

```swift
struct StarsFiltering: StaticFiltering {
    typealias Model = Star
    typealias Key = EmptyFilteringKey

    func defaultFiltering(_ queryBuilder: QueryBuilder<Star>) -> QueryBuilder<Star> {
        //no filter will be applied:
        return queryBuilder
    }
}

```

2. When defining controller, add filter type as collection controller builder parameter:

```swift

let controller = Star.Output
        .controller(eagerLoading: EagerLoadingUnsupported.self)
        .create(using: Star.Input.self)
        .read()
        .update(using: Star.Input.self)
        .patch(using: Star.PatchInput.self)
        .delete()
        .collection(sorting: StarControllers.StarsSorting.self, 
                    filtering: StarControllers.StarsFiltering.self)

```

Such filter will be always applied to the collection request

### Dynamic Filtering

*Restkit allows to define acceptable filtering keys for dynamic filtering.

Supported filter types: 
- value filters
- field filters allowing to filter against entity's other fields values*


#### How to setup dynamic filters query

1. Define filter struct, conforming to DynamicFiltering protocol:

```swift
struct StarsFiltering: DynamicFiltering {
    typealias Model = Star
    typealias Key = Keys

    func defaultFiltering(_ queryBuilder: QueryBuilder<Star>) -> QueryBuilder<Star> {
        //no filter
        return queryBuilder
    }

    enum Keys: String, FilteringKey {
        typealias Model = Star

        case title
        case subtitle
        case size

        func filterFor(queryBuilder: QueryBuilder<Star>,
                       method: DatabaseQuery.Filter.Method,
                       value: String) -> QueryBuilder<Star> {

            switch self {
            case .title:
                return queryBuilder.filter(\.$title, method, value)
            case .subtitle:
                return queryBuilder.filter(\.$subtitle, method, value)
            case .size:
                guard let intValue = Int(value) else {
                    return queryBuilder
                }
                return queryBuilder.filter(\.$size, method, intValue)
            }
        }

        static func filterFor(queryBuilder: QueryBuilder<Star>,
                              lhs: Keys,
                              method: DatabaseQuery.Filter.Method,
                              rhs: Keys) -> QueryBuilder<Star> {
            switch (lhs, rhs) {
            case (.title, .subtitle):
                return queryBuilder.filter(\.$title, method, \.$subtitle)
            case (.subtitle, .title):
                return queryBuilder.filter(\.$subtitle, method, \.$title)
            default:
                return queryBuilder
            }
        }
    }
}
```

2. When defining controller, add filter type as collection controller builder parameter:

```swift

let controller = Star.Output
        .controller(eagerLoading: EagerLoadingUnsupported.self)
        .create(using: Star.Input.self)
        .read()
        .update(using: Star.Input.self)
        .patch(using: Star.PatchInput.self)
        .delete()
        .collection(sorting: StarControllers.StarsSorting.self, 
                    filtering: StarControllers.StarsFiltering.self)

```
#### Definitions



The following func defines default filtering, applied to the collection.
```swift
func defaultFiltering() 
```
- If filtering enitity conforms to **StaticFiltering** default filtering is always applied. 
- If filtering enitity conforms to **DynamicFiltering** default filtering is applied if no filter keys provided.



The following Keys enum defines supported dynamic keys 


```swift 
 enum Keys: String, FilteringKey {
        typealias Model = Star

        case title
        case subtitle
        case size
}
```
 
The following func provides mapping current of keys to a filtered queryBuilder via

```swift
func filterFor(queryBuilder: QueryBuilder<Star>,
                           method: DatabaseQuery.Filter.Method,
                           value: String) -> QueryBuilder<Star> 

```

The following func defines supported field filter if needed. 
It provides mapping of filter keys and method to a filtered queryBuilder:

```swift
static func filterFor(queryBuilder: QueryBuilder<Star>,
                                  lhs: Keys,
                                  method: DatabaseQuery.Filter.Method,
                                  rhs: Keys) -> QueryBuilder<Star> 
```

#### How to use dynamic filters query

##### Filters methods
The following filter methods are supported for querying:

```swift
enum FilterOperations: String, Codable {
    case less = "lt"
    case greater = "gt"
    case lessOrEqual = "lte"
    case greaterOrEqual = "gte"
    case equal = "eq"
    case notEqual = "ne"

    case prefix = "prefix"
    case suffix = "suffix"
    case like = "like"
}
```
#### How to query Value Filter

RestKit uses JSON format to parse filter query string. Query key is **filter**, value is valid JSON string:
```JSON
{"value":  {"value": "X", "method": "eq", "key": "title"}}
```
So the overall request query will look like:

```
https://api.yourservice.com?/v1/stars?filter={"value":  {"value": "X", "method": "eq", "key": "title"}}
```

*All values should be passed as string even if it's numerical values.*

#### How to query Field Filter
For field filters, RestKit uses JSON of the following format to parse filter query string. 
Query key is **filter**, value is valid JSON string:
```json
{"field":  {"lhs": "title", "method": "eq", "rhs": "subtitle"}}
 ```
#### How to query Complex filters

Restkit supports complex nested filters with Value and/or Field filters:
- **OR** predicate:
```json
{"or": [
    {"value":  {"value": "AAPL", "method": "eq", "key": "ticker"} },
    {"field":  {"lhs": "title", "method": "eq", "rhs": "subtitle"}}
]}

```
- **AND** predicate:
```json
{"and": [
    {"value":  {"value": "AAPL", "method": "eq", "key": "ticker"} },
    {"value":  {"value": "F", "method": "like", "key": "ticker"} }
]}

```
 
#### How to query Complex nested filters

Element of array of nested filters can be also a complex nested filter:
```json
{"or": [
    {"value":  {"value": "Hello", "method": "eq", "key": "subtitle"} },
    {"and": [
        {"value":  {"value": "h", "method": "like", "key": "title"} },
        {"value":  {"value": "f", "method": "like", "key": "title"} },
        {"value":  {"value": "a", "method": "like", "key": "title"} }
    ]}
]}
```

The complexity of nested filters is not limited.


## Sorting

### Static Sorting
#### How to setup default sorting for controller methods

1. Define Sorting struct, conforming to StaticSorting protocol:

```swift
struct StaticStarsSorting: StaticSorting {
    typealias Key = EmptySortingKey<Star>
    typealias Model = Star

    func defaultSorting(_ queryBuilder: QueryBuilder<Star>) -> QueryBuilder<Star> {
        return queryBuilder
    }
}
```

2. When defining controller, add sorting type as collection controller builder parameter:

```swift 

let controller = Star.Output
            .controller(eagerLoading: EagerLoadingUnsupported.self)
            .create(using: Star.Input.self)
            .read()
            .update(using: Star.Input.self)
            .patch(using: Star.PatchInput.self)
            .delete()
            .collection(sorting: StarControllers.StaticStarsSorting.self, 
                        filtering: StarControllers.StarsFiltering.self)
```

### Dynamic Sorting
#### How to setup dynamic sorting query keys

1. Define Sorting struct, conforming to DynamicSorting protocol:
```swift 

struct StarsSorting: DynamicSorting {
    typealias Model = Star
    typealias Key = Keys
    
    func defaultSorting(_ queryBuilder: QueryBuilder<Star>) -> QueryBuilder<Star> {
        return queryBuilder
    }
    
    enum Keys: String, SortingKey {
        typealias Model = Star

        case title
        case subtitle

        func sortFor(_ queryBuilder: QueryBuilder<Star>, direction: DatabaseQuery.Sort.Direction) -> QueryBuilder<Star> {
            switch self {
            case .title:
                return queryBuilder.sort(\Star.$title, direction)
            case .subtitle:
                return queryBuilder.sort(\Star.$subtitle, direction)
            }
        }
    }
}

```

2. When defining controller, add sorting type as collection controller builder parameter:

```swift 

let controller = Star.Output
            .controller(eagerLoading: EagerLoadingUnsupported.self)
            .create(using: Star.Input.self)
            .read()
            .update(using: Star.Input.self)
            .patch(using: Star.PatchInput.self)
            .delete()
            .collection(sorting: StarControllers.StarsSorting.self, 
                        filtering: StarControllers.StarsFiltering.self)
```

#### Definitions
This func that defines default sorting, applied to the collection:

```swift
func defaultSorting() 
```

- If sorting enitity conforms to **StaticSorting** default sorting is always applied. 
- If sorting enitity conforms to **DynamicSorting** default StaticSorting is applied if no sorting keys provided.

### Important

**RestKit always appends sorting by ID with ascending order. This is necessary for valid cursor pagination.**

#### How to use dynamic sort query

RestKit uses the following format to parse sort query string. Query key is **sort**, value is **key:direction**
where direction is **asc** or **desc**.

The result request will look like:
```
https://api.yourservice.com/v1/stars?sort=title:asc
```

#### How to use dynamic sort query with multiple keys

It's also possible to use several sort keys, separated by comma:

```
https://api.yourservice.com/v1/stars?sort=title:asc,subtitle:desc
```

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
func defaultEagerLoading(...) 
```

- If eager loading conforms to **StaticEagerLoading** default eager loading is always applied. 
- If eager loading conforms to **DynamicEagerLoading** default eager loading is applied if no eager loading keys provided in the query.

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

## Pagination

Reskit supports pagination for collection controller:

```swift
let controller = Star.Output
        .controller(eagerLoading: EagerLoadingUnsupported.self) 
        .collection(sorting: StarControllers.StarsSorting.self, 
                    filtering: StarControllers.StarsFiltering.self)
```

### By cursor

By default, cursor pagination is applied to collection controller.

#### How to query cursor pagination

When making initial request, client should provide only limit parameter, like this:

```
https://api.yourservice.com/v1/stars?limit=10
```
 
As a part of metadata, returned by server, there will be **next_cursor** parameter.
In order to get the next portion of data, client should include cursor in the requers query:

```
https://api.yourservice.com/v1/stars?limit=10cursor=W3siZmllbGRLZXkiOiJhc3NldHNfW3RpY2tlcl0iLCJ2YWx1Z

```

Cursor is a base64 encoded string, containing data pointing to the last element of the returned portion of items. 
It also contains sorting metadata allowing to use cursor pagination along with static or dynamic sorting keys.

#### How to configure cursor pagination

1. Define config:

```swift
//defalut parameters are limitMax: 25, defaultLimit: 10

let cursorPaginationConfig = CursorPaginationConfig(limitMax: 25, defaultLimit: 10)
```

2. Provide cursor config parameter to collection controller builder:

```swift
let controller = Star.Output
        .controller(eagerLoading: StarEagerLoading.self)
        .collection(sorting: StarsSorting.self,
                    filtering: StarsFiltering.self,
                    config: .paginateWithCursor(cursorPaginationConfig))
```

### By page

#### How to use page pagination

```swift
let controller = Star.Output
        .controller(eagerLoading: StarEagerLoading.self)
        .collection(sorting: StarsSorting.self,
                    filtering: StarsFiltering.self,
                    config: .paginateByPage)
```

That config will apply default Vapor Fluent per page pagination with the following parameters:

- **page**  - for page number
- **per** - for number of items per page

This will result in something like:

```
https://api.yourservice.com/v1/stars?page=2&per=15
```
 

### Collection response without Pagination

#### How to get all items 

Not recommended for large collections, but sometimes useful to provide api for the whole list of items.

The controller should be set-up in the following way:

```swift
let controller = Star.Output
        .controller(eagerLoading: StarEagerLoading.self)
        .collection(sorting: StarsSorting.self,
                    filtering: StarsFiltering.self,
                    config: .fetchAll)
```

_______
# Licensing

The code in this project is licensed under MIT license.

