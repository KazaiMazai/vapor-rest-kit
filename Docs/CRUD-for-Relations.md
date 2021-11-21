## CRUD for Relations 
### RelationControllers
#### How to create controllers for relations

It's possible to create relation controllers to attach/detach existing entites

1. Create relation controller methods:

```swift
  
struct TagsForTodoRelationController {

    func createRelation(req: Request) throws -> EventLoopFuture<Tag.Output> {
        try RelationsController<Tag.Output>().createRelation(
            req: req,
            relationKeyPath: \Todo.$tags)
    }

    func deleteRelation(req: Request) throws -> EventLoopFuture<Tag.Output> {
        try RelationsController<Tag.Output>().deleteRelation(
            req: req,
            relationKeyPath: \Todo.$tags)
    }
}

```

2. Add methods to routes builder:

```swift

app.group("todos", Todo.idPath, "relation_name", "tags", Tag.idPath, "relation") {
    let controller = TagsForTodoRelationController()

    $0.on(.POST, use: controller.createRelation)
    $0.on(.DELETE, use: controller.deleteRelation)
}

```

Will result in:

| HTTP Method                 | Route                                              | Result
| --------------------------- |:---------------------------------------------------| :---------------|
|POST                         | /todos/:todoId/relation_name/tags/:tagId/relation  | Attach instances with relation
|DELETE                       | /todos/:todoId/relation_name/tags/:tagId/relation  | Detach instances using relation 


Everything is the same as with RelatedResourceController. 

### Relations with Authenticatable Model

If root Model conforms to Vapor's Authenticatable protocol, there is a way to add relation controller so that the root model would be resolved from authenticator istead of looked up by ID.

This a quick way for attach something to current user.
 

1. Create relation controller with  `.requireAuth()` as resolver parameter:

```swift

struct MyAssignedTodosRelationController {
    func createRelation(req: Request) throws -> EventLoopFuture<Todo.Output> {
        try RelationsController<Todo.Output>().createRelation(
            resolver: .requireAuth(),
            req: req,
            relationKeyPath: \User.$assignedTodos)
    }

    func deleteRelation(req: Request) throws -> EventLoopFuture<Todo.Output> {
        try RelationsController<Todo.Output>().deleteRelation(
            resolver: .requireAuth(),
            req: req,
            relationKeyPath: \User.$assignedTodos)
    }
}

```

2. Setup route

```swift

app.group("users") {
 
    // Make sure that authenticator and auth guard middlewares are added to the route builder
    
    let auth = $0.grouped(Authenticator(), User.guardMiddleware())
    
    auth.group("me", "assigned", "todos") {
         
        $0.group(Todo.idPath, "relation") {
            let controller = MyAssignedTodosRelationController()

            $0.on(.POST, use: controller.createRelation)
            $0.on(.DELETE, use: controller.deleteRelation)
        }
    }
}

```

