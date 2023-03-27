//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 25.03.2023.
//

import Fluent

extension DatabaseQuery.Sort.Direction {
    func reversed() -> DatabaseQuery.Sort.Direction {
        switch self {
        case .ascending:
            return .descending
        case .descending:
            return .ascending
        case .custom:
            return self
        }
    }
}

extension DatabaseQuery.Sort {
    func reversed() -> DatabaseQuery.Sort {
        switch self {
        case .sort(let field, let direction):
            return .sort(field, direction.reversed())
        case .custom:
            return self
        }
    }
}
