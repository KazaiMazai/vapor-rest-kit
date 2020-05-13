//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 05.05.2020.
//

import Vapor
import Fluent


//MARK:- EagerLoadingKey Protocol

protocol EagerLoadingKey: RawRepresentable where RawValue == String {
    associatedtype Model: Fluent.Model

    func eagerLoadFor(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model>
}

//MARK:- EagerLoadProvider Protocol

protocol EagerLoadProvider where Key: EagerLoadingKey, Key.Model == Model {
    associatedtype Model
    associatedtype Key

    func defaultEagerLoading(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model>
    var supportsDynamicEagerLoadingKeys: Bool { get }

    init()
}

extension EagerLoadProvider where Key.RawValue == String {
    func eagerLoadFor(builder: QueryBuilder<Model>,
                       includeKeys: [Self.Key]) -> QueryBuilder<Model> {

        var queryBuilder = builder
        includeKeys.forEach { queryBuilder = $0.eagerLoadFor(queryBuilder) }

        return queryBuilder
    }
}

//MARK:- StaticEagerLoading Protocol

protocol StaticEagerLoading: EagerLoadProvider { }

extension StaticEagerLoading {
    var supportsDynamicEagerLoadingKeys: Bool { return false }
}

//MARK: DynamicEagerLoading Protocol

protocol DynamicEagerLoading: EagerLoadProvider { }

extension DynamicEagerLoading {
    var supportsDynamicEagerLoadingKeys: Bool { return true }
}


//MARK:- EmptyEagerLoadKey

enum EmptyEagerLoadKey<Model: Fluent.Model>: String, EagerLoadingKey {
    case empty

    func eagerLoadFor(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        return queryBuilder
    }
}

//MARK:- EagerLoadingUnsupported

struct EagerLoadingUnsupported<Model: Fluent.Model>: StaticEagerLoading {
    typealias Key = EmptyEagerLoadKey<Model>

    func defaultEagerLoading(_ queryBuilder: QueryBuilder<Model>) -> QueryBuilder<Model> {
        return queryBuilder
    }
}
