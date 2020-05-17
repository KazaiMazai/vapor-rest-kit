//
//  
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- ReplaceChildrenResourceController

struct CreateChildrenResourceController<Model, RelatedModel, Output, Input, EagerLoading>: CreatableResourceController, ChildrenResourceModelProvider

    where Output: ResourceOutputModel,
          Input: ResourceUpdateModel,
          Model == Input.Model,
          Model == Output.Model,
          RelatedModel: Fluent.Model,
          Model.IDValue: LosslessStringConvertible,
          RelatedModel.IDValue: LosslessStringConvertible,
          EagerLoading: EagerLoadProvider,
          EagerLoading.Model == Model {

    let relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel>
    let relationNamePath: String?
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>
}


//MARK:- ReadChildrenResourceController

struct ReadChildrenResourceController<Model, RelatedModel, Output, EagerLoading>: ReadableResourceController, ChildrenResourceModelProvider

    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    RelatedModel: Fluent.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

    let relationNamePath: String?
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>

}

//MARK:- UpdateChildrenResourceController

struct UpdateChildrenResourceController<Model, RelatedModel, Output, Input, EagerLoading>: UpdateableResourceController, ChildrenResourceModelProvider

    where
    Output: ResourceOutputModel,
    Input: ResourceUpdateModel,
    Model == Input.Model,
    Model == Output.Model,
    RelatedModel: Fluent.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

    let relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel>
    let relationNamePath: String?
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>

}

//MARK:- PatchChildrenResourceController

struct PatchChildrenResourceController<Model, RelatedModel, Output, Patch, EagerLoading>:
    PatchableResourceController, ChildrenResourceModelProvider

    where
        Output: ResourceOutputModel,
        Patch: ResourcePatchModel,
        Model == Output.Model,
        Model == Patch.Model,
        RelatedModel: Fluent.Model,
        Model.IDValue: LosslessStringConvertible,
        RelatedModel.IDValue: LosslessStringConvertible,
        EagerLoading: EagerLoadProvider,
        EagerLoading.Model == Model {


    let relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel>
    let relationNamePath: String?
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>

}

//MARK:- DeleteChildrenResourceController

struct DeleteChildrenResourceController<Model, RelatedModel, Output, EagerLoading>:
    DeletableResourceController, ChildrenResourceModelProvider
    where
        Output: ResourceOutputModel,
        Model == Output.Model,
        Model.IDValue: LosslessStringConvertible,
        RelatedModel: Fluent.Model,
        RelatedModel.IDValue: LosslessStringConvertible,
        EagerLoading: EagerLoadProvider,
EagerLoading.Model == Model {


    let relatedResourceMiddleware: RelatedResourceControllerMiddleware<Model, RelatedModel>
    let useForcedDelete: Bool
    let relationNamePath: String?
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>

}

//MARK:- CollectionChildResourceController

struct CollectionChildResourceController<Model, RelatedModel, Output, Sorting, EagerLoading, Filtering>: IterableResourceController, ChildrenResourceModelProvider
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
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>
    let config: IterableControllerConfig

}
