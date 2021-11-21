## Combine controllers
### CompoundResourceController
#### How to use custom controllers along with pre-implemented


CompoundResourceController allows to combine several controllers into one.  


1. Create your custom CustomTodoController and make it conform to *APIMethodsProviding* protocol:

```swift
struct CustomUserController:  APIMethodsProviding { 
    func someMethod(_ req: Request) -> EventLoopFuture<SomeResponse> {
       //Some stuff here
    }
    
    func anotherMethod(_ req: Request) -> EventLoopFuture<SomeResponse> {
       //Some stuff here
    }
    
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        routeBuilder.on(.POST, "users", body: .collect, use: self.someMethod)
        routeBuilder.on(.PUT, "users", body: .collect, use: self.anotherMethod)
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
 
