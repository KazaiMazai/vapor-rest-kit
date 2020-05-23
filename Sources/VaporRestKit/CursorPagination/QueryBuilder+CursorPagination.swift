//
//  
//  
//
//  Created by Sergey Kazakov on 06.05.2020.
//

import Vapor
import Fluent

//MARK:- QueryBuilder Pagination Extension

extension QueryBuilder {
    func paginateWithCursor(for request: Request,
                            config: CursorPaginationConfig = .defaultConfig) -> EventLoopFuture<CursorPage<Model>> {

        do {
            let page = try request.query.decode(CursorPageRequest.self)
            return try self.paginateWithCursor(page.cursorType(with: config))
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
}

//MARK:- QueryBuilder private extensions

extension QueryBuilder  {
    fileprivate func paginateWithCursor(_ cursorType: CursorType) throws -> EventLoopFuture<CursorPage<Model>> {
        switch cursorType {
        case .initial(limit: let limit):
            return try paginateWithInitCursor(limit)
        case .next(cursor: let cursor, limit: let limit):
            return try paginateWithCursor(cursor, limit: limit)
        }
    }

    fileprivate func paginateWithInitCursor(_ limit: Int) throws -> EventLoopFuture<CursorPage<Model>> {
        let filterBuilder = try CursorFilterBuilder(sorts: self.query.sorts)
        let items = self.copy().limit(limit).all()

        return items.flatMapThrowing { models in
            let next = try PaginationCursor(models.last, cursorFilters: filterBuilder.filterDescriptors)?.cursorString
            let metadata = CursorPageMetadata(nextCursor: next)
            return CursorPage(items: models,
                              metadata: metadata)
        }
    }

    fileprivate func paginateWithCursor(_ cursor: String, limit: Int) throws -> EventLoopFuture<CursorPage<Model>> {
        let requestCursor = try PaginationCursor(cursor)
        let filterBuilder = try CursorFilterBuilder(sorts: self.query.sorts)
        let queryBulder = try filterBuilder.filter(self.copy(), with: requestCursor.values)

        let items = queryBulder.limit(limit).all()

        return items.flatMapThrowing { models in
            let nextCursor = try PaginationCursor(models.last, cursorFilters: filterBuilder.filterDescriptors)
            let metadata = CursorPageMetadata(nextCursor: nextCursor?.cursorString)
            return CursorPage(items: models,
                              metadata: metadata)
        }
    }
}


//MARK:- CursorPage

struct CursorPage<T>: Codable where T: Codable {
    let items: [T]

    let metadata: CursorPageMetadata

    init(items: [T], metadata: CursorPageMetadata) {
        self.items = items
        self.metadata = metadata
    }

    func map<U>(_ transform: (T) throws -> (U)) rethrows -> CursorPage<U> where U: Codable {
        try .init(
            items: self.items.map(transform),
            metadata: self.metadata
        )
    }
}

extension CursorPage: Content { }

//MARK:- CursorPageMetadata

struct CursorPageMetadata: Codable {
    let nextCursor: String?
}

//MARK:- CursorRequestType

enum CursorType {
    case initial(limit: Int)
    case next(cursor: String, limit: Int)
}

//MARK:- CursorPaginationConfig

public struct CursorPaginationConfig {
    static let defaultConfig = CursorPaginationConfig(limitMax: 25, defaultLimit: 10)

    let limitMax: Int
    let defaultLimit: Int
}

//MARK:- CursorPageRequest

struct CursorPageRequest: Codable {
    let cursor: String?
    let limit: Int?

    func cursorType(with config: CursorPaginationConfig) -> CursorType {
        let rawLimit = limit ?? config.defaultLimit
        let checkedLimit = min(rawLimit, config.limitMax)

        guard let cursor = cursor else {
            return .initial(limit: checkedLimit)
        }

        return .next(cursor: cursor, limit: checkedLimit)
    }

}
