//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 24.05.2020.
//

import Vapor
import Fluent

struct SuccessOutput<Model: Fields>: ResourceOutputModel {
    let success = true

    init(_ model: Model, req: Request) {  }
}
