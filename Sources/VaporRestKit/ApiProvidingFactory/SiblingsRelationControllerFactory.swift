//
//  
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

public final class SiblingsRelationControllerFactory<Model, RelatedModel, Through, Output, EagerLoading>: APIMethodsProviding
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    Through: Fluent.Model {

    internal let resourceFactory: SiblingsResourceControllerFactory<Model, RelatedModel, Through, Output, EagerLoading>

    internal init(resourceFactory: SiblingsResourceControllerFactory<Model, RelatedModel, Through, Output, EagerLoading>) {
        self.resourceFactory = resourceFactory
    }

    fileprivate var controllers: [APIMethodsProviding] = []

    fileprivate func adding(_ controller: APIMethodsProviding) -> SiblingsRelationControllerFactory  {
        controllers.append(controller)
        return self
    }
}

public extension SiblingsRelationControllerFactory {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        resourceFactory.addMethodsTo(routeBuilder, on: endpoint)
        CompoundResourceController(with: controllers).addMethodsTo(routeBuilder, on: endpoint)
    }
}

public extension SiblingsRelationControllerFactory {
    func create() -> SiblingsRelationControllerFactory {
        return adding(CreateSiblingRelationController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relationNamePath: resourceFactory.relationName,
                          siblingKeyPath: resourceFactory.relation))
    }

    func delete() -> SiblingsRelationControllerFactory {
        return adding(DeleteSiblingRelationController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relationNamePath: resourceFactory.relationName,
                          siblingKeyPath: resourceFactory.relation))
    }
}

public extension SiblingsRelationControllerFactory where RelatedModel: Authenticatable {
    func create(authenticatable: RelatedModel.Type) -> SiblingsRelationControllerFactory {
        return adding(CreateAuthSiblingRelationController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relationNamePath: resourceFactory.relationName,
                          siblingKeyPath: resourceFactory.relation))
    }

    func delete(authenticatable: RelatedModel.Type) -> SiblingsRelationControllerFactory {
        return adding(DeleteAuthSiblingRelationController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relationNamePath: resourceFactory.relationName,
                          siblingKeyPath: resourceFactory.relation))
    }
}
