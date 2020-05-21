//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 15.05.2020.
//

import Vapor

enum ApiVersion: String, CaseIterable {
    case v1

    var path: PathComponent {
        return PathComponent(stringLiteral: rawValue)
    }
}
