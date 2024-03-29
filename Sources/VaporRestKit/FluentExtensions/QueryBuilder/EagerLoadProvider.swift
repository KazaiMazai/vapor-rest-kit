//
//  
//  
//
//  Created by Sergey Kazakov on 05.05.2020.
//

import Vapor
import Fluent


//MARK:- EagerLoadingKey Protocol

public protocol EagerLoadingKey: RawRepresentable where RawValue == String {
    associatedtype Model: Fluent.Model

    func eagerLoadFor(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model>
}

public protocol EagerLoadingQueryKey: EagerLoadingKey {
    static func eagerLoadEmptyQueryFor(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model>
}

public extension EagerLoadingQueryKey {
    static func eagerLoadEmptyQueryFor(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        queryBuilder
    }
}


//MARK:- EagerLoadProvider Protocol

public protocol EagerLoadProvider where Key: EagerLoadingKey, Key.Model == Model {
    associatedtype Model
    associatedtype Key

    func defaultEagerLoading(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model>

    func baseEagerLoading(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model>

    var supportsDynamicEagerLoadingKeys: Bool { get }

    init()
}

public extension EagerLoadProvider {
    func baseEagerLoading(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        return queryBuilder
    }
}



//MARK:- StaticEagerLoading Protocol

public protocol StaticEagerLoading: EagerLoadProvider { }

public extension StaticEagerLoading {
    var supportsDynamicEagerLoadingKeys: Bool { return false }

    func defaultEagerLoading(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        baseEagerLoading(queryBuilder)
    }

}

//MARK: DynamicEagerLoading Protocol

public protocol DynamicEagerLoading: EagerLoadProvider { }

public extension DynamicEagerLoading {
    var supportsDynamicEagerLoadingKeys: Bool { return true }
}


//MARK:- EmptyEagerLoadKey

public enum EmptyEagerLoadKey<Model: Fluent.Model>: String, EagerLoadingKey {
    case empty

    public func eagerLoadFor(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        return queryBuilder
    }
}

//MARK:- EagerLoadingUnsupported

public struct EagerLoadingUnsupported<Model: Fluent.Model>: StaticEagerLoading {
    public typealias Key = EmptyEagerLoadKey<Model>

    public init() { }

    public func defaultEagerLoading(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        return queryBuilder
    }
}
