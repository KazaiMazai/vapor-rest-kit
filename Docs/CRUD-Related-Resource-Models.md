## CRUD for Related Resource Models

### Related Resource Controllers

#### How to create nested CRUD API with related models


1. Define Inputs, Outputs as usual

 
2. Define relation controller providing sibling relation keyPath and some *relationName* or nil, if not needed.

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
            relationKeyPath: \Galaxy.$stars)
    }
}

```

3. Routes setup:


```swift

app.group("galaxies") {
   
    $0.group(Galaxy.idPath, "contains") {
    
        $0.group("stars") {
        
            let controller = StarForGalaxyNestedController()

            $0.on(.POST, use: controller.create)
            $0.on(.GET, Star.idPath, use: controller.read)
            $0.on(.PUT, Star.idPath, use: controller.update)
            $0.on(.PATCH, Star.idPath, use: controller.patch)
            $0.on(.DELETE, Star.idPath, use: controller.delete)
            $0.on(.GET, use: controller.index)
 
        }
    }
}
```
     

This will result in the following methods:


| HTTP Method                 | Route               | Result
| --------------------------- |:--------------------| :---------------|
|POST       | /galaxies/:GalaxyId/contains/stars         | Create new
|GET        | /galaxies/:GalaxyId/contains/stars/:starId  | Show existing
|PUT        | /galaxies/:GalaxyId/contains/stars/:starId  | Update existing (Replace)
|PATCH      | /galaxies/:GalaxyId/contains/stars/:starId  | Patch exsiting (Partial update)
|DELETE     | /galaxies/:GalaxyId/contains/stars/:starId  | Delete 
|GET        | /galaxies/:GalaxyId/contains/stars         | Show list

*Under the hood, there is a "resolver guy", who takes models' IDs from the route query path as `Galaxy.idPath` and `Star.idPath` and then looks them up in the database, taking into account specified relations key paths.*

Actually we can easily do without "contains" part of the path:

```swift

app.group("galaxies") {
   
    $0.group(Galaxy.idPath) {
    
        $0.group("stars") {
        
            let controller = StarForGalaxyNestedController()

            $0.on(.POST, use: controller.create)
            $0.on(.GET, Star.idPath, use: controller.read)
            $0.on(.PUT, Star.idPath, use: controller.update)
            $0.on(.PATCH, Star.idPath, use: controller.patch)
            $0.on(.DELETE, Star.idPath, use: controller.delete)
            $0.on(.GET, use: controller.index)
 
        }
    }
}

```

And get the following methods: 

| HTTP Method                 | Route               | Result
| --------------------------- |:--------------------| :---------------|
|POST       | /galaxies/:GalaxyId/stars         | Create new
|GET        | /galaxies/:GalaxyId/stars/:starId  | Show existing
|PUT        | /galaxies/:GalaxyId/stars/:starId  | Update existing (Replace)
|PATCH      | /galaxies/:GalaxyId/stars/:starId  | Patch exsiting (Partial update)
|DELETE     | /galaxies/:GalaxyId/stars/:starId  | Delete 
|GET        | /galaxies/:GalaxyId/stars         | Show list




### Supported relations type

`RelatedResourceController` supports Child-Parent and Siblings relations in both directions. 
Meaning that you can setup all kinds of "galaxy for star" or "stars for galaxy" controllers for parent-child relations. Along with "post-for-tags" or "tags-for-post" controllers for siblings relations.


### Related to Authenticatable Model

If root Model conforms to Vapor's Authenticatable protocol, there is a way to add related resource controller for it. So that the root model would come from authenticator istead of looked up by ID.
This a quick way for creating current user's posts or todos or whatever.
 

1. Create controller with relation keyPath and pass `.requireAuth()` as resolver parameter:


```swift
struct MyTodosController {
    func create(req: Request) throws -> EventLoopFuture<Todo.Output> {
        try RelatedResourceController<Todo.Output>().create(
            resolver: .requireAuth(),
            req: req,
            using: Todo.Input.self,
            relationKeyPath: \User.$todos)
    }

    func read(req: Request) throws -> EventLoopFuture<Todo.Output> {
        try RelatedResourceController<Todo.Output>().read(
            resolver: .requireAuth(),
            req: req,
            relationKeyPath: \User.$todos)
    }

    func update(req: Request) throws -> EventLoopFuture<Todo.Output> {
        try RelatedResourceController<Todo.Output>().update(
            resolver: .requireAuth(),
            req: req,
            using: Todo.Input.self,
            relationKeyPath: \User.$todos)
    }

    func delete(req: Request) throws -> EventLoopFuture<Todo.Output> {
        try RelatedResourceController<Todo.Output>().delete(
            resolver: .requireAuth(),
            req: req,
            relationKeyPath: \User.$todos)
    }

    func patch(req: Request) throws -> EventLoopFuture<Todo.Output> {
        try RelatedResourceController<Todo.Output>().patch(
            resolver: .requireAuth(),
            req: req,
            using: Todo.PatchInput.self,
            relationKeyPath: \User.$todos)
    }

    func index(req: Request) throws -> EventLoopFuture<CursorPage<Todo.Output>> {
        try RelatedResourceController<Todo.Output>().getCursorPage(
            resolver: .requireAuth(),
            req: req,
            relationKeyPath: \User.$todos,
            config: CursorPaginationConfig.defaultConfig)
    }
}
        

```

2. Setup route

```swift

app.group("users") {
 
    // Make sure that authenticator and auth guard middlewares are added to the route builder
    
    let auth = $0.grouped(Authenticator(), User.guardMiddleware())
    
    auth.group("me", "todos") {
    
        let controller = MyTodosController()

        $0.on(.POST, use: controller.create)
        $0.on(.GET, Todo.idPath, use: controller.read)
        $0.on(.PUT, Todo.idPath, use: controller.update)
        $0.on(.PATCH, Todo.idPath, use: controller.patch)
        $0.on(.DELETE, Todo.idPath, use: controller.delete)
        $0.on(.GET, use: controller.index)
    }
}

```
   
Will result in:

| HTTP Method                 | Route               | Result
| --------------------------- |:--------------------| :---------------|
|POST       | /users/me/todos          | Create new
|GET        | /users/me/todos/:todoId  | Show existing
|PUT        | /users/me/todos/:todoId  | Update existing (Replace)
|PATCH      | /users/me/todos/:todoId  | Patch exsiting (Partial update)
|DELETE     | /users/me/todos/:todoId  | Delete 
|GET        | /users/me/todos          | Show list
