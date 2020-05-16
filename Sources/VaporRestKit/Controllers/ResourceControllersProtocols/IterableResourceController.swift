//
//  
//  
//
//  Created by Sergey Kazakov on 28.04.2020.
//

import Vapor
import Fluent

public enum IterableControllerConfig {
    case fetchAll
    case paginateWithCursor(CursorPaginationConfig)
    case paginateByPage

    public static let defaultConfig: IterableControllerConfig = .paginateWithCursor(CursorPaginationConfig.defaultConfig)
}

protocol IterableResourceController: ResourceControllerProtocol {
    associatedtype Output
    associatedtype Model
    
    func readWithCursorPagination(_: Request, paginationConfig: CursorPaginationConfig) throws -> EventLoopFuture<CursorPage<Output>>

    func readWithPagination(_: Request) throws -> EventLoopFuture<Page<Output>>

    func readAll(_: Request) throws -> EventLoopFuture<[Output]>
 
    var config: IterableControllerConfig { get }

    func prepareQueryBuilder(_ req: Request) throws -> EventLoopFuture<QueryBuilder<Model>>
}

extension IterableResourceController where Self: ResourceModelProvider {
    func readWithCursorPagination(_ req: Request, paginationConfig: CursorPaginationConfig) throws -> EventLoopFuture<CursorPage<Output>> {
        return try prepareQueryBuilder(req)
            .flatMap { $0.paginateWithCursor(for: req, config: paginationConfig) }
            .map { $0.map { Output($0, req: req) } }
    }

    func readWithPagination(_ req: Request) throws -> EventLoopFuture<Page<Output>> {
        return try prepareQueryBuilder(req)
            .flatMap { $0.paginate(for: req) }
            .map { $0.map { Output($0, req: req) } }
    }

    func readAll(_ req: Request) throws -> EventLoopFuture<[Output]> {
        return try prepareQueryBuilder(req)
            .flatMap { $0.all() }
            .map { $0.map { Output($0, req: req) } }
    }
}

extension IterableResourceController where Self: ResourceModelProvider {
    func prepareQueryBuilder(_ req: Request) throws -> EventLoopFuture<QueryBuilder<Model>> {
        let queryBuilder = try Model.query(on: req.db)
            .with(self.eagerLoadHandler, for: req)
            .sort(self.sortingHandler, for: req)
            .filter(self.filteringHandler, for: req)

        return req.eventLoop.makeSucceededFuture(queryBuilder)
    }
}

extension IterableResourceController where Self: ChildrenResourceModelProvider {
    func prepareQueryBuilder(_ req: Request) throws -> EventLoopFuture<QueryBuilder<Model>> {
        return try findRelated(req).map { $0.query(keyPath: self.childrenKeyPath, on: req.db) }
            .flatMapThrowing { try $0.with(self.eagerLoadHandler, for: req) }
            .flatMapThrowing { try $0.sort(self.sortingHandler, for: req) }
            .flatMapThrowing { try $0.filter(self.filteringHandler, for: req) }
    }
}

extension IterableResourceController where Self: ParentResourceModelProvider {
    func prepareQueryBuilder(_ req: Request) throws -> EventLoopFuture<QueryBuilder<Model>> {
        return try findRelated(req)
            .map { $0.query(keyPath: self.inversedChildrenKeyPath, on: req.db) }
            .flatMapThrowing { try $0.with(self.eagerLoadHandler, for: req) }
            .flatMapThrowing { try $0.sort(self.sortingHandler, for: req) }
            .flatMapThrowing { try $0.filter(self.filteringHandler, for: req) }
    }
}

extension IterableResourceController where Self: SiblingsResourceModelProvider {
    func prepareQueryBuilder(_ req: Request) throws -> EventLoopFuture<QueryBuilder<Model>> {
        return try findRelated(req)
            .map { $0.queryRelated(keyPath: self.siblingKeyPath, on: req.db) }
            .flatMapThrowing { try $0.with(self.eagerLoadHandler, for: req) }
            .flatMapThrowing { try $0.sort(self.sortingHandler, for: req) }
            .flatMapThrowing { try $0.filter(self.filteringHandler, for: req) }
    }
}
