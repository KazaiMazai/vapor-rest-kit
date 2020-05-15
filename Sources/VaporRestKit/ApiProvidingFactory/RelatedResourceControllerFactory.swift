//
//  
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

public final class RelatedResourceControllerFactory<Model, RelatedModel, Output, EagerLoading>: APIMethodsProviding
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible {

    internal let resourceFactory: ResourceControllerFactory<Model, Output, EagerLoading>
    internal let keyPathType: KeyPathType
    internal let relationName: String

    internal init(_ resourceFactory: ResourceControllerFactory<Model, Output, EagerLoading>,
                  childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>,
                  relationName: String) {

        self.resourceFactory = resourceFactory
        self.keyPathType = .children(childrenKeyPath)
        self.relationName = relationName
    }

    internal init(_ resourceFactory: ResourceControllerFactory<Model, Output, EagerLoading>,
                  childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>,
                  relationName: String) {

        self.resourceFactory = resourceFactory
        self.keyPathType = .inversedChildren(childrenKeyPath)
        self.relationName = relationName
    }

    internal enum KeyPathType {
        case children(ChildrenKeyPath<RelatedModel, Model>)
        case inversedChildren(ChildrenKeyPath<Model, RelatedModel>)
    }

    fileprivate var controllers: [APIMethodsProviding] = []

    fileprivate func adding(_ controller: APIMethodsProviding) -> RelatedResourceControllerFactory  {
        controllers.append(controller)
        return self
    }
}

public extension RelatedResourceControllerFactory {
    var relationController: RelationControllerFactory<Model, RelatedModel, Output, EagerLoading> {
        return RelationControllerFactory<Model, RelatedModel, Output, EagerLoading>(resourceFactory: self)
    }
}

public extension RelatedResourceControllerFactory {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        resourceFactory.addMethodsTo(routeBuilder, on: endpoint)
        CompoundResourceController(with: controllers).addMethodsTo(routeBuilder, on: endpoint)
    }
}

public extension RelatedResourceControllerFactory {
    func create<Input>(with: Input.Type) -> RelatedResourceControllerFactory
        where
        Input: ResourceUpdateModel,
        Model == Input.Model  {

            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(CreateChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath))

            case .inversedChildren(let relationKeyPath):
                return adding(CreateParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath))
            }
    }

    func read() -> RelatedResourceControllerFactory {
            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(ReadChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath))

            case .inversedChildren(let relationKeyPath):
                return adding(ReadParentResourceController<Model,
                    RelatedModel,
                    Output,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath))
            }
    }

    func update<Input>(with: Input.Type) -> RelatedResourceControllerFactory
        where
        Input: ResourceUpdateModel,
        Model == Input.Model  {

            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(UpdateChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath))
            case .inversedChildren(let relationKeyPath):
                return adding(UpdateParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath))
            }
    }

    func patch<Input>(with: Input.Type) -> RelatedResourceControllerFactory
        where
        Input: ResourcePatchModel,
        Model == Input.Model  {

            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(PatchChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath))

            case .inversedChildren(let relationKeyPath):
                return adding(PatchParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath))
            }
    }

    func delete() -> RelatedResourceControllerFactory  {

        switch keyPathType {
        case .children(let relationKeyPath):
            return adding(DeleteChildrenResourceController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: relationName,
                              childrenKeyPath: relationKeyPath))

        case .inversedChildren(let relationKeyPath):
            return adding(DeleteParentResourceController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: relationName,
                              inversedChildrenKeyPath: relationKeyPath))
        }
    }

    func collection<Sorting, Filtering>(sorting: Sorting.Type,
                                        filtering: Filtering.Type,
                                        config: IterableControllerConfig = .defaultConfig) -> RelatedResourceControllerFactory
        where
        Sorting: SortProvider,
        Sorting.Model == Model,
        Filtering: FilterProvider,
        Filtering.Model == Model {

            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(CollectionChildResourceController<Model,
                    RelatedModel,
                    Output,
                    Sorting,
                    EagerLoading,
                    Filtering>(relationNamePath: relationName,
                               childrenKeyPath: relationKeyPath,
                               config: config))

            case .inversedChildren(let relationKeyPath):
                return adding(CollectionParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Sorting,
                    EagerLoading,
                    Filtering>(relationNamePath: relationName,
                               inversedChildrenKeyPath: relationKeyPath,
                               config: config))
            }
    }
}

public extension RelatedResourceControllerFactory where RelatedModel: Authenticatable {
    func create<Input>(with: Input.Type, authenticatable: RelatedModel.Type) -> RelatedResourceControllerFactory
        where
        Input: ResourceUpdateModel,
        Model == Input.Model  {

            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(CreateAuthChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath))

            case .inversedChildren(let relationKeyPath):
                return adding(CreateAuthParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath))
            }
    }

    func read() -> RelatedResourceControllerFactory {
            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(ReadAuthChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath))

            case .inversedChildren(let relationKeyPath):
                return adding(ReadAuthParentResourceController<Model,
                    RelatedModel,
                    Output,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath))
            }
    }

    func update<Input>(with: Input.Type, authenticatable: RelatedModel.Type) -> RelatedResourceControllerFactory
        where
        Input: ResourceUpdateModel,
        Model == Input.Model  {

            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(UpdateAuthChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath))

            case .inversedChildren(let relationKeyPath):
                return adding(UpdateAuthParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath))
            }
    }

    func patch<Input>(with: Input.Type, authenticatable: RelatedModel.Type) -> RelatedResourceControllerFactory
        where
        Input: ResourcePatchModel,
        Model == Input.Model  {

            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(PatchAuthChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath))

            case .inversedChildren(let relationKeyPath):
                return adding(PatchParentResourceController<Model,
                    RelatedModel,
                    Output, Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath))
            }
    }

    func delete(authenticatable: RelatedModel.Type) -> RelatedResourceControllerFactory  {
        switch keyPathType {
        case .children(let relationKeyPath):
            return adding(DeleteAuthChildrenResourceController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: relationName,
                              childrenKeyPath: relationKeyPath))

        case .inversedChildren(let relationKeyPath):
            return adding(DeleteAuthParentResourceController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: relationName,
                              inversedChildrenKeyPath: relationKeyPath))
        }
    }

    func collection<Sorting, Filtering>(authenticatable: RelatedModel.Type,
                                        sorting: Sorting.Type,
                                        filtering: Filtering.Type,
                                        config: IterableControllerConfig = .defaultConfig) -> RelatedResourceControllerFactory
        where
        Sorting: SortProvider,
        Sorting.Model == Model,
        Filtering: FilterProvider,
        Filtering.Model == Model {

            switch keyPathType {
            case .children(let relationKeyPath):
                return adding(CollectionAuthChildResourceController<Model,
                    RelatedModel,
                    Output,
                    Sorting,
                    EagerLoading,
                    Filtering>(relationNamePath: relationName,
                               childrenKeyPath: relationKeyPath,
                               config: config))

            case .inversedChildren(let relationKeyPath):
                return adding(CollectionAuthParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Sorting,
                    EagerLoading,
                    Filtering>(relationNamePath: relationName,
                               inversedChildrenKeyPath: relationKeyPath,
                               config: config))
            }
    }
}
