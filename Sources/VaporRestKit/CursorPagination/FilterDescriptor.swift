//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 09.05.2020.
//

import Vapor
import Fluent

//MARK:- FilterDescriptor

struct FilterDescriptor {
    let field: DatabaseQuery.Field
    let method: DatabaseQuery.Filter.Method

    init(field: DatabaseQuery.Field, method: DatabaseQuery.Filter.Method) {
        self.field = field
        self.method = method
    }

    init(sort: DatabaseQuery.Sort) throws {
        switch sort {
        case .sort(let field, let direction):
            self.field = field
            self.method = try direction.filterMethodForSortDirection(including: false)
        case .custom(_):
            throw Abort(.unprocessableEntity, reason: "Custom sort is not compatible with cursor pagination")
        }
    }
}

//MARK:- Direction Extesion

extension DatabaseQuery.Sort.Direction {
    fileprivate func filterMethodForSortDirection(including: Bool) throws -> DatabaseQuery.Filter.Method {
        switch self {
        case .ascending:
            return including ? .greaterThanOrEqual : .greaterThan
        case .descending:
            return including ? .lessThanOrEqual : .lessThan
        case .custom(_):
            throw Abort(.badRequest, reason: "Custom sort direction is not compatible with cursor pagination")
        }
    }
}

