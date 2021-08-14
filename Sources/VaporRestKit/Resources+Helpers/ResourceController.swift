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

