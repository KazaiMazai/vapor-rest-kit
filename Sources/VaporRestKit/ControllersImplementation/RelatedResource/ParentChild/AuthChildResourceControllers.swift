//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- CreateAuthChildrenResourceController

open struct CreateAuthChildrenResourceController<Model, RelatedModel, Output, Input, EagerLoading>: CreatableResourceController, AuthChildrenResourceModelProviding

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

    let relationNamePath: String
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>
}


//MARK:- ReadAuthChildrenResourceController

open struct ReadAuthChildrenResourceController<Model, RelatedModel, Output, EagerLoading>: ReadableResourceController, AuthChildrenResourceModelProviding

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

open struct UpdateAuthChildrenResourceController<Model, RelatedModel, Output, Input, EagerLoading>: UpdateableResourceController, AuthChildrenResourceModelProviding

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

    let relationNamePath: String
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>

}

//MARK:- PatchAuthChildrenResourceController

open struct PatchAuthChildrenResourceController<Model, RelatedModel, Output, Patch, EagerLoading>:
    PatchableResourceController, AuthChildrenResourceModelProviding

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

    let relationNamePath: String
    let childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>

}

//MARK:- DeleteAuthChildrenResourceController

open struct DeleteAuthChildrenResourceController<Model, RelatedModel, Output, EagerLoading>:
    DeletableResourceController, AuthChildrenResourceModelProviding

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

//MARK:- CollectionAuthChildResourceController

open struct CollectionAuthChildResourceController<Model, RelatedModel, Output, Sorting, EagerLoading, Filtering>: IterableResourceController, AuthChildrenResourceModelProviding

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

}
