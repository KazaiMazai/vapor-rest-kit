//
//  
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

public struct RelationControllerFactory<Model, RelatedModel, Output, EagerLoading>
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible {

    internal let resourceFactory: RelatedResourceControllerFactory<Model, RelatedModel, Output, EagerLoading>
    
}

public extension RelationControllerFactory {
    func create() -> APIMethodsProviding {
        switch resourceFactory.relationType {
        case .child(let relationKeyPath):
            return CreateChildrenRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceFactory.relationName,
                              childrenKeyPath: relationKeyPath)

        case .reversedChild(let relationKeyPath):
            return CreateParentRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceFactory.relationName,
                              inversedChildrenKeyPath: relationKeyPath)
        }
    }

    func delete() -> APIMethodsProviding {
        switch resourceFactory.relationType {
        case .child(let relationKeyPath):
            return DeleteChildrenRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceFactory.relationName,
                              childrenKeyPath: relationKeyPath)

        case .reversedChild(let relationKeyPath):
            return DeleteParentRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceFactory.relationName,
                              inversedChildrenKeyPath: relationKeyPath)
        }
    }
}

public extension RelationControllerFactory where RelatedModel: Authenticatable {
    func create(authenticatable: RelatedModel.Type) -> APIMethodsProviding {
        switch resourceFactory.relationType {
        case .child(let relationKeyPath):
            return CreateAuthChildrenRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceFactory.relationName,
                              childrenKeyPath: relationKeyPath)

        case .reversedChild(let relationKeyPath):
            return CreateAuthParentRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceFactory.relationName,
                              inversedChildrenKeyPath: relationKeyPath)
        }
    }

    func delete(authenticatable: RelatedModel.Type) -> APIMethodsProviding {
        switch resourceFactory.relationType {
        case .child(let relationKeyPath):
            return DeleteAuthChildrenRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceFactory.relationName,
                              childrenKeyPath: relationKeyPath)

        case .reversedChild(let relationKeyPath):
            return DeleteAuthParentRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceFactory.relationName,
                              inversedChildrenKeyPath: relationKeyPath)
        }
    }
}

