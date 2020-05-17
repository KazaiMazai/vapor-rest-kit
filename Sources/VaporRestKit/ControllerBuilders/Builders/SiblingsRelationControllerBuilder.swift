//
//  
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

public final class SiblingsRelationControllerBuilder<Model, RelatedModel, Through, Output, EagerLoading>: APIMethodsProviding
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible,
    Through: Fluent.Model {

    internal let resourceControllerBuilder: SiblingsResourceControllerBuilder<Model, RelatedModel, Through, Output, EagerLoading>

    internal init(resourceControllerBuilder: SiblingsResourceControllerBuilder<Model, RelatedModel, Through, Output, EagerLoading>) {
        self.resourceControllerBuilder = resourceControllerBuilder
    }

    fileprivate var controllers: [APIMethodsProviding] = []

    fileprivate func adding(_ controller: APIMethodsProviding) -> SiblingsRelationControllerBuilder  {
        controllers.append(controller)
        return self
    }
}

public extension SiblingsRelationControllerBuilder {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        resourceControllerBuilder.addMethodsTo(routeBuilder, on: endpoint)
        CompoundResourceController(with: controllers).addMethodsTo(routeBuilder, on: endpoint)
    }
}

public extension SiblingsRelationControllerBuilder {
    func create(with middleware: RelatedResourceControllerMiddleware<Model, RelatedModel> = .defaultMiddleware) -> SiblingsRelationControllerBuilder {
        return adding(CreateSiblingRelationController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relatedResourceMiddleware: middleware,
                          relationNamePath: resourceControllerBuilder.relationName,
                          siblingKeyPath: resourceControllerBuilder.relationKeyPath))
    }

    func delete(with middleware: RelatedResourceControllerMiddleware<Model, RelatedModel> = .defaultMiddleware) -> SiblingsRelationControllerBuilder {

        return adding(DeleteSiblingRelationController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relatedResourceMiddleware: middleware,
                          relationNamePath: resourceControllerBuilder.relationName,
                          siblingKeyPath: resourceControllerBuilder.relationKeyPath))
    }
}

public extension SiblingsRelationControllerBuilder where RelatedModel: Authenticatable {
    func create(with middleware: RelatedResourceControllerMiddleware<Model, RelatedModel> = .defaultMiddleware,
                authenticatable: RelatedModel.Type) -> SiblingsRelationControllerBuilder {
        
        return adding(CreateAuthSiblingRelationController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relatedResourceMiddleware: middleware,
                          relationNamePath: resourceControllerBuilder.relationName,
                          siblingKeyPath: resourceControllerBuilder.relationKeyPath))
    }


    func delete(with middleware: RelatedResourceControllerMiddleware<Model, RelatedModel> = .defaultMiddleware, authenticatable: RelatedModel.Type) -> SiblingsRelationControllerBuilder {

        return adding(DeleteAuthSiblingRelationController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relatedResourceMiddleware: middleware,
                          relationNamePath: resourceControllerBuilder.relationName,
                          siblingKeyPath: resourceControllerBuilder.relationKeyPath))
    }
}
