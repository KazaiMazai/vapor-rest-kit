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
    internal let relationName: String?

    internal init(_ resourControllerBuilder: ResourceControllerBuilder<Model, Output, EagerLoading>,
                  relation: SiblingKeyPath<RelatedModel, Model, Through>,
                  relationName: String?) {

        self.resourceControllerBuilder = resourControllerBuilder
        self.relationKeyPath = relation
        self.relationName = relationName
    }

    internal var controllers: [APIMethodsProviding] = []

    internal func adding(_ controller: APIMethodsProviding) -> SiblingsResourceControllerBuilder  {
        controllers.append(controller)
        return self
    }
}

