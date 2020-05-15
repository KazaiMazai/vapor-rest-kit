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
    func filter<Filtering: FilterProvider>(_ filterProvider: Filtering, for req: Request) throws -> QueryBuilder<Model> where Filtering.Model == Model {

        let baseFiltered = filterProvider.defaultFiltering(self)

        guard filterProvider.supportsDynamicFilterKeys else {
            return baseFiltered
        }

        let filter = try req.query.decode(FilterQueryRequest<FilteringCodingKeys, Filtering.Key>.self)
        guard let filterNode = filter.filterNode else {
            return baseFiltered
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
