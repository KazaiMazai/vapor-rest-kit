## Basics
 
While **Mode**l is something represented by a table in your database, RestKit introduces such thing as **ResourceModel**. ResourceModel is a wrap over the Model that is returned from backend API as a response and consumed by backend API as a request.


At Rest-Kit, Resource is separated into **Output**:

```swift
protocol ResourceOutputModel: Content {
    associatedtype Model: Fields

    init(_: Model)
}
```

and **Input**:

```swift
protocol ResourceUpdateModel: Content, Validatable {
    associatedtype Model: Fields

    func update(_: Model) -> Model
}

protocol ResourcePatchModel: Content, Validatable {
    associatedtype Model: Fields

    func patch(_: Model) -> Model
}

```
**Input** and **Output** Resources provide managable interface for the models. Each model can have as many possible inputs and outputs as you wish, though it's better not to.
