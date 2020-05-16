//
//  
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- CreateRelatedResourceController

struct CreateSiblingRelationController<Model, RelatedModel, Through, Output, EagerLoading>: CreatableRelationController, SiblingsResourceRelationProvider

    where
    Output: ResourceOutputModel,
 
    Model == Output.Model,
    RelatedModel: Fluent.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    Through: Fluent.Model {

    let middleware: RelationMiddleware<Model, RelatedModel>
    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>
}

//MARK:- DeleteRelatedResourceController

struct DeleteSiblingRelationController<Model, RelatedModel, Through, Output, EagerLoading>:
    DeletableRelationController, SiblingsResourceRelationProvider
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    Through: Fluent.Model {


    let middleware: RelationMiddleware<Model, RelatedModel>
    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>

}
