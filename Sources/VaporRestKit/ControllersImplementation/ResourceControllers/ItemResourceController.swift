//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- CreateResourceController

open struct CreateResourceController<Model, Output, Input, EagerLoading>: CreatableResourceController, ResourceModelProviding
    where
    Output: ResourceOutputModel,
    Input: ResourceUpdateModel,
    Model == Input.Model,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model  {

}

//MARK:- ReadResourceController

open struct ReadResourceController<Model, Output, EagerLoading>: ReadableResourceController, ResourceModelProviding
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

}

//MARK:- CreateResourceController

open struct UpdateResourceController<Model, Output, Input, EagerLoading>: UpdateableResourceController, ResourceModelProviding
    where
    Output: ResourceOutputModel,
    Input: ResourceUpdateModel,
    Model == Input.Model,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

}

//MARK:- PatchResourceController

open struct PatchResourceController<Model, Output, Patch, EagerLoading>: PatchableResourceController, ResourceModelProviding

    where
    Output: ResourceOutputModel,
    Patch: ResourcePatchModel,
    Model == Output.Model,
    Model == Patch.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

}

//MARK:- DeleteResourceController

open struct DeleteResourceController<Model, Output, EagerLoading>: DeletableResourceController, ResourceModelProviding

    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

}

//MARK:- CollectionResourceController

open struct CollectionResourceController<Model, Output, Sorting, EagerLoading, Filtering>: IterableResourceController, ResourceModelProviding

    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    Sorting: SortProvider,
    Sorting.Model == Model,
    Filtering: FilterProvider,
    Filtering.Model == Model,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model  {

}
