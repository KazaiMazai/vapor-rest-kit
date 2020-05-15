//
//  
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

public final class SiblingsResourceControllerFactory<Model, RelatedModel, Through, Output, EagerLoading>: APIMethodsProviding
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
Through: Fluent.Model {

    internal let resourceFactory: ResourceControllerFactory<Model, Output, EagerLoading>
    internal let relation: SiblingKeyPath<RelatedModel, Model, Through>
    internal let relationName: String

    internal init(_ resourceFactory: ResourceControllerFactory<Model, Output, EagerLoading>,
                  relation: SiblingKeyPath<RelatedModel, Model, Through>,
                  relationName: String) {

        self.resourceFactory = resourceFactory
        self.relation = relation
        self.relationName = relationName
    }

    fileprivate var controllers: [APIMethodsProviding] = []

    fileprivate func adding(_ controller: APIMethodsProviding) -> SiblingsResourceControllerFactory  {
        controllers.append(controller)
        return self
    }
}

public extension SiblingsResourceControllerFactory {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        resourceFactory.addMethodsTo(routeBuilder, on: endpoint)
        CompoundResourceController(with: controllers).addMethodsTo(routeBuilder, on: endpoint)
    }
}

public extension SiblingsResourceControllerFactory {
    var relationController: SiblingsRelationControllerFactory<Model, RelatedModel, Through, Output, EagerLoading> {
        return SiblingsRelationControllerFactory<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(resourceFactory: self)
    }
}

public extension SiblingsResourceControllerFactory {
    func create<Input>(input: Input.Type) -> SiblingsResourceControllerFactory
        where
        Input: ResourceUpdateModel,
        Model == Input.Model {

            return adding(CreateRelatedResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Input,
                EagerLoading>(relationNamePath: relationName,
                              siblingKeyPath: relation))
    }

    func read() -> SiblingsResourceControllerFactory {

        return adding(ReadRelatedResourceController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relationNamePath: relationName,
                          siblingKeyPath: relation))
    }


    func update<Input>(input: Input.Type) -> SiblingsResourceControllerFactory
        where
        Input: ResourceUpdateModel,
        Model == Input.Model {

            return adding(UpdateRelatedResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Input,
                EagerLoading>(relationNamePath: relationName,
                              siblingKeyPath: relation))
    }

    func patch<Input>(input: Input.Type) -> SiblingsResourceControllerFactory
        where
        Input: ResourcePatchModel,
        Model == Input.Model {

            return adding(PatchRelatedResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Input,
                EagerLoading>(relationNamePath: relationName,
                              siblingKeyPath: relation))
    }

    func delete() -> SiblingsResourceControllerFactory {
        return adding(DeleteRelatedResourceController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relationNamePath: relationName,
                          siblingKeyPath: relation))
    }

    func collection<Sorting, Filtering>(sorting: Sorting.Type, filtering: Filtering.Type, config: IterableControllerConfig = .defaultConfig) -> SiblingsResourceControllerFactory
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
                           siblingKeyPath: relation, config: config))
    }
}

public extension SiblingsResourceControllerFactory where RelatedModel: Authenticatable {
    func create<Input>(input: Input.Type, authenticatable: RelatedModel.Type) -> SiblingsResourceControllerFactory
        where
        Input: ResourceUpdateModel,
        Model == Input.Model {

            return adding(CreateRelatedAuthResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Input,
                EagerLoading>(relationNamePath: relationName,
                              siblingKeyPath: relation))
    }

    func read(authenticatable: RelatedModel.Type) -> SiblingsResourceControllerFactory {
        return adding(ReadRelatedAuthResourceController<Model,
            RelatedModel,
            Through,
            Output,
            Input,
            EagerLoading>(relationNamePath: relationName,
                          siblingKeyPath: relation))
    }

    func update<Input>(input: Input.Type,
                       authenticatable: RelatedModel.Type) -> SiblingsResourceControllerFactory
        where
        Input: ResourceUpdateModel,
        Model == Input.Model {

            return adding(UpdateRelatedAuthResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Input,
                EagerLoading>(relationNamePath: relationName,
                              siblingKeyPath: relation))
    }

    func patch<Input>(input: Input.Type,
                      authenticatable: RelatedModel.Type) -> SiblingsResourceControllerFactory
        where
        Input: ResourcePatchModel,
        Model == Input.Model {

            return adding(PatchRelatedAuthResourceController<Model,
                RelatedModel,
                Through,
                Output,
                Input,
                EagerLoading>(relationNamePath: relationName,
                              siblingKeyPath: relation))
    }

    func delete(authenticatable: RelatedModel.Type) -> SiblingsResourceControllerFactory {
        return adding(DeleteRelatedAuthResourceController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relationNamePath: relationName,
                          siblingKeyPath: relation))
    }

    func collection<Sorting, Filtering>(authenticatable: RelatedModel.Type,
                                        sorting: Sorting.Type,
                                        filtering: Filtering.Type,
                                        config: IterableControllerConfig = .defaultConfig) -> SiblingsResourceControllerFactory
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
                           siblingKeyPath: relation,
                           config: config))
    }
}
