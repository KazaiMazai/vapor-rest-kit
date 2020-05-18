# Vapor RestKit

This package is intended to speed up backend development using server side swift framework Vapor 4.
It allows to build up Restful APIs in decalrative way.

## Features
- Fluent Model convenience extensions for Init schema migrations
- Fluent Model convenience extensions for Siblings relations
- Declarative CRUD for Resource Models
- CRUD for all kinds of Relations
- Controller Middlewares for custom business logic
- API versioning
- API versioning for Resource Models
- Filtering 
- Sorting
- Eager loading
- Pagination by cursor/page


## Fluent Model Extensions
### FieldsProvidingModel
#### How to stop suffering from string literals in Fluent Models' Fields


Allows to create Model's fields as an enum and then safely use it without hassling with string literals and suffering from fat fingers.

```
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

```
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

```
func configureDatabaseInitialMigrations(_ app: Application) {
    app.migrations.add(User.createInitialMigration()) 
}
```

3. PROFIT!


### SiblingRepresentable
#### How to stop suffering from Siblings pivot models boiler plate

Short-cut for creating many-to-many relations.

1. Define whatever as SiblingRepresentable (enum for example)

```
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

```
final class User: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Siblings(through: Relations.RelatedTags.through, from: \.$from, to: \.$to)
    var relatedTags: [Tag]
}
```

3. Add initial migration for pivot Fluent model representing the sibling after related models:

```
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

```
protocol ResourceOutputModel: Content {
    associatedtype Model: Fields

    init(_: Model)
}
```

and **Input**:

```
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



## CRUD Controllers

### Resource Controllers

#### How to create CRUD API

1. Create Inputs, Outputs for your model:

```
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

```
let controller = Todo.Output
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .create(input: Todo.CreateInput.self)
                    .read()
                    .update(input: Todo.UpdateInput.self)
                    .patch(input: Todo.PatchInput.self)
                    .delete()
                    .collection(sorting: DefaultSorting.self,
                                filtering: DefaultFiltering.self)

``` 
3. Add controller's methods to Vapor's routes builder:

```
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


### Delete Output

If defined this way, controller will return deleted model instance wrapped into output as response:

```
let controller = Todo.Output
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .delete()

```

It's possible to define special empty Output for delete controller, or use default **SuccessOutput**:

```
let controller =  SuccessOutput<Todo>
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .delete()

```


### Related Resource Controllers

#### How to create nested CRUD API with related models

#### Siblings

1. Define Inputs, Outputs as usual
2. Define relation controller providing sibling relation keyPath and some *relationName* or nil, if not needed.

```
let controller = Tag.Output
        .controller(eagerLoading: EagerLoadingUnsupported.self)
        .related(with: \Todo.$tags, relationName: "mentioned")
        .create(input: Tag.CreateInput.self)
        .read()
        .update(input: Tag.UpdateInput.self)
        .patch(input: Tag.PatchInput.self)
        .collection(sorting: DefaultSorting.self,
                    filtering: DefaultFiltering.self)

```

3. Add related tags controller on top of "todos" route group:


```
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

###### nil for *relationName*

In case of nil provided as *relationName*, the following routes will be created:

| HTTP Method                 | Route               | Result
| --------------------------- |:--------------------| :---------------|
|POST       | /todos/:todoId/tags         | Create new as related
|GET        | /todos/:todoId/tags/:tagId  | Show existing
|PUT        | /todos/:todoId/tags/:tagId  | Update existing (Replace)
|PATCH      | /todos/:todoId/tags/:tagId  | Patch exsiting (Partial update)
|DELETE     | /todos/:todoId/tags/:tagId  | Delete 
|GET        | /todos/:todoId/tags         | Show list of related

#### Inversed Siblings

Nested controllers for siblings work in both directions. 
We can create:
- Tags controller for Tags related to a Todo
- Todo controller for Todos related to a Tag:

1. Create controller
```
let controller = Todo.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(with: \Tag.$relatedTodos, relationName: "related")
                .create(input: Todo.Input.self)
                .read()
                .update(input: Todo.Input.self)
                .patch(input: Todo.PatchInput.self)
                .read()
                .delete()
                .collection(sorting: DefaultSorting.self,
                            filtering: DefaultFiltering.self)


```
2. Add methods to route builder
```
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

#### Parent / Child relations

1. Create controller with child relation keyPath and optional *relationName*

```
let controller = Todo.Output
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .related(with: \User.$todos, relationName: "managed")
                    .create(input: Todo.Input.self)
                    .read()
                    .update(input: Todo.Input.self)
                    .patch(input: Todo.PatchInput.self)
                    .read()
                    .delete()
                    .collection(sorting: DefaultSorting.self,
                                filtering: DefaultFiltering.self)
        

```

2. Add methods to route builder:

```
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


#### Child / Parent
Probably more rare case, but still supported. Inversed nested controller for child - parent relation

1. Create controller with child relation keyPath and optional *relationName*:

```
let controller = User.Output
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .related(with: \User.$todos, relationName: "author")
                    .read()
```


2. Add methods to route builder:

```
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


##### Related to Authenticatable Model
If root Model conforms to Vapor's Authenticatable protocol, it's possible to add **/me** nested controllers.
It works the same way as with other type of relations:


1. Create controller with relation keyPath, optional *relationName* and mention **authenticatable** type:

```
let controller = Todo.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(with: \User.$todos, relationName: "managed")
                .read(authenticatable: User.self)
                .collection(authenticatable: User.self,
                            sorting: DefaultSorting.self,
                            filtering: DefaultFiltering.self)
        

