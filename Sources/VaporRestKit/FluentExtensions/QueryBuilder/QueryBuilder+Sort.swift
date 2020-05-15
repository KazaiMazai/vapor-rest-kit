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
    func sort<Sorting: SortProvider>(_ sortProvider: Sorting, for req: Request) throws -> QueryBuilder<Model> where Sorting.Model == Model {

        guard sortProvider.supportsDynamicSortKeys else {
            let defaultSorted = sortProvider.defaultSorting(self)
            return sortProvider.uniqueKeySorting(defaultSorted)
        }

        let keys = try req.query.decode(ArrayQueryRequest<SortingCodingKeys>.self)
                                .values
                                .map { SortDescriptor(fromString: $0, sortKeyType: Sorting.Key.self) }
                                .compactMap { $0 }

        let sortedQueryBuilder = keys.isEmpty ?
                                sortProvider.defaultSorting(self):
                                sortProvider.sortFor(builder: self, sortDescriptors: keys)

        return sortProvider.uniqueKeySorting(sortedQueryBuilder)
    }
}

//MARK:- SortDescriptor

struct SortDescriptor<Key> where Key: SortingKey {
    static var separator: Character { return ":" }

    let key: Key
    let direction: DatabaseQuery.Sort.Direction

    func updateBuilder(_ queryBuilder: QueryBuilder<Key.Model>) -> QueryBuilder<Key.Model> {
        return key.sortFor(queryBuilder, direction: direction)
    }

    init?(fromString: String, sortKeyType: Key.Type) {
        let splitedSourceString = fromString.split(separator: Self.separator)
                                            .map { String($0) }

        let rawKey = splitedSourceString.first ?? ""
        let rawDirection = SortDirection(rawValue: splitedSourceString.last ?? "") ?? .ascending

        guard let sortKey = Key(rawValue: rawKey) else {
            return nil
        }

        self.key = sortKey
        self.direction = rawDirection.queryDirection
    }
}


//MARK:- SortDirection

fileprivate enum SortDirection: String {
    case ascending = "asc"
    case descending = "desc"

    var queryDirection: DatabaseQuery.Sort.Direction {
        switch self {
        case .ascending:
            return .ascending
        case .descending:
            return .descending
        }
    }
}

fileprivate enum SortingCodingKeys: String, SingleCodingKey {
    static let key: Self = .sort

    case sort = "sort"
}

