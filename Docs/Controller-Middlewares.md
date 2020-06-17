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
