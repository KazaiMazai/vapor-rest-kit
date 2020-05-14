//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 26.04.2020.
//

import Vapor

public protocol APIMethodsProviding {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String)
}
