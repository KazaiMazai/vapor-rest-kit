# Vapor RestKit

This package is intended to speed up backend development using server side swift framework Vapor 4.
It allows to build up Restful APIs in decalrative way.

## Features
- Fluent Model convenience extensions for Init schema migrations
- Fluent Model convenience extensions for Siblings relations
- Declarative CRUD for Resource Models
- CRUD for all kinds of Relations
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

#### How to create CRUD API blazingly fast

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
                    .collection(sorting: SortingUnsupported.self,
                                filtering: FilteringUnsupported.self)

``` 
3. Add controller's methods to Vapor's routes builder:

```
controller.addMethodsTo(routeBuilder, on: "todos")

```
  
This will add the following methods to your API endpoint: 


| HTTP Method                 | Route            | Result
| --------------------------- |:-----------------| :---------------|
|POST       | /todos                    | Create new
|GET        | /todos/:todoID            | Show existing
|PUT        | /todos/:todoID            | Update existing (Replace)
|PATCH      | /todos/:todoID            | Patch exsiting (Partial update)
|GET        | /todos/                   | Show list

### Related Resource Controllers

#### How to create nestedd CRUD API with entities relations

##### Siblings

1. Define Inputs, Outputs as usual
2. Define relation controller providing relation keyPath and some *relationName* or nil, if not needed.

```
let controller = Tag.Output
        .controller(eagerLoading: EagerLoadingUnsupported.self)
        .related(with: \Todo.$tags, relationName: "mentioned")
        .create(input: Tag.CreateInput.self)
        .read()
        .update(input: Tag.UpdateInput.self)
        .patch(input: Tag.PatchInput.self)
        .collection(sorting: SortingUnsupported.self,
                    filtering: FilteringUnsupported.self)

```

3. Add related tags controller on top of "todos" route group:


```
let todos = routeBuilder.grouped("todos")
controller.addMethodsTo(todos, on: "tags")
```

This will add the following methods:


| HTTP Method                 | Route               | Result
| --------------------------- |:--------------------| :---------------|
|POST       | /todos/:todoID/mentioned/tags         | Create new
|GET        | /todos/:todoID/mentioned/tags/:tagID  | Show existing
|PUT        | /todos/:todoID/mentioned/tags/:tagID  | Update existing (Replace)
|PATCH      | /todos/:todoID/mentioned/tags/:tagID  | Patch exsiting (Partial update)
|GET        | /todos/:todoID/mentioned/tags/:tagID  | Show list

###### nil for *relationName*

In case of nil provided as *relationName*, the following routes will be created:

| HTTP Method                 | Route               | Result
| --------------------------- |:--------------------| :---------------|
|POST       | /todos/:todoID/tags         | Create new as related
|GET        | /todos/:todoID/tags/:tagID  | Show existing
|PUT        | /todos/:todoID/tags/:tagID  | Update existing (Replace)
|PATCH      | /todos/:todoID/tags/:tagID  | Patch exsiting (Partial update)
|GET        | /todos/:todoID/tags/:tagID  | Show list of related

##### Inversed Siblings

Nested controllers for siblings work in both directions. 
We can create:
- Tags controller for Tags mentioned in a Todo
- Todo controller for Todos related to a Tag:

1.
```
let controller = Todo.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(with: \Tag.$relatedTodos, relationName: "related")
                .collection(sorting: SortingUnsupported.self,
                            filtering: FilteringUnsupported.self)


```
2.
```
let tags = routeBuilder.grouped("tags")
controller.addMethodsTo(tags, on: "todos")
```
Will result in:

| HTTP Method                 | Route               | Result
| --------------------------- |:--------------------| :---------------|
|POST       | /tags/:tagID/related/todos          | Create new
|GET        | /tags/:tagID/related/todos/:todoID  | Show existing
|PUT        | /tags/:tagID/related/todos/:todoID  | Update existing (Replace)
|PATCH      | /tags/:tagID/related/todos/:todoID  | Patch exsiting (Partial update)
|GET        | /tags/:tagID/related/todos/:todoID  | Show list

##### Parent - Child relations


##### Child / Parent

##### Related to Authenticatable Model






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
                    .collection(sorting: SortingUnsupported.self, filtering: FilteringUnsupported.self),

                CustomCreateUserController() ])
```

 ##### Important

 **It's up to developer to take care of http methods that are still available, otherwise Vapor will probably get sad due to attempt to use the same method several twice.**
 

## Relations
RestKit supports all kinds of Fluent relations to create nested routes:
- Parent/Child
- Child/Parent
- Siblings





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

BTW Associated types with protocols contraints would make sure, that we haven't missed anything.

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
                .collection(sorting: SortingUnsupported.self,
                            filtering: FilteringUnsupported.self)

        }

        var apiV2: APIMethodsProviding {
            return Todo.OutputV2
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .read()
                .collection(sorting: SortingUnsupported.self, filtering: FilteringUnsupported.self)
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
