//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 14.08.2021.
//

import Vapor
import Fluent

struct ResourceController<Model: Fluent.Model> where Model.IDValue: LosslessStringConvertible {

}

struct RelatedResourceController<Model: Fluent.Model> where Model.IDValue: LosslessStringConvertible {

}

struct RelationsController<Model: Fluent.Model> where Model.IDValue: LosslessStringConvertible {

}
