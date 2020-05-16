//
//  
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

//MARK:- CreateResourceController

struct CreateResourceController<Model, Output, Input, EagerLoading>: CreatableResourceController, ResourceModelProvider
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

struct ReadResourceController<Model, Output, EagerLoading>: ReadableResourceController, ResourceModelProvider
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

}

//MARK:- CreateResourceController

struct UpdateResourceController<Model, Output, Input, EagerLoading>: UpdateableResourceController, ResourceModelProvider
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

struct PatchResourceController<Model, Output, Patch, EagerLoading>: PatchableResourceController, ResourceModelProvider

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

struct DeleteResourceController<Model, Output, DeleteHandler, EagerLoading>: DeletableResourceController, ResourceModelProvider

    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    DeleteHandler: ResourceDeleteHandler,
    Model == DeleteHandler.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

    let deleteHandler: DeleteHandler
}

//MARK:- CollectionResourceController

struct CollectionResourceController<Model, Output, Sorting, EagerLoading, Filtering>: IterableResourceController, ResourceModelProvider

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

    let config: IterableControllerConfig
    
}
