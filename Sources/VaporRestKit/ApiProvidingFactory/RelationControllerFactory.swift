//
//  
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

public final class RelationControllerFactory<Model, RelatedModel, Output, EagerLoading>: APIMethodsProviding
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible {

    internal let resourceFactory: RelatedResourceControllerFactory<Model, RelatedModel, Output, EagerLoading>

    internal init(resourceFactory: RelatedResourceControllerFactory<Model, RelatedModel, Output, EagerLoading>) {
        self.resourceFactory = resourceFactory
    }

    fileprivate var controllers: [APIMethodsProviding] = []

    fileprivate func adding(_ controller: APIMethodsProviding) -> RelationControllerFactory  {
        controllers.append(controller)
        return self
    }

}


public extension RelationControllerFactory {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        resourceFactory.addMethodsTo(routeBuilder, on: endpoint)
        CompoundResourceController(with: controllers).addMethodsTo(routeBuilder, on: endpoint)
    }
}

public extension RelationControllerFactory {
    func create() -> RelationControllerFactory {
        switch resourceFactory.keyPathType {
        case .children(let relationKeyPath):
            return adding(CreateChildrenRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceFactory.relationName,
                              childrenKeyPath: relationKeyPath))

        case .inversedChildren(let relationKeyPath):
            return adding(CreateParentRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceFactory.relationName,
                              inversedChildrenKeyPath: relationKeyPath))
        }
    }

    func delete() -> RelationControllerFactory {
        switch resourceFactory.keyPathType {
        case .children(let relationKeyPath):
            return adding(DeleteChildrenRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceFactory.relationName,
                              childrenKeyPath: relationKeyPath))

        case .inversedChildren(let relationKeyPath):
            return adding(DeleteParentRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceFactory.relationName,
                              inversedChildrenKeyPath: relationKeyPath))
        }
    }
}

public extension RelationControllerFactory where RelatedModel: Authenticatable {
    func create(authenticatable: RelatedModel.Type) -> RelationControllerFactory {
        switch resourceFactory.keyPathType {
        case .children(let relationKeyPath):
            return adding(CreateAuthChildrenRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceFactory.relationName,
                              childrenKeyPath: relationKeyPath))

        case .inversedChildren(let relationKeyPath):
            return adding(CreateAuthParentRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceFactory.relationName,
                              inversedChildrenKeyPath: relationKeyPath))
        }
    }

    func delete(authenticatable: RelatedModel.Type) -> RelationControllerFactory {
        switch resourceFactory.keyPathType {
        case .children(let relationKeyPath):
            return adding(DeleteAuthChildrenRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceFactory.relationName,
                              childrenKeyPath: relationKeyPath))

        case .inversedChildren(let relationKeyPath):
            return adding(DeleteAuthParentRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceFactory.relationName,
                              inversedChildrenKeyPath: relationKeyPath))
        }
    }
}

