//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- CreateParentResourceController

open struct CreateParentRelationController<Model, RelatedModel, Output, Input, EagerLoading>: CreatableRelationController, ParentResourceRelationProviding
    where
    Output: ResourceOutputModel,
    Input: ResourceUpdateModel,
    Model == Input.Model,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

    let relationNamePath: String
    let inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel>

}


//MARK:- DeleteParentRelationController

struct DeleteParentRelationController<Model, RelatedModel, Output, EagerLoading>: DeletableRelationController, ParentResourceRelationProviding
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

    let relationNamePath: String
    let inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel>

}
