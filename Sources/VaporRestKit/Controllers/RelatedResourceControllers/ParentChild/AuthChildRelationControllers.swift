//
//  
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- CreateAuthChildrenRelationController

struct CreateAuthChildrenRelationController<Model, RelatedModel, Output, EagerLoading>: CreatableRelationController, AuthChildrenResourceRelationProvider

    where Output: ResourceOutputModel,
          Model == Output.Model,
          RelatedModel: Fluent.Model,
          Model.IDValue: LosslessStringConvertible,
          RelatedModel.IDValue: LosslessStringConvertible,
          RelatedModel: Authenticatable,
          EagerLoading: EagerLoadProvider,
          EagerLoading.Model == Model {

    let relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel>
    let relationNamePath: String?
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>
}

//MARK:- DeleteAuthChildrenRelationController

struct DeleteAuthChildrenRelationController<Model, RelatedModel, Output, EagerLoading>:
    DeletableRelationController, AuthChildrenResourceRelationProvider
    where
        Output: ResourceOutputModel,
        Model == Output.Model,
        Model.IDValue: LosslessStringConvertible,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        RelatedModel: Authenticatable,
        EagerLoading: EagerLoadProvider,
        EagerLoading.Model == Model {

    let relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel>
    let relationNamePath: String?
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>

}

