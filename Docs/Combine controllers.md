## Combine controllers
### CompoundResourceController
#### How to use custom controllers along with pre-implemented


CompoundResourceController allows to combine several controllers into one.  


1. Create your custom CustomTodoController and make it conform to *APIMethodsProviding* protocol:

```swift
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
 
```swift
let controller: APIMethodsProviding = CompoundResourceController(with: [
                Todo.Output
                    .controller(eagerLoading: EagerLoadingUnsupported.self)
                    .collection(sorting: DefaultSorting.self, filtering: DefaultFiltering.self),

                CustomCreateUserController() ])
```

 ### Important

 **It's up to developer to take care of http methods that are still available, otherwise Vapor will probably get sad due to attempt to use the same method several times.**
 
