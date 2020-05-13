//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- CreateRelatedResourceController

open struct CreateRelatedResourceController<Model, RelatedModel, Through, Output, Input, EagerLoading>: CreatableResourceController, SiblingsResourceModelProviding

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

    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>
}


//MARK:- ReadRelatedResourceController

open struct ReadRelatedResourceController<Model, RelatedModel, Through, Output, EagerLoading>: ReadableResourceController, SiblingsResourceModelProviding

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

open struct UpdateRelatedResourceController<Model, RelatedModel, Through, Output, Input, EagerLoading>: UpdateableResourceController, SiblingsResourceModelProviding

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

    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>

}

//MARK:- PatchRelatedResourceController

open struct PatchRelatedResourceController<Model, RelatedModel, Through, Output, Patch, EagerLoading>:
    PatchableResourceController, SiblingsResourceModelProviding

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

    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>

}

//MARK:- DeleteRelatedResourceController

open struct DeleteRelatedResourceController<Model, RelatedModel, Through, Output, EagerLoading>:
    DeletableResourceController, SiblingsResourceModelProviding
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    Through: Fluent.Model {

    let relationNamePath: String
    let siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>

}

//MARK:- CollectionRelatedResourceController

open struct CollectionRelatedResourceController<Model, RelatedModel, Through, Output, Sorting, EagerLoading, Filtering>: IterableResourceController, SiblingsResourceModelProviding
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

}
