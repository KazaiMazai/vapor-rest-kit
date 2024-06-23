//
//  
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor
import Fluent

public final class ResourceControllerBuilder<Model, Output, EagerLoading>: APIMethodsProviding
    where
    Output: ResourceOutputModel,
    Model == Output.Model,
    Model.IDValue: LosslessStringConvertible,
    EagerLoading: EagerLoadProvider,
    EagerLoading.Model == Model {

        internal init(modelType: Model.Type = Model.self,
                      outputType: Output.Type = Output.self,
                      eagerLoading: EagerLoading.Type = EagerLoading.self) {
            
        }
        
        internal var controllers: [APIMethodsProviding] = []
        
        internal func adding(_ controller: APIMethodsProviding) -> ResourceControllerBuilder  {
            controllers.append(controller)
            return self
        }
    }
