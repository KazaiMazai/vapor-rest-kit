//
//  
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- CreateParentResourceController

struct CreateParentRelationController<Model, RelatedModel, Output, EagerLoading>: CreatableRelationController, ParentResourceRelationProvider
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
EagerLoading.Model == Model {

    let relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel>
    let relationNamePath: String?
    let inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel>

}


//MARK:- DeleteParentRelationController

struct DeleteParentRelationController<Model, RelatedModel, Output, EagerLoading>: DeletableRelationController, ParentResourceRelationProvider
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {


    let relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel>
    let relationNamePath: String?
    let inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel>

}
