//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

protocol DeletableRelationController: ItemResourceControllerProtocol {
    func delete(_ req: Request) throws -> EventLoopFuture<Output>
}

extension DeletableRelationController where Self: ChildrenResourceRelationProviding {

    func delete(_ req: Request) throws -> EventLoopFuture<Output> {
        return try self.findWithRelated(req)
                       .flatMapThrowing { try $0.resource.detached(from: $0.relatedResource, with: self.childrenKeyPath) }
                       .flatMap { resource in return resource.save(on: req.db)
                                                             .transform(to: Output(resource)) }
    }
}

extension DeletableRelationController where Self: ParentResourceRelationProviding {
      func delete(_ req: Request) throws -> EventLoopFuture<Output> {
        return try self.findWithRelated(req)
                       .flatMapThrowing {
                            try $0.resource.detached(from: $0.relatedResource, with: self.inversedChildrenKeyPath)
                            let resource = $0.resource
                            return $0.relatedResource.save(on: req.db)
                                                     .transform(to: resource)}
                       .flatMap { $0 }
                       .map { Output($0) }

    }
}

extension DeletableRelationController where Self: SiblingsResourceRelationProviding {
    func delete(_ req: Request) throws -> EventLoopFuture<Output> {
        return try findWithRelated(req)
                    .flatMap { $0.resource.detached(from: $0.relatedResoure, with: self.siblingKeyPath, on: req.db) }
                    .map { Output($0)}
    }
}
