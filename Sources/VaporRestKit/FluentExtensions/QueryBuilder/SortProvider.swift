//
//  
//  
//
//  Created by Sergey Kazakov on 05.05.2020.
//

import Fluent
import Vapor


//MARK:- SortingKey Protocol

public protocol SortingKey: RawRepresentable where RawValue == String {
    associatedtype Model: Fluent.Model

    func sortFor(_ queryBuilder: QueryBuilder<Model>, direction: DatabaseQuery.Sort.Direction) -> QueryBuilder<Model>
}

public protocol SortingQueryKey: SortingKey {
    static func emptyQuerySort(queryBuilder: QueryBuilder<Model>)-> QueryBuilder<Model>

    static func uniqueKeySort(queryBuilder: QueryBuilder<Model>)-> QueryBuilder<Model>
}

//MARK:- SortProvider Protocol
@available(*, deprecated, message: "Use SortingQueryKey instead")
public protocol SortProvider where Key: SortingKey, Key.Model == Model {
    associatedtype Model
    associatedtype Key

    var supportsDynamicSortKeys: Bool { get }

    func defaultSorting(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model>

    func uniqueKeySorting(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model>

    init()
}


public extension SortProvider {
    func uniqueKeySorting(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        return queryBuilder.sort(\Model._$id, .ascending)
    }
}

//MARK:- StaticSorting Protocol

@available(*, deprecated, message: "Use Sorting<Key>.with(_ handler: _) instead")
public protocol StaticSorting: SortProvider { }

public extension StaticSorting {
    var supportsDynamicSortKeys: Bool { return false }
}

//MARK: DynamicSorting Protocol

@available(*, deprecated, message: "Use Sorting<Key>.with(keys: _, defaultSorting: _, uniqueKeySorting: _) instead")
public protocol DynamicSorting: SortProvider { }

public extension DynamicSorting {
    var supportsDynamicSortKeys: Bool { return true }
}


//MARK:- EmptySortingKey

public enum EmptySortingKey<Model: Fluent.Model>: String, SortingKey {
    case empty

    public func sortFor(_ queryBuilder: QueryBuilder<Model>, direction: DatabaseQuery.Sort.Direction) -> QueryBuilder<Model> {
        return queryBuilder
    }
}


//MARK:- SortingUnsupported

public struct SortingUnsupported<Model: Fluent.Model>: StaticSorting {
    public typealias Key = EmptySortingKey<Model>

    public init() { }

    public func defaultSorting(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        return queryBuilder
    }
}
