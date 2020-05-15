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
    func with<EagerLoading: EagerLoadProvider>(_ eagerLoadProvider: EagerLoading, for req: Request) throws -> QueryBuilder<Model> where EagerLoading.Model == Model {

        guard eagerLoadProvider.supportsDynamicEagerLoadingKeys else {
            return eagerLoadProvider.defaultEagerLoading(self)
        }

        let keys = try req.query.decode(ArrayQueryRequest<EagerLoadCodingKeys>.self)
                                  .values
                                  .map { EagerLoading.Key(rawValue: $0) }
                                  .compactMap { $0 }

        return eagerLoadProvider.eagerLoadFor(builder: self, includeKeys: keys)
    }
}

//MARK:- Request decoding private extensions

fileprivate enum EagerLoadCodingKeys: String, SingleCodingKey {
    static let key: Self = .include

     case include = "include"
}

