//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- CreateChildrenRelationController

open struct CreateChildrenRelationController<Model, RelatedModel, Output, Input, EagerLoading>: CreatableRelationController, ChildrenResourceRelationProviding

    where Output: ResourceOutputModel,
          Input: ResourceUpdateModel,
          Model == Input.Model,
          Model == Output.Model,
          RelatedModel: Fluent.Model,
          Model.IDValue: LosslessStringConvertible,
          RelatedModel.IDValue: LosslessStringConvertible,
          EagerLoading: EagerLoadProvider,
          EagerLoading.Model == Model {

    let relationNamePath: String
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>
}

//MARK:- DeleteChildrenRelationController

open struct DeleteChildrenRelationController<Model, RelatedModel, Output, EagerLoading>:
    DeletableRelationController, ChildrenResourceRelationProviding
    where
        Output: ResourceOutputModel,
        Model == Output.Model,
        Model.IDValue: LosslessStringConvertible,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        EagerLoading: EagerLoadProvider,
        EagerLoading.Model == Model {

    let relationNamePath: String
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>

}
