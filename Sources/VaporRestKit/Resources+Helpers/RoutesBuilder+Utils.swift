//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 15.08.2021.
//

import Vapor

extension RoutesBuilder {

    @discardableResult
    func with<Controller>(_ controller: Controller,  closure: (RoutesBuilder, Controller) -> Void) -> RoutesBuilder {
        closure(self, controller)
        return self
    }
}
