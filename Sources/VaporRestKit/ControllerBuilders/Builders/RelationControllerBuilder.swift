//
//  
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

public final class RelationControllerBuilder<Model, RelatedModel, Output, EagerLoading>: APIMethodsProviding
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible {

    internal let resourceControllerBuilder: RelatedResourceControllerBuilder<Model, RelatedModel, Output, EagerLoading>

    internal init(resourceControllerBuilder: RelatedResourceControllerBuilder<Model, RelatedModel, Output, EagerLoading>) {
        self.resourceControllerBuilder = resourceControllerBuilder
    }

    fileprivate var controllers: [APIMethodsProviding] = []

    fileprivate func adding(_ controller: APIMethodsProviding) -> RelationControllerBuilder  {
        controllers.append(controller)
        return self
    }

}

public extension RelationControllerBuilder {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        resourceControllerBuilder.addMethodsTo(routeBuilder, on: endpoint)
        CompoundResourceController(with: controllers).addMethodsTo(routeBuilder, on: endpoint)
    }
}

public extension RelationControllerBuilder {
    func create() -> RelationControllerBuilder {
        switch resourceControllerBuilder.keyPathType {
        case .children(let relationKeyPath):
            return adding(CreateChildrenRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceControllerBuilder.relationName,
                              childrenKeyPath: relationKeyPath))

        case .inversedChildren(let relationKeyPath):
            return adding(CreateParentRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceControllerBuilder.relationName,
                              inversedChildrenKeyPath: relationKeyPath))
        }
    }

    func delete<DeleteHandler>(input: DeleteHandler.Type) -> RelationControllerBuilder
        where
        DeleteHandler: ResourceDeleteHandler,
        Model == DeleteHandler.Model {

        switch resourceControllerBuilder.keyPathType {
        case .children(let relationKeyPath):
            return adding(DeleteChildrenRelationController<Model,
                RelatedModel,
                Output,
                DeleteHandler,
                EagerLoading>(relationNamePath: resourceControllerBuilder.relationName,
                              childrenKeyPath: relationKeyPath))

        case .inversedChildren(let relationKeyPath):
            return adding(DeleteParentRelationController<Model,
                RelatedModel,
                Output,
                DeleteHandler,
                EagerLoading>(relationNamePath: resourceControllerBuilder.relationName,
                              inversedChildrenKeyPath: relationKeyPath))
        }
    }
}

public extension RelationControllerBuilder where RelatedModel: Authenticatable {
    func create(authenticatable: RelatedModel.Type) -> RelationControllerBuilder {
        switch resourceControllerBuilder.keyPathType {
        case .children(let relationKeyPath):
            return adding(CreateAuthChildrenRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceControllerBuilder.relationName,
                              childrenKeyPath: relationKeyPath))

        case .inversedChildren(let relationKeyPath):
            return adding(CreateAuthParentRelationController<Model,
                RelatedModel,
                Output,
                EagerLoading>(relationNamePath: resourceControllerBuilder.relationName,
                              inversedChildrenKeyPath: relationKeyPath))
        }
    }

    func delete<DeleteHandler>(input: DeleteHandler.Type, authenticatable: RelatedModel.Type) -> RelationControllerBuilder
        where
        DeleteHandler: ResourceDeleteHandler,
        Model == DeleteHandler.Model {

        switch resourceControllerBuilder.keyPathType {
        case .children(let relationKeyPath):
            return adding(DeleteAuthChildrenRelationController<Model,
                RelatedModel,
                Output,
                DeleteHandler,
                EagerLoading>(relationNamePath: resourceControllerBuilder.relationName,
                              childrenKeyPath: relationKeyPath))

        case .inversedChildren(let relationKeyPath):
            return adding(DeleteAuthParentRelationController<Model,
                RelatedModel,
                Output,
                DeleteHandler,
                EagerLoading>(relationNamePath: resourceControllerBuilder.relationName,
                              inversedChildrenKeyPath: relationKeyPath))
        }
    }
}

