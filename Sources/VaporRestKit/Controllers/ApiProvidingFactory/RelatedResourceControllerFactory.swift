//
//  
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

public struct RelatedResourceControllerFactory<Model, RelatedModel, Output, EagerLoading>
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
}

public extension RelatedResourceControllerFactory {
    var relationController: RelationControllerFactory<Model, RelatedModel, Output, EagerLoading> {
        return RelationControllerFactory<Model, RelatedModel, Output, EagerLoading>(resourceFactory: self)
    }
}

public extension RelatedResourceControllerFactory {
    func create<Input>(with: Input.Type) -> APIMethodsProviding
        where
        Input: ResourceUpdateModel,
        Model == Input.Model  {

            switch keyPathType {
            case .children(let relationKeyPath):
                return CreateChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath)

            case .inversedChildren(let relationKeyPath):
                return CreateParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath)
            }
    }

    func update<Input>(with: Input.Type) -> APIMethodsProviding
        where
        Input: ResourceUpdateModel,
        Model == Input.Model  {

            switch keyPathType {
            case .children(let relationKeyPath):
                return UpdateChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath)
            case .inversedChildren(let relationKeyPath):
                return UpdateParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath)
            }
    }

    func patch<Input>(with: Input.Type) -> APIMethodsProviding
        where
        Input: ResourcePatchModel,
        Model == Input.Model  {

            switch keyPathType {
            case .children(let relationKeyPath):
                return PatchChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath)

            case .inversedChildren(let relationKeyPath):
                return PatchParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath)
            }
    }

    func delete() -> APIMethodsProviding  {

        switch keyPathType {
        case .children(let relationKeyPath):
            return DeleteChildrenResourceController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: relationName,
                              childrenKeyPath: relationKeyPath)

        case .inversedChildren(let relationKeyPath):
            return DeleteParentResourceController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: relationName,
                              inversedChildrenKeyPath: relationKeyPath)
        }
    }

    func collection<Sorting, Filtering>(sorting: Sorting.Type,
                                        filtering: Filtering.Type,
                                        config: IterableControllerConfig = .defaultConfig) -> APIMethodsProviding
        where
        Sorting: SortProvider,
        Sorting.Model == Model,
        Filtering: FilterProvider,
        Filtering.Model == Model {

            switch keyPathType {
            case .children(let relationKeyPath):
                return CollectionChildResourceController<Model,
                    RelatedModel,
                    Output,
                    Sorting,
                    EagerLoading,
                    Filtering>(relationNamePath: relationName,
                               childrenKeyPath: relationKeyPath,
                               config: config)

            case .inversedChildren(let relationKeyPath):
                return CollectionParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Sorting,
                    EagerLoading,
                    Filtering>(relationNamePath: relationName,
                               inversedChildrenKeyPath: relationKeyPath,
                               config: config)
            }
    }
}

public extension RelatedResourceControllerFactory where RelatedModel: Authenticatable {
    func create<Input>(with: Input.Type, authenticatable: RelatedModel.Type) -> APIMethodsProviding
        where
        Input: ResourceUpdateModel,
        Model == Input.Model  {

            switch keyPathType {
            case .children(let relationKeyPath):
                return CreateAuthChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath)

            case .inversedChildren(let relationKeyPath):
                return CreateAuthParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath)
            }
    }

    func update<Input>(with: Input.Type, authenticatable: RelatedModel.Type) -> APIMethodsProviding
        where
        Input: ResourceUpdateModel,
        Model == Input.Model  {

            switch keyPathType {
            case .children(let relationKeyPath):
                return UpdateAuthChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath)

            case .inversedChildren(let relationKeyPath):
                return UpdateAuthParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath)
            }
    }

    func patch<Input>(with: Input.Type, authenticatable: RelatedModel.Type) -> APIMethodsProviding
        where
        Input: ResourcePatchModel,
        Model == Input.Model  {

            switch keyPathType {
            case .children(let relationKeyPath):
                return PatchAuthChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath)

            case .inversedChildren(let relationKeyPath):
                return PatchParentResourceController<Model,
                    RelatedModel,
                    Output, Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath)
            }
    }

    func delete(authenticatable: RelatedModel.Type) -> APIMethodsProviding  {
        switch keyPathType {
        case .children(let relationKeyPath):
            return DeleteAuthChildrenResourceController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: relationName,
                              childrenKeyPath: relationKeyPath)

        case .inversedChildren(let relationKeyPath):
            return DeleteAuthParentResourceController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: relationName,
                              inversedChildrenKeyPath: relationKeyPath)
        }
    }

    func collection<Sorting, Filtering>(authenticatable: RelatedModel.Type,
                                        sorting: Sorting.Type,
                                        filtering: Filtering.Type,
                                        config: IterableControllerConfig = .defaultConfig) -> APIMethodsProviding
        where
        Sorting: SortProvider,
        Sorting.Model == Model,
        Filtering: FilterProvider,
        Filtering.Model == Model {

            switch keyPathType {
            case .children(let relationKeyPath):
                return CollectionAuthChildResourceController<Model,
                    RelatedModel,
                    Output,
                    Sorting,
                    EagerLoading,
                    Filtering>(relationNamePath: relationName,
                               childrenKeyPath: relationKeyPath,
                               config: config)

            case .inversedChildren(let relationKeyPath):
                return CollectionAuthParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Sorting,
                    EagerLoading,
                    Filtering>(relationNamePath: relationName,
                               inversedChildrenKeyPath: relationKeyPath,
                               config: config)
            }
    }
}
