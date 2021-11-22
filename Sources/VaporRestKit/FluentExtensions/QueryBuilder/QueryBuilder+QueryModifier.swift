//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 24.09.2021.
//

import Vapor
import Fluent

extension QueryBuilder {
    func with(_ queryModifier: QueryModifier<Model>, for req: Request) throws -> QueryBuilder<Model> {
        try queryModifier.apply(self, req)
    }
}
