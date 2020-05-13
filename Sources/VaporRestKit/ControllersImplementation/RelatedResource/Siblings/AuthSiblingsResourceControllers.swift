//
//  File 3.swift
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- CreateRelatedResourceController

open struct CreateRelatedAuthResourceController<Model, RelatedModel, Through, Output, Input, EagerLoading>: CreatableResourceController, AuthSiblingsResourceModelProviding

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

    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>
}


//MARK:- ReadRelatedResourceController

open struct ReadRelatedAuthResourceController<Model, RelatedModel, Through, Output, EagerLoading>: ReadableResourceController, AuthSiblingsResourceModelProviding

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

    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>

}

//MARK:- UpdateRelatedResourceController

open struct UpdateRelatedAuthResourceController<Model, RelatedModel, Through, Output, Input, EagerLoading>: UpdateableResourceController, AuthSiblingsResourceModelProviding

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

    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>

}

//MARK:- PatchRelatedResourceController

open struct PatchRelatedAuthResourceController<Model, RelatedModel, Through, Output, Patch, EagerLoading>:
    PatchableResourceController, AuthSiblingsResourceModelProviding

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

    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>

}

//MARK:- DeleteRelatedResourceController

open struct DeleteRelatedAuthResourceController<Model, RelatedModel, Through, Output, EagerLoading>:
    DeletableResourceController, AuthSiblingsResourceModelProviding
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

    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>

}

//MARK:- CollectionRelatedResourceController

open struct CollectionRelatedAuthResourceController<Model, RelatedModel, Through, Output, Sorting, EagerLoading, Filtering>: IterableResourceController, AuthSiblingsResourceModelProviding
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

    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>

}

