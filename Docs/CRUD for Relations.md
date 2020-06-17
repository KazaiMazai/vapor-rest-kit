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
 
