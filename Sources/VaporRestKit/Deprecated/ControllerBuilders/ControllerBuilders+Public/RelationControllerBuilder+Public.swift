//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 23.05.2020.
//

import Vapor
import Fluent

public extension RelationControllerBuilder {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        resourceControllerBuilder.addMethodsTo(routeBuilder, on: endpoint)
        CompoundResourceController(with: controllers).addMethodsTo(routeBuilder, on: endpoint)
    }
}

public extension RelationControllerBuilder {
    func create(with middleware: ControllerMiddleware<Model, RelatedModel> = .empty) -> RelationControllerBuilder {
        switch resourceControllerBuilder.keyPathType {
        case .children(let relationKeyPath):
            return adding(CreateChildrenRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relatedResourceMiddleware: middleware,
                              relationNamePath: resourceControllerBuilder.relationName,
                              childrenKeyPath: relationKeyPath))

        case .inversedChildren(let relationKeyPath):
            return adding(CreateParentRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relatedResourceMiddleware: middleware,
                              relationNamePath: resourceControllerBuilder.relationName,
                              inversedChildrenKeyPath: relationKeyPath))
        }
    }

    func delete(with middleware: ControllerMiddleware<Model, RelatedModel> = .empty) -> RelationControllerBuilder {

        switch resourceControllerBuilder.keyPathType {
        case .children(let relationKeyPath):
            return adding(DeleteChildrenRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relatedResourceMiddleware: middleware,
                              relationNamePath: resourceControllerBuilder.relationName,
                              childrenKeyPath: relationKeyPath))

        case .inversedChildren(let relationKeyPath):
            return adding(DeleteParentRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relatedResourceMiddleware: middleware,
                              relationNamePath: resourceControllerBuilder.relationName,
                              inversedChildrenKeyPath: relationKeyPath))
        }
    }
}

public extension RelationControllerBuilder where RelatedModel: Authenticatable {
    func create(with middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
                authenticatable: RelatedModel.Type) -> RelationControllerBuilder {

        switch resourceControllerBuilder.keyPathType {
        case .children(let relationKeyPath):
            return adding(CreateAuthChildrenRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relatedResourceMiddleware: middleware,
                              relationNamePath: resourceControllerBuilder.relationName,
                              childrenKeyPath: relationKeyPath))

        case .inversedChildren(let relationKeyPath):
            return adding(CreateAuthParentRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relatedResourceMiddleware: middleware,
                              relationNamePath: resourceControllerBuilder.relationName,
                              inversedChildrenKeyPath: relationKeyPath))
        }
    }

    func delete(with middleware: ControllerMiddleware<Model, RelatedModel> = .empty,
                authenticatable: RelatedModel.Type) -> RelationControllerBuilder {

        switch resourceControllerBuilder.keyPathType {
        case .children(let relationKeyPath):
            return adding(DeleteAuthChildrenRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relatedResourceMiddleware: middleware,
                              relationNamePath: resourceControllerBuilder.relationName,
                              childrenKeyPath: relationKeyPath))

        case .inversedChildren(let relationKeyPath):
            return adding(DeleteAuthParentRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relatedResourceMiddleware: middleware,
                              relationNamePath: resourceControllerBuilder.relationName,
                              inversedChildrenKeyPath: relationKeyPath))
        }
    }
}

