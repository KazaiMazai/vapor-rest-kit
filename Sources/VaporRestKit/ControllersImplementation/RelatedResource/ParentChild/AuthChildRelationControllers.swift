//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- CreateAuthChildrenRelationController

open struct CreateAuthChildrenRelationController<Model, RelatedModel, Output, Input, EagerLoading>: CreatableRelationController, AuthChildrenResourceRelationProviding

    where Output: ResourceOutputModel,
          Input: ResourceUpdateModel,
          Model == Input.Model,
          Model == Output.Model,
          RelatedModel: Fluent.Model,
          Model.IDValue: LosslessStringConvertible,
          RelatedModel.IDValue: LosslessStringConvertible,
          RelatedModel: Authenticatable,
          EagerLoading: EagerLoadProvider,
          EagerLoading.Model == Model {

    let relationNamePath: String
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>
}

//MARK:- DeleteAuthChildrenRelationController

open struct DeleteAuthChildrenRelationController<Model, RelatedModel, Output, EagerLoading>:
    DeletableRelationController, AuthChildrenResourceRelationProviding
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
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>

}

