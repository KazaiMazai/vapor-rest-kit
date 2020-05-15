//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Foundation

extension ResourceOutputModel {
    static func resourceController<EagerLoading>(eagerLoading: EagerLoading.Type = EagerLoading.self) -> ResourceControllerFactory<Self.Model,
        Self,
        EagerLoading> {

            return ResourceControllerFactory<Self.Model,
                                        Self,
                                        EagerLoading>(modelType: Model.self,
                                                      outputType: Self.self,
                                                      eagerLoading: eagerLoading)
    }
}
