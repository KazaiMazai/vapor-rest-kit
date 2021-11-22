//
//  
//  
//
//  Created by Sergey Kazakov on 10.05.2020.
//

import Vapor
import Fluent

//MARK:- QueryBuilder Extension

extension QueryBuilder {
    func eagerLoadFor<Key: EagerLoadingKey>(keys: [Key]) -> QueryBuilder<Model> where Key.Model == Model {

        var queryBuilder = self
        keys.forEach { queryBuilder = $0.eagerLoadFor(queryBuilder) }

        return queryBuilder
    }
}

public extension QueryBuilder {
    func with<EagerLoading: EagerLoadProvider>(_ eagerLoadProvider: EagerLoading, for req: Request) throws -> QueryBuilder<Model> where EagerLoading.Model == Model {

        guard eagerLoadProvider.supportsDynamicEagerLoadingKeys else {
            return eagerLoadProvider.baseEagerLoading(self)
        }

        let baseEagerLoaded = eagerLoadProvider.baseEagerLoading(self)

        let keys = try req.query.decode(ArrayQueryRequest<EagerLoadCodingKeys>.self)
                                  .values
                                  .map { EagerLoading.Key(rawValue: $0) }
                                  .compactMap { $0 }

        guard keys.count > 0 else {
            return eagerLoadProvider.defaultEagerLoading(baseEagerLoaded)
        }

        return baseEagerLoaded.eagerLoadFor(keys: keys)
    }

    func with<Key: EagerLoadingQueryKey>(keys: Key.Type, for req: Request) throws -> QueryBuilder<Model>
    where Key.Model == Model {

        let keys = try req.query.decode(ArrayQueryRequest<EagerLoadCodingKeys>.self)
                                  .values
                                  .map { Key(rawValue: $0) }
                                  .compactMap { $0 }

        guard !keys.isEmpty else {
            return Key.eagerLoadEmptyQueryFor(self)
        }

        return self.eagerLoadFor(keys: keys)
    }
}

//MARK:- Request decoding private extensions

fileprivate enum EagerLoadCodingKeys: String, SingleCodingKey {
    static let key: Self = .include

     case include = "include"
}

