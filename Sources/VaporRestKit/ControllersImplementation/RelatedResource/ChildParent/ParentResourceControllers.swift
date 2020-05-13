//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- CreateParentResourceController

open struct CreateParentResourceController<Model, RelatedModel, Output, Input, EagerLoading>: CreatableResourceController, ParentResourceModelProviding
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

    let relationNamePath: String
    let inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel>

}

//MARK:- CreateParentResourceController

struct ReadParentResourceController<Model, RelatedModel, Output, EagerLoading>: ReadableResourceController, ParentResourceModelProviding
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

    let relationNamePath: String
    let inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel>

}

//MARK:- UpdateParentResourceController

struct UpdateParentResourceController<Model, RelatedModel, Output, Input, EagerLoading>: UpdateableResourceController, ParentResourceModelProviding
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

    let relationNamePath: String
    let inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel>

}

//MARK:- PatchParentResourceController

struct PatchParentResourceController<Model, RelatedModel, Output, Patch, EagerLoading>: PatchableResourceController, ParentResourceModelProviding
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

    let relationNamePath: String
    let inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel>

}

//MARK:- CreateParentResourceController

struct DeleteParentResourceController<Model, RelatedModel, Output, EagerLoading>: DeletableResourceController, ParentResourceModelProviding
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

    let relationNamePath: String
    let inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel>

}

//MARK:- CollectionParentResourceController

struct CollectionParentResourceController<Model, RelatedModel, Output, Sorting, EagerLoading, Filtering>: IterableResourceController, ParentResourceModelProviding
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
    let inversedChildrenKeyPath: ChildrenKeyPath<Model, RelatedModel>

}
