//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

public struct SiblingsRelationControllerFactory<Model, RelatedModel, Through, Output, EagerLoading>
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    Through: Fluent.Model {

    internal let resourceFactory: SiblingsResourceControllerFactory<Model, RelatedModel, Through, Output, EagerLoading>
}

public extension SiblingsRelationControllerFactory {
    func create() -> APIMethodsProviding {
        return CreateSiblingRelationController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relationNamePath: resourceFactory.relationName,
                          siblingKeyPath: resourceFactory.relation)
    }

    func delete() -> APIMethodsProviding {
        return DeleteSiblingRelationController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relationNamePath: resourceFactory.relationName,
                          siblingKeyPath: resourceFactory.relation)
    }
}

public extension SiblingsRelationControllerFactory where RelatedModel: Authenticatable {
    func create(authenticatable: RelatedModel.Type) -> APIMethodsProviding {
        return CreateAuthSiblingRelationController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relationNamePath: resourceFactory.relationName,
                          siblingKeyPath: resourceFactory.relation)
    }

    func delete(authenticatable: RelatedModel.Type) -> APIMethodsProviding {
        return DeleteAuthSiblingRelationController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relationNamePath: resourceFactory.relationName,
                          siblingKeyPath: resourceFactory.relation)
    }
}
