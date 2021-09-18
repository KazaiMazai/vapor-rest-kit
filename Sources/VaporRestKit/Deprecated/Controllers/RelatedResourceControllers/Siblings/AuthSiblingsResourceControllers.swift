//
//  File 3.swift
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- CreateRelatedResourceController

struct CreateRelatedAuthResourceController<Model, RelatedModel, Through, Output, Input, EagerLoading>: CreatableResourceController, AuthSiblingsResourceModelProvider

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
    RelatedModel: Authenticatable,
    Through: Fluent.Model {

    let relatedResourceMiddleware: ControllerMiddleware<Model, RelatedModel>
    let relationNamePath: String?
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>
    let bodyStreamingStrategy: HTTPBodyStreamStrategy
}


//MARK:- ReadRelatedResourceController

struct ReadRelatedAuthResourceController<Model, RelatedModel, Through, Output, EagerLoading>: ReadableResourceController, AuthSiblingsResourceModelProvider

    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    RelatedModel: Fluent.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    RelatedModel: Authenticatable,
    Through: Fluent.Model {

    let relationNamePath: String?
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>

}

//MARK:- UpdateRelatedResourceController

struct UpdateRelatedAuthResourceController<Model, RelatedModel, Through, Output, Input, EagerLoading>: UpdateableResourceController, AuthSiblingsResourceModelProvider

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
    RelatedModel: Authenticatable,
    Through: Fluent.Model {

    let relatedResourceMiddleware: ControllerMiddleware<Model, RelatedModel>
    let relationNamePath: String?
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>
    let bodyStreamingStrategy: HTTPBodyStreamStrategy

}

//MARK:- PatchRelatedResourceController

struct PatchRelatedAuthResourceController<Model, RelatedModel, Through, Output, Patch, EagerLoading>:
    PatchableResourceController, AuthSiblingsResourceModelProvider

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
    RelatedModel: Authenticatable,
    Through: Fluent.Model {

    let relatedResourceMiddleware: ControllerMiddleware<Model, RelatedModel>
    let relationNamePath: String?
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>
    let bodyStreamingStrategy: HTTPBodyStreamStrategy
}

//MARK:- DeleteRelatedResourceController

struct DeleteRelatedAuthResourceController<Model, RelatedModel, Through, Output, EagerLoading>:
    DeletableResourceController, AuthSiblingsResourceModelProvider

    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    RelatedModel: Authenticatable,
    Through: Fluent.Model {


    let relatedResourceMiddleware: ControllerMiddleware<Model, RelatedModel>
    let deleter: Deleter<Model>
    let relationNamePath: String?
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>

}

//MARK:- CollectionRelatedResourceController

struct CollectionRelatedAuthResourceController<Model, RelatedModel, Through, Output, Sorting, EagerLoading, Filtering>: IterableResourceController, AuthSiblingsResourceModelProvider

    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    Sorting: SortProvider,
    Sorting.Model == Model,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    Filtering: FilterProvider,
    Filtering.Model == Model,
    RelatedModel: Authenticatable,
    Through: Fluent.Model {

    let relationNamePath: String?
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>
    let config: IterableControllerConfig

}

