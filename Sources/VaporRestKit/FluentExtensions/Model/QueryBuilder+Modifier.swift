//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 18.07.2021.
//

import Vapor
import Fluent
 
struct QueryModifier<Model: Fluent.Model> {
    let modify: (QueryBuilder<Model>, Request) throws -> QueryBuilder<Model>
}

extension QueryModifier {
    static var empty: QueryModifier {
        QueryModifier { query, _ in query  }
    }

    static func using<EagerLoading: EagerLoadProvider,
                      Sorting: SortProvider,
                      Filtering: FilterProvider>(

        eagerLoadProvider: EagerLoading,
        sortProvider: Sorting,
        filterProvider: Filtering) -> QueryModifier
    where
        EagerLoading.Model == Model,
        Sorting.Model == Model,
        Filtering.Model == Model {

        QueryModifier { query, req in
            try query
                .with(eagerLoadProvider, for: req)
                .sort(sortProvider, for: req)
                .filter(filterProvider, for: req)
        }
    }
}

extension QueryBuilder {
    func with(_ queryModifier: QueryModifier<Model>, for req: Request) throws -> QueryBuilder<Model> {
        try queryModifier.modify(self, req)
    }
}
