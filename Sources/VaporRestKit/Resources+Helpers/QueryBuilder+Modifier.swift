//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 18.07.2021.
//

import Vapor
import Fluent
 
struct QueryModifier<Model: Fluent.Model> {
    let query: (QueryBuilder<Model>, Request) -> QueryBuilder<Model>
}

extension QueryModifier {
    static var empty: QueryModifier {
        QueryModifier { query, _ in query  }
    }
}

extension QueryBuilder {
    func with(_ queryModifier: QueryModifier<Model>?, for req: Request) -> QueryBuilder<Model> {
        guard let queryModifier = queryModifier else {
            return self
        }

        return queryModifier.query(self, req)
    }

    func using<EagerLoading: EagerLoadProvider,
               Sorting: SortProvider,
               Filtering: FilterProvider> (_ eagerLoadProvider: EagerLoading,
                                           sortProvider: Sorting,
                                           filterProvider: Filtering,
                                           for req: Request) throws -> QueryBuilder<Model> where EagerLoading.Model == Model,
                                                                                                 Sorting.Model == Model,
                                                                                                Filtering.Model == Model {

        try self.with(eagerLoadProvider, for: req)
                .sort(sortProvider, for: req)
                .filter(filterProvider, for: req)
    }


}
