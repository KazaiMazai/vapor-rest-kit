//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 25.09.2021.
//

import Fluent
import Vapor

public struct Sorting<Key: SortingKey> {
    public typealias Handler<Model: Fluent.Model> = (_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model>
    
    let supportsDynamicSortKeys: Bool

    let defaultSorting: Handler<Key.Model>

    let uniqueKeySorting: Handler<Key.Model>
}

public extension Sorting {
    static func with<Key>(keys: Key.Type,
                          defaultSorting: @escaping Handler<Key.Model> = { $0 },
                          uniqueKeySorting: @escaping Handler<Key.Model>) -> Sorting<Key> {

        Sorting<Key>(supportsDynamicSortKeys: true,
                     defaultSorting: defaultSorting,
                     uniqueKeySorting: uniqueKeySorting)
    }
    

    static func with<Model>(_ handler: @escaping Handler<Model>) -> Sorting<EmptySortingKey<Model>> {

        Sorting<EmptySortingKey<Model>>(
            supportsDynamicSortKeys: false,
            defaultSorting: { $0 },
            uniqueKeySorting: handler)
    }
} 
