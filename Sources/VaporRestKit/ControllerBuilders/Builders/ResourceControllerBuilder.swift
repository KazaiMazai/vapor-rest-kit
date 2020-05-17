//
//  
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

public final class ResourceControllerBuilder<Model, Output, EagerLoading>: APIMethodsProviding
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

    internal init<Model, Output, EagerLoading>(modelType: Model.Type = Model.self,
                                               outputType: Output.Type = Output.self,
                                               eagerLoading: EagerLoading.Type = EagerLoading.self) {

    }

    fileprivate var controllers: [APIMethodsProviding] = []

    fileprivate func adding(_ controller: APIMethodsProviding) -> ResourceControllerBuilder  {
        controllers.append(controller)
        return self
    }
}

public extension ResourceControllerBuilder {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        CompoundResourceController(with: controllers).addMethodsTo(routeBuilder, on: endpoint)
    }
}

public extension ResourceControllerBuilder {
    func related<RelatedModel, Through>(with siblingKeyPath: SiblingKeyPath<RelatedModel, Model, Through>,
                                        relationName: String) -> SiblingsResourceControllerBuilder<Model,
        RelatedModel,
        Through,
        Output,
        EagerLoading> {

            return SiblingsResourceControllerBuilder<Model,
                RelatedModel,
                Through,
                Output,
                EagerLoading>(self,
                              relation: siblingKeyPath,
                              relationName: relationName)
    }

    func related<RelatedModel>(with childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>,
                               relationName: String) -> RelatedResourceControllerBuilder<Model, RelatedModel, Output, EagerLoading> {

        return RelatedResourceControllerBuilder<Model, RelatedModel, Output, EagerLoading>(self,
                                                                                           childrenKeyPath: childrenKeyPath,
                                                                                           relationName: relationName)
    }

    func related<RelatedModel>(with childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>,
                               relationName: String) -> RelatedResourceControllerBuilder<Model, RelatedModel, Output, EagerLoading> {

        return RelatedResourceControllerBuilder<Model,
            RelatedModel,
            Output,
            EagerLoading>(self,
                          childrenKeyPath: childrenKeyPath,
                          relationName: relationName)
    }
}


extension ResourceControllerBuilder {
    func create<Input>(input: Input.Type, middleware: ResourceMiddleware<Model> = .defaultMiddleware) -> ResourceControllerBuilder
        where
        Input: ResourceUpdateModel,
        Model == Input.Model {

            return adding(CreateResourceController<Model,
                Output,
                Input,
                EagerLoading>(resourceMiddleware: middleware))
    }


    func read() -> ResourceControllerBuilder {
        return adding(ReadResourceController<Model,
            Output,
            EagerLoading>())
    }


    func update<Input>(input: Input.Type, middleware: ResourceMiddleware<Model> = .defaultMiddleware) -> ResourceControllerBuilder

        where
        Input: ResourceUpdateModel,
        Model == Input.Model {

            return adding(UpdateResourceController<Model,
                Output,
                Input,
                EagerLoading>(resourceMiddleware: middleware))
    }

    func patch<Input>(input: Input.Type, middleware: ResourceMiddleware<Model> = .defaultMiddleware) -> ResourceControllerBuilder
        where
        Input: ResourcePatchModel,
        Model == Input.Model {

            return adding(PatchResourceController<Model,
                Output,
                Input,
                EagerLoading>(resourceMiddleware: middleware))
    }


    func delete(forced: Bool = false, middleware: ResourceMiddleware<Model> = .defaultMiddleware) -> ResourceControllerBuilder {

        return adding(DeleteResourceController<Model,
            Output,
            EagerLoading>(resourceMiddleware: middleware,
                          useForcedDelete: forced))
    }

    func collection<Sorting, Filtering>(sorting: Sorting.Type,
                                        filtering: Filtering.Type,
                                        config: IterableControllerConfig = .defaultConfig) -> ResourceControllerBuilder
        where
        Sorting: SortProvider,
        Sorting.Model == Model,
        Filtering: FilterProvider,
        Filtering.Model == Model {

            return adding(CollectionResourceController<Model,
                Output,
                Sorting,
                EagerLoading,
                Filtering>(config: config))
    }
}

