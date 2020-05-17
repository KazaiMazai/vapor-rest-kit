//
//  
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

public final class SiblingsResourceControllerBuilder<Model, RelatedModel, Through, Output, EagerLoading>: APIMethodsProviding
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
Through: Fluent.Model {

    internal let resourceControllerBuilder: ResourceControllerBuilder<Model, Output, EagerLoading>
    internal let relationKeyPath: SiblingKeyPath<RelatedModel, Model, Through>
    internal let relationName: String

    internal init(_ resourControllerBuilder: ResourceControllerBuilder<Model, Output, EagerLoading>,
                  relation: SiblingKeyPath<RelatedModel, Model, Through>,
                  relationName: String) {

        self.resourceControllerBuilder = resourControllerBuilder
        self.relationKeyPath = relation
        self.relationName = relationName
    }

    fileprivate var controllers: [APIMethodsProviding] = []

    fileprivate func adding(_ controller: APIMethodsProviding) -> SiblingsResourceControllerBuilder  {
        controllers.append(controller)
        return self
    }
}

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
    func create<Input>(input: Input.Type,
                       middleware: RelationMiddleware<Model, RelatedModel> = .defaultMiddleware) -> SiblingsResourceControllerBuilder
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
                              siblingKeyPath: relationKeyPath))
    }

    func read() -> SiblingsResourceControllerBuilder {

        return adding(ReadRelatedResourceController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relationNamePath: relationName,
                          siblingKeyPath: relationKeyPath))
    }


    func update<Input>(input: Input.Type,
                       middleware: RelationMiddleware<Model, RelatedModel> = .defaultMiddleware) -> SiblingsResourceControllerBuilder
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
                              siblingKeyPath: relationKeyPath))
    }

    func patch<Input>(input: Input.Type,
                      middleware: RelationMiddleware<Model, RelatedModel> = .defaultMiddleware) -> SiblingsResourceControllerBuilder
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
                              siblingKeyPath: relationKeyPath))
    }

    func delete(with handler: Deleter<Model> = .defaultDeleter,
                middleware: RelationMiddleware<Model, RelatedModel> = .defaultMiddleware) -> SiblingsResourceControllerBuilder {

            return adding(DeleteRelatedResourceController<Model,
            RelatedModel,
            Through,
            Output,
                EagerLoading>(relatedResourceMiddleware: middleware,
                              deleteHandler: handler, relationNamePath: relationName,
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
    func create<Input>(input: Input.Type,
                       middleware: RelationMiddleware<Model, RelatedModel> = .defaultMiddleware,
                       authenticatable: RelatedModel.Type) -> SiblingsResourceControllerBuilder
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
                              siblingKeyPath: relationKeyPath))
    }

    func read(authenticatable: RelatedModel.Type) -> SiblingsResourceControllerBuilder {
        return adding(ReadRelatedAuthResourceController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relationNamePath: relationName,
                          siblingKeyPath: relationKeyPath))
    }

    func update<Input>(input: Input.Type,
                       middleware: RelationMiddleware<Model, RelatedModel> = .defaultMiddleware,
                       authenticatable: RelatedModel.Type) -> SiblingsResourceControllerBuilder
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
                              siblingKeyPath: relationKeyPath))
    }

    func patch<Input>(input: Input.Type,
                      middleware: RelationMiddleware<Model, RelatedModel> = .defaultMiddleware,
                      authenticatable: RelatedModel.Type) -> SiblingsResourceControllerBuilder
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
                              siblingKeyPath: relationKeyPath))
    }

    func delete(with handler: Deleter<Model> = .defaultDeleter,
                middleware: RelationMiddleware<Model, RelatedModel> = .defaultMiddleware,
                authenticatable: RelatedModel.Type) -> SiblingsResourceControllerBuilder {

        return adding(DeleteRelatedAuthResourceController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relatedResourceMiddleware: middleware,
                          deleteHandler: handler,
                          relationNamePath: relationName,
                          siblingKeyPath: relationKeyPath))
    }

    func collection<Sorting, Filtering>(authenticatable: RelatedModel.Type,
                                        sorting: Sorting.Type,
                                        filtering: Filtering.Type,
                                        config: IterableControllerConfig = .defaultConfig) -> SiblingsResourceControllerBuilder
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
                           siblingKeyPath: relationKeyPath,
                           config: config))
    }
}
