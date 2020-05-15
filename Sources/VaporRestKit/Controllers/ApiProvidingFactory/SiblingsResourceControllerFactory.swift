//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

struct SiblingsResourceControllerFactory<Model, RelatedModel, Through, Output, EagerLoading>
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    Through: Fluent.Model {

    let resourceFactory: ResourceControllerFactory<Model, Output, EagerLoading>
    let relation: SiblingKeyPath<RelatedModel, Model, Through>
    let relationName: String

    init(_ resourceFactory: ResourceControllerFactory<Model, Output, EagerLoading>,
         relation: SiblingKeyPath<RelatedModel, Model, Through>,
         relationName: String) {

        self.resourceFactory = resourceFactory
        self.relation = relation
        self.relationName = relationName
    }

    func relationController() -> SiblingsRelationControllerFactory<Model, RelatedModel, Through, Output, EagerLoading> {
        return  SiblingsRelationControllerFactory<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(resourceFactory: self)
    }
}

extension SiblingsResourceControllerFactory {
    func create<Input>(input: Input.Type) -> APIMethodsProviding
        where
        Input: ResourceUpdateModel,
        Model == Input.Model {

            return CreateRelatedResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Input,
                EagerLoading>(relationNamePath: relationName,
                              siblingKeyPath: relation)
    }

    func update<Input>(input: Input.Type) -> APIMethodsProviding
        where
        Input: ResourceUpdateModel,
        Model == Input.Model {

            return UpdateRelatedResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Input,
                EagerLoading>(relationNamePath: relationName,
                              siblingKeyPath: relation)
    }

    func patch<Input>(input: Input.Type) -> APIMethodsProviding
        where
        Input: ResourcePatchModel,
        Model == Input.Model {

            return PatchRelatedResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Input,
                EagerLoading>(relationNamePath: relationName,
                              siblingKeyPath: relation)
    }

    func delete() -> APIMethodsProviding {
        return DeleteRelatedResourceController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relationNamePath: relationName,
                          siblingKeyPath: relation)
    }

    func collection<Sorting, Filtering>(sorting: Sorting.Type, filtering: Filtering.Type, config: IterableControllerConfig = .defaultConfig) -> APIMethodsProviding
        where
        Sorting: SortProvider,
        Sorting.Model == Model,
        Filtering: FilterProvider,
        Filtering.Model == Model {

            return CollectionRelatedResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Sorting,
                EagerLoading,
                Filtering>(relationNamePath: relationName,
                           siblingKeyPath: relation, config: config)
    }
}


extension SiblingsResourceControllerFactory where RelatedModel: Authenticatable {
    func create<Input>(input: Input.Type, authenticatable: RelatedModel.Type) -> APIMethodsProviding
        where
        Input: ResourceUpdateModel,
        Model == Input.Model {

            return CreateRelatedAuthResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Input,
                EagerLoading>(relationNamePath: relationName,
                              siblingKeyPath: relation)
    }

    func update<Input>(input: Input.Type,
                       authenticatable: RelatedModel.Type) -> APIMethodsProviding
        where
        Input: ResourceUpdateModel,
        Model == Input.Model {

            return UpdateRelatedAuthResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Input,
                EagerLoading>(relationNamePath: relationName,
                              siblingKeyPath: relation)
    }

    func patch<Input>(input: Input.Type,
                      authenticatable: RelatedModel.Type) -> APIMethodsProviding
        where
        Input: ResourcePatchModel,
        Model == Input.Model {

            return PatchRelatedAuthResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Input,
                EagerLoading>(relationNamePath: relationName,
                              siblingKeyPath: relation)
    }

    func delete(authenticatable: RelatedModel.Type) -> APIMethodsProviding {
        return DeleteRelatedAuthResourceController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relationNamePath: relationName,
                          siblingKeyPath: relation)
    }

    func collection<Sorting, Filtering>(authenticatable: RelatedModel.Type,
                                        sorting: Sorting.Type,
                                        filtering: Filtering.Type,
                                        config: IterableControllerConfig = .defaultConfig) -> APIMethodsProviding
        where
        Sorting: SortProvider,
        Sorting.Model == Model,
        Filtering: FilterProvider,
        Filtering.Model == Model {

            return CollectionRelatedResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Sorting,
                EagerLoading,
                Filtering>(relationNamePath: relationName,
                           siblingKeyPath: relation,
                           config: config)
    }
}
