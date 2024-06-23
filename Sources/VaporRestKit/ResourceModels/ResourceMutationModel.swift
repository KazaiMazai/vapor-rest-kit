//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 08.08.2021.
//


import Vapor
import Fluent

public protocol ResourceMutationModel: Content, Validatable where Model: Fields {
    associatedtype Model
 
    func mutate(_ model: Model, req: Request, database: Database) -> EventLoopFuture<Model>
}
