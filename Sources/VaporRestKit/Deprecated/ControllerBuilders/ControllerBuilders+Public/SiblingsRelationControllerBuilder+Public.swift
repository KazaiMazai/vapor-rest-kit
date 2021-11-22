//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 23.05.2020.
//

import Vapor
import Fluent

public extension SiblingsRelationControllerBuilder {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        resourceControllerBuilder.addMethodsTo(routeBuilder, on: endpoint)
        CompoundResourceController(with: controllers).addMethodsTo(routeBuilder, on: endpoint)
    }
}

public extension SiblingsRelationControllerBuilder {
    func create(with middleware: ControllerMiddleware<Model, RelatedModel> = .empty) -> SiblingsRelationControllerBuilder {
        return adding(CreateSiblingRelationController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relatedResourceMiddleware: middleware,
                          relationNamePath: resourceControllerBuilder.relationName,
                          siblingKeyPath: resourceControllerBuilder.relationKeyPath))
    }

    func delete(with middleware: ControllerMiddleware<Model, RelatedModel> = .empty) -> SiblingsRelationControllerBuilder {

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
    func create(with middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
                authenticatable: RelatedModel.Type) -> SiblingsRelationControllerBuilder {

        return adding(CreateAuthSiblingRelationController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relatedResourceMiddleware: middleware,
                          relationNamePath: resourceControllerBuilder.relationName,
                          siblingKeyPath: resourceControllerBuilder.relationKeyPath))
    }


    func delete(with middleware: ControllerMiddleware<Model, RelatedModel> = .empty, authenticatable: RelatedModel.Type) -> SiblingsRelationControllerBuilder {

        return adding(DeleteAuthSiblingRelationController<Model,
            RelatedModel,
            Through,
            Output,
            EagerLoading>(relatedResourceMiddleware: middleware,
                          relationNamePath: resourceControllerBuilder.relationName,
                          siblingKeyPath: resourceControllerBuilder.relationKeyPath))
    }
}
