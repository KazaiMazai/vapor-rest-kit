//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 18.07.2021.
//

import Vapor
import Fluent

public struct QueryModifier<Model: Fluent.Model> {
    let apply: (QueryBuilder<Model>, Request) throws -> QueryBuilder<Model>

    public init(apply: @escaping (QueryBuilder<Model>, Request) throws -> QueryBuilder<Model>) {
        self.apply = apply
    }
}

public extension QueryModifier {
    static func & (lhs: QueryModifier, rhs: QueryModifier) -> QueryModifier {
        QueryModifier { query, req in
            try rhs.apply(try lhs.apply(query, req), req)
        }
    }
}

public extension QueryModifier {
    @available(*, deprecated, message: "Use SortingQueryKey instead")
    static func sort<Sorting: SortProvider>(_ sortProvider: Sorting) -> QueryModifier
    where
        Sorting.Model == Model {

        QueryModifier { query, req in
            try query.sort(sortProvider, for: req)
        }
    }

    static func sort<Key: SortingQueryKey>(using key: Key.Type) -> QueryModifier
    where
        Key.Model == Model {

        QueryModifier { query, req in
            try query.sort(key, for: req)
        }
    }
}

public extension QueryModifier {

    @available(*, deprecated, message: "Use FilterQueryKey instead")
    static func filter<Filtering: FilterProvider>(_ filterProvider: Filtering) -> QueryModifier
    where
        Filtering.Model == Model {

        QueryModifier { query, req in
            try query.filter(filterProvider, for: req)
        }
    }

    static func filter<Key: FilterQueryKey>(_ keys: Key.Type) -> QueryModifier
    where
        Key.Model == Model {

        QueryModifier { query, req in
            try query.filter(with: keys, for: req)
        }
    }
}


public extension QueryModifier {

    static func eagerLoading<EagerLoading: EagerLoadProvider>(_ eagerLoadProvider: EagerLoading) -> QueryModifier
    where
        EagerLoading.Model == Model {

        QueryModifier { query, req in
            try query.with(eagerLoadProvider, for: req)
        }
    }

    static func eagerLoading<Key: EagerLoadingQueryKey>(_ keys: Key.Type) -> QueryModifier
    where
        Key.Model == Model {

        QueryModifier { query, req in
            try query.with(keys: keys, for: req)
        }
    }
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

        .eagerLoading(eagerLoadProvider) &
        .sort(sortProvider) &
        .filter(filterProvider)
    }
}
