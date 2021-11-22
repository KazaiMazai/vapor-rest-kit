//
//  
//  
//
//  Created by Sergey Kazakov on 05.05.2020.
//

import Fluent
import Vapor

//MARK:- FilteringKey Protocol

public protocol FilteringKey: RawRepresentable, Codable where RawValue == String {
    associatedtype Model: Fluent.Model

    func filterFor(queryBuilder: QueryBuilder<Model>, method: DatabaseQuery.Filter.Method, value: String) -> QueryBuilder<Model>

    static func filterFor(queryBuilder: QueryBuilder<Model>, lhs: Self, method: DatabaseQuery.Filter.Method, rhs: Self)-> QueryBuilder<Model>
}

//MARK:- FilteringQueryKey Protocol

public protocol FilterQueryKey: FilteringKey {

    static func emptyQueryFilter(queryBuilder: QueryBuilder<Model>)-> QueryBuilder<Model>
}

public extension FilterQueryKey {
    static func emptyQueryFilter(queryBuilder: QueryBuilder<Model>)-> QueryBuilder<Model> {
        queryBuilder
    }
}

//MARK:- FilterProvider Protocol

@available(*, deprecated, message: "Use FilterQueryKey instead")
public protocol FilterProvider where Key: FilteringKey, Key.Model == Model {
    associatedtype Model
    associatedtype Key

    var supportsDynamicFilterKeys: Bool { get }

    func defaultFiltering(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model>

    func baseFiltering(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model>

    init()
}

public extension FilterProvider {
    func baseFiltering(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        return queryBuilder
    }
}

extension FilterProvider {
    func filterFor(builder: QueryBuilder<Model>,
                   filterNode: FilterNode<Key>) -> QueryBuilder<Model> {

        return filterNode.filterFor(queryBuilder: builder)
    }
}

//MARK:- StaticFiltering Protocol

public protocol StaticFiltering: FilterProvider { }

public extension StaticFiltering {
    var supportsDynamicFilterKeys: Bool { return false }

    func defaultFiltering(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        baseFiltering(queryBuilder)
    }
}

//MARK: DynamicFiltering Protocol

public protocol DynamicFiltering: FilterProvider { }

public extension DynamicFiltering {
    var supportsDynamicFilterKeys: Bool { return true }

    func baseFiltering(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        return queryBuilder
    }
}

//MARK:- EmptyFilteringKey

public enum EmptyFilteringKey<Model: Fluent.Model>: String, FilteringKey {
    case empty

    public func filterFor(queryBuilder: QueryBuilder<Model>, method: DatabaseQuery.Filter.Method, value: String) -> QueryBuilder<Model> {
        return queryBuilder
    }

    public static func filterFor(queryBuilder: QueryBuilder<Model>, lhs: EmptyFilteringKey<Model>, method: DatabaseQuery.Filter.Method, rhs: EmptyFilteringKey<Model>) -> QueryBuilder<Model> {
         return queryBuilder
    }
}

//MARK:- FilteringUnsupported

public struct FilteringUnsupported<Model: Fluent.Model>: StaticFiltering {
    public typealias Key = EmptyFilteringKey<Model>

    public init() { }

    public func defaultFiltering(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        return queryBuilder
    }
}

//MARK:- ValueFilter

struct ValueFilter<PropertyKey>: Codable where PropertyKey: FilteringKey {
    let key: PropertyKey
    let value: String
    let method: FilterOperations
}

//MARK:- FieldFilter

struct FieldFilter<PropertyKey>: Codable where PropertyKey: FilteringKey {
    let lhs: PropertyKey
    let method: FilterOperations
    let rhs: PropertyKey
}

//MARK:- FilterOperations

enum FilterOperations: String, Codable {
    case less = "lt"
    case greater = "gt"
    case lessOrEqual = "lte"
    case greaterOrEqual = "gte"
    case equal = "eq"
    case notEqual = "ne"

    case prefix = "prefix"
    case suffix = "suffix"
    case like = "like"

    var databaseFilterMethod: DatabaseQuery.Filter.Method {
        switch self {
        case .less:
            return .lessThan
        case .greater:
            return .greaterThan
        case .lessOrEqual:
            return .lessThanOrEqual
        case .greaterOrEqual:
            return .greaterThanOrEqual
        case .equal:
            return .equal
        case .notEqual:
            return .notEqual
        case .prefix:
            return .contains(inverse: false, .prefix)
        case .suffix:
            return .contains(inverse: false, .suffix)
        case .like:
            return .contains(inverse: false, .anywhere)
        }
    }
}

//MARK:- RawFilterNode

struct RawFilterNode<PropertyKey: FilteringKey>: Codable {
    let or: [RawFilterNode<PropertyKey>]?
    let and: [RawFilterNode<PropertyKey>]?
    let value: ValueFilter<PropertyKey>?
    let field: FieldFilter<PropertyKey>?

    func filterNode() throws -> FilterNode<PropertyKey> {
        if let valueFilter = value {
            return FilterNode.valueFilter(valueFilter)
        }

        if let fieldFilter = field {
            return FilterNode.fieldFilter(fieldFilter)
        }

        if let or = or {
            return try FilterNode.or(or.map { try $0.filterNode() })
        }

        if let and = and {
            return try FilterNode.and(and.map { try $0.filterNode() })
        }

        throw Abort(.badRequest)
    }
}

//MARK:- FilterNode

indirect enum FilterNode<PropertyKey: FilteringKey> {
    case or([FilterNode<PropertyKey>])
    case and([FilterNode<PropertyKey>])
    case valueFilter(ValueFilter<PropertyKey>)
    case fieldFilter(FieldFilter<PropertyKey>)

    func filterFor(queryBuilder: QueryBuilder<PropertyKey.Model>) -> QueryBuilder<PropertyKey.Model> {
        switch self {
        case .or(let nodes):
            return queryBuilder.group(.or) { groupQueryBuilder in
                var qb = groupQueryBuilder
                nodes.forEach { qb = $0.filterFor(queryBuilder: qb) }
            }
        case .and(let nodes):
            return queryBuilder.group(.and) { groupQueryBuilder in
                var qb = groupQueryBuilder
                nodes.forEach { qb = $0.filterFor(queryBuilder: qb) }
            }
        case .valueFilter(let filter):
            return filter.key.filterFor(queryBuilder: queryBuilder,
                                                 method: filter.method.databaseFilterMethod,
                                                 value: filter.value)
        case .fieldFilter(let filter):
            return PropertyKey.filterFor(queryBuilder: queryBuilder,
                                         lhs: filter.lhs,
                                         method: filter.method.databaseFilterMethod,
                                         rhs: filter.rhs)
        }
    }
}
