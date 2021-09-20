## CRUD for Resource Models
### Resource Controllers

#### How to create CRUD API

1. Create Inputs, Outputs for your model:

```swift
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

2. Implement Controller:

```swift
struct TodoController {
    func create(req: Request) throws -> EventLoopFuture<Todo.Output> {
        try ResourceController<Todo.Output>().create(
            req: req,
            using: Todo.Input.self)
    }

    func read(req: Request) throws -> EventLoopFuture<Todo.Output> {
        try ResourceController<Todo.Output>().read(req: req)
    }

    func update(req: Request) throws -> EventLoopFuture<Todo.Output> {
        try ResourceController<Todo.Output>().update(req: req, using: Todo.Input.self)
    }

    func patch(req: Request) throws -> EventLoopFuture<Todo.Output> {
        try ResourceController<Todo.Output>().patch(req: req, using: Todo.PatchInput.self)
    }

    func delete(req: Request) throws -> EventLoopFuture<Todo.Output> {
        try ResourceController<Todo.Output>().delete(req: req)
    }

    func index(req: Request) throws -> EventLoopFuture<CursorPage<Todo.Output>> {
        try ResourceController<Todo.Output>().getCursorPage(req: req, config: CursorPaginationConfig.defaultConfig)
    }
}

```
3. Add controller's methods to Vapor's routes builder:

```swift

routeBuilder.group("todos") {
    let controller = TodoController()

    $0.on(.POST, use: controller.create)
    $0.on(.GET, Todo.idPath, use: controller.read)
    $0.on(.PUT, Todo.idPath, use: controller.update)
    $0.on(.DELETE, Todo.idPath, use: controller.delete)
    $0.on(.PATCH, Todo.idPath, use: controller.patch)
    $0.on(.GET, use: controller.index)
}

```

 
<details><summary>Deprecated</summary>
<p>
 
2. Define which operations will be supported by your resource controller:

```swift
let controller = Todo.Output
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .create(using: Todo.CreateInput.self)
                    .read()
                    .update(using: Todo.UpdateInput.self)
                    .patch(using: Todo.PatchInput.self)
                    .delete()
                    .collection(sorting: DefaultSorting.self,
                                filtering: DefaultFiltering.self)

``` 
3. Add controller's methods to Vapor's routes builder:

```swift
controller.addMethodsTo(routeBuilder, on: "todos")

```

</p>
</details>


  
This will add the following methods to your API endpoint: 


| HTTP Method                 | Route            | Result
| --------------------------- |:-----------------| :---------------|
|POST       | /todos                    | Create new
|GET        | /todos/:todoId            | Show existing
|PUT        | /todos/:todoId            | Update existing (Replace)
|PATCH      | /todos/:todoId            | Patch exsiting (Partial update)
|DELETE     | /todos/:todoId            | Delete 
|GET        | /todos                    | Show list

### DeleteOutput 

By default delete method will return deleted model instance wrapped into output as response.


<details><summary>Deprecated</summary>
<p>
    
If defined this way, controller will return deleted model instance wrapped into output as response:

```swift
let controller = Todo.Output
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .delete()

```

It's possible to define special empty Output for delete controller, or use default **SuccessOutput**:

```swift
let controller =  SuccessOutput<Todo>
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .delete()

```
   
</p>
</details>

