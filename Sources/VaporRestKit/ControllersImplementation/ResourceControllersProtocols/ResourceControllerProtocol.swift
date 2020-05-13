//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 26.04.2020.
//

import Vapor
import Fluent

protocol ResourceControllerProtocol: APIMethodsProviding
    where Output: ResourceOutputModel,
        Model == Output.Model,
        Model: Fluent.Model,
        Model.IDValue: LosslessStringConvertible {

    associatedtype Output
    associatedtype Model
}



