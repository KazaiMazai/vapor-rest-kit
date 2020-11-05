//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 24.05.2020.
//

import Vapor
import Fluent

struct SuccessOutput<Model: Fields>: ResourceOutputModel {
    let success: Bool

    init(_ model: Model, req: Request) {
        self.success = true
    }
}
