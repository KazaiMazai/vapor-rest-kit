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

    internal var controllers: [APIMethodsProviding] = []

    internal func adding(_ controller: APIMethodsProviding) -> RelationControllerBuilder  {
        controllers.append(controller)
        return self
    }

}
