//
//  
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- CreateAuthChildrenResourceController

struct CreateAuthChildrenResourceController<Model, RelatedModel, Output, Input, EagerLoading>: CreatableResourceController, AuthChildrenResourceModelProvider

    where
    Output: ResourceOutputModel,
    Input: ResourceUpdateModel,
    Model == Input.Model,
    Model == Output.Model,
    RelatedModel: Fluent.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel.IDValue: LosslessStringConvertible,
    RelatedModel: Authenticatable,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

    let relatedResourceMiddleware: RelationMiddleware<Model, RelatedModel>
    let relationNamePath: String
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>
}


//MARK:- ReadAuthChildrenResourceController

struct ReadAuthChildrenResourceController<Model, RelatedModel, Output, EagerLoading>: ReadableResourceController, AuthChildrenResourceModelProvider

    where
    Output: ResourceOutputModel,
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

//MARK:- UpdateAuthChildrenResourceController

struct UpdateAuthChildrenResourceController<Model, RelatedModel, Output, Input, EagerLoading>: UpdateableResourceController, AuthChildrenResourceModelProvider

    where
    Output: ResourceOutputModel,
    Input: ResourceUpdateModel,
    Model == Input.Model,
    Model == Output.Model,
    RelatedModel: Fluent.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel.IDValue: LosslessStringConvertible,
    RelatedModel: Authenticatable,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

    let relatedResourceMiddleware: RelationMiddleware<Model, RelatedModel>
    let relationNamePath: String
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>

}

//MARK:- PatchAuthChildrenResourceController

struct PatchAuthChildrenResourceController<Model, RelatedModel, Output, Patch, EagerLoading>:
    PatchableResourceController, AuthChildrenResourceModelProvider

    where
    Output: ResourceOutputModel,
    Patch: ResourcePatchModel,
    Model == Output.Model,
    Model == Patch.Model,
    RelatedModel: Fluent.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel.IDValue: LosslessStringConvertible,
    RelatedModel: Authenticatable,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

    let relatedResourceMiddleware: RelationMiddleware<Model, RelatedModel>
    let relationNamePath: String
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>

}

//MARK:- DeleteAuthChildrenResourceController

struct DeleteAuthChildrenResourceController<Model, RelatedModel, Output, EagerLoading>:
    DeletableResourceController, AuthChildrenResourceModelProvider

    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    RelatedModel: Authenticatable,
    EagerLoading: EagerLoadProvider,
EagerLoading.Model == Model {


    var relatedResourceMiddleware: RelationMiddleware<Model, RelatedModel>
    let useForcedDelete: Bool
    let relationNamePath: String
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>

}

//MARK:- CollectionAuthChildResourceController

struct CollectionAuthChildResourceController<Model, RelatedModel, Output, Sorting, EagerLoading, Filtering>: IterableResourceController, AuthChildrenResourceModelProvider

    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    RelatedModel: Authenticatable,
    Sorting: SortProvider,
    Sorting.Model == Model,
    Filtering: FilterProvider,
    Filtering.Model == Model,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

    let relationNamePath: String
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>
    let config: IterableControllerConfig

}
