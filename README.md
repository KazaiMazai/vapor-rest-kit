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
 
While **Mode**l is something represented as by a table in your database, Rest-Kit introduces such thing as **Resource**. Resource is a wrap over the model that is returned from backend API as response and consumed by backend API as request.


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
**Input** and **Output** Resources provide managable interface for the models..



## Resource Controllers

Since ResourceModelOutput is defined for a Model class, ResourceController creations turnes out as easy as:

```
let controller: APIMethodsProviding = User.Output
                                        .controller(eagerLoading: EagerLoadingUnsupported.self)
                                        .read()
```

ResourceOutput and Eager Loading come to be the starting point of the controller. These two guys define response format.
The following methods will add CRUD capabilities to the controller:

- create(...) via POST
- read(...) via GET
- update(...) via PUT
- patch(...) via PATCH
- delete(...) via DELETE

- collection(...) adds resource listing capabilities via GET

Method calls can be chained to obtain required behaviour of the controller:

```
let controller = User.Output
                        .controller(eagerLoading: EagerLoadingUnsupported.self)
                        .create(input: User.Input.self)
                        .read()
                        .update(input: User.Input.self)
                        .patch(input: User.PatchInput.self)
                        .delete()
                        .collection(sorting: SortingUnsupported.self,
                                    filtering: FilteringUnsupported.self)
```


### Routes

ResourceController conforms to APIMethodsProviding protocol:

```
public protocol APIMethodsProviding {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String)
}

```

Let's cossider some entity controller:

```

let controller = Entity.Output
                        .controller(eagerLoading: EagerLoadingUnsupported.self)
                        .create(input: Entity.Input.self)
                        .read()
                        .update(input: Entity.Input.self)
                        .patch(input: Entity.PatchInput.self)
                        .delete()
                        .collection(sorting: SortingUnsupported.self,
                                    filtering: FilteringUnsupported.self)
                                    
                                    
```

Then 

```
controller.addMethodsTo(someBuilder)

``



/entity/:entity_id

| HTTP Method                 | Route template | Result
| --------------------------- |:---------------| :---------------|
|POST | /entity/  | Create new
|GET | /entity/:entity_id. | Show existing
|PUT | /entity/:entity_id. | Update existing (Replace)
|PATCH | /entity/:entity_id | Patch exsiting (Partial update)
|GET | /entity/   | Show list




### CompoundResourceController

CompoundResourceController allows to combine several single-api-method controllers into one. Each controller should conform to
*APIMethodsProviding* protocol.

```
let controller: APIMethodsProviding = CompoundResourceController(with: [
                User.Output
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .collection(sorting: SortingUnsupported.self, filtering: FilteringUnsupported.self),

                CustomCreateUserController() ])
```

 #### Important

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
