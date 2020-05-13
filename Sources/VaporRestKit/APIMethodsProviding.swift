//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 26.04.2020.
//

import Vapor

open protocol APIMethodsProviding {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String)
}
