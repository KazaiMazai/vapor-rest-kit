//
//  
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Foundation

public extension ResourceOutputModel {
    static func resourceController<EagerLoading>(eagerLoading: EagerLoading.Type) -> ResourceControllerFactory<Self.Model,
        Self,
        EagerLoading> {

            return ResourceControllerFactory<Self.Model,
                Self,
                EagerLoading>(modelType: Model.self,
                              outputType: Self.self,
                              eagerLoading: eagerLoading)
    }
}
