//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 17.05.2020.
//

import Vapor
import Fluent

public protocol ResourceOutputModel: Content {
    associatedtype Model: Fields

    init(_: Model, req: Request)
}


struct SuccessOutput<Model: Fields>: ResourceOutputModel {
    let success = true

    init(_ model: Model, req: Request) {  }
}


