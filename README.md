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

# Fluent Model Extensions

## FieldsProvidingModel

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

## InitMigratableSchema

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

## SiblingRepresentable

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

# Basics
 
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



# Resource Controllers

## Overview

Basically, controller can be defined by two protocols:
- ResourceModelProvider 
- ResourceControllerProtocol



### ResourceModelProvider

**ResourceModelProvider works with Models**. 
ResourceModelProvider handles request query and defines the the rules how the model is obtained. 

It knows if it is a kind of related models, and handles all the hassle of working with relations.

#### ResourceModelProvider Naming
Naming rules for ResourceModelProvider are the following:
- If it is simply resource model endpoint than it's **ResourceModelProvider**

##### Resource Type
- If it contains "ModelProvider" then it is intended to work with Models as resources.
- If it contains "RelationProvider" then it is intended to work with models' Relations. It adds "/relation" to the route path.

##### Relation Type
- If it contains "Children" then the resource model is a child of the root model
- If it contains "Parent" then the resource model is a parent of the root model
- if it contains "Siblings" then the resource model and root model have "to-many" relation

##### Authenticatable
- If it contains "Auth" then the root model is Authenticatable. Basically that must be User. It creates "/me/" route path. 

 


| ResourceModelProvider                 | Route template |
| ------------------------------------- |:--------------- | 
| ResourceModelProviding                | /entity/:entity_id
|*Parent / Child*|
| ChildrenResourceModelProvider        | /:parent_entity_id/relation_name/entity/:entity_id 
| ChildrenResourceRelationProvider     | /:parent_entity_id/relation_name/entity/:entity_id/relation 
| AuthChildrenResourceModelProvider    | /me/relation_name/entity/:entity_id 
| AuthChildrenResourceRelationProvider | /me/relation_name/entity/:entity_id/relation
|*Child / Parent*|
| ParentResourceModelProvider          | /:child_entity_id/relation_name/entity/:entity_id  
| ParentResourceRelationProvider       | /:child_entity_id/relation_name/entity/:entity_id/relation
| AuthParentResourceModelProvider      | /me/relation_name/entity/:entity_id
| AuthParentResourceRelationProvider   | /me/relation_name/entity/:entity_id/relation
|*Siblings*|
| SiblingsResourceModelProvider        | /:related_entity_id/relation_name/entity/:entity_id 
| SiblingsResourceRelationProvider     | /:related_entity_id/relation_name/entity/:entity_id/relation
| AuthSiblingsResourceModelProvider    | /me/relation_name/entity/:entity_id
| AuthSiblingsResourceRelationProvider | /me/relation_name/entity/:entity_id/relation




### ResourceControllerProtocol 
ResourceControllerProtocol defines the api method that will be added to the route builder via 
```
addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String)
```

It's also ResourceControllerProtocol that defines resource API Output and Input if supported.
It performs Input validation and knows what to do with the model, provided by ResourceModelProvider

There are protocols for CRUD operations over resource models: 
- CreatableResourceController
- ReadableResourceController
- UpdatableResourceController
- PatchableResourceController
- DeletableResourceController

There is a protocol that works with resource collections
- IterableResourceController

There are protocols to create/delete relations between models
- DeletableRelationController
- CreatableRelationController

Basically all controllers are intended to provide only 1 API method so that we could combine them later.


**All these protocols has default implementaion. So behaviour can be obtained by just subclasssing from them.**


 
 
 

For convenience, all possible supported combinations of Controllers + ModelProviders are already defined.
Naming rules are almost the same as for ResourceModelProvider, adding method name, defining what controllers does.

All supported CRUD combinations can be found in the table below:

| resource type / method                | Create           | Read  |  Update  | Patch | Delete|
| ------------------------------------- |:---------------:| -----:|---------:|------:|-------|
| ResourceModelProvider             |:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|
|*Parent / Child*|
| ChildrenResourceModelProvider        |:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|  
| ChildrenResourceRelationProvider     | :heavy_check_mark:|    |    |    | :heavy_check_mark:| 
| AuthChildrenResourceModelProvider    |:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|
| AuthChildrenResourceRelationProvider | :heavy_check_mark:|    |    |    | :heavy_check_mark:| 
|*Child / Parent*|
| ParentResourceModelProvider         |  :heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|
| ParentResourceRelationProvider       | :heavy_check_mark:|    |    |    | :heavy_check_mark:|  
| AuthParentResourceModelProvider      |:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|
| AuthParentResourceRelationProvider   | :heavy_check_mark:|    |    |    | :heavy_check_mark:|
|*Siblings*|
| SiblingsResourceModelProvider        |:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|
| SiblingsResourceRelationProvider     | :heavy_check_mark:|    |    |    | :heavy_check_mark:|
| AuthSiblingsResourceModelProvider    |:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|:heavy_check_mark:|
| AuthSiblingsResourceRelationProvider | :heavy_check_mark:|    |    |    | :heavy_check_mark:|



### Examples
- CreateChildrenResourceController creates resource model, as a child of the root model on provided relation.
- DeleteChildrenResourceController search resource model by Id among children of the root model, if found, deletes it.

- CreateChildrenRelationController attaches provided models on provided relation.
- DeleteChildrenRelationController detaches provided models on provided relation.


## CompoundResourceController

CompoundResourceController is simply to combine several single-api-method controllers into one. 

Setup is as easy as the following lines:
```
struct TodosController: VersionableController {
    let controllerV1 = CompoundResourceController(with: [
        ReadResourceController<Todo, TodoOutput, TodoEagerLoader>(),
        CollectionResourceController<Todo, TodoOutput, TodoSorting, TodoEagerLoader, TodoFilter>()
    ])

    func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
        switch version {

        case .v1:
            return controllerV1.addMethodsTo(routeBuilder, on: endpoint)
        }
    }
}

```
 


# API versioning
## VersionableController

VersionableController protocol is to force destinguishing controllers versions.

```
open protocol VersionableController {
    associatedtype ApiVersion

    func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion)
}

```

## Versioning via Resource Models

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
            self.id = asset.id
            self.name = asset.title
            self.description = asset.notes
        }
    }
    
    struct OutputV2: ResourceOutputModel {
        let id: UUID?
        let title: String  
        let notes: String
 
        init(_ model: Todo) {
            self.id = asset.id
            self.title = asset.title
            self.notes = asset.notes
        }
    }
}


struct TodosController: VersionableController {
    let controllerV1 = CompoundResourceController(with: [
        ReadResourceController<Todo, Todo.OutputV1, TodoEagerLoader>(),
        CollectionResourceController<Todo, Todo.OutputV1, TodoSorting, TodoEagerLoader, TodoFilter>()
    ])
    
    let controllerV2 = CompoundResourceController(with: [
        ReadResourceController<Todo, Todo.OutputV2, TodoEagerLoader>(),
        CollectionResourceController<Todo, Todo.OutputV2, TodoSorting, TodoEagerLoader, TodoFilter>()
    ])

    func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
        switch version {

        case .v1:
            return controllerV1.addMethodsTo(routeBuilder, on: endpoint)
        case .v2:
            return controllerV2.addMethodsTo(routeBuilder, on: endpoint)
        }
    }
}

```


# Filtering

## Static Filtering

## Dynamic Filtering

# Sorting

## Static Sorting

## Dynamic Sorting

# Eager Loading

## Static Eager Loading

## Dynamic Eager Loading

##  Versioned Output for Eager Loaded Resource Models

# Pagination

## Cursor

## Page

## Collection access without Pagination
