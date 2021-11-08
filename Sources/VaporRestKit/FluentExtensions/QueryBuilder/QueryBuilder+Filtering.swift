//
//  
//  
//
//  Created by Sergey Kazakov on 10.05.2020.
//

import Vapor
import Fluent

//MARK:- QueryBuilder Extension

public extension QueryBuilder {
    func filter<Filtering: FilterProvider>(_ filtering: Filtering, for req: Request) throws -> QueryBuilder<Model> where Filtering.Model == Model {

        guard filtering.supportsDynamicFilterKeys else {
            return filtering.baseFiltering(self)
        }

        let baseFiltered = filtering.baseFiltering(self)

        let filter = try req.query.decode(FilterQueryRequest<FilteringCodingKeys, Filtering.Key>.self)
        guard let filterNode = filter.filterNode else {
            return filtering.defaultFiltering(baseFiltered)
        }

        return filterNode.filterFor(queryBuilder: baseFiltered)
    }

    func filter<Key: FilterQueryKey>(with queryKeys: Key.Type, for req: Request) throws -> QueryBuilder<Model> where Key.Model == Model {
        let filter = try req.query.decode(FilterQueryRequest<FilteringCodingKeys, Key>.self)
        guard let filterNode = filter.filterNode else {
            return Key.emptyQueryFilter(queryBuilder: self)
        }

        return filterNode.filterFor(queryBuilder: self)
    }
}

//MARK:- FilterQueryRequest

fileprivate enum FilteringCodingKeys: String, SingleCodingKey {
    static let key: Self = .filter

    case filter = "filter"
}

fileprivate struct FilterQueryRequest<RequestCodingKey: SingleCodingKey, PropertyKey: FilteringKey>: Decodable {
    let filterNode: FilterNode<PropertyKey>?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RequestCodingKey.self)
        guard let rawFilterNodesString = try container.decodeIfPresent(String.self, forKey: RequestCodingKey.key) else {
            filterNode = nil
            return
        }

        guard let data = rawFilterNodesString.data(using: String.Encoding.utf8) else {
            throw Abort(.badRequest)
        }

        let rawFilterNode = try JSONDecoder().decode(RawFilterNode<PropertyKey>.self, from: data)
        self.filterNode = try rawFilterNode.filterNode()
    }
}
