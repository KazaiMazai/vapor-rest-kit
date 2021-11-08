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
routesBuilder.group("todos", Todo.idPath, "relation_name", "tags", Tag.idPath, "relation") {
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


**It's also possible to use use RelationController with Authenticatable models.**

**It's possible to use RelationController with all types of relations mentioned above.**
 
