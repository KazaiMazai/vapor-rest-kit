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

    internal var controllers: [APIMethodsProviding] = []

    internal func adding(_ controller: APIMethodsProviding) -> SiblingsRelationControllerBuilder  {
        controllers.append(controller)
        return self
    }
}
