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
 
### ResourcePatchModel
#### Override ResourcePatchModel method

Default implementation of that method is:

```swift
func patch(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model> {
    return database.eventLoop.tryFuture { try patch(model) }
}

```

It can be made as complicated as you wish, but with the following restrictions: 
- **All database requests should be performed with provided database instance**
- **Database instance parameter should be used for obtaining event loop**
 
### ControllerMiddleware
#### How to provide custom middleware for RelatedResourceController or RelationsController

When creating nested controller that works with related resource or relations, it's possible to provide middleware method that will be called 
right **before** Resource Model and Related Resource models will be attached/detached and saved to database.


1. Define middleware:

```swift
let assignTodoToUserMiddleware = ControllerMiddleware<Todo, User>() { todo, user, req, database in

    // Do something here
    // return database.eventLoop.makeFailedFuture(SomeError())
    // or
    // return database.eventLoop.tryFuture { try someFailingStuff() }
    
    database.eventLoop.makeSucceededFuture((todo, user))
}
```

2. Add middleware to controller method:

```swift 
struct UserController {
     func createRelation(req: Request) throws -> EventLoopFuture<User.Output> {
            try RelationsController<User.Output>().createRelation(
                req: req,
                willAttach: assignTodoToUserMiddleware,
                relationKeyPath: \Todo.$assignees)
      }
}
```

3. Add method to route builder:
```swift
routesBuilder.group("todos", Todo.idPath, "assignees", "users", User.idPath, "relation") {

    let controller = UserController()
    $0.on(.POST, use: controller.createRelation) 

```

4. Profit!


<details><summary>Deprecated</summary>
<p>
    
2. Add middleware to controller 
```swift
let controller = Todo.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .related(with: \User.$todos, relationName: nil)
                .relation
                .create(with: middleware) 

```
    
3. Profit!   
    
</p>
</details>




For middlewares restrictions are the same:
- **All database requests should be performed with provided database instance**
- **Database instance parameter should be used for obtaining event loop** 

### Deleter
#### Custom Delete logic with Deleter
 
Custon delete busiess logic can be defined via Fluent on database level: cascade delete, etc.
Fluent also provides model lifecycle callbacks that can be used for that.

RestKit provides a way to implement delete logic on controller's layer via Deleter

1. Define delete handler:

```swift

let deleter = Deleter<Todo>(useForcedDelete: false) { (todo, forceDelete, req, database) -> EventLoopFuture<Todo> in
    //that's the default implementation:
    todo.delete(force: forceDelete, on: database)
 }
 
```
2. Provide custom deleter to controller's delete method:

```swift

struct TodoController {
    func delete(req: Request) throws -> EventLoopFuture<Todo.Output> {
            try ResourceController<Todo.Output>().delete(
                req: req,
                using: deleter)
    }      
}

```

<details><summary>Deprecated</summary>
<p>
    
2. Provide custom deleter to delete controller builder:

```swift
let controller = Todo.Output
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .read()
                    .delete(with: deleter)

```
</p>
</details>

Restrictions are usual for RestKit middlewares:
- **All database requests should be performed with provided database instance**
- **Database instance parameter should be used for obtaining event loop** 
