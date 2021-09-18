//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 14.08.2021.
//

import Vapor
import Fluent

struct ResourceController<Output: ResourceOutputModel> where
    Output.Model.IDValue: LosslessStringConvertible,
    Output.Model: Fluent.Model {
}

struct RelatedResourceController<Output: ResourceOutputModel> where
    Output.Model.IDValue: LosslessStringConvertible,
    Output.Model: Fluent.Model {
}

struct RelationsController<Output: ResourceOutputModel> where
    Output.Model.IDValue: LosslessStringConvertible,
    Output.Model: Fluent.Model {
}
