//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- ReplaceChildrenResourceController

open struct CreateChildrenResourceController<Model, RelatedModel, Output, Input, EagerLoading>: CreatableResourceController, ChildrenResourceModelProviding

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


//MARK:- ReadChildrenResourceController

open struct ReadChildrenResourceController<Model, RelatedModel, Output, EagerLoading>: ReadableResourceController, ChildrenResourceModelProviding

    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    RelatedModel: Fluent.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

    let relationNamePath: String
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>

}

//MARK:- UpdateChildrenResourceController

open struct UpdateChildrenResourceController<Model, RelatedModel, Output, Input, EagerLoading>: UpdateableResourceController, ChildrenResourceModelProviding

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

    let relationNamePath: String
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>

}

//MARK:- PatchChildrenResourceController

open struct PatchChildrenResourceController<Model, RelatedModel, Output, Patch, EagerLoading>:
    PatchableResourceController, ChildrenResourceModelProviding

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


    let relationNamePath: String
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>

}

//MARK:- DeleteChildrenResourceController

open struct DeleteChildrenResourceController<Model, RelatedModel, Output, EagerLoading>:
    DeletableResourceController, ChildrenResourceModelProviding
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

//MARK:- CollectionChildResourceController

open struct CollectionChildResourceController<Model, RelatedModel, Output, Sorting, EagerLoading, Filtering>: IterableResourceController, ChildrenResourceModelProviding
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

    let relationNamePath: String
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>

}
