//
//  File 2.swift
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- CreateRelatedResourceController

struct CreateAuthSiblingRelationController<Model, RelatedModel, Through, Output, EagerLoading>: CreatableRelationController, AuthSiblingsResourceRelationProvider

    where
    Output: ResourceOutputModel,
 
    Model == Output.Model,
    RelatedModel: Fluent.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel.IDValue: LosslessStringConvertible,
    RelatedModel: Authenticatable,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    Through: Fluent.Model {

    let relatedResourceMiddleware: RelationMiddleware<Model, RelatedModel>
    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>
}

//MARK:- DeleteRelatedResourceController

struct DeleteAuthSiblingRelationController<Model, RelatedModel, Through, Output, EagerLoading>:
    DeletableRelationController, AuthSiblingsResourceRelationProvider
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    RelatedModel: Authenticatable,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    Through: Fluent.Model {

    let relatedResourceMiddleware: RelationMiddleware<Model, RelatedModel>
    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>

}
