//
//  
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- CreateParentResourceController

struct CreateParentResourceController<Model, RelatedModel, Output, Input, EagerLoading>: CreatableResourceController, ParentResourceModelProvider

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

    let relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel>
    let relationNamePath: String?
    let inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel>

}

//MARK:- CreateParentResourceController

struct ReadParentResourceController<Model, RelatedModel, Output, EagerLoading>: ReadableResourceController, ParentResourceModelProvider

    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

    let relationNamePath: String?
    let inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel>

}

//MARK:- UpdateParentResourceController

struct UpdateParentResourceController<Model, RelatedModel, Output, Input, EagerLoading>: UpdateableResourceController, ParentResourceModelProvider

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

    let relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel>
    let relationNamePath: String?
    let inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel>

}

//MARK:- PatchParentResourceController

struct PatchParentResourceController<Model, RelatedModel, Output, Patch, EagerLoading>: PatchableResourceController, ParentResourceModelProvider

    where
    Output: ResourceOutputModel,
    Patch: ResourcePatchModel,
    Model == Patch.Model,
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

//MARK:- CreateParentResourceController

struct DeleteParentResourceController<Model, RelatedModel, Output, EagerLoading>: DeletableResourceController, ParentResourceModelProvider

    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {


    let relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel>
    let deleter: DeleteHandler<Model>
    let relationNamePath: String?
    let inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel>

}

//MARK:- CollectionParentResourceController

struct CollectionParentResourceController<Model, RelatedModel, Output, Sorting, EagerLoading, Filtering>: IterableResourceController, ParentResourceModelProvider

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
    EagerLoading.Model == Model {

    let relationNamePath: String?
    let inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel>
    let config: IterableControllerConfig

}