```
2. Make sure that auth and auth guard middlewares are added to the routee

```
authRoutesBuilder = routeBuilder.grouped(Authenticator(), User.guardMiddleware())
```

3. Add methods to route builder:

```
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

### Related Resource Controllers
#### How to create controllers for relations

It's possible to create relation controllers to attach/detach existing entites

The proccess is almost the same as usual:

1. Use **relation** property of contoller builder:

```
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
 


### Controller Middlewares
#### How to add custom business logic to Resource Controller


#### Override ResourceUpdateModel method

Default implementation of that method is:

```
func update(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model> {
    return database.eventLoop.tryFuture { try update(model) }
}

```

It can be made complex, but with the following restrictions: 
- **All database requests should be performed with provided database instance parameter**
- **Database instance parameter should be used for obtaining event loop**
- **Transactions should not be used because write operations are already wrapped in a transaction on upper layers**


#### Override ResourcePatchModel method

Default implementation of that method is:

```
func patch(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model> {
    return database.eventLoop.tryFuture { try patch(model) }
}

```

It can be made complex, but with the following restrictions: 
- **All database requests should be performed with provided database instance**
- **Database instance parameter should be used for obtaining event loop
- **Transactions should not be used because write operations are already wrapped in a transaction on upper layers**

#### Provide RelatedResourceControllerMiddleware for RelatedResourceControllers or RelationControllers

When creating nested controller that works with related resource or relations, it's possible to provide middleware method that will be called **before** saving to database:
- Right **after** Resource Model is created/patched/updated in memory
- Right **before** Resource Model and Related Resource models will be attached/detached and saved to database.


1. Define middleware:

```
let middleware = RelatedResourceControllerMiddleware<Todo, User>() { todo, user, req, database in

    // Do something here
    // return database.eventLoop.makeFailedFuture(SomeError())
    // or
    // return database.eventLoop.tryFuture { try someFailingStuff() }
    
    return database.eventLoop.makeSucceededFuture((todo, user))
}
```

2. Add middleware to controller 
```
let controller = Todo.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(with: \User.$todos, relationName: nil)
                .create(with: Todo.Input.self,
                        middleware: middleware)
                .patch(with: Todo.PatchInput.self, middleware: anotherMiddleware)

```
3. Pofit!

For middlewares restrictions are the same:
- **All database requests should be performed with provided database instance**
- **Database instance parameter should be used for obtaining event loop
- **Transactions should not be used because write operations are already wrapped in a transaction on upper layers**


#### Use Delete Handler
 
Custon delete busiess logic can be defined via Fluent on database level: cascade delete, etc.
Fluent also provides model lifecycle callbacks that can be used for that.

RestKit provides a way to implement delete logic on controller's layer via DeleteHandler

1. Define delete handler:

```
let deleter1 = DeleteHandler<Todo>(handler: { (todo, forceDelete, req, database) -> EventLoopFuture<Todo> in
                //that's the default implementation:
                return todo.delete(force: forceDelete, on: database)
 }, useForcedDelete: false)
 
 //or
 
let deleter2 = DeleteHandler<Todo>(useForcedDelete: true)
 
let deleter 
```

2. Provide custom deleter to delete controller builder:

```
let controller = Todo.Output
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .read()
                    .delete(with: customDeleter)

```

Restrictions are usual for RestKit middlewares:
- **All database requests should be performed with provided database instance**
- **Database instance parameter should be used for obtaining event loop
- **Transactions should not be used because write operations are already wrapped in a transaction on upper layers**




### CompoundResourceController
#### How to use custom controllers along with pre-implemented


CompoundResourceController allows to combine several controllers into one.  


1. Create your custom CustomTodoController and make it conform to *APIMethodsProviding* protocol:

```
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
 
```
let controller: APIMethodsProviding = CompoundResourceController(with: [
                Todo.Output
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .collection(sorting: DefaultSorting.self, filtering: DefaultFiltering.self),

                CustomCreateUserController() ])
```

 ##### Important

 **It's up to developer to take care of http methods that are still available, otherwise Vapor will probably get sad due to attempt to use the same method several twice.**
 



## API versioning
### VersionableController

VersionableController protocol is to force destinguishing controllers versions.

```
open protocol VersionableController {
    associatedtype ApiVersion

    func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion)
}

```

### Versioning via Resource Models

Resource Inputs and Outputs as well as all necessary dependencies needed for Controllers and ModelProviders are required to be provided explicitly as associated types.  

BTW Associated types with protocols contraints would make sure, that we haven't missed anything. Complier won't let you.

This allows to create managable versioned Resource Models as follows:

```
extension Todo {
    struct OutputV1: ResourceOutputModel {
        let id: UUID?
        let name: String
        let description: String 
 
        init(_ model: Todo) {
            self.id = model.id
            self.name = model.title
            self.description = model.notes
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

### Dynamic Filtering

## Sorting

### Static Sorting

### Dynamic Sorting

## Eager Loading

### Static Eager Loading

### Dynamic Eager Loading

###  Versioned Output for Eager Loaded Resource Models

## Pagination

### Cursor

### Page

### Collection access without Pagination
