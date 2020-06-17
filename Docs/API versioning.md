## API versioning
### VersionableController
#### How to distinguish api versions

VersionableController protocol is to force destinguishing controllers versions.

```swift
open protocol VersionableController {
    associatedtype ApiVersion

    func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion)
}

```

### Versioning via Resource Models
#### How to manage API inputs and outputs

Resource Inputs and Outputs as well as all necessary dependencies needed for Controllers and ModelProviders are required to be provided explicitly as associated types.  

Protocols constraints applied on associated types would make sure, that we haven't missed anything. Complier just won't let.

This allows to create manageable versioned Resource Models as follows:

```swift
extension Todo {
    struct OutputV1: ResourceOutputModel {
        let id: UUID?
        let name: String
        let oldNotes: String 
 
        init(_ model: Todo) {
            self.id = model.id
            self.name = model.title
            self.oldNotes = model.notes
        }
    }
    
    struct OutputV2: ResourceOutputModel {
        let id: UUID?
        let title: String  
        let notes: String
 
        init(_ model: Todo) {
            self.id = model.id
            self.title = model.title
            self.notes = model.notes
        }
    }
}

struct TodoController: VersionableController {
        var apiV1: APIMethodsProviding {
            return Todo.Output
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .read()
                .collection(sorting: DefaultSorting.self,
                            filtering: DefaultFiltering.self)

        }

        var apiV2: APIMethodsProviding {
            return Todo.OutputV2
                .controller(eagerLoading: EagerLoadingUnsupported.self)
                .read()
                .collection(sorting: DefaultSorting.self, filtering: DefaultFiltering.self)
        }

        func setupAPIMethods(on routeBuilder: RoutesBuilder, for endpoint: String, with version: ApiVersion) {
            switch version {
            case .v1:
                apiV1.addMethodsTo(routeBuilder, on: endpoint)
            case .v2:
                apiV2.addMethodsTo(routeBuilder, on: endpoint)
            }
        }
    }

```
