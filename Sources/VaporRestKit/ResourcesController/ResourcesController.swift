//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 14.08.2021.
//

import Vapor
import Fluent

public struct ResourceController<Output: ResourceOutputModel> where
    Output.Model.IDValue: LosslessStringConvertible,
    Output.Model: Fluent.Model {
}

public struct RelatedResourceController<Output: ResourceOutputModel> where
    Output.Model.IDValue: LosslessStringConvertible,
    Output.Model: Fluent.Model {
}

public struct RelationsController<Output: ResourceOutputModel> where
    Output.Model.IDValue: LosslessStringConvertible,
    Output.Model: Fluent.Model {
}
