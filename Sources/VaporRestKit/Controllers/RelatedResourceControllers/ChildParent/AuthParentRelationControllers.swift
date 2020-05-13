//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- CreateAuthParentRelationController

open struct CreateAuthParentRelationController<Model, RelatedModel, Output, Input, EagerLoading>: CreatableRelationController, AuthParentResourceRelationProviding
    where
    Output: ResourceOutputModel,
    Input: ResourceUpdateModel,
    Model == Input.Model,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    RelatedModel: Authenticatable,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {


    let relationNamePath: String
    let inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel>

}


//MARK:- DeleteAuthParentRelationController

struct DeleteAuthParentRelationController<Model, RelatedModel, Output, EagerLoading>: DeletableRelationController, AuthParentResourceRelationProviding
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    RelatedModel: Authenticatable,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

    let relationNamePath: String
    let inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel>

}
