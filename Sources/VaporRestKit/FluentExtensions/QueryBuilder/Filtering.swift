//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 25.09.2021.
//

import Fluent
import Vapor

public struct Filtering<Key: FilteringKey> {
    public typealias Handler<Model: Fluent.Model> = (_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model>

    let useQueryFilterKeys: Bool

    let emptyQueryKeys: Handler<Key.Model>

    let base: Handler<Key.Model>
}

public extension Filtering {
    static func with<Key>(keys: Key.Type,
                          defaultFiltering: @escaping Handler<Key.Model> = { $0 },
                          baseFiltering: @escaping Handler<Key.Model> = { $0 }) -> Filtering<Key> {

        Filtering<Key>(useQueryFilterKeys: true,
                       emptyQueryKeys: defaultFiltering,
                       base: baseFiltering)
    }

    static func with<Model>(baseFiltering: @escaping Handler<Model>) -> Filtering<EmptyFilteringKey<Model>> {

        Filtering<EmptyFilteringKey<Model>>(useQueryFilterKeys: false,
                       emptyQueryKeys: { $0 },
                       base: baseFiltering)
    }
}
