//
//  
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

public final class RelatedResourceControllerBuilder<Model, RelatedModel, Output, EagerLoading>: APIMethodsProviding
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model,
    RelatedModel: Fluent.Model,
    RelatedModel.IDValue: LosslessStringConvertible {

    internal let resourceControllerBuilder: ResourceControllerBuilder<Model, Output, EagerLoading>
    internal let keyPathType: KeyPathType
    internal let relationName: String?

    internal init(_ resourceControllerBuilder: ResourceControllerBuilder<Model, Output, EagerLoading>,
                  childrenKeyPath: ChildrenKeyPath<RelatedModel, Model>,
                  relationName: String?) {

        self.resourceControllerBuilder = resourceControllerBuilder
        self.keyPathType = .children(childrenKeyPath)
        self.relationName = relationName
    }

    internal init(_ resourceFactory: ResourceControllerBuilder<Model, Output, EagerLoading>,
                  childrenKeyPath: ChildrenKeyPath<Model, RelatedModel>,
                  relationName: String?) {

        self.resourceControllerBuilder = resourceFactory
        self.keyPathType = .inversedChildren(childrenKeyPath)
        self.relationName = relationName
    }

    internal enum KeyPathType {
        case children(ChildrenKeyPath<RelatedModel, Model>)
        case inversedChildren(ChildrenKeyPath<Model, RelatedModel>)
    }

    internal var controllers: [APIMethodsProviding] = []

    internal func adding(_ controller: APIMethodsProviding) -> RelatedResourceControllerBuilder  {
        controllers.append(controller)
        return self
    }
}
