//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 23.05.2020.
//

import Vapor
import Fluent

public extension SiblingsResourceControllerBuilder {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        resourceControllerBuilder.addMethodsTo(routeBuilder, on: endpoint)
        CompoundResourceController(with: controllers).addMethodsTo(routeBuilder, on: endpoint)
    }
}

public extension SiblingsResourceControllerBuilder {
    var relation: SiblingsRelationControllerBuilder<Model, RelatedModel, Through, Output, EagerLoading> {
        return SiblingsRelationControllerBuilder<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(resourceControllerBuilder: self)
    }
}

public extension SiblingsResourceControllerBuilder {
    func create<Input>(using: Input.Type,
                       middleware: RelatedResourceMiddleware<Model, RelatedModel> = .defaultMiddleware,
                       bodyStreamingStrategy: HTTPBodyStreamStrategy = .collect) -> SiblingsResourceControllerBuilder
        where
        Input: ResourceUpdateModel,
        Model == Input.Model {

            return adding(CreateRelatedResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Input,
                EagerLoading>(relatedResourceMiddleware: middleware,
                              relationNamePath: relationName,
                              siblingKeyPath: relationKeyPath,
                              bodyStreamingStrategy: bodyStreamingStrategy))
    }

    func read() -> SiblingsResourceControllerBuilder {

        return adding(ReadRelatedResourceController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relationNamePath: relationName,
                          siblingKeyPath: relationKeyPath))
    }


    func update<Input>(using: Input.Type,
                       middleware: RelatedResourceMiddleware<Model, RelatedModel> = .defaultMiddleware,
                       bodyStreamingStrategy: HTTPBodyStreamStrategy = .collect) -> SiblingsResourceControllerBuilder
        where
        Input: ResourceUpdateModel,
        Model == Input.Model {

            return adding(UpdateRelatedResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Input,
                EagerLoading>(relatedResourceMiddleware: middleware,
                              relationNamePath: relationName,
                              siblingKeyPath: relationKeyPath,
                              bodyStreamingStrategy: bodyStreamingStrategy))
    }

    func patch<Input>(using: Input.Type,
                      middleware: RelatedResourceMiddleware<Model, RelatedModel> = .defaultMiddleware,
                      bodyStreamingStrategy: HTTPBodyStreamStrategy = .collect) -> SiblingsResourceControllerBuilder
        where
        Input: ResourcePatchModel,
        Model == Input.Model {

            return adding(PatchRelatedResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Input,
                EagerLoading>(relatedResourceMiddleware: middleware,
                              relationNamePath: relationName,
                              siblingKeyPath: relationKeyPath,
                              bodyStreamingStrategy: bodyStreamingStrategy))
    }

    func delete(with handler: DeleteHandler<Model> = .defaultDeleter,
                middleware: RelatedResourceMiddleware<Model, RelatedModel> = .defaultMiddleware) -> SiblingsResourceControllerBuilder {

        return adding(DeleteRelatedResourceController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relatedResourceMiddleware: middleware,
                          deleter: handler, relationNamePath: relationName,
                          siblingKeyPath: relationKeyPath))
    }

    func collection<Sorting, Filtering>(sorting: Sorting.Type, filtering: Filtering.Type, config: IterableControllerConfig = .defaultConfig) -> SiblingsResourceControllerBuilder
        where
        Sorting: SortProvider,
        Sorting.Model == Model,
        Filtering: FilterProvider,
        Filtering.Model == Model {

            return adding(CollectionRelatedResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Sorting,
                EagerLoading,
                Filtering>(relationNamePath: relationName,
                           siblingKeyPath: relationKeyPath, config: config))
    }
}

public extension SiblingsResourceControllerBuilder where RelatedModel: Authenticatable {
    func create<Input>(using: Input.Type,
                       middleware: RelatedResourceMiddleware<Model, RelatedModel> = .defaultMiddleware,
                       authenticatable: RelatedModel.Type,
                       bodyStreamingStrategy: HTTPBodyStreamStrategy = .collect) -> SiblingsResourceControllerBuilder
        where
        Input: ResourceUpdateModel,
        Model == Input.Model {

            return adding(CreateRelatedAuthResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Input,
                EagerLoading>(relatedResourceMiddleware: middleware,
                              relationNamePath: relationName,
                              siblingKeyPath: relationKeyPath,
                              bodyStreamingStrategy: bodyStreamingStrategy))
    }

    func read(authenticatable: RelatedModel.Type) -> SiblingsResourceControllerBuilder {
        return adding(ReadRelatedAuthResourceController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relationNamePath: relationName,
                          siblingKeyPath: relationKeyPath))
    }

    func update<Input>(using: Input.Type,
                       middleware: RelatedResourceMiddleware<Model, RelatedModel> = .defaultMiddleware,
                       authenticatable: RelatedModel.Type,
                       bodyStreamingStrategy: HTTPBodyStreamStrategy = .collect) -> SiblingsResourceControllerBuilder
        where
        Input: ResourceUpdateModel,
        Model == Input.Model {

            return adding(UpdateRelatedAuthResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Input,
                EagerLoading>(relatedResourceMiddleware: middleware,
                              relationNamePath: relationName,
                              siblingKeyPath: relationKeyPath,
                              bodyStreamingStrategy: bodyStreamingStrategy))
    }

    func patch<Input>(using: Input.Type,
                      middleware: RelatedResourceMiddleware<Model, RelatedModel> = .defaultMiddleware,
                      authenticatable: RelatedModel.Type,
                      bodyStreamingStrategy: HTTPBodyStreamStrategy = .collect) -> SiblingsResourceControllerBuilder
        where
        Input: ResourcePatchModel,
        Model == Input.Model {

            return adding(PatchRelatedAuthResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Input,
                EagerLoading>(relatedResourceMiddleware: middleware,
                              relationNamePath: relationName,
                              siblingKeyPath: relationKeyPath,
                              bodyStreamingStrategy: bodyStreamingStrategy))
    }

    func delete(with handler: DeleteHandler<Model> = .defaultDeleter,
                middleware: RelatedResourceMiddleware<Model, RelatedModel> = .defaultMiddleware,
                authenticatable: RelatedModel.Type) -> SiblingsResourceControllerBuilder {

        return adding(DeleteRelatedAuthResourceController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relatedResourceMiddleware: middleware,
                          deleter: handler,
                          relationNamePath: relationName,
                          siblingKeyPath: relationKeyPath))
    }

    func collection<Sorting, Filtering>(sorting: Sorting.Type,
                                        filtering: Filtering.Type,
                                        config: IterableControllerConfig = .defaultConfig,
                                        authenticatable: RelatedModel.Type) -> SiblingsResourceControllerBuilder
        where
        Sorting: SortProvider,
        Sorting.Model == Model,
        Filtering: FilterProvider,
        Filtering.Model == Model {

            return adding(CollectionRelatedAuthResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Sorting,
                EagerLoading,
                Filtering>(relationNamePath: relationName,
                           siblingKeyPath: relationKeyPath,
                           config: config))
    }
}
