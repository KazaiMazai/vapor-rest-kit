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
            return try self.pageWithCursor(page.cursorType(with: config),
                                           decoder: config.coder,
                                           encoder: config.coder)
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
}

//MARK:- QueryBuilder private extensions

extension QueryBuilder  {
    fileprivate func pageWithCursor(_ cursorType: CursorType,
                                    decoder: PaginationCursorDecoder,
                                    encoder: PaginationCursorEncoder) throws -> EventLoopFuture<CursorPage<Model>> {
        switch cursorType {
        case .initial(limit: let limit):
            return try initialPage(limit, encoder: encoder)
        case .after(cursor: let cursor, limit: let limit):
            return try pageAfterCursor(cursor, limit: limit, decoder: decoder, encoder: encoder)
        case .before(cursor: let cursor, limit: let limit):
            return try pageBeforeCursor(cursor, limit: limit, decoder: decoder, encoder: encoder)
        }
    }

    fileprivate func initialPage(_ limit: Int, encoder: PaginationCursorEncoder) throws -> EventLoopFuture<CursorPage<Model>> {
        let nextCursorFilterBuilder = try CursorFilterBuilder(sorts: query.sorts)
        let prevCursorfilterBuilder = try CursorFilterBuilder(sorts: query.sorts.map { sort in sort.flipped() })

        let items = self.copy().limit(limit).all()

        return items.flatMapThrowing { models in
            let next = try models.last.map { try encoder.encode($0, cursorFilters: nextCursorFilterBuilder.filterDescriptors) }
            let prev = try models.first.map { try encoder.encode($0, cursorFilters: prevCursorfilterBuilder.filterDescriptors) }
            let metadata = CursorPageMetadata(nextCursor: next, prevCursor: prev)
            return CursorPage(items: models,
                              metadata: metadata)
        }
    }

    fileprivate func pageAfterCursor(_ cursor: String,
                                     limit: Int,
                                     decoder: PaginationCursorDecoder,
                                     encoder: PaginationCursorEncoder) throws -> EventLoopFuture<CursorPage<Model>> {
        let requestCursorValues = try decoder.decode(cursor: cursor)
        let nextCursorFilterBuilder = try CursorFilterBuilder(sorts: query.sorts)
        let prevCursorfilterBuilder = try CursorFilterBuilder(sorts: query.sorts.map { sort in sort.flipped() })
        let queryBulder = try nextCursorFilterBuilder.filter(copy(), with: requestCursorValues)

        let items = queryBulder.limit(limit).all()

        return items.flatMapThrowing { models in
            let next = try models.last.map { try encoder.encode($0, cursorFilters: nextCursorFilterBuilder.filterDescriptors) }
            let prev = try models.first.map { try encoder.encode($0, cursorFilters: prevCursorfilterBuilder.filterDescriptors) }
            let metadata = CursorPageMetadata(nextCursor: next, prevCursor: prev)
            return CursorPage(items: models,
                              metadata: metadata)
        }
    }

    fileprivate func pageBeforeCursor(_ cursor: String,
                                      limit: Int,
                                      decoder: PaginationCursorDecoder,
                                      encoder: PaginationCursorEncoder) throws -> EventLoopFuture<CursorPage<Model>> {
        let requestCursorValues = try decoder.decode(cursor: cursor)
        let nextCursorFilterBuilder = try CursorFilterBuilder(sorts: query.sorts)
        let prevCursorfilterBuilder = try CursorFilterBuilder(sorts: query.sorts.map { sort in sort.flipped() })
        let queryBulder = try prevCursorfilterBuilder.filter(copy(), with: requestCursorValues)

        let items = queryBulder.limit(limit).all()

        return items.flatMapThrowing { models in
            let next = try models.last.map { try encoder.encode($0, cursorFilters: nextCursorFilterBuilder.filterDescriptors) }
            let prev = try models.first.map { try encoder.encode($0, cursorFilters: prevCursorfilterBuilder.filterDescriptors) }
            let metadata = CursorPageMetadata(nextCursor: next, prevCursor: prev)
            return CursorPage(items: models,
                              metadata: metadata)
        }
    }
}


//MARK:- CursorPage

public struct CursorPage<T>: Codable where T: Codable {
    public let items: [T]

    public let metadata: CursorPageMetadata

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

public struct CursorPageMetadata: Codable {
    public let nextCursor: String?
    public let prevCursor: String?
}

//MARK:- CursorRequestType

enum CursorType {
    case initial(limit: Int)
    case after(cursor: String, limit: Int)
    case before(cursor: String, limit: Int)
}

//MARK:- CursorPaginationConfig

public struct CursorPaginationConfig {


    let limitMax: Int
    let defaultLimit: Int
    let coder: PaginationCursorDecoder & PaginationCursorEncoder

    static let encoder: JSONEncoder = {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .secondsSince1970
        return jsonEncoder
    }()

    static let decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        return jsonDecoder
    }()
    
    public static let defaultConfig = CursorPaginationConfig(
        limitMax: 25,
        defaultLimit: 10,
        coder: PaginationCursorCoder(encoder: Self.encoder,
                                     decoder: Self.decoder))

    public init(limitMax: Int, defaultLimit: Int) {
        self.limitMax = limitMax
        self.defaultLimit = defaultLimit
        self.coder = PaginationCursorCoder(encoder: Self.encoder,
                                           decoder: Self.decoder)
    }

    init(limitMax: Int,
         defaultLimit: Int,
         coder: PaginationCursorDecoder & PaginationCursorEncoder) {

        self.limitMax = limitMax
        self.defaultLimit = defaultLimit
        self.coder = coder
    }
}

//MARK:- CursorPageRequest

struct CursorPageRequest: Codable {
    let cursor: String?
    let limit: Int?
    let after: String?
    let before: String?

    func cursorType(with config: CursorPaginationConfig) -> CursorType {
        let rawLimit = limit ?? config.defaultLimit
        let checkedLimit = min(rawLimit, config.limitMax)

        if let cursor = cursor {
            return .after(cursor: cursor, limit: checkedLimit)
        }

        if let cursor = after {
            return .after(cursor: cursor, limit: checkedLimit)
        }

        if let cursor = before {
            return .before(cursor: cursor, limit: checkedLimit)
        }

        return .initial(limit: checkedLimit)
    }

}
