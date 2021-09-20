//
//  
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Foundation

public extension ResourceOutputModel {
    @available(*, deprecated, message: "Use ResourceController, RelatedResourceController and RelationsController API instead")
    static func controller<EagerLoading>(eagerLoading: EagerLoading.Type) -> ResourceControllerBuilder<Self.Model,
        Self,
        EagerLoading> {

            return ResourceControllerBuilder<Self.Model,
                Self,
                EagerLoading>(modelType: Model.self,
                              outputType: Self.self,
                              eagerLoading: eagerLoading)
    }
}
