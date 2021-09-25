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
    @available(*, deprecated, message: "use Filtering<Key> instead")
    func filter<Filtering: FilterProvider>(_ filterProvider: Filtering, for req: Request) throws -> QueryBuilder<Model> where Filtering.Model == Model {

        try filter(filterProvider.filtering, for: req)
    }

    func filter<Key: FilteringKey>(_ filtering: Filtering<Key>, for req: Request) throws -> QueryBuilder<Model> where Key.Model == Model {

        guard filtering.useQueryFilterKeys else {
            return filtering.base(self)
        }

        let baseFiltered = filtering.base(self)

        let filter = try req.query.decode(FilterQueryRequest<FilteringCodingKeys, Key>.self)
        guard let filterNode = filter.filterNode else {
            return filtering.emptyQueryKeys(baseFiltered)
        }

        return filterNode.filterFor(queryBuilder: baseFiltered)
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
