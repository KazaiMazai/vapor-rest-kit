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
            let coder = config.coder
            let cursorType = page.cursorType(with: config)
            let includePrevCursor = config.allowBackwardPagination

            switch cursorType {
            case .initial(limit: let limit):
                return try initialPage(limit, inlcudePrevCursor: includePrevCursor, encoder: coder)
            case .after(cursor: let cursor, limit: let limit):
                return try pageAfterCursor(cursor, limit: limit, inlcudePrevCursor: includePrevCursor, coder: coder)
            case .before(cursor: let cursor, limit: let limit):
                return try pageBeforeCursor(cursor, limit: limit, inlcudePrevCursor: includePrevCursor, coder: coder)
            }
        } catch {
            return request.eventLoop.makeFailedFuture(error)
        }
    }
}

//MARK:- QueryBuilder private extensions


extension QueryBuilder  {

    fileprivate func initialPage(_ limit: Int,
                                 inlcudePrevCursor: Bool,
                                 encoder: PaginationCursorEncoder) throws -> EventLoopFuture<CursorPage<Model>> {
        let cursorFilter = try CursorFilter(sorts: query.sorts)
        let filterDescriptors = cursorFilter.filterDescriptors
        let items = self.copy().limit(limit).all()

        return items.flatMapThrowing { models in
            let next = try models.last.map { try encoder.encode($0, filterDescriptors: filterDescriptors) }
            let prev = try models.first.map { try encoder.encode($0, filterDescriptors: filterDescriptors) }
            let metadata = CursorPageMetadata(nextCursor: next,
                                              prevCursor: inlcudePrevCursor ? prev: nil)
            return CursorPage(items: models,
                              metadata: metadata)
        }
    }

    fileprivate func pageAfterCursor(_ cursor: String,
                                     limit: Int,
                                     inlcudePrevCursor: Bool,
                                     coder: PaginationCursorDecoder & PaginationCursorEncoder) throws -> EventLoopFuture<CursorPage<Model>> {
        let cursorValues = try coder.decode(cursor: cursor)
        let querybuilder = copy()
        let cursorFilter = try CursorFilter(sorts: querybuilder.query.sorts)
        let filterDescriptors = cursorFilter.filterDescriptors
        return try querybuilder
            .filter(cursorFilter, with: cursorValues)
            .limit(limit)
            .all()
            .flatMapThrowing { models in

                let next = try models.last.map { try coder.encode($0, filterDescriptors: filterDescriptors) }
                let prev = try models.first.map { try coder.encode($0, filterDescriptors: filterDescriptors) }
                let metadata = CursorPageMetadata(nextCursor: next,
                                                  prevCursor: inlcudePrevCursor ? prev: nil)
                return CursorPage(items: models,
                                  metadata: metadata)
            }
    }

    fileprivate func pageBeforeCursor(_ cursor: String,
                                      limit: Int,
                                      inlcudePrevCursor: Bool,
                                      coder: PaginationCursorDecoder & PaginationCursorEncoder) throws -> EventLoopFuture<CursorPage<Model>> {
        let cursorValues = try coder.decode(cursor: cursor)
        let querybuilder = copy()
        querybuilder.query.sorts = query.sorts.map { sort in sort.reversed() }
        let cursorFilter = try CursorFilter(sorts: querybuilder.query.sorts)
        let filterDescriptors = cursorFilter.filterDescriptors

        return try querybuilder
            .filter(cursorFilter, with: cursorValues)
            .limit(limit)
            .all()
            .flatMapThrowing { reveresedModels in

                let models = Array(reveresedModels.reversed())
                let next = try models.last.map { try coder.encode($0, filterDescriptors: filterDescriptors) }
                let prev = try models.first.map { try coder.encode($0, filterDescriptors: filterDescriptors) }
                let metadata = CursorPageMetadata(nextCursor: next,
                                                  prevCursor: inlcudePrevCursor ? prev: nil)
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

    let allowBackwardPagination: Bool
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
        allowBackwardPagination: false,
        coder: PaginationCursorCoder(encoder: Self.encoder,
                                     decoder: Self.decoder))

    public init(limitMax: Int = 25, defaultLimit: Int = 10, allowBackwardPagination: Bool = false) {
        self.limitMax = limitMax
        self.defaultLimit = defaultLimit
        self.allowBackwardPagination = allowBackwardPagination
        self.coder = PaginationCursorCoder(encoder: Self.encoder,
                                           decoder: Self.decoder)
    }

    init(limitMax: Int,
         defaultLimit: Int,
         allowBackwardPagination: Bool,
         coder: PaginationCursorDecoder & PaginationCursorEncoder) {

        self.limitMax = limitMax
        self.defaultLimit = defaultLimit
        self.allowBackwardPagination = allowBackwardPagination
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

        guard config.allowBackwardPagination else {
            return .initial(limit: checkedLimit)
        }

        if let cursor = before {
            return .before(cursor: cursor, limit: checkedLimit)
        }

        return .initial(limit: checkedLimit)
    }
}
