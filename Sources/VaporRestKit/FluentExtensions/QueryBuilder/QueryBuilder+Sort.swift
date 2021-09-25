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
    func sort<Key>(with sortDescriptors: [SortDescriptor<Key>]) -> QueryBuilder<Key.Model> where Key.Model == Model {
        var queryBuilder = self
        sortDescriptors.forEach { queryBuilder =  $0.key.sortFor(queryBuilder, direction: $0.direction) }

        return queryBuilder
    }
}

public extension QueryBuilder {
    @available(*, deprecated, message: "Use Sorting<Key> instead")
    func sort<Sorting: SortProvider>(_ sortProvider: Sorting, for req: Request) throws -> QueryBuilder<Model> where Sorting.Model == Model {
        try sort(sortProvider.sorting, for: req)
    }

    func sort<Key>(_ sorting: Sorting<Key>, for req: Request) throws -> QueryBuilder<Model> where Key.Model == Model {
        guard sorting.supportsDynamicSortKeys else {
            let defaultSorted = sorting.defaultSorting(self)
            return sorting.uniqueKeySorting(defaultSorted)
        }

        let sortDescriptors = try req.query.decode(ArrayQueryRequest<SortingCodingKeys>.self)
                                .values
                                .map { SortDescriptor(fromString: $0, sortKeyType: Key.self) }
                                .compactMap { $0 }

        let sortedQueryBuilder = sortDescriptors.isEmpty ?
                                sorting.defaultSorting(self):
                                self.sort(with: sortDescriptors)

        return sorting.uniqueKeySorting(sortedQueryBuilder)
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

