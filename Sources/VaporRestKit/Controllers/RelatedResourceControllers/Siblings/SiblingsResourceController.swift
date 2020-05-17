//
//  
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- CreateRelatedResourceController

struct CreateRelatedResourceController<Model, RelatedModel, Through, Output, Input, EagerLoading>: CreatableResourceController, SiblingsResourceModelProvider

    where
    Output: ResourceOutputModel,
    Input: ResourceUpdateModel,
    Model == Input.Model,
    Model == Output.Model,
    RelatedModel: Fluent.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    Through: Fluent.Model {

    let relatedResourceMiddleware: RelationMiddleware<Model, RelatedModel>
    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>
}


//MARK:- ReadRelatedResourceController

struct ReadRelatedResourceController<Model, RelatedModel, Through, Output, EagerLoading>: ReadableResourceController, SiblingsResourceModelProvider

    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    RelatedModel: Fluent.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    Through: Fluent.Model {

    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>

}

//MARK:- UpdateRelatedResourceController

struct UpdateRelatedResourceController<Model, RelatedModel, Through, Output, Input, EagerLoading>: UpdateableResourceController, SiblingsResourceModelProvider

    where
    Output: ResourceOutputModel,
    Input: ResourceUpdateModel,
    Model == Input.Model,
    Model == Output.Model,
    RelatedModel: Fluent.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    Through: Fluent.Model {

    let relatedResourceMiddleware: RelationMiddleware<Model, RelatedModel>
    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>

}

//MARK:- PatchRelatedResourceController

struct PatchRelatedResourceController<Model, RelatedModel, Through, Output, Patch, EagerLoading>:
    PatchableResourceController, SiblingsResourceModelProvider

    where
    Output: ResourceOutputModel,
    Patch: ResourcePatchModel,
    Model == Output.Model,
    Model == Patch.Model,
    RelatedModel: Fluent.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    Through: Fluent.Model {

    let relatedResourceMiddleware: RelationMiddleware<Model, RelatedModel>
    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>

}

//MARK:- DeleteRelatedResourceController

struct DeleteRelatedResourceController<Model, RelatedModel, Through, Output, EagerLoading>:
    DeletableResourceController, SiblingsResourceModelProvider
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    Through: Fluent.Model {

    let relatedResourceMiddleware: RelationMiddleware<Model, RelatedModel>
    let deleteHandler: Bool
    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>

}

//MARK:- CollectionRelatedResourceController

struct CollectionRelatedResourceController<Model, RelatedModel, Through, Output, Sorting, EagerLoading, Filtering>: IterableResourceController, SiblingsResourceModelProvider
    
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    Sorting: SortProvider,
    Sorting.Model == Model,
    Filtering: FilterProvider,
    Filtering.Model == Model,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    Through: Fluent.Model {

    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>
    let config: IterableControllerConfig

}
