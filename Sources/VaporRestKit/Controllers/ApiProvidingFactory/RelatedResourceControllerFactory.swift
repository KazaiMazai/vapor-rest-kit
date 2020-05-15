//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

struct RelatedResourceControllerFactory<Model, RelatedModel, Output, EagerLoading>
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    RelatedModel: Fluent.Model,
RelatedModel.IDValue: LosslessStringConvertible {

    let resourceFactory: ResourceControllerFactory<Model, Output, EagerLoading>
    let relationType: RelationType
    let relationName: String

    init(_ resourceFactory: ResourceControllerFactory<Model, Output, EagerLoading>,
         relationType: RelationType,
         relationName: String,
         authenitcatedRelatedModel: Bool) {

        self.resourceFactory = resourceFactory
        self.relationType = relationType
        self.relationName = relationName
    }

    init(_ resourceFactory: ResourceControllerFactory<Model, Output, EagerLoading>,
         child: ChildrenKeyPath<RelatedModel, Model>,
         relationName: String) {

        self.resourceFactory = resourceFactory
        self.relationType = .child(child)
        self.relationName = relationName
    }

    init(_ resourceFactory: ResourceControllerFactory<Model, Output, EagerLoading>,
         reversedChild: ChildrenKeyPath<Model, RelatedModel>,
         relationName: String) {

        self.resourceFactory = resourceFactory
        self.relationType = .reversedChild(reversedChild)
        self.relationName = relationName
    }

    enum RelationType {
        case child(ChildrenKeyPath<RelatedModel, Model>)
        case reversedChild(ChildrenKeyPath<Model, RelatedModel>)
    }

    func relationController() -> RelationControllerFactory<Model, RelatedModel, Output, EagerLoading> {
        return RelationControllerFactory<Model, RelatedModel, Output, EagerLoading>(resourceFactory: self)
    }
}

extension RelatedResourceControllerFactory {
    func create<Input>(with: Input.Type) -> APIMethodsProviding
        where
        Input: ResourceUpdateModel,
        Model == Input.Model  {


            switch relationType {
            case .child(let relationKeyPath):
                return CreateChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath)

            case .reversedChild(let relationKeyPath):
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


            switch relationType {
            case .child(let relationKeyPath):
                return UpdateChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath)
            case .reversedChild(let relationKeyPath):
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


            switch relationType {
            case .child(let relationKeyPath):
                return PatchChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath)

            case .reversedChild(let relationKeyPath):
                return PatchParentResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath)
            }
    }

    func delete() -> APIMethodsProviding  {

        switch relationType {
        case .child(let relationKeyPath):
            return DeleteChildrenResourceController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: relationName,
                              childrenKeyPath: relationKeyPath)

        case .reversedChild(let relationKeyPath):
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

            switch relationType {
            case .child(let relationKeyPath):
                return CollectionChildResourceController<Model,
                    RelatedModel,
                    Output,
                    Sorting,
                    EagerLoading,
                    Filtering>(relationNamePath: relationName,
                               childrenKeyPath: relationKeyPath,
                               config: config)

            case .reversedChild(let relationKeyPath):
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

extension RelatedResourceControllerFactory where RelatedModel: Authenticatable {
    func create<Input>(with: Input.Type, authenticatable: RelatedModel.Type) -> APIMethodsProviding
        where
        Input: ResourceUpdateModel,
        Model == Input.Model  {


            switch relationType {
            case .child(let relationKeyPath):
                return CreateAuthChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath)

            case .reversedChild(let relationKeyPath):
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


            switch relationType {
            case .child(let relationKeyPath):
                return UpdateAuthChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath)

            case .reversedChild(let relationKeyPath):
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

            switch relationType {
            case .child(let relationKeyPath):
                return PatchAuthChildrenResourceController<Model,
                    RelatedModel,
                    Output,
                    Input,
                    EagerLoading>(relationNamePath: relationName,
                                  childrenKeyPath: relationKeyPath)

            case .reversedChild(let relationKeyPath):
                return PatchParentResourceController<Model,
                    RelatedModel,
                    Output, Input,
                    EagerLoading>(relationNamePath: relationName,
                                  inversedChildrenKeyPath: relationKeyPath)
            }
    }

    func delete(authenticatable: RelatedModel.Type) -> APIMethodsProviding  {
        switch relationType {
        case .child(let relationKeyPath):
            return DeleteAuthChildrenResourceController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: relationName,
                              childrenKeyPath: relationKeyPath)

        case .reversedChild(let relationKeyPath):
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

            switch relationType {
            case .child(let relationKeyPath):
                return CollectionAuthChildResourceController<Model,
                    RelatedModel,
                    Output,
                    Sorting,
                    EagerLoading,
                    Filtering>(relationNamePath: relationName,
                               childrenKeyPath: relationKeyPath,
                               config: config)

            case .reversedChild(let relationKeyPath):
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
